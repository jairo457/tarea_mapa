import 'package:flutter/material.dart';
import 'package:tarea_mapa/Screens/HomeScreen.dart';
import 'package:tarea_mapa/Screens/MapScreen.dart';

Map<String, WidgetBuilder> GetRoutes() {
  return {
    '/home': (BuildContext context) => HomeScreen(),
    '/map': (BuildContext context) => MapScreen(),
    /*'/detail': (BuildContext context) => DetailMovieScreen(),
    '/fav': (BuildContext context) => FavScreen(),
    '/basic': (BuildContext context) => LoginScreen(),*/
  };
}
