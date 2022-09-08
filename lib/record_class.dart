// A class defining the attributes of the object being used to parse each record
class Record {
  // Declaring expected attributes locally
  String id;
  String country;
  String capital;

  // Constructor declaration
  Record({required this.id, required this.country, required this.capital});

  // Factory constructor that can be called to return an instance of the class
  // Designed to parse json data being fed from the server api
  factory Record.fromJson(Map<String, dynamic> json) {
    return Record(
      id: json['id'] as String,
      country: json['country'] as String,
      capital: json['capital'] as String,
    );
  }
}
