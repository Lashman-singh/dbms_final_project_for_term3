<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>CRUD Website</title>
    <link rel="stylesheet" href="styles.css">
</head>
<body>
    <div class="container">
        <h1>Lashman's Playlist</h1>
        <table>
            <tr>
                <th>Songs</th>
                <th>Song Title</th>
                <th>Album ID</th>
                <th>Action</th>
            </tr>
            <?php
            include 'connect.php';
            $stmt = $db->query('SELECT * FROM song');
            $counter = 1;
            while ($row = $stmt->fetch(PDO::FETCH_ASSOC)) {
                echo "<tr><td>".$counter."</td><td>".$row['Song_Title']."</td><td>".$row['Album_ID']."</td>";
                echo "<td><a href='update.php?id=".$row['Song_ID']."'>Update</a> | <a href='delete.php?id=".$row['Song_ID']."'>Delete</a></td></tr>";
                $counter++;
            }
            ?>
        </table>
        <br>
        <a href="create.php">Add New Song</a>
    </div>
</body>
</html>
