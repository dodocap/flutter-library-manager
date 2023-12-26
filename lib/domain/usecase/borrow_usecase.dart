import 'package:orm_library_manager/common/result.dart';
import 'package:orm_library_manager/domain/model/book.dart';
import 'package:orm_library_manager/domain/model/borrow_info.dart';
import 'package:orm_library_manager/domain/model/borrow_info_model.dart';
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

  Future<Result<List<BorrowInfoModel>>> getBorrowList({required bool containFinish}) async {
    Result<List<BorrowInfoModel>> result = await borrowRepository.getAll();

    switch (result) {
      case Success<List<BorrowInfoModel>>(:final data):

        if(!containFinish) {
          final List<BorrowInfoModel> newList = result.data.toList()..removeWhere((element) => element.isFinished);
          return Success(newList);
        }
        return result;

      case Error(:final error):
        return Error(error);
    }
  }
}