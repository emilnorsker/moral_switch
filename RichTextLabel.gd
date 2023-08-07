extends RichTextLabel

var OPENAI_API_KEY = "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"

func _ready():
	var http_request = HTTPRequest.new()
	add_child(http_request)
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
 "theory": <the name of the theory>, 
 "aftermath_text" : <text explaining the aftermath of the choice>, 
 "main_character_impact":  { "health_impact": < integer between -1 and 1>, "impact_text": 
   <text explaining why the character lost, stayed at the same amount or gained mental health>}
},
"dont_pull_switch_choice" : {
 "character_text": <text describing the group targetted in this choice>, 
 "theory": <the name of the theory>, 
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
	var json = JSON.parse_string(body.get_string_from_utf8())
	var content = json["choices"][0]["message"]["content"]
	print(content)
	self.text = "{1}".format({'1': content})
