import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:utangin/models/auth.dart';
import 'package:utangin/pages/home/menu_borrower.dart';
import '../../pages/home/menu_login.dart';
import '../../pages/auth/authentication.dart';
import '../../pages/auth/form_daftar.dart';
import '../../pages/auth/sukses_daftar.dart';
import '../../pages/landing.dart';
import '../../pages/forlater/ajukan_pinjaman.dart';
import '../../pages/forlater/pelunasan.dart';
import '../../pages/forlater/pelunasan_konfirmasi.dart';
import '../../pages/forlater/peminjaman_terdokumentasi.dart';
import '../../pages/forlater/revisi_peminjaman.dart';
import '../../pages/forlater/sukses_pelunasan.dart';
import '../../pages/forlater/sukses_pengajuan.dart';
import '../../pages/forlater/sukses_tawaran_peminjaman.dart';
import '../../pages/forlater/tawaran_pinjaman.dart';
import '../../pages/forlater/tawarkan_pinjaman.dart';
import '../../pages/auth/form_login.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
  runApp(const MyApp());
}

class MyHttpOverrides extends HttpOverrides {
  @override
  HttpClient createHttpClient(SecurityContext? context) {
    return super.createHttpClient(context)
      ..badCertificateCallback =
          (X509Certificate cert, String host, int port) => true;
  }
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  Future<bool> getsession() async {
    bool status;
    final prefs = await SharedPreferences.getInstance();
    if (!prefs.containsKey('status')) {
      status = false;
    }
    if (prefs.getBool('status') == true) {
      status = true;
    } else {
      status = false;
    }
    return status;
  }

  @override
  Widget build(BuildContext context) {
    // HttpOverrides.global = MyHttpOverrides();
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => AuthModel()),
      ],
      child: GestureDetector(
        onTap: () {
          FocusManager.instance.primaryFocus?.unfocus();
        },
        child: MaterialApp(
          debugShowCheckedModeBanner: false,
          title: 'Utangin',
          theme: ThemeData(
            primarySwatch: Colors.red,
            appBarTheme: const AppBarTheme(
              color: Color.fromARGB(250, 250, 250, 250),
            ),
          ),
          initialRoute: MenuBorrower.nameRoute,
          // home: FutureBuilder<bool>(
          //   future: getsession(),
          //   builder: (BuildContext context, snapshot) {
          //     if (snapshot.data == true) {
          //       return const MenuLogin();
          //     } else {
          //       return const MyHomePage();
          //     }
          //   },
          // ),
          routes: {
            AuthPage.nameRoute: (context) => const AuthPage(),
            MyHomePage.nameRoute: (context) => const MyHomePage(),
            FormDaftar.nameRoute: (context) => const FormDaftar(),
            FormLogin.nameRoute: (context) => const FormLogin(),
            MenuLogin.nameRoute: (context) => const MenuLogin(),
            MenuBorrower.nameRoute: (context) => const MenuBorrower(),
            FormPelunasan.nameRoute: (context) => const FormPelunasan(),
            FormPelunasanLender.nameRoute: (context) =>
                const FormPelunasanLender(),
            PengajuanPinjaman.nameRoute: (context) => const PengajuanPinjaman(),
            TawarkanPinjaman.nameRoute: (context) => const TawarkanPinjaman(),
            TawaranPeminjamanLender.nameRoute: (context) =>
                const TawaranPeminjamanLender(),
            NotifSuksesDaftar.nameRoute: (context) => const NotifSuksesDaftar(),
            NotifSuksesPengajuan.nameRoute: (context) =>
                const NotifSuksesPengajuan(),
            NotifSuksesPelunasan.nameRoute: (context) =>
                const NotifSuksesPelunasan(),
            NotifTawaranPeminjaman.nameRoute: (context) =>
                const NotifTawaranPeminjaman(),
            NotifRevisiPeminjaman.nameRoute: (context) =>
                const NotifRevisiPeminjaman(),
            NotifPeminjamanTerdokumentasi.nameRoute: (context) =>
                const NotifPeminjamanTerdokumentasi(),
          },
          onGenerateRoute: (settings) {
            if (settings.name == PassArgumentsScreen.routeName) {
              final args = settings.arguments as ScreenArguments;
              return MaterialPageRoute(
                builder: (context) {
                  return PassArgumentsScreen(
                    title: args.title,
                    message: args.message,
                  );
                },
              );
            }
            return null;
          },
        ),
      ),
    );
  }
}

class PassArgumentsScreen extends StatelessWidget {
  static const routeName = '/passArguments';

  final String title;
  final String message;

  const PassArgumentsScreen({
    Key? key,
    required this.title,
    required this.message,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(title),
      ),
      body: Center(
        child: Text(message),
      ),
    );
  }
}

class ScreenArguments {
  final String title;
  final String message;

  ScreenArguments(this.title, this.message);
}
