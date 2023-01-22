import 'dart:convert';

import 'package:apites/Models/people_model.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({
    super.key,
  });

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  List<PeopleData> peopleResult = [];

  getPeopleData() async {
    try {
      // making the network request
      var response = await http.get(
        Uri.parse('https://swapi.dev/api/people'),
      );
      // decoding te response in the language we understand (flutter)
      Map<String, dynamic> decodedResponse = jsonDecode(
        utf8.decode(response.bodyBytes),
      ) as Map<String, dynamic>;

      setState(() {
        // conversion of the decoded data into a list
        List data = decodedResponse['results'] as List;
        // going into the converted list and returning it into our pre-created list
        for (var element in data) {
          peopleResult.add(
            PeopleData.fromJson(element),
          );
        }
      });
    } catch (e) {
      print(e.toString());
    }
  }

  @override
  void initState() {
    // getPeopleData();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('api call'),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
        child: Column(
          children: <Widget>[
            const Text(
              'All the datas goes below!',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 20,
              ),
            ),
            if (peopleResult.isEmpty)
              const Center(
                child: CircularProgressIndicator(),
              )
            else
              Expanded(
                child: ListView.builder(
                  itemCount: peopleResult.length,
                  itemBuilder: (context, index) {
                    var data = peopleResult[index];
                    return Container(
                      decoration: BoxDecoration(
                        boxShadow: const [
                          BoxShadow(
                            color: Colors.black,
                            blurRadius: 10,
                            offset: Offset(0, 3),
                          )
                        ],
                        color: Colors.deepPurple,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      margin: const EdgeInsets.symmetric(vertical: 10),
                      child: ListTile(
                        title: Text(data.name.toString(),
                            style: const TextStyle(color: Colors.white)),
                        subtitle: Text(
                          data.birthYear.toString(),
                          style: const TextStyle(color: Colors.white),
                        ),
                        trailing: Text(data.gender.toString(),
                            style: const TextStyle(color: Colors.white)),
                      ),
                    );
                  },
                ),
              )
          ],
        ),
      ),
      floatingActionButton: GestureDetector(
        onTap: () {
          getPeopleData();
        },
        child: Container(
          height: 50,
          width: 150,
          decoration: BoxDecoration(
            color: Colors.amber,
            border: Border.all(color: Colors.white),
            borderRadius: BorderRadius.circular(8),
          ),
          child: const Center(
            child: Text(
              'get People',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 20,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
