#using scripts\codescripts\struct;
#using scripts\shared\animation_shared;
#using scripts\shared\array_shared;
#using scripts\shared\callbacks_shared;
#using scripts\shared\clientfield_shared;
#using scripts\shared\filter_shared;
#using scripts\shared\postfx_shared;
#using scripts\shared\util_shared;

    	   	                                                                                                                         	                                                                                                                                                                                                                                                                                                                                                                    	        	     	             	    	   	                           	                               	                                	                                                              	                                                                                                              	                            	                                     	                                       	                                                               	   	                  	       	                                                    	                   	                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                       	                                                                                        	           	                        	                                            	                                             	                                                   	                                                             	                                                         	                                                                    	                                                                                                                                                                                                    	                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                     	                                                              	                                                          	                                   	                                   	                                                    	                                       
                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                            	                                                                                                                                                                                                                                                                                                                                                                                       

#using scripts\zm\zm_zod_amb;
#using scripts\zm\zm_zod_craftables;
#using scripts\zm\zm_zod_idgun_quest;
#using scripts\zm\zm_zod_util;

                                                                                                                                                                                                                                                                                                                                                                                                                 	                                                                                                                                                                          	                                                                                         	                                                                                                                                                                                                                                                                                                                                                                                                                                        	                                                                                                                               	                                                                                                                                                                                                                                              	                                                                                                                                           	                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                   	                                                                                                                       	   	                                                                                                                                                                                                                                                                                                                         	                                                                                                                                                                                                                                      
                                                                                                                                                                                                                                                                                                    	                                                                                     	                                                                                                                                                                                                                                                                                             	                                                                                                                                                                                                                                                                                                                                                                                                   	                                                                                                                                                                                                                                                                                                         	                                                   

#using scripts\shared\vehicles\_glaive;
#using scripts\zm\_load;
#using scripts\zm\_zm;
#using scripts\zm\_zm_magicbox_zod;
#using scripts\zm\_zm_utility;
#using scripts\zm\_zm_weap_bouncingbetty;
#using scripts\zm\_zm_weap_cymbal_monkey;
#using scripts\zm\_zm_weap_octobomb;
#using scripts\zm\_zm_weap_tesla;
#using scripts\zm\_zm_weap_glaive;
// #using scripts\zm\_zm_weap_id_gun;
#using scripts\zm\_zm_weapons;
#using scripts\zm\craftables\_zm_craftables;
#using scripts\zm\archetype_zod_companion;

//Perks
#using scripts\zm\_zm_perk_doubletap2;
#using scripts\zm\_zm_perk_juggernaut;
#using scripts\zm\_zm_perk_quick_revive;
#using scripts\zm\_zm_perk_sleight_of_hand;
#using scripts\zm\_zm_perk_staminup;
#using scripts\zm\_zm_perk_widows_wine;

//Powerups
#using scripts\zm\_zm_powerup_bonus_points_team;
#using scripts\zm\_zm_powerup_carpenter;
#using scripts\zm\_zm_powerup_double_points;
#using scripts\zm\_zm_powerup_fire_sale;
#using scripts\zm\_zm_powerup_full_ammo;
#using scripts\zm\_zm_powerup_insta_kill;
#using scripts\zm\_zm_powerup_nuke;

//Optional features
#using scripts\zm\zm_zod_fx;
#using scripts\zm\zm_zod_octobomb_quest;
#using scripts\zm\zm_zod_pods;
#using scripts\zm\zm_zod_portals;
#using scripts\zm\zm_zod_quest;
#using scripts\zm\zm_zod_sword_quest;
#using scripts\zm\zm_zod_traps;
#using scripts\zm\_zm_altbody_beast;
#using scripts\zm\craftables\_zm_craft_shield;

//AI
#using scripts\zm\_zm_ai_raps;
#using scripts\zm\_zm_ai_wasp;

#precache( "client_fx", "zombie/fx_glow_eye_orange" );
#precache( "client_fx", "zombie/fx_bul_flesh_head_fatal_zmb" );
#precache( "client_fx", "zombie/fx_bul_flesh_head_nochunks_zmb" );
#precache( "client_fx", "zombie/fx_bul_flesh_neck_spurt_zmb" );
#precache( "client_fx", "zombie/fx_blood_torso_explo_zmb" );
#precache( "client_fx", "trail/fx_trail_blood_streak" );
#precache( "client_fx", "weather/fx_rain_system_hvy_runner" );

