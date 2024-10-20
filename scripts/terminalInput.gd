
extends Node2D

@onready var line_edit: LineEdit = $LineEdit
@onready var label: Label = $Label
@export var file_scene: PackedScene  # Reference to the File scene
@onready var main_character: Node2D = $MainCharacter  # Reference to your character
@export var text_editor_scene: PackedScene
@onready var laser_beam = $LaserBeam # Reference to the sprite
@onready var timer = Timer.new()
@onready var hearts_node = $Hearts
@onready var slime_boss = $SlimeBoss
@onready var mini_slime1 = $MiniSlime1
@onready var mini_slime2 = $MiniSlime2
@onready var tipBox: Label = $TipLabel

var text_editor_instance: TextEdit
#var FileSystemScript = load("res://scripts/fileStructure.gd") 
#var current_directory = FileSystemScript.file_system["Root"]  # Start in the root directory
#var path_stack = []  # Stack to keep track of directory history
var FileSystemScript = preload("res://scripts/lvl1FileSystem.gd")
var file_system_instance = FileSystemScript.new()  # Create an instance of the File System script
var current_directory_name: String = "root"  # Start at root
var current_directory = file_system_instance.file_system["Root"]
var sudo_password = file_system_instance.file_system["sudo"] # Access the file system from the instance
var path_stack = []  # Stack to keep track of directory history
var is_sudo_authenticated = false
var attackers = file_system_instance.file_system["attackers"]
var processes = [{"pid": 1, "name": "bashy", "status": "running"}]
var trapped = false
var missleSend = false
var pushed = false
var gitChanged = []
var staged_files = []
var commited = false
var misslecode = ""
var slimeHearts = 3
var tooltip = file_system_instance.file_system["Root"]["textInfo"]
func _ready():
	line_edit.text_submitted.connect(_on_LineEdit_text_entered)
	add_child(timer)
	timer.wait_time = 2.0 # Wait for 2 seconds
	mini_slime1.hide()
	mini_slime2.hide()
	tipBox.text = tooltip
	#timer.connect("timeout", self, "_on_Timer_timeout")

