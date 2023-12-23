class BorrowInfo {
  int _memberId;
  int _bookId;
  DateTime _borrowDate;
  DateTime _returnDate;
  DateTime _extensionDate;

  BorrowInfo({
    required int memberId,
    required int bookId,
    required DateTime borrowDate,
    required DateTime returnDate,
    required DateTime extensionDate,
  })  : _memberId = memberId,
        _bookId = bookId,
        _borrowDate = borrowDate,
        _returnDate = returnDate,
        _extensionDate = extensionDate;
}
