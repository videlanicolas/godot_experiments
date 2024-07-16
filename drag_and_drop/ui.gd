extends MarginContainer

signal button_select(selected_object : String)
signal button_done_select

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func select(selected_object : PackedScene):
	print(selected_object.resource_path)
	emit_signal("button_select", selected_object.resource_path)
	print("emitted signal")

func done_select():
	emit_signal("button_done_select")
