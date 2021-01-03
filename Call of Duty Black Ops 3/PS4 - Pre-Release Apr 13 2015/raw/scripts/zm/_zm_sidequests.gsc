#using scripts\codescripts\struct;

#using scripts\shared\util_shared;

    	   	                                                                                                                         	                                                                                                                                                                                                                                                                                                                                                                    	        	     	             	    	   	                           	                               	                                	                                                              	                                                                                                              	                            	                                     	                                       	                                                               	   	                  	       	                                                    	                   	                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                       	                                                                                        	           	                        	                                            	                                             	                                                   	                                                             	                                                         	                                                                    	                                                                                                                                                                                                    	                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                     	                                                              	                                                          	                                   	                                   	                                                    	                                       

#using scripts\zm\_zm_utility;

#namespace zm_sidequests;

/* _zombiemode_sidequests
 *
 * Purpose : 	Zombie sidequest framework.
 *		
 *						Handles all infrastructure for zombie side quests.
 * 
 * Author : 	Dan L
 * 
 */


function init_sidequests()
{
	level._sidequest_icons_base_x = - 225;
	
	level._zombie_sidequests = [];

	/#
	
	level thread sidequest_debug();
	
	#/
	
}

// checks the game difficulty and the current gametype to see if the SQ should be active
function is_sidequest_allowed( a_gametypes )	
{
	if( IsDefined( level.gamedifficulty ) && level.gamedifficulty == 0 ) //easy
	{
		return false;
	}
	
	b_is_gametype_active = false;
	
	if ( !IsArray( a_gametypes ) )
	{
		a_gametypes = Array( a_gametypes );
	}
	
	for ( i = 0; i < a_gametypes.size; i++ )
	{
		if ( GetDvarString( "g_gametype" ) == a_gametypes[ i ] )
		{
			b_is_gametype_active = true;
		}
	}

	return b_is_gametype_active;
}

/#

function sidequest_debug()
{
	if(GetDvarString("str_debug_sidequests") != "1")
	{
		return;
	}
	
	while(1)
	{
		// Useful debug shiz goes here.
		
		wait(1);
	}
}

#/

function damager_trigger_thread(dam_types, trigger_func)
{

	while(1)
	{
		self waittill("damage", amount, attacker, dir, point, type);
		
		self.dam_amount = amount;
		self.attacker = attacker;
		self.dam_dir = dir;
		self.dam_point = point;
		self.dam_type = type;	
		
		for(i = 0; i < dam_types.size; i ++)
		{
			if(type == dam_types[i])
			{
				break;
			}
		}
	}
	
	if(isdefined(trigger_func))
	{
		self [[trigger_func]]();
	}
	
	self notify("triggered");
	
}

function damage_trigger_thread()
{
	self endon("death");		
	
	while(1)
	{
		self waittill("damage");
		
		self.owner_ent notify("triggered");
	}
}

function sidequest_uses_teleportation(name)
{
	level._zombie_sidequests[name].uses_teleportation = true;
}

function declare_sidequest_icon(sidequest_name, icon_name, shader_name)
{
	sidequest = level._zombie_sidequests[sidequest_name];
	
	sidequest.icons[icon_name] = shader_name;
}

function create_icon(shader_name, x)
{
	icon = zm_utility::create_simple_hud( self );

	icon.foreground = true;
	icon.sort = 2;
	icon.hidewheninmenu = false;
	icon.alignX = "center";
	icon.alignY = "bottom";
	icon.horzAlign = "user_right";
	icon.vertAlign = "user_bottom";
	icon.x = x;
	icon.y = 0;

	icon.alpha = 1;
	icon setshader( shader_name, 32, 32 );	
	
	return(icon);
}

function add_sidequest_icon(sidequest_name, icon_name)
{
	if(!isdefined(self.sidequest_icons))
	{
		self.sidequest_icons = [];
	}
	
	if(isdefined(self.sidequest_icons[icon_name]))
	{
		return;
	}
	
	sq = level._zombie_sidequests[sidequest_name];
	
	base_x = level._sidequest_icons_base_x;
	
	if(isdefined(level._zombiemode_sidequest_icon_offset))
	{
		base_x += level._zombiemode_sidequest_icon_offset;
	}	
	
	self.sidequest_icons[icon_name] = self create_icon(sq.icons[icon_name], base_x + (self.sidequest_icons.size * 34));
}

