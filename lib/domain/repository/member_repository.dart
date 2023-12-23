import 'package:orm_library_manager/domain/model/member.dart';

abstract interface class MemberRepository {
  Future<List<Member>> getAllMembers();
  Future<Member> join(Member member);
  Future<void> update(Member member);
  Future<void> withdraw(Member member, int memberId);
  Future<void> cancelLastWithdraw();
}