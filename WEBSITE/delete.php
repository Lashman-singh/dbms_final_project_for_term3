<?php
include 'connect.php';

// Check if song ID is provided
if ($_SERVER["REQUEST_METHOD"] == "GET" && isset($_GET['id'])) {
    $id = $_GET['id'];

    // Prepare and execute the deletion query
    $stmt = $db->prepare("DELETE FROM song WHERE Song_ID = :id");
    $stmt->bindParam(':id', $id);
    
    // Check if deletion was successful
    if ($stmt->execute()) {
        header("Location: index.php");
        exit();
    } else {
        echo "Error deleting song.";
    }
} else {
    echo "No song ID provided.";
}
?>
