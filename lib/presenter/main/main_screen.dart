import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class MainScreen extends StatelessWidget {
  const MainScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('도서 관리 프로그램')),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 100.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              TextButton.icon(
                onPressed: () => context.push(Uri(path: '/member').toString()),
                icon: const Icon(Icons.accessibility, size: 75),
                label: const Text('회원관리', style: TextStyle(fontSize: 25))),
              TextButton.icon(
                  onPressed: () => context.push(Uri(path: '/book').toString()),
                  icon: const Icon(Icons.library_books, size: 75),
                  label: const Text('도서관리', style: TextStyle(fontSize: 25))),
              TextButton.icon(
                  onPressed: () => context.push(Uri(path: '/borrow').toString()),
                  icon: const Icon(Icons.local_library, size: 75),
                  label: const Text('대출관리', style: TextStyle(fontSize: 25))),
              SizedBox(height: 50,)
            ],
          ),
        ),
      ),
    );
  }
}
