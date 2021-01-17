import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class PrimaryColors {
  final colors;

  PrimaryColors({this.colors});

  factory PrimaryColors.fromJson(Map<String, dynamic> json) {
    var expCols = [];
    for(var i=0; i<4; i++){
      print(json);
      if(json["responses"][0]["error"] == null) {
        expCols.add(Color.fromRGBO(
            json["responses"][0]["imagePropertiesAnnotation"]
            ["dominantColors"]["colors"][i]["color"]["red"],
            json["responses"][0]["imagePropertiesAnnotation"]
            ["dominantColors"]["colors"][i]["color"]["green"],
            json["responses"][0]["imagePropertiesAnnotation"]
            ["dominantColors"]["colors"][i]["color"]["blue"],
            1.0));
      } else {
        return null;
      }
    }
    return PrimaryColors(colors: expCols);
  }

  Map<String, dynamic> toMap() {
    return {
      "colors1" : colors[0],
      "colors2" : colors[1],
      "colors3" : colors[2],
      "colors4" : colors[3]
    };
  }
}

Future<void> insertColors(PrimaryColors colors, Database database) async {
  final Database db = await database;
  await db.insert(
    'favorites',
    colors.toMap(),
    conflictAlgorithm: ConflictAlgorithm.replace
  );
}

Future<PrimaryColors> fetchLocalPalette(var imageFile) async {
  List fileBytes = await imageFile.readAsBytesSync();
  String encodedFile = base64.encode(fileBytes);
  final body = {"requests" : [{"image" : {"content" : "$encodedFile"}, "features" : [{"maxResults" : 4, "type" : "IMAGE_PROPERTIES"}]}]};
  final token = "ya29.c.Kp0B7gcquuNVt3Zz64jRYd7aFaJX-Z6mPCltpsjrEXZxy4wh39Ou13AGwh5A0qdQxbvvzvwbNWNaD7dHLZIcOD4KdNBaVd2UTm4YHhcj0imP88aL0DXumsRaYpPsSNaxuBGvN28qQbGQN5_iz5Wx2zbrbatTnZWFNeQ5mT11NJ6A8_2S5LiQ5M_ECAtNqWKl8l2LyWWzrURHdC4AW6gIVw";
  final headers = {"Content-Type": "application/json", "Authorization" : "Bearer $token"};
  final response = await http.post("https://vision.googleapis.com/v1/images:annotate", body: jsonEncode(body), headers: headers);

  if (response.statusCode == 200) {
    return PrimaryColors.fromJson(jsonDecode(response.body));
  } else {
    print(response.body);
    return null;
  }
}

Future<PrimaryColors> fetchPalette(var imageUri) async {
  final body = {"requests" : [{"image" : {"source" : {"imageUri" : "$imageUri"}}, "features" : [{"maxResults" : 4, "type" : "IMAGE_PROPERTIES"},]}]};
  final token = "ya29.c.Kp0B7gcquuNVt3Zz64jRYd7aFaJX-Z6mPCltpsjrEXZxy4wh39Ou13AGwh5A0qdQxbvvzvwbNWNaD7dHLZIcOD4KdNBaVd2UTm4YHhcj0imP88aL0DXumsRaYpPsSNaxuBGvN28qQbGQN5_iz5Wx2zbrbatTnZWFNeQ5mT11NJ6A8_2S5LiQ5M_ECAtNqWKl8l2LyWWzrURHdC4AW6gIVw";
  final headers = {"Content-Type": "application/json", "Authorization" : "Bearer $token"};
  final response = await http.post("https://vision.googleapis.com/v1/images:annotate", body: jsonEncode(body), headers: headers);

  if (response.statusCode == 200) {
    return PrimaryColors.fromJson(jsonDecode(response.body));
  } else {
    print(response.body);
    return null;
  }
}
