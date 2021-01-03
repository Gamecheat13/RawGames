#using scripts\codescripts\struct;

#using scripts\shared\array_shared;
#using scripts\shared\callbacks_shared;
#using scripts\shared\compass;
#using scripts\shared\exploder_shared;
#using scripts\shared\flag_shared;
#using scripts\shared\laststand_shared;
#using scripts\shared\scene_shared;
#using scripts\shared\util_shared;

    	   	                                                                                                                         	                                                                                                                                                                                                                                                                                                                                                                    	        	     	             	    	   	                           	                               	                                	                                                              	                                                                                                              	                            	                                     	                                       	                                                               	   	                  	       	                                                    	                   	                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                       	                                                                                        	           	                        	                                            	                                             	                                                   	                                                             	                                                         	                                                                    	                                                                                                                                                                                                    	                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                     	                                                              	                                                          	                                   	                                   	                                                    	                                       
                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                            	                                                                                                                                                                                                                                                                                                                                                                                       

                                                                                                                               

#using scripts\zm\_load;
#using scripts\zm\_zm;
#using scripts\zm\_zm_ai_dogs;
#using scripts\zm\_zm_audio;
#using scripts\zm\_zm_laststand;
#using scripts\zm\_zm_net;
#using scripts\zm\_zm_score;
#using scripts\zm\_zm_spawner;
#using scripts\zm\_zm_power;
#using scripts\zm\_zm_powerups;
#using scripts\zm\_zm_timer;
#using scripts\zm\_zm_utility;
#using scripts\zm\_zm_weap_bouncingbetty;
#using scripts\zm\_zm_weap_cymbal_monkey;
#using scripts\zm\_zm_weap_bowie;
#using scripts\zm\_zm_weap_tesla;
#using scripts\zm\_zm_weapons;
#using scripts\zm\_zm_zonemgr;

//basic zombie AI
#using scripts\shared\ai\zombie;
#using scripts\shared\ai\behavior_zombie_dog;
#using scripts\shared\ai\zombie_utility;

//Perks
#using scripts\zm\_zm_pack_a_punch;
#using scripts\zm\_zm_pack_a_punch_util;
#using scripts\zm\_zm_perk_doubletap2;
#using scripts\zm\_zm_perk_juggernaut;
#using scripts\zm\_zm_perk_quick_revive;
#using scripts\zm\_zm_perk_sleight_of_hand;

//Powerups
#using scripts\zm\_zm_powerup_double_points;
#using scripts\zm\_zm_powerup_carpenter;
#using scripts\zm\_zm_powerup_fire_sale;
#using scripts\zm\_zm_powerup_full_ammo;
#using scripts\zm\_zm_powerup_insta_kill;
#using scripts\zm\_zm_powerup_nuke;

//Traps
#using scripts\zm\_zm_trap_electric;

#using scripts\zm\zm_factory_distance_tracking;
#using scripts\zm\zm_factory_teleporter;
#using scripts\zm\zm_factory_gamemodes;
#using scripts\zm\zm_factory_fx;

#precache( "fx", "zombie/fx_glow_eye_orange" );
#precache( "fx", "zombie/fx_bul_flesh_head_fatal_zmb" );
#precache( "fx", "zombie/fx_bul_flesh_head_nochunks_zmb" );
#precache( "fx", "zombie/fx_bul_flesh_neck_spurt_zmb" );
#precache( "fx", "zombie/fx_blood_torso_explo_zmb" );
#precache( "fx", "trail/fx_trail_blood_streak" );
#precache( "fx", "electric/fx_elec_sparks_directional_orange" );

#precache( "string", "ZOMBIE_NEED_POWER" );
#precache( "string", "ZOMBIE_ELECTRIC_SWITCH" );

#precache( "string", "ZOMBIE_POWER_UP_TPAD" );
#precache( "string", "ZOMBIE_TELEPORT_TO_CORE" );
#precache( "string", "ZOMBIE_LINK_TPAD" );
#precache( "string", "ZOMBIE_LINK_ACTIVE" );
#precache( "string", "ZOMBIE_INACTIVE_TPAD" );
#precache( "string", "ZOMBIE_START_TPAD" );

//precacheshellshock("electrocution");
#precache( "model", "zombie_zapper_cagelight_red");
#precache( "model", "zombie_zapper_cagelight_green");
#precache( "model", "lights_indlight_on" );
#precache( "model", "lights_milit_lamp_single_int_on" );
#precache( "model", "lights_tinhatlamp_on" );
#precache( "model", "lights_berlin_subway_hat_0" );
#precache( "model", "lights_berlin_subway_hat_50" );
#precache( "model", "lights_berlin_subway_hat_100" );

#precache( "model", "p6_power_lever" );

#precache( "string", "ZOMBIE_BETTY_ALREADY_PURCHASED" );
#precache( "string", "ZOMBIE_BETTY_HOWTO" );




//*****************************************************************************
// GAME MODES SETUP
//*****************************************************************************

function gamemode_callback_setup()
{
	zm_factory_gamemodes::init();	// Moved to it's own file - for your patching pleasure.
}


#using_animtree( "generic" );

function setup_rex_starts()
{
	// populate the Gametype dropdown
	zm_utility::add_gametype( "zclassic", &dummy, "zclassic", &dummy );

	// populate the Location dropdown
	zm_utility::add_gameloc( "default", &dummy, "default", &dummy );
}

function dummy()
{
}

//*****************************************************************************
// MAIN
//*****************************************************************************

