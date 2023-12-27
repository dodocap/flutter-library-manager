import 'package:orm_library_manager/common/result.dart';
import 'package:orm_library_manager/domain/model/book.dart';
import 'package:orm_library_manager/domain/model/borrow_info.dart';
import 'package:orm_library_manager/domain/model/borrow_info_model.dart';
import 'package:orm_library_manager/domain/model/member.dart';

abstract interface class BorrowRepository {
  Future<Result<List<BorrowInfoModel>>> getAll();
  Future<Result<List<BorrowInfoModel>>> getByMember(Member member);
  Future<Result<BorrowInfo>> borrowBook(Member member, Book book);
  Future<Result<BorrowInfo>> returnBook(BorrowInfoModel borrowInfoModel);
  Future<Result<BorrowInfo>> renewalBook(BorrowInfoModel borrowInfoModel);
}