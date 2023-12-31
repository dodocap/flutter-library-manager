import 'package:flutter_test/flutter_test.dart';
import 'package:orm_library_manager/data/repository_impl/memory/book_memory_repository.dart';
import 'package:orm_library_manager/domain/dto/book.dart';
import 'package:orm_library_manager/domain/repository/book_repository.dart';

void main() {
  late BookRepository bookRepository;
  late Book book;

  // 전체 테스트시 1회 실행
  setUpAll(() {
    book = Book(
      name: '오준석의 플러터 생존코딩',
      price: '28000',
      isbn: '979-11-6224-437-1',
      publishDate: '2022-03-21',
    );
  });

  // 매 테스트마다 초기화 코드
  setUp(() async {
    bookRepository = BookMemoryRepository();
    await bookRepository.add(book);
  });

  test('도서 조회', () async {
    final List<Book> bookList = await bookRepository.getAllBooks();

    expect(bookList.length, 1);
    expect(bookList[0].name, '오준석의 플러터 생존코딩');
  });

  test('도서 추가', () async {
    final Book newBook = Book(
      name: 'RxJava 프로그래밍',
      price: '25000',
      isbn: '978-89-6848-865-8',
      publishDate: '2019-04-01',
    );

    final Book resultBook = await bookRepository.add(newBook);
    final List<Book> bookList = await bookRepository.getAllBooks();

    expect(bookList.length, 2);
    expect(newBook, resultBook);
    expect(bookList.last, resultBook);
  });

  test('도서 추가. 같은 도서여도 중복 추가 가능', () async {
    final Book newBook = Book(
      name: '오준석의 플러터 생존코딩',
      price: '28000',
      isbn: '979-11-6224-437-1',
      publishDate: '2022-03-21',
    );

    final Book resultBook = await bookRepository.add(newBook);
    final List<Book> bookList = await bookRepository.getAllBooks();

    expect(bookList.first.name, resultBook.name);
    expect(bookList.first.publishDate, resultBook.publishDate);
    expect(bookList.first.price, resultBook.price);
    expect(bookList.first.isBorrowed, resultBook.isBorrowed);
    expect(bookList.first.isbn, resultBook.isbn);
    expect(bookList.first, isNot(resultBook));
  });
}
