import 'package:flutter/material.dart';

class BaseLoadingScreen extends StatefulWidget {
  bool isLoading = false;
  final Widget child;

  BaseLoadingScreen({super.key, required this.child});

  @override
  State<BaseLoadingScreen> createState() => _BaseLoadingScreenState();
}

class _BaseLoadingScreenState extends State<BaseLoadingScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: widget.isLoading
          ? const CircularProgressIndicator()
          : widget.child
    );
  }
}