#using_animtree( "generic" );




function autoexec opt_in()
{
	level.aat_in_use = true;
	level.bgb_in_use = true;
}

function init_gamemodes()
{
	zm::add_map_gamemode("zclassic",	undefined,	undefined);		
	zm::add_map_location_gamemode("zclassic",	"default", 	&util::empty,	undefined, &util::empty);
}

function main()
{
	level.zod_character_names = [];
	array::add( level.zod_character_names, "boxer" );
	array::add( level.zod_character_names, "detective" );
	array::add( level.zod_character_names, "femme" );
	array::add( level.zod_character_names, "magician" );

	register_clientfields();

	// custom client side exert sounds for the special characters
	level.setupCustomCharacterExerts =&setup_personality_character_exerts;

	// TODO T7 - Update the cymbal monkey to the latest version.
	level.legacy_cymbal_monkey = true;

	zm_zod_fx::main();

	level._effect["eye_glow"]				= "zombie/fx_glow_eye_orange";
	level._effect["headshot"]				= "zombie/fx_bul_flesh_head_fatal_zmb";
	level._effect["headshot_nochunks"]		= "zombie/fx_bul_flesh_head_nochunks_zmb";
	level._effect["bloodspurt"]				= "zombie/fx_bul_flesh_neck_spurt_zmb";

	level._effect["animscript_gib_fx"]		= "zombie/fx_blood_torso_explo_zmb"; 
	level._effect["animscript_gibtrail_fx"]	= "trail/fx_trail_blood_streak"; 	

	level._effect[ "rain_heavy" ]			= "weather/fx_rain_system_hvy_runner";
	
	level._uses_default_wallbuy_fx = 1;
	level._uses_sticky_grenades = 1;
	level._uses_taser_knuckles = 1;		

	include_weapons();
	// custom magicbox init
	zm_magicbox_zod::init();

	zm_zod_craftables::include_craftables();
	zm_zod_craftables::init_craftables();

	load::main();
	
	_zm_weap_cymbal_monkey::init();
	_zm_weap_octobomb::init();
	_zm_weap_tesla::init();
//	_zm_weap_id_gun::init();

	init_gamemodes();


	//thread _audio::audio_init(0);
	thread zm_zod_amb::main();

	callback::on_spawned( &on_player_spawned );
	callback::on_localclient_connect( &on_player_connect );

	util::waitforclient( 0 );
}


function register_clientfields()
{
	// rain
	clientfield::register( "toplayer",	"fullscreen_rain_fx",	1,	1,		"int", &toggle_rain_overlay,	!true, !true );
	
	// show or hide the red weeds in the world after the world-transformation (end of the Pack-a-Punch quest)
	clientfield::register( "world",		"show_hide_pap_weed",	1,	1,		"int", &show_hide_pap_weed,		!true, true );

	// trigger the crane in the junction to animate
	clientfield::register( "world", 	"junction_crane_state"	, 1, 1,		"int", &junction_crane_state,	!true, true );
	
	// apothicon god animation and show/hide states
	n_bits = GetMinBitCountForNum( 4 );
	clientfield::register( "world", 	"god_state"				, 1, n_bits, "int", &god_state,				!true, true );

	// player rumble and camera shake controller	
	n_bits = GetMinBitCountForNum( 6 );
	clientfield::register( "toplayer", "player_rumble_and_shake", 1, n_bits, "int", &zm_zod_util::player_rumble_and_shake, !true, !true );
}


function on_player_spawned( localClientNum )
{
	filter::init_filter_raindrops( self );
}

function on_player_connect( localClientNum )
{
	self thread player_rain_thread( localClientNum );
}

function toggle_rain_overlay( localClientNum, oldVal, newVal, bNewEnt, bInitialSnap, fieldName, bWasDemoJump )
{
	if( bNewEnt )
	{
		filter::init_filter_raindrops( self );
	}

	if ( newVal )
    {
		/#
        PrintLn( "**** rain overlay on ****" );
		#/
			
		filter::enable_filter_raindrops( self, 2 );
	}
    else
    {
    	/#
    	PrintLn( "**** rain overlay off ****" );
    	#/
    		
    	filter::disable_filter_raindrops( self, 2 );
    }
}

