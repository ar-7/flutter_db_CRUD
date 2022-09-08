# flutter_db_access_application

An application made in Flutter as part of a project comparing Flutter to older frameworks.

The application provides Create, Read, Update and Delete functionality with a MySQL database.

Connects to a locally hosted MySQL database via the php API located in "Folder for Server Root" the "researchDB" folder should be placed in the localhost server root.

The MySQL database is called “research_db” with a single table inside named “test_data.”

The following SQL query contains the configuration for the table:

CREATE TABLE `test_data` (
`id` int UNSIGNED NOT NULL,
`country` varchar(40) COLLATE utf8mb4_general_ci NOT NULL,
`capital` varchar(40) COLLATE utf8mb4_general_ci NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

With localhost running the MySQL database and the API in the correct location, the application will be able to interface with the database.