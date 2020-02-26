#include clientscripts\mp\_utility;
#include clientscripts\mp\zombies\_zm_utility;

weapon_box_callback(localClientNum, set, newEnt)
{
/#	println( "ZM >> weapon_box_callback - client scripts" );	#/
	if(localClientNum != 0)
	{
		return;
	}
	
	if(set)
	{
		self thread weapon_floats_up();
	}
	else
	{
		self notify("end_float");
		
		cleanup_weapon_models();
	}
}

cleanup_weapon_models()
{
	if(IsDefined(self.weapon_models))
	{
		players = level.localPlayers;
		for( index = 0; index < players.size; index++)
		{
			if(IsDefined(self.weapon_models[index]))
			{
				self.weapon_models[index].dw Delete();
				self.weapon_models[index] Delete();
			}
		}
		self.weapon_models = undefined;
	}
}

weapon_is_dual_wield(name)
{
	switch(name)
	{
		case  "fivesevendw_zm":
		case  "fivesevendw_upgraded_zm":
		case  "cz75dw_zm":
		case  "cz75dw_upgraded_zm":
		case  "m1911_upgraded_zm":
		case  "hs10_upgraded_zm":
		case  "pm63_upgraded_zm":
		case  "microwavegundw_zm":
		case  "microwavegundw_upgraded_zm":
			return true;
		default:
			return false;
	}
}

weapon_floats_up()
{
	self endon("end_float");
	
	cleanup_weapon_models();

	self.weapon_models = [];

	number_cycles = 39;
	floatHeight = 64;

	rand = treasure_chest_ChooseRandomWeapon();
	modelname = GetWeaponModel( rand );
	
	level.localPlayers = GetLocalPlayers();
	players = level.localPlayers;
/#	println( "ZM >> weapon_box_callback - players.size=" + players.size );	#/
		
	for( i = 0; i < players.size; i ++)
	{
		self.weapon_models[i] = spawn(i, self.origin, "script_model"); 
		self.weapon_models[i].angles = self.angles+( 0, 180, 0 );
		self.weapon_models[i].dw = spawn(i, self.weapon_models[i].origin - ( 3, 3, 3 ), "script_model");
		self.weapon_models[i].dw.angles = self.weapon_models[i].angles;
		self.weapon_models[i].dw Hide();
	
		self.weapon_models[i] SetModel( modelname ); 
		self.weapon_models[i].dw SetModel(modelname);
		self.weapon_models[i] useweaponhidetags( rand );

		//move it up
		self.weapon_models[i] moveto( self.origin +( 0, 0, floatHeight ), 3, 2, 0.9 ); 	
		self.weapon_models[i].dw MoveTo(self.origin + (0,0,floatHeight) - ( 3, 3, 3 ), 3, 2, 0.9);
	}
	
	for( i = 0; i < number_cycles; i++ )
	{

		if( i < 20 )
		{
			serverwait( 0, 0.05, 0.01 ); 
		}
		else if( i < 30 )
		{
			serverwait( 0, 0.1, 0.01 ); 
		}
		else if( i < 35 )
		{
			serverwait( 0, 0.2, 0.01 ); 
		}
		else if( i < 38 )
		{
			serverwait( 0, 0.3, 0.01 ); 
		}

		//debugstar(self.weapon_models[0].origin, 20, (0,1,0));

		rand = treasure_chest_ChooseRandomWeapon();
		modelname = GetWeaponModel( rand );
		
		players = level.localPlayers;
		for( index = 0; index < players.size; index++)
		{
			if(IsDefined(self.weapon_models[index]))
			{
				self.weapon_models[index] SetModel( modelname ); 
				self.weapon_models[index] useweaponhidetags( rand );
				
				if(weapon_is_dual_wield(rand))
				{
					self.weapon_models[index].dw SetModel(modelname);
					self.weapon_models[index].dw useweaponhidetags(rand);
					self.weapon_models[index].dw show();
				}
				else
				{
					self.weapon_models[index].dw Hide();
				}
			}
		}
	}

	cleanup_weapon_models();
}

is_weapon_included( weapon_name )
{
	if ( !IsDefined( level._included_weapons ) )
	{
		return false;
	}

	for ( i = 0; i < level._included_weapons.size; i++ )
	{
		if ( weapon_name == level._included_weapons[i] )
		{
			return true;
		}
	}

	return false;
}


include_weapon( weapon, display_in_box, func )
{
	if ( !IsDefined( level._included_weapons ) )
	{
		level._included_weapons = [];
	}

	level._included_weapons[level._included_weapons.size] = weapon;

	if ( !IsDefined( level._display_box_weapons ) )
	{
		level._display_box_weapons = [];
	}

	if ( !IsDefined( display_in_box ) )
	{
		display_in_box = true;
	}

	if ( !display_in_box )
	{
		return;
	}

	level._display_box_weapons[level._display_box_weapons.size] = weapon;
}

treasure_chest_ChooseRandomWeapon()
{
	if ( !IsDefined(level._display_box_weapons))
	{
		level._display_box_weapons = array( "python_zm", "g11_lps_zm", "famas_zm" );
	}
	
	return level._display_box_weapons[RandomInt( level._display_box_weapons.size )];
}

