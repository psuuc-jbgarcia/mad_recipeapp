import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:pantrychef/components/drawer.dart';
import 'package:http/http.dart' as http;
import 'package:pantrychef/screens/model.dart';
import 'package:pantrychef/screens/search.dart';
import 'package:pantrychef/screens/view.dart';

const Color primaryColor = Colors.redAccent; // Appetizing red
const Color secondaryColor = Colors.lightGreenAccent; // Fresh green
const Color accentColor = Colors.yellow; // Warm yellow

class Home extends StatefulWidget {
  const Home({Key? key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  List<Recipe> list = <Recipe>[];
  String? search;
  final GlobalKey<ScaffoldState> _drawerKey = GlobalKey();
  //10 results
  final url =
      "https://api.edamam.com/search?q=&app_id=1a08c259&app_key=344a22a6d97e805580ee27a597df263c&from=0&to=10&calories=591-722&health=alcohol-free";
  getApiData() async {
    var response = await http.get(Uri.parse(url));
    Map json = jsonDecode(response.body);
    print(response.body);
    //array hits
    //Each object within the hits array contains a recipe
    json['hits'].forEach((e) {
      Recipe model = Recipe(
          url: e['recipe']['url'],
          image: e['recipe']['image'],
          source: e['recipe']['source'],
          label: e['recipe']['label']);
      setState(() {
        list.add(model);
      });
    });
  }

  Future<void> addToFavorites(
      String url, String label, String source, String image) async {
    final userId = FirebaseAuth.instance.currentUser!.uid;
    await FirebaseFirestore.instance.collection('favorites').doc(userId).set(
        {
          url: {
            'url':url,
            'label': label,
            'source': source,
            'image': image,
            'timestamp': FieldValue.serverTimestamp(),
          }
        },
        SetOptions(
            merge:
                true)); // Use merge option to avoid overwriting existing data
    setState(() {});
  }

  Future<bool> isFavorite(String url) async {
    final userId = FirebaseAuth.instance.currentUser!.uid;
    final querySnapshot = await FirebaseFirestore.instance
        .collection('favorites')
        .doc(userId)
        .get();
    if (querySnapshot.exists) {
      final data = querySnapshot.data()!;
      return data.containsKey(url);
    }
    return false;
  }
   Widget _buildImage(String imageUrl) {
    return Image.network(
      imageUrl,
      width: 80,
      height: 80,
      fit: BoxFit.cover,
      errorBuilder: (context, error, stackTrace) {
        return Placeholder(); // Placeholder widget to show when image fails to load
      },
    );
  }

  @override
  void initState() {
    super.initState();
    getApiData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _drawerKey,
      appBar: AppBar(
        centerTitle: true,
        title: Text(
          "Home",
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
          textAlign: TextAlign.center,
        ),
        backgroundColor: primaryColor,
      ),
      drawer: CustomDrawer(),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              SizedBox(height: 10),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: TextField(
                  onChanged: (value) {
                    search = value;
                  },
                  decoration: InputDecoration(
                    hintText: "Search For Recipe",
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                    fillColor: primaryColor.withOpacity(0.1),
                    filled: true,
                    suffixIcon: IconButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (_) => Search(search: search)),
                        );
                      },
                      icon: Icon(Icons.search),
                    ),
                  ),
                ),
              ),
              SizedBox(height: 20),
              GridView.builder(
                shrinkWrap: true,
                physics: NeverScrollableScrollPhysics(),
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  crossAxisSpacing: 10,
                  mainAxisSpacing: 10,
                  childAspectRatio: 0.8, // Adjusted child aspect ratio
                ),
                itemCount: list.length,
                itemBuilder: (context, index) {
                  final x = list[index];
                  return GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (_) => ViewRecipe(url: x.url.toString())),
                      );
                    },
                    child: FutureBuilder<bool>(
                      future: isFavorite(x.url.toString()),
                      builder: (context, snapshot) {
                        if (snapshot.connectionState ==
                            ConnectionState.waiting) {
                          return CircularProgressIndicator();
                        } else if (snapshot.hasError) {
                          return Text('Error: ${snapshot.error}');
                        } else {
                          final isFavorite = snapshot.data ?? false;
                          return Card(
                            elevation: 3,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: Stack(
                              children: [
                                Column(
                                  crossAxisAlignment:
                                      CrossAxisAlignment.stretch,
                                  children: [
                                    Expanded(
                                      flex: 3,
                                      child: ClipRRect(
                                        borderRadius: BorderRadius.vertical(
                                            top: Radius.circular(10)),
                                        child: _buildImage(x.image.toString()),
                                      ),
                                    ),
                                    Expanded(
                                      flex: 2,
                                      child: Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              x.label.toString(),
                                              style: TextStyle(
                                                fontWeight: FontWeight.bold,
                                                fontSize: 16,
                                              ),
                                              maxLines: 2,
                                              overflow: TextOverflow.ellipsis,
                                            ),
                                            SizedBox(height: 5),
                                            Text(
                                              x.source.toString(),
                                              style: TextStyle(
                                                color: Colors.grey[700],
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                                Positioned(
                                  top: -13,
                                  right: -8,
                                  child: IconButton(
                                    onPressed: () {
                                      if (!isFavorite) {
                                        addToFavorites(
                                          x.url.toString(),
                                          x.label.toString(),
                                          x.source.toString(),
                                          x.image.toString(),
                                        );
                                      }
                                    },
                                    icon: Icon(
                                      isFavorite
                                          ? Icons.favorite
                                          : Icons.favorite_border,
                                      color: isFavorite ? Colors.red : null,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          );
                        }
                      },
                    ),
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
