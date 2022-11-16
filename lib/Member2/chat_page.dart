import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:mlvapp/Member4/test_reports_page.dart';
import 'package:mlvapp/shared/rounded_button.dart';
import 'package:mlvapp/theme.dart';
import 'package:mlvapp/utility/utils.dart';
import 'package:provider/provider.dart';

//Widgets

import '../shared/custom_list_view_tiles.dart';
import '../shared/custom_input_fields.dart';

//Models
import '../Models/chat.dart';
import '../Models/chat_message.dart';

//Providers
import '../provider/chats_page_provider.dart';
import '../provider/authentication_provider.dart';
import '../provider/chat_page_provider.dart';

//Services
import '../services/navigation_service.dart';

class ChatPage extends StatefulWidget {
  final Chat chat;

  ChatPage({required this.chat});

  @override
  _ChatPageState createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  late double _deviceHeight;
  late double _deviceWidth;
  late double _statusBarHeight;

  late AuthenticationProvider _auth;
  late ChatPageProvider _pageProvider;

  late NavigationService _navigation;

  late GlobalKey<FormState> _messageFormState;
  late ScrollController _messageListViewController;

  @override
  void initState() {
    super.initState();
    _messageFormState = GlobalKey<FormState>();
    _messageListViewController = ScrollController();
  }

  @override
  Widget build(BuildContext context) {
    _deviceHeight = MediaQuery.of(context).size.height;
    _deviceWidth = MediaQuery.of(context).size.width;
    _statusBarHeight = MediaQuery.of(context).viewPadding.top;

    _auth = Provider.of<AuthenticationProvider>(context);
    _navigation = GetIt.instance.get<NavigationService>();

    return MultiProvider(
      providers: [
        ChangeNotifierProvider<ChatPageProvider>(
          create: (_) => ChatPageProvider(widget.chat.uid, _auth, _messageListViewController),
        ),
      ],
      child: _buildUI(),
    );
  }

  Widget _buildUI() {
    return Builder(builder: (BuildContext _context) {
      _pageProvider = _context.watch<ChatPageProvider>();
      return Scaffold(
        appBar: AppBar(
          foregroundColor: Colors.green,
          backgroundColor: Colors.white,
          title: Text(
            _auth.user.usertype == "Doctor"
                ? widget.chat.title()
                : widget.chat.title().contains("Dr")
                    ? widget.chat.title()
                    : "Dr. ${widget.chat.title()}",
          ),
          actions: [
            _auth.user.usertype == "Doctor"
                ? TextButton(
                    onPressed: () {
                      _navigation.navigateToPage(TestReportsPage(uid: widget.chat.members[1].uid));
                    },
                    child: const Text("Reports"))
                : Container()
          ],
        ),
        body: Stack(
          children: [
            SingleChildScrollView(
              child: Container(
                height: _deviceHeight * 0.9,
                width: _deviceWidth,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisSize: MainAxisSize.max,
                  children: [_messagesListView(), Container(color: background, child: _sendMessageForm())],
                ),
              ),
            ),
            // Positioned(bottom: 0, child: Container(color: Colors.white, child: _sendMessageForm())),
          ],
        ),
      );
    });
  }

  Widget _messagesListView() {
    if (_pageProvider.messages != null) {
      if (_pageProvider.messages!.isNotEmpty) {
        return Container(
          // padding: EdgeInsets.symmetric(
          //   horizontal: _deviceWidth * 0.03,
          //   vertical: _deviceHeight * 0.02,
          // ),
          height: _deviceHeight * 0.8,
          child: Scrollbar(
            child: ListView.builder(
                padding: EdgeInsets.symmetric(
                  horizontal: _deviceWidth * 0.03,
                  vertical: _deviceHeight * 0.02,
                ),
                controller: _messageListViewController,
                addAutomaticKeepAlives: true,
                shrinkWrap: true,
                itemCount: _pageProvider.messages!.length,
                itemBuilder: (BuildContext _context, int _index) {
                  ChatMessage _message = _pageProvider.messages![_index];
                  bool _isOWnMessage = _message.senderID == _auth.user.uid;

                  return Container(
                    child: CustomChatListViewTile(
                      deviceHeight: _deviceHeight,
                      width: _deviceWidth * 0.80,
                      message: _message,
                      isOwnMessage: _isOWnMessage,
                      sender: widget.chat.members.where((_m) => _m.uid == _message.senderID).first,
                    ),
                  );
                }),
          ),
        );
      } else {
        return Container(
          height: _deviceHeight * 0.8,
          child: Center(
            child: Text(
              "Be the first to say Hi!",
              style: TextStyle(color: primaryColor),
            ),
          ),
        );
      }
    } else {
      return Container(
        height: _deviceHeight * 0.8,
        child: Center(
          child: CircularProgressIndicator(
            color: primaryColor,
          ),
        ),
      );
    }
  }

  Widget _sendMessageForm() {
    return Container(
      height: _deviceHeight * 0.06,
      width: deviceWidth(context),
      margin: EdgeInsets.fromLTRB(0, 0, 0, _deviceHeight * 0.03),
      child: Row(
        mainAxisSize: MainAxisSize.max,
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Container(
            decoration: BoxDecoration(
              color: secondaryBackground,
              borderRadius: BorderRadius.circular(100),
            ),
            child: Form(
                key: _messageFormState,
                child: Row(
                  mainAxisSize: MainAxisSize.max,
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    _messageTextField(),
                    _imageMessageButton(),
                  ],
                )),
          ),
          _sendMessageButton(),
        ],
      ),
    );
  }

  Widget _messageTextField() {
    return Container(
      width: _deviceWidth * 0.71,
      child: PlainFormInputField(
        keyboardType: TextInputType.multiline,
        onSaved: (_value) {
          _pageProvider.message = _value;
        },
        validator: (_value) {
          if (_value.isEmpty) {
            return "Type a Message.";
          } else {
            return null;
          }
        },
        color: Colors.transparent,
        isBordered: false,
        hintText: "Message",
        obscureText: false,
      ),
    );
  }

  Widget _sendMessageButton() {
    double _size = _deviceHeight * 0.049;

    return Container(
        height: _size,
        width: _size,
        child: FloatingActionButton(
          backgroundColor: primaryColor,
          onPressed: () {
            if (_messageFormState.currentState!.validate()) {
              _messageFormState.currentState!.save();
              _pageProvider.sendTextMessage();
              _messageFormState.currentState!.reset();
            }
          },
          child: Icon(
            Icons.send_rounded,
            size: _size * 0.6,
          ),
        )
        // child: IconButton(
        //   icon: Icon(
        //     Icons.send_rounded,
        //     color: primaryColor,
        //     size: _size,
        //   ),
        //   onPressed: () {
        //     if (_messageFormState.currentState!.validate()) {
        //       _messageFormState.currentState!.save();
        //       _pageProvider.sendTextMessage();
        //       _messageFormState.currentState!.reset();
        //     }
        //   },
        // ),
        );
  }

  Widget _imageMessageButton() {
    double _size = _deviceHeight * 0.045;

    return Center(
        child: IconButton(
      onPressed: () {
        _pageProvider.sendImageMessage();
      },
      color: primaryColor,
      icon: Icon(
        Icons.image,
        size: _size * 0.8,
      ),
    ));
  }
}
