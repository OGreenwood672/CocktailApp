
import 'dart:math';

import 'package:the_bartender/colour_scheme.dart';
import 'package:the_bartender/data_handling.dart';
import 'package:the_bartender/premium.dart';
import 'package:flutter/material.dart';

import "cocktail_icon.dart";


class DisplayCocktailList extends StatefulWidget {
    final List<Map<String, dynamic>> cocktails;
    final bool giveTitle;
    final bool addBack;
    const DisplayCocktailList({super.key, required this.cocktails, required this.giveTitle, required this.addBack});

    @override
    DisplayCocktailListState createState() => DisplayCocktailListState();
}

class DisplayCocktailListState extends State<DisplayCocktailList> {

    @override
    void initState() {
        super.initState();
        setState(() {
            results = getDefaultCocktails();
        });
    }

    late List<dynamic> results = [];
    int premiumCount = 0;
    TextEditingController _controller = TextEditingController();
    bool searching = false;

    @override
    void dispose() {
        super.dispose();
        _controller.dispose();
    }

    Widget addTitle() {

        return Padding(
            padding: const EdgeInsets.only(top: 25.0),
            child: Align(
                alignment: Alignment.center,
                child: Text(
                    "MENU",
                    style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 45.0,
                        color: secondaryColour
                    ),
                )
            ),
        );
    }

    Widget buyPremium() {

        return Center(
            child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: ElevatedButton(
                    style: ButtonStyle(
                        backgroundColor: MaterialStateProperty.all<Color>(secondaryColour),
                    ),
                    onPressed: () {
                        
                    },
                    child: Padding(
                        padding: const EdgeInsets.only(top: 6.0, bottom: 6.0),
                        child: Text(
                            "Buy Premium\n£1.99",
                            textAlign: TextAlign.center,
                            style: TextStyle(
                                color: textColour
                            ),
                        )
                    )
                )
            )
        );

    }

    Widget addSearchBar() {
        
        return Container(
            margin: const EdgeInsets.symmetric(horizontal: 15, vertical: 20),
            width: double.infinity,
            height: 50,
            alignment: Alignment.center,
            decoration:  BoxDecoration(
                color: secondaryColour,
                borderRadius: BorderRadius.circular(10)
            ),
            child: TextField(
                controller: _controller,
                decoration: InputDecoration(
                    hintText: 'Search by Name or Ingredient',
                    prefixIcon: Icon(
                        Icons.search,
                        size: 30,
                        color: textColour
                    )
                ),
                onChanged: onSearch,
                onSubmitted: onSearch
                ),
            );
    }

    Widget backButton(BuildContext context) {

        return Align(
            alignment: Alignment.topLeft,
            child: Container(
                margin: const EdgeInsets.only(left: 15.0, top: 40.0),
                child: InkWell(
                    onTap: () {
                        Navigator.pop(context);
                    },
                    child: Padding(
                        padding: const EdgeInsets.all(0.0),
                        child: Icon(
                            Icons.arrow_back_ios_new_outlined,
                            size: 20.0,
                            weight: 30.0,
                            color: textColour
                        )
                    )
                )
            )
        );
    }

    List<Map<String, dynamic>> getDefaultCocktails() {

        List<Map<String, dynamic>> res = [];
        premiumCount = 0;
        for (String cocktail in getCocktailNames(widget.cocktails)) {
            Map<String, dynamic> cocktailInfo = getCocktailByName(cocktail);
            if (cocktailInfo["premium"] && !hasPremium) {
                premiumCount++;
            } else {
                int resIndex = 0;
                bool found = false;
                for (Map<String, dynamic> cocktail in res) {
                    if (cocktailInfo["name"].compareTo(cocktail["name"]) < 0) {
                        res.insert(resIndex, cocktailInfo);
                        found = true;
                        break;
                    }
                    resIndex++;
                }
                if (!found) { res.add(cocktailInfo); }
            }
        }
        return res;

    }

    void onSearch(String query) {
        if (query == "") {
            setState(() {
                searching = false;
                results = getDefaultCocktails();
            });
        } else {
            results = [];
            premiumCount = 0;
            for (String cocktail in getCocktailNames(widget.cocktails)) {

                bool priority = cocktail.toLowerCase().startsWith(query.toLowerCase());

                Map<String, dynamic> cocktailInfo = getCocktailByName(cocktail);

                bool inName = cocktail.toLowerCase().contains(query.toLowerCase());

                bool inIngredient = false;
                for (List<String> ingredient in cocktailInfo["ingredients"]) {
                    if (ingredient[0].contains(query.toLowerCase())) {
                        inIngredient = true;
                        break;
                    }
                }
                
                if (inName || inIngredient) {
                    if (cocktailInfo["premium"] && !hasPremium) {
                        premiumCount++;
                    } else {
                        if (priority) { results.insert(0, cocktailInfo); }
                        else { results.add(cocktailInfo); }
                    }
                }
            }
            setState(() {
                searching = true;
            });
        }
    }

    Widget itemList(List<dynamic> items, bool displayMissing) {

        return GridView.count(
            physics: const NeverScrollableScrollPhysics(),
            crossAxisCount: 2,
            shrinkWrap: true,
            childAspectRatio: 150 / 195,
            children: [
                for (int index = 0; index<items.length; index++)
                Container(
                    padding: const EdgeInsets.all(16.0),
                    width: double.infinity,
                    height: 200,
                    child: CocktailIcon(cocktailInfo: items[index], displayMissing: displayMissing)

                )
            ]
        );
    }
    
    @override
    Widget build(BuildContext context) {

        return SafeArea(
            child: Padding(
                padding: const EdgeInsets.all(4.0),
                child: ListView(
                    children: [

                        if (widget.addBack)
                        backButton(context),

                        if (widget.giveTitle)
                        addTitle(),

                        addSearchBar(),

                        itemList(results, false),

                        if (results.isEmpty)
                        Center(child: Text(
                            "No Cocktails Found",
                            style: TextStyle(
                                color: textColour,
                                fontSize: 19.0,
                            )
                        )),

                        if (results.isEmpty && widget.giveTitle)
                        Center(child: Text(
                            "Request New Cocktails to Add on Instagram (@thebartenderapp)",
                            textAlign: TextAlign.center,
                            style: TextStyle(
                                color: textColour
                            )
                        )),

                        if (results.length < 10 && !searching)
                            Center(child: Text(
                            "Cocktails you can almost make",
                            textAlign: TextAlign.center,
                            style: TextStyle(
                                color: textColour,
                                fontSize: 20.0,
                                fontWeight: FontWeight.bold,
                            )
                        )),
                        if (results.length < 10 && !searching)
                        itemList(getCocktailsByName(getMissingCocktails(max(10 - results.length, 6))), true),

                        if (premiumCount > 0)
                        Center(child: Text(
                            "More found with premium",
                            textAlign: TextAlign.center,
                            style: TextStyle(
                                color: textColour
                            )
                        )),
                        if (!hasPremium)
                        buyPremium()
                    ],
                )
            )
        );
    }
    
}
