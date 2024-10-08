import 'package:barang/screens/login/login_screen.dart';
import 'package:barang/screens/login/register_screen.dart';
import 'package:barang/screens/product/product_list_page.dart';
import 'package:barang/services/auth_services.dart';
import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';

void main() {
  // Mematikan banner debug
  WidgetsFlutterBinding.ensureInitialized();
  if (kReleaseMode) {
    debugPrint = (String? message, {int? wrapWidth}) {};
  }

  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  final AuthService _authService = AuthService();

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Toko App',
      debugShowCheckedModeBanner: false, // Mematikan banner "DEBUG"
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: FutureBuilder<bool>(
        future: _authService.isLoggedIn(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Scaffold(
              body: Center(
                child: CircularProgressIndicator(),
              ),
            );
          } else {
            if (snapshot.data == true) {
              return ProductListPage();
            } else {
              return LoginScreen();
            }
          }
        },
      ),
      routes: {
        '/login': (context) => LoginScreen(),
        '/register': (context) => RegisterScreen(),
        '/products': (context) => ProductListPage(),
      },
    );
  }
}
