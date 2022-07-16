extends Node

var DEBUG_MODE: bool = OS.is_debug_build()
var logger: Logger = Logger.new()
#unfortunately many scene nodes hardcoded the size from the project settings!!
var window_size: Vector2

#modifying this won't work, it's hardcoded in the tilemaps present in the game!!
const cell_size: Vector2 = Vector2(32, 32)
const TILE: Dictionary = {
	"FLOOR": 0,
	"START_1": 1,
	"START_2": 2,
	"START_3": 3,
	"START_4": 4,
	"START_5": 5,
	"START_6": 6,
	"GOAL_1": 7,
	"GOAL_2": 8,
	"GOAL_3": 9,
	"GOAL_4": 10,
	"GOAL_5": 11,
	"GOAL_6": 12,
	"SOLVED_1": 13,
	"SOLVED_2": 14,
	"SOLVED_3": 15,
	"SOLVED_4": 16,
	"SOLVED_5": 17,
	"SOLVED_6": 18,
	"WALL_TL": 19,
	"WALL_TC": 20,
	"WALL_TR": 21,
	"WALL_ML": 22,
	"WALL_MR": 23,
	"WALL_BL": 24,
	"WALL_BC": 25,
	"WALL_BR": 26,
	"EXTERIOR": 27,
	"PLAYER_D2": 28
}

#don't set a difficulty higher than 6 because the dice tile won't exist!
class Level:
	var id: int = -1
	var name: String = ""
	var difficulty: int = -1
	var width: int = -1
	var height: int = -1
	var map: PoolStringArray
	
	func _init(_id: int, _name: String, _difficulty: int, _width: int, _height: int, _map: PoolStringArray):
		id = _id
		name = _name
		difficulty = _difficulty
		if _difficulty < 1:
			difficulty = 1
		elif _difficulty > 6:
			difficulty = 6
		width = _width
		height = _height
		map = _map
	
	func get_difficulty_tile() -> int:
		match difficulty:
			1: return TILE.SOLVED_1
			2: return TILE.SOLVED_2
			3: return TILE.SOLVED_3
			4: return TILE.SOLVED_4
			5: return TILE.SOLVED_5
			6: return TILE.SOLVED_6
		return -1

var level_to_load: int = -1
var level_data: Array = []

const CELL_TILE_MAPPING: Dictionary = {
	".": TILE.EXTERIOR,
	">": TILE.WALL_TL,
	"T": TILE.WALL_TC,
	"<": TILE.WALL_TR,
	"L": TILE.WALL_ML,
	"R": TILE.WALL_MR,
	"\\": TILE.WALL_BL,
	"B": TILE.WALL_BC,
	"/": TILE.WALL_BR,
	" ": TILE.FLOOR,
	"@": TILE.PLAYER_D2,
	"1": TILE.START_1,
	"2": TILE.START_2,
	"3": TILE.START_3,
	"4": TILE.START_4,
	"5": TILE.START_5,
	"6": TILE.START_6,
	"a": TILE.GOAL_1,
	"b": TILE.GOAL_2,
	"c": TILE.GOAL_3,
	"d": TILE.GOAL_4,
	"e": TILE.GOAL_5,
	"f": TILE.GOAL_6
}

var tutorial_1: Level = Level.new(0, "Tutorial 1", 1, 7, 5, PoolStringArray([
">TTTTT<",
"L@    R",
"L  1  R",
"L    aR",
"\\BBBBB/"
]))
var tutorial_2: Level = Level.new(1, "Tutorial 2", 2, 7, 6, PoolStringArray([
">TTTTT<",
"L@    R",
"L  1  R",
"L  2  R",
"La   bR",
"\\BBBBB/"
]))

func _ready() -> void:
	window_size = get_viewport().size
	level_data.push_back(tutorial_1)
	level_data.push_back(tutorial_2)

#UTILS
func get_path_as_string(path: NodePath) -> String:
	var path_string = ""
	for idx in range(path.get_name_count()):
		path_string += path.get_name(idx)
	return path_string

func get_tile_texture(tile_map: TileMap, ID: int) -> ImageTexture:
	var tile_set: TileSet = tile_map.tile_set
	var full_img: Image = tile_set.tile_get_texture(ID).get_data()
	var tile_pos: Rect2 = tile_set.tile_get_region(ID)
	var tile_img: Image = Image.new()
	tile_img.create(int(cell_size.x), int(cell_size.y), false, full_img.get_format())
	tile_img.blit_rect(full_img, tile_pos, Vector2(0, 0))
	var tile_texture: ImageTexture = ImageTexture.new()
	tile_texture.create_from_image(tile_img)
	return tile_texture

#parapixel from Godot Discord server: works with autotiles/atlastiles too
#func tileset_get_tile_texture(tile_set: TileSet, tile_id: int, autotile_coords := Vector2.ZERO) -> ImageTexture:
	#var image_texture := ImageTexture.new()
	#if not tile_id in tile_set.get_tiles_ids():
		#return image_texture
	#var image: Image = tile_set.tile_get_texture(tile_id).get_data()
	#var region: Rect2 = tile_set.tile_get_region(tile_id)
	#var cell_size: Vector2 = tile_set.autotile_get_size(tile_id)
	#var tile_image := Image.new()
	#tile_image.create(int(cell_size.x), int(cell_size.y), false, image.get_format())
	#tile_image.blit_rect(image, Rect2(region.position + autotile_coords * cell_size, cell_size), Vector2.ZERO)
	#image_texture.create_from_image(tile_image)
	#return image_texture
