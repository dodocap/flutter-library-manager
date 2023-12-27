const expireDefaultDate = 14;
const expireMaximumDate = 21;
const errNotAnymoreRenewal = '[오류] 연장을 할 수 없습니다';

const errMemberExist = '[오류] 동일한 회원이 존재합니다';
const errNotFoundMember = '[오류] 해당 회원 정보가 없습니다';
const errNotFoundPendingRemoveMember = '[오류] 마지막으로 삭제한 회원 정보가 없습니다';
const errNotFoundRestoreMember = '[오류] 복원할 회원 정보가 없습니다';

const errAlreadyBorrowed = '[오류] 대여중인 도서입니다';
const errAlreadyReturned = '[오류] 이미 반납된 도서입니다';

const errNotFoundBook = '[오류] 해당 도서 정보가 없습니다';
const errFailedRemoveBook = '[오류] 도서 삭제에 실패했습니다';

const errNotFoundBorrowInfo = '[오류] 회원의 해당 도서 대여 정보를 찾을 수 없습니다';

const String memberFileName = 'member.csv';
const String memberFileRowString = 'id,name,contact,birthdate,address,gender';
const List<String> memberFileRowStringList = ['이름','연락처','나이','주소','성별'];
final int memberFileColumnCount = memberFileRowString.split(',').length;

const String bookFileName = 'book.csv';
const String bookFileRowString = 'id,name,price,publishDate,isbn,isBorrowed';
const List<String> bookFileRowStringList = ['제목','출간일','ISBN','대여중','가격'];
final int bookFileColumnCount = bookFileRowString.split(',').length;

const String borrowFileName = 'borrow.csv';
const String borrowFileRowString = 'id,memberId,bookId,borrowDate,expireDate,returnDate,isFinished';
const List<String> borrowFileRowStringList = ['회원명','도서명','대출일','만료일','반납일'];
final int borrowFileColumnCount = borrowFileRowString.split(',').length;

const List<String> borrowInfoRowStringList = ['도서명','대출일','만료일'];