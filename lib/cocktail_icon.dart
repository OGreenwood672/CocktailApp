import "package:the_bartender/colour_scheme.dart";
import "package:flutter/material.dart";

import "cocktail_page.dart";


class CocktailIcon extends StatelessWidget {
    const CocktailIcon({super.key, required this.cocktailInfo, required this.displayMissing});

    final Map<String, dynamic> cocktailInfo;
    final bool displayMissing;

    @override
    Widget build(BuildContext context) {

        return GestureDetector(
            onTap: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (_) => CocktailDisplayPage(cocktailInfo: cocktailInfo, displayMissing: displayMissing)
                    ),
                );
            },
            child: Container(
                width: double.infinity,
                decoration: BoxDecoration(
                    color: secondaryColour,
                    borderRadius: const BorderRadius.all(Radius.circular(20)),
                    boxShadow: [
                        BoxShadow(
                            color: Colors.black.withOpacity(0.3),
                            spreadRadius: 1,
                            blurRadius: 8,
                        )
                    ]
                ),
                child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                        Container(
                            width: MediaQuery.of(context).size.width * 1/3,
                            height: MediaQuery.of(context).size.width * 1/3,
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(100.0), // Adjust the radius as needed
                                    image: DecorationImage(
                                        image: AssetImage('assets/Cocktail Images/${cocktailInfo["name"]}.png'),
                                    fit: BoxFit.cover,
                                ),
                            ),
                        ),
                        Text(
                            cocktailInfo["name"],
                            textAlign: TextAlign.center,
                            style: TextStyle(
                                fontSize: MediaQuery.of(context).size.width * 1/23,
                                fontWeight: FontWeight.bold,
                                color: textColour
                            ),
                        ),
                    ],
                ),
            ),
        );
    }
}