#include maps\_utility;
#include common_scripts\utility;
#include maps\_anim;
#include maps\_vehicle;
#include maps\see1_code;
#include maps\see1_anim;
#include maps\_music;

#using_animtree( "generic_human" );

opening_main()
{
	// Number of drone reduction, for coop
	
	if(NumRemoteClients() > 0)	// Are we in coop?
	{
		if(NumRemoteClients() > 1)		// 3 or 4 player coop
		{
			level.max_drones["allies"] = 0;	// Down from 32
			level.max_drones["axis"] = 8; // Down from 32
		}
		else	// 2 player coop
		{
			level.max_drones["allies"] = 0;	// Down from 32
			level.max_drones["axis"] = 11; // Down from 32
		}
	}
	
	
	// Spawn germans who will then retreat and die in the wheat field
	level thread opening_spawn_germans();

	level thread opening_spawn_molotov_tossers();

	level thread opening_spawn_fake_tank();

	//level thread opening_player_speed_change();

	level see1_intro();

	// 1. As player exists the door, he sees heros meleeing germans
	//    Several Germans are defending the front of the house

	level thread opening_objectives();


	// The heroes will be animated initially, so turn off colors for now
	//level.hero1 disable_ai_color();
	//level.hero2 disable_ai_color();


	// wait for player to kick the event off
	//trigger = getent( "opening_vig_start", "targetname" );
	//trigger waittill( "trigger" );

	// plane flyby, followed with distant flashes
	level thread opening_plane_flash();


	// hero 1 and 2 are both meleing german soldiers
	level thread melee_comabt_1_vignette();
	level thread melee_comabt_2_vignette();

	// 2 friendly tanks that move along the road and fire into the field
	level thread opening_spawn_tanks();

	// Failsafe: Move friendlies if the player does not move quickly enough to trigger colors chain
	level thread force_move_friends();

	level thread dialog_player_into_wheat_field();

	level thread opening_molotov_instructions();

	level notify( "player_exits_house" );
	
	// prepare the enemies that run out from the other side
	
	// These guys run, and die while running
	initialize_spawn_function( "opening_running_germans", "script_noteworthy", ::spawn_func_running_and_dying );
	initialize_spawn_function( "opening_running_germans_close", "script_noteworthy", ::spawn_func_running_and_dying );
	// These guys manage to make it to the end, and deletes there
	initialize_spawn_function( "opening_running_germans_2", "script_noteworthy", ::spawn_func_running_and_dying_to_end );
	
	// vignette to have 2 enemies on fire come out of the field
	level thread spawn_flaming_guys();
	level thread spawn_flaming_guys_side();

	// Play additional fire fx when molotoves are tosses into the field
	level thread additional_fires();

	// Failsafe: If the player sticks around, spawn more tanks down the road
	level thread opening_spawn_more_tanks();

	level thread lower_accuracy_for_event_2();

	// Event ends in the downhill path
	end_trigger = getent( "event_1_ends", "targetname" );
	end_trigger waittill( "trigger" );
	level notify( "event_1_ends" );

	level thread opening_cleanup();
}

opening_name_hide()
{
	wait( 37 );
	level.hero1.name = undefined;
	level.hero1.script_friendname = undefined;
	wait( 15 );
	level.hero1.name = "Sgt. Reznov";
	level.hero1.script_friendname = "Sgt. Reznov";
}

opening_player_speed_change()
{
	players_speed_set( 0.3, 1 );
	level waittill( "player_exits_house" );
	wait( 2 );
	players_speed_set( 1.0, 6 );
}

