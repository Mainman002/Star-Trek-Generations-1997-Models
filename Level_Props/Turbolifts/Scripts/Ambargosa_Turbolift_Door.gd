extends Node3D

var door_open: bool = false

@onready var animation_player: AnimationPlayer = $Ambargosa_Station_Turbolift_Door/AnimationPlayer


func _ready() -> void:
	close_door()


func interact( _floor:int ) -> void:
	match door_open:
		false:
			open_door()
		true:
			close_door()


func open_door() -> void:
	change_animation( true )


func close_door() -> void:
	change_animation( false )


func change_animation( _door_open:bool ) -> void:
	if not animation_player.is_playing():
		if not _door_open:
			if door_open:
				animation_player.play("Door_Close")
				door_open = false
		else:
			if not door_open:
				animation_player.play("Door_Open")
				door_open = true
