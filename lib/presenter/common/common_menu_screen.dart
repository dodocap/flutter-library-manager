import 'package:flutter/material.dart';

class CommonMenuScreen extends StatelessWidget {
  final Map<String, Widget> menu;

  const CommonMenuScreen({
    super.key,
    required this.menu,
  });

  @override
  Widget build(BuildContext context) {
    return ListView(
        children: menu.entries.map((e) {
      return ListTile(
        title: Text(e.key),
        onTap: () => Navigator.push(context, MaterialPageRoute(builder: (context) => e.value)),
      );
    }).toList());
  }
}
