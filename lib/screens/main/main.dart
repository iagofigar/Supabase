// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:supersearch/screens/main/tile.dart';
import 'package:supersearch/screens/data/data_insert.dart';
import 'package:supersearch/style.dart';
import 'package:supersearch/screens/main/profile.dart';

class Search extends StatefulWidget {
  const Search({super.key});

  @override
  State<Search> createState() => _SearchState();
}

class _SearchState extends State<Search> {
  List<String>? _results;
  String _input = '';

  @override
  void initState() {
    super.initState();
    _fetchAllData();
  }

  Future<void> _fetchAllData() async {
    final result = await Supabase.instance.client
        .from('armies')
        .select('name, alignments(name), image_url, id')
        .execute();

    if (result.data != null) {
      setState(() {
        _results = (result.data as List<dynamic>).map((v) {
          return "${v['name']}**+--${v['alignments']['name']}**+--${v['image_url']}**+--${v['id']}";
        }).toList();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Center(child: Text('Warhammer 40K Armies')), backgroundColor: Colors.red,
          actions: [
            IconButton(
              icon: const Icon(Icons.person, color: Colors.white,),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const ProfilePage()),
                );
              },
            ),
          ],
        ),
        body: Column(children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10),
            child: TextFormField(
                style: Theme.of(context).textTheme.bodyLarge,
                onChanged: _onSearchFieldChanged,
                autocorrect: false,
                autofocus: true,
                decoration: InputDecoration(
                  hintText: "Name",
                  hintStyle: placeholderTextFieldStyle,
                  border: InputBorder.none,
                  focusedBorder: InputBorder.none,
                  enabledBorder: InputBorder.none,
                  errorBorder: InputBorder.none,
                  disabledBorder: InputBorder.none,
                )),
          ),
          Expanded(
              child: (_results ?? []).isNotEmpty
                  ? GridView.count(
                      childAspectRatio: 1,
                      crossAxisCount: 2,
                      padding: const EdgeInsets.all(2.0),
                      mainAxisSpacing: 1.0,
                      crossAxisSpacing: 1.0,
                      children: _results!.map((r) => Tile(r)).toList())
                  : Padding(
                      padding: const EdgeInsets.only(top: 200),
                      child: _results == null
                          ? Container()
                          : Text("No results for '$_input'",
                              style: Theme.of(context).textTheme.bodySmall))),
        ]),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => InsertScreen()),
          );
        },
        child: Icon(Icons.add),
        backgroundColor: Colors.red,
      ),);
  }

  /// Handles user entering text into the search field. We kick off a search for
  /// every letter typed.
  _onSearchFieldChanged(String value) async {
    setState(() {
      _input = value;
      if (value.isEmpty) {
        // null is a sentinal value that allows us more control the UI
        // for a better user experience. instead of showing 'No results for ''",
        // if this is null, it will just show nothing
        //_results = null;
      }
    });

    final results = await _searchUsers(value);

    setState(() {
      _results = results;
    });
  }
  

  /// Searches our user database via the supabase_flutter package.
  ///
  /// Returns a list of user names.
  ///
  /// WARNING:
  /// - in a more realistic example, this would be moved to a "repository" instead
  ///   optionally with something like a FutureBuilder
  /// - check fluttercrashcourse.com for tutorials on these concepts
  Future<List<String>> _searchUsers(String name) async {
    // here, we leverage Supabase's (Postgres') full text search feature
    // for super fast text searching without the need for something overkill for
    // an example like this such as ElasticSearch or Algolia
    //
    // more info on Supabase's full text search here
    // https://supabase.com/docs/guides/database/full-text-search

    // WARNING: we aren't doing proper error handling here,
    // as this is an example but typically we'd handle any exceptions via the
    // callee of this function
    // NOTE: this seaches our 'fts' (full text search column)
    // NOTE: 'limit()' will improve the performance of the call as well.
    // normally, we'd use a proper backend search index that would provide
    // us with the most relevant results, vs simply using a wildcard match
    final result;
    if (name.isNotEmpty) {
      result = await Supabase.instance.client
          .from('armies')
          .select('name, alignments(name), image_url, id')
          .textSearch('fts', "$name:*")
          .limit(100)
          .execute();
    }
    else {
      result = await Supabase.instance.client
          .from('armies')
          .select('name, alignments(name), image_url, id')
          .limit(100)
          .execute();
    }

    if (result.data == null) {
      // ignore: avoid_print
      print('error: ${result.data.toString()}');
      return [];
    }

    final List<String> names = [];

    // convert results into a list here
    // 'result.data' is a list of Maps, where each map represents a returned
    // row in our database. each key of the map represents a table column
    for (var v in ((result.data ?? []) as List<dynamic>)) {
      // NOTE: string formatting over many items can be a tad resource intensive
      // but since this is across a limited set of results, it should be fine.
      // alternatively, we can format this directly in the supabase query
      names.add("${v['name']}**+--${v['alignments']['name']}**+--${v['image_url']}**+--${v['id']}");
    }
    return names;
  }
}
