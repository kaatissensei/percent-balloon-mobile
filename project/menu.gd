extends Control


func _set_questions():
	for i in range(Main.numQuestions):
		Main.questions[i] = %Questions.get_child(i).get_child(0).text
		Main.answers[i] = int(%Questions.get_child(i).get_child(1).text)
	_close_menu()

func load_question_menu():
	for i in range(Main.questions.size()):
		%Questions.get_child(i).get_child(0).text = Main.questions[i]
		if Main.answers[i] != 0:
			%Questions.get_child(i).get_child(1).text = str(Main.answers[i])

func _open_menu():
	load_question_menu()
	visible = true

func _close_menu():
	visible = false

#WEB FILE ACCESS FUNCTIONS ------------------------------------------------\

var file_access_web: FileAccessWeb = FileAccessWeb.new()

#func _on_file_load_started(file_name: String) -> void:
	#progress.visible = true
	#success_label.visible = false

func _on_upload_pressed() -> void:
	file_access_web.open(".csv")

func _on_progress(current_bytes: int, total_bytes: int) -> void:
	pass
	#var percentage: float = float(current_bytes) / float(total_bytes) * 100
	#progress.value = percentage

func _on_file_loaded(file_name: String, type: String, base64_data: String) -> void:

	var utf8_data: String = Marshalls.base64_to_utf8(base64_data)
	#var string_data: String = base64_data.get_string_from_utf8()
	var file = FileAccess.open("user://PB_Questions.csv", FileAccess.WRITE)
	if FileAccess.file_exists("user://PB_Questions.csv"):
		file.store_string(utf8_data)
		file.close() #Don't forget this!
		Main.csvFile = FileAccess.open("user://PB_Questions.csv", FileAccess.READ)
		
		Main.parse_csv()
	else:
		pass#%DebugText.text = "Can't find file."
