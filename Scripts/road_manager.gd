extends Node2D

var nodes: Array = []
var edges: Dictionary = {}
var access_nodes: Dictionary = {}
var node_id: Dictionary = {}
var id_node: Dictionary = {}

class RoadAStar extends AStar2D:
	var edge_costs: Dictionary = {}
	var manager

	func _init(road_manager: Node2D):
		manager = road_manager

	func get_edge_cost(from_id: int, to_id: int) -> float:
		var from_node
		var to_node
		if from_id in manager.id_node and to_id in manager.id_node:
			from_node = manager.id_node[from_id]
			to_node = manager.id_node[to_id]
		else:
			return 0

		var road_vector : Vector2 = to_node - from_node
		var road_length = road_vector.length()
		
		return road_length


	func set_edge_cost(from_id: int, to_id: int) -> void:
		var road_length = get_edge_cost(from_id, to_id)

		edge_costs[Vector2i(from_id, to_id)] = road_length

	func _compute_cost(from_id: int, to_id: int) -> float:
		var pair = Vector2i(from_id, to_id)
		if edge_costs.has(pair):
			return edge_costs[pair]
		
		var from_node
		var to_node
		if from_id in manager.id_node and to_id in manager.id_node:
			return manager.id_node[from_id].distance_to(manager.id_node[to_id])
		else:
			return 0

var grid = RoadAStar.new(self)

func _ready() -> void:
	bake_roads()

func bake_roads() -> void:
	var children = get_children()
	var process_progress: int = 0
	print("Starting road baking...")

	for child in children:
		print(str("Progress: ", process_progress, "/", len(children)))
		var data = child.process_node()
		
		nodes.append(data["position"])
		edges[data["position"]] = data["connected_nodes"]

		child.queue_free()

		process_progress += 1

	print("Confriming road connections...")
	process_progress = 0
	for node in nodes:

		print(str("Progress: ", process_progress, "/", len(nodes)))
		grid.add_point(process_progress, node)
		node_id[node] = process_progress
		id_node[process_progress] = node

		for edge in edges[node]:
			if not edges[edge].has(node):
				edges[edge].append(node)

			if edge in node_id:
				grid.set_edge_cost(node_id[node], node_id[edge])
				grid.connect_points(node_id[node], node_id[edge], true)

		process_progress += 1

	queue_redraw()
	print(edges)

func _draw() -> void:
	# var edge_queue = edges.duplicate(true)
	# for node in nodes:
	# 	for edge in edge_queue[node]:
	# 		draw_line(node, edge, Color(.7, .7, .7), 80)
	# 		edge_queue[edge].erase(node)
	for node in nodes:
		draw_circle(node, 40, Color(.7, .7, .7))
		for edge in edges[node]:
			draw_line(node, edge, Color(0.7, 0.7, 0.7), 80)

	for node in nodes:
		draw_circle(node, 8, Color(1, 1, 1))
		for edge in edges[node]:
			draw_line(node, edge, Color(1, 1, 1), 16)



# func find_path() -> Array[Vector2]:
# 	grid.
