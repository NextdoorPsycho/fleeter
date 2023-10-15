import 'package:flutter/cupertino.dart';
import 'package:glass_kit/glass_kit.dart';

class CupertinoWidgets {
  static GlassContainer button(String text, void Function()? onPressed) {
    return GlassContainer.frostedGlass(
      height: 50,
      width: 200,
      borderRadius: BorderRadius.circular(10.0),
      child: CupertinoButton(
        onPressed: onPressed,
        child: Text(text),
      ),
    );
  }

  static GlassContainer switchButton(bool value, void Function(bool)? onChanged) {
    return GlassContainer.frostedGlass(
      height: 50,
      width: 100,
      borderRadius: BorderRadius.circular(10.0),
      child: CupertinoSwitch(
        value: value,
        onChanged: onChanged,
      ),
    );
  }

  static List<Widget> checkboxList(List<String> items, List<String> selectedItems, void Function(List<String>) onChanged) {
    return [
      Wrap(
        spacing: 8.0, // gap between adjacent chips
        runSpacing: 4.0, // gap between lines
        children: items.map((item) {
          return Row(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              Text(item),
              CupertinoSwitch(
                value: selectedItems.contains(item),
                onChanged: (bool value) {
                  if (value == true) {
                    selectedItems.add(item);
                  } else {
                    selectedItems.remove(item);
                  }
                  onChanged(selectedItems);
                },
              ),
            ],
          );
        }).toList(),
      ),
    ];
  }

  static GlassContainer slider(double value, void Function(double)? onChanged) {
    return GlassContainer.frostedGlass(
      height: 50,
      width: 300,
      borderRadius: BorderRadius.circular(10.0),
      color: CupertinoColors.white.withOpacity(0.5),
      child: CupertinoSlider(
        value: value,
        onChanged: onChanged,
      ),
    );
  }

  static showFlyout(BuildContext context, Widget child) {
    showCupertinoModalPopup<void>(
      context: context,
      builder: (BuildContext context) => child,
    );
  }

  static GlassContainer loadingIndicator() {
    return GlassContainer.frostedGlass(
      height: 50,
      width: 50,
      borderRadius: BorderRadius.circular(10.0),
      child: const CupertinoActivityIndicator(),
    );
  }

  static CupertinoAlertDialog alertDialog({required String title, required String content}) {
    return CupertinoAlertDialog(
      title: Text(title),
      content: Text(content),
      actions: <Widget>[
        GlassContainer.frostedGlass(
          width: 100,
          height: 50,
          borderRadius: BorderRadius.circular(10.0),
          child: CupertinoDialogAction(
            isDefaultAction: true,
            child: Text('OK'),
          ),
        ),
      ],
    );
  }

  static CupertinoActionSheet actionSheet({required String title, required String message}) {
    return CupertinoActionSheet(
      title: Text(title),
      message: Text(message),
      actions: <GlassContainer>[
        GlassContainer.frostedGlass(
          width: 100,
          height: 50,
          borderRadius: BorderRadius.circular(10.0),
          child: CupertinoActionSheetAction(
            child: Text('Option 1'),
            onPressed: () {},
          ),
        ),
        GlassContainer.frostedGlass(
          width: 100,
          height: 50,
          borderRadius: BorderRadius.circular(10.0),
          child: CupertinoActionSheetAction(
            child: Text('Option 2'),
            onPressed: () {},
          ),
        ),
      ],
      cancelButton: CupertinoActionSheetAction(
        child: Text('Cancel'),
        onPressed: () {},
      ),
    );
  }

  static GlassContainer segmentedControl({required Map<int, Widget> children, required void Function(int) onValueChanged}) {
    return GlassContainer.frostedGlass(
      height: 50,
      width: 300,
      borderRadius: BorderRadius.circular(10.0),
      child: CupertinoSegmentedControl<int>(
        children: children,
        onValueChanged: onValueChanged,
      ),
    );
  }
}