function remove_sidequest_icon(sidequest_name, icon_name)
{
	if(!isdefined(self.sidequest_icons))
	{
		return;
	}
	
	if(!isdefined(self.sidequest_icons[icon_name]))
	{
		return;
	}
	
	icon = self.sidequest_icons[icon_name];
	
	new_array = [];
	keys = GetArrayKeys(self.sidequest_icons);
	
	for(i = 0; i < keys.size; i ++)
	{
		if(keys[i] != icon_name)
		{
			new_array[keys[i]] = self.sidequest_icons[keys[i]];
		}
	}
	
	self.sidequest_icons = new_array;

	icon Destroy();
	
	keys = GetArrayKeys(self.sidequest_icons);
	
	base_x = level._sidequest_icons_base_x;
	
	if(isdefined(level._zombiemode_sidequest_icon_offset))
	{
		base_x += level._zombiemode_sidequest_icon_offset;
	}	
		
	for(i = 0; i < keys.size; i ++)
	{
		self.sidequest_icons[keys[i]].x = base_x + (i * 34);
	}
}

function declare_sidequest(name, init_func, logic_func, complete_func, generic_stage_start_func, generic_stage_end_func)
{
	if(!isdefined(level._zombie_sidequests))
	{
		init_sidequests();
	}

/#	
	if(isdefined(level._zombie_sidequests[name]))
	{
		PrintLn("*** ERROR: Attempt to re-declare sidequest with name " + name);
		return;
	}
#/
	
	sq = SpawnStruct();
	
	sq.name = name;
	sq.stages = [];
	sq.last_completed_stage = -1;
	sq.active_stage = -1;	// No stage active.
	sq.sidequest_complete = false;
	sq.init_func = init_func;
	sq.logic_func = logic_func;
	sq.complete_func = complete_func;
	sq.generic_stage_start_func = generic_stage_start_func;
	sq.generic_stage_end_func = generic_stage_end_func;
	sq.assets = [];	// Asset definitions
	sq.uses_teleportation = false;
	sq.active_assets = [];
	sq.icons = [];
	sq.num_reps = 0;
		
	level._zombie_sidequests[name] = sq;
}
 
function declare_sidequest_stage(sidequest_name, stage_name, init_func, logic_func, exit_func)
{
/#	
	if(!isdefined(level._zombie_sidequests))
	{
		PrintLn("*** ERROR:  Attempt to declare a side quest stage before sidequests declared.");
		return;
	}
	
	if(!isdefined(level._zombie_sidequests[sidequest_name]))
	{
		PrintLn("*** ERROR:  Attempt to add stage " + stage_name + " to side quest " + sidequest_name + " but no such side quest exists.");
		return;
	}
	
	if(isdefined(level._zombie_sidequests[sidequest_name].stages[stage_name]))
	{
		PrintLn("*** ERROR: Sidequest " + sidequest_name + " already has a stage called " + stage_name);
		return;
	}
#/

	stage = SpawnStruct();
	stage.name = stage_name;
	stage.stage_number = level._zombie_sidequests[sidequest_name].stages.size;
	stage.assets = [];	// Asset definitions
	stage.active_assets = [];	// Actual spawned assets
	stage.logic_func = logic_func;
	stage.init_func = init_func;
	stage.exit_func = exit_func;
	stage.completed = false;
	stage.time_limit = 0;		// Unlimited time.
	
	level._zombie_sidequests[sidequest_name].stages[stage_name] = stage;
}

function set_stage_time_limit(sidequest_name, stage_name, time_limit, timer_func)
{
/#	
	if(!isdefined(level._zombie_sidequests))
	{
		PrintLn("*** ERROR:  Attempt to set a side quest stage time limit before sidequests declared.");
		return;
	}
	
	if(!isdefined(level._zombie_sidequests[sidequest_name]))
	{
		PrintLn("*** ERROR:  Attempt to add timelimit to stage " + stage_name + " in side quest " + sidequest_name + " but no such side quest exists.");
		return;
	}
	
	if(!isdefined(level._zombie_sidequests[sidequest_name].stages[stage_name]))
	{
		PrintLn("*** ERROR: Attempt to add timelimit to stage " + stage_name + " in Sidequest " + sidequest_name + " but stage does not exist.");
		return;
	}
#/

	level._zombie_sidequests[sidequest_name].stages[stage_name].time_limit = time_limit;
	level._zombie_sidequests[sidequest_name].stages[stage_name].time_limit_func = timer_func;
}

