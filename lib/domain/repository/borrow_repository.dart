import 'package:orm_library_manager/common/result.dart';
import 'package:orm_library_manager/domain/dto/book.dart';
import 'package:orm_library_manager/domain/dto/borrow_info.dart';
import 'package:orm_library_manager/domain/dto/member.dart';
import 'package:orm_library_manager/domain/model/borrow_info_model.dart';

abstract interface class BorrowRepository {
  Future<Result<List<BorrowInfoModel>>> getAll();
  Future<Result<List<BorrowInfoModel>>> getByMember(Member member);
  Future<Result<BorrowInfo>> borrowBook(Member member, Book book);
  Future<Result<BorrowInfo>> returnBook(BorrowInfoModel borrowInfoModel);
  Future<Result<BorrowInfo>> renewalBook(BorrowInfoModel borrowInfoModel);
}