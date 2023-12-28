import 'dart:io';

import 'package:orm_library_manager/common/common.dart';
import 'package:orm_library_manager/common/constants.dart';
import 'package:orm_library_manager/common/repositories.dart';
import 'package:orm_library_manager/common/result.dart';
import 'package:orm_library_manager/data/repository_impl/file/base_file_repository.dart';
import 'package:orm_library_manager/domain/model/book.dart';
import 'package:orm_library_manager/domain/model/borrow_info.dart';
import 'package:orm_library_manager/domain/model/borrow_info_model.dart';
import 'package:orm_library_manager/domain/model/member.dart';
import 'package:orm_library_manager/domain/repository/book_repository.dart';
import 'package:orm_library_manager/domain/repository/borrow_repository.dart';
import 'package:orm_library_manager/domain/repository/member_repository.dart';
import 'package:path_provider/path_provider.dart';

class BorrowFileRepository extends BaseFileRepository<BorrowInfo> implements BorrowRepository {
  static final BorrowFileRepository _instance = BorrowFileRepository._internal(borrowFileName, borrowFileRowString);
  factory BorrowFileRepository() => _instance;
  BorrowFileRepository._internal(super.fileName, super.fileRowString);

  @override
  BorrowInfo fromCSV(List<String> splitStringList) {
    return BorrowInfo.fromCSV(splitStringList);
  }
  
  @override
  Future<Result<List<BorrowInfoModel>>> getAll() async {
    final result = (await Future.wait(
        list.map((borrowInfo) async {
          Result<Book> book = await bookRepository.findById(borrowInfo.bookId);
          Result<Member> member = await memberRepository.findById(borrowInfo.memberId);

          if(book is Success<Book> && member is Success<Member>) {
            return BorrowInfoModel(
              id: borrowInfo.id,
              bookName: book.data.name,
              memberName: member.data.name,
              borrowDate: borrowInfo.borrowDate,
              expireDate: borrowInfo.expireDate,
              returnDate: borrowInfo.returnDate,
              isFinished: borrowInfo.isFinished,
            );
          }
          return null;
        })
    )).where((element) => element != null)
      .cast<BorrowInfoModel>()
      .toList();

    return Success(result);
  }

  @override
  Future<Result<List<BorrowInfoModel>>> getByMember(Member member) async {
    final result = (await Future.wait(
        list.map((borrowInfo) async {
          Result<Book> book = await bookRepository.findById(borrowInfo.bookId);
          if(book is Success<Book> && borrowInfo.memberId == member.id) {
            return BorrowInfoModel(
              id: borrowInfo.id,
              bookName: book.data.name,
              memberName: member.name,
              borrowDate: borrowInfo.borrowDate,
              expireDate: borrowInfo.expireDate,
              returnDate: borrowInfo.returnDate,
              isFinished: borrowInfo.isFinished,
            );
          }
        })
    )).where((element) => element != null)
        .cast<BorrowInfoModel>()
        .toList();

    return Success(result);
  }

  @override
  Future<Result<BorrowInfo>> borrowBook(Member member, Book book) async {
    if(book.isBorrowed) {
      return const Error(errAlreadyBorrowed);
    }

    Result<Book> result = await bookRepository.borrow(book);
    if(result is Error<Book>) {
      return Error(result.error);
    }

    final BorrowInfo borrowInfo = BorrowInfo(memberId: member.id, bookId: book.id);
    list.add(borrowInfo);
    await saveFile();

    return Success(borrowInfo);
  }

  @override
  Future<Result<BorrowInfo>> returnBook(BorrowInfoModel borrowInfoModel) async {
    BorrowInfo? findBorrowInfo = list.firstWhereOrNull((e) => e.id == borrowInfoModel.id);

    if (findBorrowInfo == null) {
      return const Error(errNotFoundBorrowInfo);
    }

    Result<Book> findBook = await bookRepository.findById(findBorrowInfo.bookId);
    if (findBook is Error<Book>) {
      return Error(findBook.error);
    }

    Result<Book> returnBook = await bookRepository.returns((findBook as Success).data);
    if (returnBook is Error<Book>) {
      return Error(returnBook.error);
    }

    findBorrowInfo.setReturn();
    await saveFile();

    return Success(findBorrowInfo);
  }

  @override
  Future<Result<BorrowInfo>> renewalBook(BorrowInfoModel borrowInfoModel) async {
    BorrowInfo? findBorrowInfo = list.firstWhereOrNull((e) => e.id == borrowInfoModel.id);

    if (findBorrowInfo == null) {
      return const Error(errNotFoundBorrowInfo);
    }

    String addDateString = DateTime(
        int.parse(findBorrowInfo.expireDate.substring(0, 4)),
        int.parse(findBorrowInfo.expireDate.substring(4, 6)),
        int.parse(findBorrowInfo.expireDate.substring(6, 8))
    ).add(const Duration(days: expireMaximumDate - expireDefaultDate)).dFormat();

    findBorrowInfo.renewalDate(addDateString);
    await saveFile();

    return Success(findBorrowInfo);
  }
}