function declare_stage_asset_from_struct(sidequest_name, stage_name, target_name, thread_func, trigger_thread_func)
{
	structs = struct::get_array(target_name, "targetname");
/#	

	if(!isdefined(level._zombie_sidequests))
	{
		PrintLn("*** ERROR:  Attempt to declare a side quest asset " + target_name + " before sidequests declared.");
		return;
	}
	
	if(!isdefined(level._zombie_sidequests[sidequest_name]))
	{
		PrintLn("*** ERROR:  Attempt to add asset " + target_name + " to side quest " + sidequest_name + " but no such side quest exists.");
		return;
	}

	if(!isdefined(level._zombie_sidequests[sidequest_name].stages[stage_name]))
	{
		PrintLn("*** ERROR:  Attempt to add asset " + target_name + " to side quest " + sidequest_name + " : " + stage_name + " but no such stage exists.");
		return;
	}

	if(!structs.size)
	{
		PrintLn("*** ERROR: No Structs with " + target_name + " not found.");
		return;
	}
#/

	for(i = 0; i < structs.size; i ++)
	{
		asset = SpawnStruct();
		asset.type = "struct";
		asset.struct = structs[i];
		asset.thread_func = thread_func;
		asset.trigger_thread_func = trigger_thread_func;
		
		level._zombie_sidequests[sidequest_name].stages[stage_name].assets[level._zombie_sidequests[sidequest_name].stages[stage_name].assets.size] = asset;
	}	
}
	
function declare_stage_title(sidequest_name, stage_name, title)
{
/#
	if(!isdefined(level._zombie_sidequests))
	{
		PrintLn("*** ERROR:  Attempt to declare a stage title " + title + " before sidequests declared.");
		return;
	}
	
	if(!isdefined(level._zombie_sidequests[sidequest_name]))
	{
		PrintLn("*** ERROR:  Attempt to declare a stage title " + title + " to side quest " + sidequest_name + " but no such side quest exists.");
		return;
	}

	if(!isdefined(level._zombie_sidequests[sidequest_name].stages[stage_name]))
	{
		PrintLn("*** ERROR:  Attempt to declare stage title " + title + " to side quest " + sidequest_name + " : " + stage_name + " but no such stage exists.");
		return;
	}
#/

	level._zombie_sidequests[sidequest_name].stages[stage_name].title = title;

}
	
function declare_stage_asset(sidequest_name, stage_name, target_name, thread_func, trigger_thread_func)
{
	ents = GetEntArray(target_name, "targetname");
	
/#	

	if(!isdefined(level._zombie_sidequests))
	{
		PrintLn("*** ERROR:  Attempt to declare a side quest asset " + target_name + " before sidequests declared.");
		return;
	}
	
	if(!isdefined(level._zombie_sidequests[sidequest_name]))
	{
		PrintLn("*** ERROR:  Attempt to add asset " + target_name + " to side quest " + sidequest_name + " but no such side quest exists.");
		return;
	}

	if(!isdefined(level._zombie_sidequests[sidequest_name].stages[stage_name]))
	{
		PrintLn("*** ERROR:  Attempt to add asset " + target_name + " to side quest " + sidequest_name + " : " + stage_name + " but no such stage exists.");
		return;
	}


	if(!ents.size)
	{
		PrintLn("*** ERROR: No Ents with " + target_name + " not found.");
		return;
	}
#/

	for(i = 0; i < ents.size; i ++)
	{
		asset = SpawnStruct();
		asset.type = "entity";
		asset.ent = ents[i];
		asset.thread_func = thread_func;
		asset.trigger_thread_func = trigger_thread_func;
		
		level._zombie_sidequests[sidequest_name].stages[stage_name].assets[level._zombie_sidequests[sidequest_name].stages[stage_name].assets.size] = asset;	
	}
}

