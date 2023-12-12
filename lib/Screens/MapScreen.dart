import 'dart:async';
import 'dart:ffi';
import 'dart:typed_data';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:circular_menu/circular_menu.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:tarea_mapa/Model/MarkModel.dart';
import 'package:tarea_mapa/Model/WeatherModel.dart';
import 'package:tarea_mapa/Network/ApiWeather.dart';
import 'package:tarea_mapa/Widgets/CardLocateWidget.dart';
import 'package:tarea_mapa/database/Masterdb.dart';
import 'package:tarea_mapa/utils/Ubicacion.dart';
import 'package:tarea_mapa/utils/utils.dart';

class MapScreen extends StatefulWidget {
  const MapScreen({super.key});

  @override
  State<MapScreen> createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {
  final details = false.obs;
  final type = false.obs;
  final list = false.obs;
  MapType? mapType;
  int mapMode = 1;
  WeatherModel? myclime;
  List<WeatherModel>? oneclime;
  final ApiWeather apiWeather = ApiWeather();
  final Completer<GoogleMapController> _controller =
      Completer<GoogleMapController>();
  List<Marker> myMarker = [];
  List<MarkModel>? list1;
  late Position possi;
  Ubicacion ubi = Ubicacion();
  late GoogleMapController mapcontroller;
  BitmapDescriptor myIcon = BitmapDescriptor.defaultMarker;
  MasterDB? masterDB;
  bool cambio = false;
  bool borra = false;
  TextEditingController TxtGenericName = TextEditingController();
  Color primar = Colors.white;
  Color secund = Colors.white;
  Color ter = Colors.white;
  Color cuart = Colors.white;

  @override
  void initState() {
    masterDB = MasterDB();
    super.initState();
    modo();
    //SystemChrome.setEnabledSystemUIMode(SystemUiMode.leanBack);
    marca();
    Lista();
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

  Posiciona(LatLng Point) async {
    oneclime = await apiWeather.getWeather(
        Point.latitude.toString(), Point.longitude.toString());
    //print(oneclime![0].humidity);
    details.value = true;
  }

  Lista() async {
    list1 = await masterDB!.GETALL_Mark();
    for (MarkModel ma in list1!) {
      myMarker.add(Marker(
          icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueBlue),
          markerId: MarkerId(ma.lat.toString()),
          /* infoWindow: InfoWindow(
              title:
                  ma.Name!.length > 10 ? ma.Name!.substring(0, 15) : ma.Name),*/
          position: LatLng(double.tryParse(ma.lat.toString())!,
              double.tryParse(ma.long.toString())!)));
    }
    setState(() {});
  }

  marca() {
    /*Uint8List iconBytes = await Utils.getBytesFromAsset('assets/01d.png', 10);
    myIcon = BitmapDescriptor.fromBytes(iconBytes);
    myIcon = BitmapDescriptor.fromAssetImage(configuration, assetName);*/
    BitmapDescriptor.fromAssetImage(ImageConfiguration.empty, "assets/01d.png")
        .then((icon) {
      myIcon = icon;
    });
  }

  modo() {
    switch (mapMode) {
      case 0:
        mapType = MapType.hybrid;
        break;
      case 1:
        mapType = MapType.normal;
        break;
      case 2:
        mapType = MapType.terrain;
        break;
      case 3:
        mapType = MapType.satellite;
        break;
    }
  }

  CameraPosition _kGooglePlex = CameraPosition(
    target: LatLng(37.42796133580664, -122.085749655962),
    zoom: 14.4746,
  );

  static const CameraPosition _kLake = CameraPosition(
      bearing: 192.8334901395799,
      target: LatLng(37.43296265331129, -122.08832357078792),
      tilt: 59.440717697143555,
      zoom: 19.151926040649414);

  @override
  Widget build(BuildContext context) {
    /* final txtGenericName = TextFormField(
      decoration: const InputDecoration(
          label: Text('Nombre'), border: OutlineInputBorder()),
      controller: TxtGenericName,
    );*/

    final circularMenu = CircularMenu(
        alignment: Alignment.centerRight,
        toggleButtonSize: MediaQuery.of(context).size.width / 8,
        curve: Curves.ease,
        toggleButtonColor: Colors.amber,
        items: [
          CircularMenuItem(
              color: Color.fromARGB(255, 250, 189, 131),
              icon: Icons.device_thermostat,
              onTap: () {
                Navigator.pushNamed(context, '/home');
              }),
          CircularMenuItem(
              color: Color.fromARGB(255, 124, 192, 248),
              icon: Icons.view_list_rounded,
              onTap: () {
                details.value = false;
                list.value = true;
                type.value = false;
                //callback
              }),
          CircularMenuItem(
              color: Color.fromARGB(255, 117, 183, 89),
              icon: Icons.my_location,
              onTap: () async {
                Position nu;
                nu = await ubi.GetCurrentposition();
                //print(nu.latitude.toString());
                mapcontroller.moveCamera(
                    CameraUpdate.newLatLng(LatLng(nu.latitude, nu.longitude)));
                /* _kGooglePlex = CameraPosition(
                  target: LatLng(nu.latitude, nu.longitude),
                  zoom: 14.4746,
                );*/
                _handle_tap(LatLng(nu.latitude, nu.longitude));
              }),
        ]);

    return Obx(
      () => Scaffold(
        body: Stack(children: [
          GoogleMap(
            markers: Set.from(myMarker),
            mapType: mapType!,
            initialCameraPosition: _kGooglePlex,
            onMapCreated:
                onMapCreated /*(GoogleMapController mapcontroller) {
              _controller.complete(mapcontroller);
            },*/
            ,
            onTap: _handle_tap,
          ),
          Align(
            alignment: Alignment.bottomRight,
            child: circularMenu,
          ),
          details.value
              ? Positioned(
                  top: 20,
                  left: 20,
                  child: Container(
                      decoration: BoxDecoration(
                          color: Colors.white,
                          //border: Border.,
                          borderRadius: BorderRadius.all(Radius.circular(20))),
                      //padding: EdgeInsets.only(top: 40),
                      //color: Colors.white,
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Image(
                              width: MediaQuery.of(context).size.width / 4,
                              image: AssetImage('assets/' +
                                  oneclime![0].icon.toString() +
                                  '.png')),
                          Column(children: [
                            SizedBox(
                              height: MediaQuery.of(context).size.width / 25,
                            ),
                            Text(oneclime![0].description.toString()),
                            Text(
                              'Humedad: ' + oneclime![0].humidity.toString(),
                            ),
                            Text('Temperatura maxima: ' +
                                oneclime![0].temp_max.toString()),
                            Text('Temperatura minima: ' +
                                oneclime![0].temp_min.toString())
                          ]),
                          IconButton(
                              onPressed: () {
                                myMarker.removeLast();
                                borra = false;
                                details.value = false;
                              },
                              icon: Icon(color: Colors.red, Icons.close))
                        ],
                      )),
                )
              : Container(),
          Positioned(
            bottom: 50,
            left: 10,
            child: Container(
                decoration: BoxDecoration(
                    color: Colors.white,
                    //border: Border.,
                    borderRadius: BorderRadius.all(Radius.circular(20))),
                //padding: EdgeInsets.only(top: 2),
                //color: Colors.white,
                child: type.value
                    ? Row(
                        children: [
                          IconButton(
                            icon: Icon(
                              color: Colors.blueAccent,
                              Icons.menu,
                              size: MediaQuery.of(context).size.width / 10,
                            ),
                            onPressed: () {
                              type.value = false;
                            },
                          ),
                          IconButton(
                              color: Color.fromARGB(255, 52, 204, 72),
                              onPressed: () {
                                mapMode = 2;
                                modo();
                                setState(() {});
                              },
                              icon: Icon(Icons.landscape)),
                          IconButton(
                              color: Color.fromARGB(255, 128, 213, 255),
                              onPressed: () {
                                mapMode = 1;
                                modo();
                                setState(() {});
                              },
                              icon: Icon(Icons.map)),
                          IconButton(
                              color: Color.fromARGB(255, 146, 153, 161),
                              onPressed: () {
                                mapMode = 3;
                                modo();
                                setState(() {});
                              },
                              icon: Icon(Icons.satellite_alt)),
                          IconButton(
                              color: Color.fromARGB(255, 218, 141, 225),
                              onPressed: () {
                                mapMode = 0;
                                modo();
                                setState(() {});
                              },
                              icon: Icon(Icons.science_outlined))
                        ],
                      )
                    : IconButton(
                        icon: Icon(
                          color: Colors.blueAccent,
                          Icons.menu,
                          size: MediaQuery.of(context).size.width / 10,
                        ),
                        onPressed: () {
                          list.value = false;
                          type.value = true;
                        },
                      )),
          ),
          list.value
              ? Positioned(
                  top: 40,
                  left: 30,
                  child: Container(
                      width: 300,
                      decoration: BoxDecoration(
                          color: Colors.white,
                          //border: Border.,
                          borderRadius: BorderRadius.all(Radius.circular(20))),
                      //padding: EdgeInsets.only(top: 2),
                      //color: Colors.white,
                      child: Column(children: [
                        IconButton(
                            onPressed: () {
                              list.value = false;
                            },
                            icon: Icon(color: Colors.red, Icons.close)),
                        FutureBuilder(
                            future: masterDB!.GETALL_Mark(),
                            builder: (BuildContext buildContext,
                                AsyncSnapshot<List<MarkModel>> snapshot) {
                              if (snapshot.hasData) {
                                return ListView.builder(
                                    physics: NeverScrollableScrollPhysics(),
                                    shrinkWrap: true,
                                    itemCount: snapshot.data!.length,
                                    itemBuilder:
                                        (BuildContext context, int index) {
                                      return CardLocateWidget(
                                        markModel: snapshot.data![index],
                                        masterDB: masterDB,
                                        control: mapcontroller,
                                      );
                                    });
                              } else {
                                if (snapshot.hasError) {
                                  return const Center(
                                    child: Text('Error!'),
                                  );
                                } else {
                                  return CircularProgressIndicator();
                                }
                              }
                            }),
                      ])),
                )
              : Container()
        ]),
      ),
    );
  }

  _handle_tap(LatLng tappedPoint) {
    details.value = false;
    if (borra) {
      myMarker.removeLast();
    }
    list.value = false;
    type.value = false;
    Posiciona(tappedPoint);
    myMarker.add(Marker(
        draggable: false,
        icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueBlue),
        //myIcon,
        markerId: MarkerId(tappedPoint.toString()),
        position: tappedPoint,
        onTap: () {
          showDialog(
              context: context,
              builder: (context) {
                return AlertDialog(
                  content: IntrinsicHeight(
                    child: Column(
                      children: [
                        Text('¿Desea agregar la ubicacion?'),
                        TextFormField(
                          decoration: const InputDecoration(
                            label: Text('Nombre'),
                          ),
                          controller: TxtGenericName,
                        ),
                        TextButton(
                            onPressed: () {
                              masterDB!.INSERT_Mark('tblMark', {
                                'lat': tappedPoint.latitude.toString(),
                                'long': tappedPoint.longitude.toString(),
                                'Name': TxtGenericName.text,
                              }).then((value) {
                                TxtGenericName.text = '';
                                Navigator.pop(context);
                                borra = false;
                              });
                            },
                            child: Text('Agregar'))
                      ],
                    ),
                  ),
                );
              });
        }));
    /*print('Markers: ' +
        myMarker.length.toString() +
        '---------' +
        borra.toString());*/
    borra = true;
    setState(() {});
    /*myMarker.add(Marker(
        draggable: false,
        icon: // await BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.fromAssetImage(configuration, assetName)) ,
            myIcon,
        markerId: MarkerId(tappedPoint.toString() + "a"),
        position: LatLng(
            tappedPoint.latitude - 0.0001, tappedPoint.longitude - 0.0001),
        onTap: () {}));*/
  }

  onMapCreated(GoogleMapController controller) {
    mapcontroller = controller;
  }

  Future<void> _goToTheLake() async {
    final GoogleMapController controller = await _controller.future;
    await controller.animateCamera(CameraUpdate.newCameraPosition(_kLake));
  }
}
