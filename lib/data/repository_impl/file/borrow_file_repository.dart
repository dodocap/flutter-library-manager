import 'dart:io';

import 'package:orm_library_manager/common/common.dart';
import 'package:orm_library_manager/common/constants.dart';
import 'package:orm_library_manager/common/repositories.dart';
import 'package:orm_library_manager/common/result.dart';
import 'package:orm_library_manager/domain/model/book.dart';
import 'package:orm_library_manager/domain/model/borrow_info.dart';
import 'package:orm_library_manager/domain/model/borrow_info_model.dart';
import 'package:orm_library_manager/domain/model/member.dart';
import 'package:orm_library_manager/domain/repository/book_repository.dart';
import 'package:orm_library_manager/domain/repository/borrow_repository.dart';
import 'package:orm_library_manager/domain/repository/member_repository.dart';
import 'package:path_provider/path_provider.dart';

class BorrowFileRepository implements BorrowRepository {
  static final BorrowFileRepository _instance = BorrowFileRepository._internal();
  factory BorrowFileRepository() => _instance;
  BorrowFileRepository._internal() {
    _loadFile();
  }

  final List<BorrowInfo> _borrowList = [];
  File? _file;

  Future<void> _loadFile() async {
    final Directory directory = await getApplicationDocumentsDirectory();
    _file = File('${directory.path}/$borrowFileName');

    try {
      final String readString = await _file?.readAsString() ?? '';
      List<String> readLines = readString.split('\n');
      String readFirstRow = readLines.first.split(',').map((e) => e.trim()).join(',');

      if (readFirstRow == borrowFileRowString) {
        for(int i = 1; i < readLines.length; i++) {
          final List<String> commaSplitList = readLines[i].split(',').map((e) => e.trim().toLowerCase()).toList();
          if (commaSplitList.length == borrowFileColumnCount) {
            _borrowList.add(BorrowInfo.fromCSV(readLines[i].split(',').map((e) => e.trim().toLowerCase()).toList()));
          }
        }
        print(_borrowList);
      } else {
        // await _file?.delete();
      }
    } catch (e) {
      print(e);
      // await _file?.delete();
    }
  }

  Future<void> _saveFile() async {
    final StringBuffer stringBuffer = StringBuffer();
    stringBuffer.write('$borrowFileRowString\n');
    for (final borrow in _borrowList) {
      stringBuffer.write(borrow.toCSV());
    }
    await _file?.writeAsString(stringBuffer.toString());
  }


  @override
  Future<Result<List<BorrowInfoModel>>> getAll() async {
    final result = (await Future.wait(
        _borrowList.map((borrowInfo) async {
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
        _borrowList.map((borrowInfo) async {
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
    _borrowList.add(borrowInfo);
    await _saveFile();

    return Success(borrowInfo);
  }

  @override
  Future<Result<BorrowInfo>> returnBook(BorrowInfoModel borrowInfoModel) async {
    BorrowInfo? findBorrowInfo = _borrowList.firstWhereOrNull((e) => e.id == borrowInfoModel.id);

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
    await _saveFile();

    return Success(findBorrowInfo);
  }

  @override
  Future<Result<BorrowInfo>> renewalBook(BorrowInfoModel borrowInfoModel) async {
    BorrowInfo? findBorrowInfo = _borrowList.firstWhereOrNull((e) => e.id == borrowInfoModel.id);

    if (findBorrowInfo == null) {
      return const Error(errNotFoundBorrowInfo);
    }

    String addDateString = DateTime(
        int.parse(findBorrowInfo.expireDate.substring(0, 4)),
        int.parse(findBorrowInfo.expireDate.substring(4, 6)),
        int.parse(findBorrowInfo.expireDate.substring(6, 8))
    ).add(const Duration(days: expireMaximumDate - expireDefaultDate)).dFormat();

    findBorrowInfo.renewalDate(addDateString);
    await _saveFile();

    return Success(findBorrowInfo);
  }
}