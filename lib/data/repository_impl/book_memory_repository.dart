import 'dart:math';
import 'package:orm_library_manager/common/result.dart';
import 'package:orm_library_manager/domain/model/book.dart';
import 'package:orm_library_manager/domain/repository/book_repository.dart';

class BookMemoryRepository implements BookRepository {
  final List<Book> _bookList = [];

  Future<void> _virtualDelayed() async {
    await Future.delayed(Duration(milliseconds: Random().nextInt(150) + 150));
  }

  @override
  Future<Result<List<Book>>> getAllBooks() async {
    await _virtualDelayed();

    return Success(_bookList);
  }

  @override
  Future<Result<Book>> add(Book book) async {
    await _virtualDelayed();
    _bookList.add(book);
    return Success(book);
  }

  @override
  Future<Result<Book>> remove(Book book) async {
    return Success(book);
  }

  @override
  Future<Result<Book>> borrow(Book book) async {
    return const Error('');
  }

  @override
  Future<Result<Book>> returns(Book book) async {
    return const Error('');
  }
}