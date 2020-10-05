import 'package:flutter/material.dart';
import 'package:mr_invoice/widgets/receipt_list_item.dart';

class ListSearch extends SearchDelegate<String> {
  final fullList = [
    "Muzzafarpur",
    "Agra",
    "Jaipur",
    "Patna",
    "Shirdi",
    "Pune",
    "Mumbai",
    "Kashi",
    "Rane",
    "Thane",
    "Jaipur",
    "Jaisalmer"
  ];

  @override
  Widget buildSuggestions(BuildContext context) {
    final recentList = generateRecentsList();
    List<String> suggestionList = [];
    query.isEmpty
        ? suggestionList = recentList
        : suggestionList
            .addAll(fullList.where((element) => element.contains(query)));
    return ListView.builder(
        itemCount: suggestionList.length,
        itemBuilder: (context, index) {
          return ListTile(
            onTap: () {
              var suggestedResult = suggestionList[index];
              showResults(context);
            },
            title: Text(suggestionList[index]),
          );
        });
  }

  @override
  List<Widget> buildActions(BuildContext context) {
    return [
      IconButton(
        icon: Icon(Icons.close),
        onPressed: () => {query = ""},
      ),
    ];
  }

  @override
  Widget buildLeading(BuildContext context) {
    return IconButton(
      icon: AnimatedIcon(
        icon: AnimatedIcons.menu_arrow,
        progress: transitionAnimation,
      ),
      onPressed: () {
        close(context, null);
      },
    );
  }

  @override
  Widget buildResults(BuildContext context) {
    return ReceiptListItem();
  }

  List<String> generateRecentsList() {
    return ["Muzzafarpur", "Agra", "Jaipur", "Patna"];
  }
}
