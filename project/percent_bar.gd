extends MarginContainer


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.

func _update_percent_guessed(value : int, team_num : int = Main.currentTeam):
	%PercentGuessed.text = "[right]%s[/right]" % str(int(value))
	Main.set_guess(value, team_num)
	%PercentSlider.get_child(team_num).position.x = (14.7 * value)
	