#using_animtree( "generic_human" );
see1_intro()
{
	if( is_german_build() )
	{
		exploder( 99 );
		wait( 4.5 ); // normal introscreen is 6.5 seconds. Push the event 2 seconds earlier
		//level waittill( "finished final intro screen fadein" ); 
		//share_screen( get_host(), false );
		level notify( "intro_spawns" );
		level notify( "player_exits_house" );

		wait( 4 );
		share_screen( get_host(), false );

		level.hero1 thread intro_german_dialog();

		return;
	}

	battlechatter_off();

	//share_screen( get_host(), true, true );
	level waittill( "finished final intro screen fadein" ); 

	players = get_players();

	//tuey set music state intro
	setmusicstate("INTRO");

	wait( 2 );

	level thread restore_share_screen( "intro_restore_share_screen" );



	level thread waking_up();



	
	//flag_wait( "introscreen_complete" ); 

	level notify("start_chant");

	spawn_trigger = getent( "opening_vig_start", "targetname" );
	spawn_trigger trigger_off();

	all_friends_hold_fire();

//	level.ground_ref_ent = spawn( "script_model", (0,0,0) );
//	players[0] playerSetGroundReferenceEnt( level.ground_ref_ent );
	//players[0] thread waking_up();

	for( i = 0; i < players.size; i++ )
	{
		players[i] SetDoubleVision( 5, 0.05 );
		players[i] SetBlur( 2, 0.05 ); 
	}

	// spawn the AIs:
	spawner_1 = getent( "opening_german_1", "targetname" );
	spawner_2 = getent( "opening_german_2", "targetname" );
	spawner_3 = getent( "opening_german_3", "targetname" );
	spawner_4 = getent( "opening_russian_1", "targetname" );
	spawner_5 = getent( "opening_russian_2", "targetname" );

	german_1 = spawn_guy( spawner_1 );
	german_2 = spawn_guy( spawner_2 );
	german_3 = spawn_guy( spawner_3 );
	//russian_1 = spawn_guy( spawner_4 );
	russian_2 = spawn_guy( spawner_5 );
	reznov = level.hero1;
	chernov = level.hero2;

	level thread opening_name_hide();

	orig = getstruct( "see1_collect_anim", "targetname" );

	level.russian_corpse = spawn( "script_model", german_1.origin );
	level.russian_corpse.angles = german_1.angles;
	level.russian_corpse character\char_rus_r_rifle::main(); 
	
	if( level.wii == false )
	{
		level.russian_corpse detach( level.russian_corpse.gearModel );
	}

	level.russian_corpse.animname = "dead_guy";
	level.russian_corpse UseAnimTree( #animtree );
	//level.russian_corpse hide();
	russian_1 = level.russian_corpse;

	german_1.dropweapon = false;
	german_2.dropweapon = false;
	german_3.dropweapon = false;
	//russian_1.dropweapon = false;
	russian_2.dropweapon = false;

	german_1.grenadeammo = 0;
	german_2.grenadeammo = 0;
	german_3.grenadeammo = 0;
	//russian_1.grenadeammo = 0;
	russian_2.grenadeammo = 0;

	german_1.animname = "german1";
	german_2.animname = "german2";
	german_3.animname = "german3";
	russian_1.animname = "dead_guy";
	russian_2.animname = "dead_guy2";
	reznov.animname = "reznov";
	chernov.animname = "chernov";

	//german_1.allowdeath = true;
	german_2.allowdeath = true;
	german_3.allowdeath = true;
	//german_1.health = 5;
	german_2.health = 5;
	german_3.health = 5;

	german_1.nodeathragdoll = true;
	german_2.nodeathragdoll = true;
	german_3.nodeathragdoll = true;
	//russian_1.nodeathragdoll = true;
	russian_2.nodeathragdoll = true;

	german_1 hold_fire();
	german_2 hold_fire();
	german_3 hold_fire();
	//russian_1 hold_fire();
	russian_2 hold_fire();
	reznov hold_fire();
	chernov hold_fire();

	reznov hide();
	chernov hide();

	if( level.wii )
	{
		german_2 thread wii_show_hide_weapon_1();
		german_3 thread wii_show_hide_weapon_2();
	}

	guys = [];
	guys[0] = german_1;
	guys[1] = german_2;
	guys[2] = german_3;
	guys[3] = russian_1;
	guys[4] = reznov;
	guys[5] = chernov;
	guys[6] = russian_2;

	reznov disable_ai_color();
	chernov disable_ai_color();

	german_1.deathanim = %ch_seelow1_intro_german1_dead;
	//russian_1.deathanim = %ch_seelow1_intro_deadguy_dead;
	russian_2.deathanim = %ch_seelow1_intro_deadguy2_dead;

	// remove gears from the Russians
	//russian_1 Detach( russian_1.gearmodel, "" );
	if( level.wii == false )
	{
		russian_2 Detach( russian_2.gearmodel, "" );
	
		german_1 Detach( german_1.gearmodel, "" );
		german_2 Detach( german_2.gearmodel, "" );
		german_3 Detach( german_3.gearmodel, "" );
	}

	animspot = getent( "intro_anim_node", "targetname" );
	reznov thread intro_wait_anim_done();
	level thread intro_russian_1_death( russian_1 );
	level thread intro_german_1_death( russian_2 );
	level thread intro_german_1_death( german_1 );
	level thread intro_german_2_injured_loop( animspot, german_2 );
	level thread intro_german_3_injured_loop( animspot, german_3 );
	level thread intro_german_injured_kill( german_2, "event_1_ends", "opening_german1_spared" );
	level thread intro_german_injured_kill( german_3, "event_1_ends", "opening_german2_spared" );

	level thread drop_all_weapons( german_1 );
	level thread drop_all_weapons( german_2 );
	level thread drop_all_weapons( german_3 );

	level thread intro_achievement_detection();

	opening_knife = spawn( "script_model", german_3 gettagorigin( "TAG_WEAPON_LEFT" ) );
	opening_knife.angles = german_3 gettagangles( "TAG_WEAPON_LEFT" );
	opening_knife setmodel("static_berlin_ger_knife");
	opening_knife linkto( german_3, "TAG_WEAPON_LEFT" );

	level thread opening_timing();

	animSpot thread anim_single( guys, "intro" );

	lerp_nodes = [];
	lerp_nodes[0] = getnode( "opening_player1_start", "script_noteworthy" );
	lerp_nodes[1] = getnode( "opening_player2_start", "script_noteworthy" );
	lerp_nodes[2] = getnode( "opening_player3_start", "script_noteworthy" );
	lerp_nodes[3] = getnode( "opening_player4_start", "script_noteworthy" );

	for( i = 0; i < players.size; i++ )	
	{
		level thread play_player_anim_intro( i, players[i], animSpot, lerp_nodes[i] );
	}

	russian_1 thread opening_attach_detach_player_weapon( russian_2 );

	wait( 4 );

	for( i = 0; i < players.size; i++ )
	{
		players[i] SetDoubleVision( 0, 2 );
		players[i] SetBlur( 0, 2 );
	}

	//TUEY Set next music state up now so it times out properly
	setmusicstate("FIELDS_OF_FIRE");
	
	level waittill( "intro_hands_end" );

	opening_knife delete();

	if( isdefined( 	level.opening_watch ) )
	{
		level.opening_watch delete();
	}

	spawn_trigger trigger_on(); 
	all_friends_resume_fire();
	
	level thread release_player_later( 1 );




	//level thread test_tanks();
}

wii_show_hide_weapon_1()
{
	my_weapon = self.weapon;
	// this is the guy putting gun on table

	// wait till he puts the gun down, then spawn a new gun and detach
	//for( i = 0; i < 50; i++ )
	//{
	//	iprintlnbold( i );
	//	wait( 1 );
	//}

	wait( 11 );

	temp_gun = spawn( "script_model", self gettagorigin( "tag_weapon_right" ) );
	temp_gun.angles = self gettagangles( "tag_weapon_right" );
	temp_gun setmodel( "weapon_ger_g43_rifle" );

	self Detach( GetWeaponModel( my_weapon ), "tag_weapon_right" );

	level waittill( "kick_face" );

	self Attach( GetWeaponModel( my_weapon ), "tag_weapon_right" );
	temp_gun delete();
}

wii_show_hide_weapon_2()
{
	my_weapon = self.weapon;
	// this is the guy checking the corpse
	self Detach( GetWeaponModel( my_weapon ), "tag_weapon_right" );

	level waittill( "kick_face" );

	self Attach( GetWeaponModel( my_weapon ), "tag_weapon_right" );
}

drop_all_weapons( german )
{
	level waittill( "opening_house_explosion" );
	wait( 0.2 );
	german Detach( GetWeaponModel( german.weapon ), "tag_weapon_right" );
}

#using_animtree( "generic_human" );
opening_russian_corpse()
{
	animspot = getent( "intro_anim_node", "targetname" );
	level.russian_corpse show();
	level.russian_corpse UseAnimTree( #animtree );
	level anim_loop_solo( level.russian_corpse, "intro_death", undefined, "stop_death_loop", animspot );

	level.russian_corpse show();
}


///TEST
test_tanks()
{
	tank = spawnvehicle( "vehicle_rus_tracked_t34", 
						 "tank", 
						 "t34", 
						 ( 2800, -6613, -666 ), 
						 ( 0, 0, 0 ) );	
	
	level.ev2_tank_3_can_mount = true;
	level thread maps\see1_event2::pacing_get_on_tank_3b( tank );
}



opening_fake_german()
{
	spawner = getent( "opening_fake_german", "targetname" );
	spawned = spawner stalingradSpawn( true );
	if( spawn_failed( spawned ) )
	{
		return;
	}

	spawned hold_fire();
	spawned.health = 99999;
	
	trigger = getent( "opening_field_spawners", "script_noteworthy" );
	trigger waittill( "trigger" );

	spawned dodamage( spawned.health + 100, ( 0, 0, 0 ) );
}

waking_up()
{
	overlay = newHudElem();
	overlay.x = 0;
	overlay.y = 0;
	overlay setshader( "black", 640, 480 );
	overlay.alignX = "left";
	overlay.alignY = "top";
	overlay.horzAlign = "fullscreen";
	overlay.vertAlign = "fullscreen";
	overlay.alpha = 0;
	overlay.sort = 1;
		
	//overlay thread fadeOverlay( 0.0001, 1, 2 );

	level.ground_ref_ent = spawn( "script_model", (0,0,0) );

	players = get_players();
	for( i = 0; i < players.size; i++ )
	{
		players[i] playerSetGroundReferenceEnt( level.ground_ref_ent );
	}

	level.ground_ref_ent rotateto( ( -50, 30, 10 ), .2, 0.1, 0.1 ); // 1+80, leans left, 2+80, looks left, 3+80: looks downward

	//overlay thread  fadeOverlay( 4, .3, 1);

	level waittill( "stright_up_player" );

	level.ground_ref_ent rotateto( (0,0,0), 4, 1, 1 );

}

release_player_later( time )
{

	//player_1_link = getent( "intro_lock_player", "targetname" );
	//players[0] setorigin( players[0].origin + (0,0,10) );
}

intro_wait_anim_done()
{
	self waittillmatch( "single anim", "end" );
	level notify( "intro_anim_done" );

	//level.hero1 enable_ai_color();
	//level.hero1 thread opening_react_to_tank_fire();
	//end_node1 = getnode( "ev1_hero1_end_node", "targetname" );
	//level.hero1 setgoalnode( end_node1 );

	//level.hero2 enable_ai_color();
	//level.hero2 thread opening_react_to_tank_fire();
	//end_node2 = getnode( "ev1_hero2_end_node", "targetname" );
	//level.hero2 setgoalnode( end_node2 );

	wait( 1 );
	//level.hero2 say_dialogue( "chernov", "retreating" );
	wait( 0.5 );

	//level.hero1 say_dialogue( "reznov", "not_save" );
	wait( 0.5 );

	level.hero1 say_dialogue( "reznov", "burn_wheat" );
	wait( 0.5 );

	level.hero1 say_dialogue( "reznov", "no_escape" );

	level thread shoot_from_behind_dialog();
	wait( 3 );

	battlechatter_on();
	
	//tuey set music state Fields of Fire
	setmusicstate("FIELDS_OF_FIRE");
}

intro_german_dialog()
{
	wait( 1 );
	//level.hero2 say_dialogue( "chernov", "retreating" );
	wait( 0.5 );

	//level.hero1 say_dialogue( "reznov", "not_save" );
	wait( 0.5 );

	level.hero1 say_dialogue( "reznov", "burn_wheat" );
	wait( 0.5 );

	level.hero1 say_dialogue( "reznov", "no_escape" );

	level thread shoot_from_behind_dialog();
	wait( 3 );

	battlechatter_on();
	
	//tuey set music state Fields of Fire
	setmusicstate("FIELDS_OF_FIRE");
}

intro_russian_1_death( guy )
{
	guy waittillmatch( "single anim", "end" );

	animspot = getent( "intro_anim_node", "targetname" );
	//level.russian_corpse show();
	//level.russian_corpse UseAnimTree( #animtree );
	level thread anim_loop_solo( level.russian_corpse, "intro_death", undefined, "stop_death_loop", animspot );

	// wait till all players are far away, then delete
	while( 1 )
	{
		players = get_players();
		still_too_close = false;

		if( !isdefined( level.russian_corpse ) )
		{
			return;
		}

		for( i = 0; i < players.size; i++ )
		{
			if( distance( players[i].origin, level.russian_corpse.origin ) < 3000 )
			{
				still_too_close = true;
			}
			else if( distance( players[i].origin, level.russian_corpse.origin ) > 10000 )
			{
				level.russian_corpse notify( "stop_death_loop" );
				level.russian_corpse delete();
				return;
			}
		}

		if( still_too_close == false )
		{
			level.russian_corpse notify( "stop_death_loop" );
			level.russian_corpse delete();
			return;
		}
		
		wait( 0.5 );
	}
/*
	level.russian_corpse show();


	level thread opening_russian_corpse();

	wait( 0.05 );

	guy hide();
	guy dodamage( guy.health + 10, ( 0, 0, 0 ) );
	guy delete();
*/
}

intro_german_1_death( guy )
{
	guy waittillmatch( "single anim", "end" );
	guy stopanimscripted();
	//iprintlnbold( "German dies" );
	guy dodamage( guy.health + 10, ( 0, 0, 0 ) );
	guy notify( "death" );
}

intro_german_2_injured_loop( animspot, guy )
{
	level endon( "event_1_ends" );
	guy setcandamage( true );
	guy waittillmatch( "single anim", "end" );
	guy.health = 1;
	guy.nodeathragdoll = true;
	guy.deathanim = %ch_seelow1_intro_german2_dead;
	level thread intro_german_end_anim_at_damage( guy, "opening_german1_killed" );

	while( isalive( guy ) )
	{
		animspot thread anim_single_solo( guy, "intro_loop" );
		guy waittill( "single anim" );
	}
}

intro_german_3_injured_loop( animspot, guy )
{
	level endon( "event_1_ends" );
	guy setcandamage( true );
	guy waittillmatch( "single anim", "end" );
	guy.health = 1;
	guy.nodeathragdoll = true;
	guy.deathanim = %ch_seelow1_intro_german3_dead;
	level thread intro_german_end_anim_at_damage( guy, "opening_german2_killed" );

	while( isalive( guy ) )
	{
		animspot thread anim_single_solo( guy, "intro_loop" );
		guy waittill( "single anim" );
	}
}

intro_german_injured_kill( guy, msg, flag_live )
{	
	level waittill( msg );
	if( isalive( guy ) )
	{
		guy dodamage( 10000, ( 0, 0, 0 ) );
		guy notify( "death" );
		flag_set( flag_live );
	}
}


intro_achievement_detection()
{
	level waittill( "event_1_ends" );
	wait( 1 );

	if( flag( "opening_german1_killed" ) && flag( "opening_german2_killed" ) )
	{
		// Both enemies KILLED
		russian_diary_event( "evil" );
	}
	else if( flag( "opening_german1_spared" ) && flag( "opening_german2_spared" ) )
	{
		// Both enemies SPARED
		russian_diary_event( "good" );
	}
	else
	{
		// 1 enemy killed, 1 spared.		

	}
}

opening_attach_watch( guy )
{
	//iprintlnbold( "attach" );
	level.opening_watch = spawn( "script_model", guy gettagorigin( "TAG_WEAPON_LEFT" ) );
	level.opening_watch.angles = guy gettagangles( "TAG_WEAPON_LEFT" );
	level.opening_watch setmodel( "anim_seelow_pocketwatch" );
	level.opening_watch linkto( guy, "TAG_WEAPON_LEFT" );
}

opening_detach_watch( guy )
{
	level.opening_watch delete();
}

opening_attach_book( guy )
{
	//iprintlnbold( "attach" );
	//level.opening_book = spawn( "script_model", guy gettagorigin( "TAG_WEAPON_LEFT" ) );
	//level.opening_book.angles = guy gettagangles( "TAG_WEAPON_LEFT" );
	//level.opening_book setmodel( "static_berlin_books_diary" );

	level.opening_book.origin = guy gettagorigin( "TAG_WEAPON_LEFT" );
	level.opening_book.angles = guy gettagangles( "TAG_WEAPON_LEFT" );
	level.opening_book linkto( guy, "TAG_WEAPON_LEFT" );
}

opening_detach_book( guy )
{
	level.opening_book delete();
}

opening_player_straight( guy )
{
	level notify( "stright_up_player" );
}

opening_kick_face( guy )
{
	level notify( "kick_face" );

	players = get_players();
	for( i = 0; i < players.size; i++ )
	{
		players[i] dodamage( players[i].health * 0.1, ( 1509, -6516, -560 ) );
	}
}

opening_punch_face( guy )
{
	level notify( "punch_face" );

	players = get_players();
	for( i = 0; i < players.size; i++ )
	{
		players[i] dodamage( players[i].health * 0.1, ( 1509, -6516, -560 ) );
	}
}

opening_outside_reaction( guy )
{
	level notify( "outside_reaction" );

	exploder( 98 );
/*
	wait( 30 );

	players = get_players();
	for( i = 0; i < players.size; i++ )
	{
		players[i] PlayRumbleOnEntity( "damage_heavy" );
	}
*/
}

opening_detach_player( guy )
{
	level notify( "intro_release_player" );
	
	//iprintlnbold( "release player track" );
}

opening_timing()
{
	level waittill( "outside_reaction" );
	level notify( "intro_spawns" );
	//iprintlnbold( "intro spawns" );

	battlechatter_off();
}

opening_attach_detach_player_weapon( new_guy )
{
	wait( 0.5 );
	//iprintlnbold( "DETACH" );
	//self Detach( "weapon_rus_mosinnagant_rifle", "tag_weapon_right" );
	//self.weapon = "none";

	level waittill( "intro_hands_end" );

	new_guy Detach( "weapon_rus_mosinnagant_rifle", "tag_weapon_right" );
	new_guy.weapon = "none";
}

intro_german_end_anim_at_damage( guy, flag_name )
{
	level endon( "event_1_ends" );
	guy waittill( "damage", amount, attacker );
	//iprintlnbold( "DAMAGE" );
	guy stopanimscripted();
	guy.health = 5;
	guy dodamage( 10000, ( 0, 0, 0 ), attacker, attacker );
	flag_set( flag_name );
	//guy notify( "death" );
}

opening_zeitzev_gunshotFX( guy )
{
	PlayFxOnTag( level._effect["rifleflash"], guy, "tag_flash" );  // muzzleflash	
	wait( 0.2 );
	PlayFxOnTag( level._effect["rifle_shelleject"], guy, "tag_brass" );  // shell eject
}

opening_zeitzev_explosion( guy )
{
	exploder( 99 );

	players = get_players();
	for( i = 0; i < players.size; i++ )
	{
		players[i] PlayRumbleOnEntity( "artillery_rumble" );
	}

	level notify( "opening_house_explosion" );

	book_struct = getstruct( "opening_fake_book", "targetname" );
	level.opening_book = spawn( "script_model", book_struct.origin );
	level.opening_book.angles = book_struct.angles;
	level.opening_book setmodel( "static_berlin_books_diary" );

	level.hero1 show();
	level.hero2 show();
}

opening_objectives()
{
	// OBJ: To river
	objective_add( 1, "current", level.obj1_string, ( 2810, -6138, -662 ) );

	trigger = getent( "opening_obj_trig1", "targetname" );
	trigger waittill( "trigger" );
	objective_position( 1, ( 2999, -3940, -673.1 ) );

	trigger = getent( "flame_spawn_trigger", "targetname" );
	trigger waittill( "trigger" );
	objective_position( 1, ( 3537, -2243, -913 ) );

	level waittill( "event_1_ends" );
}

#using_animtree( "generic_human" );
// Russian soldier melees a German, then run to cover
melee_comabt_1_vignette()
{
	anim_node = getnode( "melee_combat_1", "targetname" );

	// spawn a german
	spawner = getent( "melee_combat_1_german", "targetname" );
	german = spawner stalingradspawn();
	if( !maps\_utility::spawn_failed( german ) )
	{
		german setup_vig_ai( "german" );
		german.health = 99999;
		german thread killed_by_player_only();
		//german.deathanim = level.scr_anim["german"]["melee_combat_1_death"];
		//german.weapon hide();
	}

	german Detach( GetWeaponModel( german.weapon ), "tag_weapon_right" );
	german.weapon = "none";
	german.dropweapon = false;
	german.grenadeammo = 0;

	spawner2 = getent( "melee_combat_1_russian", "targetname" );
	russian = spawner2 stalingradspawn();
	if( !maps\_utility::spawn_failed( russian ) )
	{
		russian setup_vig_ai( "russian" );
		russian disable_ai_color();
		russian thread magic_bullet_shield();
		russian.NoFriendlyfire = true;
	} 

	guys = [];
	guys[0] = german;
	guys[1] = russian;

	german.killer = russian;
	
	waittillframeend;
	
	if( isalive( german ) && isalive( russian ) )
	{
		level anim_reach( guys, "melee_combat_1", undefined, anim_node, undefined );

		if( isalive( german ) && isalive( russian ) )
		{
			russian thread monitor_other_guys_death( german );
			german thread monitor_other_guys_death2( russian );
			//german thread track_knockdown( russian );
			level anim_single( guys, "melee_combat_1", undefined, anim_node, undefined );
		}
	}

	if( !isalive( russian ) )
	{
		return;
	}

	russian resume_fire();

	flag_wait( "molotov_tossed" );

	russian enable_ai_color();
	russian thread late_stop_magic_bullet();

	russian.animname = "generic";
	russian thread opening_react_to_tank_fire();
}

late_stop_magic_bullet()
{
	self endon( "death" );
	wait( 3 );
	self thread stop_magic_bullet_shield();
}

monitor_other_guys_death2( otherguy )
{
	self endon( "anim_complete" );
	self endon( "death" );

	otherguy waittill( "death" );

	self StopAnimScripted();
			
	self resume_fire();

	self.health = 1;

	wait( 2 );

	self dodamage( self.health + 100, ( 0, 0, 0 ) );
}

track_knockdown( russian )
{
	self thread track_punches();
	wait( 8 );
	self.deathanim =  %ch_berlin1_E3vignette3_german_death;
	self playsound( "fall_body" );

	wait( 1 );

	if( isalive( russian ) )
	{
		PlayFxOnTag( level._effect["rifleflash"], russian, "tag_flash" );  // muzzleflash	
		russian playsound( "weap_mosinnagant_fire" );
	}
	wait( 0.2 );
	if( isalive( russian ) )
	{
		PlayFxOnTag( level._effect["rifle_shelleject"], russian, "tag_brass" );  // shell eject
	}
}

track_punches()
{
	//self thread track_punches_single( 3 );
	self thread track_punches_single( 5.5 );
	self thread track_punches_single( 7.2 );
}

track_punches_single( time )
{
	self endon( "death" );
	wait( time );
	self playsound( "ber3b_gun_impct" );
}

killed_by_player_only()
{
	while( 1 )
	{
		self waittill( "damage", amount, attacker, direction_vec, point, type );
	
		if( isplayer( attacker ) )
		{
			self dodamage( self.health + 100, ( 0, 0, 0 ), attacker, attacker );
		}
	}
}


#using_animtree( "generic_human" );
// Russian soldier melees a German, then run to cover
melee_comabt_2_vignette()
{
	anim_node = getnode( "melee_combat_2", "targetname" );

	spawner = getent( "melee_combat_2_german", "targetname" );
	german = spawner stalingradspawn();
	if( !maps\_utility::spawn_failed( german ) )
	{
		german setup_vig_ai( "german" );
		german.health = 99999;
		german thread killed_by_player_only();
		//german.deathanim = level.scr_anim["german"]["melee_combat_2_death"];
		//german.weapon hide();
	}

	german Detach( GetWeaponModel( german.weapon ), "tag_weapon_right" );
	german.weapon = "none";
	german.dropweapon = false;
	german.grenadeammo = 0;

	spawner2 = getent( "melee_combat_2_russian", "targetname" );
	russian = spawner2 stalingradspawn();
	if( !maps\_utility::spawn_failed( russian ) )
	{
		russian setup_vig_ai( "russian" );
		russian disable_ai_color();
		russian thread magic_bullet_shield();
		russian.NoFriendlyfire = true;
	}
	
	guys = [];
	guys[0] = german;
	guys[1] = russian;

	german.killer = russian;
	
	waittillframeend;

	//russian thread say_dialogue( "russian", level.opening_dialogs_list[level.opening_dialog_index] );
	//level.opening_dialog_index++;

	if( isalive( german ) && isalive( russian ) )
	{
		level anim_reach( guys, "melee_combat_2", undefined, anim_node, undefined );

		if( isalive( german ) && isalive( russian ) )
		{
			russian thread monitor_other_guys_death( german );
			german thread monitor_other_guys_death2( russian );
			german thread track_knockdown( russian );
			level anim_single( guys, "melee_combat_2", undefined, anim_node, undefined );
		}
	}

	if( !isalive( russian ) )
	{
		return;
	}

	russian resume_fire();

	flag_wait( "molotov_tossed" );

	russian enable_ai_color();
	russian thread late_stop_magic_bullet();

	russian.animname = "generic";
	russian thread opening_react_to_tank_fire();
}


//---------------------------------------------------------------------------------

opening_spawn_germans()
{
	level waittill( "player_exits_house" );
	//level waittill( "intro_spawns" );
	//level waittill( "player_exits_house" );

	spawners = getentarray( "opening_german_retreating", "targetname" );
	array_thread( spawners, ::add_spawn_function, ::opening_spawn_germans_think );

	for( i = 0; i < spawners.size; i++ )
	{
		german = spawners[i] stalingradspawn();

		// ensure that no more than 4 are spawned in a single frame. Helps network latency
		if( i % 4 == 0 )
		{
			wait_network_frame();		// Modifed to actually wait on the network correctly.  DSL
		}
	}
}

opening_spawn_germans_think()
{
	self endon( "death" );
		
	self hold_fire();
	self.goalradius = 32;
	self.grenadeammo = 0;
	self.ignoreall = 1;
	self.animname = "generic";

	//first_node_name = self.script_noteworthy + "_1";
	second_node_name = self.script_noteworthy + "_2";

	//first_node = getnode( first_node_name, "script_noteworthy" );
	second_node = getnode( second_node_name, "script_noteworthy" );

	self setgoalnode( second_node );
	//self thread play_random_turning_anim();

	self thread randomly_get_shot_from_behind();

	// kill himself once there
	self waittill( "goal" );
	self doDamage( self.health + 25, ( 0,180,48 ) );
}

randomly_get_shot_from_behind()
{
	self endon( "death" );
	chance = randomint( 100 );
	if( chance < 50 )
	{
		wait( randomfloat( 4 ) + 2 );
		self doDamage( self.health + 25, ( 0,90,48 ) );
	}
}

//---------------------------------------------------------------------------------

opening_spawn_fake_tank()
{
	drone_trigger = getent( "intro_fake_drones", "script_noteworthy" );
	drone_trigger trigger_off();

	level waittill( "intro_spawns" );
	drone_trigger trigger_on();
	drone_trigger notify( "trigger" );

	wait( 8 );

	tank_trigger = getent( "intro_fake_tank_trigger", "script_noteworthy" );
	tank_trigger notify( "trigger" );

	wait( 1 );

	tank = getent( "opening_fake_tank", "targetname" );
	tank SetTurretTargetVec( ( 1706, -5651, -666 ) );

	tank waittill( "reached_end_node" );

	if( isalive( tank ) )
	{
		tank notify( "death" );
		tank delete();
	}

}

opening_spawn_molotov_tossers()
{
	level waittill( "intro_spawns" );

	level.molotov_tosser_fall_down = 0;

	// molotov guys have all been spawned. 3 friends and 2 heroes
	level.friends[0] thread opening_molotov_tossers_think();
	level.friends[1] thread opening_molotov_tossers_think();
	level.friends[2] thread opening_molotov_tossers_think();
	level.hero1 thread opening_molotov_tossers_think( "hero" );
	level.hero2 thread opening_molotov_tossers_think( "hero" );
}

opening_molotov_tossers_think( hero )
{
	self endon( "death" );

	self.goalradius = 32;
	self.health = 99999;
	self.grenadeammo = 0;
	self hold_fire();
	self disable_ai_color();

	first_node_name = self.script_noteworthy + "_node1";
	second_node_name = self.script_noteworthy + "_node2";

	first_node = getnode( first_node_name, "script_noteworthy" );
	second_node = getnode( second_node_name, "script_noteworthy" );

	if( is_german_build() == false )
	{
		if( isdefined( hero ) && hero == "hero" )
		{
	
		}
		else
		{
			self setgoalnode( first_node );
			level waittill( "player_exits_house" );
		}
	}

	self setgoalnode( second_node );
	self.ignoreme = true;

	//self.grenadeWeapon = "molotov";

	self waittill( "goal" );
	//iprintlnbold( "GOAL" );

	if( self == level.hero1 )
	{
		self.animname = "reznov";
	}
	else if( self == level.hero2 )
	{
		self.animname = "chernov";
	}
	else 
	{
		self.animname = "russian";
	}

	second_node thread anim_single_solo( self, "toss_molotov" );
	self thread fake_throw_molotov();
	self waittillmatch( "single anim", "end" );

	//run_node = getnode( self.script_noteworthy, "script_noteworthy" );

	//self.goalradius = 32;
	//self thread run_chain_nodes( run_node );

	if( self == level.hero1 || self == level.hero2 )
	{
		run_node = getnode( self.script_noteworthy, "script_noteworthy" );
		self setgoalnode( run_node );
	}
	else
	{
		self.animname = "generic";
	}

	self thread opening_react_to_tank_fire();

	flag_set( "molotov_tossed" );

	wait( 2 );
	self enable_ai_color();

	self resume_fire();

	//self waittill( "chain_ends" );
	//self.health = 1;
	
	//self dodamage( self.health + 25, ( 0,180,48 ) );
	//self delete();
}

fake_throw_molotov()
{
	self endon( "death" );

	molotov = spawn( "script_model", self gettagorigin( "tag_weapon_left" ) );
	molotov.angles = self gettagangles( "tag_weapon_left" );
	molotov setmodel( "weapon_rus_molotov_grenade" );
	molotov linkto( self, "tag_weapon_left" );
	wait( 3.5 );
	playfxontag( level._effect["molotov_trail_fire"], molotov, "tag_flash" );

	wait( 2.2 );
	molotov unlink();
	molotov_target = getstruct( self.script_noteworthy, "targetname" );
	forward = VectorNormalize( ( molotov_target.origin + ( 0, 0, 300 ) ) - molotov.origin );
	velocities = forward * 12000;
	molotov physicslaunch( ( molotov.origin ), velocities );

	//velocities = ( forward + ( 300, 0, 0 ) ) * 10;
	//molotov movegravity( velocities, 4 );

	wait( 1.2 );
	playfx( level._effect["molotov_explosion"], molotov_target.origin );
	//Kevin adding molotov explosion sound
	playsoundatposition("weap_molotov_impact",molotov.origin);
	level thread start_spreading_fire( molotov_target.origin, 0.2 );
	molotov delete();
}

opening_react_to_tank_fire()
{
	self endon( "death" );

	while( 1 )
	{
		level waittill( "tank_fires" );

		if( isdefined( level.tank_fire_pos ) && isdefined( level.tank_fire_target ) )
		{
			nearestPoint = PointOnSegmentNearestToPoint( level.tank_fire_pos, level.tank_fire_target, self.origin );
			dist = distance( nearestPoint, self.origin );

			if( dist <= 250 )
			{
				wait( randomfloat( 0.5 ) );
				if( isalive( self ) )
				{
					if( self.angles[1] > 70 && self.angles[1] < 110 )
					{
						if( level.molotov_tosser_fall_down == 1 )
						{
							trigger = getent( "dont_flinch", "targetname" );
							if( self istouching( trigger ) )
							{
								return;
							}
							else
							{
								self anim_single_solo( self, "flinching_run_1" );
							}
							/*
							self set_run_anim( "flinching_run_1" );
							animation_time = getAnimLength( %ch_seelow1_flinch_run );
							wait( animation_time );
							self reset_run_anim();	
							*/
						}
						else if( self != level.hero1 )
						{		
							trigger = getent( "dont_flinch", "targetname" );
							if( self istouching( trigger ) )
							{
								return;
							}
							else
							{
								level.molotov_tosser_fall_down = 1;
								self anim_single_solo( self, "flinching_run_2" );
							/*
							self set_run_anim( "flinching_run_2" );
							animation_time = getAnimLength( %ch_seelow1_knockdown_run_b );
							wait( animation_time );
							self reset_run_anim();
							*/
								level.molotov_tosser_fall_down = 0;
							}
						}
					}
				}
			}
		}
		wait( 0.05 );
	}
}


start_spreading_fire( pos, wait_time )
{
	wait( wait_time );

	playfx( level._effect["wheat_fire_medium"], pos );
	//client notify for Kevins audio
	SetClientSysState("levelNotify","wheat_fire");

	//wait( 1 );

	//playfx( level._effect["tree_brush_fire"], pos+ ( 80, 30, 10 ) );
	//playfx( level._effect["tree_brush_fire"], pos + ( -80, -10, 6 ) );
}

//---------------------------------------------------------------------------------


opening_spawn_tanks()
{
	level thread opening_tank_1();
	level thread opening_tank_2();
	level thread wait_for_move_trigger();
	wait( 6 );
	level notify( "move_tanks" );
}

wait_for_move_trigger()
{
	trigger = getent( "opening_move_tanks", "targetname" );
	trigger waittill( "trigger" );
	level notify( "move_tanks" );

	level thread opening_fake_german();
}

opening_loop_fire_at_target( target_ent, fire_msg, end_msg )
{
	if( isdefined( end_msg ) )
	{
		level endon( end_msg );	
	}

	self SetTurretTargetEnt( target_ent );

	max_fires = 10;
	current_fires = 0;

	while( 1 )
	{
		if( current_fires > max_fires )
		{
			return;
		}

		if( isalive( self ) )
		{
			wait( randomfloat( 1.5 ) + 1.2 );
			if( isalive( self ) )
			{
				level notify( fire_msg );
				level.tank_fire_pos = self.origin;
				level.tank_fire_target = target_ent.origin;
				wait( 0.3 );
				self FireWeapon();
				playfx( level._effect["tank_fire_dust"],self.origin );
				current_fires++;

				if( target_ent.targetname == "opening_tank_1_target_2" || target_ent.targetname == "opening_tank_2_target_2" )
				{
					playfx( level._effect["wheat_blow_up"], target_ent.origin + ( 200, 0, 20 ) );
				}

				play_puddle_fx( self.origin, target_ent.origin );
			}
			wait( 4 );
		}
		else
		{
			return;
		}
	}
}


play_puddle_fx( tank_origin, target_origin )
{
	//find the nearest struct to the tank
	puddle_origins = getstructarray( "opening_puddle", "targetname" );
	nearest_puddle = puddle_origins[0];
	nearest_puddle_dist = distance( nearest_puddle.origin, tank_origin );

	for( i = 0; i < puddle_origins.size; i++ )
	{
		if( distance( puddle_origins[i].origin, tank_origin ) < nearest_puddle_dist )
		{
			nearest_puddle = puddle_origins[i];
			nearest_puddle_dist = distance( nearest_puddle.origin, tank_origin );
		}
	}

	// now the nearest struct is found. Make sure it's close enough to the firing tracer
	nearestPoint = PointOnSegmentNearestToPoint( tank_origin, target_origin, nearest_puddle.origin );
	dist = distance( nearestPoint, nearest_puddle.origin );

	if( dist <= 300 )
	{
		//print3d( nearest_puddle.origin + ( 0, 0, 30 ), "Puddle" );
		playfx( level._effect["puddle"], nearest_puddle.origin + ( 0, 0, 4 ) );
	}
}


opening_tank_1()
{
	start_node_1 = getvehiclenode( "opening_tank_1_start", "targetname" );
	tank1 = spawnvehicle( "vehicle_rus_tracked_t34", 
						 "tank1", 
						 "t34", 
						 start_node_1.origin, 
						 start_node_1.angles );		
	tank1.vehicletype = "t34";
	vehicle_init( tank1 );
	tank1 attachPath( start_node_1 );
	tank1.health = 100000;

	// prepare targets to fire at
	tank1_target1 = getent( "opening_tank_1_target_1", "targetname" );
	tank1_target2 = getent( "opening_tank_1_target_2", "targetname" );
	tank1_target3 = getent( "opening_tank_1_target_3", "targetname" );

	tank1 thread opening_loop_fire_at_target( tank1_target1, "tank_fires", "move_tanks" );
	level waittill( "move_tanks" );

	tank1 thread opening_loop_fire_at_target( tank1_target2, "tank_fires", "stop_firing_1" );
	tank1 startpath();

	end_node = getvehiclenode( "opening_tank_1_stop_fire", "script_noteworthy" );
	tank1 setwaitnode( end_node );
	tank1 waittill( "reached_wait_node" );	
	level notify( "stop_firing_1" );

	tank1 SetTurretTargetEnt( tank1_target3 );

	tank1 waittill( "reached_end_node" );
	tank1_target1 delete();
	tank1_target2 delete();
	tank1_target3 delete();
	tank1 doDamage( tank1.health + 25, ( 0,180,48 ) );
	tank1 delete();
}

opening_tank_2()
{
	start_node_2 = getvehiclenode( "opening_tank_2_start", "targetname" );
	tank2 = spawnvehicle( "vehicle_rus_tracked_t34", 
						 "tank2", 
						 "t34", 
						 start_node_2.origin, 
						 start_node_2.angles );	
	tank2.vehicletype = "t34";
	vehicle_init( tank2 );	
	tank2 attachPath( start_node_2 );
	tank2.health = 100000;

	// prepare targets to fire at
	tank2_target1 = getent( "opening_tank_2_target_1", "targetname" );
	tank2_target2 = getent( "opening_tank_2_target_2", "targetname" );
	tank2_target3 = getent( "opening_tank_2_target_3", "targetname" );

	tank2 thread opening_loop_fire_at_target( tank2_target1, "tank_fires", "move_tanks" );
	level waittill( "move_tanks" );

	wait( 3 );

	tank2 thread opening_loop_fire_at_target( tank2_target2, "tank_fires", "stop_firing_2" );
	tank2 startpath();


	// now fire at the house with player trigger. If the player is slow, wait for him at the node
	level.house_blown_up = false;
	tank2 thread opening_tank_2_wait();

	player_trigger = getent( "flame_spawn_trigger", "targetname" );
	player_trigger waittill( "trigger" );

	level notify( "stop_firing_2" );
	house_target = getent( "opening_house_explosion_target", "targetname" );
	tank2 SetTurretTargetEnt( house_target );
	wait( 2 );
	tank2 FireWeapon();
	exploder( 101 );
	level.house_blown_up = true;
	
	//client notify for Kevins audio
	SetClientSysState("levelNotify","house_explosion");

	tank2 SetTurretTargetEnt( tank2_target3 );
	level notify( "house_blown_up" );

	tank2 waittill( "reached_end_node" );
	tank2_target1 delete();
	tank2_target2 delete();
	tank2_target3 delete();
	tank2 doDamage( tank2.health + 25, ( 0,180,48 ) );
	tank2 delete();
}

opening_tank_2_wait()
{
	end_node = getvehiclenode( "opening_tank_2_stop_fire_2", "script_noteworthy" );
	self setwaitnode( end_node );
	self waittill( "reached_wait_node" );

	if( level.house_blown_up == false )
	{
		self setspeed( 0, 5 );

		while( level.house_blown_up == false )
		{
			wait( 0.05 );
		}

		self resumespeed( 5 );
	}

	wait( 1 );
}

opening_spawn_more_tanks()
{
	level endon( "event_1_ends" );

	trigger = getent( "flame_spawn_trigger", "targetname" );
	trigger waittill( "trigger" );

	start_node = getvehiclenode( "opening_tank_3_start", "targetname" );
	count = 0;

	while( 1 )
	{
		if( get_players()[0] istouching( trigger ) )
		{
			level thread opening_spawn_move_tank( start_node );	
			wait( randomint( 17 ) + 12 );
		}
		wait( 0.05 );
		count++;

		if( count > 5 )
		{
			return;
		}
	}
}

opening_spawn_move_tank( start_node )	
{
	tank = spawnvehicle( "vehicle_rus_tracked_t34", 
						 "tank", 
						 "t34", 
						 start_node.origin, 
						 start_node.angles );		
	tank attachPath( start_node );
	tank.health = 100000;
	tank startpath();

	tank waittill( "reached_end_node" );
	tank doDamage( tank.health + 25, ( 0,180,48 ) );
	tank delete();
}

//---------------------------------------------------------------------------------

additional_fires()
{
	flag_wait( "molotov_tossed" );

	structs = getstructarray( "opening_burning_field_points", "targetname" );
	for( i = 0; i < structs.size; i++ )
	{
		if( isdefined( structs[i].script_noteworthy ) && structs[i].script_noteworthy == "temp_disable" )
		{
			continue;
		}
		else
		{
			wait( 0.05 );
			playfx( level._effect["wheat_fire_medium"], structs[i].origin );	
		}
	}

	structs2 = getstructarray( "opening_burning_field_points_large", "targetname" );
	for( i = 0; i < structs2.size; i++ )
	{
		if( isdefined( structs2[i].script_noteworthy ) && structs2[i].script_noteworthy == "temp_disable" )
		{
			continue;
		}
		else
		{
			wait( 0.05 );
			playfx( level._effect["wheat_fire_large"], structs2[i].origin + ( 0, 0, 30 ) );
		}
	}

	structs3 = getstructarray( "opening_burning_field_points_smoke", "targetname" );
	for( i = 0; i < structs3.size; i++ )
	{
		wait( 0.05 );
		playfx( level._effect["wheat_smoke"], structs3[i].origin );
	}
}

force_move_friends()
{
	init_trigger = getent( "opening_initial_move_friends", "targetname" );
	init_trigger waittill( "trigger" );

	level thread pacing_dialog();
	wait( 6 );

	init_trigger trigger_off();
	init_trigger_2 = getent( "opening_initial_move_friends_1", "targetname" );
	if( isdefined( init_trigger_2 ) )
	{
		init_trigger_2 notify( "trigger" );
	}
}

shoot_from_behind_dialog()
{
	level.hero1 say_dialogue( "reznov", "shoot" );
	wait( 0.5 );
	level.hero2 say_dialogue( "chernov", "in_the_back" );
	wait( 0.5 );
	level.hero2 say_dialogue( "reznov", "wherever" );
}

pacing_dialog()
{
	trigger = getent( "scurve_pacing", "targetname" );
	trigger waittill( "trigger" );
	
	level.hero1 say_dialogue( "reznov", "things_changed" );
	wait( 0.5 );

	level.hero1 say_dialogue( "reznov", "their_blood" );
}

spawn_func_running_and_dying()
{
	self.goalradius = 16;
	self.ignoreall = 1;
	self.pacifist = 1;
	self.health = 999;
	self.accuracy = 0.01;
	self.animname = "generic";
	self endon( "death" );

	if( is_german_build() == false )
	{
	//self assign_random_retreat_anim();
		self putGunAway();


		self set_run_anim( "flame_run" );
	}
	//self.deathanim = %ai_flame_death_run_die;
/*
	index = randomint( 100 );
	if( index < 50 )
	{
		self set_run_anim( "flame_run" );
	}
	else
	{
		self set_run_anim( "panick_run_2" );
	}
*/

	self thread protect_from_dying( 2);

	if( is_german_build() == false )
	{
		self thread animscripts\death::flame_death_fx();
	}

	wait( 2 );
	while( distance( self.origin, self.goalpos ) > 100 )
	{
		wait( 0.1 );
	}
	//self waittill( "goal" );

	if( is_german_build() == false )
	{
		tags = [];
		tags[0] = "j_hip_le";
		tags[1] = "j_hip_ri";
		tags[2] = "j_head";
		tags[3] = "j_spine4";
		tags[4] = "j_elbow_le";
		tags[5] = "j_elbow_ri";
		tags[6] = "j_clavicle_le";
		tags[7] = "j_clavicle_ri";
		
		for(i = 0; i < 2; i++)
		{
			random = randomintrange(0, tags.size);
			BulletTracer( ( 2051, -5465, -666 ) + ( randomint(50)-25, 0, 0 ) , self gettagorigin( tags[random] ) );
			if( random == 2 )
			{
				playfxontag( level._effect["headshot_hit"], self, tags[random]);
				break;
			}
			else
			{
				playfxontag( level._effect["flesh_hit"], self, tags[random]);
				wait(randomfloat(0.1));
			}
		}
	}

	if( self.script_noteworthy == "opening_running_germans_close" )
	{
		self doDamage( self.health + 25, ( 2550, -5224, -666 ) );
	}
	else
	{
		self doDamage( self.health + 25, ( 2550, -5224, -666 ) );
	}
}

protect_from_dying( time )
{
	self endon( "death" );
	self.health = 9999;
	wait( time );
	self.health = 50;
}

spawn_func_running_and_dying_to_end()
{
	self endon( "death" );
	self endon( "ready_to_die_already" );

	self.goalradius = 16;
	self.ignoreall = 1;
	self.pacifist = 1;
	self.health = 200;
	self.accuracy = 0.01;

	self thread goal_die_to_player();

	wait( 2 );
	while( distance( self.origin, self.goalpos ) > 100 )
	{
		wait( 0.1 );
	}

	if( is_german_build() == false )
	{
		tags = [];
		tags[0] = "j_hip_le";
		tags[1] = "j_hip_ri";
		tags[2] = "j_head";
		tags[3] = "j_spine4";
		tags[4] = "j_elbow_le";
		tags[5] = "j_elbow_ri";
		tags[6] = "j_clavicle_le";
		tags[7] = "j_clavicle_ri";
		
		for(i = 0; i < 2 + randomint(3); i++)
		{
			random = randomintrange(0, tags.size);
			BulletTracer( ( 2051, -5465, -666 ) + ( randomint(50)-25, 0, 0 ) , self gettagorigin( tags[random] ) );
			if( random == 2 )
			{
				playfxontag( level._effect["headshot_hit"], self, tags[random]);
				break;
			}
			else
			{
				playfxontag( level._effect["flesh_hit"], self, tags[random]);
				wait(randomfloat(0.2));
			}
		}
	}

	//self waittill( "goal" );
	self doDamage( self.health + 25, ( 2046, -5308, -666 ) );
}

goal_die_to_player()
{
	self endon( "death" );
	self endon( "goal" );

	while( 1 )
	{
		players = get_players();
		for( i = 0; i < players.size; i++ )
		{
			if( distance( players[i].origin, self.origin ) < 80 )
			{
				self notify( "ready_to_die_already" );
				tags = [];
				tags[0] = "j_hip_le";
				tags[1] = "j_hip_ri";
				tags[2] = "j_head";
				tags[3] = "j_spine4";
				tags[4] = "j_elbow_le";
				tags[5] = "j_elbow_ri";
				tags[6] = "j_clavicle_le";
				tags[7] = "j_clavicle_ri";
				
				for(i = 0; i < 2 + randomint(3); i++)
				{
					random = randomintrange(0, tags.size);
					BulletTracer( ( 2051, -5465, -666 ) + ( randomint(50)-25, 0, 0 ) , self gettagorigin( tags[random] ) );
					if( random == 2 )
					{
						playfxontag( level._effect["headshot_hit"], self, tags[random]);
						break;
					}
					else
					{
						playfxontag( level._effect["flesh_hit"], self, tags[random]);
						wait(randomfloat(0.2));
					}
				}

				self doDamage( self.health + 25, ( 0,180,48 ) );
				return;
			}
		}

		wait( 0.1 );
	}
}


spawn_flaming_guys()
{
	/*
	trigger = getent( "flame_spawn_trigger", "targetname" );
	trigger waittill( "trigger" );

	level thread running_on_fire_1_vignette();
	level thread running_on_fire_2_vignette();
	*/
}

running_on_fire_1_vignette()
{
	spawner = getent( "opening_fire_runner_1_death", "targetname" );
	german = spawner StalingradSpawn();
	spawn_failed (german);
	german.animname = "german";

	//german = spawn_fake_guy_to_anim( "running_on_fire_1", "axis", "german", "guy" );
	german thread animscripts\death::flame_death_fx();
	level thread anim_single_solo( german, "running_on_fire_1", undefined, german );
	 
	level thread early_kill_german( german );
	wait( 5 );
	//german doDamage( german.health + 25, ( 0,180,48 ) );
	german startragdoll();	
}	

running_on_fire_2_vignette()
{
	//german = spawn_fake_guy_to_anim( "running_on_fire_2", "axis", "german", "guy" );
	spawner = getent( "opening_fire_runner_1_death", "targetname" );
	german = spawner StalingradSpawn();
	spawn_failed (german);
	german.animname = "german";

	german thread animscripts\death::flame_death_fx();
	level thread anim_single_solo( german, "running_on_fire_2", undefined, german );

	level thread early_kill_german( german );
	wait( 5 );
	//german doDamage( german.health + 25, ( 0,180,48 ) );
	german startragdoll();
}	

early_kill_german( german )
{
	german waittill( "damage" );
	//iprintlnbold( "damage" );
	german stopanimscripted();
	german startragdoll();
}

spawn_flaming_guys_side()
{
	trigger = getent( "opening_fire_hole_trig", "targetname" );
	trigger waittill( "trigger" );

	pos1 = getstruct( "opening_fire_hole_target", "targetname" );
	pos2 = getstruct( "opening_fire_hole_target_2", "targetname" );

	playfx( level._effect["molotov_explosion"], pos1.origin );
	playfx( level._effect["molotov_explosion"], pos2.origin );

	if( is_german_build() == false )
	{
		level thread running_on_fire_3_vignette();  
		wait( 0.5 );
		level thread running_on_fire_5_vignette(); 
	}
}

running_on_fire_3_vignette()
{
	//german = spawn_fake_guy_to_anim( "running_on_fire_3", "axis", "german", "guy" );
	spawner = getent( "opening_fire_runner_1_death", "targetname" );
	german = spawner StalingradSpawn();
	spawn_failed (german);
	german hold_fire();
	german.animname = "german";
	german.health = 10;
	german.allowdeath = true;

	german thread animscripts\death::flame_death_fx();
	level thread anim_single_solo( german, "running_on_fire_1", undefined, german );
	 level thread early_kill_german( german );
	wait( 5 );
	//german doDamage( german.health + 25, ( 0,180,48 ) );
	if( isalive( german ) )
	{
		german startragdoll();
	}
}	

running_on_fire_4_vignette()
{
	german = spawn_fake_guy_to_anim( "running_on_fire_4", "axis", "german", "guy" );
	german thread animscripts\death::flame_death_fx();
	level thread anim_single_solo( german, "running_on_fire_2", undefined, german );

	wait( 5 );
	//german doDamage( german.health + 25, ( 0,180,48 ) );
	german startragdoll();
}	

running_on_fire_5_vignette()
{
	//german = spawn_fake_guy_to_anim( "running_on_fire_5", "axis", "german", "guy" );
	spawner = getent( "opening_fire_runner_2_death", "targetname" );
	german = spawner StalingradSpawn();
	spawn_failed (german);
	german hold_fire();
	german.animname = "german";
	german.health = 10;
	german.allowdeath = true;

	german thread animscripts\death::flame_death_fx();
	level thread anim_single_solo( german, "running_on_fire_2", undefined, german );
	level thread early_kill_german( german );
	wait( 5 );
	//german doDamage( german.health + 25, ( 0,180,48 ) );
	if( isalive( german ) )
	{
		german startragdoll();
	}
}	
	
//---------------------------------------------------------------------------------

opening_plane_flash()
{
	trigger = getent( "opening_obj_trig1", "targetname" );
	trigger waittill( "trigger" );

	wait( 2 );

	level thread opening_flashes();

	start_node = getvehiclenode( "opening_plane_start", "targetname" );

	plane = spawnvehicle( "vehicle_rus_airplane_il2", 
						 "plane", 
						 "stuka", 
						 start_node.origin, 
						 start_node.angles );		

	plane attachPath( start_node );
	plane startpath();
	
	plane playsound( "fly_by" );

	wait( 3 );
	//level thread maps\see1_event3::plane_tracer_burst( plane );

	plane waittill( "reached_end_node" );
	plane notify( "stop_firing" );

	plane delete();
}

opening_flashes()
{
	flash_points1 = getstruct( "opening_flash_1", "targetname" );
	//flash_points2 = getstruct( "opening_flash_2", "targetname" );
	flash_points2 = getstruct( "opening_flash_2_new", "targetname" );
	flash_points3 = getstruct( "opening_flash_3", "targetname" );

	wait( 5 );

	//playfx( level._effect["flak_flash"], flash_points1.origin );
	//wait( 0.5 );
	//playfx( level._effect["flak_flash"], flash_points2.origin );
	//wait( 0.5 );
	//playfx( level._effect["flak_flash"], flash_points3.origin );
	//wait( 0.5 );

	playfx( level._effect["napalm"], flash_points1.origin );
	//kevin's playsound
	playsoundatposition("bomb1L",flash_points1.origin);
	wait( 0.7 );
	playfx( level._effect["napalm"], flash_points2.origin );
	playsoundatposition("bomb2L",flash_points2.origin);
	//wait( 1.4 );
	//playfx( level._effect["napalm"], flash_points3.origin );
	//playsoundatposition("plane_bomb1L",flash_points1.origin);
}

lower_accuracy_for_event_2()
{
	start_trigger = getent( "opening_initial_move_friends_2", "targetname" );
	start_trigger waittill( "trigger" );
	//iprintlnbold( "lower" );

	level thread lower_friendlies_accuracy( 0.1, "restore_accuracy" );
	
	end_trigger1 = getent( "ev1_move_init_enemies", "targetname" );
	end_trigger2 = getent( "restore_accuracy_1", "targetname" );
	end_trigger3 = getent( "restore_accuracy_2", "targetname" );

	level thread wait_for_trigger_and_notify( end_trigger2, "restore_accuracy" );
	level thread wait_for_trigger_and_notify( end_trigger3, "restore_accuracy" );

	end_trigger1 waittill( "trigger" );
	level thread wait_time( 30, "restore_accuracy" );

}

dialog_player_into_wheat_field()
{
	trigger = getent( "opening_into_wheat_field", "targetname" );
	trigger waittill( "trigger" );

	level.hero2 say_dialogue_wait( "chernov", "stay_out" );
	level.hero2 say_dialogue_wait( "chernov", "soon_ashes" );
	if( isdefined( trigger ) && any_player_touching( trigger ) )
	{
		// wait for player to exit flame
		while( 1 )
		{
			if( !isdefined( trigger ) )
			{
				return;
			}

			if( any_player_touching( trigger ) == false )
			{
				wait( 1 );
				level.hero1 say_dialogue_wait( "reznov", "fireproof" );
				return;
			}
			else
			{
				wait( 0.1 );
			}
		}
	}

}

opening_molotov_instructions()
{
	trigger = getent( "opening_initial_move_friends", "targetname" );
	trigger waittill( "trigger" );
	
	print_text_on_screen( &"SEE1_USE_MOLOTOV" );
}

opening_cleanup()
{

	wait( 0.1 );
	delete_ent_array( "opening_mg_vig", "targetname" );
	delete_ent_array( "opening_into_wheat_field", "targetname" );
	delete_ent_array( "opening_obj_trig1", "targetname" );
	delete_ent_array( "opening_move_tanks", "targetname" );
	delete_ent_array( "opening_vig_start", "targetname" );
	delete_ent_array( "opening_fire_hole_trig", "targetname" );
	delete_ent_array( "flame_spawn_trigger", "targetname" );
	delete_ent_array( "opening_field_spawners", "targetname" );
	delete_ent_array( "intro_anim_node", "targetname" );
	delete_ent_array( "opening_initial_move_1", "targetname" );
	delete_ent_array( "opening_initial_move_friends", "targetname" );
	delete_ent_array( "opening_initial_move_friends_1", "targetname" );
	delete_ent_array( "opening_initial_move_friends_2", "targetname" );
	delete_ent_array( "intro_fake_drones", "script_noteworthy" );
	delete_ent_array( "opening_field_spawners", "script_noteworthy" );
	delete_ent_array( "intro_fake_tank_trigger", "script_noteworthy" );
	delete_ent_array( "intro_drones_temp", "script_noteworthy" );

}