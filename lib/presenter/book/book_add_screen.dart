import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:orm_library_manager/common/common.dart';
import 'package:orm_library_manager/common/repositories.dart';
import 'package:orm_library_manager/common/result.dart';
import 'package:orm_library_manager/domain/dto/book.dart';
import 'package:orm_library_manager/domain/usecase/book_usecase.dart';

class BookAddScreen extends StatefulWidget {
  const BookAddScreen({super.key});

  @override
  State<BookAddScreen> createState() => _BookAddScreenState();
}

class _BookAddScreenState extends State<BookAddScreen> {
  final BookUseCase _bookUseCase = BookUseCase(bookRepository: bookRepository);

  final _textNameController = TextEditingController();
  final _textPublishDateController = TextEditingController();
  final _textISBNController = TextEditingController();
  final _textPriceController = TextEditingController();

  String _errorMessage = '';

  @override
  void dispose() {
    _textNameController.dispose();
    _textPublishDateController.dispose();
    _textISBNController.dispose();
    _textPriceController.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('도서 추가'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _textNameController,
              decoration: InputDecoration(
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10.0),
                ),
                hintText: '도서명',
                hintStyle: TextStyle(color: Colors.grey[800]),
                filled: true,
                fillColor: Colors.white70,
              ),
            ),
            const SizedBox(height: 24),
            TextField(
              controller: _textPublishDateController,
              decoration: InputDecoration(
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10.0),
                ),
                hintText: '발행일(YYYYMMDD)',
                hintStyle: TextStyle(color: Colors.grey[800]),
                filled: true,
                fillColor: Colors.white70,
              ),
              keyboardType: TextInputType.number,
              inputFormatters: [
                FilteringTextInputFormatter.digitsOnly,
                LengthLimitingTextInputFormatter(8),
              ],
            ),
            const SizedBox(height: 24),
            TextField(
              controller: _textISBNController,
              decoration: InputDecoration(
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10.0),
                ),
                hintText: 'ISBN(13자리)',
                hintStyle: TextStyle(color: Colors.grey[800]),
                filled: true,
                fillColor: Colors.white70,
              ),
              keyboardType: TextInputType.number,
              inputFormatters: [
                FilteringTextInputFormatter.digitsOnly,
                LengthLimitingTextInputFormatter(13),
              ],
            ),
            const SizedBox(height: 24),
            TextField(
              controller: _textPriceController,
              decoration: InputDecoration(
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10.0),
                ),
                hintText: '가격',
                hintStyle: TextStyle(color: Colors.grey[800]),
                filled: true,
                fillColor: Colors.white70,
              ),
              keyboardType: TextInputType.number,
              inputFormatters: [
                FilteringTextInputFormatter.digitsOnly,
              ],
            ),
            const SizedBox(height: 24),
            Text(
              _errorMessage,
              style: const TextStyle(color: Colors.red, fontSize: 16, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 24),
            ElevatedButton(
              onPressed: () {
                _onPressedAddButton();
              },
              child: const Padding(
                padding: EdgeInsets.all(8.0),
                child: Text(
                  '도서 추가',
                  style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
  Future<void> _onPressedAddButton() async {
    final Result<Book> result = await _bookUseCase.addBook(
      name: _textNameController.text,
      publishDate: _textPublishDateController.text,
      isbn: _textISBNController.text,
      price: _textPriceController.text,
    );

    switch(result) {
      case Success(:final data):
        if (mounted) {
          showSimpleDialog(context, '${data.name}\n도서가 추가되었습니다', () {
            Navigator.pop(context, true);
          });
        }
        break;
      case Error(:final error):
        setState(() {
          _errorMessage = error;
        });
        break;
    }
  }
}
