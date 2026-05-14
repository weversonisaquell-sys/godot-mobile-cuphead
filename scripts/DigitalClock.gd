extends Control

var time_zones = {
	"UTC": 0,
	"EST": -5,
	"CST": -6,
	"MST": -7,
	"PST": -8,
	"GMT": 0,
	"CET": 1,
	"EET": 2,
	"IST": 5.5,
	"JST": 9,
	"AEST": 10,
	"NZST": 12,
	"BRT": -3
}

var clock_labels = {}
var update_timer = 0.0
var update_interval = 0.1

func _ready():
	create_clock_displays()

func _process(delta):
	update_timer += delta
	if update_timer >= update_interval:
		update_timer = 0.0
		update_all_clocks()

func create_clock_displays():
	var vbox = VBoxContainer.new()
	vbox.anchor_left = 0.5
	vbox.anchor_top = 0.5
	vbox.anchor_right = 0.5
	vbox.anchor_bottom = 0.5
	vbox.offset_left = -150
	vbox.offset_top = -200
	vbox.offset_right = 150
	vbox.offset_bottom = 200
	add_child(vbox)
	
	for timezone_name in time_zones.keys():
		var hbox = HBoxContainer.new()
		hbox.custom_minimum_size = Vector2(300, 40)
		vbox.add_child(hbox)
		
		var label_name = Label.new()
		label_name.text = timezone_name
		label_name.custom_minimum_size = Vector2(80, 40)
		hbox.add_child(label_name)
		
		var label_time = Label.new()
		label_time.text = "00:00:00"
		label_time.custom_minimum_size = Vector2(150, 40)
		hbox.add_child(label_time)
		
		clock_labels[timezone_name] = label_time

func update_all_clocks():
	var current_time = Time.get_ticks_msec() / 1000.0
	var utc_dict = Time.get_time_dict_from_system()
	
	for timezone_name in time_zones.keys():
		var offset = time_zones[timezone_name]
		var local_time = get_time_with_offset(utc_dict, offset)
		var formatted_time = format_time(local_time)
		clock_labels[timezone_name].text = formatted_time

func get_time_with_offset(utc_dict: Dictionary, offset_hours: float) -> Dictionary:
	var total_seconds = utc_dict.hour * 3600 + utc_dict.minute * 60 + utc_dict.second
	total_seconds += int(offset_hours * 3600)
	
	if total_seconds < 0:
		total_seconds += 86400
	elif total_seconds >= 86400:
		total_seconds -= 86400
	
	var hour = (total_seconds / 3600) % 24
	var minute = (total_seconds % 3600) / 60
	var second = total_seconds % 60
	
	return {
		"hour": hour,
		"minute": minute,
		"second": second
	}

func format_time(time_dict: Dictionary) -> String:
	var hour = int(time_dict.hour)
	var minute = int(time_dict.minute)
	var second = int(time_dict.second)
	
	var hour_str = str(hour).pad_zeros(2)
	var minute_str = str(minute).pad_zeros(2)
	var second_str = str(second).pad_zeros(2)
	
	return "%s:%s:%s" % [hour_str, minute_str, second_str]

func add_timezone(name: String, offset: float):
	if name not in time_zones:
		time_zones[name] = offset

func remove_timezone(name: String):
	if name in time_zones:
		time_zones.erase(name)
