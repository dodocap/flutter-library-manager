import 'package:flutter/material.dart';
import 'package:orm_library_manager/common/repositories.dart';
import 'package:orm_library_manager/common/result.dart';
import 'package:orm_library_manager/domain/model/borrow_info.dart';
import 'package:orm_library_manager/domain/model/borrow_info_model.dart';
import 'package:orm_library_manager/domain/usecase/borrow_usecase.dart';

class ReturnResultScreen extends StatefulWidget {
  final BorrowInfoModel borrowInfoModel;

  const ReturnResultScreen({super.key, required this.borrowInfoModel});

  @override
  State<ReturnResultScreen> createState() => _ReturnResultScreenState();
}

class _ReturnResultScreenState extends State<ReturnResultScreen> {
  final BorrowUseCase _borrowUseCase = BorrowUseCase(borrowRepository: borrowRepository);

  @override
  void initState() {
    _returnBook();

    super.initState();
  }

  Future<void> _returnBook() async {
    Result<BorrowInfo> result = await _borrowUseCase.returnBook(widget.borrowInfoModel);

    print(result);
    switch (result) {
      case Success<BorrowInfo>(:final data):
        break;
      case Error(:final error):
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(

    );
  }
}
