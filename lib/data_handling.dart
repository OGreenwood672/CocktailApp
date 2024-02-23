
import 'cocktails_json.dart';
import 'ingredients_json.dart';


Map<String, bool> saveIngredientMap(Map<String, dynamic> subsection, Map<String, bool> ingredientMap) {

    if (subsection.containsKey("contains")) {
        for (Map<String, dynamic> section in subsection["contains"]) {
            ingredientMap = saveIngredientMap(section, ingredientMap);
        }
    } else {
        ingredientMap[subsection["name"]] = false;
    }
    return ingredientMap;

}

final Map<String, bool> ingredientMap = saveIngredientMap({
    "name": "ingredients",
    "contains": ingredients
}, {});

void updateIngredientMap(String key) {
    ingredientMap[key] = !ingredientMap[key]!;
}

bool getIngredientMap(String key) {
    return ingredientMap[key] != null && ingredientMap[key]!;
}

List<String> getMainIngredientKeys() {

    return ingredients.map((ingredient) => ingredient["name"].toString()).toList();

}

List<Map<String, dynamic>> copyTree(List<Map<String, dynamic>> originalTree) {
    List<Map<String, dynamic>> copiedTree = [];

    for (var node in originalTree) {
        Map<String, dynamic> copiedNode = {
            'name': node['name'],
        };

        if (node.containsKey('contains')) {
            copiedNode['contains'] = copyTree(node['contains']);
        }

        copiedTree.add(copiedNode);
    }

    return copiedTree;
}

bool checkIngredientInMap(String key) {
    if (!ingredientMap.containsKey(key)) {
        // Find key in map
        List<Map<String, dynamic>> queue = copyTree(ingredients);
        Map<String, dynamic>? res;
        while (queue.isNotEmpty && res == null) {
            Map<String, dynamic> curr = queue.removeAt(0);
            if (curr["name"] == key) {
                res = curr;
            } else if (curr.containsKey("contains")) {
                queue.addAll(curr["contains"]);
            }
        }
        //If not found
        if (res == null) { return false; }
        //Check if user has the ingredient: or a subcategory of the ingredient
        List<Map<String, dynamic>> queue2 = res["contains"];
        while (queue2.isNotEmpty) {
            Map<String, dynamic> curr = queue2.removeAt(0);
            if (getIngredientMap(curr["name"])) {
                return true;
            } else if (curr.containsKey("contains")) {
                queue2.addAll(curr["contains"]);
            }
        }
        return false;
    }
    return getIngredientMap(key);
}

bool isIngredientofType(String type, String ingredient) {
    // Find key in map
    List<Map<String, dynamic>> queue = copyTree(ingredients);
    Map<String, dynamic>? res;
    while (queue.isNotEmpty && res == null) {
        Map<String, dynamic> curr = queue.removeAt(0);
        if (curr["name"] == type) {
            res = curr;
        } else if (curr.containsKey("contains")) {
            queue.addAll(curr["contains"]);
        }
    }
    //If not found
    if (res == null) { return false; }
    //Check if user has the ingredient: or a subcategory of the ingredient
    List<Map<String, dynamic>> queue2 = res["contains"];
    while (queue2.isNotEmpty) {
        Map<String, dynamic> curr = queue2.removeAt(0);
        if (curr["name"] == ingredient) {
            return true;
        } else if (curr.containsKey("contains")) {
            queue2.addAll(curr["contains"]);
        }
    }
    return false;
}

List<Map<String, dynamic>> getCocktailsByName(List<String> cocktailNames) {
    return cocktailNames.map((cocktailName) => getCocktailByName(cocktailName)).toList();
}

List<String> getMakeableCocktails() {
    
    List<String> validCocktails = [];

    for (Map<String, dynamic> cocktail in cocktails) {

        bool validCocktail = true;
        for (List<String> ingredient in cocktail["ingredients"]) {

            if (!checkIngredientInMap(ingredient[0])) {
                validCocktail = false;
                break;
            }
        }
        if (validCocktail) {
            validCocktails.add(cocktail["name"]);
        }

    }
    // print("Data:");
    // print(cocktails.length);
    // print(validCocktails.length);
    return validCocktails;
 
}

List<Map<String, dynamic>> filterCocktailsByName(List<String> cocktailNames) {

    return cocktails.where((cocktail) => cocktailNames.contains(cocktail['name'])).toList();

}

List<String> getCocktailNames(List<Map<String, dynamic>> cocktails) {

    return cocktails
        .map((e) => e["name"])
        .whereType<String>()
        .toList();
}

Map<String, dynamic> getCocktailByName(String name) {

    return cocktails.where(
        (cocktail) => name == cocktail['name']
    ).toList()[0];

}

List<String> getNamesOfSubItems(String item) {


    List<Map<String, dynamic>> queue = copyTree(ingredients);
    Map<String, dynamic>? mainItem;
    while (queue.isNotEmpty && mainItem == null) {
        Map<String, dynamic> curr = queue.removeAt(0);
        if (curr["name"] == item) {
            mainItem = curr;
        } else if (curr.containsKey("contains")) {
            queue.addAll(curr["contains"]);
        }
    }
    if (mainItem == null) { return []; }

    List<Map<String, dynamic>> queue2 = mainItem["contains"];
    List<String> res = [];
    while (queue2.isNotEmpty) {
        Map<String, dynamic> curr = queue2.removeAt(0);
        if (curr.containsKey("contains")) {
            queue2.addAll(curr["contains"]);
        } else {
            res.add(curr["name"]);
        }
    }
    return res;

}

List<String> getMissingCocktails(int numberToReturn) {
    List<List<dynamic>> cocktailsWithWeights = [];
    
    Map<String, int> extraWeights = {
        "spirits": 5,
        "aperitifs": 3,
    };

    for (Map<String, dynamic> cocktail in cocktails) {

        int weight = 0;
        for (List<String> ingredient in cocktail["ingredients"]) {

            if (!checkIngredientInMap(ingredient[0])) {
                weight += 2;
                for (String type in extraWeights.keys) {
                    if (isIngredientofType(type, ingredient[0])) {
                        weight += extraWeights[type]!;
                    }
                }
            }
        }

        int index = 0;
        bool found = false;
        for (List<dynamic> otherCocktail in cocktailsWithWeights) {
            if (weight < otherCocktail[1]) {
                cocktailsWithWeights.insert(index, [cocktail["name"], weight]);
                found = true;
                break;
            }

            index++;
        }
        if (!found) {
            cocktailsWithWeights.add([cocktail["name"], weight]);
        }

    }
    List<String> toReturn = [];
    while (cocktailsWithWeights.isNotEmpty && toReturn.length != numberToReturn) {
        var cocktailWithWeight = cocktailsWithWeights.removeAt(0);
        if (cocktailWithWeight[1] != 0) {
            toReturn.add(cocktailWithWeight[0]);
        }
    }
    return toReturn;
}