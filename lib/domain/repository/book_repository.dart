import 'package:orm_library_manager/domain/model/book.dart';

abstract interface class BookRepository {
  Future<List<Book>> getAllBooks();
  Future<Book> add(Book book);
  Future<void> remove(Book book);
  Future<void> update(Book book);
}