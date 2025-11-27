import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:jogos_videogame_t3/view/home_page.dart';
import 'package:jogos_videogame_t3/view/login_page.dart';
import 'package:jogos_videogame_t3/view/register_page.dart';

class AuthPage extends StatefulWidget {
  const AuthPage({super.key});

  @override
  State<AuthPage> createState() => _AuthPageState();
}

class _AuthPageState extends State<AuthPage> {
  bool showLoginPage = true;
  bool _initializing = true;

  @override
  void initState() {
    super.initState();
    _checkInitialization();
  }

  void _checkInitialization() async {
    await Future.delayed(Duration(milliseconds: 500));
    setState(() {
      _initializing = false;
    });
  }

  void togglePages() {
    setState(() {
      showLoginPage = !showLoginPage;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (_initializing) {
      return Scaffold(
        backgroundColor: Color(0xFF0A0E21),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              CircularProgressIndicator(color: Color(0xFF667EEA)),
              SizedBox(height: 20),
              Text(
                "Inicializando...",
                style: TextStyle(color: Colors.white),
              ),
            ],
          ),
        ),
      );
    }

    return Scaffold(
      body: StreamBuilder<User?>(
        stream: FirebaseAuth.instance.authStateChanges(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator(color: Color(0xFF667EEA)));
          }
          
          if (snapshot.hasData) {
            return HomePage();
          } else {
            if (showLoginPage) {
              return LoginPage(onToggle: togglePages);
            } else {
              return RegisterPage(onToggle: togglePages);
            }
          }
        },
      ),
    );
  }
}