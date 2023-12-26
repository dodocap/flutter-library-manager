import 'package:orm_library_manager/common/result.dart';
import 'package:orm_library_manager/domain/model/member.dart';

abstract interface class MemberRepository {
  Future<Result<List<Member>>> getAllMembers();
  Future<Result<Member>> findById(int id);
  Future<Result<Member>> join(Member member);
  Future<Result<Member>> remove(Member member);
  Future<Result<Member>> getPendingRemove();
  Future<Result<Member>> restore(Member member);
}