import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:project_app/models/api_call.model.dart';
import 'package:project_app/models/user_details.model.dart';
import 'package:project_app/widgets/search_results.dart';

class Search extends ConsumerStatefulWidget {
  const Search({super.key});

  @override
  _SearchState createState() => _SearchState();
}

class _SearchState extends ConsumerState<Search> {
  String text = "";

  @override
  Widget build(BuildContext context) {
    return SearchAnchor(
      builder: (BuildContext context, SearchController controller) {
        return SearchBar(
          controller: controller,
          padding: const WidgetStatePropertyAll<EdgeInsets>(
              EdgeInsets.symmetric(horizontal: 16.0)),
          onTap: () {},
          onChanged: (v) {
            setState(() {
              text = v;
            });
          },
          trailing: [
            ElevatedButton(
                onPressed: () async {
                  ApiCall searchCall = ApiCall(
                      request: Request(
                          base: "appointments",
                          endpoint: "search",
                          ref: ref,
                          reqBody: {"keyword": text}));
                  List<dynamic> res = await searchCall.call();
                  List<UserDetails> searchResults =
                      res.map((e) => UserDetails.fromJson(e)).toList();
                  showModalBottomSheet<void>(
                    context: context,
                    builder: (BuildContext context) {
                      return SearchResults(results: searchResults, sheetContext: context);
                    },
                  );
                },
                child: const Text("Search"))
          ],
          leading: const Icon(Icons.search),
        );
      },
      suggestionsBuilder: (context, query) => [],
    );
  }
}
