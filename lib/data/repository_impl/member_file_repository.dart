import 'dart:io';

import 'package:orm_library_manager/common/constants.dart';
import 'package:orm_library_manager/common/result.dart';
import 'package:orm_library_manager/domain/model/member.dart';
import 'package:orm_library_manager/domain/repository/member_repository.dart';
import 'package:path_provider/path_provider.dart';

class MemberFileRepository implements MemberRepository {
  static final MemberFileRepository _instance = MemberFileRepository._internal();
  factory MemberFileRepository() => _instance;
  MemberFileRepository._internal() {
    _loadFile();
  }

  final List<Member> _memberList = [];
  File? _file;

  Future<void> _loadFile() async {
    final Directory directory = await getApplicationDocumentsDirectory();
    _file = File('${directory.path}/$memberFileName');

    try {
      final String readString = await _file?.readAsString() ?? '';
      List<String> readLines = readString.split('\n');
      String readFirstRow = readLines.first.split(',').map((e) => e.trim().toLowerCase()).join(',');

      if (readFirstRow == memberFileRowString) {
        for(int i = 1; i < readLines.length; i++) {
          final List<String> commaSplitList = readLines[i].split(',').map((e) => e.trim().toLowerCase()).toList();
          if (commaSplitList.length == memberFileColumnCount) {
            _memberList.add(Member.fromCSV(readLines[i].split(',').map((e) => e.trim().toLowerCase()).toList()));
          }
        }
      } else {

      }
    } catch (e) {
      print(e);
      // await _file?.delete();
    }
  }

  Future<void> _saveFile() async {
    final StringBuffer stringBuffer = StringBuffer();
    stringBuffer.write('$memberFileRowString\n');
    for (final member in _memberList) {
      stringBuffer.write(member.toCSV());
    }
    await _file?.writeAsString(stringBuffer.toString());
  }

  @override
  Future<Result<List<Member>>> getAllMembers() async {
    return Success(_memberList);
  }

  @override
  Future<Result<Member>> join(Member member) async {
    if(_memberList.contains(member)) {
      return const Error(errMemberExist);
    }

    _memberList.add(member);
    _saveFile();
    return Success(member);
  }

  @override
  Future<void> cancelLastWithdraw() async {
    return Future.value();
  }


  @override
  Future<void> update(Member member) async {
    return Future.value();
  }

  @override
  Future<void> withdraw(Member member, int memberId) async {
    return Future.value();
  }
}