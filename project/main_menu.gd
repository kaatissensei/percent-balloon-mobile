extends TextureRect

func _start():
	visible = false
	%ResultsScreen.visible = false
	Main.reset_rrb()


func _mouseover(btnID : int) -> void:
	for btn in get_tree().get_nodes_in_group("main_menu_btns"):
		btn.get_child(0).visible = false

	
	match btnID:
		1:
			%UploadCSV.get_child(0).visible = true
			%UploadCSV.get_child(1).visible = false
			
			%StartGame.get_child(1).visible = true
		_:
			%StartGame.get_child(0).visible = true
			%StartGame.get_child(1).visible = false
			
			%UploadCSV.get_child(1).visible = true
	