function declare_sidequest_asset(sidequest_name, target_name, thread_func, trigger_thread_func)
{
	ents = GetEntArray(target_name, "targetname");
	
/#	

	if(!isdefined(level._zombie_sidequests))
	{
		PrintLn("*** ERROR:  Attempt to declare a side quest asset " + target_name + " before sidequests declared.");
		return;
	}
	
	if(!isdefined(level._zombie_sidequests[sidequest_name]))
	{
		PrintLn("*** ERROR:  Attempt to add asset " + target_name + " to side quest " + sidequest_name + " but no such side quest exists.");
		return;
	}

	if(!ents.size)
	{
		PrintLn("*** ERROR: No Ents with " + target_name + " not found.");
		return;
	}
#/

	for(i = 0; i < ents.size; i ++)
	{
		asset = SpawnStruct();
		asset.type = "entity";
		asset.ent = ents[i];
		asset.thread_func = thread_func;
		asset.trigger_thread_func = trigger_thread_func;
		asset.ent.thread_func = thread_func;
		asset.ent.trigger_thread_func = trigger_thread_func;
		
		level._zombie_sidequests[sidequest_name].assets[level._zombie_sidequests[sidequest_name].assets.size] = asset;
	}
	
}

function declare_sidequest_asset_from_struct(sidequest_name, target_name, thread_func, trigger_thread_func)
{
	structs = struct::get_array(target_name, "targetname");
/#	

	if(!isdefined(level._zombie_sidequests))
	{
		PrintLn("*** ERROR:  Attempt to declare a side quest asset " + target_name + " before sidequests declared.");
		return;
	}
	
	if(!isdefined(level._zombie_sidequests[sidequest_name]))
	{
		PrintLn("*** ERROR:  Attempt to add asset " + target_name + " to side quest " + sidequest_name + " but no such side quest exists.");
		return;
	}

	if(!structs.size)
	{
		PrintLn("*** ERROR: No Structs with " + target_name + " not found.");
		return;
	}
#/

	for(i = 0; i < structs.size; i ++)
	{
		asset = SpawnStruct();
		asset.type = "struct";
		asset.struct = structs[i];
		asset.thread_func = thread_func;
		asset.trigger_thread_func = trigger_thread_func;
		
		level._zombie_sidequests[sidequest_name].assets[level._zombie_sidequests[sidequest_name].assets.size] = asset;
	}
}

function build_asset_from_struct(asset, parent_struct)
{
	// build ent from asset.struct and return it.
	
	ent = spawn("script_model", asset.origin);
	
	if(isdefined(asset.model))
	{
		ent SetModel(asset.model);
	}
	
	if(isdefined(asset.angles))
	{
		ent.angles = asset.angles;
	}
	
	// Copy 'interesting' keys from struct to ent.

	ent.script_noteworthy = asset.script_noteworthy;
	ent.type = "struct";
	ent.radius = asset.radius;
	ent.thread_func = parent_struct.thread_func;
	ent.trigger_thread_func = parent_struct.trigger_thread_func;
	ent.script_vector = parent_struct.script_vector;
	asset.trigger_thread_func = parent_struct.trigger_thread_func;
	asset.script_vector = parent_struct.script_vector;
	ent.target = asset.target;
	ent.script_float = asset.script_float;
	ent.script_int = asset.script_int;
	ent.script_trigger_spawnflags = asset.script_trigger_spawnflags;
	ent.targetname = asset.targetname;
	
	return ent;
}

function delete_stage_assets()
{
	for(i = 0; i < self.active_assets.size; i ++)
	{
		asset = self.active_assets[i];
		
		switch(asset.type)
		{
			case "struct":
				if(isdefined(asset.trigger))
				{
/#	
					PrintLn("Deleting trigger from struct type asset.");
#/	
					asset.trigger Delete();
					asset.trigger = undefined;
				}
				
				asset Delete();
				break;
				
			case "entity":
				if(isdefined(asset.trigger))
				{
/#
					PrintLn("Deleting trigger from ent type asset.");
#/
					asset.trigger Delete();
					asset.trigger = undefined;
				}
			
				break;
		}
	}
	
	remaining_assets = [];
	
	for(i = 0; i < self.active_assets.size; i ++)
	{
		if(isdefined(self.active_assets[i]))
		{
			remaining_assets[remaining_assets.size] = self.active_assets[i];
		}
	}
	
	self.active_assets = remaining_assets;
}

