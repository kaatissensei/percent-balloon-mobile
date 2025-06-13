extends Node2D

#var currentTeam

func _ready() -> void:
	pass#currentTeam = Main.currentTeam

func _change_team(teamNum: float):
	var currentTeam = int(teamNum)
	Main.currentTeam = currentTeam
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
	%PercentSlider.value = Main.get_guess(currentTeam)
	%BalloonControl.show_teams_balloons(currentTeam)
	%RemainingBalloon.texture = load("res://images/balloons/balloon%sSm.png" % basketColor)
	%RemainingBalloonNum.text = str(Main.remainingArray[currentTeam].size())

func reset_guesses():
	for i in range(Main.num_teams-1, -1, -1):
		_change_team(i)
		%ResultsBarMargin._update_percent_guessed(0)
		update_markers()
		%PercentSlider.value = 0
		%TeamSlider.value = 0
		#Hide popped num on results
		%BalloonResults.get_child(i).get_child(1).visible = false
	

func _show_results() -> void:
	%ResultsScreen.open()


func _next_question() -> void:
	%ResultsScreen.visible = false
	Main.question_num += 1
	load_question_text()
	reset_guesses()

func load_question_text():
	var q_num : int = Main.question_num
	%QuestionText.text = "Q%d: " % q_num + Main.questions[q_num]

func update_markers():
	var guess_val
	for i in range(6):
		guess_val = Main.get_guess(i)
		%ResultsPercentSlider.get_child(i).position.x = (14.7 * guess_val) - 10 #1500 * i/100
		%BalloonResults.get_child(i).get_child(0).text = str(guess_val) + "%"
