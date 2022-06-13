import 'dart:async';

import 'package:email_validator/email_validator.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../pages/auth/form_login.dart';
import '../../../main.dart';
import '../../../models/auth.dart';
import '../../../template/reusablewidgets.dart';
import 'form_daftar.dart';

class AuthPage extends StatefulWidget {
  const AuthPage({Key? key}) : super(key: key);

  static const nameRoute = '/pageauthentication';

  @override
  State<AuthPage> createState() => _AuthPageState();
}

class _AuthPageState extends State<AuthPage> {
  late Timer _timer;
  late int _countdown;
  final email = TextEditingController();
  final nohp = TextEditingController();
  final kodeotp = TextEditingController();
  late bool otpsend, otpverified, _emailvalid, _start;
  late FocusNode _focusNode;
  late TextEditingController _textFieldController;

  @override
  void initState() {
    email.text = "";
    nohp.text = "";
    otpsend = false;
    otpverified = false;
    _emailvalid = false;
    _start = false;
    _focusNode = FocusNode();
    _focusNode.addListener(() {
      if (_focusNode.hasFocus) _textFieldController.clear();
    });
    super.initState();
  }

  void startTimer() {
    _countdown = 60;
    const oneSec = Duration(seconds: 1);
    _timer = Timer.periodic(
      oneSec,
      (Timer timer) => setState(
        () {
          if (_countdown < 1) {
            _start = false;
            timer.cancel();
          } else {
            _countdown = _countdown - 1;
          }
        },
      ),
    );
  }

