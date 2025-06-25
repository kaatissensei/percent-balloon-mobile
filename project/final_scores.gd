extends Control

var final_scores : Array[int]
var height : int
var time : float
var winner_order : Array[int]
var team_placements : Array[int]
var sorted_scores
var next_to_stop : int = 0
var winners : Array[int] #array in case of ties

func _ready() -> void:
	final_scores.resize(6)
	winner_order.resize(6)
	team_placements.resize(6)
	load_scores

func get_final_scores():
	for i in range(Main.num_teams):
		final_scores[i] = 500 - (100 * Main.falls[i]) - (100 - Main.remainingArray[i].size())
		if final_scores[i] < 0:
			final_scores[i] = 0
	print("Red:%d B:%d Y:%d G:%d P:%d O:%d" % final_scores)
	sorted_scores = final_scores.duplicate(true)
	sorted_scores.sort()
	print(sorted_scores)
	sort_winners()

func show_final_results():
	%FinalScoresBtn.visible = false
	for i in range(Main.num_teams):
		var score_range : float = sorted_scores[5]-sorted_scores[0]
		if score_range == 0:
			score_range = 1
		var adjusted_score : float = final_scores[i]-sorted_scores[0]
		var fraction : float = adjusted_score / score_range #Don't forget to convert to float

		var height = 725 - (550 * (fraction))
		%CollisionObjects.get_child(i).position.y = height
		%FinalBalloons.get_child(i).start_moving()

func sort_winners():
	var team_score : int
	for t in range(Main.num_teams): #for each team
		team_score = final_scores[t]
		for s in range(sorted_scores.size()):
			if sorted_scores[s] == team_score:
				team_placements[t] = 6-s #because it is sorted by ascending order
				
				if s == 5:
					winners.push_back(t)
				#return
	for i in range(team_placements.size()):
		%FinalBalloons.get_child(i).set_place(team_placements[i])
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
