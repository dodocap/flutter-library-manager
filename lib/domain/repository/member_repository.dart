import 'package:orm_library_manager/domain/model/member.dart';

abstract interface class MemberRepository {
  Future<void> getAllMembers();
  Future<void> join(Member member);
  Future<void> update(Member member);
  Future<void> withdraw(Member member, int memberId);
  Future<void> cancelLastWithdraw();
}