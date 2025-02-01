import 'package:flutter/material.dart';
import 'dart:math';
import 'package:supersearch/screens/data/data_edit.dart';

class Tile extends StatelessWidget {
  final String title;

  late List<String> data = title.split("**+--");

  Tile(this.title, {super.key});

  @override
  Widget build(BuildContext context) {
    return Stack(children: [
      InkWell(
        child: Container(
          decoration: BoxDecoration(
            image: DecorationImage(
                image: NetworkImage(data[2]), fit: BoxFit.cover),
          ),
        ),
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => EditScreen(data: data),
            ),
          );
        },
      ),
      InkWell(
        child: Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [Colors.transparent, Colors.transparent, Colors.black],
                  stops: [0, 0.4, 1]
              ),
            )
        ),
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => EditScreen(data: data),
            ),
          );
        },
      ),
      Padding(
        padding: const EdgeInsets.all(10),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.end,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              data[1],
              style: Theme.of(context).textTheme.bodySmall,
              textAlign: TextAlign.end,
            ),
            Text(
              data[0].toUpperCase(),
              style: Theme.of(context).textTheme.displaySmall,
              textAlign: TextAlign.end,
            ),
          ],
        ),
      ),
    ]);
  }
}
