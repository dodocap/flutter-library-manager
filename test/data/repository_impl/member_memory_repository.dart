import 'dart:math';
import 'package:orm_library_manager/common/constants.dart';
import 'package:orm_library_manager/domain/model/member.dart';
import 'package:orm_library_manager/domain/repository/member_repository.dart';

class MemberMemoryRepository implements MemberRepository {
  final List<Member> _memberList = [];

  Future<void> _virtualDelayed() async {
    await Future.delayed(Duration(milliseconds: Random().nextInt(150) + 150));
  }

  @override
  Future<List<Member>> getAllMembers() async {
    await _virtualDelayed();
    return _memberList;
  }

  @override
  Future<Member> join(Member member) async {
    await _virtualDelayed();

    if(_memberList.contains(member)) {
      return Future.error(errMemberExist);
    }

    _memberList.add(member);
    return member;
  }

  @override
  Future<void> cancelLastWithdraw() {
    return Future.value();
  }

  @override
  Future<void> update(Member member) {
    return Future.value();
  }

  @override
  Future<void> withdraw(Member member, int memberId) {
    return Future.value();
  }
  
}