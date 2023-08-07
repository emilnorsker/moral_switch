extends PopupPanel

@export var pull_switch = false
@export var character_image_1 = Texture2D
@export var character_image_2 = Texture2D
var character_text_pull_switch = ""
var character_text_dont_pull_switch = ""
var character_pull_switch_name = ""
var character_dont_pull_switch_name = ""

# connected to the two buttons in the scene,
# they will either emit true or false depending 
# on who to save
func _on_button_button_up(pull_switch):
	self.pull_switch = pull_switch
	print("pulling: ",pull_switch)
	self.hide()

func update():
	%character_text_pull_switch.text = self.character_text_pull_switch
	%character_text_dont_pull_switch.text = self.character_text_dont_pull_switch
	%dont_pull.char_name = character_pull_switch_name
	%pull_switch.char_name = character_dont_pull_switch_name
	%dont_pull.update()
	%pull_switch.update()

func _ready():
	%character_image_1.texture = character_image_1
