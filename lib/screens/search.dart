import 'dart:convert';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:pantrychef/components/drawer.dart';
import 'package:pantrychef/screens/model.dart';
import 'package:pantrychef/screens/view.dart';

class Search extends StatefulWidget {
  final search;

  const Search({Key? key, this.search}) : super(key: key);

  @override
  State<Search> createState() => _SearchState();
}

class _SearchState extends State<Search> {
  List<Recipe> list = <Recipe>[];
  final GlobalKey<ScaffoldState> _drawerKey = GlobalKey();

  getApiData(String search) async {
    final url =
        "https://api.edamam.com/search?q=$search&app_id=1a08c259&app_key=344a22a6d97e805580ee27a597df263c&from=0&to=10&calories=591-722&health=alcohol-free";
    var response = await http.get(Uri.parse(url));
    Map json = jsonDecode(response.body);
    print(response.body);
    json['hits'].forEach((e) {
      Recipe model = Recipe(
        url: e['recipe']['url'],
        image: e['recipe']['image'],
        source: e['recipe']['source'],
        label: e['recipe']['label'],
      );
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
     Widget buildImage(String imageUrl) {
    return Image.network(
      imageUrl,
      width: 80,
      height: 80,
      fit: BoxFit.cover,
      errorBuilder: (context, error, stackTrace) {
        return  Placeholder(
          color: Colors.red,
          fallbackWidth: 80,
          fallbackHeight: 80,
          child: Center(
            child: Text("Image is too slow to show"),
          ),
        );// Placeholder widget to show when image fails to load
      },
    );
  }
  @override
  void initState() {
    super.initState();
    getApiData(widget.search);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(

      appBar: AppBar(
    centerTitle: true,
          title: Text(
            "Result",
            style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
            textAlign: TextAlign.center,
          ),
          backgroundColor: primaryColor,
                    iconTheme: IconThemeData(color: Colors.white), 

      ),
      body:SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              SizedBox(height: 10),
         
              SizedBox(height: 20),
              GridView.builder(
                shrinkWrap: true,
                physics: NeverScrollableScrollPhysics(),
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  crossAxisSpacing: 10,
                  mainAxisSpacing: 10,
                  childAspectRatio: 0.75,
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
                          return  Card(
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
                                        child: buildImage(x.image.toString()),
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
                if (list.isEmpty)
                Center(
                  child: Text(
                    "No recipes found",
                    style: TextStyle(fontSize: 18),
                  ),
                )
            ],
          ),
        ),
    ));
  }
}
