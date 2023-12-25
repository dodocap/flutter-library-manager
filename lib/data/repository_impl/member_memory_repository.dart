import 'dart:math';
import 'package:orm_library_manager/common/constants.dart';
import 'package:orm_library_manager/common/result.dart';
import 'package:orm_library_manager/domain/model/member.dart';
import 'package:orm_library_manager/domain/repository/member_repository.dart';

class MemberMemoryRepository implements MemberRepository {
  final List<Member> _memberList = [];

  Future<void> _virtualDelayed() async {
    await Future.delayed(Duration(milliseconds: Random().nextInt(150) + 150));
  }

  @override
  Future<Result<List<Member>>> getAllMembers() async {
    await _virtualDelayed();
    return Success(_memberList);
  }

  @override
  Future<Result<Member>> join(Member member) async {
    await _virtualDelayed();

    if(_memberList.contains(member)) {
      return const Error(errMemberExist);
    }

    _memberList.add(member);
    return Success(member);
  }

  @override
  Future<Result<Member>> remove(Member member) async {
    return const Error('');
  }

  @override
  Future<Result<Member>> getPendingRemove() async {
    return const Error('');
  }

  @override
  Future<Result<Member>> restore(Member member) async {
    return const Error('');
  }
  
}