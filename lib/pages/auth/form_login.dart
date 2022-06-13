import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../pages/auth/authentication.dart';
import '../../../models/auth.dart';
import '../../../template/reusablewidgets.dart';

class FormLogin extends StatefulWidget {
  const FormLogin({Key? key}) : super(key: key);

  static const nameRoute = '/pagelogin';

  @override
  State<FormLogin> createState() => _FormLoginState();
}

class _FormLoginState extends State<FormLogin> {
  late TextEditingController email;
  late TextEditingController password;

  bool _isVisible = true;

  @override
  void initState() {
    email = TextEditingController();
    password = TextEditingController();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final login = Provider.of<AuthModel>(context, listen: false);
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: ReusableWidgets.backAppBar("Log in", context),
      body: Container(
        padding: const EdgeInsets.only(left: 20, right: 20, bottom: 10),
        child: ListView(
          children: [
            SizedBox(
              width: MediaQuery.of(context).size.width,
              child: Padding(
                padding: const EdgeInsets.only(left: 30, right: 30),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: const [
                    Text(
                      "U",
                      style: TextStyle(
                          color: Colors.red,
                          fontSize: 30,
                          fontWeight: FontWeight.bold),
                    ),
                    Text(
                      " T A N G I N . C O M",
                      style: TextStyle(
                          color: Colors.red,
                          fontSize: 12,
                          fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 20),
            ReusableWidgets.inputField(
                "Email", email, TextInputType.emailAddress),
            const SizedBox(height: 5),
            Container(
              padding: const EdgeInsets.only(left: 5),
              decoration: BoxDecoration(
                border:
                    Border.all(color: const Color.fromARGB(255, 184, 174, 174)),
                borderRadius: BorderRadius.circular(10),
              ),
              child: TextField(
                controller: password,
                textCapitalization: TextCapitalization.none,
                style: const TextStyle(
                  fontSize: 18,
                  color: Colors.black,
                ),
                cursorColor: Colors.black,
                autocorrect: false,
                obscureText: _isVisible,
                enableSuggestions: false,
                decoration: InputDecoration(
                  contentPadding: const EdgeInsets.all(5),
                  suffixIcon: IconButton(
                    onPressed: () {
                      setState(() {
                        _isVisible = !_isVisible;
                      });
                    },
                    icon: _isVisible
                        ? const Icon(Icons.visibility_off)
                        : const Icon(Icons.visibility),
                  ),
                  border: InputBorder.none,
                  labelText: "Password",
                  labelStyle: const TextStyle(
                      color: Color.fromARGB(255, 110, 108, 108)),
                ),
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                TextButton(
                  onPressed: () {},
                  child: const Text(
                    "Lupa Password?",
                    style: TextStyle(
                      color: Colors.red,
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                TextButton(
                  onPressed: () {
                    Navigator.of(context)
                        .pushReplacementNamed(AuthPage.nameRoute);
                  },
                  child: const Text(
                    "Belum daftar?",
                    style: TextStyle(
                      color: Colors.red,
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
            Container(
              padding: const EdgeInsets.only(left: 5, right: 5),
              child: Wrap(
                children: [
                  const InkWell(
                    child: SizedBox(
                      height: 20,
                      child: Text(
                        "By continuing, you are agree to our ",
                        textAlign: TextAlign.left,
                        style: TextStyle(color: Colors.black, fontSize: 12),
                      ),
                    ),
                  ),
                  InkWell(
                    onTap: () {
                      Navigator.of(context)
                          .pushReplacementNamed(FormLogin.nameRoute);
                    },
                    child: const SizedBox(
                      height: 20,
                      child: Text(
                        "Terms of Service",
                        textAlign: TextAlign.left,
                        style: TextStyle(color: Colors.red, fontSize: 12),
                      ),
                    ),
                  ),
                  const InkWell(
                    child: SizedBox(
                      height: 20,
                      child: Text(
                        " and ",
                        textAlign: TextAlign.left,
                        style: TextStyle(color: Colors.black, fontSize: 12),
                      ),
                    ),
                  ),
                  InkWell(
                    onTap: () {
                      Navigator.of(context)
                          .pushReplacementNamed(FormLogin.nameRoute);
                    },
                    child: const SizedBox(
                      height: 20,
                      child: Text(
                        "Privacy Policy",
                        textAlign: TextAlign.left,
                        style: TextStyle(color: Colors.red, fontSize: 12),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            ElevatedButton(
              onPressed: () async {
                login.login(email.text, password.text, context);
              },
              style: ElevatedButton.styleFrom(
                minimumSize: const Size.fromHeight(50),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              child: const Text(
                "Log in",
                style: TextStyle(fontSize: 15),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