function build_assets()
{
	for(i = 0; i < self.assets.size; i ++)
	{
		asset = undefined;
		
		switch(self.assets[i].type)
		{
			case "struct":
				asset = self.assets[i].struct;
				self.active_assets[self.active_assets.size] = build_asset_from_struct(asset, self.assets[i]);
				break;
			case "entity":
				for(j = 0; j < self.active_assets.size; j ++)
				{
					if(self.active_assets[j] == self.assets[i].ent)
					{
						asset = self.active_assets[j];
						break;	// This was an entity placed in the map, it's not created by us - so it stays in the active_assets list once added to it.
										// It's triggers however, are torn down and re-created each time.
					}
				}
				
				asset = self.assets[i].ent;
				asset.type = "entity";
				
				self.active_assets[self.active_assets.size] = asset;	// Just set up a reference to the existing ent.
				break;
			
			default:
/#
				PrintLn("*** ERROR: Don't know how to build asset of type " + self.assets.type);
#/
				break;
		}
		
		if((isdefined(asset.script_noteworthy) && (self.assets[i].type == "entity" && !isdefined(asset.trigger))) || isdefined(asset.script_noteworthy))
		{
			trigger_radius = 15;
			trigger_height = 72;
			
			if(isdefined(asset.radius))
			{
				trigger_radius = asset.radius;
			}

			if(isdefined(asset.height))
			{
				trigger_height = asset.height;
			}

			trigger_spawnflags = 0;

			if(isdefined(asset.script_trigger_spawnflags))
			{
				trigger_spawnflags = asset.script_trigger_spawnflags;
			}
			
			trigger_offset = (0,0,0);
			
			if(isdefined(asset.script_vector))
			{
				trigger_offset = asset.script_vector;
			}
			
			switch(asset.script_noteworthy)
			{
				case "trigger_radius_use":
					use_trigger = spawn( "trigger_radius_use", asset.origin + trigger_offset, trigger_spawnflags, trigger_radius, trigger_height );
										
					use_trigger SetCursorHint( "HINT_NOICON" );
					use_trigger TriggerIgnoreTeam();
					if(IsDefined(asset.radius))
					{
						use_trigger.radius = asset.radius;
					}
					use_trigger.owner_ent = self.active_assets[self.active_assets.size - 1];
					if(isdefined(asset.trigger_thread_func))
					{
						use_trigger thread [[asset.trigger_thread_func]]();
					}
					else
					{
						use_trigger thread use_trigger_thread();
					}
					
					self.active_assets[self.active_assets.size - 1].trigger = use_trigger;
					break;
				case "trigger_radius_damage":
					damage_trigger = spawn( "trigger_damage", asset.origin + trigger_offset, trigger_spawnflags, trigger_radius, trigger_height );

					if(isdefined(asset.radius))
					{
						damage_trigger.radius = asset.radius;
					}
					
					damage_trigger.owner_ent = self.active_assets[self.active_assets.size - 1];
					
					if(isdefined(asset.trigger_thread_func))
					{
						damage_trigger thread [[asset.trigger_thread_func]]();
					}
					else
					{
						damage_trigger thread damage_trigger_thread();
					}

					self.active_assets[self.active_assets.size - 1].trigger = damage_trigger;				
					break;
				case "trigger_radius":
					radius_trigger = spawn( "trigger_radius", asset.origin + trigger_offset, trigger_spawnflags, trigger_radius, trigger_height );
					if(isdefined(asset.radius))
					{
						radius_trigger.radius = asset.radius;
					}
					
					radius_trigger.owner_ent = self.active_assets[self.active_assets.size - 1];
					
					if(isdefined(asset.trigger_thread_func))
					{
						radius_trigger thread [[asset.trigger_thread_func]]();
					}
					else
					{
						radius_trigger thread radius_trigger_thread();
					}

					self.active_assets[self.active_assets.size - 1].trigger = radius_trigger;
					
					break;
			}
		}
		
		if(isdefined(self.assets[i].thread_func) && !isdefined(self.active_assets[self.active_assets.size -1].dont_rethread))
		{
			self.active_assets[self.active_assets.size - 1] thread [[self.assets[i].thread_func]]();
		}
		
		if(i % 2 == 0)
		{
			util::wait_network_frame();
		}
		
	}
}

function radius_trigger_thread()
{
	self endon("death");		
	
	while(1)
	{
		self waittill("trigger", player);
		
		if(!IsPlayer(player))
		{
			continue;
		}				

		self.owner_ent notify("triggered");
		
		while(player IsTouching(self))
		{
			{wait(.05);};
		}
		
		self.owner_ent notify("untriggered");
	}
	
}

