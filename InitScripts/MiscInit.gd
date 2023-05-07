extends Node


# Called when the node enters the scene tree for the first time.
func _ready():
	var cursorPng = load("res://Sprites/Cursor/cursorRing.png")
	Input.set_custom_mouse_cursor(cursorPng, Input.CURSOR_ARROW, Vector2(16,16))


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
