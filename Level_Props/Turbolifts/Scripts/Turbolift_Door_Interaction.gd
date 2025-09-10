extends Area3D

@export var toggle:bool = false
@export_range(0, 1, 1.0) var current_floor:int

var locked:bool = false

@warning_ignore("unused_signal")
signal call_turbolift(current_floor:int)

@warning_ignore("unused_signal")
signal interact(current_floor:int)

@warning_ignore("unused_signal")
signal interact_toggle()

@warning_ignore("unused_signal")
signal left_interact

var can_interact:bool = false

func _ready() -> void:
	connect("body_entered", area_entered)
	connect("body_exited", area_exited)
	$Interact_Label3D.visible = false


func _input(_event: InputEvent) -> void:
	if not (can_interact and not locked):
		return

	if Input.is_action_just_pressed("interact"):
		if toggle: emit_signal("interact_toggle")
		else: emit_signal("interact", current_floor)


func area_entered( _body ) -> void:
	if _body.is_in_group("PlayerCharacter"):
		_body.jumpLock = true
		can_interact = true
		$Interact_Label3D.visible = true
		emit_signal("call_turbolift", current_floor)


func area_exited( _body ) -> void:
	if _body.is_in_group("PlayerCharacter"):
		_body.jumpLock = false
		can_interact = false
		$Interact_Label3D.visible = false
		emit_signal("left_interact")