function thread_on_assets(target_name, thread_func)
{
	for(i = 0; i < self.active_assets.size; i ++)
	{
		if(self.active_assets[i].targetname == target_name)
		{
			self.active_assets[i] thread [[thread_func]]();
		}
	}
}


function stage_logic_func_wrapper(sidequest, stage)
{
	if(isdefined(stage.logic_func))
	{
		level endon(sidequest.name + "_" + stage.name + "_over");
		stage [[stage.logic_func]]();
	}
}

function sidequest_start(sidequest_name)
{
	// Logic to handle starting a sidequest.

/#	

	if(!isdefined(level._zombie_sidequests))
	{
		PrintLn("*** ERROR:  Attempt start a side quest asset " + sidequest_name + " before sidequests declared.");
		return;
	}
	
	if(!isdefined(level._zombie_sidequests[sidequest_name]))
	{
		PrintLn("*** ERROR:  Attempt to start " + sidequest_name + " but no such side quest exists.");
		return;
	}

#/	

	sidequest = level._zombie_sidequests[sidequest_name];
	
	sidequest build_assets();
	
	if(isdefined(sidequest.init_func))
	{
		sidequest [[sidequest.init_func]]();
	}
	
	if(isdefined(sidequest.logic_func))
	{
		sidequest thread [[sidequest.logic_func]]();
	}

}

function stage_start(sidequest, stage)
{
	if(IsString(sidequest))
	{
		sidequest = level._zombie_sidequests[sidequest];
	}
	
	if(IsString(stage))
	{
		stage = sidequest.stages[stage];
	}	
	
	stage build_assets();

	sidequest.active_stage = stage.stage_number;	
	
	level notify(sidequest.name + "_" + stage.name +"_started");
	
	stage.completed = false;
	
	if(isdefined(sidequest.generic_stage_start_func))
	{
		stage [[sidequest.generic_stage_start_func]]();
	}
	
	if(isdefined(stage.init_func))
	{
		stage [[stage.init_func]]();	// Run the init func if it exists.
	}
	
	level._last_stage_started = stage.name;
	
	level thread stage_logic_func_wrapper(sidequest, stage);	// Threaded to take care of auto-adding the endon condition for the stage.
	
	if(stage.time_limit > 0)
	{
		stage thread time_limited_stage(sidequest);
	}
	
	if(isdefined(stage.title))
	{
		stage thread display_stage_title(sidequest.uses_teleportation);
	}
}

function display_stage_title(wait_for_teleport_done_notify)
{
	
	if(wait_for_teleport_done_notify)
	{
		level waittill("teleport_done");
		wait(2.0);
	}
	
	stage_text = NewHudElem();

	stage_text.location = 0;
	stage_text.alignX = "center";
	stage_text.alignY = "middle";
	stage_text.foreground = 1;
	stage_text.fontScale = 1.6;
	stage_text.sort = 20;
	stage_text.x = 320;
	stage_text.y = 300;
	stage_text.og_scale = 1;
	stage_text.color = (128, 0, 0);
	stage_text.alpha = 0;
	stage_text.fontstyle3d = "shadowedmore";
	stage_text SetText(self.title);		
	
	stage_text FadeOverTime(0.5);
	stage_text.alpha = 1;
	
	wait(5.0);
	
	stage_text FadeOverTime(1.0);
	stage_text.alpha = 0;
	wait(1.0);
	
	stage_text Destroy();
}

function time_limited_stage(sidequest)
{
/#	
	PrintLn("*** Starting timer for sidequest " + sidequest.name + " stage " + self.name + " : " + self.time_limit + " seconds.");
#/
	
	level endon(sidequest.name + "_" + self.name + "_over");
	level endon("suspend_timer");
	level endon( "end_game" );
	
	time_limit = undefined;
	
	if(isdefined(self.time_limit_func))
	{
		time_limit = [[self.time_limit_func]]() * 0.25;
	}
	else
	{
		time_limit = self.time_limit * 0.25;	// Notifications at 75%, 50%, 25%.
	}
	
	
	wait(time_limit);	
	
	level notify("timed_stage_75_percent");
	
	wait(time_limit);
	
	level notify("timed_stage_50_percent");
	
	wait(time_limit);
	
	level notify("timed_stage_25_percent");
	
	wait(time_limit - 10);	// Give a notify at the 10 seconds left mark
	
	level notify("timed_stage_10_seconds_to_go");
	
	wait(10);
	
	stage_failed(sidequest, self);
}

