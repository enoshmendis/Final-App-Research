//packages
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:mlvapp/Models/chat_message.dart';
import 'package:mlvapp/shared/label.dart';
import 'package:mlvapp/shared/message_bubble.dart';
import 'package:mlvapp/shared/rounded_image.dart';
import 'package:mlvapp/theme.dart';

//Models
import '../Models/app_user.dart';

class CustomListViewTileWithActivity extends StatelessWidget {
  final double height;
  final String title;
  final String subtitle;
  final String imagePath;
  final bool isActive;
  final bool isActivity;
  final Function onTap;

  CustomListViewTileWithActivity({
    required this.height,
    required this.title,
    required this.subtitle,
    required this.imagePath,
    required this.isActive,
    required this.isActivity,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
        onTap: () => onTap(),
        minVerticalPadding: height * 0.20,
        leading: RoundedImageAssetStatusIndicator(
          key: UniqueKey(),
          size: height / 2,
          imagePath: imagePath,
          isActive: isActive,
        ),
        title: SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Text(
            title,
            maxLines: 1,
            style: const TextStyle(
              color: Colors.black,
              fontSize: 18,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
        subtitle: isActivity
            ? Row(
                mainAxisSize: MainAxisSize.max,
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  SpinKitThreeBounce(
                    color: primaryColor,
                    size: height * 0.1,
                  )
                ],
              )
            : Text(
                subtitle,
                style: const TextStyle(
                  color: Colors.black,
                  fontSize: 12,
                  fontWeight: FontWeight.w400,
                ),
              ));
  }
}

class CustomChatListViewTile extends StatelessWidget {
  final double width;
  final double deviceHeight;
  final bool isOwnMessage;
  final ChatMessage message;
  final AppUser sender;

  CustomChatListViewTile({
    required this.width,
    required this.deviceHeight,
    required this.isOwnMessage,
    required this.message,
    required this.sender,
  });

  @override
  Widget build(BuildContext context) {
    // if (sender.imageURL.isEmpty) {
    //   sender.imageURL =
    //       "https://res.cloudinary.com/xinli/image/upload/v1645959728/images/default/defaultProfile_ejhe3c.png";
    // }
    return Container(
      padding: const EdgeInsets.only(bottom: 10),
      width: width,
      child: Row(
        mainAxisAlignment: isOwnMessage ? MainAxisAlignment.end : MainAxisAlignment.start,
        mainAxisSize: MainAxisSize.max,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          !isOwnMessage
              ? RoundedImageAsset(key: UniqueKey(), imagePath: "assets/images/defaultProfile.png", size: width * 0.08)
              : Container(),
          SizedBox(
            width: width * 0.05,
          ),
          message.type == MessageType.TEXT
              ? TextMessageBubble(
                  isOwnMessage: isOwnMessage,
                  message: message,
                  height: deviceHeight * 0.06,
                  width: width,
                )
              : ImageMessageBubble(
                  isOwnMessage: isOwnMessage,
                  message: message,
                  height: deviceHeight * 0.3,
                  width: width * 0.55,
                ),
        ],
      ),
    );
  }
}

class CustomListViewTile extends StatelessWidget {
  final double height;
  final String title;
  final String subtitle;
  final bool isActive;
  final bool isSelected;
  String? label;
  String? semiTitle;
  Color? labelColor;
  Function? onTap;
  Function? onLongPress;
  Widget? leading;

  CustomListViewTile({
    required this.height,
    required this.title,
    required this.subtitle,
    required this.isActive,
    required this.isSelected,
    this.onTap,
    this.onLongPress,
    this.label,
    this.labelColor,
    this.semiTitle,
    this.leading,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      onLongPress: onLongPress != null ? () => onLongPress!() : () {},
      trailing: isSelected
          ? const Icon(
              Icons.check,
              color: Colors.black,
            )
          : label != null
              ? Label(labelColor: labelColor, label: label)
              : null,
      onTap: onTap != null ? () => onTap!() : () {},
      minVerticalPadding: height * 0.20,
      leading: leading,
      title: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: const TextStyle(
              color: Colors.black,
              fontSize: 18,
              fontWeight: FontWeight.w500,
            ),
          ),
          semiTitle != null
              ? Text(
                  semiTitle!,
                  style: const TextStyle(
                    color: Colors.black,
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                  ),
                )
              : Container()
        ],
      ),
      subtitle: Text(
        subtitle,
        style: const TextStyle(
          color: Colors.black54,
          fontSize: 12,
          fontWeight: FontWeight.w400,
        ),
      ),
    );
  }
}

class CustomColorListViewTile extends StatelessWidget {
  final double height;
  final String title;
  final bool isSelected;
  String? subtitle;

  String? label;
  String? semiTitle;
  Color? labelColor;
  Function? onTap;
  Function? onLongPress;
  Widget? leading;
  Color color;

  CustomColorListViewTile({
    required this.height,
    required this.title,
    required this.isSelected,
    required this.color,
    this.subtitle,
    this.onTap,
    this.onLongPress,
    this.label,
    this.labelColor,
    this.semiTitle,
    this.leading,
  });

  @override
  Widget build(BuildContext context) {
    List<Color> gradient = isSelected ? [color, color] : [Colors.white, Colors.white];
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 5),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: gradient,
        ),
        boxShadow: const [
          BoxShadow(
            color: Colors.black26,
            spreadRadius: 1,
            blurRadius: 2,
            offset: Offset(0, 3),
          ),
        ],
        borderRadius: const BorderRadius.all(
          Radius.circular(5),
        ),
        border: Border.all(color: labelColor ?? Colors.black, width: 2),
      ),
      child: ListTile(
        selected: isSelected,
        onLongPress: onLongPress != null ? () => onLongPress!() : () {},
        leading: leading != null
            ? Container(
                width: MediaQuery.of(context).size.width * 0.2,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    leading ?? Container(),
                    VerticalDivider(
                      color: Colors.black54,
                      width: 1,
                    )
                  ],
                ),
              )
            : null,
        trailing: isSelected
            ? const Icon(
                Icons.check,
                color: Colors.white,
              )
            : label != null
                ? Label(labelColor: labelColor, label: label)
                : null,
        onTap: onTap != null ? () => onTap!() : () {},
        minVerticalPadding: height * 0.20,
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              textAlign: TextAlign.start,
              style: TextStyle(
                color: isSelected ? Colors.white : Colors.black,
                fontSize: 18,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
        subtitle: subtitle != null
            ? Text(
                subtitle ?? "",
                style: const TextStyle(
                  color: Colors.black54,
                  fontSize: 12,
                  fontWeight: FontWeight.w400,
                ),
              )
            : null,
      ),
    );
  }
}
