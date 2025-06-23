extends Node

var colors   #array of colors taken from Main
var window_width	
var window_height
var ratio
var balloon_size #balloonsize

func _ready() -> void:
	ratio = 1
	colors = Main.colors
	balloon_size = 100
	
	populate_balloons()

func populate_balloons(color: String = "Default", originX: int = 0, originY: int = 0):
	var top_bpr = Main.top_bpr
	var bpr = top_bpr
	var xOffset = 220 #* ratio
	var x = 0
	var y = -1
	var iOffset = 0
	var yParabola = 0    #multiplier to make parabola shape
	var xParabola = 0    #multiplier to account for rows with fewer balloons
	#var guesses = [0,0,0,0,0,0,0,0]
	var scale = Main.scale * ratio
	var size = balloon_size * ratio
	var balloonControlX = originX
	var balloonControlY = originY
	
	#WARNING: If you try to get the position of the parent here, the most recent values won't be updated
	#call_deferred() seems to be the suggested solution, but I'll just divide the screen size
	#var bcNum = int(self.name.right(1))
	#if bcNum % 2 == 1:  #odd teams
		#balloonControlX = 962
	
	for i in range(Main.num_balloons):
		#Reduce 4th row by 1
		if i == 3 * top_bpr:
			iOffset = 3 * bpr
			bpr -= 1
			x=0
			xOffset += 50
			xParabola = 0.5
		#Reduce last row by 1 again
		if i == 3 * (top_bpr + (top_bpr - 1)):
			iOffset = 3 * (2* top_bpr - 1)
			bpr -= 1
			x=0
			xOffset += 50
			xParabola = 1
		
		#Go to next row once max balloons per row has been reached
		if ((i - iOffset) % bpr == 0):
			x = 0
			y += 1
			
		yParabola = (-2*((x+xParabola)**2)+28.7*(x + xParabola))*ratio	#multiplier to make parabola shape y=ax^2+bx+c
		
		#Create new balloon instance
		var newBalloon = Main.BALLOON.instantiate()
		var rnd = randi_range(-10,10)
		newBalloon.transform = Transform2D(deg_to_rad(float(rnd) / 2), Vector2((xOffset+(balloon_size * x) + rnd)*ratio, 280+y * 70 + rnd - yParabola*2))*ratio #2d(instance int, transform2d(rot, trans)
		newBalloon.position += Vector2(balloonControlX, balloonControlY)
		newBalloon.add_to_group("main_balloons")
		#Set balloon color
		var randColor = colors[randi() % Main.colors.size()]
		if color != "Default":
			randColor = color
			
		
		newBalloon.scale = Vector2(scale, scale)
		newBalloon.name = "Balloon" + str(i).pad_zeros(2)
		newBalloon.set_default_color(randColor)
		Main.balloons.append(newBalloon)
		Main.remainingBalloons.append(newBalloon)
		add_child(newBalloon)
		
		x += 1
	Main.build_remaining_array()


func _check_answers():
	#Set answer variable based on textbox val or imported csv
	var ans = Main.answers[Main.question_num - 1]
	Main.set_answer(ans)
	
	#For each team, check how wrong they were, then pop those balloons
	for i in range(Main.num_teams):
		calc_num_to_pop(i)
		pop_balloons(i)
		if Main.remainingArray[i].size() <= 0:
			Main.trigger_fall[i] = true
			
	
			
func calc_num_to_pop(teamNum: int):
	var percentOff = abs(Main.get_answer() - Main.get_guess(teamNum))
	#print("Popping " + str(percentOff) + ", team guess: " + str(Main.get_guess(teamNum)))
	Main.set_num_to_pop(teamNum, percentOff)	
	
func pop_balloons(teamNum: int):
	var num_to_pop = Main.get_num_to_pop(teamNum)
	for i in range(num_to_pop):  #run [numToPop] times
		if Main.remainingArray[teamNum].size() >= 1:  #If there are any balloons left, make invisible and remove from remainingBalloons
			var balloon = Main.get_rand_balloons(teamNum)
			balloon[0].popped[teamNum] = true
			if teamNum == Main.currentTeam:
				balloon[0].visible = false
			Main.remainingArray[teamNum].erase(balloon[0])
			#Result balloon
			balloon[1].visible = false
			Main.remaining_result_balloons[teamNum].erase(balloon[1])
		else: #if no more balloons
			#change characters
			#change background
			#reset balloons
			pass
	%RemainingBalloonNum.text = str(Main.remainingArray[Main.currentTeam].size())
	#Update NumPopped text boxes
	var popped_text = %BalloonResults.get_child(teamNum).get_child(1)
	popped_text.visible = true
	popped_text.text = "-%d" % num_to_pop

func show_teams_balloons(teamNum: int):
	var balloons = Main.balloons
	for balloon in balloons:
		if balloon.is_popped(teamNum):
			balloon.visible = false
		else:
			balloon.visible = true

func reset_balloons():
	for balloon in get_tree().get_nodes_in_group("main_balloons"):
		balloon.popped.fill(false)
		balloon.visible = true
	for r_balloon in get_tree().get_nodes_in_group("result_balloons"):
		r_balloon.visible = true

func restore_balloons(team_num : int):
	for balloon in get_tree().get_nodes_in_group("main_balloons"):
		balloon.popped[team_num] = false
		balloon.visible = true
	##DO THIS LATER---_\
	for r_balloon in get_tree().get_nodes_in_group("result_balloons"):
		r_balloon.visible = true
	Main.restore_remaining(team_num)

func glow_in_the_dark(tf : bool):
	if tf:
		for balloon in get_tree().get_nodes_in_group("main_balloons"):
			balloon.glow()
	else:
		for balloon in get_tree().get_nodes_in_group("main_balloons"):
			balloon.no_glow()

func _print_guess() -> void:
	print(str(Main.get_guess(0)))
