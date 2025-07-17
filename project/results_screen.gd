extends TextureRect

var offset : int = -10
var symbol = "%"

func _ready() -> void:
	pass
	
func open():
	if Main.percent_mode:
		symbol = "%"
	else:
		symbol = ""
	visible = true
	update_markers()
	show_popped()
	%ResultsText.visible = false
	%ResultsGrayBar.size.x = 0
	for circle in get_tree().get_nodes_in_group("balloon_cicles"):
		circle.move_circle()
	
	var num_teams = Main.num_teams
	%ResultsFiller.visible = false
	if num_teams > 6:
		get_child(0).add_theme_constant_override("margin_left",100) #Margin Container
		%BalloonResults.columns = 4
	elif num_teams > 3:
		get_child(0).add_theme_constant_override("margin_left",150)
		%BalloonResults.columns = 3
	else:
		get_child(0).add_theme_constant_override("margin_left",150)
		%BalloonResults.columns = num_teams
		%ResultsFiller.visible = true
	
func load_results():
	%CheckAnswers.disabled = true
	await animate_bar()
	%BalloonControl._check_answers()
	show_popped()
	var answer : int = Main.get_answer()
	%ResultsText.text = str(answer) + symbol
	if (answer < 85):
		%ResultsText.position.x = 14.7 * answer
	else:
		%ResultsText.position.x = (14.7 * answer) - 400 #move to left side of line
	%ResultsText.visible = true

func update_markers():
	var guess_val
	for i in range(Main.num_teams):
		guess_val = Main.get_guess(i)
		%ResultsPercentSlider.get_child(i).position.x = (14.7 * guess_val) + offset #1500 * i/100

func animate_bar():
	##WIP Edit tween now that you realized you can just turn it upside down
	var duration : float = 1.5
	await tween_bar(randf_range(500, 1200), duration)
	await tween_bar(randf_range(100, 500), duration)
	await tween_bar(randf_range(600, 1500), duration)
	
	go_to_answer()

func tween_bar(amount : float, duration : float):
	#var r_pos = 1481
	var tween = create_tween()
	tween.tween_property(%ResultsGrayBar, "size:x", amount, duration)	
	await tween.finished

func go_to_answer():
	var answer = Main.answers[Main.question_num-1]
	var tween_final = create_tween()
	tween_final.tween_property(%ResultsGrayBar, "size:x", (100 - answer) * 14.7, 0.2)
	await tween_final.finished
	
	#Pop balloons
func show_popped(): #Should change name
	for i in range(Main.num_teams):
		%BalloonResults.get_child(i).get_child(0).text = str(Main.get_guess(i)) + symbol


func _close_results() -> void:
	%CheckAnswers.disabled = false
	visible = false

##WIP WHY does it not change it until AFTER???
func change_num_team_results():
	var num_teams = Main.num_teams
	var is_on : bool
		
	#Move the orange guess bar to top or bottom
	if num_teams > 6:
		%OrangeGuess.position.y = 8.0
		%OrangeGuess.flip_v = true
		%BalloonResults.columns = 4
	else:
		%OrangeGuess.position.y = -3.0
		%OrangeGuess.flip_v = false
		%BalloonResults.columns = 3
		
	for i in range(8):
		if i <= num_teams - 1:
			is_on = true
		else:
			is_on = false
		%BalloonResults.get_child(i).visible = is_on
		#set_balloon_circle_position()
		%BalloonResults.get_child(i).find_child("BalloonCircle*").move_circle()
		%ResultsPercentSlider.get_child(i).visible = is_on
	
	#Briefly making screen visible doesn't work
	#%ResultsScreen.z_index = -1000
	#%ResultsScreen.visible = true
	#await get_tree().create_timer(0.01).timeout
	#%ResultsScreen.visible = false
	#%ResultsScreen.z_index = 10
	##TO TRY
	##Check starting positions of balloons and circles at every stage between calling this and opening and closing results screen
	##WHEN MOVE CIRCLE IS CALLED, HAVE THE SIZES CHANGED YET?? WHAT ABOUT ADDING A TIMER IN THE BALLOON SCENE METHOD?
	for circle in get_tree().get_nodes_in_group("balloon_circles"):
		circle.move_circle()
		#circle.visible = false
		


func set_balloon_circle_position(_x:float, _y:float):
	
	pass


func _print_global_pos() -> void:
	print(%BalloonResults.get_child(3).find_child("BalloonCircle*").global_position)
