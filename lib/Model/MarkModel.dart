class MarkModel {
  String? lat;
  String? long;

  MarkModel({
    this.lat,
    this.long,
  });

  factory MarkModel.fromMap(Map<String, dynamic> map) {
    return MarkModel(
      lat: map['lat'] ?? '',
      //cualense ??, si es nulo lo de la izquierda
      //asigna lo de la derecha
      long: map['long'],
    );
  }
}
