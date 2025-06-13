extends TextureRect

var offset : int = -10

func _ready() -> void:
	pass
	
func open():
	visible = true
	update_markers()
	
func load_results():
	await animate_bar()
	%BalloonControl._check_answers()
	show_popped()

func update_markers():
	var guess_val
	for i in range(6):
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
	var r_pos = 1481
	var tween = create_tween()
	tween.tween_property(%ResultsGrayBar, "size:x", amount, duration)	
	await tween.finished

func go_to_answer():
	var answer = Main.answers[Main.question_num-1]
	var tween_final = create_tween()
	tween_final.tween_property(%ResultsGrayBar, "size:x", (100 - answer) * 14.7, 0.5)
	await tween_final.finished
	
	#Pop balloons
func show_popped():
	for i in range(Main.num_teams):
		%BalloonResults.get_child(i).get_child(0).text = str(Main.get_guess(i)) + "%"
