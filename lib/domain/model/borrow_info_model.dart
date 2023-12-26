class BorrowInfoModel {
  String _bookName;
  String _memberName;
  final String _borrowDate;
  final String _expireDate;
  String? _returnDate;
  bool _isFinished;

  BorrowInfoModel({
    required String bookName,
    required String memberName,
    required String borrowDate,
    required String expireDate,
    required String? returnDate,
    required bool isFinished,
  })  : _bookName = bookName,
        _memberName = memberName,
        _borrowDate = borrowDate,
        _expireDate = expireDate,
        _returnDate = returnDate,
        _isFinished = isFinished;


  String get bookName => _bookName;
  String get memberName => _memberName;
  String get borrowDate => _borrowDate;
  String get expireDate => _expireDate;
  String? get returnDate => _returnDate;
  bool get isFinished => _isFinished;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is BorrowInfoModel &&
          runtimeType == other.runtimeType &&
          _bookName == other._bookName &&
          _memberName == other._memberName &&
          _borrowDate == other._borrowDate &&
          _expireDate == other._expireDate &&
          _returnDate == other._returnDate &&
          _isFinished == other._isFinished);

  @override
  int get hashCode =>
      _bookName.hashCode ^ _memberName.hashCode ^ _borrowDate.hashCode ^ _expireDate.hashCode ^ _returnDate.hashCode ^ _isFinished.hashCode;

  @override
  String toString() {
    return 'BorrowInfoModel{ _bookName: $_bookName, _memberName: $_memberName, _borrowDate: $_borrowDate, _expireDate: $_expireDate, _returnDate: $_returnDate, _isFinished: $_isFinished,}';
  }

  BorrowInfoModel copyWith({
    String? bookName,
    String? memberName,
    String? borrowDate,
    String? expireDate,
    String? returnDate,
    bool? isFinished,
  }) {
    return BorrowInfoModel(
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
      bookName: map['_bookName'] as String,
      memberName: map['_memberName'] as String,
      borrowDate: map['_borrowDate'] as String,
      expireDate: map['_expireDate'] as String,
      returnDate: map['_returnDate'] as String,
      isFinished: map['_isFinished'] as bool,
    );
  }
}