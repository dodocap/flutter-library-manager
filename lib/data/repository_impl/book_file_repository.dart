import 'dart:io';

import 'package:orm_library_manager/common/constants.dart';
import 'package:orm_library_manager/common/result.dart';
import 'package:orm_library_manager/domain/model/book.dart';
import 'package:orm_library_manager/domain/repository/book_repository.dart';
import 'package:path_provider/path_provider.dart';

class BookFileRepository implements BookRepository {
  static final BookFileRepository _instance = BookFileRepository._internal();
  factory BookFileRepository() => _instance;
  BookFileRepository._internal() {
    _loadFile();
  }

  final List<Book> _bookList = [];
  File? _file;

  Future<void> _loadFile() async {
    final Directory directory = await getApplicationDocumentsDirectory();
    _file = File('${directory.path}/$bookFileName');

    try {
      final String readString = await _file?.readAsString() ?? '';
      List<String> readLines = readString.split('\n');
      String readFirstRow = readLines.first.split(',').map((e) => e.trim()).join(',');

      if (readFirstRow == bookFileRowString) {
        for(int i = 1; i < readLines.length; i++) {
          final List<String> commaSplitList = readLines[i].split(',').map((e) => e.trim().toLowerCase()).toList();
          if (commaSplitList.length == bookFileColumnCount) {
            _bookList.add(Book.fromCSV(readLines[i].split(',').map((e) => e.trim().toLowerCase()).toList()));
          }
        }
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
    stringBuffer.write('$bookFileRowString\n');
    for (final book in _bookList) {
      stringBuffer.write(book.toCSV());
    }
    await _file?.writeAsString(stringBuffer.toString());
  }

  @override
  Future<Result<Book>> add(Book book) async {
    _bookList.add(book);

    await _saveFile();
    return Success(book);
  }

  @override
  Future<Result<List<Book>>> getAllBooks() async {
    return Success(_bookList);
  }

  @override
  Future<Result<Book>> remove(Book book) async {
    if (!_bookList.contains(book)) {
      return const Error(errNotFoundBook);
    }

    if (!_bookList.remove(book)) {
      return const Error(errFailedRemoveBook);
    }

    await _saveFile();

    return Success(book);
  }
}