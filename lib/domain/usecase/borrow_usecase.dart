import 'package:orm_library_manager/common/result.dart';
import 'package:orm_library_manager/domain/model/book.dart';
import 'package:orm_library_manager/domain/model/borrow_info.dart';
import 'package:orm_library_manager/domain/model/member.dart';
import 'package:orm_library_manager/domain/repository/borrow_repository.dart';

class BorrowUseCase {
  final BorrowRepository borrowRepository;

  const BorrowUseCase({
    required this.borrowRepository,
  });

  Future<Result<BorrowInfo>> borrowBook(Member member, Book book) {
    return borrowRepository.borrowBook(member, book);
  }

  Future<Result<List<BorrowInfo>>> getBorrowList({required bool containFinish}) async {
    Result<List<BorrowInfo>> result = await borrowRepository.getAll();

    switch (result) {
      case Success<List<BorrowInfo>>(:final data):

        if(!containFinish) {
          final List<BorrowInfo> newList = result.data.toList()..removeWhere((element) => element.isFinished);
          return Success(newList);
        }
        return result;

      case Error(:final error):
        return Error(error);
    }
  }
}