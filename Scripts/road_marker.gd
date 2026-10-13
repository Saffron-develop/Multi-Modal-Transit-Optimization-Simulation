@tool
extends Marker2D

var road_marker_scene: PackedScene = preload("res://Scenes/road_marker.tscn")
var old_selection: Marker2D
var connecting: bool = false
@export var connected_nodes: Array[Marker2D] = []

@export_tool_button("Create connected node right") var create_connection_right = func _create_connected_node_right() -> void:
	var new_marker = road_marker_scene.instantiate()
	new_marker.position = self.position + Vector2(100, 0)
	get_parent().add_child(new_marker)
	new_marker.owner = get_tree().edited_scene_root
	connected_nodes.append(new_marker)
	new_marker.connected_nodes.append(self)

@export_tool_button("Create connected node up") var create_connection_up = func _create_connected_node_up() -> void:
	var new_marker = road_marker_scene.instantiate()
	new_marker.position = self.position + Vector2(0, -100)
	get_parent().add_child(new_marker)
	new_marker.owner = get_tree().edited_scene_root
	connected_nodes.append(new_marker)
	new_marker.connected_nodes.append(self)

@export_tool_button("Connect nodes") var connect_nodes = func _connect_nodes() -> void:
	var selected_nodes = EditorInterface.get_selection().get_selected_nodes()
	if selected_nodes.size() > 1:
		return

	if not selected_nodes.has(self):
		return

	old_selection = selected_nodes[0]
	connecting = true
			

@export_tool_button("Delete node") var delete_node = func _delete_node() -> void:
	for node in connected_nodes:
		if node.connected_nodes.size() == 1:
			node.queue_free()
		else:
			node.connected_nodes.erase(self)
	queue_free()

func process_node() -> Dictionary:
	var dict = {
		"position" = self.global_position,
		"connected_nodes" = []
	}

	for node in connected_nodes:
		if node:
			dict["connected_nodes"].append(node.global_position)

	return dict

func _process(delta: float) -> void:
	if not Engine.is_editor_hint():
		return

	if connecting:
		var selected_nodes = EditorInterface.get_selection().get_selected_nodes()
		if selected_nodes.size() > 1:
			return

		if not selected_nodes[0] is Marker2D:
			return

		if not selected_nodes[0] == old_selection:
			connected_nodes.append(selected_nodes[0])
			selected_nodes[0].connected_nodes.append(self)
			
			connecting = false
