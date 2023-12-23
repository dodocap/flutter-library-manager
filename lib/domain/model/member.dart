import 'package:orm_library_manager/common/common.dart';

class Member {
  int? _id;
  String _name;
  String _address;
  String _contact;
  String _birthDate;
  Gender _gender;

  set id(int? value) => _id = value;

  int? get id => _id;
  String get name => _name;
  String get address => _address;
  String get contact => _contact;
  String get birthDate => _birthDate;
  Gender get gender => _gender;

  Member({
    required String name,
    required String address,
    required String contact,
    required String birthDate,
    required Gender gender,
  })  : _name = name,
        _address = address,
        _contact = contact,
        _birthDate = birthDate,
        _gender = gender;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Member &&
          runtimeType == other.runtimeType &&
          _name == other._name &&
          _address == other._address &&
          _contact == other._contact &&
          _birthDate == other._birthDate &&
          _gender == other._gender);

  @override
  int get hashCode => _name.hashCode ^ _address.hashCode ^ _contact.hashCode ^ _birthDate.hashCode ^ _gender.hashCode;

  Member copyWith({
    String? name,
    String? address,
    String? contact,
    String? birthDate,
    Gender? gender,
  }) {
    return Member(
      name: name ?? _name,
      address: address ?? _address,
      contact: contact ?? _contact,
      birthDate: birthDate ?? _birthDate,
      gender: gender ?? _gender,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      '_name': _name,
      '_address': _address,
      '_contact': _contact,
      '_birthDate': _birthDate,
      '_gender': _gender,
    };
  }

  factory Member.fromJson(Map<String, dynamic> map) {
    return Member(
      name: map['_name'] as String,
      address: map['_address'] as String,
      contact: map['_contact'] as String,
      birthDate: map['_birthDate'] as String,
      gender: map['_gender'] as Gender,
    );
  }
}
