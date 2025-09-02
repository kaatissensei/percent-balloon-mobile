extends TextureRect

signal num_teams_changed
signal start_demo

var demo : bool = false

func _start():
	visible = false
	%ResultsScreen.visible = false
	Main.reset_rrb()
	
	#%StartGame.connect("mouse_entered", _mouseover.bind(%StartGame))
	#%UploadCSV.connect("mouse_entered", _mouseover.bind(%UploadCSV))
	#%StartDemo.connect("mouse_entered", _mouseover.bind(%StartGame))

func _set_initial_num_teams(num_teams : int):
	num_teams_changed.connect(Main.root._change_num_teams)
	num_teams_changed.emit(num_teams)

	%ChooseNumPlayers.visible = false
	if !demo:
		_start()
	else:
		start_demo.connect(Main.root._start_demo)
		start_demo.emit()

func _open_num_players(is_demo : bool = false):
	%ChooseNumPlayers.visible = true
	
	demo = is_demo


#func _start_demo():
	#start_demo.connect(Main.root._start_demo)
	#start_demo.emit()

func _mouseover(btnID : int) -> void:
	for btn in get_tree().get_nodes_in_group("main_menu_btns"):
		btn.get_child(0).visible = false
		btn.get_child(1).visible = true

	var hovered_btn : Button
	match btnID:
		1:
			hovered_btn = %UploadCSV
		2:
			hovered_btn = %StartDemo
		_:
			hovered_btn = %StartGame
	
	hovered_btn.get_child(0).visible = true
	hovered_btn.get_child(1).visible = false


func _on__pressed(extra_arg_0: int) -> void:
	pass # Replace with function body.
