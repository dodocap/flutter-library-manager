import 'dart:math';
import 'package:orm_library_manager/domain/model/book.dart';
import 'package:orm_library_manager/domain/repository/book_repository.dart';

class BookMemoryRepository implements BookRepository {
  final List<Book> _bookList = [];

  Future<void> _virtualDelayed() async {
    await Future.delayed(Duration(milliseconds: Random().nextInt(150) + 150));
  }

  @override
  Future<List<Book>> getAllBooks() async {
    await _virtualDelayed();
    return _bookList;
  }

  @override
  Future<Book> add(Book book) async {
    await _virtualDelayed();
    _bookList.add(book);
    return book;
  }

  @override
  Future<void> remove(Book book) async {
    return Future.value();
  }

  @override
  Future<void> update(Book book) async {
    return Future.value();
  }

}