import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

enum Gender {
  male('남자'),
  female('여자'),
  unknown('미공개');

  const Gender(this.genderString);
  final String genderString;

  factory Gender.getByString(String genderString) {
    return Gender.values.firstWhere((e) => e.genderString == genderString);
  }
}

enum ScreenMode {
  selectorBurrower('대출'),
  selectorReturner('반납'),
  selectorRenewal('연장'),
  editor('편집');

  const ScreenMode(this.modeString);
  final String modeString;

  factory ScreenMode.getByString(String modeString) {
    return ScreenMode.values.firstWhere((e) => e.modeString == modeString);
  }
}

extension IterableExtension<T> on Iterable<T> {
  T? firstWhereOrNull(bool Function(T) test) {
    try {
      return firstWhere(test);
    } catch (e) {
      return null;
    }
  }
}

extension DateFormatter on DateTime {
  String dFormat() => DateFormat('yyyyMMdd').format(this);
}

void showSimpleDialog(BuildContext context, String msg, [void Function()? callback]) {
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        title: Text(msg),
        actions: [
          ElevatedButton(
            onPressed: () {
              Navigator.of(context).pop();
              callback?.call();
            },
            child: const Text('확인'),
          ),
        ],
      );
    },
  );
}