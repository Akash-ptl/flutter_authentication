import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_login/global.dart';
import 'package:flutter_login/login_page.dart';

class NumberPage extends StatefulWidget {
  const NumberPage({super.key});

  @override
  State<NumberPage> createState() => _NumberPageState();
}

class _NumberPageState extends State<NumberPage> {
  final _formKey = GlobalKey<FormState>();
  TextEditingController phonecontroller = TextEditingController();
  final TextEditingController _otpController = TextEditingController();
  late bool _showOtpInput = false;
  late String _verificationId = '';

  Future<void> verifyPhoneNumber(String phoneNumber) async {
    final FirebaseAuth auth = FirebaseAuth.instance;

    await auth.verifyPhoneNumber(
      phoneNumber: phoneNumber,
      verificationCompleted: (PhoneAuthCredential credential) async {
        await auth.signInWithCredential(credential);
        // Code to navigate to next screen or perform other action upon successful login
      },
      verificationFailed: (FirebaseAuthException e) {
        print(e.message);
      },
      codeSent: (String verificationId, int? resendToken) {
        setState(() {
          _verificationId = verificationId;
          _showOtpInput = true;
        });
        // Save the verification ID somewhere so that you can use it later.
        // For example, you can save it to a state variable.
      },
      codeAutoRetrievalTimeout: (String verificationId) {},
    );
  }

  Future<void> signInWithCredential(String otp) async {
    final FirebaseAuth auth = FirebaseAuth.instance;

    try {
      final PhoneAuthCredential credential = PhoneAuthProvider.credential(
          verificationId: _verificationId, smsCode: otp);
      await auth.signInWithCredential(credential);
      // Code to navigate to next screen or perform other action upon successful login
    } catch (e) {
      print(e.toString());
    }
  }

  @override
  Widget build(BuildContext context) {
    double h = MediaQuery.of(context).size.height;
    double w = MediaQuery.of(context).size.width;
    return Scaffold(
      appBar: null,
      body: Form(
          key: _formKey,
          child: Padding(
            padding: const EdgeInsets.all(30),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Visibility(
                  visible: !_showOtpInput,
                  child: TextFormField(
                    controller: phonecontroller,
                    decoration: const InputDecoration(
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(15))),
                      labelText: 'Phone number',
                    ),
                    validator: validateEmailMobile,
                  ),
                ),
                const SizedBox(
                  height: 16,
                ),
                if (_showOtpInput)
                  TextField(
                    controller: _otpController,
                    decoration: const InputDecoration(
                        border: OutlineInputBorder(
                            borderRadius:
                                BorderRadius.all(Radius.circular(15))),
                        labelText: 'OTP'),
                    keyboardType: TextInputType.number,
                  ),
                const SizedBox(height: 16),
                GestureDetector(
                  onTap: () async {
                    if (_showOtpInput) {
                      final otp = _otpController.text.trim();
                      if (otp.isNotEmpty) {
                        signInWithCredential(otp);
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => const LoginPage()),
                        );
                      }
                    } else {
                      final phoneNumber = phonecontroller.text.trim();
                      if (phoneNumber.isNotEmpty) {
                        verifyPhoneNumber(phoneNumber);
                      }
                    }
                  },
                  child: Container(
                    alignment: Alignment.center,
                    height: h / 22,
                    width: w,
                    decoration: BoxDecoration(
                        color: _showOtpInput ? Colors.black : Colors.white,
                        border: Border.all(),
                        borderRadius: BorderRadius.circular(15)),
                    child: Text(
                      _showOtpInput ? 'Verify OTP' : 'Send OTP',
                      style: TextStyle(
                          fontSize: 20,
                          color: _showOtpInput ? Colors.white : Colors.black),
                    ),
                  ),
                ),
              ],
            ),
          )),
    );
  }
}