function main()
{
	zm_factory_fx::main();
	
	//Setup callbacks for bridge fxanim
	scene::add_scene_func("p7_fxanim_zm_factory_bridge_lft_bundle", &bridge_disconnect , "init" );
	scene::add_scene_func("p7_fxanim_zm_factory_bridge_lft_bundle", &bridge_connect , "done" );
	scene::add_scene_func("p7_fxanim_zm_factory_bridge_rt_bundle", &bridge_disconnect , "init" );
	scene::add_scene_func("p7_fxanim_zm_factory_bridge_rt_bundle", &bridge_connect , "done" );	

	level._uses_default_wallbuy_fx = 1;
	level._uses_sticky_grenades = 1;
	level._uses_taser_knuckles = 1;	
	
	zm::init_fx();

	level.lighting_state = 1; // power_off
	SetLightingState( level.lighting_state );
	
	callback::on_spawned( &on_player_spawned );
	
	level._effect["eye_glow"]				= "zombie/fx_glow_eye_orange";
	level._effect["headshot"]				= "zombie/fx_bul_flesh_head_fatal_zmb";
	level._effect["headshot_nochunks"]		= "zombie/fx_bul_flesh_head_nochunks_zmb";
	level._effect["bloodspurt"]				= "zombie/fx_bul_flesh_neck_spurt_zmb";

	level._effect["animscript_gib_fx"]		= "zombie/fx_blood_torso_explo_zmb"; 
	level._effect["animscript_gibtrail_fx"]	= "trail/fx_trail_blood_streak"; 	
	level._effect["switch_sparks"]			= "electric/fx_elec_sparks_directional_orange";

	//Setup game mode defaults
	level.default_start_location = "start_room";	
	level.default_game_mode = "zclassic";	

	level.random_pandora_box_start = true;	
	if ( 1 == GetDvarInt( "movie_intro" ) )
	{
		SetDvar( "art_review", "1" );

		level.random_pandora_box_start = false;
		level.start_chest_name = "chest_4";

		clock_snow = GetEnt( "clock_snow", "targetname" );
		clock_snow Ghost();

		scene::add_scene_func( "cin_der_01_intro_3rd_sh050", &clock_shot, "play" );
		level thread cinematic();
	}
	else
	{
		clock = GetEnt( "factory_clock", "targetname" );
		clock thread scene::play( "p7_fxanim_zm_factory_clock_bundle" );
	}

	level.has_richtofen = false;	

	level.zm_disable_recording_stats = true;
	
	level.powerup_special_drop_override = &powerup_special_drop_override;

	level.giveCustomLoadout =&giveCustomLoadout;
	level.precacheCustomCharacters =&precacheCustomCharacters;
	level.giveCustomCharacters =&giveCustomCharacters;
	initCharacterStartIndex();

	//Weapons and Equipment
	level.register_offhand_weapons_for_level_defaults_override = &offhand_weapon_overrride;
	level.zombiemode_offhand_weapon_give_override = &offhand_weapon_give_override;

	level._zombie_custom_add_weapons =&custom_add_weapons;
	level thread custom_add_vox();
	level._allow_melee_weapon_switching = 1;
	zm_pap_util::enable_swap_attachments();

	//Level specific stuff
	include_weapons();
	include_powerups();
	include_perks();

	load::main();
	
    compass::setupMiniMap( "compass_map_zm_factory" );

	// Equipment

	_zm_weap_cymbal_monkey::init();
	//_zm_weap_ballistic_knife::init();
	//_zm_weap_crossbow::init();
	_zm_weap_bowie::init();
	_zm_weap_tesla::init();


	// used to modify the percentages of pulls of ray gun and tesla gun in magic box
	level.pulls_since_last_ray_gun = 0;
	level.pulls_since_last_tesla_gun = 0;
	level.player_drops_tesla_gun = false;

	level.mixed_rounds_enabled = true;	// MM added support for mixed crawlers and dogs
	level.burning_zombies = [];		//JV max number of zombies that can be on fire
	level.zombie_rise_spawners = [];	// Zombie riser control
	level.max_barrier_search_dist_override = 400;

	level.door_dialog_function = &zm::play_door_dialog;
//t6todo	level.dog_spawn_func = _zm_ai_dogs::dog_spawn_factory_logic;

	// Animations needed for door initialization
	script_anims_init();

//t6todo	level thread _callbacksetup::SetupCallbacks();
	
	level.zombie_anim_override = &zm_factory::anim_override_func;
	//level.exit_level_func =&factory_exit_level;

	/*precachestring(&"ZOMBIE_NEED_POWER");
	precachestring(&"ZOMBIE_ELECTRIC_SWITCH");

	precachestring(&"ZOMBIE_POWER_UP_TPAD");
	precachestring(&"ZOMBIE_TELEPORT_TO_CORE");
	precachestring(&"ZOMBIE_LINK_TPAD");
	precachestring(&"ZOMBIE_LINK_ACTIVE");
	precachestring(&"ZOMBIE_INACTIVE_TPAD");
	precachestring(&"ZOMBIE_START_TPAD");

	precacheshellshock("electrocution");
	precachemodel("zombie_zapper_cagelight_red");
	precachemodel("zombie_zapper_cagelight_green");
	precacheModel("lights_indlight_on" );
	precacheModel("lights_milit_lamp_single_int_on" );
	precacheModel("lights_tinhatlamp_on" );
	precacheModel("lights_berlin_subway_hat_0" );
	precacheModel("lights_berlin_subway_hat_50" );
	precacheModel("lights_berlin_subway_hat_100" );

	// DCS: not mature settings models without blood or gore.
	PreCacheModel( "p6_power_lever" );

	precachestring(&"ZOMBIE_BETTY_ALREADY_PURCHASED");
	precachestring(&"ZOMBIE_BETTY_HOWTO");*/




	level.dog_rounds_allowed = GetGametypeSetting( "allowdogs" );
	if( level.dog_rounds_allowed )
	{
		zm_ai_dogs::enable_dog_rounds();
	}

	level._round_start_func = &zm::round_start;
	

	init_sounds();
	init_achievement();
	level thread power_electric_switch();
	
	level thread magic_box_init();
	//zm_timer::init();


	//Setup the levels Zombie Zone Volumes
	level.zones = [];
	level.zone_manager_init_func =&factory_zone_init;
	init_zones[0] = "receiver_zone";
	level thread zm_zonemgr::manage_zones( init_zones );

	level.zombie_ai_limit = 24;

	level thread intro_screen();

	level thread jump_from_bridge();
	level lock_additional_player_spawner();

	level thread bridge_init();
	
	
	level thread sndFunctions();
	level.sndTrapFunc = &sndPA_Traps;
	level.monk_scream_trig = getent( "monk_scream_trig", "targetname" );

	// DCS: mature and german safe settings.
	level thread factory_german_safe();
	level thread mature_settings_changes();


	// Special level specific settings
	zombie_utility::set_zombie_var( "zombie_powerup_drop_max_per_round", 3 );	// lower this to make drop happen more often

	// Check under the machines for change
	trigs = GetEntArray( "audio_bump_trigger", "targetname" );
	for ( i=0; i<trigs.size; i++ )
	{
		if ( IsDefined(trigs[i].script_sound) && trigs[i].script_sound == "fly_bump_bottle" )
		{
			trigs[i] thread check_for_change();
		}
	}

	trigs = GetEntArray( "trig_ee", "targetname" );
	array::thread_all( trigs,&extra_events);

//	level thread flytrap();

	// Set the color vision set back
//	level.zombie_visionset = "zombie_factory";
	
	
//	VisionSetNaked( "zombie_factory", 0 );
//t6todo	SetSavedDvar( "r_lightGridEnableTweaks", 1 );
//t6todo	SetSavedDvar( "r_lightGridIntensity", 1.45 );
//t6todo	SetSavedDvar( "r_lightGridContrast", 0.15 );

//t6todo	zombie_cod5_factory_art::main();
	
	//DCS: get betties working.
//t6todo	_zombiemode_betty::init();	
}

function cinematic()
{
	level flag::wait_till( "all_players_connected" );

	SetDvar( "cg_draw2D", 0 );
	SetDvar( "cg_drawFPS", 0 );
	SetDvar( "cg_drawPerformanceWarnings", 0 );
	
	while( !areTexturesLoaded() )
	{
		{wait(.05);};
	}

	VisionSetNaked( "cp_igc_chinatown_intro", 0.05 );	
	
	//freeze players
	foreach( e_player in level.players )
	{
		e_player freezecontrols( true );
		e_player AllowSprint( false	);
		e_player AllowJump( false );
	}
	
	//turn off RADAR, AMMO COUNT	
	level.players[0] SetClientUIVisibilityFlag( "hud_visible", 0 );
	
	//turns off FOV info
	SetDvar( "debug_show_viewpos", "0" ); 
	
	//go to a black screen
//	util::screen_fade_out( 0.05 );		

	//wait a few seconds so the game fades into the level - colin needs this
	wait 3;

	//play scene bundle
	s_tag_align = struct::get( "tag_align_switch_box" );
	s_tag_align scene::play( "cin_der_01_intro_3rd_sh010" );
}


function clock_shot( a_ents )
{
	clock = GetEnt( "factory_clock", "targetname" );
	clock thread scene::play( "p7_fxanim_zm_factory_clock_igc_bundle" );
}

function on_player_spawned()
{
	self SetLightingState( level.lighting_state );
}

function offhand_weapon_overrride()
{
	zm_utility::register_lethal_grenade_for_level( "frag_grenade" );
	level.zombie_lethal_grenade_player_init = GetWeapon( "frag_grenade" );

	zm_utility::register_tactical_grenade_for_level( "cymbal_monkey" );
	zm_utility::register_tactical_grenade_for_level( "emp_grenade" );

	zm_utility::register_melee_weapon_for_level( level.weaponBaseMelee.name );
	zm_utility::register_melee_weapon_for_level( "bowie_knife" );
	zm_utility::register_melee_weapon_for_level( "tazer_knuckles" );
	level.zombie_melee_weapon_player_init = level.weaponBaseMelee;
	
	level.zombie_equipment_player_init = undefined;
}

function offhand_weapon_give_override( weapon )
{
	self endon( "death" );
	
	if( zm_utility::is_tactical_grenade( weapon ) && IsDefined( self zm_utility::get_player_tactical_grenade() ) && !self zm_utility::is_player_tactical_grenade( weapon )  )
	{
		self SetWeaponAmmoClip( self zm_utility::get_player_tactical_grenade(), 0 );
		self TakeWeapon( self zm_utility::get_player_tactical_grenade() );
	}
	return false;
}

/////////////////////////////////////////////////////////////////////
// Zombie Requirements To Get Map Running
/////////////////////////////////////////////////////////////////////

function include_powerups()
{	
	zm_powerups::add_zombie_special_drop( "nothing" );
	//zm_powerups::add_zombie_special_drop( "dog" );//TODO T7 - enable once dogs come back online
}

function include_perks()
{
	
}

function include_weapons()
{
}

function precacheCustomCharacters()
{
	//c_usa_dempsey_zm::precache();
	//c_rus_nikolai_zm::precache();
	//c_jap_takeo_zm::precache();
	//c_ger_richtofen_zm::precache();
}


function initCharacterStartIndex()
{
	level.characterStartIndex = RandomInt( 4 );
}

function selectCharacterIndexToUse()
{
	if( level.characterStartIndex>=4 )
	level.characterStartIndex = 0;

	self.characterIndex = level.characterStartIndex;
	level.characterStartIndex++;

	return self.characterIndex;
}