var holder = ""
func _on_LineEdit_text_entered(new_text: String):
	var command = new_text.strip_edges().to_lower()
	if label.text == "Enter sudo password:":
		if new_text == sudo_password:
			is_sudo_authenticated = true  # Mark as authenticated for sudo
			label.text = "Sudo authenticated."
			command = holder
			return
		else:
			label.text = "Incorrect password."
			return
		#return  # Don't process the command yet, just handle password
	label.text = ""
	#label.text = new_text  # Update the label with the submitted text
	  # Normalize the input
	if command.begins_with("sudo "):
		if not is_sudo_authenticated:
			# Prompt for password if not authenticated
			label.text = "Enter sudo password:"
			holder = new_text.substr(5).strip_edges()
			return
		# Remove 'sudo ' prefix and process the remaining command
		new_text = new_text.substr(5).strip_edges()
		command = new_text.to_lower()
	
	# Check if the input is "ls"
	if command == "ls":
		label.text = await(display_files_and_directories(current_directory))
	elif command == "git status":
		label.text = seeGitStatus() + "\n" + seeStagedFiles()
	elif command.begins_with("git add "):
		var file_name = new_text.substr(8).strip_edges()  # Extract the file name after "git add "
		label.text = git_add(file_name)
	elif command == "git commit":
		commited = true
		label.text = "commited files"
	elif command == "git push":
		for file_name in staged_files:
			staged_files.erase(file_name)
		pushed = true
		label.text = "pushed files"
		
	elif command == "ls -l":
		display_files_and_directories(current_directory)
		display_detailed_file_info(current_directory)
	elif command.begins_with("cd "):
		var dir_name = new_text.substr(3).strip_edges()
		var toChange = change_directory(dir_name)
		label.text = toChange
	elif new_text.begins_with("cat "):
		var file_name = new_text.substr(4).strip_edges()
		label.text = read_file_content(file_name) 
	elif new_text.begins_with("chmod "):
		if not is_sudo_authenticated:
			label.text = "Permission denied. Try 'sudo chmod'."
		else:
			var result = change_permissions(new_text.substr(6).strip_edges())
			label.text = result
	elif new_text.begins_with("run "):
		if trapped:
			label.text = "Kill Bad Processes First"
		var file_name = new_text.substr(4).strip_edges()
		label.text = await(execute_file(file_name))
	elif command == "ps":
		display_processes()  # Call function to display processes
	elif new_text.begins_with("kill -9 "):
		var pid_str = new_text.substr(8).strip_edges()  # Extract PID from the command
		if pid_str.is_valid_int():  # Ensure it's a valid integer
			var pid = int(pid_str)
			label.text = await(kill_process(pid))  # Kill the process and display the result
		else:
			label.text = "Invalid PID. Please provide a valid process ID."
	elif new_text.begins_with("echo "):
		var parts = new_text.split(" > ")
		if parts.size() == 2:
			var text_to_write = parts[0].substr(5).strip_edges()  # Extract text after "echo "
			var file_name = parts[1].strip_edges()  # Get the file name
			var result = write_to_file(file_name, text_to_write)  # Call the write function
			label.text = result  # Display the result in the label
		else:
			label.text = "Invalid syntax. Use: echo \"text\" > filename"
	elif command == "man":
		label.text = "ls : see the files in the current directory \n" +  \
		"cd <directory_name>: enter into the specified directory \n" + \
		"cat <file_name>: display the text contents of a file \n" + \
		"chmod [+,-][r,w,x] <file_name: select one from each to add or remove permissions to specified file \n" + \
		"echo <text> > <file_name>: inserts text into specified file \n" + \
		"run <file_name>: executes a file \n"  + \
		"kill -9 <pid>: Terminates a process with given pid \n" + \
		"ps: shows active running processes" + \
		"git help: shows how to use git"
	elif command == "git help":
		label.text = "git status: shows the changed and staged files \n" + \
		"git add <file_name>: adds file to the staging area + \n" + \
		"git commit: creates a snapshot of staged files to be pushed \n" + \
		"git push: uploads local repository to remote repository"
	else:
		label.text = "Command not found"  # Handle case where directory doesn't exist
  # Optional: Update label for unrecognized commands

	line_edit.clear()  # Clear the LineEdit after submission

func seeStagedFiles() -> String:
	if staged_files.size() == 0:
		return "No files staged."
	else:
		var status = "Staged files:\n"
		for file_name in staged_files:
			status += file_name + "\n"  # Add each staged file to the status string
		return status
		
func git_add(file_name: String) -> String:
	if file_name in gitChanged:
		if file_name not in staged_files:
			staged_files.append(file_name)  # Add to staged list
			gitChanged.erase(file_name)
			return "File '" + file_name + "' added to staging area."
		else:
			return "File '" + file_name + "' is already staged."
	else:
		return "File '" + file_name + "' does not exist in the changed files."
		
func seeGitStatus() -> String:
	if gitChanged.size() == 0:
		return "No changes."
	else:
		var status = "Changed files:\n"
		for file_name in gitChanged:
			status += file_name + "\n"  # Add each changed file to the status string
		return status
func kill_process(pid: int):
	for process in processes:
		if process["pid"] == pid:
			processes.erase(process)  # Remove the process from the list
			if pid == 1:  # Change this to the PID that should trigger game over
				await get_tree().create_timer(2).timeout
				get_tree().change_scene_to_file("res://scenes/game_over.tscn")  # Load the game over scene
			if processes.size() == 1 and processes[0]["pid"] == 1:
				trapped = false
			if pid == 2:
				mini_slime1.texture = preload("res://art/miniSlimeDmg.png")
				await get_tree().create_timer(2).timeout
				mini_slime1.hide()
			if pid == 3:
				mini_slime2.texture = preload("res://art/miniSlimeDmg.png")
				await get_tree().create_timer(2).timeout
				mini_slime2.hide()
				
			return "Process with PID " + str(pid) + " has been killed."
			
	return "No process found with PID " + str(pid) + "."

