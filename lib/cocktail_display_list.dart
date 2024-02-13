// import 'dart:async';
// import 'dart:io';

import 'package:the_bartender/colour_scheme.dart';
import 'package:the_bartender/data_handling.dart';
import 'package:the_bartender/premium.dart';
import 'package:flutter/material.dart';
// import 'package:in_app_purchase/in_app_purchase.dart';

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

    // final InAppPurchase iap = InAppPurchase.instance;
    // late StreamSubscription<List<PurchaseDetails>> _subscription;

    // List<ProductDetails> _products = <ProductDetails>[];
    // List<PurchaseDetails> _purchases = <PurchaseDetails>[];

    // final String moreCocktailsID = "more_cocktails";

    // bool _avaliable = false;

    // @override
    // void initState() {
    //     _initialize();
    //     super.initState();
    // }

    // void _initialize() async {

    //     _avaliable = await iap.isAvailable();

    //     if (_avaliable) {
    //         List<Future> furtures = [_getProducts(), _getPastProducts()];
    //         await Future.wait(furtures);
    //         _verifyPurchase();
    //         _subscription = iap.purchaseStream.listen((data) {setState(() {
    //             print("purchased");
    //             _purchases.addAll(data);
    //         });});
    //     } else {
    //         setState(() {
    //             results = getDefaultCocktails();
    //         });
    //     }

    // }

    // Future<void> _getProducts() async {
    //     Set<String> ids = {moreCocktailsID};
    //     ProductDetailsResponse response = await iap.queryProductDetails(ids);

    //     setState(() {
    //         _products = response.productDetails;
    //     });
    // }

    // Future<void> _getPastProducts() async {

    //     // _purchases = Map<String, PurchaseDetails>.fromEntries(
    //     //     _purchases.map((PurchaseDetails purchase) {
    //     //     if (purchase.pendingCompletePurchase) {
    //     //         iap.completePurchase(purchase);
    //     //     }
    //     //     return PurchaseDetails(purchase);
    //     // }));
    //     // QueryPurchaseDetailsResponse response = await iap.queryPastPurchases();
    //     Set<String> ids = {moreCocktailsID};
    //     ProductDetailsResponse response = await InAppPurchase.instance.queryProductDetails(ids);

    //     // for (PurchaseDetails purchase in response.pastPurchases) {
    //     //     if (Platform.isIOS) {
    //     //         iap.completePurchase(purchase);
    //     //     }
    //     // }
    //     setState(() {
    //         _purchases = response.productDetails;
    //     });

    // }

    // PurchaseDetails? _hasPurchased(String productID) {
    //     return _purchases.firstWhere( (purchase) => purchase.productID == productID, orElse: () => null);
    // }

    // void _verifyPurchase() {
    //     PurchaseDetails? purchase = _hasPurchased(moreCocktailsID);

    //     if (purchase != null && purchase.status == PurchaseStatus.purchased) {
    //         hasPremium = true;
    //     }
    // }

    // void _buyProduct(ProductDetails prod) {
    //     final PurchaseParam purchaseParam = PurchaseParam(productDetails: prod);
    //     iap.buyNonConsumable(purchaseParam: purchaseParam);
    // }

    // @override
    // void dispose() {
    //     _subscription.cancel();
    //     super.dispose();
    // }

    @override
    void initState() {
        super.initState();
        setState(() {
            results = getDefaultCocktails();
        });
    }

    late List<dynamic> results = [];
    int premiumCount = 0;


    Widget addTitle() {

        return Padding(
            padding: const EdgeInsets.only(top: 25.0),
            child: Align(
                alignment: Alignment.center,
                child: Text(
                    "Cocktails",
                    style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 45.0,
                        color: secondaryColour
                    ),)
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
            child: TextFormField(
                decoration: InputDecoration(
                    hintText: "Search by Name or Ingredient",
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
                res.add(cocktailInfo);
            }
        }
        return res;

    }

    void onSearch(String query) {
        if (query == "") {
            setState(() {
                results = getDefaultCocktails();
            });
        } else {
            results = [];
            premiumCount = 0;
            for (String cocktail in getCocktailNames(widget.cocktails)) {

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
                        results.add(cocktailInfo);
                    }
                }
            }
            setState(() {});
        }
    }

    Widget itemList(List<dynamic> items) {

        return GridView.count(
            physics: const NeverScrollableScrollPhysics(),
            crossAxisCount: 2,
            shrinkWrap: true,
            childAspectRatio: 150 / 195,
            children: [
                for (int index = 0; index<results.length; index++)
                Container(
                    padding: const EdgeInsets.all(16.0),
                    width: double.infinity,
                    height: 200,
                    child: CocktailIcon(cocktailInfo: results[index])

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
                        itemList(results),
                        if (results.isEmpty)
                        Center(child: Text(
                            "No Cocktails Found",
                            style: TextStyle(
                                color: textColour
                            )
                        )),
                        if (premiumCount > 0)
                        Center(child: Text(
                            // "$premiumCount more cocktails were found with premium",
                            "More found with premium",
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
