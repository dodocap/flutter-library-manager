import 'package:flutter/material.dart';
import 'package:orm_library_manager/common/common.dart';
import 'package:orm_library_manager/common/constants.dart';
import 'package:orm_library_manager/common/repositories.dart';
import 'package:orm_library_manager/common/result.dart';
import 'package:orm_library_manager/domain/model/member.dart';
import 'package:orm_library_manager/domain/usecase/member_usecase.dart';
import 'package:orm_library_manager/presenter/book/book_list_screen.dart';
import 'package:orm_library_manager/presenter/member/member_join_screen.dart';
import 'package:sticky_headers/sticky_headers/widget.dart';

class MemberListScreen extends StatefulWidget {
  final ScreenMode mode;

  const MemberListScreen({
    super.key,
    required this.mode,
  });

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
    _loadMemberList();
    super.initState();
  }

  Future<void> _loadMemberList() async {
    Result<List<Member>> memberList = await _memberUseCase.getMemberList();

    switch (memberList) {
      case Success<List<Member>>(:final data):
        _memberList = data;
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
        title: const Text('회원 조회'),
        actions: widget.mode == ScreenMode.editor
        ? [
            IconButton(
              icon: const Icon(Icons.add_reaction_outlined),
              onPressed: () async {
                bool? result = await Navigator.push(context, MaterialPageRoute(builder: (context) => const MemberJoinScreen()));
                if(result != null && result) {
                  await _loadMemberList();
                }
              },
            ),
            IconButton(
              icon: const Icon(Icons.restore_outlined),
              onPressed: () async {
                Result<Member> result = await _memberUseCase.getPendingRemoveMember();
                switch (result) {
                  case Success<Member>(:final data):
                    _showRestoreMemberDialog(data);
                    break;
                  case Error(:final error):
                    if (context.mounted) {
                      showSimpleDialog(context, error);
                    }
                    break;
                }
              },
            ),
        ] : null,
      ),
      body: _memberList.isEmpty
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
              rows: _memberList.map((member) {
                return DataRow(
                  cells: [
                    DataCell(SizedBox(
                      width: 120,
                      child: Text(member.name, textAlign: TextAlign.center),
                    )),
                    DataCell(SizedBox(width: 120,
                      child: Text(member.contact, textAlign: TextAlign.center),
                    )),
                    DataCell(SizedBox(width: 120,
                      child: Text(_calculateAge(member.birthDate), textAlign: TextAlign.center),
                    )),
                    DataCell(SizedBox(width: 120,
                      child: Text(member.address, textAlign: TextAlign.center),
                    )),
                    DataCell(SizedBox(width: 120,
                      child: Text(member.gender.genderString, textAlign: TextAlign.center),
                    )),
                  ],
                  onLongPress: () {
                    switch(widget.mode) {
                      case ScreenMode.selector:
                        _showSelectMemberDialog(member);
                        break;
                      case ScreenMode.editor:
                        _showDeleteMemberDialog(member);
                        break;
                    }
                  }
                );
              }).toList(),
            ),
          ),
        ),
      ),
    );
  }
  String _calculateAge(String birthDate) {
    int year = int.parse(birthDate.substring(0, 4));
    int month = int.parse(birthDate.substring(4, 6));
    int day = int.parse(birthDate.substring(6, 8));

    DateTime birthDateTime = DateTime(year, month, day);

    DateTime now = DateTime.now();
    int age = now.year - birthDateTime.year;

    if (now.month < birthDateTime.month || (now.month == birthDateTime.month && now.day < birthDateTime.day)) {
      age--;
    }

    return age.toString();
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

  void _showSelectMemberDialog(Member member) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Center(child: Text('${member.name} 회원님이\n도서대출을 신청합니까?')),
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
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => BookListScreen(mode: ScreenMode.selector, member: member)),
                  );
                },
                child: const Text('예', style: TextStyle(color: Colors.red, fontWeight: FontWeight.bold),),
              ),
            ],
          ),
        );
      },
    );
  }

  void _showDeleteMemberDialog(Member member) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Center(child: Text('${member.name} 회원을\n삭제하시겠습니까?')),
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
                  _removeMember(member);
                },
                child: const Text('삭제', style: TextStyle(color: Colors.red, fontWeight: FontWeight.bold),),
              ),
            ],
          ),
        );
      },
    );
  }

  Future<void> _removeMember(Member member) async {
    final Result<Member> result = await _memberUseCase.removeMember(member);

    switch(result) {
      case Success<Member>(:final data):
        if(context.mounted) {
          showSimpleDialog(context, '${data.name} 삭제 성공', () {
            setState(() {
              _memberList.remove(data);
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

  void _showRestoreMemberDialog(Member member) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Center(child: Text('${member.name} 회원을\n다시 복원하시겠습니까?')),
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
                  _restoreMember(member);
                },
                child: const Text('복원', style: TextStyle(color: Colors.red, fontWeight: FontWeight.bold),),
              ),
            ],
          ),
        );
      },
    );
  }

  Future<void> _restoreMember(Member member) async {
    final Result<Member> result = await _memberUseCase.restoreMember(member);

    switch(result) {
      case Success<Member>(:final data):
        if(context.mounted) {
          showSimpleDialog(context, '${data.name} 복원 성공', () {
            _memberList.add(data);
            setState(() {
              _onSortColumn(_sortColumnIndex);
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
