class Member {
  int _id;
  String _name;
  String _joinDate;
  String _address;
  String _contact;
  String _birthDate;
  String _gender;

  Member({
    required int id,
    required String name,
    required String joinDate,
    required String address,
    required String contact,
    required String birthDate,
    required String gender,
  })  : _id = id,
        _name = name,
        _joinDate = joinDate,
        _address = address,
        _contact = contact,
        _birthDate = birthDate,
        _gender = gender;
}
