extends Area2D

# Requires a unique tilemap called RailRoad
# requires a unique PopOpPanel called DescisionPanel
# this should be refactored to be `required exported vars` for better modularity... but ehhh 

var animation_speed = 2
var moving = false
var can_move = true
var tile_size = 16
var last_tile_pos;
signal finished_track


func _ready():
	position = position.snapped(Vector2.ONE * tile_size)
	position += Vector2.ONE * tile_size / 2

func _process(delta):
	if moving or !self.can_move: return
	
	var event = %Railroad.get_tile_data(self.global_position, 'event')
	var dir = Vector2(%Railroad.get_tile_data(self.global_position, 'dir'))
	parse_event(event)
	move(dir)
	self.last_tile_pos = self.get_tile_pos()

func parse_event(event: String):
	match (event):
		"decision":
			if self.last_tile_pos == self.get_tile_pos(): return 
			self.can_move = false
			%DecisionPopup.popup_centered()
			await Signal(%DecisionPopup, 'popup_hide')
			if %DecisionPopup.pull_switch: %Railroad.change_switches()
			self.can_move = true
		"stop":
			emit_signal("finished_track")
		_:
			pass

func get_tile_pos():
	var player_pos = %Railroad.local_to_map(self.global_position)
	var source_id = %Railroad.get_cell_source_id(0, player_pos, false)
	var get_tile_pos = %Railroad.get_cell_atlas_coords(0, player_pos, false)
	return get_tile_pos

func move(dir):
	if !dir or !self.can_move: return
	
	var tween = get_tree().create_tween()
	tween.tween_property(self, "position", position + dir * tile_size, 0.54).set_trans(Tween.TRANS_LINEAR)

	moving = true
	$AnimationPlayer.play('down')
	await tween.finished
	moving = false
