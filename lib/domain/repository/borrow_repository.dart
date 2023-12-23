import 'package:orm_library_manager/domain/model/book.dart';
import 'package:orm_library_manager/domain/model/member.dart';

abstract interface class BorrowRepository {
  Future<void> borrowBook(Member member, Book book);
  Future<void> returnBook(Member member, Book book);
  Future<void> renewalBook(Member member, Book book);
  Future<void> getAllBorrowInfo();
}