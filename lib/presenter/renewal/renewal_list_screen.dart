import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:orm_library_manager/common/constants.dart';
import 'package:orm_library_manager/common/repositories.dart';
import 'package:orm_library_manager/common/result.dart';
import 'package:orm_library_manager/domain/model/borrow_info_model.dart';
import 'package:orm_library_manager/domain/model/member.dart';
import 'package:orm_library_manager/domain/usecase/borrow_usecase.dart';
import 'package:sticky_headers/sticky_headers/widget.dart';

class RenewalListScreen extends StatefulWidget {
  final Member member;

  const RenewalListScreen({super.key, required this.member});

  @override
  State<RenewalListScreen> createState() => _RenewalListScreenState();
}

class _RenewalListScreenState extends State<RenewalListScreen> {
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
    Result<List<BorrowInfoModel>> model = await _borrowUseCase.getBorrowListByMember(member: widget.member);

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
        title: Text('대출 연장'),
      ),
      body: _borrowBookList.isEmpty
          ? const Center(
          child: Text('대출 목록 없음', style: TextStyle(fontSize: 48, fontWeight: FontWeight.bold, color: Colors.grey)))
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
              rows: _borrowBookList.map((borrowInfoModel) {
                return DataRow(
                    cells: [
                      DataCell(SizedBox(width: width,
                        child: Text(borrowInfoModel.bookName, textAlign: TextAlign.center),
                      )),
                      DataCell(SizedBox(width: width,
                        child: Text(borrowInfoModel.borrowDate, textAlign: TextAlign.center),
                      )),
                      DataCell(SizedBox(width: width,
                        child: Text(borrowInfoModel.expireDate, textAlign: TextAlign.center),
                      )),
                    ],
                    onLongPress: () {
                      _showSelectBookDialog(borrowInfoModel);
                    }
                );
              }).toList(),
            ),
          ),
        ),
      ),
    );
  }

  void _showSelectBookDialog(BorrowInfoModel borrowInfoModel) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Center(child: Text('${borrowInfoModel.bookName} 대출기간을 1주일 연장하시겠습니까?')),
          content: Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text('아니요', style: TextStyle(color: Colors.black87),),
              ),
              TextButton(
                onPressed: () {
                  Navigator.pop(context);
                  context.go(
                      Uri(
                          path: '/resultRenewal',
                          queryParameters: {
                            'borrowInfoModel': jsonEncode(borrowInfoModel.toJson()),
                          }
                      ).toString());
                },
                child: const Text('예', style: TextStyle(color: Colors.red, fontWeight: FontWeight.bold),),
              ),
            ],
          ),
        );
      },
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