function sidequest_println(str)
{
/#
	if(GetDvarString("str_debug_sidequests") != "1")
	{
		return;
	}

	PrintLn(str);	
#/
}

function precache_sidequest_assets()
{
	
}

function sidequest_complete(sidequest_name)
{
/#	

	if(!isdefined(level._zombie_sidequests))
	{
		PrintLn("*** ERROR:  Attempt to call sidequest_complete for sidequest " + sidequest_name + " before sidequests declared.");
		return;
	}
	
	if(!isdefined(level._zombie_sidequests[sidequest_name]))
	{
		PrintLn("*** ERROR:  Attempt to call sidequest_complete for sidequest " + sidequest_name + " but no such side quest exists.");
		return;
	}
#/		

	return(level._zombie_sidequests[sidequest_name].sidequest_complete);

}

function stage_completed(sidequest_name, stage_name)
{
/#	

	if(!isdefined(level._zombie_sidequests))
	{
		PrintLn("*** ERROR:  Attempt to call stage_complete for sidequest " + sidequest_name + " before sidequests declared.");
		return;
	}
	
	if(!isdefined(level._zombie_sidequests[sidequest_name]))
	{
		PrintLn("*** ERROR:  Attempt to call stage_complete for sidequest " + sidequest_name + " but no such side quest exists.");
		return;
	}
	
	if(!isdefined(level._zombie_sidequests[sidequest_name].stages[stage_name]))
	{
		PrintLn("*** ERROR:  Attempt to call stage_complete in sq " + sidequest_name + " : " + stage_name + " but no such stage exists.");
		return;
	}	
		
	PrintLn("*** stage completed called.");
#/	
	
	sidequest = level._zombie_sidequests[sidequest_name];
	stage = sidequest.stages[stage_name];
	level thread stage_completed_internal(sidequest, stage);
}

function stage_completed_internal(sidequest, stage)
{
	level notify(sidequest.name + "_" + stage.name + "_over"); // Kill logic func if it's still running.
	level notify(sidequest.name + "_" + stage.name +"_completed");
	
	if(isdefined(sidequest.generic_stage_end_func))
	{
/#
		PrintLn("Calling generic end func.");
#/
		stage [[sidequest.generic_stage_end_func]]();
	}
	
	if(isdefined(stage.exit_func))
	{
/#
		PrintLn("Calling stage end func.");
#/
		stage [[stage.exit_func]](true);	// Run the exit func if it exists.
	}
	
	stage.completed = true;
	sidequest.last_completed_stage = sidequest.active_stage;
	sidequest.active_stage = -1;	// No stage active.
	
	// Delete any assets created by the stage.
	
	stage delete_stage_assets();
	
	all_complete = true;
	
	stage_names = GetArrayKeys(sidequest.stages);
	
	for(i = 0; i < stage_names.size; i ++)
	{
		if(sidequest.stages[stage_names[i]].completed == false)
		{
			all_complete = false;
			break;
		}
	}
	
	if(all_complete == true)
	{
		if(isdefined(sidequest.complete_func))
		{
			sidequest thread [[sidequest.complete_func]]();	// Run the completion logic for the sidequest.
		}
		level notify("sidequest_" + sidequest.name + "_complete");
		sidequest.sidequest_completed = true;
	}	
}


function stage_failed_internal(sidequest, stage)
{
	level notify(sidequest.name + "_" + stage.name + "_over"); // Kill logic func if it's still running.
	level notify(sidequest.name + "_" + stage.name +"_failed");

	if(isdefined(sidequest.generic_stage_end_func))
	{
		stage [[sidequest.generic_stage_end_func]]();
	}

	if(isdefined(stage.exit_func))
	{
		stage [[stage.exit_func]](false);	// Run the exit func if it exists.
	}
	
	sidequest.active_stage = -1;	// No stage active.	
	
	stage delete_stage_assets();
}

function stage_failed(sidequest, stage)
{
/#
	PrintLn("*** Stage failed called.");
#/
	
	if(IsString(sidequest))
	{
		sidequest = level._zombie_sidequests[sidequest];
	}
	
	if(IsString(stage))
	{
		stage = sidequest.stages[stage];
	}
	
	level thread stage_failed_internal(sidequest, stage);
}

