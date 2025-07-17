extends TextureRect

signal num_teams_changed

func _start():
	num_teams_changed.connect(Main.root._change_num_teams)
	num_teams_changed.emit(Main.num_teams)
	visible = false
	%ResultsScreen.visible = false
	Main.reset_rrb()

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
