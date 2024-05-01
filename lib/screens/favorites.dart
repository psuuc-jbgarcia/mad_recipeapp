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
    const Color secondaryColor = Colors.lightGreenAccent; // Fresh green

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
        iconTheme: IconThemeData(color: Colors.white),
        actions: [
          IconButton(
            onPressed: () {
              showConfirmationSnackBar();
            },
            icon: Icon(Icons.delete, color: Colors.white),
          ),
        ],
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
  child: Column(
    mainAxisAlignment: MainAxisAlignment.center,
    children: [
      Icon(
        Icons.favorite_border,
        color: primaryColor,
        size: 48,
      ),
      SizedBox(height: 16),
      Text(
        'No favorites found',
        style: TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.bold,
          color: primaryColor,
        ),
      ),
    ],
  ),
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
              padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
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
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: primaryColor,
                    ),
                  ),
                  subtitle: Text(
                    source,
                    style: TextStyle(
                      color: secondaryColor,
                    ),
                  ),
                  onTap: () {
                    if (url != null) {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (_) => ViewRecipe(url: url)),
                      );
                    } else {
                      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                        content: Text('The recipe URL is not available.'),
                      ));
                    }
                  },
                  trailing: IconButton(
                    icon: Icon(Icons.remove_circle, color: primaryColor),
                    onPressed: () {
                      removeFromFavorites(url.toString());
                      print(url);
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
        return Placeholder(
          color: Colors.red,
          fallbackWidth: 80,
          fallbackHeight: 80,
          child: Center(
            child: Text("Image is too slow to show"),
          ),
        );
      },
    );
  }
Future<void> removeFromFavorites(String url) async {
  final userId = FirebaseAuth.instance.currentUser!.uid;
  final documentRef =
      FirebaseFirestore.instance.collection('favorites').doc(userId);

  final docSnapshot = await documentRef.get();
  if (docSnapshot.exists) {
    Map<String, dynamic> favorites = docSnapshot.data() as Map<String, dynamic>;
    favorites.remove(url); // Remove the recipe with the specified URL
    await documentRef.set(favorites); // Update the document
  }
 
}


  void showConfirmationSnackBar() {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Are you sure you want to remove all favorites?'),
        duration: Duration(seconds: 5),
        action: SnackBarAction(
          label: 'REMOVE ALL',
          onPressed: () {
            removeAllFavorites();
          },
        ),
      ),
    );
  }

  Future<void> removeAllFavorites() async {
    final userId = FirebaseAuth.instance.currentUser!.uid;
    final favoritesRef =
        FirebaseFirestore.instance.collection('favorites').doc(userId);

    await favoritesRef.delete();

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('All favorites removed')),
    );
  }
}
