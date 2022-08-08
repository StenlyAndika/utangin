import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../pages/home/borrower/borrower_riwayat.dart';
import '../pages/home/lender/lender_riwayat.dart';
import '../pages/home/lender/sukses_pelunasan_lender.dart';
import '../pages/home/lender/detail_cicilan_lender.dart';
import '../pages/home/lender/evaluasi_cicilan_lender.dart';
import '../pages/home/lender/evaluasi_pembayaran.dart';
import '../pages/home/borrower/sukses_pelunasan.dart';
import '../pages/home/lender/evaluasi_pelunasan.dart';
import '../pages/home/borrower/detail_cicilan.dart';
import '../pages/home/user/form_rekening.dart';
import '../pages/home/borrower/evaluasi_cicilan.dart';
import '../pages/home/borrower/evaluasi_hutang.dart';
import '../pages/home/user/data_rekening.dart';
import '../pages/home/borrower/form_pengajuan_tawaran.dart';
import '../pages/home/borrower/tawaran_pinjaman.dart';
import '../pages/home/borrower/evaluasi_tawaran.dart';
import '../pages/home/lender/sukses_tawaran_peminjaman.dart';
import '../pages/home/lender/form_revisi.dart';
import '../pages/home/lender/sukses_revisi.dart';
import '../pages/home/lender/tawarkan_pinjaman.dart';
import '../pages/home/lender/detail_permohonan.dart';
import '../pages/home/lender/sukses_konfirmasi.dart';
import '../pages/home/lender/upload_bukti_peminjaman.dart';
import '../services/evaluasi_pinjaman_services.dart';
import '../pages/home/lender/evaluasi_pinjaman.dart';
import '../pages/home/lender/menu_lender.dart';
import '../services/auth.dart';
import '../pages/home/borrower/form_pengajuan.dart';
import '../pages/home/borrower/menu_borrower.dart';
import '../pages/home/menu_login.dart';
import '../pages/auth/authentication.dart';
import '../pages/auth/form_daftar.dart';
import '../pages/auth/sukses_daftar.dart';
import '../pages/landing.dart';
import '../pages/home/borrower/sukses_pengajuan.dart';
import '../pages/auth/form_login.dart';
import '../services/pengajuan.dart';
import '../services/evaluasi_tawaran_services.dart';
import '../services/user.dart';
import '../services/evaluasi_hutang_services.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
  runApp(MyApp());
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
        ChangeNotifierProvider(create: (context) => AuthServices()),
        ChangeNotifierProvider(create: (context) => PengajuanServices()),
        ChangeNotifierProvider(create: (context) => EvaluasiPinjamanServices()),
        ChangeNotifierProvider(create: (context) => EvaluasiTawaranServices()),
        ChangeNotifierProvider(create: (context) => EvaluasiHutangServices()),
        ChangeNotifierProvider(create: (context) => UserServices()),
      ],
      child: GestureDetector(
        onTap: () {
          FocusManager.instance.primaryFocus?.unfocus();
        },
        child: MaterialApp(
          localizationsDelegates: [
            GlobalMaterialLocalizations.delegate,
            GlobalWidgetsLocalizations.delegate,
            GlobalCupertinoLocalizations.delegate,
          ],
          supportedLocales: [
            const Locale('id', 'ID'),
          ],
          debugShowCheckedModeBanner: false,
          title: 'Utangin',
          theme: ThemeData(
            primarySwatch: Colors.red,
            appBarTheme: AppBarTheme(
              color: Color.fromARGB(250, 250, 250, 250),
            ),
          ),
          home: FutureBuilder<bool>(
            future: getsession(),
            builder: (BuildContext context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return Center(child: CircularProgressIndicator());
              } else {
                if (snapshot.data == true) {
                  return MenuLogin();
                } else {
                  return MyHomePage();
                }
              }
            },
          ),
          // initialRoute: NotifPeminjamanTerdokumentasi.nameRoute,
          routes: {
            // Landing
            MyHomePage.nameRoute: (context) => MyHomePage(),

            // auth>daftar>login
            AuthPage.nameRoute: (context) => AuthPage(),
            FormDaftar.nameRoute: (context) => FormDaftar(),
            FormLogin.nameRoute: (context) => FormLogin(),
            NotifSuksesDaftar.nameRoute: (context) => NotifSuksesDaftar(),

            // menu login
            MenuLogin.nameRoute: (context) => MenuLogin(),

            //user
            DataRekening.nameRoute: (context) => DataRekening(),
            FormRekening.nameRoute: (context) => FormRekening(),

            // fitur borrower
            MenuBorrower.nameRoute: (context) => MenuBorrower(),
            FormPengajuan.nameRoute: (context) => FormPengajuan(),
            NotifSuksesPengajuan.nameRoute: (context) => NotifSuksesPengajuan(),
            EvaluasiTawaran.nameRoute: (context) => EvaluasiTawaran(),
            TawaranPinjaman.nameRoute: (context) => TawaranPinjaman(),
            FormPengajuanTawaran.nameRoute: (context) => FormPengajuanTawaran(),
            EvaluasiHutang.nameRoute: (context) => EvaluasiHutang(),
            EvaluasiCicilan.nameRoute: (context) => EvaluasiCicilan(),
            DetailCicilan.nameRoute: (context) => DetailCicilan(),
            NotifSuksesPelunasan.nameRoute: (context) => NotifSuksesPelunasan(),
            RiwayatBorrower.nameRoute: (context) => RiwayatBorrower(),

            // fitur lender
            MenuLender.nameRoute: (context) => MenuLender(),
            TawarkanPinjaman.nameRoute: (context) => TawarkanPinjaman(),
            NotifTawaranPeminjaman.nameRoute: (context) =>
                NotifTawaranPeminjaman(),
            EvaluasiPinjaman.nameRoute: (context) => EvaluasiPinjaman(),
            DetailPermohonan.nameRoute: (context) => DetailPermohonan(),
            UploadBuktiPeminjaman.nameRoute: (context) =>
                UploadBuktiPeminjaman(),
            NotifPeminjamanTerdokumentasi.nameRoute: (context) =>
                NotifPeminjamanTerdokumentasi(),
            RevisiPinjaman.nameRoute: (context) => RevisiPinjaman(),
            NotifSuksesRevisi.nameRoute: (context) => NotifSuksesRevisi(),
            EvaluasiPelunasan.nameRoute: (context) => EvaluasiPelunasan(),
            EvaluasiPembayaran.nameRoute: (context) => EvaluasiPembayaran(),
            EvaluasiCicilanLender.nameRoute: (context) =>
                EvaluasiCicilanLender(),
            DetailCicilanLender.nameRoute: (context) => DetailCicilanLender(),
            NotifSuksesPelunasanLender.nameRoute: (context) =>
                NotifSuksesPelunasanLender(),
            RiwayatLender.nameRoute: (context) => RiwayatLender(),
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

  PassArgumentsScreen({
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
