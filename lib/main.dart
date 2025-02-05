import 'package:ecommerce_app/provider/cart_provider.dart';
import 'package:ecommerce_app/provider/favorite_provider.dart';
import 'package:ecommerce_app/screens/bottom_navbar.dart';
import 'package:ecommerce_app/screens/favorite_screen.dart';
import 'package:ecommerce_app/screens/login_screen.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

import 'screens/cart_screen.dart';

void main() {
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => CartProvider()),
        ChangeNotifierProvider(create: (_) => FavoritesProvider()),
      ],
      child: MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'E-commerce App',
      theme: ThemeData(

        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
        textTheme: GoogleFonts.montserratTextTheme(), // Apply Montserrat text theme
        tabBarTheme: TabBarTheme( // Proper TabBarTheme object
          labelStyle: GoogleFonts.montserrat(
            fontWeight: FontWeight.bold,
          ),
          unselectedLabelStyle: GoogleFonts.montserrat(),
          indicator: UnderlineTabIndicator(
            borderSide: BorderSide(color: Colors.deepPurple, width: 2),
          ),
        ),
      ),debugShowCheckedModeBanner: false,
      home: Login(),
      routes: {
        '/cart': (context) => CartScreen(),
        '/favorites': (context) => FavoritesScreen(),
      },
    );
  }
}
