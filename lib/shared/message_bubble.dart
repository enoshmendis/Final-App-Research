import 'dart:async';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:mlvapp/theme.dart';
import 'package:mlvapp/utility/utils.dart';

//Packages
import 'package:timeago/timeago.dart' as timeago;

//Models
import 'package:mlvapp/Models/chat_message.dart';

class TextMessageBubble extends StatelessWidget {
  final bool isOwnMessage;
  final ChatMessage message;
  final double height;
  final double width;

  const TextMessageBubble({
    required this.isOwnMessage,
    required this.message,
    required this.height,
    required this.width,
  });

  @override
  Widget build(BuildContext context) {
    List<Color> _colorShcheme = isOwnMessage
        ? [
            primaryMaterialColor.shade200,
            secondaryMaterialColor.shade300,
          ]
        : [
            secondaryBackground,
            secondaryBackground,
          ];
    return Container(
      //height: height + (message.content.length / 20 * 6.0),
      constraints: BoxConstraints(
        minHeight: height + (message.content.length / 20 * 6.0),
      ),
      width: (message.content.length / 5 * 10) + width * 0.4 > deviceWidth(context) * 0.8
          ? deviceWidth(context) * 0.8
          : (message.content.length / 5 * 10) + width * 0.4,
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        gradient: LinearGradient(
          colors: _colorShcheme,
          stops: const [0.30, 0.70],
          begin: Alignment.centerLeft,
          end: Alignment.centerRight,
        ),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.max,
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            message.content,
            overflow: TextOverflow.visible,
            style: const TextStyle(
              color: Colors.black,
            ),
          ),
          Text(
            timeago.format(message.sentTime),
            style: const TextStyle(
              color: Colors.black45,
              fontSize: 12,
            ),
          )
        ],
      ),
    );
  }
}

class ImageMessageBubble extends StatelessWidget {
  final bool isOwnMessage;
  final ChatMessage message;
  final double height;
  final double width;

  ImageMessageBubble({
    required this.isOwnMessage,
    required this.message,
    required this.height,
    required this.width,
  });

  @override
  Widget build(BuildContext context) {
    double imageHeight;
    double imageWidth;
    String _orientation = message.orientation;

    List<Color> _colorShcheme = isOwnMessage
        ? [
            primaryMaterialColor.shade200,
            secondaryMaterialColor.shade300,
          ]
        : [
            secondaryBackground,
            secondaryBackground,
          ];

    DecorationImage _image = DecorationImage(
        image: NetworkImage(
          message.content,
        ),
        fit: BoxFit.cover);

    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: width * 0.02,
        vertical: height * 0.03,
      ),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(15),
        gradient: LinearGradient(
          colors: _colorShcheme,
          stops: const [0.30, 0.70],
          begin: Alignment.bottomLeft,
          end: Alignment.topRight,
        ),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.max,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            height: _orientation == "landscape" || _orientation == "square" ? width : height,
            width: _orientation == "landscape" ? height : width,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(15),
              image: _image,
            ),
          ),
          SizedBox(
            height: height * 0.02,
          ),
          Container(
            padding: EdgeInsets.only(left: width * 0.04),
            child: Text(
              timeago.format(message.sentTime),
              style: const TextStyle(
                color: Colors.black45,
                fontSize: 12,
              ),
            ),
          )
        ],
      ),
    );

    // return FutureBuilder<Size>(
    //   future: _calculateImageDimension(),
    //   builder: (BuildContext context, AsyncSnapshot<Size> snapshot) {
    //     if (snapshot.connectionState == ConnectionState.waiting) {
    //       return Center(
    //         child: SpinKitChasingDots(
    //           color: primaryColor,
    //           size: height * 0.1,
    //         ),
    //       );
    //     } else {
    //       if (snapshot.hasError) {
    //         return const Center(child: Text(''));
    //       } else {
    //         imageWidth = snapshot.data!.width;
    //         imageHeight = snapshot.data!.height;

    //         return Container(
    //           padding: EdgeInsets.symmetric(
    //             horizontal: width * 0.02,
    //             vertical: height * 0.03,
    //           ),
    //           decoration: BoxDecoration(
    //             borderRadius: BorderRadius.circular(15),
    //             gradient: LinearGradient(
    //               colors: _colorShcheme,
    //               stops: const [0.30, 0.70],
    //               begin: Alignment.bottomLeft,
    //               end: Alignment.topRight,
    //             ),
    //           ),
    //           child: Column(
    //             mainAxisSize: MainAxisSize.max,
    //             mainAxisAlignment: MainAxisAlignment.spaceBetween,
    //             crossAxisAlignment: CrossAxisAlignment.start,
    //             children: [
    //               Container(
    //                 height: imageHeight >= imageWidth ? height : width,
    //                 width: imageWidth > imageHeight ? height : width,
    //                 decoration: BoxDecoration(
    //                   borderRadius: BorderRadius.circular(15),
    //                   image: _image,
    //                 ),
    //               ),
    //               SizedBox(
    //                 height: height * 0.02,
    //               ),
    //               Container(
    //                 padding: EdgeInsets.only(left: width * 0.04),
    //                 child: Text(
    //                   timeago.format(message.sentTime),
    //                   style: const TextStyle(
    //                     color: Colors.black45,
    //                     fontSize: 12,
    //                   ),
    //                 ),
    //               )
    //             ],
    //           ),
    //         );
    //       }
    //     }
    //   },
    // );
  }

  Future<Size> _calculateImageDimension() {
    Completer<Size> completer = Completer();
    Image image = Image.network(message.content);
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
}
