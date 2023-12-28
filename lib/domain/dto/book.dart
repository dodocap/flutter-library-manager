import 'package:orm_library_manager/domain/dto/csv_covertable.dart';

class Book implements CsvConvertible {
  int _id;
  String _name;
  String _price;
  String _isbn;
  String _publishDate;
  bool _isBorrowed;

  int get id => _id;
  bool get isBorrowed => _isBorrowed;
  String get publishDate => _publishDate;
  String get isbn => _isbn;
  String get price => _price;
  String get name => _name;


  set setBorrowed(bool isBorrowed) => _isBorrowed = isBorrowed;

  Book({
    required String name,
    required String price,
    required String isbn,
    required String publishDate,
  })  : _id = DateTime.now().millisecondsSinceEpoch,
        _name = name,
        _price = price,
        _isbn = isbn,
        _publishDate = publishDate,
        _isBorrowed = false;

  Book._internal({
    required int id,
    required String name,
    required String price,
    required String isbn,
    required String publishDate,
    required bool isBorrowed,
  }) : _id = id,
        _name = name,
        _price = price,
        _isbn = isbn,
        _publishDate = publishDate,
        _isBorrowed = isBorrowed;


  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Book &&
          runtimeType == other.runtimeType &&
          _id == other._id &&
          _name == other._name &&
          _price == other._price &&
          _isbn == other._isbn &&
          _publishDate == other._publishDate &&
          _isBorrowed == other._isBorrowed);

  @override
  int get hashCode => _id.hashCode ^ _name.hashCode ^ _price.hashCode ^ _isbn.hashCode ^ _publishDate.hashCode ^ _isBorrowed.hashCode;

  @override
  String toCSV() => '$_id,$_name,$_price,$_publishDate,$_isbn,$_isBorrowed\n';

  factory Book.fromCSV(List<String> list) {
    return Book._internal(
      id: int.parse(list[0]),
      name: list[1],
      price: list[2],
      publishDate: list[3],
      isbn: list[4],
      isBorrowed: bool.parse(list[5]),
    );
  }

  @override
  String toString() {
    return 'Book{ _id: $_id, _name: $_name, _price: $_price, _isbn: $_isbn, _publishDate: $_publishDate, _isBorrowed: $_isBorrowed,}';
  }

  Book copyWith({
    int? id,
    String? name,
    String? price,
    String? isbn,
    String? publishDate,
    bool? isBorrowed,
  }) {
    return Book._internal(
      id: id ?? _id,
      name: name ?? _name,
      price: price ?? _price,
      isbn: isbn ?? _isbn,
      publishDate: publishDate ?? _publishDate,
      isBorrowed: isBorrowed ?? _isBorrowed,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      '_id': _id,
      '_name': _name,
      '_price': _price,
      '_isbn': _isbn,
      '_publishDate': _publishDate,
      '_isBorrowed': _isBorrowed,
    };
  }

  factory Book.fromJson(Map<String, dynamic> map) {
    return Book._internal(
      id: map['_id'],
      name: map['_name'],
      price: map['_price'],
      isbn: map['_isbn'],
      publishDate: map['_publishDate'],
      isBorrowed: map['_isBorrowed'],
    );
  }
}
