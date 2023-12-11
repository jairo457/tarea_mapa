import 'dart:async';
import 'package:circular_menu/circular_menu.dart';
import 'package:geolocator/geolocator.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
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
  ScrollController _controller = new ScrollController();
  Ubicacion ubi = Ubicacion();
/*  late Location location;
  late bool _serviceEnabled = false;
  late PermissionStatus _permissionGranted;
  late LocationData _locationData;*/
//----
//---
  StreamController<Position> _locStream = StreamController();
  late StreamSubscription<Position> locationSubscription;
//--
  final ApiWeather apiWeather = ApiWeather();
  double? tempi;
  Color primar = Colors.white;
  Color secund = Colors.white;
  Color ter = Colors.white;
  Color cuart = Colors.white;
  String? lati;
  String? longi;
  final red = false.obs;

  late Position
      posi; //= Position(longitude: 0, latitude: 0, timestamp: Date, accuracy: 0, altitude: 0, altitudeAccuracy: altitudeAccuracy, heading: heading, headingAccuracy: headingAccuracy, speed: speed, speedAccuracy: speedAccuracy);

  void initState() {
    super.initState();
    /*WidgetsBinding.instance.addPostFrameCallback((_) {
      setState(() {});
    });*/
    permisos();
    startLocation();
    //pregunta1();
  }

  permisos() async {
    red.value = ubi.determinePosition();
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

  startLocation() {
    final positionStream =
        Geolocator.getPositionStream().handleError((error) {});
    locationSubscription = positionStream.listen((Position position) {
      _locStream.sink.add(position);
    });
  }

  @override
  Widget build(BuildContext context) {
    final circularMenu = CircularMenu(
        alignment: Alignment.centerRight,
        toggleButtonColor: Colors.amber,
        items: [
          CircularMenuItem(
              icon: Icons.map,
              onTap: () {
                Navigator.pushNamed(context, '/map');
              }),
          CircularMenuItem(
              icon: Icons.search,
              onTap: () {
                //callback
              }),
          CircularMenuItem(
              icon: Icons.settings,
              onTap: () {
                //callback
              }),
          CircularMenuItem(
              icon: Icons.star,
              onTap: () {
                //callback
              }),
          CircularMenuItem(
              icon: Icons.pages,
              onTap: () {
                //callback
              }),
        ]);

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

    return Obx(
      () => Scaffold(
          backgroundColor: Color.fromARGB(255, 183, 205, 224),
          body: red.value
              ? Stack(children: [
                  ListView(
                      controller: _controller,
                      physics: const AlwaysScrollableScrollPhysics(),
                      children: [
                        StreamBuilder(
                            stream: _locStream.stream,
                            builder: (context, snapshot) {
                              if (snapshot.hasData) {
                                lati = snapshot.data!.latitude.toString();
                                longi = snapshot.data!.longitude.toString();
                                return FutureBuilder(
                                    future: apiWeather!.getWeather(
                                        snapshot.data!.latitude.toString(),
                                        snapshot.data!.longitude.toString()),
                                    builder: (context,
                                        AsyncSnapshot<List<WeatherModel>?>
                                            snapshot) {
                                      if (snapshot.hasData) {
                                        tempi = double.tryParse(
                                            snapshot.data![0].temp.toString());
                                        Coloreame(double.tryParse(snapshot
                                            .data![0].temp
                                            .toString())!);
                                        return Center(
                                          child: ListView(
                                            shrinkWrap: true,
                                            children: [
                                              const SizedBox(
                                                height: 30,
                                              ),
                                              Center(
                                                child: Container(
                                                  decoration: BoxDecoration(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            15),
                                                    gradient:
                                                        LinearGradientPainter(
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
                                                        CrossAxisAlignment
                                                            .center,
                                                    children: [
                                                      Row(
                                                          mainAxisSize:
                                                              MainAxisSize.min,
                                                          crossAxisAlignment:
                                                              CrossAxisAlignment
                                                                  .center,
                                                          children: [
                                                            Icon(
                                                              color: primar,
                                                              Icons.thermostat,
                                                              size: 80,
                                                            ),
                                                            Text(
                                                                style: TextStyle(
                                                                    fontSize:
                                                                        40),
                                                                snapshot
                                                                        .data![
                                                                            0]
                                                                        .temp
                                                                        .toString() +
                                                                    ' C°'),
                                                            //circularMenu,
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
                                                    padding:
                                                        EdgeInsets.all(10.0),
                                                    decoration: BoxDecoration(
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              15),
                                                      color: secund,
                                                    ),
                                                    child: Column(
                                                      mainAxisSize:
                                                          MainAxisSize.max,
                                                      children: [
                                                        ColorFiltered(
                                                          colorFilter:
                                                              ColorFilter.mode(
                                                                  primar,
                                                                  BlendMode
                                                                      .modulate),
                                                          child: Image(
                                                              image: AssetImage(
                                                                  'assets/' +
                                                                      snapshot
                                                                          .data![
                                                                              0]
                                                                          .icon
                                                                          .toString() +
                                                                      '.png')),
                                                        ),
                                                        Text(
                                                            style: TextStyle(
                                                                fontSize: 35),
                                                            snapshot.data![0]
                                                                .description
                                                                .toString()),
                                                        Text(
                                                            style: TextStyle(
                                                                color: cuart,
                                                                fontSize: 20),
                                                            'Temperatura Maxima: '),
                                                        Text(
                                                            style: TextStyle(
                                                                fontSize: 20),
                                                            snapshot.data![0]
                                                                    .temp_max
                                                                    .toString() +
                                                                'C°'),
                                                        Text(
                                                            style: TextStyle(
                                                                color: cuart,
                                                                fontSize: 20),
                                                            'Temperatura Minima: '),
                                                        Text(
                                                            style: TextStyle(
                                                                fontSize: 20),
                                                            snapshot.data![0]
                                                                    .temp_min
                                                                    .toString() +
                                                                'C°'),
                                                        Text(
                                                            style: TextStyle(
                                                                color: cuart,
                                                                fontSize: 20),
                                                            'Humedad: '),
                                                        Text(
                                                            style: TextStyle(
                                                                fontSize: 20),
                                                            snapshot.data![0]
                                                                .humidity
                                                                .toString()),
                                                        Text(
                                                            style: TextStyle(
                                                                color: cuart,
                                                                fontSize: 20),
                                                            'Sensacion termica: '),
                                                        Text(
                                                            style: TextStyle(
                                                                fontSize: 20),
                                                            snapshot.data![0]
                                                                .feels_like
                                                                .toString()),
                                                        const SizedBox(
                                                          height: 10,
                                                        ),
                                                        FutureBuilder(
                                                            future: apiWeather!
                                                                .getAllWeather(
                                                                    lati!,
                                                                    longi!,
                                                                    DateTime
                                                                        .now()),
                                                            initialData: [],
                                                            builder: (context,
                                                                snapshot) {
                                                              if (snapshot
                                                                  .hasData) {
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
                                                                if (snapshot
                                                                    .hasError) {
                                                                  return Center(
                                                                    child: Text(
                                                                        'Error 3'),
                                                                  );
                                                                } else {
                                                                  return Center(
                                                                    child:
                                                                        CircularProgressIndicator(),
                                                                  );
                                                                }
                                                              }
                                                            }),
                                                        const SizedBox(
                                                          height: 10,
                                                        ),
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
                                  //setState(() {});
                                  return Center(
                                    child: Text('Error 1'),
                                  );
                                } else {
                                  return Center(
                                    child: Text(
                                        snapshot.connectionState.toString()),
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
                  Align(
                    alignment: Alignment.bottomRight,
                    child: circularMenu,
                  ),
                ])
              : ListView(children: [
                  Center(child: Text('We need permissions')),
                  TextButton(
                      onPressed: () async {
                        bool temp = await ubi.determinePosition();
                        if (temp) {
                          setState(() {
                            red.value = true;
                          });
                        }
                      },
                      child: Text('Conceder permiso'))
                ])),
    );
  }
}
