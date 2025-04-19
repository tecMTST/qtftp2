extends Node
class_name SaveAgent

signal StartAutoSaving
signal FinishAutoSaving
signal StartSaving
signal FinishSaving
signal StartLoading
signal FinishLoading

@export var AutoSave : bool = true
@export var AutoSavePeriod : int = 60

var parent : Node
var autoSaveTimer : Timer

func _enter_tree() -> void:
	parent = get_parent()		
	autoSaveTimer = Timer.new()
	autoSaveTimer.autostart = AutoSave
	autoSaveTimer.wait_time = AutoSavePeriod
	autoSaveTimer.timeout.connect(__AutoSave)
	add_child(autoSaveTimer)
	LoadSceneData()
	
func LoadSceneData():
	StartLoading.emit()	
	if not SaveService.CurrentLoadedSlot:
		FinishLoading.emit()
		return	
	if not SaveService.CurrentLoadedSlot.ScenesData.any(func(item: SaveFileScene) : return item.ScenePath == parent.scene_file_path):
		FinishLoading.emit()		
		return
	get_tree().paused = true	
	var scene : SaveFileScene = SaveService.CurrentLoadedSlot.ScenesData.filter(func(item: SaveFileScene) : return item.ScenePath == parent.scene_file_path)[0]	
	var persistentNodes = get_tree().get_nodes_in_group(SaveService.PERSISTENCE_GROUP)
	
	#Remove all persistent nodes:
	for persistent in persistentNodes:
		persistent.get_parent().queue_free()
		
	#Re-Add
	for persistent in scene.SceneNodes:
		var instance = load(persistent.NodeFilePath).instantiate()
		parent.get_node(persistent.ParentTreePath).add_child.call_deferred(instance)
		instance.request_ready()
		await instance.ready
		var saveElement = instance.get_children().filter(func(child : Node): return child is SaveElement3D or child is SaveElement2D)
		if len(saveElement) > 0:
			saveElement[0].Load(persistent)	
	get_tree().paused = false	
	FinishLoading.emit()
	

func SaveSceneData(auto = false):	
	if not SaveService.CurrentLoadedSlot:
		SaveService.NewSlot()
		
	if not auto:
		StartSaving.emit()
	else:
		StartAutoSaving.emit()
	
	var sceneData = SaveFileScene.new()
	sceneData.ScenePath = parent.scene_file_path 		
	
	var persistentNodes = get_tree().get_nodes_in_group(SaveService.PERSISTENCE_GROUP)
	for persistent in persistentNodes:
		sceneData.SceneNodes.append(persistent.Serialize())	
		
	if SaveService.CurrentLoadedSlot.ScenesData.any(func(item: SaveFileScene) : return item.ScenePath == parent.scene_file_path):		
		var currentIndex = SaveService.CurrentLoadedSlot.ScenesData.find(SaveService.CurrentLoadedSlot.ScenesData.filter(func(item: SaveFileScene) : return item.ScenePath == parent.scene_file_path)[0])
		SaveService.CurrentLoadedSlot.ScenesData.remove_at(currentIndex)
	SaveService.CurrentLoadedSlot.ScenesData.append(sceneData)	
	SaveService.SaveGame()
	
	await SaveService.saveCompleted
	
	if not auto:
		FinishSaving.emit()
	else:
		FinishAutoSaving.emit()

func __AutoSave():
	SaveSceneData(true)