function player_rain_thread( localClientNum )
{
	self endon( "disconnect" );
	self endon( "entityshutdown" );

	if ( !self IsLocalPlayer() || !IsDefined( self GetLocalClientNumber() ) || localClientNum != self GetLocalClientNumber() )
	{
		return;
	}

	while ( true )
	{
		if ( !isdefined( self ) )
		{
			return;
		}
		
		fxId = PlayFX( localClientNum, level._effect[ "rain_heavy" ], self.origin );
		SetFXOutdoor( localClientNum, fxId );
		wait( .25 );
	}
}

// TODO: trigger the junction crane fxanim here (have script move for now)
function junction_crane_state( localClientNum, oldVal, newVal, bNewEnt, bInitialSnap, fieldName, bWasDemoJump )
{
	e_crane = GetEnt( localClientNum, "quest_personal_item_junction_crane", "targetname" );
	e_crate = GetEnt( localClientNum, "junction_crane_crate", "targetname" );
	e_phrase = GetEnt( localClientNum, "junction_crane_crate_phrase", "targetname" );
	e_crate LinkTo( e_crane );
	e_phrase LinkTo( e_crate );

	e_crane util::waittill_dobj( localClientNum );
	e_phrase util::waittill_dobj( localClientNum );

	if( newVal == 1 )
	{
		// rotate the crane
		e_crane RotateYaw( 60, 3 );
		wait 3;
		
		// after rotating, ghost the crate, then pop the personal item into place (this will be the end of an fxanim of the crane animating & swinging, then dropping the crate so it shatters )
		e_crate Delete();
		e_phrase Delete();
	
		// rotate the crane back
		e_crane RotateYaw( -60, 3 );
		wait 3;
	}
	else
	{
		// play light fx on moving crane
		PlayFXOnTag( localClientNum, level._effect[ "crane_light" ], e_crane, "j_light" );
		// play Keeper magical glow on the special crate hanging from the crane in the Junction
		PlayFXOnTag( localClientNum, level._effect[ "cultist_crate_personal_item" ], e_phrase, "tag_origin" );
	}
}





function include_weapons()
{
	zm_weapons::load_weapon_spec_from_table("gamedata/weapons/zm/zm_zod_weapons.csv", 1);
	zm_weapons::autofill_wallbuys_init();
}

