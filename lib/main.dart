import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../pages/home/borrower/form_pengajuan_tawaran.dart';
import '../pages/home/borrower/tawaran_pinjaman.dart';
import '../pages/home/borrower/evaluasi_tawaran.dart';
import '../pages/home/lender/sukses_tawaran_peminjaman.dart';
import '../pages/home/lender/form_revisi.dart';
import '../pages/home/lender/sukses_revisi.dart';
import '../pages/home/lender/tawarkan_pinjaman.dart';
import '../pages/home/lender/detail_permohonan.dart';
import '../pages/home/lender/sukses_konfirmasi.dart';
import '../pages/home/lender/upload__bukti_peminjaman.dart';
import '../models/evaluasi_pinjaman_model.dart';
import '../pages/home/lender/evaluasi_pinjaman.dart';
import '../pages/home/lender/menu_lender.dart';
import '../models/auth.dart';
import '../pages/home/borrower/form_pengajuan.dart';
import '../pages/home/borrower/menu_borrower.dart';
import '../pages/home/menu_login.dart';
import '../pages/auth/authentication.dart';
import '../pages/auth/form_daftar.dart';
import '../pages/auth/sukses_daftar.dart';
import '../pages/landing.dart';
import '../pages/home/borrower/sukses_pengajuan.dart';
import '../pages/auth/form_login.dart';
import '../models/pengajuan.dart';
import '../models/evaluasi_tawaran_model.dart';

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
        ChangeNotifierProvider(create: (context) => PengajuanModel()),
        ChangeNotifierProvider(create: (context) => EvaluasiPinjamanModel()),
        ChangeNotifierProvider(create: (context) => EvaluasiTawaranModel()),
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
          home: FutureBuilder<bool>(
            future: getsession(),
            builder: (BuildContext context, snapshot) {
              if (snapshot.data == true) {
                return const MenuLogin();
              } else {
                return const MyHomePage();
              }
            },
          ),
          routes: {
            // Landing
            MyHomePage.nameRoute: (context) => const MyHomePage(),

            // auth>daftar>login
            AuthPage.nameRoute: (context) => const AuthPage(),
            FormDaftar.nameRoute: (context) => const FormDaftar(),
            FormLogin.nameRoute: (context) => const FormLogin(),
            NotifSuksesDaftar.nameRoute: (context) => const NotifSuksesDaftar(),

            // menu login
            MenuLogin.nameRoute: (context) => const MenuLogin(),

            // fitur borrower
            MenuBorrower.nameRoute: (context) => const MenuBorrower(),
            FormPengajuan.nameRoute: (context) => const FormPengajuan(),
            NotifSuksesPengajuan.nameRoute: (context) =>
                const NotifSuksesPengajuan(),

            EvaluasiTawaran.nameRoute: (context) => const EvaluasiTawaran(),
            TawaranPinjaman.nameRoute: (context) => const TawaranPinjaman(),
            FormPengajuanTawaran.nameRoute: (context) =>
                const FormPengajuanTawaran(),

            // fitur lender
            MenuLender.nameRoute: (context) => const MenuLender(),
            TawarkanPinjaman.nameRoute: (context) => const TawarkanPinjaman(),
            NotifTawaranPeminjaman.nameRoute: (context) =>
                const NotifTawaranPeminjaman(),

            EvaluasiPinjaman.nameRoute: (context) => const EvaluasiPinjaman(),
            DetailPermohonan.nameRoute: (context) => const DetailPermohonan(),
            UploadBuktiPeminjaman.nameRoute: (context) =>
                const UploadBuktiPeminjaman(),
            NotifPeminjamanTerdokumentasi.nameRoute: (context) =>
                const NotifPeminjamanTerdokumentasi(),
            RevisiPinjaman.nameRoute: (context) => const RevisiPinjaman(),
            NotifSuksesRevisi.nameRoute: (context) => const NotifSuksesRevisi(),
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
