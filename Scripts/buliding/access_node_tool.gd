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
		var above = false

		#step 1, check if vertical
		if node_a.x == node_b.x:
			if global_position.x < node_a.x:
				above = true
		#step 2, find slope of road
		var road_slope = (node_a.y - node_b.y) / (node_a.x - node_b.x)

		#step 3, find y-intercept
		var road_intercept = node_a.y - (road_slope * node_a.x)

		#step 4, plug in x of access into slope formula
		var access_point_line_height = (road_slope * global_position.x) + road_intercept

		#step 5, compare resulting y to access y
		if access_point_line_height >= global_position.y:
			above = true

		if above:
			print("point is above")
		else:
			print("point is below")

		#step 6, find perpendicular slope and place access there.
		var perpendicular_slope = 1 / road_slope
		if above:
			global_position = Vector2(node_a.x - 100, (perpendicular_slope * 100) + node_a.y)
		else:
			global_position = Vector2(node_a.x - 100, (perpendicular_slope * -100) + node_a.y)

		
		print("node a: ", selected_nodes[0], "  node b: ", selected_nodes[1])

		waiting_for_selection = false
