import 'dart:async';
import 'dart:ffi';
import 'dart:typed_data';
import 'package:intl/intl.dart';
import 'package:circular_menu/circular_menu.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:tarea_mapa/Model/MarkModel.dart';
import 'package:tarea_mapa/database/Masterdb.dart';
import 'package:tarea_mapa/utils/Ubicacion.dart';
import 'package:tarea_mapa/utils/utils.dart';

class MapScreen extends StatefulWidget {
  const MapScreen({super.key});

  @override
  State<MapScreen> createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {
  final Completer<GoogleMapController> _controller =
      Completer<GoogleMapController>();
  List<Marker> myMarker = [];
  List<MarkModel>? list1;
  Ubicacion ubi = Ubicacion();
  late GoogleMapController mapcontroller;
  BitmapDescriptor myIcon = BitmapDescriptor.defaultMarker;
  MasterDB? masterDB;
  bool cambio = false;
  bool borra = false;
  TextEditingController TxtGenericName = TextEditingController();

  @override
  void initState() {
    masterDB = MasterDB();
    super.initState();
    marca();
    Lista();
  }

  Lista() async {
    list1 = await masterDB!.GETALL_Mark();
    for (MarkModel ma in list1!) {
      myMarker.add(Marker(
          icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueBlue),
          markerId: MarkerId(ma.lat.toString()),
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
    final txtGenericName = TextFormField(
      decoration: const InputDecoration(
          label: Text('Nombre'), border: OutlineInputBorder()),
      controller: TxtGenericName,
    );

    final circularMenu = CircularMenu(
        alignment: Alignment.centerRight,
        toggleButtonColor: Colors.amber,
        items: [
          CircularMenuItem(
              icon: Icons.device_thermostat,
              onTap: () {
                Navigator.pushNamed(context, '/home');
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
              icon: Icons.my_location,
              onTap: () async {
                Position nu;
                nu = await ubi.GetCurrentposition();
                //print(nu.latitude.toString());
                mapcontroller.moveCamera(
                    CameraUpdate.newLatLng(LatLng(nu.latitude, nu.longitude)));
                _kGooglePlex = CameraPosition(
                  target: LatLng(nu.latitude, nu.longitude),
                  zoom: 14.4746,
                );
              }),
        ]);

    return Scaffold(
      body: Stack(children: [
        GoogleMap(
          markers: Set.from(myMarker),
          mapType: MapType.hybrid,
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
      ]),
    );
  }

  _handle_tap(LatLng tappedPoint) {
    if (borra) {
      myMarker.removeLast();
      borra = true;
    }
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
                        TextField(),
                        TextButton(
                            onPressed: () {
                              masterDB!.INSERT_Mark('tblMark', {
                                'lat': tappedPoint.latitude.toString(),
                                'long': tappedPoint.longitude.toString(),
                                'Name': TxtGenericName.text,
                              }).then((value) => Navigator.pop(context));
                            },
                            child: Text('Agregar'))
                      ],
                    ),
                  ),
                );
              });
        }));
    print('Markers: ' +
        myMarker.length.toString() +
        '---------' +
        borra.toString());
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
