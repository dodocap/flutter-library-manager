import 'package:orm_library_manager/common/common.dart';
import 'package:orm_library_manager/common/constants.dart';
import 'package:orm_library_manager/common/result.dart';
import 'package:orm_library_manager/data/repository_impl/file/base_file_repository.dart';
import 'package:orm_library_manager/domain/model/book.dart';
import 'package:orm_library_manager/domain/repository/book_repository.dart';

class BookFileRepository extends BaseFileRepository<Book> implements BookRepository {
  static final BookFileRepository _instance = BookFileRepository._internal(bookFileName, bookFileRowString);
  factory BookFileRepository() => _instance;
  BookFileRepository._internal(super.fileName, super.fileRowString);

  @override
  Book fromCSV(List<String> splitStringList) {
    return Book.fromCSV(splitStringList);
  }

  @override
  Future<Result<Book>> add(Book book) async {
    list.add(book);

    await saveFile();
    return Success(book);
  }

  @override
  Future<Result<List<Book>>> getAllBooks() async {
    return Success(list);
  }

  @override
  Future<Result<Book>> findById(int id) async {
    Book? findBook = list.firstWhereOrNull((book) => book.id == id);
    if(findBook == null) {
      return const Error(errNotFoundBook);
    }

    return Success(findBook);
  }

  @override
  Future<Result<Book>> remove(Book book) async {
    if (!list.contains(book)) {
      return const Error(errNotFoundBook);
    }

    if (!list.remove(book)) {
      return const Error(errFailedRemoveBook);
    }

    await saveFile();

    return Success(book);
  }

  @override
  Future<Result<Book>> borrow(Book book) async {
    if(book.isBorrowed) {
      return const Error(errAlreadyBorrowed);
    }

    Book? findBook = list.firstWhereOrNull((e) => e == book);
    if (findBook == null) {
      return const Error(errNotFoundBook);
    }

    findBook.setBorrowed = true;
    await saveFile();

    return Success(book);
  }

  @override
  Future<Result<Book>> returns(Book book) async {
    if(!book.isBorrowed) {
      return const Error(errAlreadyReturned);
    }

    Book? findBook = list.firstWhereOrNull((e) => e == book);
    if (findBook == null) {
      return const Error(errNotFoundBook);
    }

    findBook.setBorrowed = false;
    await saveFile();

    return Success(book);
  }


}