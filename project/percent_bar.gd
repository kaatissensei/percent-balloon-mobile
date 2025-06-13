extends MarginContainer


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.

func _update_percent_guessed(value):
	%PercentGuessed.text = "[right]%s[/right]" % str(int(value))
	Main.set_guess(value)
	%PercentSlider.get_child(Main.currentTeam).position.x = (14.7 * value)
	