function setup_personality_character_exerts()
{
	// sniper hold breath
	level.exert_sounds[1]["playerbreathinsound"][0] = "vox_plr_0_exert_inhale_0";
	level.exert_sounds[1]["playerbreathinsound"][1] = "vox_plr_0_exert_inhale_1";
	level.exert_sounds[1]["playerbreathinsound"][2] = "vox_plr_0_exert_inhale_2";
	
	level.exert_sounds[2]["playerbreathinsound"][0] = "vox_plr_1_exert_inhale_0";
	level.exert_sounds[2]["playerbreathinsound"][1] = "vox_plr_1_exert_inhale_1";
	level.exert_sounds[2]["playerbreathinsound"][2] = "vox_plr_1_exert_inhale_2";
	
	level.exert_sounds[3]["playerbreathinsound"][0] = "vox_plr_2_exert_inhale_0";
	level.exert_sounds[3]["playerbreathinsound"][1] = "vox_plr_2_exert_inhale_1";
	level.exert_sounds[3]["playerbreathinsound"][2] = "vox_plr_2_exert_inhale_2";
	
	level.exert_sounds[4]["playerbreathinsound"][0] = "vox_plr_3_exert_inhale_0";
	level.exert_sounds[4]["playerbreathinsound"][1] = "vox_plr_3_exert_inhale_1";
	level.exert_sounds[4]["playerbreathinsound"][2] = "vox_plr_3_exert_inhale_2";

	// sniper exhale
	level.exert_sounds[1]["playerbreathoutsound"][0] = "vox_plr_0_exert_exhale_0";
	level.exert_sounds[1]["playerbreathoutsound"][1] = "vox_plr_0_exert_exhale_1";
	level.exert_sounds[1]["playerbreathoutsound"][2] = "vox_plr_0_exert_exhale_2";
	
	level.exert_sounds[2]["playerbreathoutsound"][0] = "vox_plr_1_exert_exhale_0";
	level.exert_sounds[2]["playerbreathoutsound"][1] = "vox_plr_1_exert_exhale_1";
	level.exert_sounds[2]["playerbreathoutsound"][2] = "vox_plr_1_exert_exhale_2";
	
	level.exert_sounds[3]["playerbreathoutsound"][0] = "vox_plr_2_exert_exhale_0";
	level.exert_sounds[3]["playerbreathoutsound"][1] = "vox_plr_2_exert_exhale_1";
	level.exert_sounds[3]["playerbreathoutsound"][2] = "vox_plr_2_exert_exhale_2";
	
	level.exert_sounds[4]["playerbreathoutsound"][0] = "vox_plr_3_exert_exhale_0";
	level.exert_sounds[4]["playerbreathoutsound"][1] = "vox_plr_3_exert_exhale_1";
	level.exert_sounds[4]["playerbreathoutsound"][2] = "vox_plr_3_exert_exhale_2";
	
	// sniper hold breath
	level.exert_sounds[1]["playerbreathgaspsound"][0] = "vox_plr_0_exert_exhale_0";
	level.exert_sounds[1]["playerbreathgaspsound"][1] = "vox_plr_0_exert_exhale_1";
	level.exert_sounds[1]["playerbreathgaspsound"][2] = "vox_plr_0_exert_exhale_2";
	
	level.exert_sounds[2]["playerbreathgaspsound"][0] = "vox_plr_1_exert_exhale_0";
	level.exert_sounds[2]["playerbreathgaspsound"][1] = "vox_plr_1_exert_exhale_1";
	level.exert_sounds[2]["playerbreathgaspsound"][2] = "vox_plr_1_exert_exhale_2";
	
	level.exert_sounds[3]["playerbreathgaspsound"][0] = "vox_plr_2_exert_exhale_0";
	level.exert_sounds[3]["playerbreathgaspsound"][1] = "vox_plr_2_exert_exhale_1";
	level.exert_sounds[3]["playerbreathgaspsound"][2] = "vox_plr_2_exert_exhale_2";
	
	level.exert_sounds[4]["playerbreathgaspsound"][0] = "vox_plr_3_exert_exhale_0";
	level.exert_sounds[4]["playerbreathgaspsound"][1] = "vox_plr_3_exert_exhale_1";
	level.exert_sounds[4]["playerbreathgaspsound"][2] = "vox_plr_3_exert_exhale_2";

	// falling damage
	level.exert_sounds[1]["falldamage"][0] = "vox_plr_0_exert_pain_low_0";
	level.exert_sounds[1]["falldamage"][1] = "vox_plr_0_exert_pain_low_1";
	level.exert_sounds[1]["falldamage"][2] = "vox_plr_0_exert_pain_low_2";
	level.exert_sounds[1]["falldamage"][3] = "vox_plr_0_exert_pain_low_3";
	level.exert_sounds[1]["falldamage"][4] = "vox_plr_0_exert_pain_low_4";
	level.exert_sounds[1]["falldamage"][5] = "vox_plr_0_exert_pain_low_5";
	level.exert_sounds[1]["falldamage"][6] = "vox_plr_0_exert_pain_low_6";
	level.exert_sounds[1]["falldamage"][7] = "vox_plr_0_exert_pain_low_7";
	
	level.exert_sounds[2]["falldamage"][0] = "vox_plr_1_exert_pain_low_0";
	level.exert_sounds[2]["falldamage"][1] = "vox_plr_1_exert_pain_low_1";
	level.exert_sounds[2]["falldamage"][2] = "vox_plr_1_exert_pain_low_2";
	level.exert_sounds[2]["falldamage"][3] = "vox_plr_1_exert_pain_low_3";
	level.exert_sounds[2]["falldamage"][4] = "vox_plr_1_exert_pain_low_4";
	level.exert_sounds[2]["falldamage"][5] = "vox_plr_1_exert_pain_low_5";
	level.exert_sounds[2]["falldamage"][6] = "vox_plr_1_exert_pain_low_6";
	level.exert_sounds[2]["falldamage"][7] = "vox_plr_1_exert_pain_low_7";
	
	level.exert_sounds[3]["falldamage"][0] = "vox_plr_2_exert_pain_low_0";
	level.exert_sounds[3]["falldamage"][1] = "vox_plr_2_exert_pain_low_1";
	level.exert_sounds[3]["falldamage"][2] = "vox_plr_2_exert_pain_low_2";
	level.exert_sounds[3]["falldamage"][3] = "vox_plr_2_exert_pain_low_3";
	level.exert_sounds[3]["falldamage"][4] = "vox_plr_2_exert_pain_low_4";
	level.exert_sounds[3]["falldamage"][5] = "vox_plr_2_exert_pain_low_5";
	level.exert_sounds[3]["falldamage"][6] = "vox_plr_2_exert_pain_low_6";
	level.exert_sounds[3]["falldamage"][7] = "vox_plr_2_exert_pain_low_7";
	
	level.exert_sounds[4]["falldamage"][0] = "vox_plr_3_exert_pain_low_0";
	level.exert_sounds[4]["falldamage"][1] = "vox_plr_3_exert_pain_low_1";
	level.exert_sounds[4]["falldamage"][2] = "vox_plr_3_exert_pain_low_2";
	level.exert_sounds[4]["falldamage"][3] = "vox_plr_3_exert_pain_low_3";
	level.exert_sounds[4]["falldamage"][4] = "vox_plr_3_exert_pain_low_4";
	level.exert_sounds[4]["falldamage"][5] = "vox_plr_3_exert_pain_low_5";
	level.exert_sounds[4]["falldamage"][6] = "vox_plr_3_exert_pain_low_6";
	level.exert_sounds[4]["falldamage"][7] = "vox_plr_3_exert_pain_low_7";
	
	// mantle launch
	level.exert_sounds[1]["mantlesoundplayer"][0] = "vox_plr_0_exert_grunt_0";
	level.exert_sounds[1]["mantlesoundplayer"][1] = "vox_plr_0_exert_grunt_1";
	level.exert_sounds[1]["mantlesoundplayer"][2] = "vox_plr_0_exert_grunt_2";
	level.exert_sounds[1]["mantlesoundplayer"][3] = "vox_plr_0_exert_grunt_3";
	level.exert_sounds[1]["mantlesoundplayer"][4] = "vox_plr_0_exert_grunt_4";
	level.exert_sounds[1]["mantlesoundplayer"][5] = "vox_plr_0_exert_grunt_5";
	level.exert_sounds[1]["mantlesoundplayer"][6] = "vox_plr_0_exert_grunt_6";
	
	level.exert_sounds[2]["mantlesoundplayer"][0] = "vox_plr_1_exert_grunt_0";
	level.exert_sounds[2]["mantlesoundplayer"][1] = "vox_plr_1_exert_grunt_1";
	level.exert_sounds[2]["mantlesoundplayer"][2] = "vox_plr_1_exert_grunt_2";
	level.exert_sounds[2]["mantlesoundplayer"][3] = "vox_plr_1_exert_grunt_3";
	level.exert_sounds[2]["mantlesoundplayer"][4] = "vox_plr_1_exert_grunt_4";
	level.exert_sounds[2]["mantlesoundplayer"][5] = "vox_plr_1_exert_grunt_5";
	level.exert_sounds[2]["mantlesoundplayer"][6] = "vox_plr_1_exert_grunt_6";
	
	level.exert_sounds[3]["mantlesoundplayer"][0] = "vox_plr_2_exert_grunt_0";
	level.exert_sounds[3]["mantlesoundplayer"][1] = "vox_plr_2_exert_grunt_1";
	level.exert_sounds[3]["mantlesoundplayer"][2] = "vox_plr_2_exert_grunt_2";
	level.exert_sounds[3]["mantlesoundplayer"][3] = "vox_plr_2_exert_grunt_3";
	level.exert_sounds[3]["mantlesoundplayer"][4] = "vox_plr_2_exert_grunt_4";
	level.exert_sounds[3]["mantlesoundplayer"][5] = "vox_plr_2_exert_grunt_5";
	level.exert_sounds[3]["mantlesoundplayer"][6] = "vox_plr_2_exert_grunt_6";
	
	level.exert_sounds[4]["mantlesoundplayer"][0] = "vox_plr_3_exert_grunt_0";
	level.exert_sounds[4]["mantlesoundplayer"][1] = "vox_plr_3_exert_grunt_1";
	level.exert_sounds[4]["mantlesoundplayer"][2] = "vox_plr_3_exert_grunt_2";
	level.exert_sounds[4]["mantlesoundplayer"][3] = "vox_plr_3_exert_grunt_3";
	level.exert_sounds[4]["mantlesoundplayer"][4] = "vox_plr_3_exert_grunt_4";
	level.exert_sounds[4]["mantlesoundplayer"][5] = "vox_plr_3_exert_grunt_5";
	level.exert_sounds[4]["mantlesoundplayer"][6] = "vox_plr_3_exert_grunt_6";
	
	// melee swipe
	level.exert_sounds[1]["meleeswipesoundplayer"][0] = "vox_plr_0_exert_knife_swipe_0";
	level.exert_sounds[1]["meleeswipesoundplayer"][1] = "vox_plr_0_exert_knife_swipe_1";
	level.exert_sounds[1]["meleeswipesoundplayer"][2] = "vox_plr_0_exert_knife_swipe_2";
	level.exert_sounds[1]["meleeswipesoundplayer"][3] = "vox_plr_0_exert_knife_swipe_3";
	level.exert_sounds[1]["meleeswipesoundplayer"][4] = "vox_plr_0_exert_knife_swipe_4";
	level.exert_sounds[1]["meleeswipesoundplayer"][5] = "vox_plr_0_exert_knife_swipe_5";
	
	level.exert_sounds[2]["meleeswipesoundplayer"][0] = "vox_plr_1_exert_knife_swipe_0";
	level.exert_sounds[2]["meleeswipesoundplayer"][1] = "vox_plr_1_exert_knife_swipe_1";
	level.exert_sounds[2]["meleeswipesoundplayer"][2] = "vox_plr_1_exert_knife_swipe_2";
	level.exert_sounds[2]["meleeswipesoundplayer"][3] = "vox_plr_1_exert_knife_swipe_3";
	level.exert_sounds[2]["meleeswipesoundplayer"][4] = "vox_plr_1_exert_knife_swipe_4";
	level.exert_sounds[2]["meleeswipesoundplayer"][5] = "vox_plr_1_exert_knife_swipe_5";
	
	level.exert_sounds[3]["meleeswipesoundplayer"][0] = "vox_plr_2_exert_knife_swipe_0";
	level.exert_sounds[3]["meleeswipesoundplayer"][1] = "vox_plr_2_exert_knife_swipe_1";
	level.exert_sounds[3]["meleeswipesoundplayer"][2] = "vox_plr_2_exert_knife_swipe_2";
	level.exert_sounds[3]["meleeswipesoundplayer"][3] = "vox_plr_2_exert_knife_swipe_3";
	level.exert_sounds[3]["meleeswipesoundplayer"][4] = "vox_plr_2_exert_knife_swipe_4";
	level.exert_sounds[3]["meleeswipesoundplayer"][5] = "vox_plr_2_exert_knife_swipe_5";	
	
	level.exert_sounds[4]["meleeswipesoundplayer"][0] = "vox_plr_3_exert_knife_swipe_0";
	level.exert_sounds[4]["meleeswipesoundplayer"][1] = "vox_plr_3_exert_knife_swipe_1";
	level.exert_sounds[4]["meleeswipesoundplayer"][2] = "vox_plr_3_exert_knife_swipe_2";
	level.exert_sounds[4]["meleeswipesoundplayer"][3] = "vox_plr_3_exert_knife_swipe_3";
	level.exert_sounds[4]["meleeswipesoundplayer"][4] = "vox_plr_3_exert_knife_swipe_4";
	level.exert_sounds[4]["meleeswipesoundplayer"][5] = "vox_plr_3_exert_knife_swipe_5";
	
	// DTP land ** this may need to be expanded to take surface type into account
	level.exert_sounds[1]["dtplandsoundplayer"][0] = "vox_plr_0_exert_pain_medium_0";
	level.exert_sounds[1]["dtplandsoundplayer"][1] = "vox_plr_0_exert_pain_medium_1";
	level.exert_sounds[1]["dtplandsoundplayer"][2] = "vox_plr_0_exert_pain_medium_2";
	level.exert_sounds[1]["dtplandsoundplayer"][3] = "vox_plr_0_exert_pain_medium_3";
	
	level.exert_sounds[2]["dtplandsoundplayer"][0] = "vox_plr_1_exert_pain_medium_0";
	level.exert_sounds[2]["dtplandsoundplayer"][1] = "vox_plr_1_exert_pain_medium_1";
	level.exert_sounds[2]["dtplandsoundplayer"][2] = "vox_plr_1_exert_pain_medium_2";
	level.exert_sounds[2]["dtplandsoundplayer"][3] = "vox_plr_1_exert_pain_medium_3";
	
	level.exert_sounds[3]["dtplandsoundplayer"][0] = "vox_plr_2_exert_pain_medium_0";
	level.exert_sounds[3]["dtplandsoundplayer"][1] = "vox_plr_2_exert_pain_medium_1";
	level.exert_sounds[3]["dtplandsoundplayer"][2] = "vox_plr_2_exert_pain_medium_2";
	level.exert_sounds[3]["dtplandsoundplayer"][3] = "vox_plr_2_exert_pain_medium_3";
	
	level.exert_sounds[4]["dtplandsoundplayer"][0] = "vox_plr_3_exert_pain_medium_0";
	level.exert_sounds[4]["dtplandsoundplayer"][1] = "vox_plr_3_exert_pain_medium_1";
	level.exert_sounds[4]["dtplandsoundplayer"][2] = "vox_plr_3_exert_pain_medium_2";
	level.exert_sounds[4]["dtplandsoundplayer"][3] = "vox_plr_3_exert_pain_medium_3";
}


