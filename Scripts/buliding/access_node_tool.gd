@tool
extends Marker2D

var waiting_for_selection: bool = false

@export_tool_button("Connect to Edge") var connect_to_edge = func _connect_to_edge() -> void:
	waiting_for_selection = true


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if Engine.is_editor_hint() and waiting_for_selection:
		var selected_nodes = EditorInterface.get_selection().get_selected_nodes()

		if not selected_nodes.size() == 2:
			print("waiting for two nodes")
			return

		if not selected_nodes[0].is_in_group("road_marker") or not selected_nodes[1].is_in_group("road_marker"):
			print("waiting for road nodes")
			return
		
		var node_a = selected_nodes[0].global_position
		var node_b = selected_nodes[1].global_position
		var buidling_pos = get_parent().global_position
		var above = 1

		#step 1, check if vertical or horizontal
		if node_a.x == node_b.x:
			global_position.x = node_a.x
			waiting_for_selection = false
			return

		if node_a.y == node_b.y:
			global_position.y = node_a.y
			waiting_for_selection = false
			return

		#step 2, find slope of road and perpendicular slope
		var road_slope = (node_a.y - node_b.y) / (node_a.x - node_b.x)
		var perpendicular_slope = -(1 / road_slope)

		#step 3, find y-intercept and perpendicular y-intercept
		var road_intercept = node_a.y - (road_slope * node_a.x)
		var perpendicular_intercept = buidling_pos.y - (perpendicular_slope * buidling_pos.x)

		#step 4, solves the systems of equation for the two lines to find where they intersect
		var x_value = (perpendicular_intercept-road_intercept)/(road_slope-perpendicular_slope)
		var y_value = ((road_slope*perpendicular_intercept)-(perpendicular_slope * road_intercept))/(road_slope-perpendicular_slope)
		var intersection_point = Vector2(x_value, y_value)
	
		print(intersection_point)
		global_position = intersection_point

		waiting_for_selection = false
