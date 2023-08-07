extends TileMap

var switches = []
# Called when the node enters the scene tree for the first time.
func _ready():
	for x in range(self.get_used_rect().size.x):
		for y in range(self.get_used_rect().size.y):
			var world_pos = Vector2i(x * self.tile_set.tile_size.x + 8, y * self.tile_set.tile_size.y + 8)
			var cell_pos = self.local_to_map(world_pos)
			var type_data = self.get_tile_data(world_pos, 'type') 
			if type_data && type_data.type == 'switch':
				var source_id = self.get_cell_source_id(0, cell_pos, false)
				switches.append({'world_pos': world_pos, 'local_pos': cell_pos, 'data': type_data, 'source_id': source_id})

func get_tile_data(world_pos,layer):
	var pos = self.local_to_map(world_pos)
	var source_id = self.get_cell_source_id(0, pos, false)
	var get_tile_pos = self.get_cell_atlas_coords(0, pos, false)
	if source_id == -1: return 0
	var source = self.tile_set.get_source(source_id)
	var data = source.get_tile_data(get_tile_pos, 0).get_custom_data(layer)
	return data

func change_switches():
	for switch in switches:
		var timer = Timer.new()
		await get_tree().create_timer(0.5).timeout
		self.set_cell(0, switch.local_pos, switch.source_id, switch.data.linked_switch_pos )
	self.force_update()
