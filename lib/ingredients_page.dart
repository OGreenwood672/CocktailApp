import 'package:the_bartender/colour_scheme.dart';
import 'package:the_bartender/helper_functions.dart';
import 'package:the_bartender/ingredient_icon.dart';
import 'package:flutter/material.dart';

import 'cocktail_display_list.dart';
import 'data_handling.dart';

class IngredientsPage extends StatefulWidget {
    final List<String> items;
    const IngredientsPage({super.key, required this.items});

    @override
    IngredientsPageState createState() => IngredientsPageState();
}


class IngredientsPageState extends State<IngredientsPage> 
    with SingleTickerProviderStateMixin {

    late List<String> results = [];
    bool showAll = true;

    List<String> tabs = ["spirits", "aperitifs", "soft drinks", "syrups", "juices", "other"];
    late TabController _tabController;

    @override
    void initState() {
        super.initState();
        _tabController = TabController(length: tabs.length, vsync: this, initialIndex: 0);
        _tabController.addListener(_handleTabSelection);
        results = getNamesOfSubItems(tabs[_tabController.index]);
        setState(() {});
    }

    void _handleTabSelection() {
        if (_tabController.indexIsChanging) {
            setState(() {
                results = getNamesOfSubItems(tabs[_tabController.index]);
            });
        }
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
            child: TextFormField(
                decoration: InputDecoration(
                    hintText: "Search Ingredients",
                    prefixIcon: Icon(
                        Icons.search,
                        size: 30,
                        color: textColour
                    )
                ),
                onChanged: onSearch,
            )
        );
    }

    void onSearch(String query) {
        if (query == "") {
            setState(() {
                showAll = true;
                results = getNamesOfSubItems(tabs[_tabController.index]);
            });
        } else {
            showAll = false;
            results = [];
            for (String ingredient in ingredientMap.keys.toList()) {
                if (ingredient.toLowerCase().contains(query.toLowerCase())) {
                    results.add(ingredient);
                }
            }
            setState(() {});
        }
    }

    Widget ingredientTabs() {

        return TabBar(
            tabAlignment: TabAlignment.fill,
            controller: _tabController,
            indicatorColor: tertiaryColour,
            labelColor: tertiaryColour,
            unselectedLabelColor: secondaryColour,
            isScrollable: true,
            tabs: [
                for (int i=0; i<tabs.length; i++)
                Tab(text: capitalizeEachWord(tabs[i]),)
            ]
        );

    }

    Widget calculateButton(BuildContext context) {

        return Align(
            alignment: Alignment.bottomRight,
            child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: ElevatedButton(
                    style: ButtonStyle(
                        backgroundColor: MaterialStateProperty.all<Color>(secondaryColour),
                    ),
                    onPressed: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (_) => displayCocktails(context)
                            ),
                        );
                    },
                    child: Text(
                        "Get Drinks",
                        style: TextStyle(
                            color: textColour
                        ),
                    )
                )
            )
        );

    }

    Widget itemList(List<String> items) {

        return GridView.count(
            physics: const NeverScrollableScrollPhysics(),
            crossAxisCount: showAll ? 3 : 2,
            shrinkWrap: true,
            childAspectRatio: 150 / 100,
            children: [
                for (int index = 0; index<results.length; index++)
                Container(
                    padding: const EdgeInsets.all(5.0),
                    width: double.infinity,
                    child: IngredientIcon(ingredient: results[index], searchMode: showAll)
                )
            ]
        );
    }

    Widget displayCocktails(BuildContext context) {

        return Scaffold(
            body: DisplayCocktailList(cocktails: filterCocktailsByName(getMakeableCocktails()), giveTitle: false, addBack: true)
        );

    }

    @override
    Widget build(BuildContext context) {
        return SafeArea(
            child: Padding(
                padding: const EdgeInsets.all(4.0),
                child: Stack(children: [
                    ListView(
                        children: [
                            addSearchBar(),
                            if (showAll)
                            ingredientTabs(),
                            itemList(results),
                            const SizedBox(height: 60,)
                        ],
                    ),
                    calculateButton(context)
                ],)
            )
        );
    }
}
