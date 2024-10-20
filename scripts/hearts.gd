extends Node2D

# Function to remove the last heart
func remove_heart():
	if get_child_count() > 0:  # Check if there are any children
		var last_heart = get_child(0)  # Get the last heart node
		last_heart.queue_free()  # Remove the heart from the scene
