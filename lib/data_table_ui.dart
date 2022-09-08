// Importing packages
import 'package:flutter/material.dart';
import 'record_class.dart';
import 'services_class.dart';

// This class defines the main UI widget called for the app
class DataTableUI extends StatefulWidget {
  const DataTableUI({Key? key}) : super(key: key); // Create unique key

  final String title =
      'Flutter Research App'; // Title for the material title bar

  // Create instance of the content class
  @override
  DataTableUIState createState() => DataTableUIState();
}

// Content class for the UI
class DataTableUIState extends State<DataTableUI> {
  // Declaring variables
  late List<Record> _records; // List for storing the records for the datatable
  late GlobalKey<ScaffoldState> _scaffoldKey; // Key for the scaffold
  late TextEditingController
      _countryTextboxController; // Controller for the textbox input
  late TextEditingController
      _capitalTextboxController; // Controller for the textbox input
  late Record _selectedRecord = _records[
      0]; // giving the selection var an initial value because null is not acceptable
  late bool
      _isUpdating; // Boolean switch that saves the state of the users action
  late String
      titleMessage; // String for updating progress messages in the title bar
  bool ascending = true; // var for the column sort direction

  @override
  void initState() {
    super.initState();
    _records = []; // Initialise the records list
    _isUpdating = false; // set the initial state of the UI
    titleMessage = widget.title; // Set the initial title bar text
    _scaffoldKey = GlobalKey(); // key to get the context to show a SnackBar
    _countryTextboxController =
        TextEditingController(); // Apply the text editing controller
    _capitalTextboxController = TextEditingController();
    _getRecords(); // Call the db to populate the records
  }

  // UI function that posts messages to the title bar
  _progressMessage(String message) {
    setState(() {
      titleMessage = message;
    });
  }

