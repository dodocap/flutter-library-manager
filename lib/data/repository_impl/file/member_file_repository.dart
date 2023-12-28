import 'package:orm_library_manager/common/common.dart';
import 'package:orm_library_manager/common/constants.dart';
import 'package:orm_library_manager/common/result.dart';
import 'package:orm_library_manager/data/repository_impl/file/base_file_repository.dart';
import 'package:orm_library_manager/domain/model/member.dart';
import 'package:orm_library_manager/domain/repository/member_repository.dart';

class MemberFileRepository extends BaseFileRepository<Member> implements MemberRepository {
  static final MemberFileRepository _instance = MemberFileRepository._internal(memberFileName, memberFileRowString);
  factory MemberFileRepository() => _instance;
  MemberFileRepository._internal(super.fileName, super.fileRowString);

  @override
  Member fromCSV(List<String> splitStringList) {
    return Member.fromCSV(splitStringList);
  }

  @override
  Future<Result<List<Member>>> getAllMembers() async {
    return Success(list);
  }

  @override
  Future<Result<Member>> findById(int id) async {
    Member? findMember = list.firstWhereOrNull((member) => member.id == id);
    if (findMember == null) {
      return const Error(errNotFoundMember);
    }

    return Success(findMember);
  }

  @override
  Future<Result<Member>> join(Member member) async {
    if(list.contains(member)) {
      return const Error(errMemberExist);
    }

    list.add(member);
    await saveFile();
    return Success(member);
  }

  @override
  Future<Result<Member>> remove(Member member) async {
    bool isExist = list.contains(member);
    if (!isExist) {
      return const Error(errNotFoundMember);
    }

    Member? pendingRemoveMember = list.firstWhereOrNull((e) => e.isPendingRemove());
    if(pendingRemoveMember != null) {
      list.remove(pendingRemoveMember);
    }
    member.setPendingRemove();
    await saveFile();

    return Success(member);
  }

  @override
  Future<Result<Member>> getPendingRemove() async {
    Member? pendingRemoveMember = list.firstWhereOrNull((member) => member.isPendingRemove());
    if(pendingRemoveMember == null) {
      return const Error(errNotFoundPendingRemoveMember);
    }

    return Success(pendingRemoveMember);
  }

  @override
  Future<Result<Member>> restore(Member member) async {
    final Member? restoreMember = list.firstWhereOrNull((e) => e == member);
    if (restoreMember == null) {
      return const Error(errNotFoundRestoreMember);
    }

    restoreMember.setPendingRemove();
    await saveFile();

    return Success(restoreMember);
  }
}