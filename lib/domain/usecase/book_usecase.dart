import 'package:orm_library_manager/common/result.dart';
import 'package:orm_library_manager/domain/dto/book.dart';
import 'package:orm_library_manager/domain/repository/book_repository.dart';

class BookUseCase {
  final BookRepository bookRepository;

  const BookUseCase({
    required this.bookRepository,
  });

  Future<Result<List<Book>>> getBookList({required bool canBorrow}) async {
    Result<List<Book>> result = await bookRepository.getAllBooks();

    if(canBorrow && result is Success<List<Book>>) {
      List<Book> newList = result.data.toList()..removeWhere((element) => element.isBorrowed);
      return Success(newList);
    }

    return result;
  }

  Future<Result<Book>> addBook({
    required String name,
    required String publishDate,
    required String isbn,
    required String price,
  }) async {
    if (name.isEmpty) {
      return const Error('도서명을 입력해주세요');
    }
    if (publishDate.isEmpty) {
      return const Error('발행일을 입력해주세요');
    }
    if (publishDate.length != 8) {
      return const Error('발행일을 올바르게 입력해주세요');
    }
    if (isbn.isEmpty) {
      return const Error('ISBN을 입력해주세요');
    }
    if (isbn.length != 13) {
      return const Error('ISBN을 올바르게 입력해주세요');
    }
    if (price.isEmpty) {
      return const Error('가격을 입력해주세요');
    }

    return bookRepository.add(Book(name: name, price: price, isbn: isbn, publishDate: publishDate));
  }

  Future<Result<Book>> removeBook(Book book) async {
    return bookRepository.remove(book);
  }
}
