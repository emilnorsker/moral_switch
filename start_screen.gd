extends Control

var OPENAI_API_KEY = "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"
signal scenario_ready
var level_scene = preload("res://levels/Scenario.tscn")

func _ready():
	# TODO: if this is the first scenario - make two calls. otherwise do only one call.
	var http_request = HTTPRequest.new()
	add_child(http_request)
	request_scenario(http_request)
	var level = level_scene.instantiate()
	add_child(level)
	# TODO: pop up loading script 
	var content = await self.scenario_ready
	level.start_level(content)
	# start level
	while true:
		request_scenario(http_request)
		var new_content = await self.scenario_ready
		await level.finished
		level.hide()
		level.queue_free()
		await get_tree().create_timer(0.5).timeout
		level_scene = load("res://levels/Scenario.tscn")
		level = level_scene.instantiate()
		add_child(level)
		level.start_level(new_content)
		


func request_scenario(http_request):
	print("requesting scenrario")
	var url = "https://api.openai.com/v1/chat/completions"
	var data_to_send = {
	"model": "gpt-3.5-turbo",
	"messages": [
	  {
		"role": "system",
		"content": """
		The ai will generate a single trolley dilemma where two different ethical theories compete, 
for the scenario i need two character groups. Each character group should be highly described and there is a high amount of emotional emphasis on the description. It should be as appealing as possible to  save either group / thus making it a very difficult choice.
there can be 1-4 people in each group. The scenario should always take place on a railroad and the player can only pull a switch or not pull it.

The main character is a utilitarian and the impact on health should be based on this theory, where a choice that aligns more with utilitarianism have a better positive impact and a choice that is against have a negative impact.

the result should be formatted like this:
```json
{ 
"scenario_name": <name of the scenario>,
"pre_text": <text explaining the current scenario, what is happening why is it important for the main character to pull or not pull the switch>,
"pull_switch_choice" : {
 "character_text": <text describing the group targetted in this choice>, 
"character_details": <details of each chracter in this group, about 4 sentences>,
"theory": <the name of the theory>, 
 "aftermath_text" : <text explaining the aftermath of the choice>, 
 "main_character_impact":  { "health_impact": < integer between -1 and 1>, "impact_text": 
   <text explaining why the character lost, stayed at the same amount or gained mental health>}
},
"dont_pull_switch_choice" : {
 "character_text": <text describing the group targetted in this choice>, 
 "theory": <the name of the theory>, 
 "character_details": <details of each chracter in this group, about 4 sentences>,
 "aftermath_text" : <text explaining the aftermath of the choice>, 
 "main_character_impact":  { "health_impact": < integer between -1 and 1>, "impact_text": 
   <text explaining why the character lost, stayed at the same amount or gained mental health>}
}
}
```
the answers is always in json and only json. it should be formatted.
		
		"""
	  },
	  {
		"role": "user",
		"content": "Generate a scenario for me"
	  }
	]
  }
	var json = JSON.stringify(data_to_send)
	var headers = ["Content-Type: application/json", "Authorization: Bearer {key}".format({'key': OPENAI_API_KEY})]	
	http_request.request(url, headers, HTTPClient.METHOD_POST, json)
	http_request.request_completed.connect(_on_request_completed)
	

func _on_request_completed(result, response_code, headers, body):
	print("request_completed")
	var json = JSON.parse_string(body.get_string_from_utf8())
	var content = "{1}".format({'1':json["choices"][0]["message"]["content"]})
	content = JSON.parse_string(content)
	if !content: print(content)
	emit_signal('scenario_ready', content)
	
