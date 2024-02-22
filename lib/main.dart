import 'package:the_bartender/colour_scheme.dart';
import 'package:flutter/material.dart';

import "bottom_nav.dart";


class MyApp extends StatelessWidget {
    const MyApp({super.key});
    
    @override
    Widget build(BuildContext context) {
        return MaterialApp(
            title: 'Cocktails',
            theme: ThemeData(
                colorScheme: ColorScheme.fromSeed(seedColor: tertiaryColour),
                useMaterial3: true,
                scaffoldBackgroundColor: primaryColour,
                fontFamily: "Shackle",
            ),
            home: const BottomNavbar(),
        );
    }
}

void main() => runApp(MyApp());
