import 'dart:ffi';

import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:tarea_mapa/Model/MarkModel.dart';
import 'package:tarea_mapa/database/Masterdb.dart';
import 'package:tarea_mapa/utils/global_values.dart';

class CardLocateWidget extends StatelessWidget {
  CardLocateWidget(
      {super.key,
      required this.markModel,
      this.masterDB,
      this.control}); //Las {} indican que los parametros son nombrado

  MarkModel markModel;
  MasterDB? masterDB;
  GoogleMapController? control;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(top: 10),
      padding: EdgeInsets.all(10),
      decoration: const BoxDecoration(
        border: Border(
          top:
              BorderSide(width: 1.5, color: Color.fromARGB(255, 114, 177, 255)),
          bottom:
              BorderSide(width: 1.5, color: Color.fromARGB(255, 114, 177, 255)),
        ),
      ),
      child: Row(
        children: [
          Column(
            children: [
              Text(markModel!.Name.toString().length > 15
                  ? markModel!.Name.toString().substring(0, 15)
                  : markModel!.Name.toString())
            ],
          ),
          Expanded(child: Container()), //Se expande lo mas que puede
          Row(
            children: [
              IconButton(
                icon: Icon(
                  Icons.location_searching,
                  size: MediaQuery.of(context).size.width / 12,
                ),
                onPressed: () {
                  control!.moveCamera(CameraUpdate.newLatLng(LatLng(
                      double.tryParse(markModel.lat!)!,
                      double.tryParse(markModel.long!)!)));
                },
              ),
              IconButton(
                  onPressed: () {
                    showDialog(
                      context: context,
                      builder: (context) {
                        return AlertDialog(
                          title: Text('Mensaje del sistema'),
                          content: Text('¿Dese borrar la ubicacion?'),
                          actions: [
                            TextButton(
                                onPressed: () async {
                                  int cant = await masterDB!
                                      .DELETE_Mark('tblMark', markModel!.Id!);
                                  //print(cant.toString());
                                  GlobalValues.flagLocate.value =
                                      !GlobalValues.flagLocate.value;
                                },
                                child: Text('Si')),
                            TextButton(
                                onPressed: () => Navigator.pop(context),
                                child: Text('No'))
                          ],
                        );
                      },
                    );
                  },
                  icon: Icon(
                    Icons.delete,
                    size: MediaQuery.of(context).size.width / 12,
                  )),
            ],
          ),
        ],
      ),
    );
  }
}
