import 'dart:async';

//packages
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:encrypt/encrypt.dart' as Encrypt;
import 'package:mlvapp/provider/authentication_provider.dart';
import 'package:mlvapp/services/encryption_service.dart';
import 'package:mlvapp/services/firestore_database.dart';

//Services
import '../services/database_service.dart';



//Models
import '../Models/chat.dart';
import '../Models/chat_message.dart';
import '../Models/app_user.dart';

class ChatsPageProvider extends ChangeNotifier {
  AuthenticationProvider _auth;

  late FirebaseDatabase _db;
  late EncryptionService _encryption;
  final encrypter = Encrypt.Encrypter(Encrypt.AES(Encrypt.Key.fromLength(32)));

  List<Chat>? chats;

  late StreamSubscription _chatsStream;

  ChatsPageProvider(this._auth) {
    _db = GetIt.instance.get<FirebaseDatabase>();
    _encryption = EncryptionService(encrypter);
    getChats();
  }

  @override
  void dispose() {
    _chatsStream.cancel();
    super.dispose();
  }

  void getChats() async {
    try {
      _chatsStream =
          _db.getChatsForUser(_auth.user.uid).listen((_snapshot) async {
        chats = await Future.wait(
          _snapshot.docs.map((_d) async {
            Map<String, dynamic> _chatData = _d.data() as Map<String, dynamic>;

            //Get Users in the chat
            List<AppUser> _members = [];
            for (var _uid in _chatData["members"]) {
              DocumentSnapshot _userSnapshot = await _db.getUser(_uid);
              Map<String, dynamic> _userData =
                  _userSnapshot.data() as Map<String, dynamic>;

              _userData["uid"] = _userSnapshot.id;

              _members.add(AppUser.fromJSON(_userData));
            }

            //Get Last Message for Chat
            List<ChatMessage> _messages = [];
            QuerySnapshot _chatMessage = await _db.getLastMessageForChat(_d.id);
            if (_chatMessage.docs.isNotEmpty) {
              Map<String, dynamic> _messageData =
                  _chatMessage.docs.first.data()! as Map<String, dynamic>;

              _messageData["content"] =
                  _encryption.decrypt(_messageData["content"]);

              ChatMessage _message = ChatMessage.fromJSON(_messageData);
              _messages.add(_message);
            }

            //Return Chat Instance
            return Chat(
              uid: _d.id,
              currentUserUid: _auth.user.uid,
              members: _members,
              messages: _messages,
              activity: _chatData["is_activity"],
              group: _chatData["is_group"],
            );
          }).toList(),
        );
        notifyListeners();
      });
    } catch (e) {
      print("Error getting chats.");
      print(e);
    }
  }
}
