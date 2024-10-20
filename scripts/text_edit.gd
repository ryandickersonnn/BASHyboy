extends TextEdit

enum VimMode { NORMAL, INSERT }
var current_mode = VimMode.NORMAL

# Called every frame, handles key inputs
func _input(event):
	# Only process input if this is the active editor
	if event is InputEventKey:  # Check if the event is a key event
		if current_mode == VimMode.NORMAL:
			_handle_normal_mode(event)
		elif current_mode == VimMode.INSERT:
			_handle_insert_mode(event)

# Enable the editor and allow interaction when vi is called
func activate_vim():
	set_editable(true)  # Enable text editing when vi is triggered
	current_mode = VimMode.NORMAL  # Start in normal mode

# Handle key inputs in normal mode
func _handle_normal_mode(event: InputEventKey):
	if event.pressed:
		match event.scancode:
			KEY_I:
				current_mode = VimMode.INSERT
				set_editable(true)  # Enable text editing
			# Implement other keys...

# Handle key inputs in insert mode
func _handle_insert_mode(event: InputEventKey):
	if event.pressed:
		match event.scancode:
			KEY_P:
				# Switch back to normal mode
				current_mode = VimMode.NORMAL
				set_editable(false)  # Disable text editing to emulate normal mode

# Handle key inputs in normal mode
#func _handle_normal_mode(event: InputEventKey):
	#if event.pressed:
		#match event.scancode:
			#KEY_I:
				## Switch to insert mode
				#current_mode = VimMode.INSERT
				#set_editable(true)  # Enable text editing
			#KEY_H:
				## Move cursor left
				#set_caret_column(get_caret_column() - 1)
			#KEY_L:
				## Move cursor right
				#set_caret_column(get_caret_column() + 1)
			#KEY_K:
				## Move cursor up
				#set_caret_column(get_caret_column() - 1)
#
			#KEY_J:
				## Move cursor down
				#set_caret_column(get_caret_column() + 1)
#
			#KEY_X:
				## Delete a character at the cursor in normal mode
				#delete_char_at_cursor()
#
## Handle key inputs in insert mode
#func _handle_insert_mode(event: InputEventKey):
	#if event.pressed:
		#match event.scancode:
			#KEY_P:
				## Switch back to normal mode
				#current_mode = VimMode.NORMAL
				#set_editable(false)  # Disable text editing to emulate normal mode
#
## Helper to delete a character at the current cursor position
#func delete_char_at_cursor():
	#var cursor_pos = get_caret_column()
	#var current_line = get_caret_line()
	#var text_in_line = get_line(current_line)
#
	#if cursor_pos < text_in_line.length():
		## Remove character at the cursor position
		#var updated_text = text_in_line.substr(0, cursor_pos) + text_in_line.substr(cursor_pos + 1)
		#set_line(current_line, updated_text)
