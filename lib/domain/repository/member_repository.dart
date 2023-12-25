import 'package:orm_library_manager/common/result.dart';
import 'package:orm_library_manager/domain/model/member.dart';

abstract interface class MemberRepository {
  Future<Result<List<Member>>> getAllMembers();
  Future<Result<Member>> join(Member member);
  Future<void> update(Member member);
  Future<void> withdraw(Member member, int memberId);
  Future<void> cancelLastWithdraw();
}