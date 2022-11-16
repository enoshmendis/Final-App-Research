import 'package:flutter/cupertino.dart';

void openDialogCTX(ctx,
    {String ?title, descriptions, cancel, confirmButton, final onPress}) {
  showCupertinoDialog(
      context: ctx,
      builder: (_) => CupertinoAlertDialog(
            title: Text(title!),
            content: Text(
              descriptions,
              textAlign: TextAlign.left,
            ),
            actions: [
              // Close the dialog
              // You can use the CupertinoDialogAction widget instead
              CupertinoButton(
                  child: Text(cancel),
                  onPressed: () {
                    Navigator.of(ctx).pop();
                  }),
              CupertinoButton(
                child: Text(confirmButton),
                onPressed: onPress,
              )
            ],
          ));
}

void openDialogCTXWithCancel(ctx,
    {String ?title,
    descriptions,
    cancel,
    confirmButton,
    final onPress,
    final onPressCancel}) {
  showCupertinoDialog(
      context: ctx,
      builder: (_) => CupertinoAlertDialog(
            title: Text(title!),
            content: Text(descriptions),
            actions: [
              CupertinoButton(child: Text(cancel), onPressed: onPressCancel),
              CupertinoButton(
                child: Text(confirmButton),
                onPressed: onPress,
              )
            ],
          ));
}