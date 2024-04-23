<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Add Song</title>
    <link rel="stylesheet" href="styles.css">
</head>
<body>
    <div class="container">
        <h1>Add Song</h1>
        <form action="insert.php" method="POST">
            <label for="song_title">Song Title:</label>
            <input type="text" id="song_title" name="song_title" required><br><br>
            <label for="album_id">Album ID:</label>
            <input type="text" id="album_id" name="album_id" required><br><br>
            <input type="submit" value="Add Song">
        </form>
    </div>
</body>
</html>
