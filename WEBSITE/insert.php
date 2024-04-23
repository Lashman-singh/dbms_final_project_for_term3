<?php
include 'connect.php';

if ($_SERVER["REQUEST_METHOD"] == "POST") {
    $song_title = $_POST['song_title'];
    $album_id = $_POST['album_id'];

    $stmt = $db->prepare("INSERT INTO song (Song_Title, Album_ID) VALUES (:song_title, :album_id)");
    $stmt->bindParam(':song_title', $song_title);
    $stmt->bindParam(':album_id', $album_id);
    
    if ($stmt->execute()) {
        header("Location: index.php");
        exit();
    } else {
        echo "Error adding song.";
    }
}
?>
