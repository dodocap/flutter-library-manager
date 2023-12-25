import 'package:flutter/material.dart';
import 'package:orm_library_manager/common/constants.dart';
import 'package:orm_library_manager/common/repositories.dart';
import 'package:orm_library_manager/common/result.dart';
import 'package:orm_library_manager/domain/model/member.dart';
import 'package:orm_library_manager/domain/usecase/member_usecase.dart';
import 'package:sticky_headers/sticky_headers/widget.dart';

class MemberListScreen extends StatefulWidget {
  const MemberListScreen({super.key});

  @override
  State<MemberListScreen> createState() => _MemberListScreenState();
}

class _MemberListScreenState extends State<MemberListScreen> {
  final MemberUseCase _memberUseCase = MemberUseCase(memberRepository: memberRepository);
  List<Member> _memberList = [];
  bool _sortAscending = true;
  int _sortColumnIndex = 0;

  @override
  void initState() {
    _loadListMember();
    super.initState();
  }

  Future<void> _loadListMember() async {
    Result<List<Member>> memberList = await _memberUseCase.getMemberList();

    switch (memberList) {
      case Success<List<Member>>(:final data):
        setState(() {
          _memberList = data;
        });
        break;
      case Error(:final error):
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('회원 조회'),
      ),
      body: _memberList.isEmpty
      ? const Center(
        child: Text('회원 목록이 없습니다', style: TextStyle(fontSize: 50, fontWeight: FontWeight.bold, color: Colors.grey)),)
      : SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: StickyHeader(
          header: DataTable(
            columnSpacing: 0,
            sortAscending: _sortAscending,
            sortColumnIndex: _sortColumnIndex,
            horizontalMargin: 0,
            showBottomBorder: true,
            columns: memberFileRowStringList.map((e) {
              return DataColumn(
                label: SizedBox(width: 102, child: Text(e, textAlign: TextAlign.center,)),
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
              rows: _memberList.map((e) {
                return DataRow(cells: [
                  DataCell(SizedBox(
                    width: 120,
                    child: Text(e.name, textAlign: TextAlign.center),
                  )),
                  DataCell(SizedBox(width: 120,
                    child: Text(e.contact, textAlign: TextAlign.center),
                  )),
                  DataCell(SizedBox(width: 120,
                    child: Text(e.birthDate, textAlign: TextAlign.center),
                  )),
                  DataCell(SizedBox(width: 120,
                    child: Text(e.address, textAlign: TextAlign.center),
                  )),
                  DataCell(SizedBox(width: 120,
                    child: Text(e.gender.genderString, textAlign: TextAlign.center),
                  )),
                ]);
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
          _memberList.sort((a, b) => _sortStringColumn(a.name, b.name));
          break;
        case 1:
          _memberList.sort((a, b) => _sortStringColumn(a.contact, b.contact));
          break;
        case 2:
          _memberList.sort((a, b) => _sortStringColumn(a.birthDate, b.birthDate));
          break;
        case 3:
          _memberList.sort((a, b) => _sortStringColumn(a.address, b.address));
          break;
        case 4:
          _memberList.sort((a, b) => _sortStringColumn(a.gender.genderString, b.gender.genderString));
          break;
      }

      if (!_sortAscending) {
        _memberList = _memberList.reversed.toList();
      }
    });
  }

  int _sortStringColumn(String a, String b) {
    final aValue = _sortAscending ? a.toLowerCase() : a.toUpperCase();
    final bValue = _sortAscending ? b.toLowerCase() : b.toUpperCase();
    return aValue.compareTo(bValue);
  }
}