func gameWin():
	slime_boss.texture = preload("res://art/slimeKingDeath1.png")
	await get_tree().create_timer(2.5).timeout
	slime_boss.texture = preload("res://art/slimeKingDeath2.png")
	await get_tree().create_timer(2.5).timeout
	slime_boss.texture = preload("res://art/slimeKingDeath3New.png")
	await get_tree().create_timer(2.5).timeout
	get_tree().change_scene_to_file("res://scenes/victory.tscn")
	
func write_to_file(file_name: String, text: String) -> String:
	var current_dir = current_directory  # Get the current directory from your logic
	var directory = current_dir

	# Check if the directory exists
	if directory == null:
		return "Error: Directory does not exist."
	
	# Check if the file already exists in the current directory
	for file in directory["Files"]:
		if file.name == file_name and file["permissions"]["write"]:
	# Update the content of the existing file
			file.content = text  # Update content
			gitChanged.append(file_name)
			return "Text written to %s." % file_name

		# If the file does not exist, return an error message
	return "Error: File %s does not exist or no permission." % file_name
	
func display_processes():
	var process_info = "PID\t  NAME\t\t       STATUS\n"  # Header for display
	for process in processes:
		process_info += str(process["pid"]) + "\t   " + process["name"] + "\t " + process["status"] + "\n"
	label.text = process_info

func display_detailed_file_info(directory: Dictionary):
	var output = ""
	
	# Loop through files in the directory
	for file in directory["Files"]:
		var file_data = file  # Assuming this function retrieves the file's data
		var permissions = get_permission_string(file_data["permissions"])  # Get permissions as a string
		output += "%s %s\n" % [permissions, file_data["name"]]

	label.text = output.strip_edges()  # Display the collected output

# Helper function to format permissions
func get_permission_string(permissions: Dictionary) -> String:
	var permission_string = ""
	if(permissions["read"]):
		permission_string += "r"
	else:
		permission_string += "-"
	if(permissions["write"]):
		permission_string += "w"
	else:
		permission_string += "-"
	if(permissions["execute"]):
		permission_string += "x"
	else:
		permission_string += "-"
	return permission_string
	
func execute_file(file_name: String):
	for file in current_directory["Files"]:
		if file["name"].to_lower() == file_name.to_lower():
			if file["permissions"]["execute"] and file["specialFunction"] == "shoot":
				laser_beam.position = Vector2(1000, 250)

				laser_beam.show()
				slime_boss.texture = preload("res://art/damageSlimeBoss.png")
				await get_tree().create_timer(2).timeout
				slime_boss.texture = preload("res://art/slimeBoss.png")
				laser_beam.hide()
				hearts_node.remove_heart()
				slimeHearts -= 1
				if slimeHearts == 0:
						await(gameWin())
				file["specialFunction"] = "used"
				
				return "FIRED LASER BEAM! HE LOST A HEART!"  # Return the file content if permission is granted
			elif file["permissions"]["execute"] and file["specialFunction"] == "used":
				return "You already used this missle. Find a new one."
			elif file["permissions"]["execute"] and file["specialFunction"] == "old":
				return "This missile is out of date. Try another one"
			elif file["permissions"]["execute"] and file["specialFunction"] == "condSet":
				if file["content"].to_lower() == "slimedie" and pushed:
					missleSend = true
					return "Missle Code confirmed launch the missile"
				else:
					return "Incorrect Missle Code launch denied"
			elif file["permissions"]["execute"] and file["specialFunction"] == "condLaunch":
				if missleSend:
					laser_beam.position = Vector2(1000, 250)
					laser_beam.show()
					slime_boss.texture = preload("res://art/damageSlimeBoss.png")
					await get_tree().create_timer(2).timeout
					slime_boss.texture = preload("res://art/slimeBoss.png")
					laser_beam.hide()
					hearts_node.remove_heart()
					slimeHearts -= 1
					if slimeHearts == 0:
						gameWin()
					file["specialFunction"] = "used"
					return "Missle Code Launched Slime Hit"
				else:
					return "Incorrect Missle Code launch denied"
			elif file["permissions"]["execute"] and file["specialFunction"] == "trap":
					file["specialFunction"] = "shoot"
					processes.append_array(attackers)
					mini_slime1.show()
					mini_slime2.show()
					trapped = true
					return "Uh Oh. You opened something you shouldn't have. You are being attacked by viruses. Clear them out ASAP."
			else:
				return "Permission denied: Cannot execute this file."  # Permission error
	return "File not found."  # File does not exist

