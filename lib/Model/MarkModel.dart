class MarkModel {
  String? lat;
  String? long;
  String? Name;
  int? Id;

  MarkModel({
    this.lat,
    this.long,
    this.Name,
    this.Id,
  });

  factory MarkModel.fromMap(Map<String, dynamic> map) {
    return MarkModel(
      lat: map['lat'] ?? '',

      //cualense ??, si es nulo lo de la izquierda
      //asigna lo de la derecha
      long: map['long'],
      Name: map['Name'] ?? '',
      Id: map['Id'],
    );
  }
}
