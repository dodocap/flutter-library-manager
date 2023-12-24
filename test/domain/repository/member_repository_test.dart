import 'package:flutter_test/flutter_test.dart';
import 'package:orm_library_manager/common/common.dart';
import 'package:orm_library_manager/common/constants.dart';
import 'package:orm_library_manager/domain/model/member.dart';
import 'package:orm_library_manager/domain/repository/member_repository.dart';
import '../../data/repository_impl/member_memory_repository.dart';

void main() {
  late MemberRepository memberRepository;

  late Member member;

  // 전체 테스트시 1회 실행
  setUpAll(() {
    member = Member(
      name: '홍길동',
      address: '서울',
      contact: '010-1234-5678',
      birthDate: '2023-01-01',
      gender: Gender.male,
    );
  });

  // 매 테스트마다 초기화 코드
  setUp(() async {
    memberRepository = MemberMemoryRepository();
    await memberRepository.join(member);
  });

  test('멤버 조회', () async {
    final List<Member> memberList = await memberRepository.getAllMembers();

    expect(memberList.length, 1);
    expect(memberList[0].name, '홍길동');
  });

  test('멤버 가입', () async {
    final Member newMember = Member(name: '홍길순',
      address: '인천',
      contact: '010-1234-1234',
      birthDate: '1999-12-31',
      gender: Gender.female,
    );

    Member member = await memberRepository.join(newMember);
    final List<Member> memberList = await memberRepository.getAllMembers();

    expect(memberList.length, 2);
    expect(memberList[1], member);
  });

  test('멤버 중복 가입 불가', () async {
    final Member existMember = member.copyWith();

    try {
      await memberRepository.join(existMember);
    } catch (e) {
      expect(e.toString(), errMemberExist);
    }
  });

}
