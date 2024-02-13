import 'package:the_bartender/colour_scheme.dart';
import 'package:the_bartender/data_handling.dart';
import "package:flutter/material.dart";

import 'cocktail_display_list.dart';
import "ingredients_page.dart";

import 'cocktails_json.dart';


class BottomNavbar extends StatefulWidget {  
    const BottomNavbar({super.key});
  
    @override  
    BottomNavbarState createState() => BottomNavbarState();  
}  

class BottomNavbarState extends State<BottomNavbar> {

    static List<Widget> contents = <Widget>[
        DisplayCocktailList(cocktails: cocktails, giveTitle: true, addBack: false,),
        IngredientsPage(items: ingredientMap.keys.toList())
    ];

    int currentPage = 0;
    
    void _onItemTapped(int index) {
        setState(() {
            currentPage = index;
         });
    }

    @override
    Widget build(BuildContext context) {

        return Scaffold(
            body: contents[currentPage],
            bottomNavigationBar: BottomNavigationBar(
                backgroundColor: primaryColour,
                fixedColor: tertiaryColour,
                unselectedItemColor: secondaryColour.withOpacity(0.4),
                items: const <BottomNavigationBarItem>[
                    BottomNavigationBarItem(
                        icon: Icon(Icons.menu_book_outlined),
                        label: 'Cocktails',
                    ),
                    BottomNavigationBarItem(
                        icon: Icon(Icons.shopping_bag_outlined),
                        label: 'Ingredients',
                    ),
                ],
                currentIndex: currentPage,
                onTap: _onItemTapped,
            ),
        );
    }
}