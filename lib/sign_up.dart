import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_login/firebase_auth.dart';
import 'package:flutter_login/global.dart';
import 'package:flutter_login/login_page.dart';
import 'package:flutter_login/number.dart';

class SignupPage extends StatefulWidget {
  const SignupPage({super.key});

  @override
  State<SignupPage> createState() => _SignupPageState();
}

class _SignupPageState extends State<SignupPage> {
  bool _isSwitched = false;
  final String _passwordValidationText = '';
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  bool _obscureText = true;
  List<String> _passwordValidationTexts = [];

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
          child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Spacer(),
                const Text(
                  'Start your shopping\nadventure',
                  style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
                ),
                SizedBox(height: h / 16),
                TextFormField(
                  controller: _nameController,
                  decoration: const InputDecoration(
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(15))),
                      labelText: 'Full name'),
                  validator: (value) {
                    if (value!.isEmpty) {
                      return 'Please enter your name';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16),
                TextFormField(
                  controller: _emailController,
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
                  obscureText: _obscureText,
                  decoration: InputDecoration(
                    border: const OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(15))),
                    labelText: 'Password',
                    suffixIcon: IconButton(
                      icon: Icon(_obscureText
                          ? Icons.visibility_off
                          : Icons.visibility),
                      onPressed: () {
                        setState(() {
                          _obscureText = !_obscureText;
                        });
                      },
                    ),
                  ),
                  onTap: () {
                    setState(() {
                      _passwordValidationTexts = [
                        '8 characters minimum',
                        'One uppercase letter',
                        'One lowercase letter',
                        'One digit',
                        'One special character',
                      ];
                    });
                  },
                  onChanged: (value) {
                    setState(() {
                      if (_passwordValidationTexts.isNotEmpty) {
                        if (value.length >= 8 &&
                            _passwordValidationTexts
                                .contains('8 characters minimum')) {
                          _passwordValidationTexts
                              .remove('8 characters minimum');
                        }
                        if (RegExp(r'[A-Z]').hasMatch(value) &&
                            _passwordValidationTexts
                                .contains('One uppercase letter')) {
                          _passwordValidationTexts
                              .remove('One uppercase letter');
                        }
                        if (RegExp(r'[a-z]').hasMatch(value) &&
                            _passwordValidationTexts
                                .contains('One lowercase letter')) {
                          _passwordValidationTexts
                              .remove('One lowercase letter');
                        }
                        if (RegExp(r'[0-9]').hasMatch(value) &&
                            _passwordValidationTexts.contains('One digit')) {
                          _passwordValidationTexts.remove('One digit');
                        }
                        if (RegExp(r'[!@#\$%\^&\*]').hasMatch(value) &&
                            _passwordValidationTexts
                                .contains('One special character')) {
                          _passwordValidationTexts
                              .remove('One special character');
                        }
                      }
                    });
                  },
                  validator: (value) {
                    if (value!.isEmpty) {
                      return 'Please enter your password';
                    } else if (_passwordValidationTexts.isNotEmpty) {
                      return 'Please enter a valid password';
                    }
                    return null;
                  },
                ),
                SizedBox(
                  height: 100,
                  child: Stack(
                    children: _passwordValidationTexts.map((text) {
                      return Positioned(
                        top:
                            10.0 * (_passwordValidationTexts.indexOf(text) + 1),
                        left: 0.0,
                        child: Text(
                          text,
                          style: const TextStyle(color: Colors.red),
                        ),
                      );
                    }).toList(),
                  ),
                ),
                Text(
                  _passwordValidationText,
                  style: TextStyle(
                    color: _passwordValidationText.isNotEmpty
                        ? Colors.red
                        : Colors.transparent,
                  ),
                ),
                const SizedBox(height: 10),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      'I would like to receive information about\nVestige innovations in my e-mail',
                      style:
                          TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                    ),
                    Switch(
                      value: _isSwitched,
                      onChanged: (value) {
                        setState(() {
                          _isSwitched = value;
                        });
                      },
                      activeColor: Colors.black,
                      inactiveThumbColor: Colors.black,
                      inactiveTrackColor: Colors.grey[300],
                      activeTrackColor: Colors.grey[600],
                    )
                  ],
                ),
                const Spacer(),
                GestureDetector(
                  onTap: () async {
                    if (_formKey.currentState!.validate()) {
                      String name = _nameController.text.trim();
                      String email = _emailController.text.trim();
                      String password = _passwordController.text.trim();

                      User? user = await FireAuth.registerUsingEmailPassword(
                        name: name,
                        email: email,
                        password: password,
                      );
                      print(user);
                      if (user != null) {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const LoginPage(),
                            ));
                      } else {}
                    }
                  },
                  child: Container(
                    alignment: Alignment.center,
                    height: h / 22,
                    width: w,
                    decoration: BoxDecoration(
                        border: Border.all(),
                        borderRadius: BorderRadius.circular(15)),
                    child: const Text(
                      'Sign up',
                      style: TextStyle(
                        fontSize: 20,
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 15),
                Center(
                  child: RichText(
                    text: const TextSpan(
                      children: [
                        TextSpan(
                          text: "Already have an account? ",
                          style: TextStyle(
                              fontSize: 14,
                              color: Colors.black,
                              fontFamily: 'Sans'),
                        ),
                        TextSpan(
                          text: "Sign in",
                          style: TextStyle(
                              fontSize: 15,
                              color: Colors.black,
                              fontWeight: FontWeight.bold,
                              fontFamily: 'Sans'),
                        ),
                      ],
                    ),
                  ),
                ),
                Align(
                  alignment: Alignment.center,
                  child: TextButton(
                      onPressed: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const NumberPage(),
                            ));
                      },
                      child: const Text('Sign up using mobile number')),
                ),
                const Spacer(),
                Center(
                  child: RichText(
                    text: const TextSpan(
                      children: [
                        TextSpan(
                          text: "By signing up, you agree to our",
                          style: TextStyle(
                              fontSize: 14,
                              color: Colors.black,
                              fontFamily: 'Sans'),
                        ),
                        TextSpan(
                          text: "Terms. ",
                          style: TextStyle(
                              fontSize: 12,
                              color: Colors.black,
                              fontWeight: FontWeight.bold,
                              fontFamily: 'Sans'),
                        ),
                        TextSpan(
                          text: "see how we use\nyour data in our",
                          style: TextStyle(
                              fontSize: 12,
                              color: Colors.black,
                              fontFamily: 'Sans'),
                        ),
                        TextSpan(
                          text: "Privacy Policy",
                          style: TextStyle(
                              fontSize: 12,
                              color: Colors.black,
                              fontWeight: FontWeight.bold,
                              fontFamily: 'Sans'),
                        ),
                      ],
                    ),
                  ),
                ),
              ]),
        ),
      ),
    );
  }
}
