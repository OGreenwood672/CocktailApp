import "package:the_bartender/colour_scheme.dart";
import "package:the_bartender/helper_functions.dart";
import "package:flutter/material.dart";


class CocktailDisplayPage extends StatelessWidget {

    const CocktailDisplayPage({super.key, required this.cocktailInfo});
    final Map<String, dynamic> cocktailInfo;

    Widget backButton(BuildContext context) {

        return Align(
            alignment: Alignment.topLeft,
            child: InkWell(
                onTap: () {
                    Navigator.pop(context);
                },
                child: Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: Icon(
                        Icons.arrow_back_ios_new_outlined,
                        size: 20.0,
                        weight: 30.0,
                        color: textColour
                    )
                )
            )
        );

    }

    Widget cocktailImage(String name) {
        return Container(
            margin: const EdgeInsets.all(17.0),
            decoration: BoxDecoration(
                color: secondaryColour,
                boxShadow: [
                    BoxShadow(
                        color: Colors.black.withOpacity(0.6),
                        spreadRadius: 1,
                        blurRadius: 8,
                    )
                ]
            ),
            child: Image(
                image: AssetImage('assets/Cocktail Images/$name.png'),
                fit: BoxFit.fill,
            ),
        );
    }

    Widget cocktailTitle(String name) {
        return Center(
            child: Padding(
                padding: const EdgeInsets.only(bottom: 25.0),
                child: Text(
                    cocktailInfo["name"],
                    style: TextStyle(
                        color: secondaryColour,
                        fontSize: 35.0,
                        fontWeight: FontWeight.bold,
                    ),
                )
            )
        );
    }

    Widget ingredientsSection(List<List<String>> ingredients) {

        return Container(
            decoration: BoxDecoration(
                color: secondaryColour,
                borderRadius: const BorderRadius.all(Radius.circular(20.0)),
                boxShadow: const [BoxShadow(
                    color: Colors.black,
                    spreadRadius: 1,
                    blurRadius: 8,
                )]
            ),
            child: Padding(
                padding: const EdgeInsets.only(left: 25.0, right: 25.0, top: 15.0, bottom: 20.0),
                child: Column(
                    children: [
                        Text(
                            "INGREDIENTS",
                            style: TextStyle(
                                fontSize: 20.0,
                                fontWeight: FontWeight.bold,
                                color: textColour
                            ),
                        ),
                        ListView.builder(
                            itemCount: ingredients.length,
                            shrinkWrap: true,
                            physics: const NeverScrollableScrollPhysics(),
                            itemBuilder: (context, index) {
                                return Container(
                                    padding: const EdgeInsets.all(4.0),
                                    child: Text(
                                        "• ${capitalizeFirstLetter(ingredients[index][1])} ${capitalizeEachWord(ingredients[index][0])}",
                                        style: TextStyle(
                                            fontSize: 14.0,
                                            fontWeight: FontWeight.w400,
                                            color: textColour
                                        ),
                                    ),
                                );
                            },
                        ),
                        if (cocktailInfo.containsKey("garnish"))
                        Container(
                            padding: const EdgeInsets.all(8.0),
                            width: double.infinity,
                            child: RichText(
                                text: TextSpan(
                                    children: [
                                        TextSpan(
                                            text: "Garnish: ",
                                            style: TextStyle(
                                                fontWeight: FontWeight.bold,
                                                fontSize: 16.0,
                                                color: textColour,
                                            ),
                                        ),
                                        TextSpan(
                                            text: cocktailInfo["garnish"],
                                            style: TextStyle(
                                                fontWeight: FontWeight.normal,
                                                fontSize: 14.0,
                                                color: textColour,
                                            ),
                                        )
                                    ]
                                ),
                            ),
                        )
                    ]
                )
            )
        );

    }

    Widget methodSection(List<String> method) {

        return Container(
            decoration: BoxDecoration(
                color: secondaryColour,
                borderRadius: const BorderRadius.all(Radius.circular(20.0)),
                boxShadow: const [BoxShadow(
                    color: Colors.black,
                    spreadRadius: 1,
                    blurRadius: 8,
                )]
            ),
            child: Padding(
                padding: const EdgeInsets.only(left: 25.0, right: 25.0, top: 15.0, bottom: 20.0),
                child: Column(
                    children: [
                        Text(
                            "METHOD",
                            style: TextStyle(
                                fontSize: 20.0,
                                fontWeight: FontWeight.bold,
                                color: textColour
                            ),
                        ),
                        ListView.builder(
                            itemCount: cocktailInfo["method"].length,
                            shrinkWrap: true,
                            physics: const NeverScrollableScrollPhysics(),
                            itemBuilder: (context, index) {
                                return Container(
                                    padding: const EdgeInsets.all(8.0),
                                    width: double.infinity,
                                    child: RichText(
                                        text: TextSpan(
                                            children: [
                                                TextSpan(
                                                    text: "Step ${index + 1}\n",
                                                    style: TextStyle(
                                                        fontWeight: FontWeight.bold,
                                                        fontSize: 16.0,
                                                        color: textColour,
                                                    ),
                                                ),
                                                TextSpan(
                                                    text: method[index],
                                                    style: TextStyle(
                                                        fontWeight: FontWeight.normal,
                                                        fontSize: 14.0,
                                                        color: textColour,
                                                    ),
                                                )
                                            ]
                                        ),
                                    ),
                                );
                            },
                        ),
                    ]
                )
            )
        );

    }

    @override
    Widget build(BuildContext context) {

        return Scaffold(

            body: SingleChildScrollView(
                child: Padding(
                    padding: const EdgeInsets.all(15.0),
                    child: ListView(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        children: [
                            backButton(context),
                            cocktailImage(cocktailInfo["name"]),
                            cocktailTitle(cocktailInfo["name"]),
                            ingredientsSection(cocktailInfo["ingredients"]),
                            const SizedBox(
                                height: 25,
                            ),
                            methodSection(cocktailInfo["method"])
                        ],
                        ),
                    ),
                ),
            );

    }

}