function assign_lowest_unused_character_index()
{
	//get the lowest unused character index
	charindexarray = [];
	charindexarray[0] = 0;// - Dempsey )
	charindexarray[1] = 1;// - Nikolai )
	charindexarray[2] = 2;// - Richtofen )
	charindexarray[3] = 3;// - Takeo )
	
	players = GetPlayers();
	if ( players.size == 1 )
	{
		charindexarray = array::randomize( charindexarray );
		if ( charindexarray[0] == 2 )
		{
			level.has_richtofen = true;	
		}

		return charindexarray[0];
	}
	else // 2 or more players just assign the lowest unused value
	{
		n_characters_defined = 0;

		foreach ( player in players )
		{
			if ( isDefined( player.characterIndex ) )
			{
				ArrayRemoveValue( charindexarray, player.characterIndex, false );
				n_characters_defined++;
			}
		}
		
		if ( charindexarray.size > 0 )
		{
			// If this is the last guy and we don't have Richtofen in the group yet, make sure he's Richtofen
			if ( n_characters_defined == (players.size - 1) )
			{
				if ( !( isdefined( level.has_richtofen ) && level.has_richtofen ) )
				{
					level.has_richtofen = true;
					return 2;
				}	
			}
			
			// Randomize the array
			charindexarray = array::randomize(charindexarray);
			if ( charindexarray[0] == 2 )
			{
				level.has_richtofen = true;	
			}

			return charindexarray[0];
		}
	}

	//failsafe
	return 0;
}

function giveCustomCharacters()
{
	if( isdefined(level.hotjoin_player_setup) && [[level.hotjoin_player_setup]]("c_zom_farmgirl_viewhands") )
	{
		return;
	}
	
	self DetachAll();
	
	// Only Set Character Index If Not Defined, Since This Thread Gets Called Each Time Player Respawns
	//-------------------------------------------------------------------------------------------------
	if ( !isdefined( self.characterIndex ) )
	{
		self.characterIndex = assign_lowest_unused_character_index();
	}
	
	self.favorite_wall_weapons_list = [];
	self.talks_in_danger = false;	
	
	/#
		if(GetDvarString("force_char") != "")
		{
			self.characterIndex = getdvarint("force_char");
		}

	#/

	self SetCharacterBodyType( self.characterIndex );
	self SetCharacterBodyStyle( 0 );
	self SetCharacterHelmetStyle( 0 );
	
	switch( self.characterIndex )
	{
		case 1:
		{
				// Nikolai
//				level.vox zm_audio::zmbVoxInitSpeaker( "player", "vox_plr_", self );				
				self.favorite_wall_weapons_list[self.favorite_wall_weapons_list.size] = GetWeapon( "870mcs" );
				break;
		}
		case 0:
		{
				// Dempsey

//				level.vox zm_audio::zmbVoxInitSpeaker( "player", "vox_plr_", self );				
				self.favorite_wall_weapons_list[self.favorite_wall_weapons_list.size] = GetWeapon( "frag_grenade" );
				self.favorite_wall_weapons_list[self.favorite_wall_weapons_list.size] = GetWeapon( "bouncingbetty" );
				break;
		}
		case 3:
		{
				// Takeo
//				level.vox zm_audio::zmbVoxInitSpeaker( "player", "vox_plr_", self );
				self.favorite_wall_weapons_list[self.favorite_wall_weapons_list.size] = GetWeapon( "hk416" );
				break;
		}
		case 2:
		{	
				// Richtofen
//				level.vox zm_audio::zmbVoxInitSpeaker( "player", "vox_plr_", self );
				self.talks_in_danger = true;
				level.rich_sq_player = self;
				level.sndRadioA = self;
				self.favorite_wall_weapons_list[self.favorite_wall_weapons_list.size] = GetWeapon( "pistol_standard" );
				break;
		}
	}	

	self SetMoveSpeedScale( 1 );
	self SetSprintDuration( 4 );
	self SetSprintCooldown( 0 );	

	//self zm_utility::set_player_tombstone_index();	
	self thread set_exert_id();
	
}

function set_exert_id()
{
	self endon("disconnect");
	
	util::wait_network_frame();
	util::wait_network_frame();
	
	self zm_audio::SetExertVoice(self.characterIndex + 1);
}

function setup_personality_character_exerts()
{
	// perk burp
	level.exert_sounds[1]["burp"][0] = "vox_plr_0_exert_burp_0";
	level.exert_sounds[1]["burp"][1] = "vox_plr_0_exert_burp_1";
	level.exert_sounds[1]["burp"][2] = "vox_plr_0_exert_burp_2";
	level.exert_sounds[1]["burp"][3] = "vox_plr_0_exert_burp_3";
	level.exert_sounds[1]["burp"][4] = "vox_plr_0_exert_burp_4";
	level.exert_sounds[1]["burp"][5] = "vox_plr_0_exert_burp_5";	
	level.exert_sounds[1]["burp"][6] = "vox_plr_0_exert_burp_6";

	level.exert_sounds[2]["burp"][0] = "vox_plr_1_exert_burp_0";
	level.exert_sounds[2]["burp"][1] = "vox_plr_1_exert_burp_1";
	level.exert_sounds[2]["burp"][2] = "vox_plr_1_exert_burp_2";
	level.exert_sounds[2]["burp"][3] = "vox_plr_1_exert_burp_3";

	level.exert_sounds[3]["burp"][0] = "vox_plr_2_exert_burp_0";
	level.exert_sounds[3]["burp"][1] = "vox_plr_2_exert_burp_1";
	level.exert_sounds[3]["burp"][2] = "vox_plr_2_exert_burp_2";
	level.exert_sounds[3]["burp"][3] = "vox_plr_2_exert_burp_3";
	level.exert_sounds[3]["burp"][4] = "vox_plr_2_exert_burp_4";
	level.exert_sounds[3]["burp"][5] = "vox_plr_2_exert_burp_5";	
	level.exert_sounds[3]["burp"][6] = "vox_plr_2_exert_burp_6";
	
	level.exert_sounds[4]["burp"][0] = "vox_plr_3_exert_burp_0";
	level.exert_sounds[4]["burp"][1] = "vox_plr_3_exert_burp_1";
	level.exert_sounds[4]["burp"][2] = "vox_plr_3_exert_burp_2";
	level.exert_sounds[4]["burp"][3] = "vox_plr_3_exert_burp_3";
	level.exert_sounds[4]["burp"][4] = "vox_plr_3_exert_burp_4";
	level.exert_sounds[4]["burp"][5] = "vox_plr_3_exert_burp_5";	
	level.exert_sounds[4]["burp"][6] = "vox_plr_3_exert_burp_6";

	// medium hit
	level.exert_sounds[1]["hitmed"][0] = "vox_plr_0_exert_pain_medium_0";
	level.exert_sounds[1]["hitmed"][1] = "vox_plr_0_exert_pain_medium_1";
	level.exert_sounds[1]["hitmed"][2] = "vox_plr_0_exert_pain_medium_2";
	level.exert_sounds[1]["hitmed"][3] = "vox_plr_0_exert_pain_medium_3";
	
	level.exert_sounds[2]["hitmed"][0] = "vox_plr_1_exert_pain_medium_0";
	level.exert_sounds[2]["hitmed"][1] = "vox_plr_1_exert_pain_medium_1";
	level.exert_sounds[2]["hitmed"][2] = "vox_plr_1_exert_pain_medium_2";
	level.exert_sounds[2]["hitmed"][3] = "vox_plr_1_exert_pain_medium_3";
	
	level.exert_sounds[3]["hitmed"][0] = "vox_plr_2_exert_pain_medium_0";
	level.exert_sounds[3]["hitmed"][1] = "vox_plr_2_exert_pain_medium_1";
	level.exert_sounds[3]["hitmed"][2] = "vox_plr_2_exert_pain_medium_2";
	level.exert_sounds[3]["hitmed"][3] = "vox_plr_2_exert_pain_medium_3";
	
	level.exert_sounds[4]["hitmed"][0] = "vox_plr_3_exert_pain_medium_0";
	level.exert_sounds[4]["hitmed"][1] = "vox_plr_3_exert_pain_medium_1";
	level.exert_sounds[4]["hitmed"][2] = "vox_plr_3_exert_pain_medium_2";
	level.exert_sounds[4]["hitmed"][3] = "vox_plr_3_exert_pain_medium_3";

	// large hit
	level.exert_sounds[1]["hitlrg"][0] = "vox_plr_0_exert_pain_high_0";
	level.exert_sounds[1]["hitlrg"][1] = "vox_plr_0_exert_pain_high_1";
	level.exert_sounds[1]["hitlrg"][2] = "vox_plr_0_exert_pain_high_2";
	level.exert_sounds[1]["hitlrg"][3] = "vox_plr_0_exert_pain_high_3";
	
	level.exert_sounds[2]["hitlrg"][0] = "vox_plr_1_exert_pain_high_0";
	level.exert_sounds[2]["hitlrg"][1] = "vox_plr_1_exert_pain_high_1";
	level.exert_sounds[2]["hitlrg"][2] = "vox_plr_1_exert_pain_high_2";
	level.exert_sounds[2]["hitlrg"][3] = "vox_plr_1_exert_pain_high_3";
	
	level.exert_sounds[3]["hitlrg"][0] = "vox_plr_2_exert_pain_high_0";
	level.exert_sounds[3]["hitlrg"][1] = "vox_plr_2_exert_pain_high_1";
	level.exert_sounds[3]["hitlrg"][2] = "vox_plr_2_exert_pain_high_2";
	level.exert_sounds[3]["hitlrg"][3] = "vox_plr_2_exert_pain_high_3";
	
	level.exert_sounds[4]["hitlrg"][0] = "vox_plr_3_exert_pain_high_0";
	level.exert_sounds[4]["hitlrg"][1] = "vox_plr_3_exert_pain_high_1";
	level.exert_sounds[4]["hitlrg"][2] = "vox_plr_3_exert_pain_high_2";
	level.exert_sounds[4]["hitlrg"][3] = "vox_plr_3_exert_pain_high_3";
}

