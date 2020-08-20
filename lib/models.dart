import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';

class SelectedMovieModel {
  String selectedMovie;

  String get getSelectedMovie {
    return selectedMovie;
  }

  set setSelectedMovie(movie) {
    selectedMovie = movie;
  }
}

class MoviesModel extends ChangeNotifier {
  List movies = [];

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

  List get getMovies {
    return movies;
  }
}
