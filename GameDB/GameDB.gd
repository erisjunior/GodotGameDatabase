extends Node

var values = {}
var regex = null

func _ready() -> void:
	regex = RegEx.new()
	regex.compile("%(?P<key>.*?)%")

func save_data(name = "save"):
	var file = File.new()
	file.open(get_file_path(name), file.WRITE)
	file.store_var(values)
	file.close()

func load_data(name = "save"):
	var file = File.new()
	if !file.file_exists(get_file_path(name)):
		return false

	file.open(get_file_path(name), file.READ)
	var result = file.get_var()
	file.close()

	if !result:
		return false

	values = result
	return true

func get_file_path(name):
	return 'user://' + str(name)

func parse_str(string):
	var results = regex.search_all(string)
	if !results:
		return string

	for result in results:
		string = string.replace(
			result.get_string(),
			str(get(result.get_string('key')))
		)
	
	return string

func set(key, value):
	values[key] = value

func get(key, default = null):
	if values.has(key):
		return values[key]
	return default

func increment(key, amount = 1):
	if values.has(key):
		values[key] += amount
	else:
		set(key, amount)

func decrement(key, amount = 1):
	if values.has(key):
		values[key] -= amount
	else:
		set(key, -amount)

func toggle(key):
	if values.has(key):
		if values[key]:
			set(key, false)
		else:
			set(key, true)