function giveCustomLoadout( takeAllWeapons, alreadySpawned )
{
	self giveWeapon( level.weaponBaseMelee );
	self zm_utility::give_start_weapon( true );
}

function custom_add_weapons()
{
	zm_weapons::load_weapon_spec_from_table("gamedata/weapons/zm/zm_factory_weapons.csv", 1);
}

function custom_add_vox()
{
	zm_audio::loadPlayerVoiceCategories("gamedata/audio/zm/zm_factory_vox.csv");
}


function init_achievement()
{
	//include_achievement( "achievement_shiny" );
	//include_achievement( "achievement_monkey_see" );
	//include_achievement( "achievement_frequent_flyer" );
	//include_achievement( "achievement_this_is_a_knife" );
	//include_achievement( "achievement_martian_weapon" );
	//include_achievement( "achievement_double_whammy" );
	//include_achievement( "achievement_perkaholic" );
	//include_achievement( "achievement_secret_weapon", "zombie_kar98k_upgraded" );
	//include_achievement( "achievement_no_more_door" );
	//include_achievement( "achievement_back_to_future" );

}


//-------------------------------------------------------------------------------
//	Create the zone information for zombie spawning
//-------------------------------------------------------------------------------
function factory_zone_init()
{
	// Note this setup is based on a flag-centric view of setting up your zones.  A brief
	//	zone-centric example exists below in comments

	// Outside East Door
	zm_zonemgr::add_adjacent_zone( "receiver_zone",		"outside_east_zone",	"enter_outside_east" );

	// Outside West Door
	zm_zonemgr::add_adjacent_zone( "receiver_zone",		"outside_west_zone",	"enter_outside_west" );

	// Wnuen building ground floor
	zm_zonemgr::add_adjacent_zone( "wnuen_zone",		"outside_east_zone",	"enter_wnuen_building" );

	// Wnuen stairway
	zm_zonemgr::add_adjacent_zone( "wnuen_zone",		"wnuen_bridge_zone",	"enter_wnuen_loading_dock" );

	// Warehouse bottom 
	zm_zonemgr::add_adjacent_zone( "warehouse_bottom_zone", "outside_west_zone",	"enter_warehouse_building" );

	// Warehosue top
	zm_zonemgr::add_adjacent_zone( "warehouse_bottom_zone", "warehouse_top_zone",	"enter_warehouse_second_floor" );
	zm_zonemgr::add_adjacent_zone( "warehouse_top_zone",	"bridge_zone",			"enter_warehouse_second_floor" );

	// TP East
	zm_zonemgr::add_adjacent_zone( "tp_east_zone",			"wnuen_zone",			"enter_tp_east" );
	
	zm_zonemgr::add_adjacent_zone( "tp_east_zone",			"outside_east_zone",	"enter_tp_east",			true );
	zm_zonemgr::add_zone_flags(	"enter_tp_east",										"enter_wnuen_building" );

	// TP South
	zm_zonemgr::add_adjacent_zone( "tp_south_zone",			"outside_south_zone",	"enter_tp_south" );

	// TP West
	zm_zonemgr::add_adjacent_zone( "tp_west_zone",			"warehouse_top_zone",	"enter_tp_west" );
	
	//_zm_zonemgr::add_adjacent_zone( "tp_west_zone",			"warehouse_bottom_zone", "enter_tp_west",		true );
	//_zm_zonemgr::add_zone_flags(	"enter_tp_west",										"enter_warehouse_second_floor" );
}




//
//	Intro Chyron!
function intro_screen()
{
	if ( 1 == GetDvarInt( "movie_intro" ) )
	{
		return;
	}

	level flag::wait_till( "start_zombie_round_logic" );
	wait(2);
	level.intro_hud = [];
	for(i = 0;  i < 3; i++)
	{
		level.intro_hud[i] = newHudElem();
		level.intro_hud[i].x = 0;
		level.intro_hud[i].y = 0;
		level.intro_hud[i].alignX = "left";
		level.intro_hud[i].alignY = "bottom";
		level.intro_hud[i].horzAlign = "left";
		level.intro_hud[i].vertAlign = "bottom";
		level.intro_hud[i].foreground = true;

		if ( level.splitscreen && !level.hidef )
		{
			level.intro_hud[i].fontScale = 2.75;
		}
		else
		{
			level.intro_hud[i].fontScale = 1.75;
		}
		level.intro_hud[i].alpha = 0.0;
		level.intro_hud[i].color = (1, 1, 1);
		level.intro_hud[i].inuse = false;
	}
	level.intro_hud[0].y = -110;
	level.intro_hud[1].y = -90;
	level.intro_hud[2].y = -70;


	level.intro_hud[0] settext(&"ZOMBIE_INTRO_FACTORY_LEVEL_PLACE");
	level.intro_hud[1] settext("");
	level.intro_hud[2] settext("");
//	level.intro_hud[1] settext(&"ZOMBIE_INTRO_FACTORY_LEVEL_TIME");
//	level.intro_hud[2] settext(&"ZOMBIE_INTRO_FACTORY_LEVEL_DATE");

	for(i = 0 ; i < 3; i++)
	{
		level.intro_hud[i] FadeOverTime( 3.5 ); 
		level.intro_hud[i].alpha = 1;
		wait(1.5);
	}
	wait(1.5);
	for(i = 0 ; i < 3; i++)
	{
		level.intro_hud[i] FadeOverTime( 3.5 ); 
		level.intro_hud[i].alpha = 0;
		wait(1.5);
	}	
	//wait(1.5);
	for(i = 0 ; i < 3; i++)
	{
		level.intro_hud[i] destroy();
	}
}

//-------------------------------------------------------------------
//	Animation functions - need to be specified separately in order to use different animtrees
//-------------------------------------------------------------------
//t6todo #using_animtree( "waw_zombie_factory" );
function script_anims_init()
{
	//t6todolevel.scr_anim[ "half_gate" ]			= %o_zombie_lattice_gate_half;
	//t6todolevel.scr_anim[ "full_gate" ]			= %o_zombie_lattice_gate_full;
	//t6todolevel.scr_anim[ "difference_engine" ]	= %o_zombie_difference_engine_ani;

	//t6todolevel.blocker_anim_func =&factory_playanim;
}

function factory_playanim( animname )
{
//t6todo	self UseAnimTree(#animtree);
//t6todo	self animscripted("door_anim", self.origin, self.angles, level.scr_anim[animname] );
}


