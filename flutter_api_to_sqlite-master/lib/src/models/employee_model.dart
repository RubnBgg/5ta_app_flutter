import 'dart:convert';

List<Employee> employeeFromJson(String str) =>
    List<Employee>.from(json.decode(str).map((x) => Employee.fromJson(x)));

String employeeToJson(List<Employee> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class Employee {
  String pelicula;
  String director;
  String genero;
  String foto;
  int duracion;
  int ganancias;

  Employee({
    this.pelicula,
    this.director,
    this.genero,
    this.duracion,
    this.ganancias,
    this.foto,
  });

  factory Employee.fromJson(Map<String, dynamic> json) => Employee(
      pelicula: json["pelicula"],
      director: json["director"],
      genero: json["genero"],
      duracion: json["duracion"],
      ganancias: json["ganancias"],
      foto: json["foto"]);

  Map<String, dynamic> toJson() => {
        "pelicula": pelicula,
        "director": director,
        "genero": genero,
        "duracion": duracion,
        "ganancias": ganancias,
        "foto": foto,
      };
}
