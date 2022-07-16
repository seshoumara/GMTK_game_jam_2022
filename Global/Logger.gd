class_name Logger

class Message:
	var text: String = ""
	var type : String = ""
	var show_in_UI: bool = false
	
	func _init(_text: String, _type: String, _show_in_UI: bool):
		text = _text
		type = _type
		show_in_UI = _show_in_UI
	
	func print() -> String:
		return type + ": " + text + "\n"

const log_path: String = "GMTK_game_jam_2022_log.txt"
var messages: Array = []

func log_info(info: String, UI_only: bool) -> void:
	messages.push_back(Message.new(info, "INFO", UI_only))

func log_debug(debug: String, UI_only: bool) -> void:
	messages.push_back(Message.new(debug, "DEBUG", UI_only))

func log_warning(warning: String, UI_only: bool, show_in_console: bool) -> void:
	messages.push_back(Message.new(warning, "WARNING", UI_only))
	if show_in_console:
		push_warning(warning)

func log_error(error: String, UI_only: bool, show_in_console: bool) -> void:
	messages.push_back(Message.new(error, "ERROR", UI_only))
	if show_in_console:
		push_error(error)

func get_messages(UI_only: bool) -> String:
	var entries: String = ""
	for message in messages:
		var entry: String = message.print()
		if UI_only:
			if message.show_in_UI:
				entries += entry
		else:
			entries += entry
	return entries

func flush_messages_to_HDD() -> bool:
	var file: File = File.new()
	if file.open(log_path, file.READ_WRITE) != OK:
		push_error("Error: can't write to the log file!")
		file.close()
		return false
	file.seek_end()
	file.store_string(get_messages(false))
	file.close()
	messages.clear()
	return true
