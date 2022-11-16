import '../Models/app_user.dart';
import '../Models/chat_message.dart';

class Chat {
  final String uid;
  final String currentUserUid;
  final bool activity;
  final bool group;
  final List<AppUser> members;
  List<ChatMessage> messages;

  late final List<AppUser> _recepients;

  Chat(
      {required this.uid,
      required this.currentUserUid,
      required this.members,
      required this.messages,
      required this.activity,
      required this.group}) {
    _recepients = members.where((_i) => _i.uid != currentUserUid).toList();
  }

  List<AppUser> recepients() {
    return _recepients;
  }

  String title() {
    return !group
        ? _recepients.first.name
        : _recepients.map((_user) => _user.name).join(", ");
  }

  // String imageURL() {
  //   if (group) {
  //     return "https://firebasestorage.googleapis.com/v0/b/xinli-app.appspot.com/o/images%2Fdefault%2Fgroup_chat.png?alt=media&token=5331823d-460f-4135-baf6-264291c8cf4c";
  //   } else if (_recepients.first.imageURL == "") {
  //     return "https://firebasestorage.googleapis.com/v0/b/xinli-app.appspot.com/o/images%2Fdefault%2FdefaultProfile.png?alt=media&token=e8e5599d-c92f-4bb6-9f93-b8f186a1496d";
  //   } else {
  //     return _recepients.first.imageURL;
  //   }
  // }
}
