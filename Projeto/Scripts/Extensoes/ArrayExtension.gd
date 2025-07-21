class_name ArrayExtension

static func find_first(array: Array, method: Callable) -> Variant:
	var filtered_result = array.filter(method)
	
	if filtered_result.size() == 0:
		return null
	
	return filtered_result.front()