function anim_override_func()
{
/*		level._zombie_melee[0] 				= %ai_zombie_attack_forward_v1; 
		level._zombie_melee[1] 				= %ai_zombie_attack_forward_v2; 
		level._zombie_melee[2] 				= %ai_zombie_attack_v1; 
		level._zombie_melee[3] 				= %ai_zombie_attack_v2;	
		level._zombie_melee[4]				= %ai_zombie_attack_v1;
		level._zombie_melee[5]				= %ai_zombie_attack_v4;
		level._zombie_melee[6]				= %ai_zombie_attack_v6;	

		level._zombie_run_melee[0]				=	%ai_zombie_run_attack_v1;
		level._zombie_run_melee[1]				=	%ai_zombie_run_attack_v2;
		level._zombie_run_melee[2]				=	%ai_zombie_run_attack_v3;

		level.scr_anim["zombie"]["run4"] 	= %ai_zombie_run_v2;
		level.scr_anim["zombie"]["run5"] 	= %ai_zombie_run_v4;
		level.scr_anim["zombie"]["run6"] 	= %ai_zombie_run_v3;

		level.scr_anim["zombie"]["walk5"] 	= %ai_zombie_walk_v6;
		level.scr_anim["zombie"]["walk6"] 	= %ai_zombie_walk_v7;
		level.scr_anim["zombie"]["walk7"] 	= %ai_zombie_walk_v8;
		level.scr_anim["zombie"]["walk8"] 	= %ai_zombie_walk_v9;
*/
}

function lock_additional_player_spawner()
{
	
	spawn_points = struct::get_array("player_respawn_point", "targetname");
	for( i = 0; i < spawn_points.size; i++ )
	{

			spawn_points[i].locked = true;

	}
}


//-------------------------------------------------------------------------------
// handles lowering the bridge when power is turned on
//-------------------------------------------------------------------------------
function bridge_init()
{
	level flag::init( "bridge_down" );
	
	bridge_audio = struct::get( "bridge_audio", "targetname" );

	// wait for power
	level flag::wait_till( "power_on" );
	level util::clientnotify ("pl1");
	
	
	
	//if(isdefined( bridge_audio ) )
		//playsoundatposition( "evt_bridge_lower", bridge_audio.origin );

//	exploder::exploder( 500 );
	level thread scene::play( "p7_fxanim_zm_factory_bridge_lft_bundle" );
	level scene::play( "p7_fxanim_zm_factory_bridge_rt_bundle" );
	// wait until the bridges are down.
	
	level flag::set( "bridge_down" );
	//if(isdefined( bridge_audio ) )
	{
		//playsoundatposition( "evt_bridge_hit", bridge_audio.origin );
	}

	wnuen_bridge_clip = getent( "wnuen_bridge_clip", "targetname" );
	wnuen_bridge_clip connectpaths();
	wnuen_bridge_clip delete();

	warehouse_bridge_clip = getent( "warehouse_bridge_clip", "targetname" );
	warehouse_bridge_clip connectpaths();
	warehouse_bridge_clip delete();

	wnuen_bridge = getent( "wnuen_bridge", "targetname" );
	wnuen_bridge connectpaths();

	zm_zonemgr::connect_zones( "wnuen_bridge_zone", "bridge_zone" );
	zm_zonemgr::connect_zones( "warehouse_top_zone", "bridge_zone" );
	
	wait(14);
	
	level thread zm_factory::sndPA_DoVox( "vox_maxis_teleporter_lost_0" );
}

function bridge_disconnect( a_parts )
{
	foreach( part in a_parts )
	{
		part DisconnectPaths();
	}
}

function bridge_connect( a_parts )
{
	foreach( part in a_parts )
	{
		part ConnectPaths();
	}
}

function jump_from_bridge()
{
	trig = GetEnt( "trig_outside_south_zone", "targetname" );
	trig waittill( "trigger" );

	zm_zonemgr::connect_zones( "outside_south_zone", "bridge_zone", true );
	zm_zonemgr::connect_zones( "outside_south_zone", "wnuen_bridge_zone", true );
}


function init_sounds()
{
	zm_utility::add_sound( "break_stone", "evt_break_stone" );
	zm_utility::add_sound( "gate_door",	"zmb_gate_slide_open" );
	zm_utility::add_sound( "heavy_door",	"zmb_heavy_door_open" );

	// override the default slide with the buzz slide
	zm_utility::add_sound("zmb_heavy_door_open", "zmb_heavy_door_open");
}

function factory_ray_gun_weighting_func()
{
	if( level.chest_moves > 0 )
	{	
		num_to_add = 1;
		// increase the percentage of ray gun
		if( isDefined( level.pulls_since_last_ray_gun ) )
		{
			// after 12 pulls the ray gun percentage increases to 15%
			if( level.pulls_since_last_ray_gun > 11 )
			{
				num_to_add += int(level.zombie_include_weapons.size*0.1);
			}			
			// after 8 pulls the Ray Gun percentage increases to 10%
			else if( level.pulls_since_last_ray_gun > 7 )
			{
				num_to_add += int(.05 * level.zombie_include_weapons.size);
			}		
		}
		return num_to_add;	
	}
	else
	{
		return 0;
	}
}


//
//	Slightly elevate the chance to get it until someone has it, then make it even
function factory_cymbal_monkey_weighting_func()
{
	players = GetPlayers();
	count = 0;
	for( i = 0; i < players.size; i++ )
	{
		if( players[i] zm_weapons::has_weapon_or_upgrade( "cymbal_monkey_zm" ) )
		{
			count++;
		}
	}
	if ( count > 0 )
	{
		return 1;
	}
	else
	{
		if( level.round_number < 10 )
		{
			return 3;
		}
		else
		{
			return 5;
		}
	}
}


//
//	This initialitze the box spawn locations
//	You can disable boxes from appearing by not adding their script_noteworthy ID to the list
//
function magic_box_init()
{
	//MM - all locations are valid.  If it goes somewhere you haven't opened, you need to open it.
	level.open_chest_location = [];
	level.open_chest_location[0] = "chest1";	// TP East
	level.open_chest_location[1] = "chest2";	// TP West
	level.open_chest_location[2] = "chest3";	// TP South
	level.open_chest_location[3] = "chest4";	// WNUEN
	level.open_chest_location[4] = "chest5";	// Warehouse bottom
	level.open_chest_location[5] = "start_chest";
}


/# 
function power_on_listener( trig )
{
	trig endon( "trigger" );

	level flag::wait_till("power_on");

	trig notify( "trigger" );
}
#/


/*------------------------------------
the electric switch under the bridge
once this is used, it activates other objects in the map
and makes them available to use
------------------------------------*/
function power_electric_switch()
{
	trig = getent("use_power_switch","targetname");
	trig sethintstring(&"ZOMBIE_ELECTRIC_SWITCH");
	trig SetCursorHint( "HINT_NOICON" ); 

	//turn off the buyable door triggers for electric doors
// 	door_trigs = getentarray("electric_door","script_noteworthy");
// 	array::thread_all(door_trigs,::set_door_unusable);
// 	array::thread_all(door_trigs,::play_door_dialog);

	cheat = false;
	
/# 
	if( GetDvarInt( "zombie_cheat" ) >= 3 )
	{
		wait( 5 );
		cheat = true;
	}
#/	

	user = undefined;
	if ( cheat != true )
	{
		level thread power_on_listener( trig );

		trig waittill("trigger",user);
		if( isdefined( user ) )
		{
			//user zm_audio::create_and_play_dialog( "general", "power_on" );
		}
	}
	
	// MM - turning on the power powers the entire map
// 	if ( IsDefined(user) )	// only send a notify if we weren't originally triggered through script
// 	{
// 		other_trig = getent("use_warehouse_switch","targetname");
// 		other_trig notify( "trigger", undefined );
// 
// 		wuen_trig = getent("use_wuen_switch", "targetname" );
// 		wuen_trig notify( "trigger", undefined );
// 	}

	level thread scene::play( "power_switch", "targetname" );

	//TO DO (TUEY) - kick off a 'switch' on client script here that operates similiarly to Berlin2 subway.
	level flag::set( "power_on" );
	util::wait_network_frame();
	level notify( "sleight_on" );
	util::wait_network_frame();
	level notify( "revive_on" );
	util::wait_network_frame();
	level notify( "doubletap_on" );
	util::wait_network_frame();
	level notify( "juggernog_on" );
	util::wait_network_frame();
	level notify( "Pack_A_Punch_on" );
	util::wait_network_frame();
	level notify( "specialty_armorvest_power_on" );
	util::wait_network_frame();
	level notify( "specialty_rof_power_on" );
	util::wait_network_frame();
	level notify( "specialty_quickrevive_power_on" );
	util::wait_network_frame();
	level notify( "specialty_fastreload_power_on" );
	util::wait_network_frame();

	level.lighting_state = 0; // power_on
	SetLightingState( level.lighting_state );

//	util::clientNotify( "power_on" );
	util::clientNotify("ZPO");	// Zombie Power On!
	util::wait_network_frame();
//	exploder::exploder(600);

	trig delete();	
	
	wait 1;
	
	s_switch = struct::get("power_switch_fx","targetname");
	forward = AnglesToForward( s_switch.origin );
	playfx( level._effect["switch_sparks"], s_switch.origin, forward );

	// Don't want east or west to spawn when in south zone, but vice versa is okay
	zm_zonemgr::connect_zones( "outside_east_zone", "outside_south_zone" );
	zm_zonemgr::connect_zones( "outside_west_zone", "outside_south_zone", true );
	
	level util::delay( 19, undefined, &zm_audio::sndMusicSystem_PlayState, "power_on" );
}

