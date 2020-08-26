import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';

class MoviesModel extends ChangeNotifier {
  List movies = [];

  int selectedIndex = 0;

  MoviesModel() {
    final CollectionReference moviesCollection =
        FirebaseFirestore.instance.collection('movies');
    moviesCollection.get().then((QuerySnapshot querySnapshot) {
      querySnapshot.docs.forEach((doc) {
        this.movies.add(doc.data());
      });
      notifyListeners();
    });
  }
}
