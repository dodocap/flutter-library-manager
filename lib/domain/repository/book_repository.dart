import 'package:orm_library_manager/common/result.dart';
import 'package:orm_library_manager/domain/model/book.dart';

abstract interface class BookRepository {
  Future<Result<List<Book>>> getAllBooks();
  Future<Result<Book>> add(Book book);
  Future<Result<Book>> remove(Book book);
}