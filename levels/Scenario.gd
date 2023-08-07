extends Node2D

var OPENAI_API_KEY = "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"
signal scenario_ready
signal finished
func _ready():
	%Player.can_move =false

func start_level(content):
	print("starting new level")
	self.run_scenario(content)

func run_scenario(content):
	var dialog = AcceptDialog.new()
	dialog.dialog_autowrap = true
	dialog.min_size = Vector2(600, 400)
	add_child(dialog)
	dialog.dialog_text = content["pre_text"]
	dialog.popup_centered()
	print("dialogue up")
	await dialog.confirmed
	print("dialogue confirmed")
	var pull_switch_group = content["pull_switch_choice"]
	var dont_pull_switch_group = content["dont_pull_switch_choice"]
	%DecisionPopup.character_text_pull_switch = pull_switch_group["character_details"] 
	%DecisionPopup.character_pull_switch_name = pull_switch_group["character_text"]
	
	%DecisionPopup.character_text_dont_pull_switch = dont_pull_switch_group["character_details"]  
	%DecisionPopup.character_dont_pull_switch_name = dont_pull_switch_group["character_text"]

	%DecisionPopup.update()
	%Player.can_move = true
	await %Player.finished_track

	var killed_group =  dont_pull_switch_group
	if %DecisionPopup.pull_switch: killed_group = pull_switch_group
	var impact = killed_group["main_character_impact"]
	dialog.dialog_text = "{aftermath} \n\n {impact}".format({
		"aftermath": killed_group["aftermath_text"], 
		"impact": impact["impact_text"] 
	})
	dialog.popup_centered()
	
	await dialog.confirmed	
	# wait for the player to complete the level.
	emit_signal("finished")

