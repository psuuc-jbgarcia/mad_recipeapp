import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:pantrychef/components/drawer.dart';

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
      body: _buildFavoritesList(),
    );
  }

  Widget _buildFavoritesList() {
    return FutureBuilder<DocumentSnapshot<Map<String, dynamic>>>(
      future: _getFavorites(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(
            child: CircularProgressIndicator(),
          );
        } else if (snapshot.hasError) {
          return Center(
            child: Text('Error: ${snapshot.error}'),
          );
        } else {
          final data = snapshot.data!.data() as Map<String, dynamic>;
          final favorites = data.entries.toList();
          return ListView.builder(
            itemCount: favorites.length,
            itemBuilder: (context, index) {
              final favorite = favorites[index].value as Map<String, dynamic>;
              return Padding(
                padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                child: Card(
                  elevation: 3,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: ListTile(
                    contentPadding: EdgeInsets.all(8),
                    leading: ClipRRect(
                      borderRadius: BorderRadius.circular(8),
                      child: Image.network(
                        favorite['image'],
                        width: 80,
                        height: 80,
                        fit: BoxFit.cover,
                      ),
                    ),
                    title: Text(
                      favorite['label'],
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    subtitle: Text(favorite['source']),
                    onTap: () {
                      // Navigate to the recipe details screen
                    },
                  ),
                ),
              );
            },
          );
        }
      },
    );
  }

  Future<DocumentSnapshot<Map<String, dynamic>>> _getFavorites() async {
    final userId = FirebaseAuth.instance.currentUser!.uid;
    return await FirebaseFirestore.instance
        .collection('favorites')
        .doc(userId)
        .get();
  }
}
