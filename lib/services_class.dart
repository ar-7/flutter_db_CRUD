// Importing packages
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'record_class.dart';

// This class defines the services called by the UI class
class Services {
  static var root = Uri.parse(
      'http://localhost/researchDB/researchDB_functions.php'); // Defining the server location of the db API script

  // Define variables for the commands being sent to the api
  static const createTableAction = 'CREATE_TABLE';
  static const getAllAction = 'GET_ALL';
  static const addRecordAction = 'ADD_RECORD';
  static const updateRecordAction = 'UPDATE_RECORD';
  static const deleteRecordAction = 'DELETE_RECORD';

  // Function that instructs the db to create the table via the api
  static Future<String> createTable() async {
    try {
      // Passing parameters to the api
      var map = <String, dynamic>{};
      map['action'] = createTableAction; // define the command in an array
      final response =
          await http.post(root, body: map); // post the commands to the api
      print('Create Table Response: ${response.body}'); // debug response
      // If the response status code is 200
      if (200 == response.statusCode) {
        return response.body; // returns confirmation
      } else {
        return "error"; // returns error
      }
    } catch (e) {
      return "error"; // catch errors with response
    }
  }

  // Function that calls the records from the db
  static Future<List<Record>> getRecords() async {
    try {
      var map = <String, dynamic>{};
      map['action'] = getAllAction; // define the command in an array
      final response = await http.post(root, body: map);
      print(
          'getRecords Response: ${response.body} code: ${response.statusCode}'); // debug response
      // If the response status code is 200
      if (response.statusCode == 200) {
        List<Record> list = parseResponse(
            response.body); // Parses the response into a list of records
        return list; // returns the list to the calling class
      } else {
        print('Returning empty'); // debug response
        return <Record>[]; //
      }
    } catch (e) {
      return <Record>[]; // returns a blank list on error
    }
  }

  static List<Record> parseResponse(String responseBody) {
    final parsed = json.decode(responseBody).cast<Map<String, dynamic>>();
    return parsed.map<Record>((json) => Record.fromJson(json)).toList();
  }

  // Method to add record to the database...
  static Future<String> addRecord(String country, String capital) async {
    try {
      var map = <String, dynamic>{};
      map['action'] = addRecordAction; // define the command in an array
      map['country'] = country; // append to the array
      map['capital'] = capital; // append to the array
      final response =
          await http.post(root, body: map); // post the command to the api
      print('addRecord Response: ${response.body}'); // debug response
      // If the response status code is 200
      if (200 == response.statusCode) {
        return response.body; // returns confirmation
      } else {
        return "error"; // returns error
      }
    } catch (e) {
      return "error"; // catch errors with response
    }
  }

  // Method to update an Record in Database...
  static Future<String> updateRecord(
      String id, String country, String capital) async {
    try {
      var map = <String, dynamic>{};
      map['action'] = updateRecordAction; // define the command in an array
      map['record_id'] = id; // append to the array
      map['country'] = country;
      map['capital'] = capital;
      final response =
          await http.post(root, body: map); // post the command to the api
      print('updateRecord Response: ${response.body}');
      // If the response status code is 200
      if (200 == response.statusCode) {
        return response.body; // returns confirmation
      } else {
        return "error"; // returns error
      }
    } catch (e) {
      return "error"; // catch errors with response
    }
  }

  // Method to Delete an Record from Database...
  static Future<String> deleteRecord(String id) async {
    try {
      var map = <String, dynamic>{};
      map['action'] = deleteRecordAction; // define the command in an array
      map['record_id'] = id; // append to the array
      final response =
          await http.post(root, body: map); // post the command to the api
      print('deleteRecord Response: ${response.body}');
      // If the response status code is 200
      if (200 == response.statusCode) {
        return response.body; // returns confirmation
      } else {
        return "error"; // returns error
      }
    } catch (e) {
      return "error"; // catch errors with response
    }
  }
}
