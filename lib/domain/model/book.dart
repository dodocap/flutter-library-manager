class Book {
  int _id;
  String _name;
  String _price;
  String _isbn;
  String _publicationDate;
  bool _isBorrowed;

  int get id => _id;
  bool get isBorrowed => _isBorrowed;
  String get publicationDate => _publicationDate;
  String get isbn => _isbn;
  String get price => _price;
  String get name => _name;


  set setBorrowed(bool isBorrowed) => _isBorrowed = isBorrowed;

  Book({
    required String name,
    required String price,
    required String isbn,
    required String publicationDate,
  })  : _id = DateTime.now().millisecondsSinceEpoch,
        _name = name,
        _price = price,
        _isbn = isbn,
        _publicationDate = publicationDate,
        _isBorrowed = false;

  Book._internal({
    required int id,
    required String name,
    required String price,
    required String isbn,
    required String publicationDate,
    required bool isBorrowed,
  }) : _id = id,
        _name = name,
        _price = price,
        _isbn = isbn,
        _publicationDate = publicationDate,
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
          _publicationDate == other._publicationDate &&
          _isBorrowed == other._isBorrowed);

  @override
  int get hashCode => _id.hashCode ^ _name.hashCode ^ _price.hashCode ^ _isbn.hashCode ^ _publicationDate.hashCode ^ _isBorrowed.hashCode;

  @override
  String toString() {
    return 'Book{ _id: $_id, _name: $_name, _price: $_price, _isbn: $_isbn, _publicationDate: $_publicationDate, _isBorrowed: $_isBorrowed,}';
  }

  Book copyWith({
    int? id,
    String? name,
    String? price,
    String? isbn,
    String? publicationDate,
    bool? isBorrowed,
  }) {
    return Book._internal(
      id: id ?? _id,
      name: name ?? _name,
      price: price ?? _price,
      isbn: isbn ?? _isbn,
      publicationDate: publicationDate ?? _publicationDate,
      isBorrowed: isBorrowed ?? _isBorrowed,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      '_id': _id,
      '_name': _name,
      '_price': _price,
      '_isbn': _isbn,
      '_publicationDate': _publicationDate,
      '_isBorrowed': _isBorrowed,
    };
  }

  factory Book.fromJson(Map<String, dynamic> map) {
    return Book._internal(
      id: map['_id'],
      name: map['_name'],
      price: map['_price'],
      isbn: map['_isbn'],
      publicationDate: map['_publicationDate'],
      isBorrowed: map['_isBorrowed'],
    );
  }
}
