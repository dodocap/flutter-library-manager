import 'package:flutter/material.dart';
import 'package:orm_library_manager/common/common.dart';
import 'package:orm_library_manager/common/constants.dart';
import 'package:orm_library_manager/common/repositories.dart';
import 'package:orm_library_manager/common/result.dart';
import 'package:orm_library_manager/domain/model/book.dart';
import 'package:orm_library_manager/domain/usecase/book_usecase.dart';
import 'package:orm_library_manager/presenter/book/book_add_screen.dart';
import 'package:sticky_headers/sticky_headers/widget.dart';

class BookListScreen extends StatefulWidget {
  const BookListScreen({super.key});

  @override
  State<BookListScreen> createState() => _BookListScreenState();
}

class _BookListScreenState extends State<BookListScreen> {
  final BookUseCase _bookUseCase = BookUseCase(bookRepository: bookRepository);
  List<Book> _bookList = [];
  bool _sortAscending = true;
  int _sortColumnIndex = 0;

  @override
  void initState() {
    _loadBookList();
    super.initState();
  }

  Future<void> _loadBookList() async {
    Result<List<Book>> memberList = await _bookUseCase.getBookList();

    switch (memberList) {
      case Success<List<Book>>(:final data):
        _bookList = data;
        _onSortColumn(_sortColumnIndex);
        break;
      case Error(:final error):
        if(context.mounted) {
          showSimpleDialog(context, error);
        }
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text('도서 조회'),
        actions: [
          IconButton(
            icon: const Icon(Icons.bookmark_add_outlined),
            onPressed: () async {
              bool? result = await Navigator.push(context, MaterialPageRoute(builder: (context) => const BookAddScreen()));
              if(result != null && result) {
                await _loadBookList();
              }
            },
          ),
        ],
      ),
      body: _bookList.isEmpty
          ? const Center(child: Text('도서 목록 없음', style: TextStyle(fontSize: 48, fontWeight: FontWeight.bold, color: Colors.grey)))
          : SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: StickyHeader(
                header: DataTable(
                  columnSpacing: 0,
                  horizontalMargin: 0,
                  sortAscending: _sortAscending,
                  sortColumnIndex: _sortColumnIndex,
                  showBottomBorder: true,
                  columns: bookFileRowStringList.map((e) {
                    return DataColumn(
                      label: SizedBox(
                          width: 102,
                          child: Text(e, textAlign: TextAlign.center)
                      ),
                      onSort: (columnIndex, ascending) {
                        _sortColumnIndex = columnIndex;
                        _sortAscending = ascending;
                        _onSortColumn(columnIndex);
                      },
                    );
                  }).toList(),
                  rows: List.empty(),
                ),
                content: SingleChildScrollView(
                  child: DataTable(
                    columnSpacing: 0,
                    horizontalMargin: 0,
                    headingRowHeight: 0,
                    columns: List.generate(5, (index) => const DataColumn(label: Spacer())),
                    rows: _bookList.map((book) {
                      return DataRow(
                          cells: [
                            DataCell(SizedBox(
                              width: 120,
                              child: Text(book.name, textAlign: TextAlign.center),
                            )),
                            DataCell(SizedBox(
                              width: 120,
                              child: Text(book.publishDate, textAlign: TextAlign.center),
                            )),
                            DataCell(SizedBox(
                              width: 120,
                              child: Text(book.isbn, textAlign: TextAlign.center),
                            )),
                            DataCell(SizedBox(
                              width: 120,
                              child: Text(book.isBorrowed ? '대여중' : '대여가능', textAlign: TextAlign.center),
                            )),
                            DataCell(SizedBox(
                              width: 120,
                              child: Text(book.price, textAlign: TextAlign.center),
                            )),
                          ],
                          onLongPress: () {
                            _showDeleteBookDialog(book);
                          });
                    }).toList(),
                  ),
                ),
              ),
            ),
    );
  }
  void _onSortColumn(int columnIndex) {
    setState(() {
      switch (columnIndex) {
        case 0:
          _bookList.sort((a, b) => _sortStringColumn(a.name, b.name));
          break;
        case 1:
          _bookList.sort((a, b) => _sortStringColumn(a.publishDate, b.publishDate));
          break;
        case 2:
          _bookList.sort((a, b) => _sortStringColumn(a.isbn, b.isbn));
          break;
        case 3:
          _bookList.sort((a, b) => _sortStringColumn(a.isBorrowed.toString(), b.isBorrowed.toString()));
          break;
        case 4:
          _bookList.sort((a, b) => _sortStringColumn(a.price, b.price));
          break;
      }

      if (!_sortAscending) {
        _bookList = _bookList.reversed.toList();
      }
    });
  }

  int _sortStringColumn(String a, String b) {
    final aValue = _sortAscending ? a.toLowerCase() : a.toUpperCase();
    final bValue = _sortAscending ? b.toLowerCase() : b.toUpperCase();
    return aValue.compareTo(bValue);
  }

  void _showDeleteBookDialog(Book book) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Center(child: Text('${book.name} 도서를\n삭제하시겠습니까?')),
          content: Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text('취소', style: TextStyle(color: Colors.black87),),
              ),
              TextButton(
                onPressed: () {
                  Navigator.pop(context);
                  _removeBook(book);
                },
                child: const Text('삭제', style: TextStyle(color: Colors.red, fontWeight: FontWeight.bold),),
              ),
            ],
          ),
        );
      },
    );
  }
  Future<void> _removeBook(Book book) async {
    final Result<Book> result = await _bookUseCase.removeBook(book);

    switch(result) {
      case Success<Book>(:final data):
        if(context.mounted) {
          showSimpleDialog(context, '${data.name} 삭제 성공', () {
            setState(() {
              _bookList.remove(data);
            });
          });
        }
        break;
      case Error(:final error):
        if (context.mounted) {
          showSimpleDialog(context, error);
        }
        break;
    }
  }
}
