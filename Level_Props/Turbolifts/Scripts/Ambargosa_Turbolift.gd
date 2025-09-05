extends Node3D

@export var locked:bool = false
@export_range(0, 1, 1) var current_floor:int = 0
@export var labels:Array[Node]
@export var interact_areas:Array[Node]

var can_interact:bool = false
var silent_move:bool = false
var current_door:int = -1
var target_y: float = 0.0
var move_speed: float = 2.0

@onready var turbolift: Node3D = $Ambargosa_Station_Turbolift
@onready var door_1: Node3D = $Ambargosa_Turbolift_Door
@onready var door_2: Node3D = $Ambargosa_Turbolift_Door2
@onready var floor1_marker: Marker3D = $"1st_floor_M3D"
@onready var floor2_marker: Marker3D = $"2nd_floor_M3D"


func _ready() -> void:
	for _label in labels:
		if locked: _label.text = "Locked"
		else: _label.text = "Interact"

	for _interact_areas in interact_areas:
		if locked: _interact_areas.locked = true
		else: _interact_areas.locked = false

	#current_door = current_floor
	set_floor(current_floor)


func _process(delta: float) -> void:
	if abs(turbolift.position.y - target_y) > 0.02:
		turbolift.position.y = lerp(turbolift.position.y, target_y, delta * move_speed)
	else:
		turbolift.position.y = target_y
		_on_reached_floor(current_floor)


func interact_toggle() -> void:
	if can_interact and not locked:
		can_interact = false
		match current_floor:
			0: change_floor(1)
			1: change_floor(0)


func interact( _floor:int ) -> void:
	if can_interact and not locked:
		can_interact = false
		current_floor = _floor
		match current_floor:
			0:
				change_floor(1)
				door_2.open_door()
			1:
				change_floor(0)
				door_1.open_door()


func call_turbolift( _floor:int ) -> void:
	if can_interact and not locked:
		silent_move = true
		can_interact = false
		current_floor = _floor
		match current_floor:
			0:
				change_floor(1)
			1:
				change_floor(0)


func set_floor(_floor: int) -> void:
	current_floor = _floor
	#current_door = _floor
	match _floor:
		0: target_y = floor1_marker.position.y
		1: target_y = floor2_marker.position.y


func change_floor(_floor: int) -> void:
	if current_floor != _floor:
		set_floor(_floor)


func _on_reached_floor(_floor: int) -> void:
	if not current_door == _floor:
		if not locked:
			match _floor:
				0:
					if not silent_move:
						door_1.open_door()
					door_2.close_door()
				1:
					door_1.close_door()
					if not silent_move:
						door_2.open_door()

		current_door = _floor
	can_interact = true
	silent_move = false
