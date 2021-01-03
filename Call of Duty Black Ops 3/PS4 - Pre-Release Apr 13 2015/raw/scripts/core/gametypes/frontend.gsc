#using scripts\codescripts\struct;
#using scripts\shared\clientfield_shared;
#using scripts\shared\util_shared;
#using scripts\shared\spawner_shared;
#using scripts\shared\array_shared;
#using scripts\shared\scene_shared;
#using scripts\shared\_character_customization;

// ARCHETYPE UTILITY SCRIPTS
#using scripts\shared\ai\animation_selector_table_evaluators;
#using scripts\shared\ai\archetype_utility;
#using scripts\shared\ai\archetype_cover_utility;
#using scripts\shared\ai\archetype_locomotion_utility;
#using scripts\shared\ai\archetype_mocomps_utility;
#using scripts\shared\ai\behavior_state_machine_planners_utility;
#using scripts\shared\ai\archetype_damage_effects;
#using scripts\shared\ai\zombie;

                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                            	                                                                                                                                                                                                                                                                                                                                                                                       
                                                                                     	                                    

#precache( "menu", "SelectMode" );
#precache( "menu", "Main" );
#precache( "menu", "ModeSelect" );
#precache( "menu", "paintshop_light" );
#precache( "menu", "ChooseHead" );
#precache( "menu", "ChooseHead_v1" );
#precache( "menu", "ChooseHero" );
#precache( "menu", "ChooseHero_v1" );
#precache( "menu", "ChooseCharacterLoadout" );
#precache( "menu", "ChoosePersonalizationCharacter" );
#precache( "menu", "personalizeHero" );
#precache( "menu", "personalizeHero_v1" );
#precache( "menu", "ChooseGender" );
#precache( "menu", "ChooseGender_v1" );
#precache( "menu", "CustomClass" );
#precache( "menu", "WeaponCustomization" );

#precache( "model", "c_zom_der_dempsey_cin_fb" );
#precache( "model", "c_zom_der_nikolai_cin_fb" );
#precache( "model", "c_zom_der_richtofen_cin_fb" );
#precache( "model", "c_zom_der_takeo_cin_fb" );

#using_animtree("core_frontend");

function callback_void()
{

}

function delete_level_character()
{
	level.characterAttachedModelInfo = [];
	if ( isdefined( level.character ) )
	{
		level.character delete();
	}
}

function detach_model_from_level_character_bone( bone )
{
	if ( isdefined( level.character ) && isdefined( level.characterAttachedModelInfo[bone] ) )
	{
		level.character Detach( level.characterAttachedModelInfo[bone], bone );
		level.characterAttachedModelInfo[bone] = undefined;
	}
}

function attach_model_to_level_character( model, bone )
{
	if ( !isdefined( level.character ) )
	{
		return;
	}
	
	detach_model_from_level_character_bone( bone );
	
	level.character Attach( model, bone );
	level.characterAttachedModelInfo[bone] = model;
}

