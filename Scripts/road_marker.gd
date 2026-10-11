@tool
extends Marker2D

var road_marker_scene: PackedScene = preload("res://Scenes/road_marker.tscn")
var old_selection: Marker2D
var connecting: bool = false
@export var connected_nodes: Array[Marker2D] = []

@export_tool_button("Create connected node") var create_connection = func _create_connected_node() -> void:
	var new_marker = road_marker_scene.instantiate()
	new_marker.position = self.position + Vector2(100, 0)
	get_parent().add_child(new_marker)
	new_marker.owner = get_tree().edited_scene_root
	connected_nodes.append(new_marker)
	new_marker.connected_nodes.append(self)

@export_tool_button("Connect nodes") var _connect_nodes = func _connect_nodes() -> void:
	var selected_nodes = EditorInterface.get_selection().get_selected_nodes()
	if selected_nodes.size() > 1:
		return

	if not selected_nodes.has(self):
		return

	old_selection = selected_nodes[0]
	connecting = true
			

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
