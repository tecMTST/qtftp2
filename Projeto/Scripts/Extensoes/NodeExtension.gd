class_name NodeExtension

static func filter_children(node: Node, condition: Callable) -> Array:
	var children = []
	
	if condition.call(node):
		children.append(node)
	
	for child in node.get_children(true):
		if child.get_children(true).size() > 0:
			var child_children = NodeExtension.filter_children(child, condition)
			
			for child_child in child_children:
				children.append(child_child)
		elif condition.call(child):
			children.append(child)
	
	return children

static func find_first_child(node: Node, condition: Callable) -> Node:
	for child in node.get_children(true):
		if condition.call(child):
			return child
		
		if child.get_children(true).size() > 0:
			var child_first_child = NodeExtension.find_first_child(child, condition)
			
			if child_first_child != null:
				return child_first_child
	
	return null
