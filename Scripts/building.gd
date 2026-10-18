extends Node2D
class_name Building

enum BUILDING_TYPES {
	residence,
	commercial,
	industrial
}

@export var building_type: BUILDING_TYPES = BUILDING_TYPES.residence
@export var car_capacity: int = 100

var people_count: int = 0


@export_category("References")
@export var access_node: Marker2D

func building_info():
	return {
		"Building Type": building_type,
		"Car Capacity": car_capacity,
		"People Count": people_count
	}