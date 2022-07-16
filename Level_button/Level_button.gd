extends TextureButton

export (NodePath) var NamePath: NodePath
onready var NameNode: Label = get_node(NamePath) as Label
export (NodePath) var DicePath: NodePath
onready var DiceNode: TextureRect = get_node(DicePath) as TextureRect

func set_button_text(_text: String) -> void:
	NameNode.text = _text

func set_dice_texture(_texture: ImageTexture) -> void:
	DiceNode.texture = _texture

func show_dice() -> void:
	DiceNode.visible = true

func hide_dice() -> void:
	DiceNode.visible = false
