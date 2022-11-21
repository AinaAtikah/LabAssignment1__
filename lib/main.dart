import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:ndialog/ndialog.dart';
import 'package:fluttertoast/fluttertoast.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Movie Converter',
      theme: ThemeData(
        primarySwatch: Colors.orange,
      ),
      home: const MyMoviePage(),
    );
  }
}

class MyMoviePage extends StatefulWidget {
  const MyMoviePage({Key? key, required}) : super(key: key);

  @override
  State<MyMoviePage> createState() => _MyMoviePageState();
}

class _MyMoviePageState extends State<MyMoviePage> {
  String selectMovie = "Zootopia",
      description = "Choose your movie!",
      movie = "";

  var title, year, genre, runtime, director, plot, awards;
  List<String> movieList = [
    "Zootopia",
    "Tangled",
    "Shrek",
    "Moana",
    "Inside Out",
    "Sing",
    "Minions",
    "Madagascar",
    "Rango",
    "Frozen",
    "Bolt",
    "Doraemon",
    "Secrets Life of Pets"
  ];

  // ignore: prefer_typing_uninitialized_variables
  var decoration;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.black,
        appBar: AppBar(title: const Text("Movie App"),
            // ignore: prefer_const_literals_to_create_immutables
            actions: <Widget>[
              // ignore: prefer_const_constructors
              Icon(
                Icons.movie_creation_rounded,
                size: 60,
                color: Colors.black,
              )
            ]),
        body: SingleChildScrollView(
            child: Center(
                child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
              const Text(
                " Movie Information App",
                style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Colors.indigoAccent),
              ),
              const Icon(
                Icons.slow_motion_video_sharp,
                size: 20,
              ),
              Image.asset(
                'assets/images/moviescollage.png',
                scale: 8,
              ),
              DropdownButton(
                itemHeight: 70,
                value: selectMovie,
                dropdownColor: Colors.black,
                onChanged: (newValue) {
                  setState(() {
                    selectMovie = newValue.toString();
                  });
                },
                items: movieList.map((selectMovie) {
                  var text = Text(
                    selectMovie,
                    style: const TextStyle(
                      color: Colors.white70,
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  );
                  var dropdownMenuItem = DropdownMenuItem(
                    // ignore: sort_child_properties_last
                    child: text,
                    value: selectMovie,
                  );
                  return dropdownMenuItem;
                }).toList(),
              ),
              ElevatedButton(
                  onPressed: _loadMovie, child: const Text("Search Movie")),
              const SizedBox(height: 10),
              Text(
                description,
                style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 18,
                    color: Colors.white70),
              ),
            ]))));
  }

  Future<void> _loadMovie() async {
    ProgressDialog progressDialog = ProgressDialog(context,
        message: const Text("Progress"), title: const Text("Searching..."));
    progressDialog.show();

    var apiid = "a55a0747";
    var url = Uri.parse('http://www.omdbapi.com/?t=$selectMovie&apikey=$apiid');
    var response = await http.get(url);
    if (response.statusCode == 200) {
      var jsonData = response.body;
      var parsedData = json.decode(jsonData);
      title = parsedData['Title'];
      year = parsedData['Year'];
      genre = parsedData['Genre'];
      runtime = parsedData['Runtime'];
      director = parsedData['Director'];
      awards = parsedData['Awards'];
      plot = parsedData['Plot'];

      setState(() {
        description =
            "Title : $title. \n\nReleased on : $year.\n\nGenre : $genre.\n\nDuration : $runtime.\n\nDirector : $director.\n\nAwards: $awards. \n\nMovie Plot : $plot.";
        const SizedBox(height: 10);
      });

      @override
      Widget build(BuildContext context) {
        return Padding(
          padding: const EdgeInsets.all(16.0),
          child: Center(
              child: Column(
            // ignore: prefer_const_literals_to_create_immutables
            children: [
              const Text("Movie Information App",
                  style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
            ],
          )),
        );
      }
    }

    Fluttertoast.showToast(
        msg: "Found",
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        timeInSecForIosWeb: 1,
        backgroundColor: Colors.deepOrangeAccent,
        textColor: Colors.brown,
        fontSize: 16.0);

    progressDialog.dismiss();
  }
}
