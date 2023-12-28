import 'package:orm_library_manager/common/common.dart';
import 'package:orm_library_manager/domain/dto/csv_covertable.dart';

class BorrowInfo implements CsvConvertible {
  final int _id;
  final int _memberId;
  final int _bookId;
  final String _borrowDate;
  String _expireDate;
  String? _returnDate;
  bool _isFinished;

  BorrowInfo({
    required int memberId,
    required int bookId,
  })  : _id = DateTime.now().millisecondsSinceEpoch,
        _memberId = memberId,
        _bookId = bookId,
        _borrowDate = DateTime.now().dFormat(),
        _expireDate = DateTime.now().add(const Duration(days: 14)).dFormat(),
        _isFinished = false;

  BorrowInfo._internal({
    required int id,
    required int memberId,
    required int bookId,
    required String borrowDate,
    required String expireDate,
    required String? returnDate,
    required bool isFinished,
  }) : _id = id,
        _memberId = memberId,
        _bookId = bookId,
        _borrowDate = borrowDate,
        _expireDate = expireDate,
        _returnDate = returnDate,
        _isFinished = isFinished;

  int get id => _id;
  int get memberId => _memberId;
  int get bookId => _bookId;
  String get borrowDate => _borrowDate;
  String get expireDate => _expireDate;
  String? get returnDate => _returnDate;
  bool get isFinished => _isFinished;

  void setReturn() {
    _returnDate = DateTime.now().dFormat();
    _isFinished = true;
  }

  void renewalDate(String expireDate) {
    _expireDate = expireDate;
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is BorrowInfo &&
          runtimeType == other.runtimeType &&
          _id == other._id &&
          _memberId == other._memberId &&
          _bookId == other._bookId &&
          _borrowDate == other._borrowDate &&
          _expireDate == other._expireDate &&
          _returnDate == other._returnDate &&
          _isFinished == other._isFinished);

  @override
  int get hashCode =>
      _id.hashCode ^
      _memberId.hashCode ^
      _bookId.hashCode ^
      _borrowDate.hashCode ^
      _expireDate.hashCode ^
      _returnDate.hashCode ^
      _isFinished.hashCode;

  @override
  String toCSV() => '$_id,$_memberId,$_bookId,$_borrowDate,$_expireDate,$_returnDate,$_isFinished\n';

  factory BorrowInfo.fromCSV(List<String> list) {
    return BorrowInfo._internal(
      id: int.parse(list[0]),
      memberId: int.parse(list[1]),
      bookId: int.parse(list[2]),
      borrowDate: list[3],
      expireDate: list[4],
      returnDate: list[5],
      isFinished: bool.parse(list[6]),
    );
  }

  @override
  String toString() {
    return 'BorrowInfo{ _id: $_id, _memberId: $_memberId, _bookId: $_bookId, _borrowDate: $_borrowDate, _expireDate: $_expireDate, _returnDate: $_returnDate, _isFinished: $_isFinished,}';
  }

  BorrowInfo copyWith({
    int? id,
    int? memberId,
    int? bookId,
    String? borrowDate,
    String? expireDate,
    String? returnDate,
    bool? isFinished,
  }) {
    return BorrowInfo._internal(
      id: id ?? _id,
      memberId: memberId ?? _memberId,
      bookId: bookId ?? _bookId,
      borrowDate: borrowDate ?? _borrowDate,
      expireDate: expireDate ?? _expireDate,
      returnDate: returnDate ?? _returnDate,
      isFinished: isFinished ?? _isFinished,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      '_id': _id,
      '_memberId': _memberId,
      '_bookId': _bookId,
      '_borrowDate': _borrowDate,
      '_expireDate': _expireDate,
      '_returnDate': _returnDate,
      '_isFinished': _isFinished,
    };
  }

  factory BorrowInfo.fromJson(Map<String, dynamic> map) {
    return BorrowInfo._internal(
      id: map['_id'],
      memberId: map['_memberId'],
      bookId: map['_bookId'],
      borrowDate: map['_borrowDate'],
      expireDate: map['_expireDate'],
      returnDate: map['_returnDate'],
      isFinished: map['_isFinished'],
    );
  }
}
