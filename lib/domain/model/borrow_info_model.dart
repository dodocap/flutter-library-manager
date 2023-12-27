class BorrowInfoModel {
  int _id;
  String _bookName;
  String _memberName;
  final String _borrowDate;
  final String _expireDate;
  String? _returnDate;
  bool _isFinished;

  BorrowInfoModel({
    required int id,
    required String bookName,
    required String memberName,
    required String borrowDate,
    required String expireDate,
    required String? returnDate,
    required bool isFinished,
  })  : _id = id,
        _bookName = bookName,
        _memberName = memberName,
        _borrowDate = borrowDate,
        _expireDate = expireDate,
        _returnDate = returnDate,
        _isFinished = isFinished;


  int get id => _id;
  String get bookName => _bookName;
  String get memberName => _memberName;
  String get borrowDate => _borrowDate;
  String get expireDate => _expireDate;
  String? get returnDate => _returnDate;
  bool get isFinished => _isFinished;


  @override
  String toString() => 'BorrowInfoModel{_id: $_id, _bookName: $_bookName, _memberName: $_memberName, _borrowDate: $_borrowDate, _expireDate: $_expireDate, _returnDate: $_returnDate, _isFinished: $_isFinished}';

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is BorrowInfoModel &&
          runtimeType == other.runtimeType &&
          _id == other._id &&
          _bookName == other._bookName &&
          _memberName == other._memberName &&
          _borrowDate == other._borrowDate &&
          _expireDate == other._expireDate &&
          _returnDate == other._returnDate &&
          _isFinished == other._isFinished;

  @override
  int get hashCode =>
      _id.hashCode ^
      _bookName.hashCode ^
      _memberName.hashCode ^
      _borrowDate.hashCode ^
      _expireDate.hashCode ^
      _returnDate.hashCode ^
      _isFinished.hashCode;

  BorrowInfoModel copyWith({
    int? id,
    String? bookName,
    String? memberName,
    String? borrowDate,
    String? expireDate,
    String? returnDate,
    bool? isFinished,
  }) {
    return BorrowInfoModel(
      id: id ?? _id,
      bookName: bookName ?? _bookName,
      memberName: memberName ?? _memberName,
      borrowDate: borrowDate ?? _borrowDate,
      expireDate: expireDate ?? _expireDate,
      returnDate: returnDate ?? _returnDate,
      isFinished: isFinished ?? _isFinished,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      '_id': _id,
      '_bookName': _bookName,
      '_memberName': _memberName,
      '_borrowDate': _borrowDate,
      '_expireDate': _expireDate,
      '_returnDate': _returnDate,
      '_isFinished': _isFinished,
    };
  }

  factory BorrowInfoModel.fromJson(Map<String, dynamic> map) {
    return BorrowInfoModel(
      id: map['_id'],
      bookName: map['_bookName'],
      memberName: map['_memberName'],
      borrowDate: map['_borrowDate'],
      expireDate: map['_expireDate'],
      returnDate: map['_returnDate'],
      isFinished: map['_isFinished'],
    );
  }
}