import 'package:flutter/material.dart';
import 'package:project_app/models/user.model.dart';
import 'package:project_app/models/user_details.model.dart';
import 'package:project_app/widgets/result_card.dart';

class SearchResults extends StatelessWidget {
  List<UserDetails> results = [];
  BuildContext sheetContext;
  SearchResults({super.key, required this.results, required this.sheetContext});

  @override
  Widget build(BuildContext context) {
    return Container(
        height: 1000,
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Expanded(
              child: ListView.builder(
            itemCount: results.length,
            itemBuilder: (context, index) {
              return ResultCard(
                result: results[index],
                sheetContext: sheetContext,
              );
            },
          )),
        ));
  }
}