func _on_Timer_timeout():
	laser_beam.hide() # Hide the sprite when the timer times out
	
	
	
func read_file_content(file_name: String):
	for file in current_directory["Files"]:
		if file["name"].to_lower() == file_name.to_lower():
			if file["permissions"]["read"]:
				return file["content"]  # Return the file content if permission is granted
			else:
				return "Permission denied: Cannot read this file."  # Permission error
	return "File not found."  # File does not exist
	
func change_permissions(permission_string: String) -> String:
	var parts = permission_string.split(" ")
	if parts.size() != 2:
		return "Usage: chmod <permissions> <filename>"

	var permission_str = parts[0]
	var file_name = parts[1]

	for file in current_directory["Files"]:
		if file["name"].to_lower() == file_name.to_lower():
			for char in permission_str:
				if char == 'r':
					if '+' in permission_str:
						file["permissions"]["read"] = true
					elif '-' in permission_str:
						file["permissions"]["read"] = false
					elif '=' in permission_str:
						file["permissions"]["read"] = true
					else:
						return "include +,-, or ="
					return "Permissions updated for " + file_name # Set read permission to true if '=' is used
				elif char == 'w':
					if '+' in permission_str:
						file["permissions"]["write"] = true
					elif '-' in permission_str:
						file["permissions"]["write"] = false
					elif '=' in permission_str:
						file["permissions"]["write"] = true
					else:
						return "include +,-, or ="
					return "Permissions updated for " + file_name
				elif char == 'x':
					if '+' in permission_str:
						file["permissions"]["execute"] = true
					elif '-' in permission_str:
						file["permissions"]["execute"] = false
					elif '=' in permission_str:
						file["permissions"]["execute"] = true
					else:
						return "include +,-, or ="
					return "Permissions updated for " + file_name
	return "Incorrect use of chmod"

	return "File not found."
	
func change_directory(dir_name: String):
	#if dir_name == "..":
	## Go back to the parent directory
		#if current_directory["parent"] != null:
			#current_directory_name = current_directory["parent"]  # Update current directory name
			#current_directory = file_system_instance.file_system[current_directory_name]  # Set the current directory to its parent
			#display_files_and_directories(current_directory)
			#return current_directory_name
		#else:
			#return "You are already at the root directory."  # Already at root, can't go up
	if trapped:
		return "You are trapped deal with the viruses before escaping"
	if dir_name == "..":
	# Go back to the parent directory if it exists
		if current_directory["parent"] == null:
			return "In root"
		if current_directory.has("parent") and current_directory["parent"] != null:
			# Recursively search the directory to find the parent's reference in the file system
			var parent_directory = find_directory(file_system_instance.file_system["Root"],"Root", current_directory["parent"])

			if parent_directory != null:
				 
				current_directory_name = current_directory["parent"]  # Update current directory name
				current_directory = parent_directory  # Set the current directory to its parent
				tipBox.text = current_directory["textInfo"]
				display_files_and_directories(current_directory)
				return current_directory_name
	elif current_directory["Subdirectories"].has(dir_name):
		current_directory_name = dir_name
		current_directory = current_directory["Subdirectories"][current_directory_name]  # Navigate into the subdirectory
		tipBox.text = current_directory["textInfo"]
		display_files_and_directories(current_directory)
		return current_directory_name
	else:
		return ("Directory not found: " + dir_name)  # Handle non-existent directory

func find_directory(directory, name, target_name):
	# Base case: if the current directory name matches the target name
	if name == target_name:
		return directory

	# Recursively search through subdirectories
	for subdir_name in directory["Subdirectories"].keys():
		var subdirectory = directory["Subdirectories"][subdir_name]
		var result = find_directory(subdirectory,subdir_name, target_name)
		if result != null:
			return result

	# If no match found, return null
	return null



