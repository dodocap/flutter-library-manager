import 'package:orm_library_manager/domain/model/book.dart';
import 'package:orm_library_manager/domain/model/borrow_info.dart';
import 'package:orm_library_manager/domain/model/member.dart';

abstract interface class BorrowRepository {
  Future<List<BorrowInfo>> getAllHistory();
  Future<List<BorrowInfo>> getAllBorrows();
  Future<BorrowInfo> borrowBook(Member member, Book book);
  Future<BorrowInfo> returnBook(Member member, Book book);
  Future<void> renewalBook(Member member, Book book);
}