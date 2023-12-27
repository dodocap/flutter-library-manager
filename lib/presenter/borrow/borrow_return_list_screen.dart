import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:orm_library_manager/common/constants.dart';
import 'package:orm_library_manager/common/repositories.dart';
import 'package:orm_library_manager/common/result.dart';
import 'package:orm_library_manager/domain/model/borrow_info_model.dart';
import 'package:orm_library_manager/domain/model/member.dart';
import 'package:orm_library_manager/domain/usecase/borrow_usecase.dart';
import 'package:sticky_headers/sticky_headers/widget.dart';

class BorrowReturnListScreen extends StatefulWidget {
  final Member member;

  const BorrowReturnListScreen({
    super.key,
    required this.member,
  });

  @override
  State<BorrowReturnListScreen> createState() => _BorrowReturnListScreenState();
}

class _BorrowReturnListScreenState extends State<BorrowReturnListScreen> {
  final BorrowUseCase _borrowUseCase = BorrowUseCase(borrowRepository: borrowRepository);
  List<BorrowInfoModel> _borrowBookList = [];
  bool _sortAscending = true;
  int _sortColumnIndex = 0;

  @override
  void initState() {
    _loadBorrowList();

    super.initState();
  }

  Future<void> _loadBorrowList() async {
    Result<List<BorrowInfoModel>> model = await _borrowUseCase.getBorrowList(containFinish: false);

    switch (model) {
      case Success<List<BorrowInfoModel>>(:final data):
        _borrowBookList = data;
        _onSortColumn(_sortColumnIndex);
        break;
      case Error(:final error):
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width / 3;
    return Scaffold(
      appBar: AppBar(
        title: Text('대출 반납'),
      ),
      body: _borrowBookList.isEmpty
          ? const Center(
          child: Text('회원 목록 없음', style: TextStyle(fontSize: 48, fontWeight: FontWeight.bold, color: Colors.grey)))
          : SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: StickyHeader(
          header: DataTable(
            columnSpacing: 0,
            horizontalMargin: 0,
            sortAscending: _sortAscending,
            sortColumnIndex: _sortColumnIndex,
            showBottomBorder: true,
            columns: borrowInfoRowStringList.map((e) {
              return DataColumn(
                label: SizedBox(width: width - 18, child: Text(e, textAlign: TextAlign.center,)),
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
              columns: List.generate(3, (index) => const DataColumn(label: Spacer())),
              rows: _borrowBookList.map((borrowInfo) {
                return DataRow(
                    cells: [
                      DataCell(SizedBox(width: width,
                        child: Text(borrowInfo.bookName, textAlign: TextAlign.center),
                      )),
                      DataCell(SizedBox(width: width,
                        child: Text(borrowInfo.borrowDate, textAlign: TextAlign.center),
                      )),
                      DataCell(SizedBox(width: width,
                        child: Text(borrowInfo.expireDate, textAlign: TextAlign.center),
                      )),
                    ],
                    onLongPress: () {

                    }
                );
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
          _borrowBookList.sort((a, b) => _sortStringColumn(a.bookName, b.bookName));
          break;
        case 1:
          _borrowBookList.sort((a, b) => _sortStringColumn(a.borrowDate, b.borrowDate));
          break;
        case 2:
          _borrowBookList.sort((a, b) => _sortStringColumn(a.expireDate, b.expireDate));
          break;
      }

      if (!_sortAscending) {
        _borrowBookList = _borrowBookList.reversed.toList();
      }
    });
  }

  int _sortStringColumn(String a, String b) {
    final aValue = _sortAscending ? a.toLowerCase() : a.toUpperCase();
    final bValue = _sortAscending ? b.toLowerCase() : b.toUpperCase();
    return aValue.compareTo(bValue);
  }
}
