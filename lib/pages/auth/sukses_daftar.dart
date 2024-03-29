import 'package:flutter/material.dart';
import '../../../pages/landing.dart';

class NotifSuksesDaftar extends StatelessWidget {
  NotifSuksesDaftar({Key? key}) : super(key: key);

  static const nameRoute = '/page2';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      body: Stack(
        children: [
          Image.asset(
            "img/secondary-background.jpg",
            fit: BoxFit.cover,
            height: double.infinity,
            width: double.infinity,
            alignment: Alignment.center,
          ),
          Align(
            alignment: Alignment.center,
            child: SizedBox(
              width: MediaQuery.of(context).size.width * 0.8,
              child: ListView(
                children: [
                  SizedBox(
                    height: MediaQuery.of(context).size.height * 0.2,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        "Selamat",
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Icon(
                        Icons.celebration,
                        color: Colors.red,
                      ),
                    ],
                  ),
                  Text(
                    "Akunmu telah terdaftar",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(
                    height: 30,
                  ),
                  Text(
                    "Selamat bergabung di aplikasi pendokumentasian pinjam-meminjammu. Kami akan melakukan review atas akunmu. Kami akan menginformasikan via email terkait status akunmu.",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 15,
                    ),
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        "U",
                        style: TextStyle(
                            color: Colors.red,
                            fontSize: 40,
                            fontWeight: FontWeight.bold),
                      ),
                      Text(
                        " T A N G I N . C O M",
                        style: TextStyle(
                            color: Colors.red,
                            fontSize: 15,
                            fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Padding(
                    padding: EdgeInsets.all(10),
                    child: ElevatedButton(
                      onPressed: () {
                        Navigator.of(context)
                            .pushReplacementNamed(MyHomePage.nameRoute);
                      },
                      style: ElevatedButton.styleFrom(
                        minimumSize: Size.fromHeight(40),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                      child: Text(
                        "Kembali",
                        style: TextStyle(fontSize: 15),
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 100,
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
