import 'package:orm_library_manager/common/constants.dart';
import 'package:orm_library_manager/common/result.dart';
import 'package:orm_library_manager/domain/dto/book.dart';
import 'package:orm_library_manager/domain/dto/borrow_info.dart';
import 'package:orm_library_manager/domain/dto/member.dart';
import 'package:orm_library_manager/domain/model/borrow_info_model.dart';
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

  Future<Result<List<BorrowInfoModel>>> getBorrowListByMember({required Member member}) async {
    Result<List<BorrowInfoModel>> result = await borrowRepository.getByMember(member);

    switch (result) {
      case Success<List<BorrowInfoModel>>(:final data):
        final List<BorrowInfoModel> newList = data.toList()..removeWhere((element) => element.isFinished);
      return Success(newList);
      case Error(:final error):
        return Error(error);
    }
  }

  Future<Result<BorrowInfo>> returnBook(BorrowInfoModel borrowInfoModel) async {
    return borrowRepository.returnBook(borrowInfoModel);
  }

  Future<Result<BorrowInfo>> renewalBook(BorrowInfoModel borrowInfoModel) async {
    bool canRenewal = _canRenewal(borrowInfoModel.borrowDate, borrowInfoModel.expireDate);

    if (!canRenewal) {
      return const Error(errNotAnymoreRenewal);
    }

    return borrowRepository.renewalBook(borrowInfoModel);
  }

  bool _canRenewal(String borrowDateString, String expireDateString) {
    int borrowYear = int.parse(borrowDateString.substring(0, 4));
    int borrowMonth = int.parse(borrowDateString.substring(4, 6));
    int borrowDay = int.parse(borrowDateString.substring(6, 8));

    int expireYear = int.parse(expireDateString.substring(0, 4));
    int expireMonth = int.parse(expireDateString.substring(4, 6));
    int expireDay = int.parse(expireDateString.substring(6, 8));

    final DateTime borrowDate = DateTime(borrowYear, borrowMonth, borrowDay);
    final DateTime expireDate = DateTime(expireYear, expireMonth, expireDay);

    return expireDate.difference(borrowDate).inDays == expireDefaultDate;
  }
}