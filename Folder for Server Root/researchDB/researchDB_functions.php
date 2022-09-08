<?php
// php script to be placed in server web root
// MySQL database running on server required with name "research_db"
// API configured by default to run with a local server such as AMPSS for testing

$servername = "localhost"; // local server
$username = "root"; // default config for AMPSS phpMyAdmin
$password = "mysql"; // default config for AMPSS phpMyAdmin
$dbname = "research_db"; // required db name
$table = "test_data"; // table in db created if not present

// Listening for an action command from the application
$action = $_POST["action"]; // Stores the request details in an array

// Create SQL Connection
$conn = new mysqli($servername, $username, $password, $dbname);

// Verify connection and return if failed
if ($conn->connect_error) {
    die("Connection Failed: " . $conn->connect_error);
    return;
}

// Switch that executes commands depending on what action the app requests
switch ($action) {
    // Create the table using an sql query if it doesn't exist already
    case "CREATE_TABLE": // Start case
        // Config for test database columns 
        $sql = "CREATE TABLE IF NOT EXISTS $table ( 
                id INT(6) UNSIGNED AUTO_INCREMENT PRIMARY KEY,
                country VARCHAR(40) NOT NULL,
                capital VARCHAR(40) NOT NULL
                )"; // sql query
        // If the query worked
        if ($conn->query($sql) === TRUE) {
            // Return a success message
            echo "success";
        } else {
            // Return error notification
            echo "error";
        }
        $conn->close(); // Close the connection
        return; // End case

    // Fetch all records from the table
    case "GET_ALL":
        $db_data = array();
        $sql = "SELECT id, country, capital from $table ORDER BY id DESC";// sql query
        $result = $conn->query($sql);
        // Checks whether any rows have been returned by the db
        if ($result->num_rows > 0) {
            while ($row = $result->fetch_assoc()) {
                $db_data[] = $row;
            }            
            echo json_encode($db_data); // Returns the records as json data
        } else {
            echo "error, no records";
        }
        $conn->close();
        return;
    
    // Add new record
    case "ADD_RECORD":
        // App will be posting these values to this server
        $country = $_POST["country"];
        $capital = $_POST["capital"];
        $sql = "INSERT INTO $table (country, capital) VALUES ('$country', '$capital')";// sql query
        $result = $conn->query($sql);
        echo "success";
        $conn->close();
        return;

    // Update existing record, corresponding to given id
    case "UPDATE_RECORD":
        // App will be posting these values to this server
        $record_id = $_POST['record_id'];
        $country = $_POST["country"];
        $capital = $_POST["capital"];
        $sql = "UPDATE $table SET country = '$country', capital = '$capital' WHERE id = $record_id";// sql query

        if ($conn->query($sql) === TRUE) {
            echo "success";
        } else {
            echo "error";
        }
        $conn->close();
        return;

    // Delete existing records, corresponding to given id
    case "DELETE_RECORD":
        $record_id = $_POST['record_id'];
        $sql = "DELETE FROM $table WHERE id = $record_id"; // sql query
        if ($conn->query($sql) === TRUE) {
            echo "success";
        } else {
            echo "error";
        }
        $conn->close();
        return;
}