function show_hide_pap_weed( localClientNum, oldVal, newVal, bNewEnt, bInitialSnap, fieldName, bWasDemoJump )
{
	// this grabs all the misc models with targetname = 'station_shells' and hides them
	a_misc_model = FindStaticModelIndexArray( "pap_weed" );
	
	if ( newVal == 1 )
	{		
		const MAX_HIDE_PER_CLIENT_FRAME = 25;
		
		foreach ( i, model in a_misc_model )
		{
			UnhideStaticModel( model );
			
			if ( ( i % MAX_HIDE_PER_CLIENT_FRAME ) == 0 )
			{
				{wait(.016);};
			}
		}
	}
	else 
	{
		
		const MAX_UNHIDE_PER_CLIENT_FRAME = 10;
		
		foreach ( i, model in a_misc_model )
		{
			HideStaticModel( model );
			
			if ( ( i % MAX_UNHIDE_PER_CLIENT_FRAME ) == 0 )
			{
				{wait(.016);};
			}
		}
	}
}

function god_state( localClientNum, oldVal, newVal, bNewEnt, bInitialSnap, fieldName, bWasDemoJump )
{
	level notify( "god_state" );
	level endon( "god_state" );
	
	a_mdl_god = GetEntArray( localClientNum, "god", "targetname" );
	
	foreach( mdl_god in a_mdl_god )
	{
		mdl_god util::waittill_dobj( localClientNum );
		if ( !mdl_god HasAnimTree() )
		{
			mdl_god UseAnimTree( #animtree );
		}
		
		level thread god_animate( mdl_god, newVal );
	}
}

function god_animate( mdl_god, newVal )
{
	switch( newVal )
	{
		case 0:
			mdl_god Hide();
			// clear all possible previous anims
			mdl_god ClearAnim( "p7_fxanim_zm_zod_apothicons_god_start_anim", 0 );
			mdl_god ClearAnim( "p7_fxanim_zm_zod_apothicons_god_loop_anim", 0 );
			mdl_god ClearAnim( "p7_fxanim_zm_zod_apothicons_god_end_anim", 0 );
			break;
		case 1:
			mdl_god Show();
			// clear all other anims
			mdl_god ClearAnim( "p7_fxanim_zm_zod_apothicons_god_loop_anim", 0 );
			mdl_god ClearAnim( "p7_fxanim_zm_zod_apothicons_god_end_anim", 0 );
			// play opening anim
			mdl_god animation::play( "p7_fxanim_zm_zod_apothicons_god_start_anim" );
			break;
		case 2:
			mdl_god Show();
			// clear all other anims
			mdl_god ClearAnim( "p7_fxanim_zm_zod_apothicons_god_start_anim", 0 );
			mdl_god ClearAnim( "p7_fxanim_zm_zod_apothicons_god_end_anim", 0 );
			// play swaying anim
			mdl_god animation::play( "p7_fxanim_zm_zod_apothicons_god_loop_anim", undefined, undefined, 0.1 ); // had to slow down the anim to suit the scale of the model
			break;
		case 3:
			mdl_god Show();
			// clear all other anims
			mdl_god ClearAnim( "p7_fxanim_zm_zod_apothicons_god_start_anim", 0 );
			mdl_god ClearAnim( "p7_fxanim_zm_zod_apothicons_god_loop_anim", 0 );
			// play closing anim
			mdl_god animation::play( "p7_fxanim_zm_zod_apothicons_god_end_anim" );
			break;
	}
}
