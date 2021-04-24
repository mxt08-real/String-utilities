extends Control

onready var text = $Background/Text
onready var algorithm = $Background/Algorithm
onready var config = ConfigFile.new()
var result = ""
const PATH_TO_DATA_FILE = "user://data.cfg"
const PASSWORD = "1234"

func _ready():
	OS.center_window()
	if(config.load_encrypted_pass(PATH_TO_DATA_FILE, PASSWORD) == OK):
		text.text = config.get_value("data", "saved_text")
	pass

func OnEncode():
	var code_algorithm = algorithm.get_selected_id()
	var written = text.text + "\n\n"
	if(code_algorithm == 0):
		text.text = written + Marshalls.utf8_to_base64(written)
		result = Marshalls.utf8_to_base64(written)
	elif(code_algorithm == 1):
		text.text = written + written.c_escape()
		result = written.c_escape()
	elif(code_algorithm == 2):
		text.text = written + written.http_escape()
		result = written.http_escape()
	elif(code_algorithm == 3):
		text.text = written + written.json_escape()
		result = written.json_escape()
	elif(code_algorithm == 4):
		text.text = written + written.sha1_text()
		result = written.sha1_text()
	elif(code_algorithm == 5):
		text.text = written + written.sha256_text()
		result = written.sha256_text()
	else:
		text.text = written + str(written.hash())
		result = str(written.hash())
	pass

func OnCopy():
	OS.clipboard = result
	$Background/Copied.show()
	pass

func OnSave():
	config.set_value("data", "saved_text", text.text)
	var status = config.save_encrypted_pass(PATH_TO_DATA_FILE, PASSWORD)
	if(status == OK):
		$Background/ErrorSaving.hide()
		$Background/Saved.show()
	else:
		$Background/Saved.hide()
		$Background/ErrorSaving.show()
	pass
