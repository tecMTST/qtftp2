extends Node
class_name SaveElementBase

@export var SaveTransform : bool = true
@export var SaveVisibility : bool = true
@export var SaveProperties : Array[String] = []

func _enter_tree() -> void:	
	add_to_group(SaveService.PERSISTENCE_GROUP)

func Load(data : SaveFileNode):	
	var parent = get_parent()	
	for property in data.NodeProperties:		
		if property.contains(":"):
			var nodePath = property.split(":")[0]
			var propertyPath = ":".join(property.split(":").slice(1))
			var node = parent.get_node(nodePath)			
			node.set(propertyPath, SaveSerializationHelper.DeserializeVariable(data.NodeProperties[property]))
		else:		
			parent.set(property, SaveSerializationHelper.DeserializeVariable(data.NodeProperties[property]))
		
