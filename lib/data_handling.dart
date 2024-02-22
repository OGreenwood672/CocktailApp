
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
        if (res == null) { return false; }
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