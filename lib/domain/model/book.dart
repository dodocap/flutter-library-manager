class Book {
  int _id;
  String _name;
  String _price;
  String _isbn;
  DateTime _publicationDate;
  bool _isBorrowed;

  Book({
    required int id,
    required String name,
    required String price,
    required String isbn,
    required DateTime publicationDate,
    required bool isBorrowed,
  })  : _id = id,
        _name = name,
        _price = price,
        _isbn = isbn,
        _publicationDate = publicationDate,
        _isBorrowed = isBorrowed;
}
