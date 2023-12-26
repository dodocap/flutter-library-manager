import 'package:orm_library_manager/common/common.dart';

class Member {
  int _id;
  String _name;
  String _address;
  String _contact;
  String _birthDate;
  Gender _gender;

  int get id => _id;
  String get name => _name;
  String get address => _address;
  String get contact => _contact;
  String get birthDate => _birthDate;
  Gender get gender => _gender;

  Member({
    required String name,
    required String contact,
    required String birthDate,
    required String address,
    required Gender gender,
  })  : _id = DateTime.now().millisecondsSinceEpoch,
        _name = name,
        _contact = contact,
        _birthDate = birthDate,
        _address = address,
        _gender = gender;

  Member._internal({
    required int id,
    required String name,
    required String contact,
    required String birthDate,
    required String address,
    required Gender gender,
  }) : _id = id,
      _name = name,
      _contact = contact,
      _birthDate = birthDate,
      _address = address,
      _gender = gender;

  void setPendingRemove() {
    _id = -_id;
  }

  bool isPendingRemove() => _id < 0;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Member &&
          runtimeType == other.runtimeType &&
          _name == other._name &&
          _contact == other._contact &&
          _birthDate == other._birthDate);

  @override
  int get hashCode => _name.hashCode ^ _contact.hashCode ^ _birthDate.hashCode;

  Member copyWith({
    int? id,
    String? name,
    String? address,
    String? contact,
    String? birthDate,
    Gender? gender,
  }) {
    return Member._internal(
      id: id ?? _id,
      name: name ?? _name,
      address: address ?? _address,
      contact: contact ?? _contact,
      birthDate: birthDate ?? _birthDate,
      gender: gender ?? _gender,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      '_id' : _id,
      '_name': _name,
      '_address': _address,
      '_contact': _contact,
      '_birthDate': _birthDate,
      '_gender': _gender.genderString,
    };
  }

  factory Member.fromJson(Map<String, dynamic> map) {
    return Member._internal(
      id: map['_id'],
      name: map['_name'],
      address: map['_address'],
      contact: map['_contact'],
      birthDate: map['_birthDate'],
      gender: Gender.getByString(map['_gender']),
    );
  }

  String toCSV() => '$_id,$_name,$_contact,$_birthDate,$_address,${_gender.genderString}\n';

  factory Member.fromCSV(List<String> list) {
    return Member._internal(
      id: int.parse(list[0]),
      name: list[1],
      contact: list[2],
      birthDate: list[3],
      address: list[4],
      gender: Gender.getByString(list[5]),
    );
  }

  @override
  String toString() {
    return 'Member{_id: $_id, _name: $_name, _contact: $_contact, _birthDate: $_birthDate, _address: $_address, _gender: $_gender}';
  }
}
