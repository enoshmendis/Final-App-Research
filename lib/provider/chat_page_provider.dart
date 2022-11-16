import 'dart:async';
import 'dart:io';

//Packages
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:flutter_keyboard_visibility/flutter_keyboard_visibility.dart';
import 'package:mlvapp/provider/authentication_provider.dart';

import 'package:encrypt/encrypt.dart' as Encrypt;

//Services
import '../services/cloud_storage_service.dart';
import '../services/media_service.dart';
import '../services/navigation_service.dart';
import 'package:mlvapp/services/encryption_service.dart';
import 'package:mlvapp/services/firestore_database.dart';

//Models
import '../Models/chat_message.dart';

class ChatPageProvider extends ChangeNotifier {
  late FirebaseDatabase _db;
  late CloudStorageService _cloudStorage;
  late MediaService _media;
  late NavigationService _navigation;
  late EncryptionService _encryption;
  final encrypter = Encrypt.Encrypter(Encrypt.AES(Encrypt.Key.fromLength(32)));

  AuthenticationProvider _auth;
  ScrollController _messagesListViewController;

  String _chatID;
  List<ChatMessage>? messages;

  late StreamSubscription _messagesStream;
  late StreamSubscription _keyboardVisibilityStream;
  late KeyboardVisibilityController _keyboardVisibilityController;

  bool? _loaded = false;

  String? _message;

  String get message {
    return message;
  }

  void set message(String _value) {
    _message = _value;
  }

  bool get loaded {
    return loaded;
  }

  void set loaded(bool _value) {
    _loaded = _value;
  }

  ChatPageProvider(this._chatID, this._auth, this._messagesListViewController) {
    _db = GetIt.instance.get<FirebaseDatabase>();
    _cloudStorage = GetIt.instance.get<CloudStorageService>();
    _media = GetIt.instance.get<MediaService>();
    _navigation = GetIt.instance.get<NavigationService>();

    _encryption = EncryptionService(encrypter);
    _keyboardVisibilityController = KeyboardVisibilityController();
    listenToMessages();
    listenToKeyboardChanges();
  }

  @override
  void dispose() {
    _messagesStream.cancel();
    super.dispose();
  }

  void listenToMessages() {
    try {
      _messagesStream = _db.streamMessagesForChat(_chatID).listen((_snapshot) {
        List<ChatMessage> _messages = _snapshot.docs.map(
          (_m) {
            Map<String, dynamic> _messageData = _m.data() as Map<String, dynamic>;

            _messageData["content"] = _encryption.decrypt(_messageData["content"]);

            return ChatMessage.fromJSON(_messageData);
          },
        ).toList();
        messages = _messages;
        notifyListeners();

        //Scroll To Bottom
        WidgetsBinding.instance.addPostFrameCallback((_) {
          if (_messagesListViewController.hasClients) {
            _messagesListViewController.jumpTo(_messagesListViewController.position.maxScrollExtent);
          }
        });
      });
    } catch (e) {
      print("Error Getting Messages");
      print(e);
    }
  }

  void scrollToBottom() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_messagesListViewController.hasClients) {
        _messagesListViewController.jumpTo(_messagesListViewController.position.maxScrollExtent);
      }
    });
  }

  void sendTextMessage() {
    if (_message != null) {
      String _encryptedMessage = _encryption.encrypt(_message!);
      ChatMessage _messageToSend = ChatMessage(
        content: _encryptedMessage,
        type: MessageType.TEXT,
        senderID: _auth.user.uid,
        sentTime: DateTime.now(),
        orientation: "",
      );

      _db.addMessageToChat(_chatID, _messageToSend);
    }
  }

  void sendImageMessage() async {
    try {
      PlatformFile? _file = await _media.pickImageFromLibrary();
      double _height;
      double _width;
      String _orientation = "";
      if (_file != null) {
        await _calculateImageDimension(_file).then((value) {
          _height = value.height;
          _width = value.width;

          if (_height > _width) {
            _orientation = "portrait";
          } else if (_height < _width) {
            _orientation = "landscape";
          } else {
            _orientation = "square";
          }
        });
      }

      if (_file != null) {
        String? _downloadURL = await _cloudStorage.saveChatImageToStorage(_chatID, _auth.user.uid, _file);

        String _encryptedUrl = _encryption.encrypt(_downloadURL!);

        ChatMessage _messageToSend = ChatMessage(
          content: _encryptedUrl,
          type: MessageType.IMAGE,
          senderID: _auth.user.uid,
          sentTime: DateTime.now(),
          orientation: _orientation,
        );

        _db.addMessageToChat(_chatID, _messageToSend);
      }
    } catch (e) {
      print("Error Sending Image.");
      print(e);
    }
  }

  void deleteChat() {
    goBack();
    _db.deleteChat(_chatID);
  }

  void goBack() {
    _navigation.goBack();
  }

  Future<Size> _calculateImageDimension(PlatformFile file) {
    File _imageFile = File(file.path!);
    Completer<Size> completer = Completer();
    Image image = Image.file(_imageFile);
    image.image.resolve(ImageConfiguration()).addListener(
      ImageStreamListener(
        (ImageInfo image, bool synchronousCall) {
          var myImage = image.image;
          Size size = Size(myImage.width.toDouble(), myImage.height.toDouble());
          completer.complete(size);
        },
      ),
    );
    return completer.future;
  }

  void listenToKeyboardChanges() {
    _keyboardVisibilityStream = _keyboardVisibilityController.onChange.listen((_event) {
      _db.updateChatData(_chatID, {"is_activity": _event});
    });
  }
}
