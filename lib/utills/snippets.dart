import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:timeago/timeago.dart' as timeago;

import '../constants/color_constant.dart';

String? Function(String?) get mandatoryValidator =>
    (String? val) => val?.isEmpty ?? true ? "This field is mandatory" : null;

String? Function(String?) get emailValidator => (String? email) => RegExp(
      r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+",
    ).hasMatch(email ?? "")
        ? null
        : "Enter a valid email";

String? Function(String?) get numberValidator =>
    (String? number) => number?.isEmpty ?? true
        ? "This field is mandatory"
        : RegExp(r"^[0-9]*$").hasMatch(number ?? "")
            ? null
            : "Enter a valid number";



void pushNamed(BuildContext context, String routeName) =>
    Navigator.pushNamed(context, routeName);

String? Function(String?) get passwordValidator => (String? password) =>
    (password?.length ?? 0) < 8 ? "Password too short" : null;

String? validateConfirmPassword(String password, String? confirm) {
  if (password != confirm) {
    return "Passwords don't match";
  }
  final err = passwordValidator(confirm);
  if (err != null) {
    return err;
  } else {
    return null;
  }
}

String standardFormatTime(DateTime dataTime) {
  final DateFormat formatter = DateFormat('h:mm a');
  return formatter.format(dataTime);
}

Future<File?> pickImage(ImageSource source) async {
  final pickedImage =
      await ImagePicker().pickImage(source: source, imageQuality: 30);
  if (pickedImage != null) {
    return File(pickedImage.path);
  } else {
    // ignore: unnecessary_statements
    ("image is not selected");
  }
  return null;
  // final bytes = await pickedImage!.readAsBytes();
  // return base64Encode(bytes);
}

Future<T?> push<T>(BuildContext context, Widget child) =>
    Navigator.of(context).push<T>(MaterialPageRoute(builder: (_) => child));

void replace(BuildContext context, Widget child) => Navigator.of(context)
    .pushReplacement(MaterialPageRoute(builder: (_) => child));

String constructChatRoomId(
    {required String adminId, required String appUserId}) {
  List<String> ids = [adminId, appUserId];

  return ids.join('_');
}

void pop(BuildContext context) => Navigator.of(context).pop();

void popToMain(BuildContext context) =>
    Navigator.of(context).popUntil((route) => route.isFirst);

void snack(BuildContext context, String message,
    {bool info = true, Color color = Colors.green}) {
  debugPrint(message);
  ScaffoldMessenger.of(context).showSnackBar(SnackBar(
    duration: const Duration(milliseconds: 1000),
    backgroundColor: info ? color : redColor,
    // behavior: SnackBarBehavior.floating,
    content: Text(
      message,
      style: Theme.of(context).textTheme.bodyLarge?.copyWith(
            color: Colors.white,
          ),
    ),
  ));
}

String timeUntil(DateTime date) {
  return timeago.format(date);
}



String parseDate(DateTime date) {
  return DateFormat.yMMMd().format(date);
}

Future<dynamic> showDialogOf(context, Widget child,
    {isDismissible = true}) async {
  showDialog(
      context: context,
      barrierDismissible: isDismissible,
      builder: (BuildContext context) {
        return child;
      });
}

RoundedRectangleBorder getRoundShape({double? val}) =>
    RoundedRectangleBorder(borderRadius: getRoundBorder(val: val));

BorderRadius getRoundBorder({double? val}) => BorderRadius.circular(val ?? 30);
Widget getLoader() => const Center(child: CircularProgressIndicator());
Widget loading(bool isLoad) => isLoad == true
    ? const Center(child: CircularProgressIndicator())
    : SizedBox();

