extends SaveElementBase
class_name SaveElement2D

func Serialize() -> SaveFileNode:	
	var parent = get_parent()	
	var result := SaveFileNode.new()	
	result.NodeTreePath = parent.get_path()
	result.ParentTreePath = parent.get_parent().get_path()
	var script = parent.get_script()
	if script:
		result.NodeScriptPath = script.resource_path
	result.NodeFilePath = parent.scene_file_path	
	if SaveTransform:
		result.NodeProperties.get_or_add("position", SaveSerializationHelper.SerializeVariable(parent.position))
		result.NodeProperties.get_or_add("rotation", SaveSerializationHelper.SerializeVariable(parent.rotation))
		result.NodeProperties.get_or_add("scale", SaveSerializationHelper.SerializeVariable(parent.scale))
		result.NodeProperties.get_or_add("skew", SaveSerializationHelper.SerializeVariable(parent.skew))		
	if SaveVisibility:
		result.NodeProperties.get_or_add("visible", SaveSerializationHelper.SerializeVariable(parent.visible))
		result.NodeProperties.get_or_add("modulate", SaveSerializationHelper.SerializeVariable(parent.modulate))
		result.NodeProperties.get_or_add("self_modulate", SaveSerializationHelper.SerializeVariable(parent.self_modulate))
		result.NodeProperties.get_or_add("show_behind_parent", SaveSerializationHelper.SerializeVariable(parent.show_behind_parent))
		result.NodeProperties.get_or_add("light_mask", SaveSerializationHelper.SerializeVariable(parent.light_mask))
		result.NodeProperties.get_or_add("visibility_layer", SaveSerializationHelper.SerializeVariable(parent.visibility_layer))
		
	for property in SaveProperties:
		if property.contains(":"):
			var nodePath = property.split(":")[0]
			var propertyPath = property.split(":")[1]
			var node = parent.get_node(nodePath)
			result.NodeProperties.get_or_add(property, SaveSerializationHelper.SerializeVariable(node.get(propertyPath)))
		else:		
			result.NodeProperties.get_or_add(property, SaveSerializationHelper.SerializeVariable(parent.get(property)))
			
	return result
