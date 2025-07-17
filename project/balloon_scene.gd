extends Node2D

#var currentTeam
var symbol
var current_falls

@onready var bg_sky = preload("res://images/assets/BG_Sky.tres")
@onready var bg_fujisan = preload("res://images/assets/BG_Fujisan.png")
@onready var bg_underwater = preload("res://images/assets/BG_Underwater.png")
@onready var bg_deep_sea = preload("res://images/assets/BG_Deep_Sea.tres")


func _ready() -> void:
	current_falls = 0
	%Clouds.visible = true
	%Background.texture = bg_sky
	%Students.self_modulate = Color.WHITE
	%SurprisedFaces.visible = false
	%Snorkels.visible = false
	Main.root = self

func _start_demo():
	Main.load_demo_csv()
	#Main.parse_csv_string()
	load_question_text()
	%MainMenu.visible = false
	%ResultsScreen.visible = false
	Main.reset_rrb()
	_change_num_teams(Main.num_teams)

func _change_team(teamNum: int):
	var currentTeam = int(teamNum)
	Main.currentTeam = currentTeam
	var basketColor = "Red"
	var tintColor

	load_bg(currentTeam)
	
	#updateBalloons()
	basketColor = Main.colors[currentTeam]
	#match (currentTeam):
		#0:
			#basketColor = "Red"
		#1:
			#basketColor = "Blue"
		#2:
			#basketColor = "Yellow"
		#3:
			#basketColor = "Green"
		#4:
			#basketColor = "Purple"
		#5:
			#basketColor = "Orange"
		#6:
			#basketColor = "Sky_Blue"
		#7:
			#basketColor = "Pink"
		#_:
			#basketColor = "Red"
		
	%Basket.texture = load("res://images/assets/basket%s.png" % basketColor)
	tintColor = Main.get_tint_color(basketColor)
	
		#Change percent color
	%PercentGuessed.add_theme_color_override("default_color", Color(tintColor))
	%PercentGuessedSymbol.add_theme_color_override("default_color", Color(tintColor))
		#Change color of students' ties
	%Ties.self_modulate = Color(tintColor)
	%Snorkels.self_modulate = Color(tintColor)
		#Change slider colors
	var grabberFile = load("res://images/ui/grabber/pb_grabber_%s.png" % basketColor.to_lower())
	%PercentSlider.add_theme_icon_override("grabber", grabberFile)
	%PercentSlider.add_theme_icon_override("grabber_highlight", grabberFile)
	%PercentSlider.value = Main.get_guess(currentTeam)
	%BalloonControl.show_teams_balloons(currentTeam)
	%RemainingBalloon.texture = load("res://images/balloons/balloon%sSm.png" % basketColor)
	%RemainingBalloonNum.text = str(Main.remainingArray[currentTeam].size())
	
	%PercentGuessedMoving.add_theme_color_override("default_color", tintColor)
	
	#Trigger fall animation if the team is out of balloons
	if (Main.trigger_fall[currentTeam]):
		fall_animation()

func reset_guesses():
	for i in range(Main.max_num_teams):
		#_change_team(i)
		%ResultsBarMargin._update_percent_guessed(0, i)
		update_markers()
		%PercentSlider.value = 0
		%TeamSlider.value = 0
		#Hide popped num on results
		%BalloonResults.get_child(i).get_child(1).visible = false
	_change_team(0)
	

func _show_results() -> void:
	%ResultsScreen.open()
	if Main.question_num >= Main.num_questions:
		%NextQuestionBtn.visible = false

func _next_question() -> void:
	%CheckAnswers.disabled = false
	%ResultsScreen.visible = false
	Main.question_num += 1
	load_question_text()
	reset_guesses()
	
	#Reset results balloons if fall
	
	

func load_question_text():
	var q_num : int = Main.question_num
	%QuestionText.text = "Q%d: " % q_num + Main.questions[q_num - 1]

func update_markers():
	var guess_val
	if Main.percent_mode:
		symbol = "%"
	else:
		symbol = ""
	for i in range(6):
		guess_val = Main.get_guess(i)
		%ResultsPercentSlider.get_child(i).position.x = (14.7 * guess_val) - 10 #1500 * i/100
		%BalloonResults.get_child(i).get_child(0).text = str(guess_val) + symbol

func switch_percent_mode(toggled_on: bool) -> void:
	var tf = !toggled_on
	var text_box = %PercentModeButton.get_child(0)
	Main.switch_percent_mode(tf)
	%PercentGuessedSymbol.visible = tf
	if tf:
		text_box.text = "On"
		text_box.add_theme_color_override("default_color", Color.BLACK)
	else:
		text_box.text = "Off"
		text_box.add_theme_color_override("default_color", Color.WHITE)

