import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_login/firebase_auth.dart';
import 'package:flutter_login/login_page.dart';

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
                  'Start your shopping\nadventure',
                  style: TextStyle(fontSize: 40, fontWeight: FontWeight.bold),
                ),
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
                      labelText: 'E-mail address'),
                  validator: (value) {
                    if (value!.isEmpty) {
                      return 'Please enter your email';
                    } else if (!RegExp(
                            r'\b[A-Za-z0-9._%+-]+@[A-Za-z0-9.-]+\.[A-Z|a-z]{2,}\b')
                        .hasMatch(value)) {
                      return 'Please enter a valid email';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16),
                TextFormField(
                  keyboardType: TextInputType.phone,
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(15))),
                    labelText: 'Phone Number',
                  ),
                  validator: (value) {
                    if (value!.isEmpty) {
                      return 'Please enter your mobile number';
                    } else if (!RegExp(r'^\d{10}$').hasMatch(value)) {
                      return 'Please enter a valid 10-digit mobile number';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16),
                // TextFormField(
                //   obscureText: obscureText && !showPassword,
                //   decoration: InputDecoration(
                //     border: const OutlineInputBorder(
                //         borderRadius: BorderRadius.all(Radius.circular(15))),
                //     labelText: 'Password',
                //     suffixIcon: IconButton(
                //       icon: Icon(
                //           showPassword ? Icons.visibility_off : Icons.visibility),
                //       onPressed: () {
                //         setState(() {
                //           showPassword = !showPassword;
                //         });
                //       },
                //     ),
                //   ),
                //   validator: (value) {
                //     if (value!.isEmpty) {
                //       return 'Please enter your password';
                //     } else if (value.length < 6) {
                //       return 'Password must be at least 6 characters long';
                //     }
                //     return null;
                //   },
                // ),
                TextFormField(
                  controller: _passwordController,
                  obscureText: _obscureText,
                  decoration: InputDecoration(
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
                        'Password must be at least 8 characters long',
                        'Password must contain at least one uppercase letter',
                        'Password must contain at least one lowercase letter',
                        'Password must contain at least one digit',
                        'Password must contain at least one special character',
                      ];
                    });
                  },
                  onChanged: (value) {
                    setState(() {
                      if (_passwordValidationTexts.isNotEmpty) {
                        if (value.length >= 8 &&
                            _passwordValidationTexts.contains(
                                'Password must be at least 8 characters long')) {
                          _passwordValidationTexts.remove(
                              'Password must be at least 8 characters long');
                        }
                        if (RegExp(r'[A-Z]').hasMatch(value) &&
                            _passwordValidationTexts.contains(
                                'Password must contain at least one uppercase letter')) {
                          _passwordValidationTexts.remove(
                              'Password must contain at least one uppercase letter');
                        }
                        if (RegExp(r'[a-z]').hasMatch(value) &&
                            _passwordValidationTexts.contains(
                                'Password must contain at least one lowercase letter')) {
                          _passwordValidationTexts.remove(
                              'Password must contain at least one lowercase letter');
                        }
                        if (RegExp(r'[0-9]').hasMatch(value) &&
                            _passwordValidationTexts.contains(
                                'Password must contain at least one digit')) {
                          _passwordValidationTexts.remove(
                              'Password must contain at least one digit');
                        }
                        if (RegExp(r'[!@#\$%\^&\*]').hasMatch(value) &&
                            _passwordValidationTexts.contains(
                                'Password must contain at least one special character')) {
                          _passwordValidationTexts.remove(
                              'Password must contain at least one special character');
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
                const Align(
                  alignment: Alignment.centerRight,
                  child: Text(
                    'Forgot password?',
                    style: TextStyle(fontSize: 17, fontWeight: FontWeight.bold),
                  ),
                ),
                const SizedBox(height: 10),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      'I would like to receive information about\nVestige innovations in my e-mail',
                      style:
                          TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
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
                const SizedBox(height: 10),
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
              ]),
        ),
      ),
    );
  }
}
