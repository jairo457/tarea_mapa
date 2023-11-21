import 'package:flutter/material.dart';
import 'package:tarea_mapa/Screens/HomeScreen.dart';


Map<String, WidgetBuilder> GetRoutes() {
  return {
    '/home': (BuildContext context) => HomeScreen(),
    /*'/popular': (BuildContext context) => PopularScreen(),
    '/detail': (BuildContext context) => DetailMovieScreen(),
    '/fav': (BuildContext context) => FavScreen(),
    '/basic': (BuildContext context) => LoginScreen(),*/
  };
}
