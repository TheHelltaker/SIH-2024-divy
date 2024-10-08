extends Node


"""
1)To add a crop, add the scene to preloads at 
2)Go To Animation Player and change sprite if each layer
3) Go To Crops section at and add a new variable for crop and modify the rest
4) Make A Signal for the new crop's count change and make sure to emit it in setter
5) Go to harvest function(line 31) of crops.gd and add an if statement for new crop
6) Add it in shop(I didn't do it for "duplicate this" plant)
7) Go to in_game_ui scene -> CropsAndUtilsSelect -> CropsVSplitContainer -> SelectCropHBoxContainer
   now duplicate the crop, and modify _ready of CropsAndUtilsSelect Accoringly

"""
#Preloads
const wheat_seed = preload("res://objects/crops/wheat.tscn")
const pumpkin_seed = preload("res://objects/crops/pumpkin.tscn")
#const DUPLICATE_THIS = preload("res://objects/crops/duplicate this.tscn")

# Signals
signal coins_change
signal wheat_count_change
signal pumpkin_count_change
signal water_level_change
signal fertilized_tiles_number_change
signal is_raining()
signal weather_status_changed()
signal util_count_changed
signal curr_mode_changed
signal moat_water_level_changed
signal duplicate_this_count_changed


signal use_object
signal harvest_crop

signal aim_position_changed
# Variables

var coins: int = 500: 
	set(value):
		coins = value
		coins_change.emit()	
		
var water_level: float = 100.0:
	set(value):
		if value > 100.0:
			water_level = 100.0
		elif value >= 0.0:
			water_level = value	
		else:
			if value > water_level:
				water_level = 1.0
			water_level = 0.0
		water_level_change.emit()				
		print(water_level)

var increment_number = 0: 
	get():
		increment_number += 1
var fertilized_tiles: int:
	set(value):
		fertilized_tiles = value
		fertilized_tiles_number_change.emit()
var dugged_holes_count= 0

var curr_util: int = 0 # fertilizer:0, drip_pipes:1, plough:2, sickle:3, shovel:4

var util_count : Dictionary = {
	0:0, #fertilizer
	1:0, #drip pipes
	2:1, #plough
	3:1, #sickle
	4:0  #shovel
}

func set_util_count(key : int,value : int):
	util_count[key] = value
	util_count_changed.emit()
	
func change_util_count(key : int,value : int):
	util_count[key] += value
	util_count_changed.emit()
		
var curr_mode = 0: # 0:plant 1:util
	set(value):
		curr_mode = value
		curr_mode_changed.emit()	
		
var moat_water_level = 100:
	set(value):
		if value < 0 :
			moat_water_level = 0
		else:
			moat_water_level = value
		moat_water_level_changed.emit()			
#Weather and land
var rain_type : String: # "none" , "light" , "medium" , "heavy", "storm"
	set(type):
		rain_type = type
		is_raining.emit()
var weather_status : String: # "idle", "wetting", "extreme_sunny", "flooding"
	set(status):
		weather_status = status
		weather_status_changed.emit()
#Crops
var curr_seed = "wheat"
var wheat_count: int:
	set(value):
		wheat_count = value
		crop_count["wheat"] = value
		wheat_count_change.emit()	
								
var pumpkin_count: int:
	set(value):
		pumpkin_count = value
		crop_count["pumpkin"] = value
		pumpkin_count_change.emit()

#var duplicate_this_count = 2:
	#set(value):
		#duplicate_this_count = value
		#crop_count["duplicate"] = value
		#duplicate_this_count_changed.emit()		
		
var crop_count=  {"wheat": wheat_count, "pumpkin": pumpkin_count}
var seeds = {"wheat": wheat_seed, "pumpkin": pumpkin_seed}


#Aim tile position
var aim_pos : Vector2i = Vector2i.ZERO :
	set(coords):
		aim_pos = coords
		aim_position_changed.emit();
		
