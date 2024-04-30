import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:pantrychef/components/drawer.dart';
import 'package:pantrychef/screens/view.dart';

class Favorites extends StatefulWidget {
  const Favorites({Key? key});

  @override
  State<Favorites> createState() => _FavoritesState();
}

class _FavoritesState extends State<Favorites> {
  @override
  Widget build(BuildContext context) {
    const Color primaryColor = Colors.redAccent; // Appetizing red

    return Scaffold(
      drawer: CustomDrawer(),
      appBar: AppBar(
        centerTitle: true,
        title: Text(
          "Favorites",
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
          textAlign: TextAlign.center,
        ),
        backgroundColor: primaryColor,
      ),
      body: buildFavoritesList(),
    );
  }

  Widget buildFavoritesList() {
    final userId = FirebaseAuth.instance.currentUser!.uid;

    return StreamBuilder<DocumentSnapshot<Map<String, dynamic>>>(
      stream: getFavoritesStream(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(
            child: CircularProgressIndicator(),
          );
        } else if (snapshot.hasError) {
          return Center(
            child: Text('Error: ${snapshot.error}'),
          );
        } else if (!snapshot.hasData || snapshot.data!.data() == null) {
          // No data available
          return Center(
            child: Text('No favorites found'),
          );
        } else {
          final data = snapshot.data!.data()!;
          final favorites = data.entries.toList();
          return ListView.builder(
            itemCount: favorites.length,
            itemBuilder: (context, index) {
              final favorite = favorites[index].value as Map<String, dynamic>;
              final String label = favorite['label'] as String;
              final String source = favorite['source'] as String;
              final String imageUrl = favorite['image'] as String;
              final String? url = favorite['url'] as String?;

              return Padding(
                padding:
                    const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                child: Card(
                  elevation: 3,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: ListTile(
                    contentPadding: EdgeInsets.all(8),
                    leading: SizedBox(
                      width: 80,
                      height: 80,
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(8),
                        child: buildImage(imageUrl),
                      ),
                    ),
                    title: Text(
                      label,
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    subtitle: Text(source),
                    onTap: () {
                      if (url != null) {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => ViewRecipe(url: url)),
                          );
                      } else {
                        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                          content: Text('The recipe URL is not available.'),
                        ));
                      }
                    },
                    trailing: IconButton(
                      icon: Icon(Icons.remove_circle),
                      onPressed: () {
                        removeFavorite(label);
                        print(label);
                      },
                    ),
                  ),
                ),
              );
            },
          );
        }
      },
    );
  }

  Stream<DocumentSnapshot<Map<String, dynamic>>> getFavoritesStream() {
    final userId = FirebaseAuth.instance.currentUser!.uid;
    return FirebaseFirestore.instance
        .collection('favorites')
        .doc(userId)
        .snapshots();
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
void removeFavorite(String label) async {
  final userId = FirebaseAuth.instance.currentUser!.uid;
  final favoritesRef = FirebaseFirestore.instance.collection('favorites');

  final querySnapshot = await favoritesRef
      .where('userId', isEqualTo: userId)
      .where('label', isEqualTo: label)
      .get();

  if (querySnapshot.docs.isNotEmpty) {
    final favoriteDoc = querySnapshot.docs.first;
    await favoriteDoc.reference.delete();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Removed favorite')),
    );
    setState(() {});
  } else {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Favorite not found')),
    );
  }
}




}