//*** AUDIO SECTION ***

function check_for_change()
{
	while (1)
	{
		self waittill( "trigger", player );

		if ( player GetStance() == "prone" )
		{
			player zm_score::add_to_player_score( 25 );
			zm_utility::play_sound_at_pos( "purchase", player.origin );
			break;
		}

		wait(0.1);
	}
}

function extra_events()
{
	self UseTriggerRequireLookAt();
	self SetCursorHint( "HINT_NOICON" ); 
	self waittill( "trigger" );

	targ = GetEnt( self.target, "targetname" );
	if ( IsDefined(targ) )
	{
		targ MoveZ( -10, 5 );
	}
}


//
//	Activate the flytrap!
function flytrap()
{
	level flag::init( "hide_and_seek" );
	level.flytrap_counter = 0;

	// Hide Easter Eggs...
	// Explosive Monkey
	level thread hide_and_seek_target( "ee_exp_monkey" );
	util::wait_network_frame();
	level thread hide_and_seek_target( "ee_bowie_bear" );
	util::wait_network_frame();
	level thread hide_and_seek_target( "ee_perk_bear" );
	util::wait_network_frame();
	
	trig_control_panel = GetEnt( "trig_ee_flytrap", "targetname" );

	// Wait for it to be hit by an upgraded weapon
	upgrade_hit = false;
	while ( !upgrade_hit )
	{
		trig_control_panel waittill( "damage", amount, inflictor, direction, point, type );

		weapon = inflictor getcurrentweapon();
		if ( zm_weapons::is_weapon_upgraded( weapon ) )
		{
			upgrade_hit = true;
		}
	}

	trig_control_panel playsound( "flytrap_hit" );
	playsoundatposition( "flytrap_creeper", trig_control_panel.origin );
	thread zm_utility::play_sound_2D( "vox_sam_fly_laugh" );
	//iprintlnbold( "Samantha Sez: Hahahahahaha" );

	// Float the objects
//	level achievement_notify("DLC3_ZOMBIE_ANTI_GRAVITY");
	level util::clientNotify( "ag1" );	// Anti Gravity ON
	wait(9.0);
	thread zm_utility::play_sound_2D( "vox_sam_fly_act_0" );
	wait(6.0);
	
	thread zm_utility::play_sound_2D( "vox_sam_fly_act_1" );
	//iprintlnbold( "Samantha Sez: Let's play Hide and Seek!" );

	//	Now find them!
	level flag::set( "hide_and_seek" );

	level flag::wait_till( "ee_exp_monkey" );
	level flag::wait_till( "ee_bowie_bear" );
	level flag::wait_till( "ee_perk_bear" );

	// Colin, play music here.
//	println( "Still Alive" );
}


//
//	Controls hide and seek object and trigger
function hide_and_seek_target( target_name )
{
	level flag::init( target_name );

	obj_array = GetEntArray( target_name, "targetname" );
	for ( i=0; i<obj_array.size; i++ )
	{
		obj_array[i] Hide();
	}

	trig = GetEnt( "trig_"+target_name, "targetname" );
	trig TriggerEnable( false );
	level flag::wait_till( "hide_and_seek" );

	// Show yourself
	for ( i=0; i<obj_array.size; i++ )
	{
		obj_array[i] Show();
	}
	trig TriggerEnable( true );
	trig waittill( "trigger" );
	
	level.flytrap_counter = level.flytrap_counter +1;
	thread flytrap_samantha_vox();
	trig playsound( "object_hit" );

	for ( i=0; i<obj_array.size; i++ )
	{
		obj_array[i] Hide();
	}
	level flag::set( target_name );
}

function phono_egg_init( trigger_name, origin_name )
{
	if(!IsDefined (level.phono_counter))
	{
		level.phono_counter = 0;	
	}
	players = GetPlayers();
	phono_trig = getent ( trigger_name, "targetname");
	phono_origin = getent( origin_name, "targetname");
	
	if( ( !isdefined( phono_trig ) ) || ( !isdefined( phono_origin ) ) )
	{
		return;
	}
	
	phono_trig UseTriggerRequireLookAt();
	phono_trig SetCursorHint( "HINT_NOICON" ); 
	
	for(i=0;i<players.size;i++)
	{			
		phono_trig waittill( "trigger", players);
		level.phono_counter = level.phono_counter + 1;
		phono_origin play_phono_egg();
	}	
}

function play_phono_egg()
{
	if(!IsDefined (level.phono_counter))
	{
		level.phono_counter = 0;	
	}
	
	if( level.phono_counter == 1 )
	{
		//iprintlnbold( "Phono Egg One Activated!" );
		self playsound( "evt_phono_one" );
	}
	if( level.phono_counter == 2 )
	{
		//iprintlnbold( "Phono Egg Two Activated!" );
		self playsound( "evt_phono_two" );
	}
	if( level.phono_counter == 3 )
	{
		//iprintlnbold( "Phono Egg Three Activated!" );
		self playsound( "evt_phono_three" );
	}
}

function radio_egg_init( trigger_name, origin_name )
{
	players = GetPlayers();
	radio_trig = getent( trigger_name, "targetname");
	radio_origin = getent( origin_name, "targetname");

	if( ( !isdefined( radio_trig ) ) || ( !isdefined( radio_origin ) ) )
	{
		return;
	}

	radio_trig UseTriggerRequireLookAt();
	radio_trig SetCursorHint( "HINT_NOICON" ); 
	radio_origin playloopsound( "amb_radio_static" );

	for(i=0;i<players.size;i++)
	{			
		radio_trig waittill( "trigger", players);
		radio_origin stoploopsound( .1 );
		//iprintlnbold( "You activated " + trigger_name + ", playing off " + origin_name );
		radio_origin playsound( trigger_name );
	}	
}

function play_music_easter_egg(player)
{
	level.music_override = true;
	
	wait(4);
	
	if( IsDefined( player ) )
	{
	    player zm_audio::create_and_play_dialog( "eggs", "music_activate" );
	}
	
	wait(236);	
	level.music_override = false;
}

function meteor_egg(trigger_name)
{
	meteor_trig = getent ( trigger_name, "targetname");
	
	meteor_trig UseTriggerRequireLookAt();
	meteor_trig SetCursorHint( "HINT_NOICON" ); 
	meteor_trig PlayLoopSound( "zmb_meteor_loop" );
		
	meteor_trig waittill( "trigger", player );
	
	meteor_trig StopLoopSound( 1 );
	player PlaySound( "zmb_meteor_activate" );
	
	// no meterors in this level
	//player zm_audio::create_and_play_dialog( "eggs", "meteors", undefined, level.meteor_counter );
		
	level.meteor_counter = level.meteor_counter + 1;
	
	if( level.meteor_counter == 3 )
	{ 
	    level thread play_music_easter_egg( player );
	}
}

function flytrap_samantha_vox()
{
	if(!IsDefined (level.flytrap_counter))
	{
		level.flytrap_counter = 0;	
	}

	if( level.flytrap_counter == 1 )
	{
		//iprintlnbold( "Samantha Sez: Way to go!" );
		thread zm_utility::play_sound_2D( "vox_sam_fly_first" );
	}
	if( level.flytrap_counter == 2 )
	{
		//iprintlnbold( "Samantha Sez: Two? WOW!" );
		thread zm_utility::play_sound_2D( "vox_sam_fly_second" );
	}
	if( level.flytrap_counter == 3 )
	{
		//iprintlnbold( "Samantha Sez: And GAME OVER!" );		
		thread zm_utility::play_sound_2D( "vox_sam_fly_last" );
		return;
	}
	{wait(.05);};
}

