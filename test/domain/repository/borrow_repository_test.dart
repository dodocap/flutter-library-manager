import 'package:flutter_test/flutter_test.dart';
import 'package:orm_library_manager/common/common.dart';
import 'package:orm_library_manager/common/constants.dart';
import 'package:orm_library_manager/data/repository_impl/book_memory_repository.dart';
import 'package:orm_library_manager/data/repository_impl/borrow_memory_repository.dart';
import 'package:orm_library_manager/data/repository_impl/member_memory_repository.dart';
import 'package:orm_library_manager/domain/model/book.dart';
import 'package:orm_library_manager/domain/model/borrow_info.dart';
import 'package:orm_library_manager/domain/model/member.dart';
import 'package:orm_library_manager/domain/repository/book_repository.dart';
import 'package:orm_library_manager/domain/repository/borrow_repository.dart';
import 'package:orm_library_manager/domain/repository/member_repository.dart';

void main() {
  late MemberRepository memberRepository;
  late Member member1;
  late Member member2;

  late BookRepository bookRepository;
  late Book book1;
  late Book book2;

  late BorrowRepository borrowRepository;
  late BorrowInfo borrowInfo;

  setUp(() async {
    book1 = Book(
      name: '오준석의 플러터 생존코딩',
      price: '28000',
      isbn: '979-11-6224-437-1',
      publicationDate: '2022-03-21',
    );

    book2 = Book(
      name: 'RxJava 프로그래밍',
      price: '25000',
      isbn: '978-89-6848-865-8',
      publicationDate: '2019-04-01',
    );

    member1 = Member(
      name: '홍길동',
      address: '서울',
      contact: '010-1234-5678',
      birthDate: '2023-01-01',
      gender: Gender.male,
    );

    member2 = Member(name: '홍길순',
      address: '인천',
      contact: '010-1234-1234',
      birthDate: '1999-12-31',
      gender: Gender.female,
    );

    bookRepository = BookMemoryRepository();
    await bookRepository.add(book1);
    await bookRepository.add(book2);

    memberRepository = MemberMemoryRepository();
    await memberRepository.join(member1);
    await memberRepository.join(member2);

    borrowRepository = BorrowMemoryRepository();
  });

  test('책 대여 정보 조회', () async {
    final List<BorrowInfo> borrowHistoryList = await borrowRepository.getAllHistory();
    expect(borrowHistoryList.length, 0);

    BorrowInfo borrowInfo = await borrowRepository.borrowBook(member1, book1);
    final List<BorrowInfo> borrowList = await borrowRepository.getAllBorrows();
    expect(borrowList.length, 1);
    expect(borrowList.first, borrowInfo);
    expect(borrowList.first.memberId, member1.id);
    expect(borrowList.first.bookId, book1.id);
  });

  test('책 대여 후 반납 조회', () async {
    BorrowInfo borrowInfo = await borrowRepository.borrowBook(member1, book1);

    expect(borrowInfo.isFinished, false);
    expect(borrowInfo.returnDate, isNull);

    BorrowInfo returnInfo = await borrowRepository.returnBook(member1, book1);

    expect(borrowInfo, returnInfo);
    expect(returnInfo.isFinished, true);
    expect(returnInfo.returnDate, isNotNull);

    final List<BorrowInfo> historyList = await borrowRepository.getAllHistory();
    expect(historyList.length, 1);

    final List<BorrowInfo> borrowList = await borrowRepository.getAllBorrows();
    expect(borrowList.length, 0);
  });

  test('이미 대여중인 도서는 대여가 불가능하다', () async {
    BorrowInfo borrowInfo1 = await borrowRepository.borrowBook(member1, book1);

    try {
      await borrowRepository.borrowBook(member2, book1);
    } catch (e) {
      expect(e, errAlreadyBorrowed);
    }
  });

  test('대여이력이 없는 도서는 반납할 수 없다', () async {
    BorrowInfo borrowInfo1 = await borrowRepository.borrowBook(member1, book1);

    try {
      await borrowRepository.returnBook(member1, book2);
    } catch (e) {
      expect(e, errNotFoundBorrowInfo);
    }
  });
}
