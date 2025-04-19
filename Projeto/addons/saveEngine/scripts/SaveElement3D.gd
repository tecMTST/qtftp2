extends SaveElementBase
class_name SaveElement3D

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
		result.NodeProperties.get_or_add("top_level", SaveSerializationHelper.SerializeVariable(parent.top_level))
		result.NodeProperties.get_or_add("rotation_edit_mode", SaveSerializationHelper.SerializeVariable(parent.rotation_edit_mode))
		result.NodeProperties.get_or_add("rotation_order", SaveSerializationHelper.SerializeVariable(parent.rotation_order))
	if SaveVisibility:
		result.NodeProperties.get_or_add("visible", SaveSerializationHelper.SerializeVariable(parent.visible))
	for property in SaveProperties:
		if property.contains(":"):
			var nodePath = property.split(":")[0]
			var propertyPath = property.split(":")[1]
			var node = parent.get_node(nodePath)
			result.NodeProperties.get_or_add(property, SaveSerializationHelper.SerializeVariable(node.get(propertyPath)))
		else:		
			result.NodeProperties.get_or_add(property, SaveSerializationHelper.SerializeVariable(parent.get(property)))
			
	return result
