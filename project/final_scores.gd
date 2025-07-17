extends Control

var final_scores : Array[int]
var height : float
var time : float
var winner_order : Array[int]
var team_placements : Array[int]
var sorted_scores
var next_to_stop : int = 0
var winners : Array[int] #array in case of ties

func _ready() -> void:
	var max_num_teams = Main.max_num_teams
	final_scores.resize(max_num_teams)
	winner_order.resize(max_num_teams)
	team_placements.resize(max_num_teams)
	#load_scores()
	#for i in range(Main.max_num_teams):
		#%CollisionObjects.get_child(i).visible = false
		#%FinalBalloons.get_child(i).visible = false

func setup_balloons():
	var num_teams = Main.num_teams
	for i in range(Main.max_num_teams - 1, Main.num_teams - 1, -1):
		var balloon = %FinalBalloons.get_child(i)
		balloon.visible = false
		print(balloon.name)
		#balloon.get_child(0).position = Vector2.ZERO
		#balloon.position
		
		#var bln_collider = %StopPoints.get_child(i) #WIP These can just be 1920px wide because I learned about collision layers
		#bln_collider.visible = true
		

func get_final_scores():
	for i in range(Main.num_teams):
		final_scores[i] = 500 - (100 * Main.falls[i]) - (100 - Main.remainingArray[i].size())
		if final_scores[i] < 0:
			final_scores[i] = 0
	#print("Red:%d B:%d Y:%d G:%d P:%d O:%d SB:%d Pk:%d" % final_scores)
	sorted_scores = final_scores.duplicate(true)
	sorted_scores.sort()
	for i in range(Main.max_num_teams - Main.num_teams):
		sorted_scores.pop_front()
	print(sorted_scores)
	sort_winners()

func show_final_results():
	%FinalScoresBtn.visible = false
	for i in range(Main.num_teams):
		var score_range : float = sorted_scores[Main.num_teams - 1]-sorted_scores[0]
		if score_range == 0:
			score_range = 1
		var adjusted_score : float = final_scores[i]-sorted_scores[0]
		var fraction : float = adjusted_score / score_range #Don't forget to convert to float

		height = 675 - (500 * (fraction)) #Originally 725, 550
		%StopPoints.get_child(i).global_position.y = height
		%FinalBalloons.get_child(i).get_child(0).start_moving()

##WIP WHY ARE TWO TEAMS 0th!?!?!
func sort_winners():
	var team_score : int
	var num_teams = Main.num_teams
	for t in range(num_teams): #for each team
		team_score = final_scores[t]
		for s in range(sorted_scores.size()): #Otherwise inactive teams are in the 
			if sorted_scores[s] == team_score:
				team_placements[t] = num_teams-s #because it is sorted by ascending order
				
				if s == num_teams - 1: #WIP does this work for two winners still?
					winners.push_back(t)
				#return
	for i in range(team_placements.size()):
		%FinalBalloons.get_child(i).get_child(0).set_place(team_placements[i])
	print("Winning team order is " + str(team_placements))

func show_banner():
	var winner_text : String
	await get_tree().create_timer(1.0).timeout
	match winners.size():
		2:
			winner_text = "%s and %s Win!" % [get_color_text(winners[0]), get_color_text(winners[1])]
		1:
			winner_text = "%s Wins!" % get_color_text(winners[0])
		_:
			%WinnerBanner.size.y = 480
			%WinnerBanner.position.y = 300
			%WinnerBanner.get_child(1).size.y = 992
			for w in range(winners.size()):
				winner_text += get_color_text(winners[w]) + " "
			winner_text += "Win!"
	%WinnerBanner.get_child(0).text = winner_text
	%WinnerBanner.visible = true

func get_color_text(team_num : int):
	var color : String
	color = %FinalBalloons.get_child(team_num).name.substr(12)
	return "[color=" + color + "]" + color + "[/color]"

func load_scores() -> void:
	get_final_scores()
	setup_balloons()
