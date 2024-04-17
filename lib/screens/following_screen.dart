import 'package:flutter/material.dart';

class FollowingScreen extends StatelessWidget {
  const FollowingScreen({Key? key});

  static const routeName = '/following';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      body: const Center(
        child: Text('Following Screen'),
      ),
    );
  }
}
