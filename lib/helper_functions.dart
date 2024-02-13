

String capitalizeEachWord(String sentence) {
    List<String> words = sentence.split(' ');

    for (int i = 0; i < words.length; i++) {
        if (words[i].isNotEmpty) {
            words[i] = words[i][0].toUpperCase() + words[i].substring(1);
        }
    }

    return words.join(' ');
}

String capitalizeFirstLetter(String input) {

    if (input.isEmpty) {
        return "";
    }

    String firstLetter = input[0].toUpperCase();
    
    return '$firstLetter${input.substring(1)}';
}