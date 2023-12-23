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