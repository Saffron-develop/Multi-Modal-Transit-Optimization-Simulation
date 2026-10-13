extends Node2D

var nodes: Array = []
var edges: Dictionary = {}

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
		for edge in edges[node]:
			if not edges[edge].has(node):
				edges[edge].append(node)
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
