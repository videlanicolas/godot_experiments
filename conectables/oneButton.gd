extends TextureButton

@export
var conectable : PackedScene = null

func _on_button_down():
	print("button down")
	var c := conectable.instantiate()
	%PlayArea.add_child(c)
	get_node("/root/Root").selected = c

func _on_button_up():
	print("button up")
	get_node("/root/Root").selected.placed()
	get_node("/root/Root").selected = null