func switch_potato_mode(toggled_on: bool) -> void:
	var tf = toggled_on
	var text_box = %PotatoModeButton.get_child(0)
	
	%BalloonControl.freeze_balloons(tf)
	if !tf:
		text_box.text = "On"
		text_box.add_theme_color_override("default_color", Color.BLACK)
	else:
		text_box.text = "Off"
		text_box.add_theme_color_override("default_color", Color.WHITE)
	
	
func reset():
	reset_guesses()
	Main.reset()
	%RemainingBalloonNum.text = str(Main.remainingArray[0].size())
	%BalloonControl.reset_balloons()

func _set_questions():
	#Main.clear_questions()
	for i in range(Main.num_questions):
		Main.questions[i] = %Questions.get_child(i).get_child(0).text
		Main.answers[i] = int(%Questions.get_child(i).get_child(1).text)
	%QuestionText.text = "Q1: " + Main.questions[0]
	Main.question_num = 1
	#Reset balloons
	reset()
	Main.save_JSON()
	%QuestionMenu._close_menu()
	
	##Move circles AFTER positions have definitely been changed
	#for circle in get_tree().get_nodes_in_group("balloon_circles"):
		#circle.move_circle()

func load_bg(team_num : int):
	var team_falls : int = Main.get_falls(team_num)
	if team_falls != current_falls:
		current_falls = team_falls
		%Clouds.visible = false
		%Background.texture = bg_sky
		%Students.self_modulate = Color.WHITE
		%SurprisedFaces.visible = false
		%Snorkels.visible = false
		%BalloonControl.glow_in_the_dark(false)
		match team_falls:
			0:
				%Clouds.visible = true
			1:
				%Background.texture = bg_fujisan
				%SurprisedFaces.visible = true
			2:
				%Background.texture = bg_underwater
				%Snorkels.visible = true
			_:
				%Background.texture = bg_deep_sea
				%Snorkels.visible = true
				%Students.self_modulate = Color.BLACK
				%Ties.self_modulate = Color.BLACK
				%BalloonControl.glow_in_the_dark(true)

func fall_resets():
	pass

func fall_animation():
	var current_team = Main.currentTeam
	
	Main.trigger_fall[current_team] = false
	
	await get_tree().create_timer(0.5).timeout
	%SurprisedFaces.visible = true
	await get_tree().create_timer(0.7).timeout
	var tween = create_tween()
	tween.tween_property(%Students, "position:y", 1500, 0.25)
	await get_tree().create_timer(0.7).timeout
	
	%Speed.visible = true
	Main.fall(current_team)
	#Do while speed lines are showing
	_change_team(current_team)
	%Students.position.y = 809
	%BalloonControl.restore_balloons(current_team)
	%RemainingBalloonNum.text = str(Main.remainingArray[current_team].size())
	await get_tree().create_timer(0.5).timeout
	#Hide speed lines
	%Speed.visible = false


func _load_json() -> void:
	Main.load_JSON()
	%QuestionMenu.load_question_menu()
	load_question_text()
	%LoadMenu.visible = false

func _load_demo() -> void:
	Main.load_demo_csv()
	%QuestionMenu.load_question_menu()
	load_question_text()
	%LoadMenu.visible = false


func _go_to_final_scores() -> void:
	%FinalScores.visible = true
	%FinalScores.load_scores()

func fullscreen():
	Main.fullscreen()
	

func _change_num_teams(value: int) -> void:
	Main.set_num_teams(value)
	update_balloon_bar()
	%NumTeamsSpinbox.value = value
	%ResultsScreen.change_num_team_results()

func update_balloon_bar():
	var num_teams = Main.num_teams
	for balloon in get_tree().get_nodes_in_group("slider_balloons"):  #Careful, the balloons are in backwards order
		var team_num : int = int(balloon.name.right(1))
		if team_num <= num_teams:
			%TeamSlider.get_child(0).get_child(8 - team_num).visible = true
			%PercentSlider.get_child(team_num-1).visible = true
		else:
			%TeamSlider.get_child(0).get_child(8 - team_num).visible = false
			%PercentSlider.get_child(team_num-1).visible = false

	%TeamSlider.visible = true
	#Change slider height
	if num_teams == 8:
		%TeamSlider.size.y = 620
		%TeamSlider.position.y = 160
	elif num_teams == 7:
		%TeamSlider.size.y = 530
		%TeamSlider.position.y =250
	elif num_teams == 1:
		%TeamSlider.visible = false
	else:
		%TeamSlider.size.y = 440
		%TeamSlider.position.y = 340
	#Change number of ticks
	%TeamSlider.tick_count = num_teams
	%TeamSlider.max_value = num_teams - 1


func _update_circle_positions() -> void:
	pass # Replace with function body.
