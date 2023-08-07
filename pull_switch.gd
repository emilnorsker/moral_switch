extends Button


var char_name = "person"
# Called when the node enters the scene tree for the first time.
func _ready():
	self.text = "Do nothing.. (kills {1})".format({'1': self.char_name})

func update():
	self.text = "Pull the switch (kill {1})".format({'1': self.char_name})

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