func display_files_and_directories(directory):
	for child in get_children():
		if child.is_in_group("files"):
			var label_node = child.get_node("Label")
			if label_node.text == current_directory_name:
				# Animate the directory downward before removing it
				var target_pos = main_character.position
				#var target_pos = child.position + Vector2(0, 100)  # Move downward by 100 pixels
				
				# Create a Tween node for the animation
				var tween = create_tween()

				# Connect the animation finished signal to remove the child after the move
				tween.tween_property(child, "position", target_pos, 0.5)
				await tween.finished  # Wait until the tween finishes

				# Remove the node after animation
			child.queue_free()

	var positions = [
	Vector2(1000, 350),  # Position for the first file
	Vector2(800, 350),  # Position for the second file
	Vector2(600, 350)   # Position for the third file
	]

	# Display the files from the current directory
	#NEED TO COMBINE THESE TWO FOR LOOPS IN FUTURE DO LATER
	var lastIndPos = 0
	for i in range(directory["Files"].size()):
		var file_name = directory["Files"][i].name
		if i < positions.size():  # Ensure we don't exceed the predefined positions
			var file_instance = file_scene.instantiate()  # Create a new instance of the file
			file_instance.position = positions[i]  # Set the position from the predefined list
			file_instance.get_node("Label").text = file_name  # Set the label text to the file name
			file_instance.get_node("Sprite2D").texture = preload("res://art/fileArt2.png")  # Change texture for file
			file_instance.get_node("Sprite2D").scale = Vector2(3.75, 3.75)  # Set the scale for file
			add_child(file_instance)  # Add the file to the scene
			lastIndPos += 1
			# Optionally add the file instance to a group for easier management
			file_instance.add_to_group("files")
	
	for i in range(directory["Subdirectories"].size()):
		var dir_name = directory["Subdirectories"].keys()[i]
		if i < positions.size():  # Ensure we don't exceed the predefined positions
			var dir_instance = file_scene.instantiate()  # Create a new instance of the file (can be a directory representation)
			dir_instance.position = positions[lastIndPos]  # Set the position from the predefined list
			dir_instance.get_node("Label").text = dir_name  # Set the label text to the directory name
			dir_instance.get_node("Sprite2D").texture = preload("res://art/folderArt.png")  # Change texture for file
			dir_instance.get_node("Sprite2D").scale = Vector2(.15, .15)
			add_child(dir_instance)  # Add the directory to the scene
			lastIndPos +=1
			
			dir_instance.add_to_group("files")
	var output = ""

	# Iterate through files in the directory
	for file in directory["Files"]:
		output += "%s\n" % file["name"]  # Append file name to output

	# Iterate through subdirectories in the directory
	for subdir in directory["Subdirectories"].keys():
		output += "%s\n" % subdir  # Append subdirectory name to output

	return output

func create_files(file_name: String):
	# Remove any existing file instances
	for child in get_children():
		if child.is_in_group("files"):  # Assuming you add files to a group named "files"
			child.queue_free()  # Removes the node from the scene
	var toAdd = 450
	var positions = [
		Vector2(toAdd + 400, 250),  # Position for the first file
		Vector2(toAdd + 300, 250),  # Position for the second file
		Vector2(toAdd + 100, 250)   # Position for the third file
	]

	#for i in range(3):  # Create three files
		#var file_instance = file_scene.instantiate()  # Create a new instance of the file
		#file_instance.position = positions[i]  # Set the position from the predefined list
		#file_instance.get_node("Label").text = file_name + " " + str(i + 1)  # Set the label text to the name
		#add_child(file_instance)  # Add the file to the scene
#
		## Optionally add the file instance to a group for easier management
		#file_instance.add_to_group("files")
#
		## Position MainCharacter in front of the last created file
		#if i == 2:  # Only position the character after the last file is created
			#main_character.position = positions[1] + Vector2(-20, 50)  # Adjust the offset as needed