function get_sidequest_stage(sidequest, stage_number)
{
	stage = undefined;
	
	stage_names = GetArrayKeys(sidequest.stages);
	
	for(i = 0; i < stage_names.size; i ++)
	{
		if(sidequest.stages[stage_names[i]].stage_number == stage_number)
		{
			stage = sidequest.stages[stage_names[i]];
			break;
		}
	}
	
	return stage;
}

// get_damage_trigger(256, self.origin, array("MOD_MELEE"));

function get_damage_trigger(radius, origin, damage_types)
{
	trig = spawn("trigger_damage", origin, 0, radius, 72);
	
	trig thread dam_trigger_thread(damage_types);
	
	return trig;
}

function dam_trigger_thread(damage_types)
{
	self endon("death");
	
	damage_type = "NONE";
	
	while(1)
	{
		self waittill("damage", amount, attacker, dir, point, mod);
		
		for(i = 0; i < damage_types.size; i ++)
		{
			if(mod == damage_types[i])
			{
				self notify("triggered");
			}
		}
	}
}

function use_trigger_thread()
{
	self endon("death");
	
	while(1)
	{
		self waittill("trigger", player);
		
		self.owner_ent notify("triggered", player);
		
		wait(0.1);
	}
	
}

function sidequest_stage_active(sidequest_name, stage_name)
{
	sidequest = level._zombie_sidequests[sidequest_name];
	
	stage = sidequest.stages[stage_name];
	
	if(sidequest.active_stage == stage.stage_number)
	{
		return true;
	}
	else
	{
		return false;
	}
}

function sidequest_start_next_stage(sidequest_name)
{
/#	

	if(!isdefined(level._zombie_sidequests))
	{
		PrintLn("*** ERROR:  Attempt start next stage in side quest asset " + sidequest_name + " before sidequests declared.");
		return;
	}
	
	if(!isdefined(level._zombie_sidequests[sidequest_name]))
	{
		PrintLn("*** ERROR:  Attempt to start next sidequest in sidequest " + sidequest_name + " but no such side quest exists.");
		return;
	}

#/		

	sidequest = level._zombie_sidequests[sidequest_name];

	if(sidequest.sidequest_complete == true)
	{
		return;
	}

	last_completed = sidequest.last_completed_stage;
	
	if(last_completed == -1)
	{
		last_completed = 0;
	}
	else
	{
		last_completed ++;
	}
	
	stage = get_sidequest_stage(sidequest, last_completed);
	
	if(!isdefined(stage))
	{
/#
		PrintLn("*** ERROR:  Sidequest " + sidequest_name + " has no stage number " + last_completed);
#/		
		return;
	}
	
	stage_start(sidequest, stage);
	
	return(stage);
}

function main()
{
}

function is_facing( facee )
{
	orientation = self getPlayerAngles();
	forwardVec = anglesToForward( orientation );
	forwardVec2D = ( forwardVec[0], forwardVec[1], 0 );
	unitForwardVec2D = VectorNormalize( forwardVec2D );
	toFaceeVec = facee.origin - self.origin;
	toFaceeVec2D = ( toFaceeVec[0], toFaceeVec[1], 0 );
	unitToFaceeVec2D = VectorNormalize( toFaceeVec2D );
	
	dotProduct = VectorDot( unitForwardVec2D, unitToFaceeVec2D );
	return ( dotProduct > 0.9 ); // reviver is facing within a ~52-degree cone of the player
}

function fake_use(notify_string, qualifier_func)
{
	waittillframeend;	// In case the calling thread is threading this, then waiting for the notify, and the player has 
										// use pressed down already, this makes sure that the calling thread doesn't get notified, before it's
										// good and ready.
	while(1)
	{
		if(!isdefined(self))
		{
			return;
		}
		
		/#
		Print3d(self.origin, "+", (0,255,0), 1);
		#/
		players = GetPlayers();
		for(i = 0; i < players.size; i ++)
		{
			qualifier_passed = true;

			if(isdefined(qualifier_func))
			{
				qualifier_passed = players[i] [[qualifier_func]]();
			}

			if(qualifier_passed && (DistanceSquared(self.origin, players[i].origin) < 64*64))
			{
				if(players[i] is_facing(self))
				{
					if(players[i] UseButtonPressed())
					{
						self notify(notify_string, players[i]);
						return;
					}
				}			
			}
		}
		wait(0.1);
	}
}
