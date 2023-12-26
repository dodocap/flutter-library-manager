import 'package:flutter/material.dart';
import 'package:orm_library_manager/common/constants.dart';
import 'package:orm_library_manager/common/repositories.dart';
import 'package:orm_library_manager/common/result.dart';
import 'package:orm_library_manager/domain/model/borrow_info.dart';
import 'package:orm_library_manager/domain/model/borrow_info_model.dart';
import 'package:orm_library_manager/domain/usecase/book_usecase.dart';
import 'package:orm_library_manager/domain/usecase/borrow_usecase.dart';
import 'package:orm_library_manager/domain/usecase/member_usecase.dart';
import 'package:sticky_headers/sticky_headers/widget.dart';

class BorrowListScreen extends StatefulWidget {
  const BorrowListScreen({super.key});

  @override
  State<BorrowListScreen> createState() => _BorrowListScreenState();
}

class _BorrowListScreenState extends State<BorrowListScreen> {
  final BorrowUseCase _borrowUseCase = BorrowUseCase(borrowRepository: borrowRepository);

  List<BorrowInfoModel> _borrowList = [];
  bool _sortAscending = true;
  int _sortColumnIndex = 0;

  @override
  void initState() {
    _loadBorrowList();

    super.initState();
  }

  Future<void> _loadBorrowList() async {
    Result<List<BorrowInfoModel>> result = await _borrowUseCase.getBorrowList(containFinish: true);
    switch (result) {
      case Success<List<BorrowInfoModel>>(:final data):
        setState(() {
          _borrowList = data;
        });
        break;
      case Error(:final error):
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('대출 현황'),
      ),
      body: _borrowList.isEmpty
        ? const Center(child: Text('대출 목록 없음', style: TextStyle(fontSize: 48, fontWeight: FontWeight.bold, color: Colors.grey)))
        : SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: StickyHeader(
          header: DataTable(
            columnSpacing: 0,
            horizontalMargin: 0,
            sortAscending: _sortAscending,
            sortColumnIndex: _sortColumnIndex,
            showBottomBorder: true,
            columns: borrowFileRowStringList.map((e) {
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
              rows: _borrowList.map((borrowInfo) {
                return DataRow(
                    cells: [
                      DataCell(SizedBox(
                        width: 120,
                        child: Text(borrowInfo.memberName, textAlign: TextAlign.center),
                      )),
                      DataCell(SizedBox(
                        width: 120,
                        child: Text(borrowInfo.bookName, textAlign: TextAlign.center),
                      )),
                      DataCell(SizedBox(
                        width: 120,
                        child: Text(_getFormattedDate(borrowInfo.borrowDate), textAlign: TextAlign.center),
                      )),
                      DataCell(SizedBox(
                        width: 120,
                        child: Text(_getFormattedDate(borrowInfo.expireDate), textAlign: TextAlign.center),
                      )),
                      DataCell(SizedBox(
                        width: 120,
                        child: Text(
                            (borrowInfo.returnDate == null || borrowInfo.returnDate == 'null')
                            ? '미반납'
                            : _getFormattedDate(borrowInfo.returnDate!), textAlign: TextAlign.center),
                      )),
                    ],
                    onLongPress: () {

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
          _borrowList.sort((a, b) => _sortStringColumn(a.memberName, b.memberName));
          break;
        case 1:
          _borrowList.sort((a, b) => _sortStringColumn(a.bookName, b.bookName));
          break;
        case 2:
          _borrowList.sort((a, b) => _sortStringColumn(a.borrowDate, b.borrowDate));
          break;
        case 3:
          _borrowList.sort((a, b) => _sortStringColumn(a.expireDate, b.expireDate));
          break;
        case 4:
          _borrowList.sort((a, b) => _sortStringColumn(a.returnDate ?? '미반납', b.returnDate ?? '미반납'));
          break;
      }

      if (!_sortAscending) {
        _borrowList = _borrowList.reversed.toList();
      }
    });
  }

  int _sortStringColumn(String a, String b) {
    final aValue = _sortAscending ? a.toLowerCase() : a.toUpperCase();
    final bValue = _sortAscending ? b.toLowerCase() : b.toUpperCase();
    return aValue.compareTo(bValue);
  }

  String _getFormattedDate(String date) {
    String year = date.substring(0, 4);
    String month = date.substring(4, 6);
    String day = date.substring(6, 8);

    return '$year-$month-$day';
  }
}