init()
{
	spawn_list = [];
	spawnable_weapon_spawns = GetStructArray( "weapon_upgrade", "targetname");
	spawnable_weapon_spawns = ArrayCombine(spawnable_weapon_spawns, GetStructArray( "bowie_upgrade", "targetname" ), true, false);
	spawnable_weapon_spawns = ArrayCombine(spawnable_weapon_spawns, GetStructArray( "sickle_upgrade", "targetname" ), true, false);
	spawnable_weapon_spawns = ArrayCombine(spawnable_weapon_spawns, GetStructArray( "tazer_upgrade", "targetname" ), true, false);
	spawnable_weapon_spawns = ArrayCombine(spawnable_weapon_spawns, GetStructArray( "claymore_purchase", "targetname" ), true, false);

	location = level.scr_zm_map_start_location;
	if ((location == "default" || location == "" ) && IsDefined(level.default_start_location))
	{
		location = level.default_start_location;
	}	

	match_string = level.scr_zm_ui_gametype + "_" + location;
	match_string_plus_space = " " + match_string;
	
	for(i = 0; i < spawnable_weapon_spawns.size; i ++)
	{
		spawnable_weapon = spawnable_weapon_spawns[i];
		
		if(!isdefined(spawnable_weapon.script_noteworthy) || spawnable_weapon.script_noteworthy == "")
		{
			spawn_list[spawn_list.size] = spawnable_weapon;
		}
		else
		{
			matches  = strTok( spawnable_weapon.script_noteworthy, "," );
			
			for(j = 0; j < matches.size; j ++)
			{
				if((matches[j] == match_string) || (matches[j] == match_string_plus_space ))
				{
					spawn_list[spawn_list.size] = spawnable_weapon;
				}
			}
		}
	}

	level._active_wallbuys = [];
	
	for(i = 0; i < spawn_list.size; i ++)
	{
		spawn_list[i].script_label = spawn_list[i].zombie_weapon_upgrade + "_" + spawn_list[i].origin;
		
		level._active_wallbuys[spawn_list[i].script_label] = spawn_list[i];
		
		RegisterClientField("world", spawn_list[i].script_label, 2, "int", ::wallbuy_callback, false); // 2 bit int client field - bit 1 : 0 = not bought 1 = bought.  bit 2: 0 = not hacked 1 = hacked.
		
		target_struct = getstruct(spawn_list[i].target, "targetname");
	}

	OnPlayerConnect_Callback(::wallbuy_player_connect);
}

wallbuy_player_connect(localClientNum)
{
	keys = GetArrayKeys(level._active_wallbuys);
	
	/# println("Wallbuy connect cb : " + localClientNum); #/
	
	if(isdefined(level.createFX_enabled) && level.createFX_enabled)
	{
		return;
	}
		
	for(i = 0; i < keys.size; i ++)
	{
		wallbuy = level._active_wallbuys[keys[i]];
	
		
		fx = level._effect["m14_zm_fx"];
		
		if(isdefined(level._effect[wallbuy.zombie_weapon_upgrade + "_fx"]))
		{
			fx = level._effect[wallbuy.zombie_weapon_upgrade + "_fx"];
		}
		
		wallbuy.fx[localClientNum] = playfx( localClientNum, fx, wallbuy.origin, AnglesToForward(wallbuy.angles), AnglesToUp( wallbuy.angles ),  0.1);
		
		target_struct = getstruct(wallbuy.target, "targetname");
		
		target_model = spawn(localClientNum, target_struct.origin, "script_model");
		target_model.angles = target_struct.angles;
		target_model setmodel(target_struct.model);
		target_model useweaponhidetags( wallbuy.zombie_weapon_upgrade );
		target_model hide();
		target_model.parent_struct = target_struct;
		
		wallbuy.models[localClientNum] = target_model;
	}
}

wallbuy_callback(localClientNum, oldVal, newVal, bNewEnt, bInitialSnap, fieldName)
{
	struct = level._active_wallbuys[fieldName];

	/# println("wallbuy callback " + localClientNum); #/
	
	if(newVal == 0)
	{
		struct.models[localClientNum].origin = struct.models[localClientNum].parent_struct.origin;
		struct.models[localClientNum].angles = struct.models[localClientNum].parent_struct.angles;
		struct.models[localClientNum] hide();
	}
	else if(newVal == 1)
	{
		if(bInitialSnap)
		{
			struct.models[localClientNum] show();
			struct.models[localClientNum].origin = struct.models[localClientNum].parent_struct.origin;
		}
		else
		{
			wait(0.05);

			if(localClientNum == 0)
			{
				playsound(0, "weapon_show", struct.origin);
			}
			
			struct.models[localClientNum].origin =  struct.models[localClientNum].parent_struct.origin + (AnglesToRight( struct.models[localClientNum].angles) * 8);
			struct.models[localClientNum] show();
			struct.models[localClientNum] moveto(struct.models[localClientNum].parent_struct.origin, 1);
		}
	}
}