//-------------------------------------------------------------------------------
// Solo Revive zombie exit points.
//-------------------------------------------------------------------------------
function factory_exit_level()
{
	zombies = GetAiArray( level.zombie_team );
	for ( i = 0; i < zombies.size; i++ )
	{
		zombies[i] thread factory_find_exit_point();
	}
}
function factory_find_exit_point()
{
	self endon( "death" );

	player = GetPlayers()[0];

	dist_zombie = 0;
	dist_player = 0;
	dest = 0;

	away = VectorNormalize( self.origin - player.origin );
	endPos = self.origin + VectorScale( away, 600 );

	locs = array::randomize( level.enemy_dog_locations );

	for ( i = 0; i < locs.size; i++ )
	{
		dist_zombie = DistanceSquared( locs[i].origin, endPos );
		dist_player = DistanceSquared( locs[i].origin, player.origin );

		if ( dist_zombie < dist_player )
		{
			dest = i;
			break;
		}
	}

	self notify( "stop_find_flesh" );
	self notify( "zombie_acquire_enemy" );

	self SetGoal( locs[dest].origin );

	while ( 1 )
	{
		if ( !level flag::get( "wait_and_revive" ) )
		{
			break;
		}
		util::wait_network_frame();
	}
	
}

//-------------------------------------------------------------------------------
//	DCS: necessary changes for mature blood settings.
//-------------------------------------------------------------------------------
function mature_settings_changes()
{
}	
function factory_german_safe()
{
	if(util::is_german_build())
	{
		dead_guy = GetEnt("hanging_dead_guy","targetname");
		dead_guy Hide();
	}	
}	

function powerup_special_drop_override()
{
	// Always give something at lower rounds or if a player is in last stand mode.
	if ( level.round_number <= 10 )
	{
		powerup = zm_powerups::get_valid_powerup();
	}
	// Gets harder now
	else
	{
		powerup = level.zombie_special_drop_array[ RandomInt(level.zombie_special_drop_array.size) ];
		if ( level.round_number > 15 && ( RandomInt(100) < (level.round_number - 15)*5 ) )
		{
			powerup = "nothing";
		}
	}

	//MM test  Change this if you want the same thing to keep spawning
	//powerup = "dog";
	switch ( powerup )
	{
		// Limit max ammo drops because it's too powerful
		case "full_ammo":
			if ( level.round_number > 10 && ( RandomInt(100) < (level.round_number - 10)*5 ) )
			{
				// Randomly pick another one
				powerup = level.zombie_powerup_array[ RandomInt(level.zombie_powerup_array.size) ];
			}
			break;

		case "dog":
			if ( level.round_number >= 15 )
			{
				dog_spawners = GetEntArray( "special_dog_spawner", "targetname" );
	//			zm_dogs::special_dog_spawn( dog_spawners, 1 );//TODO T7 - add back in once dogs come online
				//iprintlnbold( "Samantha Sez: No Powerup For You!" );
				thread zm_utility::play_sound_2d( "vox_sam_nospawn" );
				powerup = undefined;
			}
			else
			{
				powerup = zm_powerups::get_valid_powerup();
			}
			break;

		// Nothing drops!!
		case "nothing":	// "nothing"
			// RAVEN BEGIN bhackbarth: callback for level specific powerups
			if ( IsDefined( level._zombiemode_special_drop_setup ) )
			{
				is_powerup = [[ level._zombiemode_special_drop_setup ]]( powerup );
			}
			// RAVEN END
			else
			{
				Playfx( level._effect["lightning_dog_spawn"], self.origin );
				playsoundatposition( "zmb_hellhound_prespawn", self.origin );
				wait( 1.5 );
				playsoundatposition( "zmb_hellhound_bolt", self.origin );
	
				Earthquake( 0.5, 0.75, self.origin, 1000);
				//PlayRumbleOnPosition("explosion_generic", self.origin);//TODO T7 - fix rumble
				playsoundatposition( "zmb_hellhound_spawn", self.origin );
	
				wait( 1.0 );
				//iprintlnbold( "Samantha Sez: No Powerup For You!" );
				thread zm_utility::play_sound_2d( "vox_sam_nospawn" );
				self Delete();
			}
			powerup = undefined;
			break;
	}
	return powerup;
}

//AUDIO





function sndFunctions()
{
	level thread setupMusic();
	level thread sndFirstDoor();
	level thread sndPASetup();
	level thread sndRadioSetup();
	level thread sndConversations();
}
function sndConversations()
{
	level flag::wait_till( "initial_blackscreen_passed" );
	
	level zm_audio::sndConversation_Init( "round1start" );
	level zm_audio::sndConversation_AddLine( "round1start", "round1_start_0", 4, 2 );
	level zm_audio::sndConversation_AddLine( "round1start", "round1_start_0", 2 );
	level zm_audio::sndConversation_AddLine( "round1start", "round1_start_1", 4, 2 );
	level zm_audio::sndConversation_AddLine( "round1start", "round1_start_1", 2 );
	
	level zm_audio::sndConversation_Init( "round1during", "end_of_round" );
	level zm_audio::sndConversation_AddLine( "round1during", "round1_during_0", 1 );
	level zm_audio::sndConversation_AddLine( "round1during", "round1_during_0", 3 );
	level zm_audio::sndConversation_AddLine( "round1during", "round1_during_0", 0 );
	level zm_audio::sndConversation_AddLine( "round1during", "round1_during_0", 2 );
	
	level zm_audio::sndConversation_Init( "round1end" );
	level zm_audio::sndConversation_AddLine( "round1end", "round1_end_0", 4, 2 );
	level zm_audio::sndConversation_AddLine( "round1end", "round1_end_0", 2 );
	
	level zm_audio::sndConversation_Init( "round2during", "end_of_round" );
	level zm_audio::sndConversation_AddLine( "round2during", "round2_during_0", 0 );
	level zm_audio::sndConversation_AddLine( "round2during", "round2_during_0", 3 );
	level zm_audio::sndConversation_AddLine( "round2during", "round2_during_0", 1 );
	level zm_audio::sndConversation_AddLine( "round2during", "round2_during_0", 2 );
	
	if( level.players.size >= 2 )
	{
		level thread sndConvo1();
		level thread sndConvo2();
		level thread sndConvo3();
		level thread sndConvo4();
	}
	else
	{
		level thread sndFieldReport1();
	}
}
function sndConvo1()
{
	wait(randomintrange(2,5));
	level zm_audio::sndConversation_Play( "round1start" );
}
function sndConvo2()
{
	level waittill( "sndConversationDone" );
	wait(randomintrange(20,30));
	level zm_audio::sndConversation_Play( "round1during" );
}
function sndConvo3()
{
	level waittill( "end_of_round" );
	wait(randomintrange(4,7));
	level zm_audio::sndConversation_Play( "round1end" );
}
function sndConvo4()
{
	while(1)
	{
		level waittill( "start_of_round" );
		
		if( !( isdefined( level.first_round ) && level.first_round ) )
			break;
	}
	
	wait(randomintrange(45,60));
	level zm_audio::sndConversation_Play( "round2during" );
}
function sndFieldReport1()
{
	wait(randomintrange(7,10));
	
	while( ( isdefined( level.players[0].isSpeaking ) && level.players[0].isSpeaking ) )
		wait(.5);
	
	level.sndVoxOverride = true;
	doLine( level.players[0], "fieldreport_start_0" );
	if( isdefined( getSpecificCharacter(2) ) )
	{
		doLine( level.players[0], "fieldreport_start_1" );
	}
	level.sndVoxOverride = false;
	
	level thread sndFieldReport2();
}
function sndFieldReport2()
{
	level waittill( "end_of_round" );
	wait(randomintrange(1,3));
	
	while( ( isdefined( level.players[0].isSpeaking ) && level.players[0].isSpeaking ) )
		wait(.5);
	
	level.sndVoxOverride = true;
	doLine( level.players[0], "fieldreport_round1_0" );
	level.sndVoxOverride = false;
	
	level thread sndFieldReport3();
}
function sndFieldReport3()
{
	level waittill( "end_of_round" );
	wait(randomintrange(1,3));
	
	while( ( isdefined( level.players[0].isSpeaking ) && level.players[0].isSpeaking ) )
		wait(.5);
	
	level.sndVoxOverride = true;
	doLine( level.players[0], "fieldreport_round2_0" );
	if( isdefined( getSpecificCharacter(2) ) )
	{
		doLine( level.players[0], "fieldreport_round2_1" );
	}
	level.sndVoxOverride = false;
}
function doLine( guy, alias )
{
	if( isdefined( guy ) )
	{
		guy playsoundontag( "vox_plr_"+guy.characterIndex+"_"+alias, "J_Head" );
		waitPlaybackTime("vox_plr_"+guy.characterIndex+"_"+alias);
	}
}
function waitPlaybackTime(alias)
{
	playbackTime = soundgetplaybacktime( alias );
			
	if( !isdefined( playbackTime ) )
		playbackTime = 1;
			
	if ( playbackTime >= 0 )
		playbackTime = playbackTime * .001;
	else
		playbackTime = 1;
			
	wait(playbacktime);
}
function getRandomNotRichtofen()
{
	array = level.players;
	array::randomize( array );
	
	foreach( guy in array )
	{
		if( guy.characterIndex != 2 )
			return guy;
	}
	return undefined;
}
function getSpecificCharacter(charIndex)
{
	foreach( guy in level.players )
	{
		if( guy.characterIndex == charIndex )
			return guy;
	}
	return undefined;
}
function isAnyoneTalking()
{
	foreach( player in level.players )
	{
		if( ( isdefined( player.isSpeaking ) && player.isSpeaking ) )
		{
			return true;
		}
	}
	
	return false;
}
function sndRadioSetup()
{
	level thread zm_audio::sndRadioSetup("vox_maxis_maxis_radio", undefined, (-329,-319,4), (691,-204,151), (-77,-2214,110), (-1257,-1211,258), (-450,-536,128));
	level thread zm_factory::sndSpecialRadioSetup("vox_maxis_player_radio", (1402,925,104), (-828,-1442,237), (564,-2819,155) );
}
function sndSpecialRadioSetup( alias_prefix, origin1, origin2, origin3 )
{
	radio = spawnstruct();
	radio.counter = 1;
	radio.alias_prefix = alias_prefix;
	radio.isPlaying = false;
	radio.array = array();
	
	if ( !isdefined( radio.array ) ) radio.array = []; else if ( !IsArray( radio.array ) ) radio.array = array( radio.array ); radio.array[radio.array.size]=origin1;;
	if ( !isdefined( radio.array ) ) radio.array = []; else if ( !IsArray( radio.array ) ) radio.array = array( radio.array ); radio.array[radio.array.size]=origin2;;
	if ( !isdefined( radio.array ) ) radio.array = []; else if ( !IsArray( radio.array ) ) radio.array = array( radio.array ); radio.array[radio.array.size]=origin3;;
	
	if( radio.array.size > 0 )
	{
		for(i=0;i<radio.array.size;i++)
		{
			level thread sndRadioWait(radio.array[i], radio, i+1);
		}
	}
}
function sndRadioWait(origin, radio, num)
{	
	temp_ent = Spawn( "script_origin", origin );
	temp_ent thread zm_audio::secretUse( "sndRadioHit", (255,0,0), &zm_audio::sndRadio_Override, radio );
	temp_ent waittill( "sndRadioHit", player);
	
	if( isdefined( level.sndRadioA ) && level.sndRadioA == player )
		letter = "a";
	else
		letter = "b";
	
	radioNum = num;
	
	radioAlias = radio.alias_prefix + radioNum + letter;	
	radioLineCount = zm_spawner::get_number_variants( radioAlias );
	
	if( radioLineCount > 0 )
	{
		radio.isPlaying = true;
	
		for(i=0;i<radioLineCount;i++)
		{
			temp_ent playsound( radioAlias + "_" + i );
			playbackTime = soundgetplaybacktime( radioAlias + "_" + i );
			
			if( !isdefined( playbackTime ) )
				playbackTime = 1;
			
			if ( playbackTime >= 0 )
				playbackTime = playbackTime * .001;
			else
				playbackTime = 1;
			
			wait(playbacktime);
		}
	}
	
	radio.counter++;
	radio.isPlaying = false;
	
	temp_ent Delete();
}






