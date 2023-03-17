import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_login/firebase_auth.dart';
import 'package:flutter_login/global.dart';
import 'package:flutter_login/home_page.dart';
import 'package:flutter_login/sign_up.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final AuthService _auth = AuthService();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  final TextEditingController _emailMobileController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  String? _validateEmailMobile(String? value) {
    if (value == null || value.isEmpty) {
      return 'Email/Mobile is required';
    }

    final emailRegex = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');
    if (emailRegex.hasMatch(value)) {
      return null;
    }

    final mobileRegex = RegExp(r'^\d{10}$');
    if (mobileRegex.hasMatch(value)) {
      return null;
    }

    return 'Invalid email/mobile';
  }

  String? _validatePassword(String? value) {
    if (value == null || value.isEmpty) {
      return 'Password is required';
    }

    if (value.length < 6) {
      return 'Password must be at least 6 characters long';
    }

    return null;
  }

  final _formKey = GlobalKey<FormState>();

  String _email = '';
  String _password = '';
  void _login() async {
    if (_formKey.currentState!.validate()) {
      User? user = await FireAuth.signInUsingEmailPassword(
        email: _email,
        password: _password,
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

  @override
  Widget build(BuildContext context) {
    double h = MediaQuery.of(context).size.height;
    double w = MediaQuery.of(context).size.width;

    return Scaffold(
      appBar: null,
      body: Padding(
        padding: const EdgeInsets.all(30),
        child: Form(
          key: _formKey,
          child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Welcome back',
                  style: TextStyle(fontSize: 40, fontWeight: FontWeight.bold),
                ),
                const Text(
                  'You have been missed Sign in to continue',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
                TextFormField(
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(15))),
                    labelText: 'Email or phone number',
                  ),
                  validator: _validateEmailMobile,
                  onSaved: (value) {
                    _email = value!;
                  },
                ),
                const SizedBox(height: 16),
                TextFormField(
                  obscureText: obscureText && !showPassword,
                  decoration: InputDecoration(
                    border: const OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(15))),
                    labelText: 'Password',
                    suffixIcon: IconButton(
                      icon: Icon(showPassword
                          ? Icons.visibility_off
                          : Icons.visibility),
                      onPressed: () {
                        setState(() {
                          showPassword = !showPassword;
                        });
                      },
                    ),
                  ),
                  validator: _validatePassword,
                  onSaved: (value) {
                    _password = value!;
                  },
                ),
                const SizedBox(height: 10),
                const Align(
                  alignment: Alignment.centerRight,
                  child: Text(
                    'Forgot password?',
                    style: TextStyle(fontSize: 17, fontWeight: FontWeight.bold),
                  ),
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
              ]),
        ),
      ),
      // Padding(
      //   padding: const EdgeInsets.all(16.0),
      //   child: Column(
      //     crossAxisAlignment: CrossAxisAlignment.stretch,
      //     mainAxisAlignment: MainAxisAlignment.center,
      //     children: [

      //       Positioned.fill(
      //         child: BackdropFilter(
      //           filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
      //           child: Container(
      //             color: Colors.transparent,
      //           ),
      //         ),
      //       ),
      //       const SizedBox(height: 20),
      //       ElevatedButton(
      //         onPressed: () async {
      //           final User? user = await _auth.signInWithGoogle();
      //           if (user != null) {
      //             // Navigate to the home screen
      //           }
      //         },
      //         style: ElevatedButton.styleFrom(
      //           backgroundColor: Colors.redAccent,
      //           shape: RoundedRectangleBorder(
      //             borderRadius: BorderRadius.circular(10.0),
      //           ),
      //         ),
      //         child: const Text('Google Sign In'),
      //       ),
      //       const SizedBox(height: 10),
      //       ElevatedButton(
      //         onPressed: () async {
      //           final result = await FacebookAuth.instance.login();
      //           final OAuthCredential credential =
      //               FacebookAuthProvider.credential(
      //                   result.accessToken?.token ?? '');

      //           final firebaseUser = await FirebaseAuth.instance
      //               .signInWithCredential(credential);
      //           print(firebaseUser.user!.displayName);
      //         },
      //         style: ElevatedButton.styleFrom(
      //           backgroundColor: Colors.blue,
      //           shape: RoundedRectangleBorder(
      //             borderRadius: BorderRadius.circular(10.0),
      //           ),
      //         ),
      //         child: const Text('Facebook'),
      //       ),
      //       const SizedBox(height: 10),
      //     ],
      //   ),
      // ),
    );
  }
}
