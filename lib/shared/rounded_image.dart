//packages
import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:mlvapp/theme.dart';

class RoundedImageNetwork extends StatelessWidget {
  final String imagePath;
  final double size;

  const RoundedImageNetwork(
      {required Key? key, required this.imagePath, required this.size})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: size,
      width: size,
      decoration: BoxDecoration(
        image: DecorationImage(
          fit: BoxFit.cover,
          image: NetworkImage(imagePath),
        ),
        borderRadius: BorderRadius.all(Radius.circular(size)),
        color: secondaryBackground,
        border: Border.all(color: secondaryShade),
      ),
    );
  }
}

class RoundedImageAsset extends StatelessWidget {
  final String imagePath;
  final double size;

  const RoundedImageAsset(
      {required Key? key, required this.imagePath, required this.size})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: size,
      width: size,
      decoration: BoxDecoration(
        image: DecorationImage(
          fit: BoxFit.cover,
          image: AssetImage(imagePath),
        ),
        borderRadius: BorderRadius.all(Radius.circular(size)),
        color: secondaryBackground,
        border: Border.all(color: secondaryShade),
      ),
    );
  }
}

class RoundedImageFile extends StatelessWidget {
  final PlatformFile image;
  final double size;

  const RoundedImageFile({
    required Key? key,
    required this.image,
    required this.size,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: size,
      width: size,
      decoration: BoxDecoration(
        image: DecorationImage(
          fit: BoxFit.cover,
          image: FileImage(File(image.path!)),
        ),
        borderRadius: BorderRadius.all(Radius.circular(size)),
        color: primaryColor,
      ),
    );
  }
}

class RoundedAssetFile extends StatelessWidget {
  final String path;
  final double size;

  const RoundedAssetFile({
    required Key? key,
    required this.path,
    required this.size,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: size,
      width: size,
      decoration: BoxDecoration(
        image: DecorationImage(
          fit: BoxFit.cover,
          image: AssetImage(path),
        ),
        borderRadius: BorderRadius.all(Radius.circular(size)),
        color: primaryColor,
      ),
    );
  }
}

class RoundedImageNetworkStatusIndicator extends RoundedImageNetwork {
  final bool isActive;

  RoundedImageNetworkStatusIndicator({
    required Key key,
    required String imagePath,
    required double size,
    required this.isActive,
  }) : super(key: key, imagePath: imagePath, size: size);

  @override
  Widget build(BuildContext context) {
    return Stack(
      clipBehavior: Clip.none,
      alignment: Alignment.bottomRight,
      children: [
        super.build(context),
        Container(
          height: size * 0.25,
          width: size * 0.25,
          decoration: BoxDecoration(
            color: isActive ? Colors.green : Colors.red,
            borderRadius: BorderRadius.circular(size),
          ),
        )
      ],
    );
  }
}

class RoundedImageAssetStatusIndicator extends RoundedImageAsset {
  final bool isActive;

  RoundedImageAssetStatusIndicator({
    required Key key,
    required String imagePath,
    required double size,
    required this.isActive,
  }) : super(key: key, imagePath: imagePath, size: size);

  @override
  Widget build(BuildContext context) {
    return Stack(
      clipBehavior: Clip.none,
      alignment: Alignment.bottomRight,
      children: [
        super.build(context),
        Container(
          height: size * 0.25,
          width: size * 0.25,
          decoration: BoxDecoration(
            color: isActive ? Colors.green : Colors.red,
            borderRadius: BorderRadius.circular(size),
          ),
        )
      ],
    );
  }
}
