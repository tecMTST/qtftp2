extends Node
class_name SaveSerializationHelper

static func SerializeVariable(variable):
	match typeof(variable):
		TYPE_NIL:
			return null
		TYPE_VECTOR2:
			return __SerializeVector2(variable)
		TYPE_VECTOR3:
			return __SerializeVector3(variable)
		TYPE_COLOR:
			return __SerializeColor(variable)
		TYPE_BASIS:
			return __SerializeBasis(variable)
		TYPE_TRANSFORM3D:
			return __SerializeTransform(variable)
		TYPE_TRANSFORM2D:
			return __SerializeTransform2d(variable)
		TYPE_ARRAY:
			return __SerializeArray(variable)
		TYPE_DICTIONARY:
			return __SerializeDictionary(variable)		
	return variable

static func DeserializeVariable(input):
	if typeof(input) == TYPE_NIL:
		return null

	if typeof(input) != TYPE_DICTIONARY:
		return input

	match input.type:
		"vector2":
			return __DeserializeVector2(input)
		"vector3":
			return __DeserializeVector3(input)
		"color":
			return __DeserializeColor(input)
		"basis":
			return __DeserializeBasis(input)
		"transform":
			return __DeserializeTransform(input)
		"transform2d":
			return __DeserializeTransform2d(input)
		"array":
			return __DeserializeArray(input)
		"dictionary":
			return __DeserializeDictionary(input)		
	return input
			
static func __SerializeVector2(input):
	return {
		"type": "vector2",
		"x" : input.x,
		"y" : input.y
	}

static func __SerializeVector3(input):
	return {
		"type": "vector3",
		"x" : input.x,
		"y" : input.y,
		"z" : input.z
	}

static func __SerializeColor(input):
	return {
		"type": "color",
		"r" : input.r,
		"g" : input.g,
		"b" : input.b,
		"a" : input.a
	}

static func __SerializeBasis(input):
	return {
		"type": "basis",
		"x": SerializeVariable(input.x),
		"y": SerializeVariable(input.y),
		"z": SerializeVariable(input.z)
	}

static func __SerializeTransform(input):
	return {
		"type": "transform",
		"basis": SerializeVariable(input.basis),
		"origin": SerializeVariable(input.origin)
	}

static func __SerializeTransform2d(input):
	return {
		"type": "transform2d",
		"x": SerializeVariable(input.x),
		"y": SerializeVariable(input.y),
		"origin": SerializeVariable(input.origin)
	}

static func __SerializeArray(input):
	var array = []
	for entry in input:
		array.push_back(SerializeVariable(entry))
	return {
		"type": "array",
		"data": array
	}

static func __SerializeDictionary(input):
	var dict = {}
	for entry in input:
		dict[entry] = SerializeVariable(input[entry])
	return {
		"type": "dictionary",
		"data": dict
	}
	
static func __DeserializeVector2(input):
	return Vector2(
		input.x,
		input.y
	)

static func __DeserializeVector3(input):
	return Vector3(
		input.x,
		input.y,
		input.z
	)

static func __DeserializeColor(input):
	return Color(
		input.r,
		input.g,
		input.b,
		input.a
	)

static func __DeserializeBasis(input):
	return Basis(
		__DeserializeVector3(input.x),
		__DeserializeVector3(input.y),
		__DeserializeVector3(input.z)
	)

static func __DeserializeTransform(input):
	return Transform3D(
		__DeserializeBasis(input.basis),
		__DeserializeVector3(input.origin)
	)

static func __DeserializeTransform2d(input):
	return Transform2D(
		__DeserializeVector2(input.x),
		__DeserializeVector2(input.y),
		__DeserializeVector2(input.origin)
	)

static func __DeserializeArray(input):
	var array = []
	for entry in input.data:
		array.push_back(DeserializeVariable(entry))
	return array

static func __DeserializeDictionary(input):
	var dict = {}
	for entry in input.data:
		dict[entry] = DeserializeVariable(input.data[entry])
	return dict
