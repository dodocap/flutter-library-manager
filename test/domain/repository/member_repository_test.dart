import 'package:flutter_test/flutter_test.dart';
import 'package:orm_library_manager/common/common.dart';
import 'package:orm_library_manager/common/constants.dart';
import 'package:orm_library_manager/common/result.dart';
import 'package:orm_library_manager/data/repository_impl/member_memory_repository.dart';
import 'package:orm_library_manager/domain/model/member.dart';
import 'package:orm_library_manager/domain/repository/member_repository.dart';

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
    final Result<List<Member>> memberResult = await memberRepository.getAllMembers();

    switch (memberResult) {
      case Success<List<Member>>(:final data):
        expect(data.length, 1);
        expect(data.first.name, '홍길동');
        break;
      case Error(:final error):
        break;
    }
  });

  test('멤버 가입', () async {
    final Member newMember = Member(name: '홍길순',
      address: '인천',
      contact: '010-1234-1234',
      birthDate: '1999-12-31',
      gender: Gender.female,
    );

    final Result<Member> result = await memberRepository.join(newMember);
    final Result<List<Member>> resultAllMembers = await memberRepository.getAllMembers();

    switch (result) {
      case Success(:final data):
        expect(data.name, '홍길순');
        break;
      case Error(:final error):
        break;
    }

    switch (resultAllMembers) {
      case Success<List<Member>>(:final data):
        expect(data.length, 2);
        break;
      case Error(:final error):
        break;
    }
  });

  test('멤버 중복 가입 불가', () async {
    final Member existMember = member.copyWith();

    Result result = await memberRepository.join(existMember);
    switch (result) {
      case Success():
        break;
      case Error(:final error):
        expect(error, errMemberExist);
        break;
    }
  });
}