function setupMusic()
{
	//Special Round
	zm_audio::sndMusicSystem_CreateState( "dog_start", "mus_zombie_round_dog_start", 3 );
	zm_audio::sndMusicSystem_CreateState( "dog_end", "mus_zombie_round_dog_over", 3 );
	
//	//Location Stingers
//	zm_audio::sndMusicSystem_CreateState( "tp_east_zone", "mus_location_tp_1", PLAYTYPE_QUEUE );
//	zm_audio::sndMusicSystem_CreateState( "tp_south_zone", "mus_location_tp_3", PLAYTYPE_QUEUE );
//	zm_audio::sndMusicSystem_CreateState( "tp_west_zone", "mus_location_tp_2", PLAYTYPE_QUEUE );
//	zm_audio::sndMusicSystem_CreateState( "warehouse_bottom_zone", "mus_location_warehouse", PLAYTYPE_QUEUE );
	zm_audio::sndMusicSystem_CreateState( "wnuen_zone", "mus_hallway", 2 );
//	zm_audio::sndMusicSystem_CreateState( "outside_south_zone", "mus_location_powerup", PLAYTYPE_QUEUE );
	locationArray = array("tp_east_zone","tp_south_zone","tp_west_zone","warehouse_bottom_zone","wnuen_zone","outside_south_zone");
	zm_audio::sndMusicSystem_LocationsInit(locationArray);
	
	
	//Event Stingers
	//zm_audio::sndMusicSystem_CreateState( "first_door", "mus_location_firstdoor", PLAYTYPE_QUEUE );
	zm_audio::sndMusicSystem_CreateState( "timer", "mus_teleporter_timer", 4 );
	//zm_audio::sndMusicSystem_CreateState( "teleporter_1", "mus_activate_tp_1", PLAYTYPE_QUEUE );
	//zm_audio::sndMusicSystem_CreateState( "teleporter_2", "mus_activate_tp_2", PLAYTYPE_QUEUE );
	//zm_audio::sndMusicSystem_CreateState( "teleporter_3", "mus_activate_tp_all", PLAYTYPE_QUEUE );
	zm_audio::sndMusicSystem_CreateState( "power_on", "mus_activate_power", 2 );
	
	//Easter Egg Song
	zm_audio::sndMusicSystem_CreateState( "musicEasterEgg", "mus_zmb_secret_song", 4 );
	zm_audio::sndMusicSystem_EESetup( "musicEasterEgg", (900,-586,151), (987,-873,122), (-1340,-483,255) );
}
function sndFirstDoor()
{
	level waittill( "sndDoorOpening" );
	level thread zm_audio::sndMusicSystem_PlayState( "first_door" );
}
function sndPASetup()
{
	level.paTalking = false;
	level.paArray = array();
	
	array = struct::get_array( "pa_system", "targetname" );
	foreach( pa in array )
	{
		ent = spawn( "script_origin", pa.origin );
		if ( !isdefined( level.paArray ) ) level.paArray = []; else if ( !IsArray( level.paArray ) ) level.paArray = array( level.paArray ); level.paArray[level.paArray.size]=ent;;
	}
}
function sndPA_DoVox( alias, delay, nowait = false )
{
	if( isdefined( delay ) )
		wait(delay);
	
	if( !( isdefined( level.paTalking ) && level.paTalking ) )
	{
		level.paTalking = true;
		
		level thread sndPA_playvox(alias);
		
		playbacktime = soundgetplaybacktime( alias );
		if( !isdefined( playbacktime ) || playbacktime <= 2 )
			waittime = 1;
		else
			waittime = playbackTime * .001;
	
		if( !nowait )
		{
			wait(waittime-.9);
		}
		
		level.paTalking = false;
	}
}
function sndPA_playvox( alias )
{
	array::randomize(level.paArray);
	
	foreach( pa in level.paArray )
	{
		pa playsound( alias );
		wait(.05);
	}
}
function sndPA_Traps(trap,stage)
{
	if( isdefined( trap ) )
	{
		if( stage == 1 )
		{
			switch( trap.target )
			{
				case "trap_b":
					level thread zm_factory::sndPA_DoVox( "vox_maxis_trap_warehouse_inuse_0", 2 );
					break;
				case "trap_a":
					level thread zm_factory::sndPA_DoVox( "vox_maxis_trap_lab_inuse_0", 2 );
					break;
				case "trap_c":
					level thread zm_factory::sndPA_DoVox( "vox_maxis_trap_bridge_inuse_0", 2 );
					break;
			}
		}
		else
		{
			switch( trap.target )
			{
				case "trap_b":
					level thread zm_factory::sndPA_DoVox( "vox_maxis_trap_warehouse_active_0", 4 );
					break;
				case "trap_a":
					level thread zm_factory::sndPA_DoVox( "vox_maxis_trap_lab_active_0", 4 );
					break;
				case "trap_c":
					level thread zm_factory::sndPA_DoVox( "vox_maxis_trap_bridge_active_0", 4 );
					break;
			}
		}
	}
}