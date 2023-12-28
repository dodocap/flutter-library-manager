import 'package:orm_library_manager/common/common.dart';
import 'package:orm_library_manager/common/result.dart';
import 'package:orm_library_manager/domain/dto/member.dart';
import 'package:orm_library_manager/domain/repository/member_repository.dart';

class MemberUseCase {
  final MemberRepository memberRepository;

  const MemberUseCase({
    required this.memberRepository,
  });

  Future<Result<List<Member>>> getMemberList() async {
    final Result<List<Member>> result = await memberRepository.getAllMembers();
    switch (result) {
      case Success<List<Member>>(:final data):
        List<Member> newList = data.toList()..removeWhere((element) => element.isPendingRemove());
        return Success(newList);
      case Error():
        return result;
    }
  }

  Future<Result<Member>> joinMember
      ({required String name, required String address, required String contact, required String birthDate, required Gender? gender}) async {
    if (name.isEmpty) {
      return const Error('이름을 입력해주세요');
    }
    if (contact.isEmpty) {
      return const Error('휴대폰번호를 입력해주세요');
    }
    if (contact.length != 11) {
      return const Error('휴대폰번호를 올바르게 입력해주세요');
    }
    if (address.isEmpty) {
      return const Error('주소를 입력해주세요');
    }
    if (birthDate.isEmpty) {
      return const Error('생년월일을 입력해주세요');
    }
    if (birthDate.length != 8) {
      return const Error('생년월일을 올바르게 입력해주세요');
    }
    if (gender == null) {
      return const Error('성별을 선택해주세요');
    }

    return memberRepository.join(Member(
        name: name,
        address: address,
        contact: contact,
        birthDate: birthDate,
        gender: gender));
  }

  Future<Result<Member>> removeMember(Member member) {
    return memberRepository.remove(member);
  }

  Future<Result<Member>> getPendingRemoveMember() {
    return memberRepository.getPendingRemove();
  }

  Future<Result<Member>> restoreMember(Member member) {
    return memberRepository.restore(member);
  }
}
