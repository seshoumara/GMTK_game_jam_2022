extends Node2D

var Level_Button: Resource = preload("res://Level_button/Level_button.tscn")

export (NodePath) var BackgroundMapPath: NodePath
onready var BackgroundMapNode: TileMap = get_node(BackgroundMapPath) as TileMap
export (NodePath) var LevelsPath: NodePath
onready var LevelsNode: GridContainer = get_node(LevelsPath) as GridContainer

func _ready() -> void:
	get_tree().set_auto_accept_quit(false)
	
	LevelsNode.rect_size = Global.window_size
	for col in range(Global.window_size.x/Global.cell_size.x):
		for row in range(Global.window_size.y/Global.cell_size.y):
			BackgroundMapNode.set_cell(col, row, Global.TILE.FLOOR)
	
	var level_count: int = Global.level_data.size()
	for lvl in range(level_count):
		var lvl_button: TextureButton = Level_Button.instance()
		lvl_button.name = Global.level_data[lvl].name.replace(" ", "_")
		LevelsNode.add_child(lvl_button)
		var lvl_button_path: String = Global.get_path_as_string(LevelsPath) + "/" + lvl_button.name
		lvl_button.set_button_text(Global.level_data[lvl].name)
		var difficulty_tile: int = Global.level_data[lvl].get_difficulty_tile()
		lvl_button.set_dice_texture(Global.get_tile_texture(BackgroundMapNode, difficulty_tile))
		if lvl_button.connect("pressed", self, "_on_lvl_pressed", [lvl]) != OK:
			Global.logger.log_error("unable to connect signal 'pressed' to self!", false, true)
		if lvl_button.connect("mouse_entered", self, "_on_lvl_mouse_entered", [lvl_button_path]) != OK:
			Global.logger.log_error("unable to connect signal 'mouse_entered' to self!", false, true)
		if lvl_button.connect("mouse_exited", self, "_on_lvl_mouse_exited", [lvl_button_path]) != OK:
			Global.logger.log_error("unable to connect signal 'mouse_exited' to self!", false, true)

func _on_lvl_pressed(lvl: int) -> void:
	Global.level_to_load = lvl
	if get_tree().change_scene("res://Level/Level.tscn") != OK:
		Global.logger.log_error("either scene path can't be loaded, or the scene can't be instantiated!", false, true)

func _on_lvl_mouse_entered(lvl_path: String) -> void:
	var lvl_button: TextureButton = get_node(lvl_path) as TextureButton
	lvl_button.show_dice()

func _on_lvl_mouse_exited(lvl_path: String) -> void:
	var lvl_button: TextureButton = get_node(lvl_path) as TextureButton
	lvl_button.hide_dice()

func _notification(what: int) -> void:
	if (what == MainLoop.NOTIFICATION_WM_QUIT_REQUEST):
		_on_Quit_pressed()

func _on_Quit_pressed() -> void:
	print("levels will be freed")
	LevelsNode.queue_free()
	get_tree().quit()
