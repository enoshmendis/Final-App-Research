//packages
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:mlvapp/theme.dart';
import 'package:provider/provider.dart';
import 'package:get_it/get_it.dart';

//providers
import '../provider/authentication_provider.dart';
import '../provider/chats_page_provider.dart';

//widgets
// import '../widgets/top_bar.dart';
import '../shared/custom_list_view_tiles.dart';

//Models
import '../Models/chat.dart';
import '../Models/app_user.dart';
import '../Models/chat_message.dart';

//Services
import '../services/navigation_service.dart';

//Pages
import '../Member2/chat_page.dart';

class ChatsPage extends StatefulWidget {
  ChatsPage({Key? key}) : super(key: key);

  @override
  _ChatsPageState createState() => _ChatsPageState();
}

class _ChatsPageState extends State<ChatsPage> {
  late double _deviceHeight;
  late double _deviceWidth;

  late AuthenticationProvider _auth;
  late ChatsPageProvider _pageProvider;

  late NavigationService _navigation;

  @override
  Widget build(BuildContext context) {
    _deviceHeight = MediaQuery.of(context).size.height;
    _deviceWidth = MediaQuery.of(context).size.width;

    _auth = Provider.of<AuthenticationProvider>(context);
    _navigation = GetIt.instance.get<NavigationService>();

    return MultiProvider(
      providers: [
        ChangeNotifierProvider<ChatsPageProvider>(
          create: (_) => ChatsPageProvider(_auth),
        ),
      ],
      child: _buildUI(),
    );
  }

  Widget _buildUI() {
    return Builder(builder: (BuildContext _context) {
      _pageProvider = _context.watch<ChatsPageProvider>();

      return Scaffold(
        appBar: AppBar(
          foregroundColor: Colors.green,
          backgroundColor: Colors.white,
          title: const Text(
            'Chats',
          ),
        ),
        body: Container(
          height: _deviceHeight,
          width: _deviceWidth,
          child: Column(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              // TopBar(
              //   "Chats",
              //   primaryAction: IconButton(
              //     icon: const Icon(
              //       Icons.logout,
              //       color: primaryColor,
              //     ),
              //     onPressed: () {
              //       _auth.logout();
              //     },
              //   ),
              // ),
              _chatsList(),
            ],
          ),
        ),
      );
    });
  }

  Widget _chatsList() {
    List<Chat>? _chats = _pageProvider.chats;

    return Expanded(
      child: (() {
        if (_chats != null) {
          if (_chats.length != 0) {
            return ListView.builder(
                padding: EdgeInsets.only(top: 10, bottom: _deviceHeight * 0.1),
                itemCount: _chats.length,
                itemBuilder: (BuildContext _context, int _index) {
                  return _chatTile(_chats[_index]);
                });
          } else {
            return const Center(
              child: Text(
                "No Chats Available.",
                style: TextStyle(
                  color: primaryColor,
                ),
              ),
            );
          }
        } else {
          return const Center(
            child: SpinKitThreeBounce(
              color: primaryColor,
            ),
          );
        }
      })(),
    );
  }

  Widget _chatTile(Chat _chat) {
    List<AppUser> _recepients = _chat.recepients();
    bool _isActive = _recepients.any((_d) => _d.wasRecentlyActive());
    String _subTitle = "";

    if (_chat.messages.isNotEmpty) {
      _subTitle = _chat.messages.first.type != MessageType.TEXT ? "Media Attachment" : _chat.messages.first.content;
    }

    return CustomListViewTileWithActivity(
      height: _deviceHeight * 0.1,
      title: _chat.title(),
      subtitle: _subTitle,
      imagePath: "assets/images/defaultProfile.png",
      isActive: _isActive,
      isActivity: _chat.activity,
      onTap: () {
        _navigation.navigateToPage(ChatPage(chat: _chat));
      },
    );
  }
}
