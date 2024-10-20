extends Node2D

@onready var line_edit: LineEdit = get_parent().get_node("LineEdit")
@onready var main_character: Node2D = self  # Reference to the MainCharacter node
var speed = 100  # Speed at which the character moves up

func _ready():
	line_edit.text_submitted.connect(_on_LineEdit_text_entered)

func _on_LineEdit_text_entered(new_text: String):
	# Move the MainCharacter up
	if(new_text == "move up"):
		main_character.position.y -= speed  # Adjust the distance as needed
	line_edit.clear()  # Optional: clear the LineEdit after submission
