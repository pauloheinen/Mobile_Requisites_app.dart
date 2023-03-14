import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

// pub.dev/packages/motion_toast/versions/2.6.5
// https://codesinsider.com/flutter-styled-motion-toast-example-tutorial/
// https://www.youtube.com/watch?v=Z83yOggpwyE&ab_channel=AmitPatil
// https://stackoverflow.com/questions/56280736/alertdialog-without-context-in-flutter
class ToastUtil {
  // static void noConnectionToast( BuildContext context ) {
  //   MotionToast(
  //       primaryColor: Colors.grey,
  //       description: const Text("Sem conexão"),
  //       icon: Icons.wifi_off,
  //       animationDuration: const Duration(seconds: 5),
  //       position: MotionToastPosition.top,
  //       animationType: AnimationType.fromTop,
  //
  //   ).show(context);
  // }
  //
  // static void userNotFoundToast( BuildContext context ) {
  //   MotionToast(
  //       primaryColor: Colors.red,
  //       description: const Text("Usuário não encontrado"),
  //       icon: Icons.person_off_rounded,
  //       animationDuration: const Duration(seconds: 5),
  //       position: MotionToastPosition.top,
  //       animationType: AnimationType.fromTop
  //   ).show(context);
  // }
  //
  // static void saveConfigurationsToast( BuildContext context ) {
  //   MotionToast(
  //       primaryColor: Colors.blue,
  //       description: const Text("Alterações salvas"),
  //       icon: Icons.save,
  //       animationDuration: const Duration(seconds: 5),
  //       position: MotionToastPosition.top,
  //       animationType: AnimationType.fromTop
  //   ).show(context);
  // }
  //
  // static void cancelConfigurationsToast( BuildContext context ) {
  //   MotionToast(
  //       primaryColor: Colors.blue,
  //       description: const Text("Alterações canceladas"),
  //       icon: Icons.person_off_rounded,
  //       animationDuration: const Duration(seconds: 5),
  //       position: MotionToastPosition.top,
  //       animationType: AnimationType.fromTop
  //   ).show(context);
  // }

  static warning(String message) {
    Fluttertoast.showToast(
        msg: message,
        toastLength: Toast.LENGTH_LONG,
        gravity: ToastGravity.TOP,
        timeInSecForIosWeb: 1,
        backgroundColor: Colors.red,
        textColor: Colors.white,
        fontSize: 16.0);
  }

  static void inform(String message) {
    Fluttertoast.showToast(
        msg: message,
        toastLength: Toast.LENGTH_LONG,
        gravity: ToastGravity.TOP,
        timeInSecForIosWeb: 1,
        backgroundColor: Colors.blue,
        textColor: Colors.white,
        fontSize: 16.0);
  }
}
