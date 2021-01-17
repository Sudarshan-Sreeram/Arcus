import 'package:arcus/color_request.dart';
import 'package:shimmer/shimmer.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'dart:io';
import './palette_page.dart';

class SearchImg {
  final String url;

  SearchImg({this.url});

  factory SearchImg.fromJson(Map<String, dynamic> json, var i) {
    return SearchImg(
      url: json["results"][i]["urls"]["raw"],
    );
  }
}

Future<SearchImg> fetchImg(var search, var i) async {
  final response = await http
      .get("https://api.unsplash.com/search/photos?query={$search}", headers: {
    HttpHeaders.authorizationHeader:
        "Client-ID 7kXNn32J4W0djMR3eCOr96yVet3FTKw7Pl3GRk8SIeA"
  });

  if (response.statusCode == 200) {
    return SearchImg.fromJson(jsonDecode(response.body), i);
  } else {
    throw Exception("Could not load Searched Image");
  }
}

class SearchUnsplash extends StatefulWidget {
  @override
  _SearchUnsplashState createState() => _SearchUnsplashState();
}

class _SearchUnsplashState extends State<SearchUnsplash> {
  List<SearchImg> searchImgs = <SearchImg>[];
  final int numImgs = 5;
  var searchTerm = "";
  final searchController = TextEditingController();
  PrimaryColors primaryColors;

  status() async {
    if (searchImgs[0] != null) {
      print("yeah");
      setState(() {});
    } else {
      status();
    }
    return null;
  }

  getContent() async {
    for (var i = 0; i < numImgs; i++) {
      searchImgs[i] = await fetchImg(searchTerm, i);
    }
    status();
    return null;
  }

  getPrimaryColors(SearchImg searchImg) async {
    primaryColors = await fetchPalette(searchImg.url);
  }

  @override
  void dispose() {
    searchController.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    if (searchImgs.length == 0) {
      for (var i = 0; i < numImgs; i++) {
        searchImgs.add(null);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(children: <Widget>[
      Container(
        decoration: BoxDecoration (
          color: Colors.white,
        ),
        padding: EdgeInsets.all(16.0),
        child: Row(children: <Widget>[
          Spacer(),
          Container(
              width: MediaQuery.of(context).size.width * 0.65,
              child: TextField(
                controller: searchController,
              )),
          Padding(padding: EdgeInsets.symmetric(horizontal: 3.0)),
          Container(
              width: MediaQuery.of(context).size.width * 0.20,
              child: FlatButton(
                onPressed: () {
                  searchTerm = searchController.text;
                  Scaffold.of(context).showSnackBar(
                      SnackBar(content: Text("Loading Images...")));
                  getContent();
                },
                child: Icon(Icons.search, size: 50),
              )),
          Spacer(),
        ]),
      ),
      Expanded(
          child: Container(
              decoration: BoxDecoration (
                color: Colors.white,
              ),
              height: 500,
              child: ListView.builder(
                scrollDirection: Axis.vertical,
                padding: EdgeInsets.all(16.0),
                itemCount: numImgs,
                itemBuilder: (BuildContext context, int index) {
                  return Column(
                    children: [
                      searchImgs[index] != null
                          ? Image.network(searchImgs[index].url)
                          : SizedBox(
                              child: Shimmer.fromColors(
                                baseColor: Colors.white,
                                highlightColor: Colors.grey,
                                child: Container(
                                  child: Column(
                                    children: <Widget>[
                                      Container(
                                        height: 150,
                                        width: 400,
                                        decoration: BoxDecoration(
                                          color: Colors.white.withOpacity(0.4),
                                        ),
                                      ),
                                      Padding(padding: EdgeInsets.all(8.0)),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                      searchImgs[index] != null
                          ? FlatButton(
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(8.0)),
                              color: Colors.black,
                              child: new Text(
                                'Create New Palette',
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  color: Colors.white.withOpacity(1),
                                ),
                              ),
                              //onPressed: getImage,
                              onPressed: () async {
                                Scaffold.of(context).showSnackBar(SnackBar(
                                    content: Text("Loading Palette...")));
                                await getPrimaryColors(searchImgs[index]);
                                if(primaryColors != null) {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) =>
                                            PalettePage(
                                                colors: primaryColors.colors)),
                                  );
                                } else {
                                  Scaffold.of(context).showSnackBar(SnackBar(
                                    shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8.0)),
                          backgroundColor: Colors.black,
                          content: Container(
                              height: 50, 
                                      child: Text("Image too big!"))));
                                }
                              },
                            )
                          : SizedBox(
                              child: Shimmer.fromColors(
                                baseColor: Colors.white,
                                highlightColor: Colors.grey,
                                child: Container(
                                  child: Column(
                                    children: <Widget>[
                                      Container(
                                        height: 150,
                                        width: 400,
                                        decoration: BoxDecoration(
                                          color: Colors.white.withOpacity(0.4),
                                        ),
                                      ),
                                      Padding(padding: EdgeInsets.all(8.0)),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                    ],
                  );
                },
              )))
    ]);
  }
}
