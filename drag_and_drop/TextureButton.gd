extends TextureButton

@export
var spawnedDevicePath : PackedScene

func _on_pressed():
	print("button pressed")

func _on_button_down():
	print("_on_button_down")
	$"../../..".select(spawnedDevicePath)

func _on_button_up():
	print("_on_button_up")
	$"../../..".done_select()
