import 'package:eshop/firebase_options.dart';
import 'package:eshop/providers/product_provider.dart';
import 'package:eshop/screens/home_screen.dart';
import 'package:eshop/screens/login_screen.dart';
import 'package:eshop/screens/register_screen.dart';
import 'package:eshop/services/auth_service.dart';
import 'package:eshop/services/remote_config_service.dart';
import 'package:eshop/utils/constants.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  // Check login status
  SharedPreferences prefs = await SharedPreferences.getInstance();
  bool isLoggedIn = prefs.getBool('isLoggedIn') ?? false;

  runApp(MyApp(isLoggedIn: isLoggedIn));
}

class MyApp extends StatelessWidget {
  final bool isLoggedIn;

  MyApp({required this.isLoggedIn});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AuthService()),
        ChangeNotifierProvider(create: (_) => ProductProvider()),
        ChangeNotifierProvider(create: (_) => RemoteConfigProvider()),
      ],
      child: MaterialApp(
        title: 'e-Shop',
        theme: ThemeData(
          primaryColor: primaryColor,
          scaffoldBackgroundColor: lightColor,
          textTheme: const TextTheme(
            headlineLarge: TextStyle(
              fontFamily: fontPoppins,
              fontWeight: fontWeightBold,
              color: primaryColor,
            ),
            bodyLarge: TextStyle(
              fontFamily: fontPoppins,
              fontWeight: fontWeightRegular,
              color: secondaryColor,
            ),
            displayMedium: TextStyle(
              fontFamily: fontPoppins,
              fontWeight: fontWeightMedium,
            ),
          ),
          elevatedButtonTheme: ElevatedButtonThemeData(
            style: ElevatedButton.styleFrom(
              backgroundColor: primaryColor,
              foregroundColor: Colors.white,
              textStyle: const TextStyle(
                fontFamily: fontPoppins,
                fontWeight: fontWeightMedium,
              ),
            ),
          ),
          inputDecorationTheme: const InputDecorationTheme(
            border: OutlineInputBorder(),
          ),
        ),
        initialRoute: isLoggedIn ? '/home' : '/',
        routes: {
          '/': (context) => LoginScreen(),
          '/signup': (context) => RegisterScreen(),
          '/signin': (context) => LoginScreen(),
          '/home': (context) => const HomeScreen(),
        },
      ),
    );
  }
}
