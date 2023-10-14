import 'package:flutter/cupertino.dart';

class CupertinoWidgets {
  static CupertinoButton button(String text, void Function()? onPressed) {
    return CupertinoButton(
      onPressed: onPressed,
      child: Text(text),
    );
  }

  static CupertinoSlider slider(double value, void Function(double)? onChanged) {
    return CupertinoSlider(
      value: value,
      onChanged: onChanged,
    );
  }

  static showFlyout(BuildContext context, Widget child) {
    showCupertinoModalPopup<void>(
      context: context,
      builder: (BuildContext context) => child,
    );
  }

  static CupertinoActivityIndicator loadingIndicator() {
    return const CupertinoActivityIndicator();
  }

  static CupertinoAlertDialog alertDialog({required String title, required String content}) {
    return CupertinoAlertDialog(
      title: Text(title),
      content: Text(content),
      actions: const <Widget>[
        CupertinoDialogAction(
          isDefaultAction: true,
          child: Text('OK'),
        ),
      ],
    );
  }

  static CupertinoActionSheet actionSheet({required String title, required String message}) {
    return CupertinoActionSheet(
      title: Text(title),
      message: Text(message),
      actions: <CupertinoActionSheetAction>[
        CupertinoActionSheetAction(
          child: Text('Option 1'),
          onPressed: () {},
        ),
        CupertinoActionSheetAction(
          child: Text('Option 2'),
          onPressed: () {},
        ),
      ],
      cancelButton: CupertinoActionSheetAction(
        child: Text('Cancel'),
        onPressed: () {},
      ),
    );
  }

  static CupertinoTextField textField({required TextEditingController controller}) {
    return CupertinoTextField(
      controller: controller,
    );
  }

  static CupertinoDatePicker datePicker({required DateTime initialDateTime, required void Function(DateTime) onDateTimeChanged}) {
    return CupertinoDatePicker(
      initialDateTime: initialDateTime,
      onDateTimeChanged: onDateTimeChanged,
    );
  }

  static CupertinoTimerPicker timerPicker({required void Function(Duration) onTimerDurationChanged}) {
    return CupertinoTimerPicker(
      onTimerDurationChanged: onTimerDurationChanged,
    );
  }

  static CupertinoPicker picker({required List<Widget> children, required void Function(int) onSelectedItemChanged, required double itemExtent}) {
    return CupertinoPicker(
      children: children,
      onSelectedItemChanged: onSelectedItemChanged,
      itemExtent: itemExtent,
    );
  }

  static CupertinoSegmentedControl<int> segmentedControl({required Map<int, Widget> children, required void Function(int) onValueChanged}) {
    return CupertinoSegmentedControl<int>(
      children: children,
      onValueChanged: onValueChanged,
    );
  }
}
