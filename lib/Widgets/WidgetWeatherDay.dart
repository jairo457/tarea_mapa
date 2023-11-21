import 'package:flutter/material.dart';
import 'package:tarea_mapa/Model/WeatherModel.dart';
import 'package:intl/intl.dart';

Widget WidgetWeatherDay(
    WeatherModel clime, context, Color mycolor, Color mycolot) {
  return GestureDetector(
    onTap: () {
      showDialog(
          context: context,
          builder: (context) {
            return AlertDialog(
              backgroundColor: mycolot,
              content: IntrinsicHeight(
                child: Column(
                  children: [
                    Image.asset('assets/' + clime.icon.toString() + '.png'),
                    Center(
                        child: Text('Estado: ' + clime.description.toString(),
                            textAlign: TextAlign.center)),
                    Center(
                        child: Text('Temperatura: ' + clime.temp.toString(),
                            textAlign: TextAlign.center)),
                    Center(
                        child: Text(
                            'Temperatura Maxima: ' + clime.temp_max.toString(),
                            textAlign: TextAlign.center)),
                    Center(
                        child: Text(
                            'Temperatura Minima: ' + clime.temp_min.toString(),
                            textAlign: TextAlign.center)),
                    Center(
                        child: Text('Humedad: ' + clime.humidity.toString(),
                            textAlign: TextAlign.center)),
                  ],
                ),
              ),
            );
          });
    },
    //Mandamos el contexto, la pantalla y un arguemnto, la pelicula
    child: Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        color: mycolor,
      ),
      height: 50,
      width: 115, // Image radius
      child: ListView(children: [
        Image.asset(
          'assets/' + clime.icon.toString() + '.png',
          width: 10,
        ),
        Center(
            child: Text(DateFormat('EEEE')
                .format(DateTime.parse(clime.dat!))
                .toString())),
      ]),
    ),
  );
}
