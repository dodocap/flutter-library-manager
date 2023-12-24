import 'package:intl/intl.dart';

enum Gender {
  male('남자'),
  female('여자'),
  unknown('미공개');

  const Gender(this.genderString);
  final String genderString;

  String getValue() {
    return genderString;
  }

  factory Gender.getByString(String genderString) {
    return Gender.values.firstWhere((e) => e.genderString == genderString);
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
  String dFormat() => DateFormat('yyyy-MM-dd').format(this);
}
