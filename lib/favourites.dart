import 'dart:math';

import 'package:flutter/material.dart';

class Favourites extends StatefulWidget {
  @override
  _FavouritesState createState() => _FavouritesState();
}

class _FavouritesState extends State<Favourites> {
  List<_MyPalette> palettes = <_MyPalette>[
    _MyPalette('Palette1', randomColor(), randomColor(), randomColor(), randomColor()),
    _MyPalette('Palette2', randomColor(), randomColor(), randomColor(), randomColor()),
    _MyPalette('Palette3', randomColor(), randomColor(), randomColor(), randomColor()),
    _MyPalette('Palette4', randomColor(), randomColor(), randomColor(), randomColor()),
  ];

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
        padding: const EdgeInsets.all(8),
        itemCount: palettes.length,
        itemBuilder: (BuildContext context, int index) {
          return Container(
            height: 70,
            color: Colors.white,
            child: Align(
                alignment: Alignment(0.0, 0.0),
                child: Row(
                  children: <Widget> [
                    Padding(padding: EdgeInsets.all(8.0)),
                    Text('${palettes[index].name}'),
                    Spacer(),
                    Box(palettes[index].color1),
                    Padding(padding: EdgeInsets.all(8.0)),
                    Box(palettes[index].color2),
                    Padding(padding: EdgeInsets.all(8.0)),
                    Box(palettes[index].color3),
                    Padding(padding: EdgeInsets.all(8.0)),
                    Box(palettes[index].color4),
                    Padding(padding: EdgeInsets.all(8.0)),
                  ]
                )
            ),
          );
        },
    );
  }
}

class Box extends StatelessWidget {
  Box(this.color);

  final Color color;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 20,
      width: 20.0,
      color: Colors.transparent,
      child: Container(
        decoration: BoxDecoration(
            color: color,
            borderRadius: BorderRadius.all(Radius.circular(10.0))),
      ),
    );
  }
}

class _MyPalette {
  const _MyPalette(this.name, this.color1, this.color2, this.color3, this.color4);

  final String name;
  final Color color1;
  final Color color2;
  final Color color3;
  final Color color4;
}

Color randomColor () {
  Random random = new Random(); //GENERATE RANDOM COLORS FOR PLACEHOLDER PALETTES
  return Color((random.nextDouble() * 0xFFFFFF).toInt()).withOpacity(1.0);
}