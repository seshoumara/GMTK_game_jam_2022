extends Node2D

export (NodePath) var UI_Path: NodePath
onready var UI_Node: ColorRect = get_node(UI_Path) as ColorRect
export (NodePath) var WorldPath: NodePath
onready var WorldNode: TileMap = get_node(WorldPath) as TileMap

func _ready() -> void:
	get_tree().set_auto_accept_quit(true)
	Global.logger.log_info("Current level: " + str(Global.level_to_load), false)
	if UI_Node.connect("reset_world", self, "_on_world_reset") != OK:
		Global.logger.log_error("unable to connect 'reset_world' to sefl!", false, true)
	load_level()

func load_level() -> void:
	var difficulty_tile: int = Global.level_data[Global.level_to_load].get_difficulty_tile()
	UI_Node.set_dice_texture(Global.get_tile_texture(WorldNode, difficulty_tile))
	UI_Node.set_level_name(Global.level_data[Global.level_to_load].name)
	UI_Node.update_moves(0)
	var offset: Vector2 = Vector2(0, 0)
	offset.x = (Global.window_size.x / 2.0) - ((Global.level_data[Global.level_to_load].width * Global.cell_size.x) / 2.0)
	offset.y = ((Global.window_size.y - UI_Node.height) / 2.0) - ((Global.level_data[Global.level_to_load].height * Global.cell_size.y) / 2.0)
	var offset_col: int = int(offset.x / Global.cell_size.x)
	var offset_row: int = int(offset.y / Global.cell_size.y)
	for col in range(Global.level_data[Global.level_to_load].width):
		for row in range(Global.level_data[Global.level_to_load].height):
			WorldNode.set_cell(offset_col + col, offset_row + row, Global.TILE.EXTERIOR)
			var cell_tile: int = Global.CELL_TILE_MAPPING[Global.level_data[Global.level_to_load].map[row].substr(col, 1)]
			WorldNode.set_cell(offset_col + col, offset_row + row, cell_tile)

func _on_world_reset():
	load_level()
