class_name Shell extends LineEdit

## Emitted when the user presses enter, it communicates the command that was written by the user.
signal command_submitted(cmd : String)

## Symbol to display at the begining of the shell line.
@export var shell_symbol : String

func _ready():
	_reset()

func _on_text_submitted(new_text : String):
	_reset()
	if len(new_text) > (len(shell_symbol) + 1):
		command_submitted.emit(new_text.substr(len(shell_symbol)))

func _on_text_changed(new_text : String):
	if not new_text.begins_with(shell_symbol + " "):
		_reset()

func _reset():
	text = shell_symbol + " "
	caret_column = len(shell_symbol) + 1

