import 'package:awesome_snackbar_content/awesome_snackbar_content.dart';
import 'package:flutter/material.dart';

class CustomSnackbar {
  static awesome(BuildContext context, {String? message, ContentType? type}) {
    var snackBar = SnackBar(
      elevation: 0,
      behavior: SnackBarBehavior.fixed,
      backgroundColor: Colors.transparent,
      content: AwesomeSnackbarContent(
        title: type == ContentType.success
            ? 'Success!'
            : type == ContentType.warning
                ? 'Warning!'
                : 'Oops!',
        message: message ?? '',
        contentType: type ?? ContentType.success,
      ),
    );

    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }
}
