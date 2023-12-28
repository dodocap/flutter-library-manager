import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:orm_library_manager/common/common.dart';
import 'package:orm_library_manager/common/repositories.dart';
import 'package:orm_library_manager/common/result.dart';
import 'package:orm_library_manager/domain/dto/member.dart';
import 'package:orm_library_manager/domain/usecase/member_usecase.dart';

class MemberJoinScreen extends StatefulWidget {
  const MemberJoinScreen({super.key});

  @override
  State<MemberJoinScreen> createState() => _MemberJoinScreenState();
}

class _MemberJoinScreenState extends State<MemberJoinScreen> {
  final MemberUseCase _memberUseCase = MemberUseCase(memberRepository: memberRepository);

  final _textNameController = TextEditingController();
  final _textContactController = TextEditingController();
  final _textAddressController = TextEditingController();
  final _textBirthdateController = TextEditingController();
  Gender? _selectedGender;
  String _errorMessage = '';

  @override
  void dispose() {
    _textNameController.dispose();
    _textContactController.dispose();
    _textAddressController.dispose();
    _textBirthdateController.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('회원 가입'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _textNameController,
              decoration: InputDecoration(
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10.0),
                ),
                hintText: '이름',
                hintStyle: TextStyle(color: Colors.grey[800]),
                filled: true,
                fillColor: Colors.white70,
              ),
            ),
            const SizedBox(height: 24),
            TextField(
              controller: _textContactController,
              decoration: InputDecoration(
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10.0),
                ),
                hintText: '연락처(번호만 입력)',
                hintStyle: TextStyle(color: Colors.grey[800]),
                filled: true,
                fillColor: Colors.white70,
              ),
              keyboardType: TextInputType.number,
              inputFormatters: [
                FilteringTextInputFormatter.digitsOnly,
                LengthLimitingTextInputFormatter(11),
              ],
            ),
            const SizedBox(height: 24),
            TextField(
              controller: _textAddressController,
              decoration: InputDecoration(
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10.0),
                ),
                hintText: '주소',
                hintStyle: TextStyle(color: Colors.grey[800]),
                filled: true,
                fillColor: Colors.white70,
              ),
            ),
            const SizedBox(height: 24),
            TextField(
              controller: _textBirthdateController,
              decoration: InputDecoration(
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10.0),
                ),
                hintText: '생년월일(YYYYMMDD)',
                hintStyle: TextStyle(color: Colors.grey[800]),
                filled: true,
                fillColor: Colors.white70,
              ),
              keyboardType: TextInputType.number,
              inputFormatters: [
                FilteringTextInputFormatter.digitsOnly,
                LengthLimitingTextInputFormatter(8),
              ],
            ),
            const SizedBox(height: 24),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                const Text('성별 ', style: TextStyle(fontSize: 18)),
                ...Gender.values.map((gender) {
                  return RadioMenuButton(
                    value: gender,
                    groupValue: _selectedGender,
                    onChanged: (value) {
                      setState(() {
                        _selectedGender = value;
                      });
                    },
                    child: Text(gender.genderString),
                  );
                }).toList(),
              ]
            ),
            const SizedBox(height: 24),
            Text(
              _errorMessage,
              style: const TextStyle(color: Colors.red, fontSize: 16, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 24),
            ElevatedButton(
                onPressed: () { _onPressedJoinButton(); },
                child: const Padding(
                  padding: EdgeInsets.all(8.0),
                  child: Text(
                    '작성완료!',
                    style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                  ),
                ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _onPressedJoinButton() async {
    final Result<Member> result = await _memberUseCase.joinMember(
      name: _textNameController.text,
      address: _textAddressController.text,
      contact: _textContactController.text,
      birthDate: _textBirthdateController.text,
      gender: _selectedGender,
    );

    switch(result) {
      case Success(:final data):
        if (mounted) {
          showSimpleDialog(context, '${data.name}님\n회원 가입 성공!', () => Navigator.pop(context, true));
        }
        break;
      case Error(:final error):
        setState(() {
          _errorMessage = error;
        });
        break;
    }
  }
}