  // UI function that displays messages to the user in a snackbar
  _showSnackBar(context, message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
      ),
    );
  }

  // Function that takes input from the textboxes and validates it is not empty before sending it to the db
  _addRecord() {
    // Validate
    if (_countryTextboxController.text.isEmpty ||
        _capitalTextboxController.text.isEmpty) {
      _showSnackBar(context, 'Empty Fields');
      return;
    }
    _progressMessage('Adding Record...'); // Report to user

    // Call the function from the Services class
    Services.addRecord(
            _countryTextboxController.text, _capitalTextboxController.text)
        .then((result) {
      if ('success' == result) {
        _getRecords(); // Refreshes the list
        _clearValues(); // Clears the input boxes
      }
    });
  }

  // Function that calls refreshes the list of records
  _getRecords() {
    if (_records.isEmpty) {
      _createTable();
    }
    _progressMessage('Loading Records...');
    Services.getRecords().then((records) {
      setState(() {
        // Loads the local list of records into the global var
        _records = records.reversed
            .toList(); // The list loads in backwards, .reversed fixes this
      });
      _progressMessage(widget.title); // Restore the title
      print("UI reporting table length at: ${records.length}");
    });
  }

  // Function that instructs the db to construct the table if it doesn't exist
  _createTable() {
    _progressMessage('Creating Table...');
    Services.createTable().then((result) {
      if ('success' == result) {
        // Table is created successfully.
        _showSnackBar(context, 'Loaded Successfully');
        _progressMessage(widget.title);
      }
    });
  }

  // Function that sends an update record to the db
  _updateRecord(Record record) {
    // Sets the UI state
    setState(() {
      _isUpdating = true;
    });

    _progressMessage('Updating Record...'); // Reports the the user
    // Calls the function from the Services class
    Services.updateRecord(record.id, _countryTextboxController.text,
            _capitalTextboxController.text)
        .then((result) {
      if ('success' == result) {
        _getRecords(); // Refresh the list after update
        // Reset the UI state
        setState(() {
          _isUpdating = false;
        });
        _clearValues(); // Clears the input boxes
      }
    });
  }

  // Function that deletes a selected record from the db
  _deleteRecord(Record record) {
    _progressMessage('Deleting Record...');
    Services.deleteRecord(record.id).then((result) {
      if ('success' == result) {
        _getRecords(); // Refresh table after deleting
      }
    });
  }

  // Method to clear TextField values
  _clearValues() {
    _countryTextboxController.text = '';
    _capitalTextboxController.text = '';
    // Ensures the state is reset
    setState(() {
      _isUpdating = false;
    });
  }

  // Function that sets the textboxes to the values from a selected record to allow editing
  _showValues(Record record) {
    _countryTextboxController.text = record.country;
    _capitalTextboxController.text = record.capital;
  }

  // Column sort function for the datatable
  onSortColum(int columnIndex, bool ascending) {
    if (columnIndex == 0) {
      if (ascending) {
        _records.sort((a, b) => a.id.compareTo(b.id));
      } else {
        _records.sort((a, b) => b.id.compareTo(a.id));
      }
    }
  }

  // Constructing a datatable to contain the table fields in
  SingleChildScrollView _dataBody() {
    // Scroll views for vertical and horizontal scrolling
    return SingleChildScrollView(
      scrollDirection: Axis.vertical,
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: DataTable(
          sortColumnIndex: 0, // enable sortable column
          sortAscending: ascending, // default value for the sorting switch
          // Start datatable layout
          columns: [
            DataColumn(
              label: const Text('ID'),
              onSort: (columnIndex, ascending) {
                setState(() {
                  this.ascending = ascending;
                });
                onSortColum(columnIndex, ascending);
              },
            ),
            const DataColumn(
              label: Text('Country'),
            ),
            const DataColumn(
              label: Text('Capital'),
            ),
            const DataColumn(
              // Delete button column
              label: Text('Delete'),
            )
          ],
          // Mapping data to the cells
          rows: _records
              .map(
                (record) => DataRow(
                  cells: [
                    DataCell(
                      Text(record.id),
                      // populates the text boxes when the fields are selected
                      onTap: () {
                        _showValues(record);
                        _selectedRecord = record; // Set the selected record
                        // Update state
                        setState(() {
                          _isUpdating = true;
                        });
                      },
                    ),
                    DataCell(
                      Text(
                        record.country,
                      ),
                      onTap: () {
                        _showValues(record);
                        _selectedRecord = record;
                        setState(() {
                          _isUpdating = true;
                        });
                      },
                    ),
                    DataCell(
                      Text(
                        record.capital,
                      ),
                      onTap: () {
                        _showValues(record);
                        _selectedRecord = record;
                        setState(() {
                          _isUpdating = true;
                        });
                      },
                    ),
                    // Delete button object
                    DataCell(IconButton(
                      icon: const Icon(Icons.delete),
                      onPressed: () {
                        _deleteRecord(record);
                        _clearValues();
                      },
                    ))
                  ],
                  selected:
                      _selectedRecord == record, // Highlight selected record
                ),
              )
              .toList(),
        ),
      ),
    );
  }

  // Build for the UI
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey, // referencing the unique key
      appBar: AppBar(
        title: Text(titleMessage), // Content of the title bar
        // Define widget for the refresh button
        actions: <Widget>[
          TextButton(
              style: TextButton.styleFrom(primary: Colors.white),
              onPressed: () {
                _getRecords();
              },
              child: const Text('Refresh Records')),
        ],
      ),
      // Define column for the text entries
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.all(20.0),
            child: TextField(
              controller: _countryTextboxController,
              decoration: const InputDecoration.collapsed(
                hintText: 'Input Country Name',
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(20.0),
            child: TextField(
              controller: _capitalTextboxController,
              decoration: const InputDecoration.collapsed(
                hintText: 'Input Capital Name',
              ),
            ),
          ),
          // Buttons for adding, updating and deleting
          // Display changes depending on the app UI state
          !_isUpdating // When not updating a record
              ? Row(
                  children: <Widget>[
                    OutlinedButton(
                      child: const Text('Add New Record'),
                      onPressed: () {
                        _addRecord();
                      },
                    ),
                  ],
                )
              : Container(),
          _isUpdating // When updating a record
              ? Row(
                  children: <Widget>[
                    OutlinedButton(
                      child: const Text('Update'),
                      onPressed: () {
                        _updateRecord(_selectedRecord);
                      },
                    ),
                    OutlinedButton(
                      child: const Text('Clear'),
                      onPressed: () {
                        setState(() {
                          _isUpdating = false;
                        });
                        _clearValues();
                      },
                    ),
                  ],
                )
              : Container(),
          Expanded(
            child: _dataBody(),
          ),
        ],
      ),
    );
  }
}
