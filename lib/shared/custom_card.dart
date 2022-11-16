import 'package:flutter/material.dart';
import 'package:mlvapp/shared/rounded_button.dart';


import '../theme.dart';

class TextCard extends StatelessWidget {
  Function? onPressed;
  String? buttonText;
  final String text;
  final Color color;
  final double width;
  final double height;

  TextCard({
    required this.text,
    required this.color,
    required this.width,
    required this.height,
    this.onPressed,
    this.buttonText,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      color: Colors.white,
      shadowColor: Colors.black,
      elevation: 3,
      shape: RoundedRectangleBorder(
          side: const BorderSide(
            color: secondaryColor,
            width: 1.0,
          ),
          borderRadius: BorderRadius.circular(15.0)),
      child: Container(
        width: width,
        padding: EdgeInsets.symmetric(horizontal: width * 0.03, vertical: width * 0.03),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              text,
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.w400),
            ),
            onPressed != null
                ? Container(
                    margin: EdgeInsets.only(top: 20),
                    alignment: Alignment.centerRight,
                    child: RoundedSizedButton(name: buttonText ?? "", fontSize: 16, radius: 10, onPressed: onPressed!),
                  )
                : Container(),
          ],
        ),
      ),
    );
  }
}

class ImageCard extends StatelessWidget {
  Function? onPressed;
  String? buttonText;
  String? description;
  final String text;
  final String image;
  final Color color;
  final double width;
  final double height;

  ImageCard({
    required this.text,
    required this.image,
    required this.color,
    required this.width,
    required this.height,
    this.onPressed,
    this.buttonText,
    this.description,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      color: Colors.white,
      shadowColor: Colors.black,
      elevation: 3,
      shape: RoundedRectangleBorder(
          side: const BorderSide(
            color: secondaryColor,
            width: 1.0,
          ),
          borderRadius: BorderRadius.circular(15.0)),
      child: Row(
        children: [
          Container(
            decoration: BoxDecoration(
              image: DecorationImage(
                image: NetworkImage(image != ""
                    ? image
                    : "https://res.cloudinary.com/xinli/image/upload/v1658072032/images/default/activity_default_xxzay6.jpg"),
                fit: BoxFit.cover,
              ),
              borderRadius: const BorderRadius.only(
                bottomLeft: Radius.circular(15.0),
                topLeft: Radius.circular(15.0),
              ),
            ),
            width: width * 0.4,
            // padding: EdgeInsets.symmetric(
            //     horizontal: width * 0.03, vertical: width * 0.03),
          ),
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisSize: MainAxisSize.max,
            children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 5),
                alignment: Alignment.center,
                height: height * 0.4,
                width: width * 0.5,
                child: Flex(
                  direction: Axis.vertical,
                  children: [
                    Expanded(
                      child: SingleChildScrollView(
                        scrollDirection: Axis.vertical, //.horizontal
                        child: Text(
                          text,
                          textAlign: TextAlign.center,
                          style: const TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: primaryColor,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                // child: Text(
                //   "sagdjah sa gdajhgds asdg ajshdg saj",
                //   textAlign: TextAlign.center,
                //   maxLines: 2,
                //   overflow: TextOverflow.ellipsis,
                //   style: const TextStyle(
                //     fontSize: 20,
                //     fontWeight: FontWeight.bold,
                //     color: primaryColor,
                //   ),
                // ),
              ),
              SizedBox(
                height: height * 0.1,
                width: width * 0.5,
              ),
              // Container(
              //   height: height * 0.01,
              //   width: width * 0.5,
              //   padding: EdgeInsets.symmetric(horizontal: 5, vertical: 5),
              // child: Flex(
              //   direction: Axis.vertical,
              //   children: [
              //     Expanded(
              //       child: SingleChildScrollView(
              //         scrollDirection: Axis.vertical, //.horizontal
              //         child: Text(
              //           description ?? "",
              //         ),
              //       ),
              //     ),
              //   ],
              // ),
              // ),
              onPressed != null
                  ? Container(
                      margin: const EdgeInsets.only(top: 0),
                      alignment: Alignment.center,
                      child:
                          RoundedSizedButton(name: buttonText ?? "", fontSize: 14, radius: 10, onPressed: onPressed!),
                    )
                  : Container(),
            ],
          ),
        ],
      ),
    );
  }
}
