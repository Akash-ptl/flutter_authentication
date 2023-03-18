import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';
import 'package:flutter_login/firebase_auth.dart';
import 'package:flutter_login/global.dart';
import 'package:flutter_login/home_page.dart';
import 'package:flutter_login/reset.dart';
import 'package:flutter_login/sign_up.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final AuthService _auth = AuthService();
  late Future _future;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _future = _initializeFirebase();
  }

  Future<FirebaseApp> _initializeFirebase() async {
    FirebaseApp firebaseApp = await Firebase.initializeApp();

    User? user = FirebaseAuth.instance.currentUser;

    if (user != null) {
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(
          builder: (context) => HomePage(
            user: user,
          ),
        ),
      );
    }

    return firebaseApp;
  }

  final TextEditingController _emailMobileController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  final _formKey = GlobalKey<FormState>();

  void _login() async {
    if (_formKey.currentState!.validate()) {
      User? user = await FireAuth.signInUsingEmailPassword(
        email: _emailMobileController.text,
        password: _passwordController.text,
      );
      print(user);
      if (user != null) {
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(
            builder: (context) => HomePage(
              user: user,
            ),
          ),
        );
      } else {
        // Show error message
      }
    }
  }

  TextStyle text1 = TextStyle(fontSize: 18, color: Colors.grey.shade600);
  @override
  Widget build(BuildContext context) {
    double h = MediaQuery.of(context).size.height;
    double w = MediaQuery.of(context).size.width;

    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: null,
      body: Padding(
        padding: const EdgeInsets.all(30),
        child: Form(
          key: _formKey,
          child:
              Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            SizedBox(
              height: h / 8,
            ),
            const Text(
              'Welcome back,',
              style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
            ),
            Text(
              'You have been missed Sign in to continue',
              style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Colors.grey.shade600),
            ),
            SizedBox(
              height: h / 14,
            ),
            TextFormField(
              controller: _emailMobileController,
              decoration: const InputDecoration(
                border: OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(15))),
                labelText: 'Email',
              ),
              validator: validateEmailMobile,
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: _passwordController,
              obscureText: obscureText && !showPassword,
              decoration: InputDecoration(
                border: const OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(15))),
                labelText: 'Password',
                suffixIcon: IconButton(
                  icon: Icon(
                      showPassword ? Icons.visibility_off : Icons.visibility),
                  onPressed: () {
                    setState(() {
                      showPassword = !showPassword;
                    });
                  },
                ),
              ),
              validator: validatePassword,
            ),
            Align(
              alignment: Alignment.centerRight,
              child: TextButton(
                style: const ButtonStyle(
                    padding: MaterialStatePropertyAll(EdgeInsets.zero)),
                onPressed: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const ResetPage(),
                      ));
                },
                child: const Text(
                  'Forgot password?',
                  style: TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.bold,
                      color: Colors.black),
                ),
              ),
            ),
            SizedBox(
              height: h / 32,
            ),
            GestureDetector(
              onTap: () async {
                _login();
              },
              child: Container(
                alignment: Alignment.center,
                height: h / 22,
                width: w,
                decoration: BoxDecoration(
                    border: Border.all(),
                    borderRadius: BorderRadius.circular(15)),
                child: const Text(
                  'Sign in',
                  style: TextStyle(fontSize: 20),
                ),
              ),
            ),
            SizedBox(height: h / 30),
            const Text(
              "Don't have an account?",
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 30),
            Text(
              '✔  Get acquainted with deals and discounts\nas a member of vestige',
              style: text1,
            ),
            const SizedBox(height: 20),
            Text(
              '✔  Enjoy making your purchases faster',
              style: text1,
            ),
            const SizedBox(height: 20),
            Text(
              '✔  Experience the ease of tracking your orders',
              style: text1,
            ),
            const SizedBox(height: 10),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                IconButton(
                    onPressed: () async {
                      final User? user = await _auth.signInWithGoogle();
                      if (user != null) {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => HomePage(user: user),
                            ));
                      }
                    },
                    icon: const Icon(MdiIcons.google)),
                IconButton(
                    onPressed: () async {
                      final result = await FacebookAuth.instance.login();
                      final OAuthCredential credential =
                          FacebookAuthProvider.credential(
                              result.accessToken?.token ?? '');

                      final firebaseUser = await FirebaseAuth.instance
                          .signInWithCredential(credential);
                      print(firebaseUser.user!.displayName);
                    },
                    icon: const Icon(MdiIcons.facebook)),
              ],
            ),
            const SizedBox(height: 10),
            GestureDetector(
              onTap: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const SignupPage(),
                    ));
              },
              child: Container(
                alignment: Alignment.center,
                height: h / 22,
                width: w,
                decoration: BoxDecoration(
                    color: Colors.black,
                    border: Border.all(),
                    borderRadius: BorderRadius.circular(15)),
                child: const Text(
                  'Create account',
                  style: TextStyle(fontSize: 20, color: Colors.white),
                ),
              ),
            ),
            const Spacer(),
          ]),
        ),
      ),
    );
  }
}
