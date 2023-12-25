const errMemberExist = '[오류] 동일한 회원이 존재합니다';

const errAlreadyBorrowed = '[오류] 대여중인 도서입니다';

const errNotFoundBorrowInfo = '[오류] 회원의 해당 도서 대여 정보를 찾을 수 없습니다';

const String memberFileName = 'member.csv';
const String memberFileRowString = 'id,name,contact,birthdate,address,gender';
const List<String> memberFileRowStringList = ['이름','연락처','나이','주소','성별'];
final int memberFileColumnCount = memberFileRowString.split(',').length;