void alert(BuildContext context, String message,
    {bool info = false, IconData? icon, String? title}) {
  debugPrint(message);

  showDialog(
    context: context,
    builder: (context) => AlertDialog(
      contentPadding: const EdgeInsets.symmetric(vertical: 40, horizontal: 20),
      actionsPadding: const EdgeInsets.symmetric(vertical: 40, horizontal: 20) -
          const EdgeInsets.only(top: 40),
      actionsAlignment: MainAxisAlignment.center,
      title: info
          ? Icon(
              icon ?? Icons.check_circle_outline,
              color: greenColor,
              size: 90,
            )
          : Icon(
              icon ?? Icons.error_outline,
              color: Theme.of(context).colorScheme.error,
              size: 90,
            ),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            title ?? (info ? "Success" : "Error"),
            style: Theme.of(context).textTheme.displaySmall,
          ),
          const SizedBox(height: 16),
          Text(
            message,
            style: Theme.of(context).textTheme.bodyMedium,
            textAlign: TextAlign.center,
          ),
        ],
      ),
      actions: <Widget>[
        ElevatedButton(
          child: const Text("Okay"),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ],
    ),
  );
}

void sureAlert({
  required BuildContext context,
  required String message,
  required void Function() onYes,
}) =>
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        contentPadding:
            const EdgeInsets.symmetric(vertical: 40, horizontal: 120),
        actionsPadding:
            const EdgeInsets.symmetric(vertical: 40, horizontal: 120) -
                const EdgeInsets.only(top: 40),
        actionsAlignment: MainAxisAlignment.center,
        title: Icon(
          Icons.help_outline,
          color: Theme.of(context).primaryColor,
          size: 90,
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              "Are you sure?",
              style: Theme.of(context).textTheme.displaySmall,
            ),
            const SizedBox(height: 16),
            Text(
              message,
              style: Theme.of(context).textTheme.bodyMedium,
              textAlign: TextAlign.center,
            ),
          ],
        ),
        actions: <Widget>[
          ElevatedButton(
            child: const Text("Yes"),
            onPressed: () {
              onYes();
              pop(context);
            },
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.orange,
            ),
            child: const Text("No"),
            onPressed: () => Navigator.of(context).pop(),
          ),
        ],
      ),
    );

// Widget getErrorMessage(BuildContext context, e) {
//   debugPrint(e);
//
//   return Center(
//     child: Text(
//       e is FirebaseException ? e.message ?? e.code : e,
//       style: Theme.of(context).textTheme.headline6!.copyWith(color: Colors.red),
//       textAlign: TextAlign.center,
//     ),
//   );
// }

Widget getShimmer({double width = 40, height = 12}) {
  return Container(
    color: Colors.grey,
    height: height,
    width: width,
  );
}

// Widget getFirebaseError(BuildContext context, error) {
//   return getErrorMessage(context,
//       error is FirebaseException ? error.message ?? error.code : '$error');
// }

bool isKeyboardOpen(BuildContext context) =>
    MediaQuery.of(context).viewInsets.bottom != 0;

Future<String?> alertInput(BuildContext context, String title, String hint,
    {String doneText = "Done"}) async {
  final controller = TextEditingController();
  return showDialog<String>(
    context: context,
    builder: (context) => AlertDialog(
      contentPadding: const EdgeInsets.symmetric(horizontal: 40, vertical: 60),
      actionsPadding: const EdgeInsets.symmetric(horizontal: 40, vertical: 8),
      actionsAlignment: MainAxisAlignment.center,
      title: Text(title),
      content: SizedBox(
        width: 500,
        child: TextField(
          decoration: InputDecoration(hintText: hint),
          controller: controller,
        ),
      ),
      actions: <Widget>[
        TextButton(
          child: const Padding(
            padding: EdgeInsets.symmetric(vertical: 8.0, horizontal: 16),
            child: Text("Cancel", style: TextStyle(color: Colors.orange)),
          ),
          onPressed: () => Navigator.of(context).pop(),
        ),
        ElevatedButton(
          child: Text(doneText),
          onPressed: () => Navigator.of(context).pop(controller.text),
        ),
      ],
    ),
  );
}
