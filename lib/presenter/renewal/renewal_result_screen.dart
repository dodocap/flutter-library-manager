import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:orm_library_manager/common/repositories.dart';
import 'package:orm_library_manager/common/result.dart';
import 'package:orm_library_manager/domain/model/borrow_info.dart';
import 'package:orm_library_manager/domain/model/borrow_info_model.dart';
import 'package:orm_library_manager/domain/usecase/borrow_usecase.dart';

class RenewalResultScreen extends StatefulWidget {
  final BorrowInfoModel borrowInfoModel;

  const RenewalResultScreen({super.key, required this.borrowInfoModel});

  @override
  State<RenewalResultScreen> createState() => _RenewalResultScreenState();
}

class _RenewalResultScreenState extends State<RenewalResultScreen> {
  final BorrowUseCase _borrowUseCase = BorrowUseCase(borrowRepository: borrowRepository);

  late BorrowInfo _borrowInfo;
  bool _isLoading = true;
  bool _isSuccess = true;
  String errorMsg = '';

  @override
  void initState() {
    _renewalBook();

    super.initState();
  }

  Future<void> _renewalBook() async {
    Result<BorrowInfo> result = await _borrowUseCase.renewalBook(widget.borrowInfoModel);
    switch (result) {
      case Success<BorrowInfo>(:final data):
        _borrowInfo = data;
        _isSuccess = true;
        break;
      case Error(:final error):
        _isSuccess = false;
        errorMsg = error;
        break;
    }

    setState(() {
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('연장 결과'),
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : !_isSuccess
            ? Center(child: Text(errorMsg, style: const TextStyle(fontSize: 36, fontWeight: FontWeight.bold, color: Colors.grey)))
            : Padding(
              padding: const EdgeInsets.all(16.0),
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      '${widget.borrowInfoModel.memberName} 님의\n도서 연장 결과입니다',
                      textAlign: TextAlign.center,
                      style: const TextStyle(fontSize: 24.0),
                    ),
                    const SizedBox(height: 20),
                    Text(
                      '제목 : ${widget.borrowInfoModel.bookName}\n'
                          '만료일 : ${_calculateExpireDate(_borrowInfo.expireDate)}',
                      textAlign: TextAlign.center,
                      style: const TextStyle(fontSize: 22.0),
                    ),
                    const SizedBox(height: 40),
                    ElevatedButton(
                        onPressed: () {
                          context.go(Uri(path: '/').toString());
                        },
                        child: const Padding(
                          padding: EdgeInsets.all(8.0),
                          child: Text(
                            '돌아가기',
                            style: TextStyle(fontSize: 22),
                          ),
                        )),
                    const SizedBox(
                      height: 64,
                    ),
                  ],
                ),
              ),
            ),
        );
  }
  String _calculateExpireDate(String expireDate) {
    String year = expireDate.substring(0, 4);
    String month = expireDate.substring(4, 6);
    String day = expireDate.substring(6, 8);

    return '$year-$month-$day';
  }
}
