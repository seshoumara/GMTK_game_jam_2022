extends ColorRect

#this is hardcoded in the editor for all the UI child nodes!!
const height: int = 50

signal reset_world()

export (NodePath) var LevelNamePath: NodePath
onready var LevelNameNode: Label = get_node(LevelNamePath) as Label
export (NodePath) var MovesPath: NodePath
onready var MovesNode: Label = get_node(MovesPath) as Label
export (NodePath) var DicePath: NodePath
onready var DiceNode: TextureRect = get_node(DicePath) as TextureRect

func set_dice_texture(texture: ImageTexture) -> void:
	DiceNode.texture = texture

func set_level_name(name: String) -> void:
	LevelNameNode.text = name

func update_moves(value: int) -> void:
	MovesNode.text = str(value)

func _on_Reset_pressed() -> void:
	emit_signal("reset_world")

func _on_Levels_pressed() -> void:
	if get_tree().change_scene("res://Level_map/Level_map.tscn") != OK:
		Global.logger.log_error("either scene path can't be loaded, or the scene can't be instantiated!", false, true)
