extends Node2D

#var currentTeam

func _ready() -> void:
	pass#currentTeam = Main.currentTeam

func _change_team(teamNum: float):
	var currentTeam = int(teamNum)
	var basketColor = "Red"
	var tintColor
	#updateBalloons()
	match (currentTeam):
		0:
			basketColor = "Red"
		1:
			basketColor = "Blue"
		2:
			basketColor = "Yellow"
		3:
			basketColor = "Green"
		4:
			basketColor = "Purple"
		5:
			basketColor = "Orange"
		6:
			basketColor = "Cyan"
		7:
			basketColor = "Pink"
		_:
			basketColor = "Red"
			
	%Basket.texture = load("res://images/assets/basket%s.png" % basketColor)
	match basketColor:
		"Yellow":
			tintColor = "Gold"
		"Blue":
			tintColor = "Dodger_Blue"
		"Orange":
			tintColor = "Dark_Orange"
		_:
			tintColor = basketColor
	
		#Change percent color
	%PercentGuessed.add_theme_color_override("default_color", Color(tintColor))
	%PercentGuessedSymbol.add_theme_color_override("default_color", Color(tintColor))
		#Change color of students' ties
	%Ties.self_modulate = Color(tintColor)
		#Change slider colors
	var grabberFile = load("res://images/ui/grabber/pb_grabber_%s.png" % basketColor.to_lower())
	%PercentSlider.add_theme_icon_override("grabber", grabberFile)
	%PercentSlider.add_theme_icon_override("grabber_highlight", grabberFile)
	%PercentSlider.value = 0
	%PercentSlider.value = 0
	%BalloonControl.show_teams_balloons(currentTeam)
	%RemainingBalloon.texture = load("res://images/balloons/balloon%sSm.png" % basketColor)
	%RemainingBalloonNum.text = str(Main.remainingArray[currentTeam].size())
	Main.currentTeam = currentTeam
	
