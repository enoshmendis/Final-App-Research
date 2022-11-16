import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class RefreshWidget extends StatefulWidget {
  final GlobalKey<RefreshIndicatorState>? keyRefresh;
  final Widget child;
  final Future Function() onRefresh;
  bool? forceReload;

  RefreshWidget({
    Key? key,
    this.keyRefresh,
    required this.child,
    required this.onRefresh,
    this.forceReload,
  }) : super(key: key);

  @override
  State<RefreshWidget> createState() => _RefreshWidgetState();
}

class _RefreshWidgetState extends State<RefreshWidget> {
  @override
  Widget build(BuildContext context) {
    return Platform.isAndroid ? buildAndroidList() : buildIOSList();
  }

  Widget buildAndroidList() {
    return RefreshIndicator(
      key: widget.keyRefresh,
      onRefresh: widget.onRefresh,
      child: widget.child,
    );
  }

  Widget buildIOSList() {
    return CustomScrollView(
      physics: BouncingScrollPhysics(),
      slivers: [
        CupertinoSliverRefreshControl(
          key: widget.keyRefresh,
          onRefresh: widget.onRefresh,
        ),
        widget.child,
      ],
    );
  }
}
