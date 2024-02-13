import 'package:the_bartender/colour_scheme.dart';
import 'package:the_bartender/data_handling.dart';
import 'package:the_bartender/helper_functions.dart';
import 'package:flutter/material.dart';

class IngredientIcon extends StatefulWidget {

    final String ingredient;
    final bool searchMode;

    const IngredientIcon({super.key, required this.ingredient, required this.searchMode});

    @override
    State<StatefulWidget> createState() => IngredientIconState();
}

class IngredientIconState extends State<IngredientIcon> {

    @override
    Widget build(BuildContext context) {

        return GestureDetector(
            child: Container(
                padding: const EdgeInsets.all(10.0),
                decoration: BoxDecoration(
                    color: getIngredientMap(widget.ingredient) ? confirmationColor : secondaryColour.withOpacity(0.9),
                    borderRadius: BorderRadius.circular(5.0),
                    boxShadow: [BoxShadow(
                        color: Colors.black.withOpacity(0.2),
                        blurRadius: 8,
                    )]
                ),
                child: Center(child: Text(
                    capitalizeEachWord(widget.ingredient),
                    textAlign: TextAlign.center,
                    style: TextStyle(
                        color: textColour,
                        fontWeight: widget.searchMode ? FontWeight.w500 : FontWeight.w600,
                        fontSize: widget.searchMode ? MediaQuery.of(context).size.width * 1/30 : MediaQuery.of(context).size.width * 1/20,
                    ),
                ),)
            ),
            onTap: () {
                updateIngredientMap(widget.ingredient);
                setState(() {});
            }
        );

    }

}