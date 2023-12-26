import 'package:flutter/material.dart';
import 'package:orm_library_manager/domain/model/book.dart';
import 'package:orm_library_manager/domain/model/member.dart';
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
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('대출 결과'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text('${widget.member.name} 님의\n도서 대출 결과입니다', textAlign: TextAlign.center, style: const TextStyle(fontSize: 24.0),),
              const SizedBox(height: 20),
              Text('제목 : ${widget.book.name}\n'
                  '반납기한 : ${widget.book.publishDate}', textAlign: TextAlign.center, style: const TextStyle(fontSize: 22.0),),
              const SizedBox(height: 40),
              ElevatedButton(onPressed: () {
                Navigator.pushAndRemoveUntil(
                  context,
                  MaterialPageRoute(builder: (context) => const MainScreen()),
                      (route) => false,
                );
              }, child: const Padding(
                padding: EdgeInsets.all(8.0),
                child: Text('돌아가기', style: TextStyle(fontSize: 22),),
              )),
              const SizedBox(height: 64,)
            ],
          ),
        ),
      ),
    );
  }
}