function setCamera( id )
{
	if ( id == "default" )
	{
		id = "room1";
	}

	cameraChanged = ( !isDefined(level.lastCameraId) || id != level.lastCameraId );
	spawnpointname = id + "_frontend_camera";
	spawnpoint = struct::get(spawnpointname);
	assert( spawnpoint.size, "There are no " + spawnpointname + "script_structs in the map.  There must be at least one."  );

	self spawn(spawnpoint.origin, spawnpoint.angles);
	if( isdefined( level.characterOrigin[id]) && cameraChanged )
	{
		delete_level_character();
		level.character = Spawn( "script_model", level.characterOrigin[id] );
		level.character SetModel( "c_54i_cqb_mpc_fb_fe" );

		if( isdefined( level.characterAnim[id]) )
		{
			level.character useanimtree( #animtree );
			level.character AnimScripted( "customization_idle", level.character.origin, level.characterAngles[id], level.characterAnim[id] );
		}
		else
		{
			level.character.angles = level.characterAngles[id];
		}
	}

	switch( id )
	{
		case "mp":
			level clientfield::set( "selectMenu", 0 );
			break;

		case "cp":
			spawnpointname = "tag_align_cp_bed";
			spawnpoint = struct::get(spawnpointname);
			CamAnimScripted( self, "cac_cp_lobby_camera_01", GetTime(), spawnpoint.origin, spawnpoint.angles );
			level clientfield::set( "selectMenu", 1 );
			break;

		case "zm":
			level clientfield::set( "selectMenu", 2 );
			break;
			
		case "room1":
			CamAnimScripted( self, "startmenu_camera_01", GetTime(), spawnpoint.origin, spawnpoint.angles );
			attach_model_to_level_character( "wpn_t7_mr6_world", "TAG_WEAPON_RIGHT" );
			attach_model_to_level_character( "wpn_t7_mr6_world", "TAG_WEAPON_LEFT" );
			level clientfield::set( "selectMenu", 3 );
			break;

		case "room2":
			spawnpointname = "character_room2";
			spawnpoint = struct::get(spawnpointname);
			CamAnimScripted( self, "cac_main_lobby_camera_01", GetTime(), spawnpoint.origin, spawnpoint.angles );
			level clientfield::set( "selectMenu", 4 );
			attach_model_to_level_character( "wpn_t7_arak_paint_shop", "TAG_WEAPON_RIGHT" );
			break;
	}

	if( ( id == "mp" || id == "cp" || id == "zm" ) )
	{
		level.game_mode_suffix = "_" + id;
	}
	level.lastCameraId = id;

}

function camera_think()
{
	level.lastMenu = "";
	level.lastResponse = "";
	weaponClasses = array( "primary", "secondary", "lethal", "tactical", "special" );
	
	paintshop_light = getEnt( "paintshop_light", "targetname" );
	if( isDefined(paintshop_light) )
	{
		lightNearPos = paintshop_light.origin;
		lightFarPos = lightNearPos;
		paintshop_light_far = struct::get( "paintshop_light_far", "targetname" );
		if( isDefined(paintshop_light_far) )
		{
			lightFarPos = paintshop_light_far.origin;
		}
	}
	usingNearLight = true;

	while ( isdefined( self ) )
	{
		self waittill( "menuresponse", menu, response );
		if( level.lastMenu != menu || level.lastResponse != response )
		{
			if( menu == "SelectMode" || menu == "Main" || menu == "ModeSelect" )
			{
				if( response == "chooseClass" )
				{
					level clientfield::set( "selectMenu", 7 );
				}
				else
				{
					self setCamera( response );
					level.lastMainRoom = response;
				}

				for( i=0; i<weaponClasses.size; i++ )
				{
					if( isdefined(level.weapon_script_model[weaponClasses[i]]) )
					{
						level.weapon_script_model[weaponClasses[i]] delete();
					}
				}
			}
			else if( menu == "paintshop_light" )
			{
				if( isDefined(paintshop_light) )
				{
					if ( usingNearLight && response == "far" )
					{
						paintshop_light moveTo(lightFarPos, 0.125, 0, 0);
						usingNearLight = false;
					}
					else if ( !usingNearLight && response == "near" )
					{
						paintshop_light moveTo(lightNearPos, 0.125, 0, 0);
						usingNearLight = true;
					}
				}
			}
			else if ( menu == "personalizeHero" || menu == "personalizeHero_v1" )
			{
				if ( StrStartsWith( response, "opened" ) )
				{
					level clientfield::set( "selectMenu", 9 );
					
					if ( response != "opened_noCam" )
					{
						spawnpointname = menu + "_camera";
						spawnpoint = struct::get( spawnpointname );
						
						assert( spawnpoint.size, "There are no " + spawnpointname + "script_structs in the map.  There must be at least one."  );
						
						animTime = 0;
						if ( level.lastMenu == "personalizeHero" )
						{
							animTime = 300;
						}
						
						CamAnimScripted( self, "ui_cam_character_customization", GetTime(), spawnpoint.origin, spawnpoint.angles, animTime, "cam_preview" );
					}
				}
				else if ( StrStartsWith( response, "inspecting" ) )
				{
					spawnpointname = menu + "_camera";
					spawnpoint = struct::get( spawnpointname );
					
					assert( spawnpoint.size, "There are no " + spawnpointname + "script_structs in the map.  There must be at least one."  );
					
					camName = "cam_select";
					if ( response == "inspecting_helmet" )
					{
						camName = "cam_helmet";
					}
					
					CamAnimScripted( self, "ui_cam_character_customization", GetTime(), spawnpoint.origin, spawnpoint.angles, 300, camName );
				}
			}
			else if ( menu == "ChooseHead" || menu == "ChooseHead_v1" )
			{
				if ( response == "opened" )
				{
					level clientfield::set( "selectMenu", 10 );
					
					if ( response != "opened_noCam" )
					{
						spawnpointname = "personalizeHero_camera";
						spawnpoint = struct::get( spawnpointname );
						
						assert( spawnpoint.size, "There are no " + spawnpointname + "script_structs in the map.  There must be at least one."  );
						
						CamAnimScripted( self, "ui_cam_character_customization", GetTime(), spawnpoint.origin, spawnpoint.angles, 0, "cam_helmet" );
					}
				}
				else if ( response == "closed" )
				{
					self setCamera( level.lastMainRoom );
				}
			}
			else if ( menu == "ChoosePersonalizationCharacter" )
			{
				if ( response == "opened" )
				{
					level clientfield::set( "selectMenu", 8 );
					
					spawnpointname = "mp_frontend_camera";
					spawnpoint = struct::get( spawnpointname );
					
					assert( spawnpoint.size, "There are no " + spawnpointname + "script_structs in the map.  There must be at least one."  );
					
					CamAnimScripted( self, "ui_cam_char_selection_background", GetTime(), spawnpoint.origin, spawnpoint.angles );
				}
				else if ( response == "closed" )
				{
					self setCamera( level.lastMainRoom );
				}
			}
			else if ( menu == "ChooseCharacterLoadout" )
			{
				if ( response == "opened" )
				{
					level clientfield::set( "selectMenu", 14 );
					
					spawnpointname = "mp_frontend_camera";
					spawnpoint = struct::get( spawnpointname );
					
					assert( spawnpoint.size, "There are no " + spawnpointname + "script_structs in the map.  There must be at least one."  );
					
					CamAnimScripted( self, "ui_cam_char_selection_background", GetTime(), spawnpoint.origin, spawnpoint.angles );
				}
				else if ( response == "closed" )
				{
					self setCamera( level.lastMainRoom );
				}
			}
			else if ( menu == "OutfitsMainMenu" )
			{
				if ( response == "opened" )
				{
					level clientfield::set( "selectMenu", 12 );
				}
			}
			else if ( menu == "ChooseOutfit" )
			{
				if ( response == "opened" )
				{
					level clientfield::set( "selectMenu", 13 );
				}
			}
			else if ( menu == "ChooseGender" || menu == "ChooseGender_v1" )
			{
				if ( response == "opened" )
				{
					level clientfield::set( "selectMenu", 11 );
					
					spawnpointname = "mp_frontend_camera";
					spawnpoint = struct::get( spawnpointname );
					
					assert( spawnpoint.size, "There are no " + spawnpointname + "script_structs in the map.  There must be at least one."  );
					
					CamAnimScripted( self, "ui_cam_char_selection_background", GetTime(), spawnpoint.origin, spawnpoint.angles );
				}
				else if ( response == "closed" )
				{
					self setCamera( level.lastMainRoom );
				}
			}
			else if( menu == "CustomClass" )
			{
				level clientfield::set( "selectMenu", 5 );
			}
			
			level.lastMenu = menu;
			level.lastResponse = response;
		}
	}
}

function callbackPlayerConnect()
{
	level.lastMainRoom = SessionModeAbbreviation();
	self setCamera( level.lastMainRoom );
	self SetClientFocalLength( 23.3622 );

	self thread camera_think();
}

function Callback_ActorSpawnedFrontEnd( spawner )
{
	self thread spawner::spawn_think( spawner );
}

function main()
{
	level.callbackStartGameType = &callback_void;
	level.callbackPlayerConnect = &callbackPlayerConnect;
	level.callbackPlayerDisconnect = &callback_void;
	level.callbackEntitySpawned = &callback_void;
	level.callbackActorSpawned =&Callback_ActorSpawnedFrontEnd;	

	level.orbis = (GetDvarString( "orbisGame") == "true");
	level.durango = (GetDvarString( "durangoGame") == "true");

	level.characterOrigin = [];
	level.characterAngles = [];
	level.characterAnim = [];
	level.characterAttachedModelInfo = [];
	level.weapon_script_model = [];
	level.weaponNone = GetWeapon( "none" );

	level.characterOrigin["room1"] = struct::get("character_room1").origin;
	level.characterAngles["room1"] = struct::get("character_room1").angles;
	level.characterAnim["room1"] = "pb_cac_startmenu_idle";

	level.characterOrigin["room2"] = struct::get("character_room2").origin;
	level.characterAngles["room2"] = struct::get("character_room2").angles;
	level.characterAnim["room2"] = "pb_cac_main_lobby_idle";

	clientfield::register( "world", "selectMenu", 1, GetMinBitCountForNum(15), "int" );
	clientfield::register("actor", "zombie_has_eyes", 1, 1, "int");		
	
	level thread zm_frontend_zombie_logic();
}

function zm_frontend_zombie_logic()
{
	a_str_char[0] = "c_zom_der_dempsey_cin_fb";
	a_str_char[1] = "c_zom_der_nikolai_cin_fb";
	a_str_char[2] = "c_zom_der_richtofen_cin_fb";
	a_str_char[3] = "c_zom_der_takeo_cin_fb";
	
	const N_MAX_ZOMBIES = 20;
	
	lobbyModel = util::spawn_model( a_str_char[ RandomInt( a_str_char.size ) ], (0,0,0) );
	lobbyModel.targetname = "zm_lobby_player_model";
	
	level thread scene::play( "cin_fe_zm_forest_vign_sitting" );
	
	//wait a little bit before ramping up
	wait 5;
	
	a_sp_zombie = GetEntArray( "sp_zombie_frontend", "targetname" );
	
	while( true )
	{
		a_sp_zombie = array::randomize( a_sp_zombie );
		foreach( sp_zombie in a_sp_zombie )
		{
			//fail safe and also making sure there isn't a ton of zombies
			while( GetAICount() >= N_MAX_ZOMBIES )
			{
				wait 1;
			}
			
			ai_zombie = sp_zombie SpawnFromSpawner();
			if( isdefined( ai_zombie ) )
			{
				ai_zombie SetAvoidanceMask( "avoid all" );
				ai_zombie PushActors( false );
				ai_zombie clientfield::set("zombie_has_eyes", 1);
				ai_zombie.delete_on_path_end = true;
				sp_zombie.count++;
			}
			
			wait RandomFloatRange( 3.0, 8.0 );
		}
	}
}

