import 'dart:convert';

import 'package:tarea_mapa/Model/WeatherModel.dart';
import 'package:http/http.dart' as http;

class ApiWeather {
  late Map<String, dynamic> someMap;
  List buena = [];
  Map? tempu;
  bool band = true;
  DateTime? tum;
  List<DateTime> fechis = [];
  Uri link = Uri.parse(
      'https://api.themoviedb.org/3/movie/popular?api_key=84376d11354a413f8d8476b07e82d0ff&language=es-MX&page=1');

  String link_someplace =
      'https://api.openweathermap.org/data/2.5/forecast?lang=es&lat=';

  String link_oneplace_1 =
      'https://api.openweathermap.org/data/2.5/weather?lang=es&lat=';
  String link_oneplace_2 = '&lon=';
  String link_oneplace_3 =
      '&units=metric&appid=6e7b0caf625386233004b1f79ec21805';

  Future<List<WeatherModel>?> getWeather(String lat, String lon) async {
    var response = await http.get(Uri.parse(link_oneplace_1 +
        lat +
        link_oneplace_2 +
        lon +
        link_oneplace_3)); //capturamos el resultado
    if (response.statusCode == 200) {
      var jsonResult = jsonDecode(response.body)['weather'] as List;
      //var jsonResult2 = jsonDecode(response.body)['main'] as List;
      var jsonResult2 = json.decode(response.body.toString());
      var list = jsonResult2['main'];
      List<dynamic> weightData = list.entries
          .map((entry) => (entry.key + ': ' + entry.value.toString()))
          .toList();
      Map bui = jsonResult[0];
      bui.addAll(list);
      jsonResult.clear();
      jsonResult.add(bui);
      //print(jsonResult.toString());
      //print('we: ' + weightData.toString());
      //print('we: ' + jsonResult.toString());
      //print('tis: ' + bui.toString());
      //print('we2: ' + jsonResult.toString());
//recuperar conjunto de resultados, antes lo parseamos y luego a lista
      return jsonResult.map((clima) => WeatherModel.fromMap(clima)).toList();
      //retornamos el json obtenido como lista o
    }
    return null; //no
  }

  Future<List<WeatherModel>?> getAllWeather(
      String lat, String lon, DateTime urs) async {
    var response = await http.get(Uri.parse(link_someplace +
        lat +
        link_oneplace_2 +
        lon +
        link_oneplace_3)); //capturamos el resultado
    if (response.statusCode == 200) {
      var jsonResult = jsonDecode(response.body)['list'] as List;
//recuperar conjunto de resultados, antes lo parseamos y luego a lista
      buena.clear();
      fechis.clear();
      band = true;
      filtra(jsonResult, urs);
      //print(jsonResult.toString());
      return buena.map((clima) => WeatherModel.fromMap(clima)).toList();
      //retornamos el json obtenido como lista o
    }
    return null; //no
  }

  filtra(List madre, DateTime limit) {
    for (Map mapi in madre) {
      Map tump;
      DateTime tim;
      Map one;
      Map two;
      Map tree;
      String four;
      List tempo;
      one = mapi['main'];
      four = mapi['dt_txt'];
      tim = DateTime.parse(four);
      tempo = mapi['weather'];
      two = tempo[0];
      two.addAll(one);
      two['dat'] = four;
      if (fechis.isEmpty) {
        if (tim!.day != limit.day) {
          tempu = two;
          fechis!.add(tim);
          tum = tim;
        }
      } else {
        if (tum!.day == tim.day) {
          if (tum!.hour == 12) {
            if (band) {
              print('Anadido ' + tum.toString() + ': ' + tempu.toString());
              buena.add(tempu);
              band = false;
            }
          } else if (tim!.hour == 12) {
            print('Anadido' + tim.toString() + ': ' + two.toString());
            buena.add(two);
            band = false;
          }
          if ((limit.day + 5) == tim.day) {
            if (band) {
              buena.add(two);
              print('Anadido' + tim.toString() + ': ' + two.toString());
              band = false;
            }
          }
        } else {
          if (band) {
            print('Anadido ' + tum.toString() + ': ' + tempu.toString());
            buena.add(tempu);
            tempu = two;
            tum = tim;
            band = true;
          } else {
            tempu = two;
            tum = tim;
            band = true;
          }
        }
      }
    }
    print(buena.toString());
  }
}
