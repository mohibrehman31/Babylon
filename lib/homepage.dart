import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

class Homepage extends StatefulWidget {
  const Homepage({super.key});

  @override
  State<Homepage> createState() => _HomepageState();
}

class _HomepageState extends State<Homepage> {
  final user = FirebaseAuth.instance.currentUser;
  signOut() async {
    await FirebaseAuth.instance.signOut();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("HomePage")),
      body: Center(child: Text('${user!.email}')),
      floatingActionButton: FloatingActionButton(
        onPressed: () => signOut(),
        child: Icon(Icons.login_rounded),
      ),
    );
  }
}
