extends MarginContainer

var pgm_timer
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pgm_timer = %PGMTimer
	#pgm_timer = get_tree().create_timer(1.0)
	#pgm_timer.autostart = false

func _update_percent_guessed(value : int, team_num : int = Main.currentTeam):
	%PercentGuessed.text = "[right]%s[/right]" % str(int(value))
	Main.set_guess(value, team_num)
	var x_pos : float = 14.7 * value
	%PercentSlider.get_child(team_num).position.x = x_pos
	
	%PercentGuessedMoving.visible = true
	%PercentGuessedMoving.position.x = x_pos - 45
	%PercentGuessedMoving.text = str(value)
	pgm_timer.start(1)
	
	
func hide_percent_guessed_moving():
	%PercentGuessedMoving.visible = false
	
	
