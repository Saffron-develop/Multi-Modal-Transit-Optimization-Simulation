@tool
extends Node2D

@export var road_manager: Node2D

func _draw() -> void:
	if not road_manager or not Engine.is_editor_hint():
		return
	var nodes = road_manager.get_children()

	if len(nodes) <= 1:
		return

	for node in nodes:
		var data_dict = node.process_node()
		
		for connected_node in data_dict["connected_nodes"]:
			draw_line(data_dict["position"], connected_node, Color(0, 0, 1), 10)

func _process(delta: float) -> void:
	if Engine.is_editor_hint():
		queue_redraw()