  @override
  void dispose() {
    if (_start == true) {
      _timer.cancel();
    }
    _start = false;
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final daftar = Provider.of<AuthModel>(context, listen: false);
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: ReusableWidgets.backAppBar("", context),
      body: Container(
        padding: const EdgeInsets.only(left: 20, right: 20, top: 20),
        child: ListView(
          children: [
            const Text(
              "Selamat Bergabung",
              textAlign: TextAlign.left,
              style: TextStyle(
                fontSize: 30,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 10),
            InkWell(
              onTap: () {
                Navigator.of(context).pushReplacementNamed(FormLogin.nameRoute);
              },
              child: const SizedBox(
                height: 40,
                child: Text(
                  "Masuk ke akunmu",
                  textAlign: TextAlign.left,
                  style: TextStyle(
                      color: Colors.red,
                      fontSize: 16,
                      fontWeight: FontWeight.bold),
                ),
              ),
            ),
            const SizedBox(height: 10),
            ReusableWidgets.inputField("No HP", nohp, TextInputType.phone),
            const SizedBox(height: 5),
            Container(
              padding: const EdgeInsets.only(left: 5),
              decoration: BoxDecoration(
                border:
                    Border.all(color: const Color.fromARGB(255, 184, 174, 174)),
                borderRadius: BorderRadius.circular(10),
              ),
              child: TextField(
                controller: email,
                onChanged: (email) {
                  otpsend = false;
                  setState(() {
                    _emailvalid = EmailValidator.validate(email);
                    if (_emailvalid == true) {
                      daftar.checkEmail(email);
                    }
                  });
                },
                style: const TextStyle(
                  fontSize: 18,
                  color: Colors.black,
                ),
                cursorColor: Colors.black,
                autocorrect: false,
                keyboardType: TextInputType.emailAddress,
                enableSuggestions: false,
                decoration: const InputDecoration(
                  contentPadding: EdgeInsets.all(5),
                  border: InputBorder.none,
                  labelText: "Email",
                  labelStyle:
                      TextStyle(color: Color.fromARGB(255, 110, 108, 108)),
                ),
              ),
            ),
            Container(
              padding: const EdgeInsets.only(left: 10),
              child: Column(
                children: [
                  if (email.text != "" && otpsend == false) ...[
                    const SizedBox(height: 5),
                    Row(
                      children: [
                        Consumer<AuthModel>(
                          builder: (context, value, child) => AnimatedContainer(
                            duration: const Duration(milliseconds: 500),
                            width: 15,
                            height: 15,
                            decoration: BoxDecoration(
                                color: (value.emailterdaftar == "true")
                                    ? Colors.red
                                    : (_emailvalid == true)
                                        ? Colors.green
                                        : Colors.red,
                                border: (value.emailterdaftar == "true")
                                    ? Border.all(color: Colors.transparent)
                                    : Border.all(color: Colors.grey.shade400),
                                borderRadius: BorderRadius.circular(50)),
                            child: Center(
                              child: (value.emailterdaftar == "true")
                                  ? const Icon(
                                      Icons.close_rounded,
                                      color: Colors.white,
                                      size: 10,
                                    )
                                  : (_emailvalid == true)
                                      ? const Icon(
                                          Icons.check,
                                          color: Colors.white,
                                          size: 10,
                                        )
                                      : const Icon(
                                          Icons.close_rounded,
                                          color: Colors.white,
                                          size: 10,
                                        ),
                            ),
                          ),
                        ),
                        const SizedBox(width: 10),
                        Consumer<AuthModel>(
                          builder: (context, value, child) => Text(
                            (value.emailterdaftar == "true")
                                ? "Email sudah terdaftar"
                                : (_emailvalid == true)
                                    ? "Email siap digunakan"
                                    : "Email tidak valid",
                            style: const TextStyle(fontSize: 12),
                          ),
                        ),
                      ],
                    ),
                  ],
                ],
              ),
            ),
            Column(
              children: [
                const SizedBox(height: 5),
                Visibility(
                  visible: (otpsend == true) ? true : false,
                  child: Container(
                    padding: const EdgeInsets.only(left: 5),
                    decoration: BoxDecoration(
                      border: Border.all(
                          color: const Color.fromARGB(255, 184, 174, 174)),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: TextField(
                      textInputAction: TextInputAction.next,
                      controller: kodeotp,
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                      ),
                      cursorColor: Colors.black,
                      autocorrect: false,
                      keyboardType: TextInputType.emailAddress,
                      enableSuggestions: false,
                      decoration: const InputDecoration(
                        contentPadding: EdgeInsets.all(5),
                        border: InputBorder.none,
                        labelText: "Kode OTP",
                        labelStyle: TextStyle(
                            color: Color.fromARGB(255, 110, 108, 108)),
                      ),
                    ),
                  ),
                ),
              ],
            ),
            Consumer<AuthModel>(
              builder: (context, value, child) => Visibility(
                visible: (otpsend == true) ? true : false,
                child: Column(
                  children: [
                    const SizedBox(height: 5),
                    ElevatedButton(
                      onPressed: () async {
                        if (value.verifotp == kodeotp.text) {
                          otpverified = true;
                          await ReusableWidgets.alertNotification(context,
                              "Verifikasi Berhasil.", Icons.celebration);
                          Navigator.of(context).pushReplacementNamed(
                            FormDaftar.nameRoute,
                            arguments: ScreenArguments(
                              nohp.text,
                              email.text,
                            ),
                          );
                        } else {
                          otpverified = false;
                          ReusableWidgets.alertNotification(
                              context,
                              "Verifikasi gagal. periksa kembali kode OTP anda.",
                              Icons.celebration);
                        }
                      },
                      style: ElevatedButton.styleFrom(
                        minimumSize: const Size.fromHeight(50),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                      child: const Text(
                        "Verifikasi",
                        style: TextStyle(fontSize: 15),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Consumer<AuthModel>(
              builder: (context, value, child) => Visibility(
                visible: (_emailvalid)
                    ? (value.emailterdaftar == "true")
                        ? false
                        : true
                    : false,
                child: Column(
                  children: [
                    const SizedBox(height: 5),
                    ElevatedButton(
                      onPressed: (_start == false)
                          ? () {
                              setState(() {
                                startTimer();
                                _start = true;
                                otpsend = true;
                                daftar.kirimOTP(email.text);
                                ReusableWidgets.alertNotification(
                                    context,
                                    "Kode OTP telah dikirimkan ke ${email.text}. silakan cek email anda.",
                                    Icons.celebration);
                              });
                            }
                          : null,
                      style: ElevatedButton.styleFrom(
                        minimumSize: const Size.fromHeight(50),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                      child: Text(
                        (_start == true)
                            ? "Kirim ulang kode dalam $_countdown detik"
                            : "Kirim OTP",
                        style: TextStyle(
                            color:
                                (_start == true) ? Colors.red : Colors.white),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
