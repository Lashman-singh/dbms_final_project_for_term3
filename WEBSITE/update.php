<?php
include 'connect.php';

if ($_SERVER["REQUEST_METHOD"] == "GET" && isset($_GET['id'])) {
    $id = $_GET['id'];

    $stmt = $db->prepare("SELECT * FROM song WHERE Song_ID = :id");
    $stmt->bindParam(':id', $id);
    $stmt->execute();
    $song = $stmt->fetch(PDO::FETCH_ASSOC);

    if (!$song) {
        echo "Song not found.";
        exit();
    }
}

if ($_SERVER["REQUEST_METHOD"] == "POST") {
    $song_title = $_POST['song_title'];
    $album_id = $_POST['album_id'];
    $id = $_POST['id'];

    $stmt = $db->prepare("UPDATE song SET Song_Title = :song_title, Album_ID = :album_id WHERE Song_ID = :id");
    $stmt->bindParam(':song_title', $song_title);
    $stmt->bindParam(':album_id', $album_id);
    $stmt->bindParam(':id', $id);
    
    if ($stmt->execute()) {
        header("Location: index.php");
        exit();
    } else {
        echo "Error updating song.";
    }
}
?>

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Update Song</title>
    <link rel="stylesheet" href="styles.css">
</head>
<body>
    <div class="container">
        <h1>Update Song</h1>
        <form action="update.php" method="POST">
            <input type="hidden" name="id" value="<?php echo $song['Song_ID']; ?>">
            <label for="song_title">Song Title:</label>
            <input type="text" id="song_title" name="song_title" value="<?php echo $song['Song_Title']; ?>" required><br><br>
            <label for="album_id">Album ID:</label>
            <input type="text" id="album_id" name="album_id" value="<?php echo $song['Album_ID']; ?>" required><br><br>
            <input type="submit" value="Update Song">
        </form>
    </div>
</body>
</html>
