import 'dart:async';
import 'package:geolocator/geolocator.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:gradients/gradients.dart';
import 'package:tarea_mapa/Model/WeatherModel.dart';
import 'package:tarea_mapa/Network/ApiWeather.dart';
import 'package:tarea_mapa/Widgets/WidgetWeatherDay.dart';
import 'package:tarea_mapa/utils/Ubicacion.dart';
import 'package:url_launcher/url_launcher.dart';

const _url = 'https://github.com/Lyokone/flutterlocation';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  Ubicacion ubi = Ubicacion();
  ApiWeather? apiWeather;
  double? tempi;
  Color primar = Colors.white;
  Color secund = Colors.white;
  Color ter = Colors.white;
  Color cuart = Colors.white;
  String? lati;
  String? longi;

  late Position
      posi; //= Position(longitude: 0, latitude: 0, timestamp: Date, accuracy: 0, altitude: 0, altitudeAccuracy: altitudeAccuracy, heading: heading, headingAccuracy: headingAccuracy, speed: speed, speedAccuracy: speedAccuracy);

  void initState() {
    super.initState();
    apiWeather = ApiWeather();
  }

  void Coloreame(double tempo) {
    if (tempo > 15 && tempo < 21) {
      primar = Colors.cyan;
      secund = Color.fromARGB(255, 244, 247, 201);
      ter = Color.fromARGB(255, 244, 206, 159);
      cuart = Color.fromARGB(255, 157, 117, 243);
    } else if (tempo <= 15 && tempo > 0) {
      primar = Colors.blue;
      secund = Color.fromARGB(255, 248, 244, 170);
      ter = Color.fromARGB(255, 157, 117, 243);
      cuart = Colors.red;
    } else if (tempo >= 21 && tempo < 27) {
      primar = Colors.yellow;
      secund = Color.fromARGB(255, 151, 245, 200);
      ter = Color.fromARGB(255, 226, 175, 244);
      cuart = Colors.blue;
    } else {
      primar = Colors.red;
      secund = Color.fromARGB(255, 212, 255, 218);
      ter = Color.fromARGB(255, 175, 229, 244);
      cuart = Color.fromARGB(255, 24, 181, 220);
    }
  }

  @override
  Widget createWeatherList(BuildContext context, AsyncSnapshot snapshot,
      Color thcolor, Color thcolot) {
    return Container(
        height: 150,
        child: ListView.separated(
            separatorBuilder: (BuildContext context, int index) => Container(
                  width: 5,
                ),
            padding: EdgeInsets.only(left: 10),
            itemCount: snapshot.data!.length,
            shrinkWrap: true,
            scrollDirection: Axis.horizontal,
            itemBuilder: (BuildContext context, int index) {
              return WidgetWeatherDay(
                  snapshot.data![index], context, thcolor, thcolot);
            }));
  }

  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color.fromARGB(255, 183, 205, 224),
      body: ListView(children: [
        StreamBuilder(
            stream: ubi.Getposition(),
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                lati = snapshot.data!.latitude.toString();
                longi = snapshot.data!.longitude.toString();
                return FutureBuilder(
                    future: apiWeather!.getWeather(
                        snapshot.data!.latitude.toString(),
                        snapshot.data!.longitude.toString()),
                    builder:
                        (context, AsyncSnapshot<List<WeatherModel>?> snapshot) {
                      if (snapshot.hasData) {
                        tempi =
                            double.tryParse(snapshot.data![0].temp.toString());
                        Coloreame(double.tryParse(
                            snapshot.data![0].temp.toString())!);
                        return Center(
                          child: ListView(
                            shrinkWrap: true,
                            scrollDirection: Axis.vertical,
                            children: [
                              const SizedBox(
                                height: 60,
                              ),
                              Center(
                                child: Container(
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(15),
                                    gradient: LinearGradientPainter(
                                      colors: <Color>[
                                        secund,
                                        ter,
                                      ],
                                    ),
                                    // color:
                                    //   secund // Color.fromARGB(234, 249, 245, 245),
                                  ),
                                  padding: EdgeInsets.all(10.0),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    children: [
                                      Row(
                                          mainAxisSize: MainAxisSize.min,
                                          crossAxisAlignment:
                                              CrossAxisAlignment.center,
                                          children: [
                                            Icon(
                                              color: primar,
                                              Icons.thermostat,
                                              size: 80,
                                            ),
                                            Text(
                                                style: TextStyle(fontSize: 40),
                                                snapshot.data![0].temp
                                                        .toString() +
                                                    ' C°')
                                          ])
                                    ],
                                  ),
                                ),
                              ),
                              const SizedBox(
                                height: 40,
                              ),
                              Center(
                                child: Container(
                                    padding: EdgeInsets.all(10.0),
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(15),
                                      color: secund,
                                    ),
                                    child: Column(
                                      children: [
                                        ColorFiltered(
                                          colorFilter: ColorFilter.mode(
                                              primar, BlendMode.modulate),
                                          child: Image(
                                              image: AssetImage('assets/' +
                                                  snapshot.data![0].icon
                                                      .toString() +
                                                  '.png')),
                                        ),
                                        Text(
                                            style: TextStyle(fontSize: 35),
                                            snapshot.data![0].description
                                                .toString()),
                                        Text(
                                            style: TextStyle(
                                                color: cuart, fontSize: 20),
                                            'Temperatura Maxima: '),
                                        Text(
                                            style: TextStyle(fontSize: 20),
                                            snapshot.data![0].temp_max
                                                    .toString() +
                                                'C°'),
                                        Text(
                                            style: TextStyle(
                                                color: cuart, fontSize: 20),
                                            'Temperatura Minima: '),
                                        Text(
                                            style: TextStyle(fontSize: 20),
                                            snapshot.data![0].temp_min
                                                    .toString() +
                                                'C°'),
                                        Text(
                                            style: TextStyle(
                                                color: cuart, fontSize: 20),
                                            'Humedad: '),
                                        Text(
                                            style: TextStyle(fontSize: 20),
                                            snapshot.data![0].humidity
                                                .toString()),
                                        Text(
                                            style: TextStyle(
                                                color: cuart, fontSize: 20),
                                            'Sensacion termica: '),
                                        Text(
                                            style: TextStyle(fontSize: 20),
                                            snapshot.data![0].feels_like
                                                .toString()),
                                        const SizedBox(
                                          height: 10,
                                        ),
                                        FutureBuilder(
                                            future: apiWeather!.getAllWeather(
                                                lati!, longi!, DateTime.now()),
                                            initialData: [],
                                            builder: (context, snapshot) {
                                              if (snapshot.hasData) {
                                                return createWeatherList(
                                                    context,
                                                    snapshot,
                                                    primar,
                                                    secund); /*Container(
                                                    height: 150,
                                                    child: ListView.builder(
                                                        itemCount: snapshot
                                                            .data!.length,
                                                        shrinkWrap: true,
                                                        scrollDirection:
                                                            Axis.horizontal,
                                                        itemBuilder:
                                                            (BuildContext
                                                                    context,
                                                                int index) {
                                                          return WidgetWeatherDay(
                                                              snapshot
                                                                  .data![index],
                                                              context);
                                                        }));*/
                                              } else {
                                                if (snapshot.hasError) {
                                                  return Center(
                                                    child: Text('Error 3'),
                                                  );
                                                } else {
                                                  return Center(
                                                    child:
                                                        CircularProgressIndicator(),
                                                  );
                                                }
                                              }
                                            })
                                      ],
                                    )),
                              ),
                            ],
                          ),
                        );
                      } else {
                        if (snapshot.hasError) {
                          return Center(
                            child: Text('Error 2'),
                          );
                        } else {
                          return Center(
                            child: CircularProgressIndicator(),
                          );
                        }
                      }
                    });

                /*Text(snapshot.data!.latitude.toString() +
                    ' ' +
                    snapshot.data!.longitude.toString());*/
              } else {
                if (snapshot.hasError) {
                  return Center(
                    child: Text('Error 1'),
                  );
                } else {
                  return Center(
                    child: CircularProgressIndicator(),
                  );
                }
              }
            })

        /* TextButton(
            onPressed: () async {
              posi = await ubi.determinePosition();
              print(posi.latitude.toString() + ' ' + posi.longitude.toString());
            },
            child: Text('hola')),*/
      ]),
    );
  }
}
