import 'dart:io';
import 'dart:ui';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class LoadingDialog {
  static void show(BuildContext context, {String? message}) {
    showAdaptiveDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 5, sigmaY: 5),
            child: Dialog(
              backgroundColor: Colors.transparent,
              surfaceTintColor: Colors.transparent,
              // contentPadding: EdgeInsets.all(0),
              child: SizedBox(
                height: 100,
                width: 100,
                child: Center(
                  child: Transform.scale(
                    scale: 1.5,
                    child: Platform.isIOS
                        ? const CupertinoActivityIndicator()
                        : const CircularProgressIndicator(),
                  ),
                ),
              ),
            ));
      },
    );
  }

  static void hide(BuildContext context) {
    Navigator.of(context).pop();
  }
}
