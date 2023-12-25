const errMemberExist = '[오류] 동일한 회원이 존재합니다';
const errNotFoundMember = '[오류] 해당 회원 정보가 없습니다';
const errNotFoundPendingRemoveMember = '[오류] 마지막으로 삭제한 회원 정보가 없습니다';
const errNotFoundRestoreMember = '[오류] 복원할 회원 정보가 없습니다';

const errAlreadyBorrowed = '[오류] 대여중인 도서입니다';

const errNotFoundBorrowInfo = '[오류] 회원의 해당 도서 대여 정보를 찾을 수 없습니다';

const String memberFileName = 'member.csv';
const String memberFileRowString = 'id,name,contact,birthdate,address,gender';
const List<String> memberFileRowStringList = ['이름','연락처','나이','주소','성별'];
final int memberFileColumnCount = memberFileRowString.split(',').length;