import 'dart:io';

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

  final BookRepository _bookRepository = bookRepository;
  final MemberRepository _memberRepository = memberRepository;
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
    final sw = Stopwatch()..start();
    final result = (await Future.wait(
        _borrowList.map((borrowInfo) async {
          Result<Book> book = await _bookRepository.findById(borrowInfo.bookId);
          Result<Member> member = await _memberRepository.findById(borrowInfo.memberId);

          if(book is Success<Book> && member is Success<Member>) {
            return BorrowInfoModel(
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

    print('getAllElapsedTime : ${sw.elapsed}');

    return Success(result);
  }

  @override
  Future<Result<BorrowInfo>> borrowBook(Member member, Book book) async {
    if(book.isBorrowed) {
      return const Error(errAlreadyBorrowed);
    }

    Result<Book> result = await bookRepository.borrow(book);
    if(result is Error) {
      return Error((result as Error).error);
    }

    final BorrowInfo borrowInfo = BorrowInfo(memberId: member.id, bookId: book.id);
    _borrowList.add(borrowInfo);
    await _saveFile();

    return Success(borrowInfo);
  }

  @override
  Future<Result<BorrowInfo>> returnBook(Member member, Book book) async {
    return const Error('');
  }

  @override
  Future<Result<BorrowInfo>> renewalBook(Member member, Book book) async {
    return const Error('');
  }
}