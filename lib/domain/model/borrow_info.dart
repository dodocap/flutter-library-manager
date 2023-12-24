import 'package:orm_library_manager/common/common.dart';

class BorrowInfo {
  int _id;
  int _memberId;
  int _bookId;
  String _borrowDate;
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

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is BorrowInfo &&
          runtimeType == other.runtimeType &&
          _id == other._id &&
          _memberId == other._memberId &&
          _bookId == other._bookId &&
          _borrowDate == other._borrowDate;

  @override
  int get hashCode => _id.hashCode ^ _memberId.hashCode ^ _bookId.hashCode ^ _borrowDate.hashCode;

  @override
  String toString() {
    return 'BorrowInfo{_id: $_id, _memberId: $_memberId, _bookId: $_bookId, _borrowDate: $_borrowDate, _expireDate: $_expireDate, _returnDate: $_returnDate, _isFinished: $_isFinished}';
  }
}
