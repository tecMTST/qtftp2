extends Node
class_name SaveFile

@export var Version : String = "1.0"
@export var SlotId : String = ""
@export var Name : String = ""
@export var DateTime : Dictionary = {}
@export var LastTime : int = 0
@export var GameTime : int = 0
@export var Hash : String = ""
@export var CurrentSceneId : String = ""
@export var MetaData : Dictionary = {}
@export var GlobalData : Array[SaveFileGlobal] = []
@export var ScenesData : Array[SaveFileScene] = []
