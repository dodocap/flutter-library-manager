import 'package:orm_library_manager/common/result.dart';
import 'package:orm_library_manager/domain/dto/book.dart';

abstract interface class BookRepository {
  Future<Result<List<Book>>> getAllBooks();
  Future<Result<Book>> findById(int id);
  Future<Result<Book>> add(Book book);
  Future<Result<Book>> remove(Book book);
  Future<Result<Book>> borrow(Book book);
  Future<Result<Book>> returns(Book book);
}