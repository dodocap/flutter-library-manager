import 'package:flutter/material.dart';
import 'package:orm_library_manager/common/repositories.dart';
import 'package:orm_library_manager/common/result.dart';
import 'package:orm_library_manager/domain/model/book.dart';
import 'package:orm_library_manager/domain/model/borrow_info.dart';
import 'package:orm_library_manager/domain/model/member.dart';
import 'package:orm_library_manager/domain/usecase/borrow_usecase.dart';
import 'package:orm_library_manager/presenter/main/main_screen.dart';

class BorrowResultScreen extends StatefulWidget {
  final Member member;
  final Book book;

  const BorrowResultScreen({
    super.key,
    required this.member,
    required this.book,
  });

  @override
  State<BorrowResultScreen> createState() => _BorrowResultScreenState();
}

class _BorrowResultScreenState extends State<BorrowResultScreen> {
  final BorrowUseCase _borrowUseCase = BorrowUseCase(borrowRepository: borrowRepository);
  bool _isLoading = true;
  bool _isSuccess = false;
  late BorrowInfo _borrowInfo;

  @override
  void initState() {
    _borrowBook();

    super.initState();
  }

  Future<void> _borrowBook() async {
    Result<BorrowInfo> result = await _borrowUseCase.borrowBook(widget.member, widget.book);

    switch (result) {
      case Success<BorrowInfo>(:final data):
        _borrowInfo = data;
        _isSuccess = true;
        break;
      case Error(:final error):
        _isSuccess = false;
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
        title: const Text('대출 결과'),
      ),
      body: _isLoading
      ? const Center(child: CircularProgressIndicator())
      : Padding(
          padding: const EdgeInsets.all(16.0),
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  '${widget.member.name} 님의\n도서 대출 결과입니다',
                  textAlign: TextAlign.center,
                  style: const TextStyle(fontSize: 24.0),
                ),
                const SizedBox(height: 20),
                Text(
                  '제목 : ${widget.book.name}\n'
                  '반납기한 : ${_calculateExpireDate(_borrowInfo.expireDate)}',
                  textAlign: TextAlign.center,
                  style: const TextStyle(fontSize: 22.0),
                ),
                const SizedBox(height: 40),
                ElevatedButton(
                    onPressed: () {
                      Navigator.pushAndRemoveUntil(
                        context,
                        MaterialPageRoute(builder: (context) => const MainScreen()),
                        (route) => false,
                      );
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
