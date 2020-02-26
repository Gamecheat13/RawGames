#include maps\_utility;
#include common_scripts\utility;
#include maps\pel2_util;
#include maps\_anim;
#include maps\_music;
#include maps\_busing;

// pel2_forest script

main()
{
	
	autosave_by_name( "Pel2 forest begin" );
	
	//Tuey Change Music State to AFTERBUNKER
	setmusicstate("AFTERBUNKER");

	maps\_debug::set_event_printname( "Dunes" );

	battlechatter_off();

	play_vo( level.roebuck, "vo", "half_a_mile_north" );

	// spawn and move forest tanks
	level thread forest_tanks();
	
	level thread bomber_crash();
	level thread admin_mg_guys();

	level thread trig_grass_admin_camo_guys();
	level thread dunes_flame_tree();
	level thread forest_ambient_bombers();
	level thread dunes_ambush_beat_2_timeout();
	level thread dunes_ambush_beat_3_timeout();

	for( i  = 0; i < level.heroes.size; i++ )
	{
		level.heroes[i] set_force_color( "g" );
		level.heroes[i] thread set_pacifist_on();
		level.heroes[i] setcandamage( true );
	}
	
	set_color_chain( "chain_forest" );

	forest_mid();
	
}



///////////////////
//
// 2nd part of ambush happens after a bit if player doesn't move up
//
///////////////////////////////

dunes_ambush_beat_2_timeout()
{
	
	level endon( "trig_grass_admin_camo_guys_2" );
	
	flag_wait( "trig_grass_admin_camo_guys" );
	
	wait( RandomIntRange( 8, 11 ) );	
	
	trig = getent( "trig_grass_admin_camo_guys_2", "script_noteworthy" );
	if( isdefined( trig ) )
	{
		quick_text( "ambush_beat_2 timed out!", 3, true );
		trig notify( "trigger" );	
	}
	
}



///////////////////
//
// 3rd part of ambush happens after a bit if player doesn't move up
//
///////////////////////////////

dunes_ambush_beat_3_timeout()
{
	
	level endon( "trig_grass_admin_camo_guys_3" );
	
	flag_wait( "trig_grass_admin_camo_guys_2" );
	
	wait( RandomIntRange( 10, 13 ) );	
	
	trig = getent( "trig_grass_admin_camo_guys_3", "script_noteworthy" );
	if( isdefined( trig ) )
	{
		quick_text( "ambush_beat_3 timed out!", 3, true );
		trig notify( "trigger" );	
	}
	
}



///////////////////
//
// Handles tree sniper
//
///////////////////////////////

dunes_flame_tree()
{

	// DEBUG
//	dunes_flame_tree_debug();

	// spawn in tree sniper
	tree_trig = getent( "trig_grass_admin_tree_guy", "script_noteworthy" );
	tree_trig notify( "trigger" );
	wait( 0.05 );
	guy = get_ai_group_ai( "tree_guy" )[0];
	guy thread dune_flame_tree_guy_strat();
	guy thread dune_flame_tree_guy_death();

	tree = getent( "dunes_flame_tree", "script_noteworthy" );
	tree thread dunes_flame_tree_notify();
	tree thread dunes_flame_tree_achievement();
	
	fake_orig = getstruct( "flame_tree_orig", "targetname" );
	fake_orig_2 = getstruct( "flame_tree_orig_2", "targetname" );
	
	// play the looping fx of fronds that hide the tree sniper
	model_tag_origin = spawn( "script_model", fake_orig.origin );
	model_tag_origin setmodel("tag_origin");
	model_tag_origin.angles = fake_orig.angles;
//	model_tag_origin linkto( tree, "tag_origin", ( 0, 0, 0 ), ( 0, 0, 0 ) );
	playfxontag( level._effect["sniper_leaf_loop"], model_tag_origin, "TAG_ORIGIN" );
	
	flag_wait( "trig_grass_admin_camo_guys_2" );
	
	set_color_chain( "chain_forest_banzai_2" );
	
	// delete the looping fx
//	model_tag_origin unlink();
	model_tag_origin delete();
	
	wait( 0.05 );
	
	// guy "throws" fronds aside so he can attack
	orig = getent( "test_orig", "targetname" );
	playfx( level._effect["sniper_leaf_canned"], tree.origin );

}




//dunes_flame_tree_debug()
//{
//	
//// spawn in tree sniper
//	tree_trig = getent( "trig_grass_admin_tree_guy", "script_noteworthy" );
//	tree_trig notify( "trigger" );
//	wait( 0.05 );
//	guy = get_ai_group_ai( "tree_guy" )[0];
//	guy thread dune_flame_tree_guy_strat();
//	guy thread dune_flame_tree_guy_death();
//
//	tree = getent( "dunes_flame_tree", "script_noteworthy" );
//	tree thread dunes_flame_tree_notify();
//	tree thread dunes_flame_tree_achievement();
//
//	fake_orig = getstruct( "flame_tree_orig", "targetname" );
//	fake_orig_2 = getstruct( "flame_tree_orig_2", "targetname" );
//	
//	while( 1 )
//	{
//		// play the looping fx of fronds that hide the tree sniper
//		model_tag_origin = spawn( "script_model", fake_orig.origin );
//		model_tag_origin setmodel("tag_origin");
//		model_tag_origin.angles = fake_orig.angles;
//	//	model_tag_origin linkto( tree, "tag_origin", ( 0, 0, 0 ), ( 0, 0, 0 ) );
//		playfxontag( level._effect["sniper_leaf_loop"], model_tag_origin, "TAG_ORIGIN" );
//		
//		wait( 3 );
//		
//		
//		// delete the looping fx
//	//	model_tag_origin unlink();
//		model_tag_origin delete();
//		
//		wait( 0.05 );
//		
//		// guy "throws" fronds aside so he can attack
//		playfx( level._effect["sniper_leaf_canned"], tree.origin );
//		
//		wait( 2 );
//		
//	}
//	
//}



dune_flame_tree_guy_death()
{

	self waittill_either( "death", "fake tree death" );
	flag_set( "flame_tree_guy_dead" );
	
}


dunes_flame_tree_notify()
{
	
	level endon( "trig_admin_back" );
	
	flag_wait( "grass_admin_surprise" );

	wait( 0.05 );

	guy = get_ai_group_ai( "tree_guy" )[0];
	
	while( 1 )
	{
	
		self waittill( "broken", broken_notify, attacker );
		
		if( broken_notify == "hideout_fronds_dmg0" )
		{
			
			flag_set( "flame_tree_flamed" );
			
			tree = getent( "dunes_flame_tree", "script_noteworthy" );
			//tree playsound( "flame_ignite_tree" );
			playsoundatposition("flame_ignite_tree", tree.origin);
		
			//TUEY - When we get entity playsound fixed, this will work...but it doesn't for now , so I'm commenting it out.		
			//level thread maps\pel2_amb::play_flame_tree_loop(tree);
			
			if( isdefined( guy ) && isalive( guy ) )
			{
			
				guy thread animscripts\death::flame_death_fx();
				guy thread tree_guy_flame_sound();
				guy setcandamage( true );
				guy notify( "fake tree death", attacker );
				
				// give player achievement for torching tree guy
				if( IsDefined( level.last_tree_attacker ) )
				{
					level.last_tree_attacker giveachievement_wrapper( "PEL2_ACHIEVEMENT_TREE" ); 
				}				
			
			}
			
			break;
		}
		
	}
	
}



///////////////////
//
// monitor destructible tree for flame tree achievement
//
///////////////////////////////

dunes_flame_tree_achievement()
{

	//level endon( "flame_tree_flamed" );

	while( 1 )
	{
	
		self waittill( "damage", amount, attacker, direction_vec, point, type );
		
		type = tolower( type );
		
		if(  IsPlayer( attacker ) && type == "mod_burned" )
		{
			level.last_tree_attacker = attacker;
		}
		
	}
	
}


tree_guy_flame_sound()
{
	// TEMP!
	temp_orig = spawn( "script_origin", self.origin );
	temp_orig playsound( "body_burn_vo" );
	
	temp_orig waittill( "body_burn_vo"  );
	
	temp_orig delete();
	
}



///////////////////
//
// handles much of the sanddune ambush
//
///////////////////////////////

trig_grass_admin_camo_guys()
{
	
	simple_spawn( "grass_admin_camo_guys", ::grass_admin_camo_guys_strat );	
	wait_network_frame(); // CLIENTSIDE to help snapshot size
	simple_spawn( "grass_admin_camo_guys_2", ::grass_admin_camo_guys_strat_2 );	
	wait_network_frame(); // CLIENTSIDE to help snapshot size
	simple_spawn( "grass_admin_camo_guys_3", ::grass_admin_camo_guys_strat_3 );	
	
	// wait till player is close enough (flag set on trigger)
	flag_wait( "trig_grass_admin_camo_guys");
	
	flag_set( "grass_admin_surprise" );

	battlechatter_on( "axis" );

	level thread grass_ambush_vo_1();

	array_thread( level.heroes, ::set_pacifist_off );

	//Tuey	Play another VO at grass location
	playsoundatposition("japanese_yell_ambush", (2686.6, -5004, 135));
	
	//Tuey Moved Music to ambush instead of on crashing plane
	//TUEY Set's Music to BOMBER
	setmusicstate("BOMBER");

	waittill_aigroupcleared( "grass_admin_camo_ai" );
	waittill_aigroupcleared( "tree_guy" );

	flag_set( "grass_ambush_done" );

	trig = getent( "trig_forest_end", "script_flag" );
	if( isdefined( trig ) )
	{
		trig notify( "trigger" );	
	}
	
	battlechatter_on();
	
	set_color_chain( "trig_start_admin_delete" );
	
}



dune_flame_tree_guy_strat()
{

	self.script_noteworthy = "dont_kill_me";

	self setcandamage( false );
	self disableaimassist();
	self allowedstances ( "prone" );
	self.a.pose = "prone"; 	
	self.ignoreme = 1;
	self.ignoreall = 1;
	self.pacifist = 1;
	self.pacifistwait = 0.05;
	self.activatecrosshair = false;
	self.drawoncompass = false;
	self.grenadeawareness = 0;		
	
	flag_wait( "trig_grass_admin_camo_guys_2" );
	
	self setcandamage( true );
	
	self allowedstances ( "crouch" );
	self.a.pose = "crouch"; 	
	self enableaimassist();
	self.activatecrosshair = true;
	self.drawoncompass = true;
	self.ignoreall = 0;	
	self.pacifist = 0;
	
	self thread accuracy_increase_over_time();
	
	wait( 3 );
	
	self.ignoreme = 0;
	
}



accuracy_increase_over_time()
{

	self endon( "death" );
	
	old_accuracy = self.baseaccuracy;
	
	self.baseaccuracy = 0.05;
	
	while( self.baseaccuracy < old_accuracy )
	{
		self.baseaccuracy += 0.05;
		wait( RandomIntRange( 3, 5 ) );
	}
	
}


grass_ambush_vo_1()
{

	guys = get_ai_group_ai( "e3_extra_ai" );
	redshirt_5 = level.extra_hero;
	redshirt_6 = guys[0];
	
	level.roebuck thread grass_ambush_vo_2();
	
	flag_wait( "grass_admin_surprise" );

	wait( 1 );
	
	play_vo( redshirt_5, "vo", "roebuck_theyre_in" );
	wait( 2.1 );

	// tree guy is revealed
	flag_wait( "trig_grass_admin_camo_guys_2" );
	
	wait( 0.3 );
	
	play_vo( level.polonsky, "vo", "up_there_in_tree" );
	wait( 1.5 );
	play_vo( level.polonsky, "vo", "shit!" );
	
	flag_wait( "flame_tree_affects_grass" );
	
	wait( 0.75 );
	
	play_vo( level.polonsky, "vo", "more_of_them" );	
	
	flag_wait( "grass_ambush_done" );
	
	wait( 1.5 );
	
	//play_vo( redshirt_5, "vo", "fuckin_believe_that" );
	//wait( 1.8 );
	play_vo( level.polonsky, "vo", "just_waiting_for_us" );


	
}



grass_ambush_vo_2()
{
	
	flag_wait( "grass_admin_surprise" );
	wait( 2.1 );

	play_vo( self, "vo", "over_there_mumble" );

}



grass_admin_camo_guys_strat()
{

	self endon( "death" );

	// so kill_all_ai skips this guy
	self.script_noteworthy = "dont_kill_me";
	
	// keep him stealthy
	self maps\pel2::init_ambush_fields();
	
	// set flag(s) if he's damaged
	self thread grass_admin_surprise_damage( "grass_admin_surprise_damage", "trig_grass_admin_camo_guys" );
	
	flag_wait_either( "grass_admin_surprise", "grass_admin_surprise_damage" );
	
	// stagger their emergence times if necessary
	if( isdefined( self.script_float ) )
	{
		wait( self.script_float );
	}

	// make him active again
	self maps\pel2::clear_ambush_fields();

	self thread maps\pel2::grass_surprise_half_shield( 1.8 );
	self thread maps\pel2::grass_camo_ignore_delay( 1.8 );
	
	// choose which variant anim to use
	prone_anim = maps\pel2::choose_prone_to_run_anim_variant();
	level.animtimefudge = 0.05;
	self play_anim_end_early( prone_anim, level.animtimefudge );	
	
	if( isdefined( self.script_noteworthy ) && self.script_noteworthy == "pel2_no_banzai" )
	{
		self allowedstances( "crouch" );
		wait( RandomIntRange( 4, 7 ) );
	}
	
	self thread maps\_banzai::banzai_force();

}



grass_admin_camo_guys_strat_2()
{

	self endon( "death" );

	// so kill_all_ai skips this guy
	self.script_noteworthy = "dont_kill_me";
	
	// keep him stealthy
	self maps\pel2::init_ambush_fields();
	
	// set flag(s) if he's damaged
	self thread grass_admin_surprise_damage( "admin_camo_guys_2_startled" );
	self thread grass_admin_surprise_proximity();
	
	while( 1 )
	{
		
		if( flag( "flame_tree_flamed" ) || flag( "flame_tree_guy_dead" ) || flag( "admin_camo_guys_2_startled" ) || flag( "trig_forest_end" ) )
		{
			break;
		}	
		
		// if he's been damaged or player got in close proximity
		if( self.pel2_startled )
		{
			break;	
		}
		
		wait( 0.1 );
	}	
	
	
	// if the tree was actually flamed, wait for the burning fronds to scorch the ground
	if( flag( "flame_tree_flamed" ) && !self.pel2_startled )
	{
		wait( 3.5 );
	}
	// if the guy was killed any other way
	else if( !self.pel2_startled )
	{
		wait( RandomFloatRange( 1.0, 1.7 ) );	
	}
	
	flag_set( "flame_tree_affects_grass" );
	
	// stagger their emergence times if necessary
	if( isdefined( self.script_float ) && !self.pel2_startled )
	{
		wait( self.script_float );
	}

	// make him active again
	self maps\pel2::clear_ambush_fields();

	self thread maps\pel2::grass_surprise_half_shield( 2.4 );
	self thread maps\pel2::grass_camo_ignore_delay( 2.4 );

	// choose which variant anim to use
	prone_anim = maps\pel2::choose_prone_to_run_anim_variant();
	level.animtimefudge = 0.05;
	self play_anim_end_early( prone_anim, level.animtimefudge );	
	
	self thread maps\_banzai::banzai_force();

}



grass_admin_camo_guys_strat_3()
{

	self endon( "death" );

	// so kill_all_ai skips this guy
	self.script_noteworthy = "dont_kill_me";
	
	// keep him stealthy
	self maps\pel2::init_ambush_fields();
	
	// set flag(s) if he's damaged
	self thread grass_admin_surprise_damage();
	self thread grass_admin_surprise_proximity();
	
	while( 1 )
	{
		// if player moves up
		if( flag( "trig_grass_admin_camo_guys_3" ) )
		{
			break;	
		}	
		// if he's been damaged
		if( self.pel2_startled )
		{
			break;	
		}
		
		wait( 0.1 );
	}
	
	// stagger their emergence times if necessary
	if( !self.pel2_startled && isdefined( self.script_float ) )
	{
		wait( self.script_float );
	}

	// make him active again
	self maps\pel2::clear_ambush_fields();

	self thread maps\pel2::grass_surprise_half_shield( 2.4 );
	self thread maps\pel2::grass_camo_ignore_delay( 1.25 );

	// choose which variant anim to use
	prone_anim = maps\pel2::choose_prone_to_run_anim_variant();
	level.animtimefudge = 0.05;
	self play_anim_end_early( prone_anim, level.animtimefudge );	

	wait( RandomFloatRange( 2.8, 4.5 ) );

	self.banzai_no_wait = 1;	
	self.ignoresuppression = 1;		
	self thread maps\_banzai::banzai_force();	

}



///////////////////
//
// sets flag(s) if guy has been damaged
//
///////////////////////////////

grass_admin_surprise_damage( flag_name, alt_flag_name )
{

	level endon( "trig_ditch_guys" );
	self endon( "clear_ambush_fields" );

	self waittill( "damage", damage, attacker );
	
	if( self.health <= 0 && isplayer( attacker ) )
	{
		attacker giveachievement_wrapper( "ANY_ACHIEVEMENT_GRASSJAP" ); 	
	}
	
	if( isdefined( flag_name ) )
	{
		flag_set( flag_name );
	}
	if( isdefined( alt_flag_name ) )
	{
		flag_set( alt_flag_name );
	}
	
	self.pel2_startled = true;
	
}


///////////////////
//
// checks if player(s) are near ambush guy
//
///////////////////////////////
grass_admin_surprise_proximity()
{

	level endon( "trig_ditch_guys" );
	self endon( "clear_ambush_fields" );	

	self endon( "death" );

	startled = false;	

	while( !startled )
	{
		
		players = get_players();
		for( i  = 0; i < players.size; i++ )
		{
			if( distanceSquared( players[i].origin, self.origin ) < (125*125) )
			{
				startled = true;
				break;
			}
		}		
		
		if( startled )
		{
			break;	
		}
		
		wait( 0.5 );
		
	}

	self.pel2_startled = true;
	
}



admin_mg_guys()
{
	//trigger_wait( "trig_admin_mg_guys", "script_noteworthy" );
	flag_wait( "trig_grass_admin_camo_guys_3" );
	wait( 1 );
	
	simple_floodspawn( "admin_mg_guys", ::admin_mg_guys_strat );
	wait_network_frame();
	simple_floodspawn( "admin_bottom_right_spawners" );
}



admin_mg_guys_strat()
{
	self endon( "death" );
	self.ignoresuppression = true;
}



///////////////////
//
// marines that join the player's squad in beginning of event 3
//
///////////////////////////////

forest_friendlies()
{

	flag_wait( "trig_forest_friendlies" );
	
	event_text( "forest_friendlies" );
	
	guys = simple_spawn( "friend_forest_spawner", ::friend_forest_spawner_strat );
		
}



friend_forest_spawner_strat()
{

	self endon( "death" );

	self disable_replace_on_death();
	
	wait( 0.5 ); // wait for simple_spawn to finish adding its own targetname so we can overwrite it
	self.targetname = "friendly_squad";

	flag_wait( "trig_flame_bunker_exit" );
	
	self set_force_color( "y" );
	
}



///////////////////
//
// Drones on ridge to left in destroyed forest area
//
///////////////////////////////

forest_drones()
{

	// start drones
	trig = getent( "trig_forest_drones", "script_noteworthy" );
	trig notify( "trigger" );
	

	level waittill( "end_forest_drones" );
	
	trig = getent( "trig_forest_drones_2", "script_noteworthy" );
	trig notify( "trigger" );
	
	extra_text( "forest_drones_2" );
	
}



///////////////////
//
// Spawn in the forest tanks on the ridge
//
///////////////////////////////

forest_tanks()
{

	maps\_vehicle::create_vehicle_from_spawngroup_and_gopath( 31 );	

	wait( 0.05 );

	level thread forest_tank_1_strat();
	level thread forest_tank_2_strat();

}



///////////////////
//
// Forest tank's strategy
//
///////////////////////////////

forest_tank_1_strat()
{

	tank = getent( "forest_tank", "targetname" );
	
	//tank RemoveVehicleFromCompass();
	
	tank veh_stop_at_node( "forest_tank_1_stop", 6, 6 );

	level notify( "end_forest_drones" );

	wait( 1.5 );
	
	tank resumespeed( 6 );
	
}



///////////////////
//
// Forest tank's strategy
//
///////////////////////////////

forest_tank_2_strat()
{

	tank = getent( "forest_tank_2", "targetname" );

	//tank RemoveVehicleFromCompass();

	tank veh_stop_at_node( "forest_tank_2_stop", 6, 6 );

	wait( 5 );
	
	tank resumespeed( 6 );
	
}



///////////////////
//
// birds that fly out of bushes
//
///////////////////////////////

forest_birds()
{

	//bird_orig = getstruct( "orig_forest_birds", "targetname" );
	bird_orig = (1632, -5736, -76 );
	playfx( level._effect["birds_fly"], bird_orig );

	wait( 0.6 );

	//bird_orig = getstruct( "orig_forest_birds_2", "targetname" );
	bird_orig = (2117, -6083, -76 );
	playfx( level._effect["birds_fly"], bird_orig );
	
}



///////////////////
//
// Bombers that precede the squadron that gets shot down
//
///////////////////////////////

forest_ambient_bombers()
{

	wait( 0.3 ); // CLIENTSIDE to help snapshot size

	plane_1 = maps\_vehicle::spawn_vehicle_from_targetname_and_drive( "forest_plane_4" );
	plane_2 = maps\_vehicle::spawn_vehicle_from_targetname_and_drive( "forest_plane_5" );
	plane_3 = maps\_vehicle::spawn_vehicle_from_targetname_and_drive( "forest_plane_6" );

	plane_1 playloopsound( "bombers" );
	plane_2 playloopsound( "bombers" );
	plane_3 playloopsound( "bombers" );

	level thread forest_ambient_aa();
	level thread ambient_high_bombers();

}



forest_ambient_aa()
{
	
	aa_gun = maps\_vehicle::spawn_vehicle_from_targetname( "aaGun_forest_1" );
	aa_gun_2 = maps\_vehicle::spawn_vehicle_from_targetname( "aaGun_forest_2" );
	aa_gun_3 = maps\_vehicle::spawn_vehicle_from_targetname( "aaGun_forest_3" );

	aa_gun thread maps\pel2_airfield::aa_move_target( "aaGun_forest_1_target" );
	wait( randomfloatrange( 0.5, 1.5 ) );
	aa_gun_2 thread maps\pel2_airfield::aa_move_target( "aaGun_forest_2_target" );
	wait( randomfloatrange( 0.5, 1.5  ) );
	aa_gun_3 thread maps\pel2_airfield::aa_move_target( "aaGun_forest_3_target" );
	
	
	flag_wait( "admin_back" );
	
	// delete aa guns
	aa_gun notify("change target");
	wait( 0.05 );
	aa_gun delete();
	
	aa_gun_2 notify("change target");
	wait( 0.05 );
	aa_gun_2 delete();
	
	aa_gun_3 notify("change target");
	wait( 0.05 );
	aa_gun_3 delete();		
	
}



///////////////////
//
// Enemies that are setting up a roadblock near between forest and admin building
//
///////////////////////////////

forest_mid()
{
	
	// flag is set on trigger...
	flag_wait( "trig_forest_mid" );	

	level thread ambush_squad_walk_to_chain();
	set_color_chain( "chain_forest_banzai" );

	// clean up old ai
	level thread forest_ai_cleanup();

	level thread admin_ai_pen();

	// flag is set on trigger...
	flag_wait( "trig_forest_end" );	

	level notify( "end_forest_drones_2" );

	battlechatter_on();

	players_speed_set( 1.0, 2.5 );

	array_thread( level.heroes, ::set_pacifist_off );

	level thread admin_truck_victim();
	wait_network_frame();
	level thread collectible_corpse();
	
	// prepare for building battle
	building_battle();

}



admin_truck_victim()
{

	guy = simple_spawn_single( "admin_truck_victim" );
	
	// he's not set to forcespawn, so his spawn could fail
	if( !isdefined( guy ) )
	{
		return;
	}
	
	guy.ignoreme = true;
	guy.animname = "stand";
	//guy.deathanim = level.scr_anim["stand"]["explode_back13"];
	guy.deathanim = level.scr_anim["stand"]["explode_stand_2"];
	
	flag_wait( "admin_truck_exploded" );
	
	guy dodamage( guy.health + 1, (0,0,0) );
	
}



///////////////////
//
// Have guys walk to their chain nodes right before the ambush happens.
//
///////////////////////////////

ambush_squad_walk_to_chain()
{

	allies = getaiarray( "allies" );
	for( i  = 0; i < allies.size; i++ )
	{
		allies[i].old_walkdist = allies[i].walkdist;
		allies[i].walkdist = 10000;
		allies[i].disableArrivals = true;
		allies[i].disableExits = true;		
	}
	
	flag_wait( "grass_admin_surprise" );
	
	wait( 1.2 );
	
	allies = getaiarray( "allies" );
	for( i  = 0; i < allies.size; i++ )
	{
		allies[i].walkdist = allies[i].old_walkdist;
		allies[i].disableArrivals = false;
		allies[i].disableExits = false;			
	}	
	
}



forest_ai_cleanup()
{

	quick_text( "kill all ai", 3, true );
	kill_all_ai();	

	// take off their "friendly_squad" targetnames so kill_all_ai will kill them later on
	forest_friendlies = get_ai_group_ai( "e3_extra_ai" );
	for( i  = 0; i < forest_friendlies.size; i++ )
	{
		forest_friendlies[i].targetname = "forest_friendly";	
	}
	
	// take care of "fake dead" flamer
	if( isdefined ( level.flamer ) && level.flamer.health )
	{
	
		level notify( "stop_flamer_fake_death" );
		
		level.flamer notify( "stop_flamebunker_death_loop" );

		level.flamer setcandamage( true );
		level.flamer stop_magic_bullet_shield();
		level.flamer dodamage( level.flamer.health + 1, (0,0,0) );		
		
	}
	
	
	
	
}



///////////////////
//
// Handles battle in/around large building
//
///////////////////////////////

building_battle()
{

	flag_wait( "trig_ditch_guys" );

	autosave_by_name( "Pel2 admin begin" );
	
	maps\_debug::set_event_printname( "Admin Building" );

	event_text( "ditch_guys" );

	level notify ( "obj_forest_complete" );
	
	// make heroes not damageable
	for( i  = 0; i < level.heroes.size; i++ )
	{
		level.heroes[i] setcandamage( false );
		level.heroes[i] disable_ai_color();
	}

	level thread admin_heroes_initial_cover();
	level thread spawn_admin_pickup_weapons();
	
	set_color_chain( "color_admin_start" );

	building_mgs();

	e3_extras_break_off_chain();

	wait_network_frame();

	level.ditch_spawner_a = simple_spawn_single( "ditch_spawner_a", ::ditch_spawner_a_strat );
	level.ditch_spawner_b = simple_spawn_single( "ditch_spawner_b", ::ditch_spawner_b_strat );
	simple_spawn_single( "ditch_spawner_c", ::helmet_guy_strat );
	
	wait_network_frame();
	
	simple_spawn_single( "admin_bazooka", ::admin_bazooka_strat );
	simple_spawn( "friend_admin_spawner" );

	level thread building_battle_vo();
	level thread admin_script_exploders();
	level thread flame_guy_explode();
	level thread bunker_last_spawners();
	level thread building_axis_check();
	level thread rifle_grenade_respawn();
	
	// Wii optimizations
	if( !level.wii )
	{
		level thread admin_extra_middle_spawner();
	}

	ambush_guys_restore_targetnames();

	wait( 1.25 );

	simple_floodspawn( "admin_mid_left_spawners" );

}



///////////////////
//
// took this spawner off a dedicated trigger_radius spawn_trig and piggybacked it here to save an ent
//
///////////////////////////////

admin_extra_middle_spawner()
{
	
	trigger_wait( "trig_admin_extra_middle_spawner", "script_noteworthy" );
	
	wait( 1.25 );
	
	simple_spawn_single( "admin_extra_middle_spawner" );
	
}



///////////////////
//
// reset their targetnames (earlier were set to "dont_kill_me" so kill_all_ai() would work
//
///////////////////////////////

ambush_guys_restore_targetnames()
{
	
	guys = get_ai_group_ai( "grass_admin_camo_ai" );
	tree_guy =  get_ai_group_ai( "tree_guy" );
	guys = array_combine( guys, tree_guy );	
	
	for( i  = 0; i < guys.size; i++ )
	{
		guys[i].targetname = "dune_ambush_guy";
	}	
	
}



building_battle_vo()
{

	//TUEY set custom bus to ADMIN
	setbusstate("ADMIN");

	play_vo( level.roebuck, "vo", "holed_up" );	
	
	// flag set on trigger
	flag_wait( "helmet_shot_vignette" );


	level thread battlechatter_off( "allies" );
	play_vo( level.roebuck, "vo", "whats_the_skinny" );	
	
	wait( getanimlength( level.scr_anim["berm"]["berm_guy_2"] ) - 2.35 );
	
	play_vo( level.roebuck, "vo", "roebuck_yeah" );	
	wait( 1.25 );
	play_vo( level.roebuck, "vo", "supply_truck" );	
	wait( 2.0 );
	play_vo( level.roebuck, "vo", "follow_me" );	
	wait( 1.75 );
	battlechatter_on( "allies" );

	//TUEY set custom bus to ADMIN
	setbusstate("RESET");
	
	level thread building_battle_vo_2();
	
	// flag wait for going into building...
	flag_wait( "trig_bunker_last_spawners" );
	
	level thread battlechatter_off( "allies" );
	play_vo( level.roebuck, "vo", "move_into_building" );
	wait( 2 );
	play_vo( level.roebuck, "vo", "dont_give_em" );	

	wait( 1.25 );

	play_vo( level.roebuck, "vo", "clear_em" );	
	battlechatter_on( "allies" );

	// when going up the stairs...
	flag_wait( "friendly_chain_admin_last" );


	level thread battlechatter_off( "allies" );
	play_vo( level.roebuck, "vo", "nearly_there" );	
	wait( 1.8 );
	play_vo( level.roebuck, "vo", "one_last_push" );	
	battlechatter_on( "allies" );
	
}



building_battle_vo_2()
{

	// flag set on trigger
	flag_wait( "near_rifle_gren_box" );

	level endon( "trig_bunker_last_spawners" );

	battlechatter_off( "allies" );

	play_vo( level.roebuck, "vo", "load_up_rifle_gren" );	
	wait( 2 );
	play_vo( level.roebuck, "vo", "hell_yeah" );		
	
	battlechatter_on( "allies" );
	
}



///////////////////
//
// Have heroes take some special cover, then eventually get back on color chain
//
///////////////////////////////

admin_heroes_initial_cover()
{

	nodes = getnodearray( "node_heroes_admin_initial", "targetname" );
	assertex( nodes.size >= level.heroes.size, "not enough goal_nodes for admin initial heroes" );	

	for( i  = 0; i < level.heroes.size; i++ )
	{
		level.heroes[i]	thread admin_heroes_initial_cover_think( nodes[i] );
	}
	
	trigger_wait( "chain_heroes_admin_initial", "targetname" );
	
	
	level notify( "end_admin_heroes_initial_cover_think" );
	
	// put the heroes back on the chain
	for( i  = 0; i < level.heroes.size; i++ )
	{
		level.heroes[i] enable_ai_color();
	}	
	
}



///////////////////
//
// make them wait using script_delay like they normally would if the next chain weren't custom scripted
//
///////////////////////////////

admin_heroes_initial_cover_think( new_node )
{
	
	level endon( "end_admin_heroes_initial_cover_think" );
	
	if( isdefined( self.node ) && isdefined( self.node.script_delay ) )
	{
		wait( self.node.script_delay );
	}
	
	self setgoalnode( new_node );
	
}






admin_script_exploders()
{

	level thread wall_explode_damage( "exploder_400" );
	//level thread wall_explode_damage( "exploder_401" );
	level thread wall_explode_damage( "exploder_405" );

	level thread mg_sandbags_explode();
	level thread mg_sandbags_explode_2();
	
}



wall_explode_damage( trig_name )
{

	level endon( "friendly_chain_admin_last" );

	trigger_wait( trig_name, "targetname" );
	
	orig = getstruct( "orig_" + trig_name, "targetname" );
	
	radiusdamage( orig.origin, 120, 130, 80 );
	
}



///////////////////
//
// Exploder stuff for admin center sandbag mg
//
///////////////////////////////

mg_sandbags_explode()
{
	
	trig = getent( "trig_admin_sandbag_explode", "targetname" );
	
	total_damage = 0;
	
	while( 1 )
	{
		
		trig waittill( "damage", damage, attacker, direction_vec, point, cause );

		// if the attacker is a player
		if( isplayer( attacker ) && damage > 220 )
		{
			
			total_damage += damage;
		
			//quick_text( "sandbag dmg: " + damage + "  total: " + total_damage, 4, true );		
		
			// set off the exploder chunks
			exploder( 404 );
			
			// delete bipod
			brush = getent( "admin_sandbag_bipod", "targetname" );
			brush delete();
			
			// delete mg & kill its owner
			mg_sandbag_cleanup( "admin_mg_l", 205 );
			
			break;
				
		}

		wait( 0.05 );

	}

	trig delete();
	
}



///////////////////
//
// Exploder stuff for admin right sandbag mg
//
///////////////////////////////

mg_sandbags_explode_2()
{
	
	trig = getent( "trig_admin_sandbag_explode_2", "targetname" );
	
	total_damage = 0;
	
	while( 1 )
	{
		
		trig waittill( "damage", damage, attacker, direction_vec, point, cause );

		// if the attacker is a player
		if( isplayer( attacker ) && damage > 220 )
		{
			
			total_damage += damage;
		
			//quick_text( "sandbag dmg: " + damage + "  total: " + total_damage, 4, true );		
		
			// set off the exploder chunks
			exploder( 406 );
			
			// delete bipod
			brush = getent( "admin_sandbag_bipod_2", "targetname" );
			brush delete();
			
			// delete mg & kill its owner
			mg_sandbag_cleanup( "admin_mg_r", 206 );
			
			break;
				
		}

		wait( 0.05 );

	}

	trig delete();
	
}



mg_killspawners()
{

	trigger_wait( "admin_mg_killspawner", "targetname" );
	
	maps\_spawner::kill_spawnernum( 205 );
	maps\_spawner::kill_spawnernum( 206 );
	
}



///////////////////
//
// bazooka guy at berm that fires up at the admin building
//
///////////////////////////////

admin_bazooka_strat()
{
	
	self endon( "death" );
	
	self.ignoreme = true;
	self setcandamage( false );
	self.pacifist = true;
	self.pacifistwait = 0.05;
	self.ignoresuppression = true;
	self.suppressionwait = 0;
	self.grenadeawareness = 0;
	
	self set_force_cover( "none" );
	
	// flag set on trigger
	flag_wait( "helmet_shot_vignette" );
	
	orig_1 = getstruct( "orig_admin_bazooka_1", "targetname" );
	orig_ent_1 = spawn( "script_origin", orig_1.origin );
	orig_ent_1.health = 1000000; // so cover_behavior.gsc is happy
	orig_2 = getstruct( "orig_admin_bazooka_2", "targetname" );
	orig_ent_2 = spawn( "script_origin", orig_2.origin );
	orig_ent_2.health = 1000000; // so cover_behavior.gsc is happy
	
	origins = [];
	origins[0] = orig_ent_1;
	origins[1] = orig_ent_2;
	
	orig_index = 0;
	
	self SetEntityTarget( origins[orig_index] );
	
	// give more rockets than default
	self.a.rockets = 7;
	
	starting_rockets = self.a.rockets;

	while( 1 && !flag( "admin_back" ) && !flag( "berm_climb" ) )
	{
		
		// a rocket has been fired
		if( starting_rockets != self.a.rockets )
		{
			
			self ClearEntityTarget();
			
			wait( RandomIntRange( 6, 9 ) );
			
			level thread bazooka_lookat_touching();
			
			trig = getent( "trig_bazooka_lookat", "targetname" );
			trig waittill( "trigger" );
			
			// if event is over, don't fire on building
			if( flag( "top_floor_retreat" ) )
			{
				break;	
			}
			
			orig_index = !orig_index;
			self SetEntityTarget( origins[orig_index] );
			starting_rockets = self.a.rockets;
			
		}
		
		if( !self.a.rockets )
		{
			break;
		}
		
		wait( 0.5 );	
		
	}
	
	self setcandamage( true );
	
	self ClearEntityTarget();
	
	orig_ent_1 delete();
	orig_ent_2 delete();
	
}



bazooka_lookat_touching()
{

	level endon( "friendly_chain_admin_last" );

	trig = getent( "trig_bazooka_lookat", "targetname" );
	
	wait( 0.05 );
	
	while( 1 )
	{
	
		if( any_player_IsTouching( trig ) )
		{
			quick_text( "inside bazooka lookat", 3, true );
			trig notify( "trigger" );
			break;
		}
	
		wait( 0.25 );
		
	}
	
}



///////////////////
//
// behavior for admin mgs
//
///////////////////////////////

building_mgs()
{
	
	// so guys don't hop off
	turret = getent( "admin_mg_r", "targetname" );
	turret setturretignoregoals( true );
	
	turret setTurretTeam( "axis" );
	turret SetMode( "auto_nonai" );
	turret thread maps\_mgturret::burst_fire_unmanned();	

	turret thread mg_fire_at_truck();
	level thread building_mg_attack_player_in_open();

	turret = getent( "admin_mg_l", "targetname" );
	turret setturretignoregoals( true );
	
}



building_mg_attack_player_in_open()
{

	level endon( "trig_bunker_last_spawners" );

	flag_wait( "admin_mg_done" );
	
	vol = getent( "vol_admin_attack_player", "targetname" );
	player_being_targeted = false;
	
//	old_bias_number = undefined;
	
	while( 1 )
	{
	
		player_touching = get_player_touching( vol );
	
		turret = getent( "admin_mg_r", "targetname" );
		// turret may have been destroyed by rifle grenade
		if( !isdefined( turret ) )
		{
			break;	
		}
	
		// if a player is in the volume
		if( isdefined( player_touching ) )
		{
	
			mg_owner = turret getturretowner();
			
			// if there is a guy on the turret
			if( isdefined( mg_owner ) )
			{
				
				// turning this off; threat bias on the guy doesn't seem to do anything if he's on an auto_ai turret
				// have admin_mg_left_threat_group pay more attention to players
//				old_bias_number = GetThreatBias( "players", "admin_mg_left_threat_group" );
//				setthreatbias( "players", "admin_mg_left_threat_group", 30000 );
//				setthreatbias( "heroes", "admin_mg_left_threat_group", 0 );

//				mg_owner.pacifist = true;
				turret SetTargetEntity( player_touching );
				
				player_being_targeted = true;
				
			}	
	
		}
		// if he was being targeted, but left the volume, put the threat back to its original value 
		else if( !isdefined( player_touching ) && player_being_targeted )
		{

//			setthreatbias( "players", "admin_mg_left_threat_group", old_bias_number );
//			mg_owner = turret getturretowner();
//			if( isdefined( mg_owner ) )
//			{
//				mg_owner.pacifist = false;
//			}
			
			turret cleartargetentity();
			player_being_targeted = false;
		}
		
		
		if( player_being_targeted )
		{
			wait( 3 );	
		}
		else
		{
			wait( 1 );	
		}
	
	}

}



mg_fire_at_truck()
{

	orig = getent( "admin_truck_target", "targetname" );
	level thread flame_move_target( orig, 4 );	
	
	quick_text( "mg on orig", 3, true );
	
	self SetTargetEntity( orig );
	
	wait( 3 );
	
	level thread truck_blocker_explode( self );
	
	wait( 10 );
	
	quick_text( "mg done", 3, true );
	
	self cleartargetentity();
	wait( 2 );
	self SetMode( "auto_ai" );
	//self notify( "death" );
	
	flag_set( "admin_mg_done" );
	
}



truck_blocker_explode( turret )
{

	truck = getent( "admin_truck", "script_noteworthy" );

	while( !truck.exploded )
	{
		wait( 0.05 );	
	}
	
	earthquake( 0.3, 1.25, truck.origin , 1300 );	
	
	flag_set( "admin_truck_exploded" );
	
}



flame_guy_explode()
{

	flamer = simple_spawn_single( "admin_flamer_guy" );
	
	flamer.targetname = "friendly_squad";
	flamer.goalradius = 30;
	flamer.pacifist = true;
	flamer.pacifistwait = 0.05;
	flamer.ignoreme = true;
	//flamer.ignoresuppression = true;
	flamer.dropweapon = false;
	flamer setcandamage( false );
	flamer thread magic_bullet_shield();

	goal = getnode( "node_berm_flame_cover_2", "targetname" );
	
	flamer setgoalnode( goal );
	flamer waittill( "goal" );	
	
	BadPlacesEnable( 0 );
	
	flamer thread flamer_fire_towards_building();
	
	// waittill player moves forward enough
	trigger_wait( "trig_flamer_explode_ready", "targetname" );

	level thread trig_override( "trig_flamer_explode_lookat" );
	// wait for player to look in the flamer guy's direction
	trigger_wait( "trig_flamer_explode_lookat", "targetname" );

	quick_text( "flamer death", 3.5, true );
	
	level notify( "stop_flamer_target_building" );
	flamer ClearEntityTarget();
	flamer StopShoot();
	
	// play initial tank explosion
	playfx( level._effect["flamer_explosion"], flamer.origin );	
	playsoundatposition ("flame_pre_explosion", flamer.origin);
	
	// fire that spawns on the guy & charring behavior
	flamer thread animscripts\death::flame_death_fx();
	
	flamer.animname = "berm";
	level thread anim_single_solo( flamer, "flamer_death", undefined, flamer );	
	
  	wait( 2.5 );
  	
  	// play second tank explosion
	playfx( level._effect["flamer_explosion"], flamer.origin );	
	earthquake( 0.5, 1.0, flamer.origin, 1700 );
	PlayRumbleOnPosition( "explosion_generic", flamer.origin ); 		
		
	playsoundatposition ("flame_explosion", flamer.origin);
	flamer stop_magic_bullet_shield();
	flamer setcandamage( true );  	
	flamer.allowdeath = 1;
  	
  	// so he always gibs
  	flamer.a.gib_ref = "right_leg";
	flamer.deathanim = level.scr_anim["berm"]["flamer_death_2"];
	flamer dodamage( flamer.health + 50, (0,0,0) );	
	
	BadPlacesEnable( 1 );
	
	// delete aim origin that the flamer was targeting
	aim_origin = getent( "orig_flamer_target_admin_converted", "targetname" );
	aim_origin delete();

}



flamer_fire_towards_building()
{

	self.ignoresuppression = 1;

	fire_spot = convert_aiming_struct_to_origin( "orig_flamer_target_admin" );
	self thread flame_burst_admin( fire_spot, "stop_flamer_target_building" );
	
}



flame_burst_admin( fire_spot, flag_notify )
{
	
	level endon( flag_notify );
	
	while( 1 )
	{
			
		self SetEntityTarget( fire_spot );
		wait( RandomFloatRange( 3.5, 4.5 ) );
		self ClearEntityTarget();
		self StopShoot();
		wait( RandomFloatRange( 1.2, 1.9 ) );
		
	}

}



///////////////////
//
// if building is cleared out, have berm guys climb over and advance
//
///////////////////////////////

building_axis_check()
{
	
	level endon( "trig_bunker_last_spawners" );
	
	while( 1 )
	{

		wait( 1 );	
		
		// if building is mostly cleared out, have berm guys climb over and advance
		if ( axis_in_building() < 3 && get_ai_group_ai( "admin_mg_ai" ).size == 0 )
		{
			// check this just in case
			if( !flag( "berm_climb" ) )
			{
				level thread berm_ai_climb();	
			}
			
			return;
			
		}
		
	}
	
}



///////////////////
//
// Returns the number of alive axis is touching the trigger volume
//
///////////////////////////////

axis_in_building()
{
	
	trig = getent( "trig_admin_building_volume", "targetname" );
	guys = getaiarray( "axis" );
	
	axis_count = 0;
	
	for( i  = 0; i < guys.size; i++ )
	{
		// if there is an axis alive inside the trigger
		if( guys[i] istouching( trig ) )
		{
			axis_count++;
		}
	}
	
	
	return axis_count;
	
}



///////////////////
//
// Remove extra dudes from color chain and send them behind berm
//
///////////////////////////////

e3_extras_break_off_chain()
{

	guys = get_ai_group_ai( "e3_extra_ai" );
	nodes = getnodearray( "node_berm_extra", "targetname" );
	assertex( nodes.size >= guys.size, "not enough goal_nodes for e3_extras" );
	
	for( i  = 0; i < guys.size; i++ )
	{
		guys[i] thread e3_extras_break_off_strat( nodes[i] );
	}

	level thread e3_extras_break_off_strat_2();
	
}



e3_extras_break_off_strat( goal_node )
{

	self endon( "death" );

	// emulate script_wait behavior that automatically works on color chains
	if( isdefined( self.node ) && isdefined( self.node.script_delay ) )
	{
		wait( self.node.script_delay );
	}	
	
	self disable_ai_color();
	
	// this flag will probably never be hit before the above node wait, but check just in case so their goalnode behavior doesn't get messed up
	if( !flag( "friendly_chain_admin_3" ) )
	{
		self.ignoreme = true;
		self setgoalnode( goal_node );
		
		self waittill( "goal" );
		
		self.ignoreme = false;
	}
	
}



///////////////////
//
// send them back up to the berm once player is far enough into the event
//
///////////////////////////////

e3_extras_break_off_strat_2()
{

	flag_wait( "friendly_chain_admin_3" );
	
	guys = get_ai_group_ai( "e3_extra_ai" );
	nodes = getnodearray( "node_berm_extra_2", "script_noteworthy" );
	assertex( nodes.size >= guys.size, "not enough goal_nodes for e3_extras" );
	
	for( i  = 0; i < guys.size; i++ )
	{
		guys[i] setgoalnode( nodes[i] );
	}	
	
}



///////////////////
//
// Cluster color reinforcements before letting them join the battle
//
///////////////////////////////

admin_ai_pen()
{

	level endon( "friendly_chain_admin_last" );
	
	trigger_wait( "trigger_admin_wave", "script_noteworthy" );
	
	flag_set( "trig_ditch_guys" );
	
	trig_pen = getent( "trig_admin_ai_pen", "targetname" );
	pen_brush = getent( "blocker_admin_ai", "targetname" );
	
	while( 1 )
	{
	
		// get alive color spawners
		guys = get_specific_ai( "friend_admin_ai" );
		guys_to_send_out = [];
		
		for( i  = 0; i < guys.size; i++ )
		{
			
			// check if they're touching the trig
			if( guys[i] istouching( trig_pen ) )
			{

				guys_to_send_out[guys_to_send_out.size] = guys[i];
				
				// if enough guys are touching
				if( guys_to_send_out.size >= 2 )
				{

					// turn off brush so they can get out
					pen_brush notsolid();
					pen_brush connectpaths();
					
					array_thread( guys_to_send_out, ::admin_ai_pen_strat );
					
					wait( 4.5 );
					
					// turn its collision back on
					pen_brush solid();
					pen_brush disconnectpaths();
					break;
				}
				
			}
		}
		
		wait( 1 );
		
	}
	
	
}



///////////////////
//
// Strategy for admin color reinforcements
//
///////////////////////////////

admin_ai_pen_strat()
{
	
	self endon( "death" );
	
	// don't let him die without a color set, otherwise no one will spawn in to take his place...
	self setcandamage( false );
	
	// force him to run out, even if no color chain nodes are open
	self disable_ai_color();
	self setgoalpos( ( 1706, -2424, -115.2 ) );

	self.ignoresuppression = 1;
	self.ignoreme = 1;
	
	wait( 3.5 );
	
	// put him back on the color chain
	self enable_ai_color();
	self.ignoresuppression = 0;

	// wait till he gets to better cover, so mgs don't tear him up right away
	wait( 3 );
	self.ignoreme = 0;
	self setcandamage( true );
	
}



///////////////////
//
// Berm guy A
//
///////////////////////////////

ditch_spawner_a_strat()
{

	self thread magic_bullet_shield();
	
	self.goalradius = 200;
	self.ignoreme = 1;
	self.animname = "berm";
	
	goal_node = getnode( "node_berm_a", "targetname" );
	
	self thread anim_loop_solo( self, "berm_guy_1_idle", undefined, "stop_berm_idle", goal_node );	
	
	// flag set on trigger
	flag_wait( "helmet_shot_vignette" );
	
	// so roebuck's VO can have a chance to play first
	wait( 0.4 );
	
	self notify( "stop_berm_idle" );
	
	anim_single_solo( self, "berm_guy_1", undefined, goal_node );	
	
	self stop_magic_bullet_shield();	
	
}



///////////////////
//
// Berm guy B
//
///////////////////////////////

ditch_spawner_b_strat()
{

	self thread magic_bullet_shield();
	
	self.goalradius = 200;
	self.ignoreme = 1;
	self.animname = "berm";
	
	goal_node = getnode( "node_berm_a", "targetname" );
	
	self thread anim_loop_solo( self, "berm_guy_2_idle", undefined, "stop_berm_idle", goal_node );	
	
	// flag set on trigger
	flag_wait( "helmet_shot_vignette" );
	
	// so roebuck's VO can have a chance to play first
	wait( 0.4 );
	
	self notify( "stop_berm_idle" );
	
	anim_single_solo( self, "berm_guy_2", undefined, goal_node );	
	
	self stop_magic_bullet_shield();	
	
}



///////////////////
//
// Helmet shot guy behavior
//
///////////////////////////////

helmet_guy_strat()
{

	self endon( "death" );
	
	self.goalradius = 200;
	self.ignoreme = 1;
	self.animname = "berm";
	
	goal_node = getnode( "node_berm_c", "targetname" );

	self thread helmet_vignette_trig();

	self thread anim_loop_solo( self, "helmet_loop", undefined, "stop_helmet_loop", goal_node );	
	
	// flag set on trigger
	flag_wait( "helmet_shot_vignette" );
	
	self notify( "stop_helmet_loop" );
	
	quick_text( "helmet shot", 3.5, true );
	
	self allowedstances( "crouch" );
	
	anim_single_solo( self, "helmet_shot", undefined, goal_node );	

	level notify( "helmet_shot_done" );

	self.allowdeath = 1;

	level thread anim_loop_solo( self, "helmet_loop", undefined, "stop_berm_idle", goal_node );	
	
}



///////////////////
//
// When to trigger the helmet shot anim
//
///////////////////////////////

helmet_vignette_trig()
{

	// flag set on trigger
	flag_wait( "helmet_shot_vignette" );
	self allowedstances( "prone", "crouch", "stand" );
	
}



///////////////////
//
// Spawners near back room on first floor
//
///////////////////////////////

bunker_last_spawners()
{

	// flag set on trigger
	flag_wait( "trig_bunker_last_spawners" );

	quick_text( "bunker_last_spawners", 2, true );

	autosave_by_name( "pel2 admin last spawners" );

	level notify( "stop_admin_mgs" );

	// make heroes damageable
	for( i  = 0; i < level.heroes.size; i++ )
	{
		level.heroes[i] setcandamage( true );
	}

	simple_spawn( "bunker_last_spawners" );
	wait_network_frame();
	simple_spawn_single( "friend_admin_spawner_2" );
	wait_network_frame(); // CLIENTSIDE to help snapshot size
	simple_spawn( "admin_2nd_floor_extra_spawners" );

	level thread bunker_last_ai_monitor();
	level thread admin_back();
	level thread far_right_ai_retreat();
	level thread top_floor_retreat();
	level thread maps\pel2_airfield::airfield_vo();
	
	if( !flag( "berm_climb" ) )
	{
		level thread berm_ai_climb();
	}
	
	// delete old friendly chains
	delete_noteworthy_ents( "friendly_chain_admin_2" );	

	flag_wait_either( "top_floor_retreat", "bunker_last_ai_dead" );

	flag_set( "friendly_chain_admin_last" );
	quick_text( "friendly_chain_admin_last", 1.5, true );

	// killspawn for mg spawners if the mgs weren't blown up by the rifle grenade
	maps\_spawner::kill_spawnernum( 205 );
	maps\_spawner::kill_spawnernum( 206 );

	level thread guys_ascend_admin_stairs();
	
	//Tuey Change Music State
	setmusicstate("POST_ADMIN");	

	// remove pen brush; all guys should be allowed to advance now no matter what
	pen_brush = getent( "blocker_admin_ai", "targetname" );
	pen_brush notsolid();
	pen_brush connectpaths();	

	// delete old friendly chains
	delete_noteworthy_ents( "friendly_chain_admin_3" );

	airfield_first_read();
	
}



///////////////////
//
// handles getting the squad up the stairs smoothly
//
///////////////////////////////

guys_ascend_admin_stairs()
{
	
	// stop reinforcements for now
//	trig = getent( "friendly_respawn_clear_admin", "script_noteworthy" );
//	trig notify( "trigger" );

	level thread admin_staircase_run_cycle();

	// move guys upstairs
	set_color_chain( "friendly_chain_admin_last" );	
	
	nodes = getnodearray( "nodes_admin_first_floor", "targetname" );
	allies = getaiarray( "allies" );
	green_allies = [];
	
	for( i  = 0; i < allies.size; i++ )
	{
		if( isdefined( allies[i].script_forcecolor ) && allies[i].script_forcecolor == "g" )
		{
			green_allies = add_to_array( green_allies, allies[i] );
		}
	}
	
	
	assertex( nodes.size >= green_allies.size, "more guys than admin nodes!" );
	
	for( i  = 0; i < green_allies.size; i++ )
	{
		green_allies[i].goalradius = 20;
		green_allies[i] disable_ai_color();
		green_allies[i] setgoalnode( nodes[i] );
		green_allies[i] thread staircase_wait_thread();
	}
	
	
	// player entered room with staircase
	flag_wait( "trig_admin_near_staircase" );
	
	set_color_chain( "friendly_chain_admin_last" );
	
	for( i  = 0; i < green_allies.size; i++ )
	{
		if( isdefined( green_allies[i] ) && isalive( green_allies[i] ) )
		{
			green_allies[i] thread staircase_dont_bunch_up();
		}
	}	
	
}



///////////////////
//
// determines when to put the guys back on the color chain, which will make them run up the stairs.
//
///////////////////////////////

staircase_dont_bunch_up()
{

	self endon( "death" );

//	while( 1 )
	//if this flag is hit, set everyone to run the stairs up regardless of waiting
	while( !flag( "move_wave_2_1" ) )
	{
		
		// make sure he's made it to his first floor goal, and that no one else is heading towards the stairs
		if( isdefined( self.pel2_staircase_wait ) && !level.guy_going_towards_stairs && no_guys_going_to_stairs_nearby( self ) && vol_near_staircase_clear() )
		{
			break;	
		}
		
		wait( 0.1 );
	}

	self.this_guy_going_towards_stairs = true;
	level.guy_going_towards_stairs = true;
	level thread guy_going_towards_stairs_falsify_delay();
	
	self enable_ai_color();
	
}



///////////////////
//
// help space out how often the guys can go up the staircase by using a mandatory delay
//
///////////////////////////////

guy_going_towards_stairs_falsify_delay()
{

	wait( 1.5 );
	level.guy_going_towards_stairs = false;
	
}



///////////////////
//
// each guy that's waiting to go up the stairs will check if anyone else around him is going before he himself can go
//
///////////////////////////////

no_guys_going_to_stairs_nearby( guy )
{
		
	allies = getaiarray( "allies" );
	green_allies = [];
	
	for( i  = 0; i < allies.size; i++ )
	{
		if( isdefined( allies[i].script_forcecolor ) && allies[i].script_forcecolor == "g" )
		{
			green_allies = add_to_array( green_allies, allies[i] );
		}
	}	
	
	for( i  = 0; i < green_allies.size; i++ )
	{
		
		if( green_allies[i] == guy )
		{
			continue;	
		}
		
		// if a guy is going to the stairs and is close to guy, then return false so guy doesn't attempt to go up the stairs
		if( distancesquared( guy.origin, green_allies[i].origin ) < (190*190) )
		{
			if( isdefined( green_allies[i].this_guy_going_towards_stairs ) && green_allies[i].this_guy_going_towards_stairs )
			{
				return false;	
			}
		}
		
	}
	
	// no one nearby is attempting to run up the stairs
	return true;
	
}


///////////////////
//
// returns true if no one is near the base of the stairs, meaning it's clear to go towards
//
///////////////////////////////

vol_near_staircase_clear()
{
	
	guys = getAIarrayTouchingVolume( "allies", "vol_near_staircase" );
	
	if( guys.size )
	{
		return false;
	}
	else
	{
		return true;
			
	}

}



///////////////////
//
// sets a field once the guy has reached his first floor goal near the staircase
//
///////////////////////////////

staircase_wait_thread()
{

	self endon( "death" );
	
	self waittill( "goal" );
	
	self.pel2_staircase_wait = true;
	
}
	


///////////////////
//
// guys use special run cycle on stairs
//
///////////////////////////////

admin_staircase_run_cycle()
{
	
	trig = getent( "trig_admin_stairs", "targetname" );
	while( 1 )
	{
		
		trig waittill( "trigger", triggerer );
		if( !isdefined( triggerer.pel2_on_stairs ) )
		{
			triggerer thread on_stairs_strat( trig );
			triggerer.pel2_on_stairs = true;
		}
		
	}
	
}



///////////////////
//
// this thread is run on the guy as soon as he hits the stairway trigger
//
///////////////////////////////

on_stairs_strat( trig )
{
	
	self endon( "death" );
	
	self.animname = "stairs";
	self set_run_anim( "run_up_stairs" );
	
	
	while( 1 )
	{
		
		// determine when he's finished traversing the staircase
		if( !(self istouching( trig ) ) )
		{
		
			self clear_run_anim();
			
			self.this_guy_going_towards_stairs = false;
			
			if ( self == level.roebuck )
			{
				level.roebuck set_generic_run_anim( "roebuck_run", true ); 	
			}			
			
			break;
			
		}
		
		wait( 0.05 );
		
	}
	
}



///////////////////
//
// sets a flag when bunker_last_ai aigroup has been killed
//
///////////////////////////////

bunker_last_ai_monitor()
{
	waittill_aigroupcleared( "bunker_last_ai" );
	flag_set( "bunker_last_ai_dead" );
}



///////////////////
//
// Few marines climb over berm and assault admin building head on
//
///////////////////////////////

berm_ai_climb()
{

	flag_set( "berm_climb" );

	quick_text( "jump over berm", undefined, true );
	
	// remove blocker so guys can climb berm
	blocker = getent( "blocker_admin_berm", "targetname" );
	blocker notsolid();
	blocker connectpaths();
	
	helmet_brush = getent( "blocker_admin_helmet", "targetname" );
	helmet_brush notsolid();
	helmet_brush connectpaths();	
	
	nodes = getnodearray( "node_berm_over", "script_noteworthy" );
	guys = get_ai_group_ai( "berm_ai" );
	assertex( nodes.size >= guys.size, "not enough nodes for berm_ai!" );

	temp_goal = ( 2330, -1954, 12.1 );

	for( i  = 0; i < guys.size; i++ )
	{
		guys[i] setgoalpos( temp_goal );
		guys[i] thread berm_ai_climb_helper( nodes[i] );
	}
	
}



berm_ai_climb_helper( goal_node )
{
	self.ignoresuppression = 1;
	self.ignoreall = 1;
	self.goalradius = 50;
	self waittill( "goal" );
	
	self setgoalnode( goal_node );	
	self waittill( "goal" );
	
	self.ignoresuppression = 0;
	self.ignoreall = 0;
	self.goalradius = 400;
}



admin_back()
{
	
	// flag set on trigger
	flag_wait( "trig_admin_back" );
	
	autosave_by_name( "pel2 admin back" );
	
	flag_set( "admin_back" );

	level thread maps\pel2_airfield::airfield_mortars();	
	level thread maps\pel2_airfield::aa_ambient_fire();
	
	wait( 1 );
	
	set_color_chain( "chain_admin_back" );
	
}



///////////////////
//
// Handles the initial read of the airfield
//
///////////////////////////////

airfield_first_read()
{

	// flag set on trigger
	flag_wait( "trig_airfield_first_read" );

	// cleanup ai
	kill_admin_ai();
	
	maps\pel2_airfield::main();
	
}



kill_admin_ai()
{
	
	//axis
	kill_aigroup( "bunker_far_right_ai" );
	kill_aigroup( "admin_left_ai" );
	kill_aigroup( "admin_mid_ai" );
	kill_aigroup( "admin_mid_left_ai" );
	kill_aigroup( "admin_3rd_floor_ai" );
	kill_aigroup( "grass_admin_camo_ai" );
	
	//allies
	kill_aigroup( "e3_extra_ai" );
	kill_aigroup( "berm_ai" );
	
}



///////////////////
//
// Get 2nd floor admin axis to retreat out the back (and get deleted)
//
///////////////////////////////

top_floor_retreat()
{
	
	// flag set on trigger
	flag_wait( "trig_top_floor_retreat" );

	flag_set( "top_floor_retreat" );

	guys = get_ai_group_ai( "admin_mg_ai" );
	guys_2 = get_ai_group_ai( "admin_2nd_floor_ai" );
	guys = array_combine( guys, guys_2 );
	
	for( i = 0; i < guys.size; i++ )
	{
		guys[i] thread top_floor_retreat_strat( i );
	}
	
	// bazooka guy may have been waiting to fire. notify the lookat trig one last time and then delete it
	trig = getent( "trig_bazooka_lookat", "targetname" );
	trig notify( "trigger" );	
	
	wait( 0.05 );
	
	trig delete();
	
	
}



top_floor_retreat_strat( index )
{

	self endon( "death" );
	
	self.goalradius = 30;
// 	self.pacifist = 1;
	self.ignoresuppression = 1;
	self StopUSeturret(); 
	
	if( index%2 )
	{
		goal = getnode( "node_admin_retreat_top_1", "targetname" );	
	}
	else
	{
		goal = getnode( "node_admin_retreat_top_2", "targetname" );
	}
	
	
	self setgoalnode( goal );
	
	self waittill( "goal" );
	
	self delete();
	
}




///////////////////
//
// Guys on the far right retreat back into the admin building when the player is on the far left
//
///////////////////////////////

far_right_ai_retreat()
{

	extra_text( "far_right_ai_retreat" );

	guys = get_ai_group_ai( "bunker_far_right_ai" );
	
	for( i  = 0; i < guys.size; i++ )
	{
		guys[i].goalradius = 300;
		
		goal_pos = ( ( 3000, -1386, 37 ) );
		guys[i] setgoalpos( goal_pos );
		
	}
	
	
}



///////////////////
//
// The plane in the middle of the airfield crashes there at the building of e4
//
///////////////////////////////
#using_animtree ("pel2_truck_crash");
bomber_crash()
{

	// flag set on trigger
	flag_wait( "trig_forest_plane_crash" );

	plane_1 = maps\_vehicle::spawn_vehicle_from_targetname_and_drive( "forest_plane_1" );
	plane_2 = maps\_vehicle::spawn_vehicle_from_targetname_and_drive( "forest_plane_2" );
	// plane that crashes
	wait_network_frame();
	crash_plane = maps\_vehicle::spawn_vehicle_from_targetname_and_drive( "airfield_crash_plane" );
	
	//Tuey - Changed these to loops
	plane_1 playloopsound( "bombers" );
	plane_2 playloopsound( "bombers" );

	//Tuey - Scripted sounds to plane so that it moves with it
	crash_plane playsound("bomber_die_scripted");	
	crash_plane playloopsound( "bombers_bass");
	
	//Tuey - Added shockwave effect to the explosion to get you to turn around.

	level thread maps\pel2_amb::plane_crash_move_shockwave();

	hit_node = getvehiclenode( "forest_plane_hit", "script_noteworthy" );
	hit_node waittill( "trigger" );
	
	level thread bomber_rumble();
	
	PlayFXOnTag( level._effect["bomber_wing_hit"], crash_plane,"tag_wingmidR" );

	rumble_node = getvehiclenode( "forest_crash_rumble", "script_noteworthy" );
	rumble_node waittill( "trigger" );

	bomber_quake( 4.0 );
	level thread forest_birds();

	vnode = getvehiclenode( "node_palm_hit", "script_noteworthy" );
	vnode waittill( "trigger" );
	
	bomber_crash_treefx();
	
	anim_node = getnode( "node_bomber_crash", "targetname" );
	
	rig_model = getent( "bomber_crash_rig_model", "targetname" );
	rig_model UseAnimTree( #animtree );
	rig_model.animname = "forest";
	
	level thread anim_single_solo( rig_model, "bomber_clip_trees", undefined, anim_node );	

	level thread bomber_crash_vo();
	
	crash_plane waittill( "reached_end_node" );	
	
	//TUEY Crash Sound
	crash_plane playsound ("bomber_crash", "sound_done");

	//bomber_quake( 2.0 );

	// smoke/fire fx on crashed plane
	level thread maps\pel2_airfield::airfield_plane_fire();
	
	crash_plane waittill("sound_done");
	crash_plane delete();

}



bomber_rumble()
{

	trig = getent( "trig_bomber_rumble", "targetname" );
	
	players = get_players();
	
	for( i  = 0; i < players.size; i++ )
	{
		if( players[i] istouching( trig ) )
		{
			PlayRumbleOnPosition( "pel2_bomber", players[i].origin ); 
		}
	}
	
}



bomber_crash_treefx()
{

	tree_top_1 = getent( "bomber_crash_treetop_1", "targetname" );
	tree_top_1 delete();
	tree_top_2 = getent( "bomber_crash_treetop_2", "targetname" );
	tree_top_2 delete();
	
	orig_2 = getstruct( "bomber_crash_treetop_fx_2", "targetname" );
	playfx( level._effect["bomber_crash_treetop"], orig_2.origin, anglestoforward( orig_2.angles ) ); 
	
}



bomber_quake( time_to_rumble )
{

	trig = getent( "trig_bomber_rumble", "targetname" );
	
	players = get_players();
	
	// TODO this shouldn't be off of each player
	for( i  = 0; i < players.size; i++ )
	{
		if( players[i] istouching( trig ) )
		{
			earthquake( 0.25, time_to_rumble, players[i].origin, 1500 );
			// Tuey - Added bass sweetner to rumble the room when the plane goes overhead
			playsoundatposition("plane_rumble", (0,0,0));
		}
		
	}
	
}



bomber_crash_vo()
{

	level endon( "grass_admin_surprise" );

	if( !flag( "grass_admin_surprise" ) )
	{
		
		play_vo( level.polonsky, "vo", "bastards_just_took" );
		
		wait( 2.75 );
		
		play_vo( level.roebuck, "vo", "every_plane_we_lose" );
		
		wait( 5 );
		
		play_vo( level.roebuck, "vo", "lets_pick_it_up" );
		
	}
	
	
}



///////////////////
//
// some script models of bombers high up in the sky for ambience
//
///////////////////////////////

ambient_high_bombers()
{

	level endon( "pacing_vignette_started" );

	// two groups, for variation
	origs = getstructarray( "orig_ambient_high_bomber", "targetname" );
	origs_2 = getstructarray( "orig_ambient_high_bomber_2", "targetname" );
	
	just_had_four_bombers = false;
	
	for( j = 0; j < 50; j++ )
	{
	
		if( randomint( 4 ) || just_had_four_bombers )
		{
			for( i  = 0; i < origs.size; i++ )
			{
				level thread ambient_high_bomber_path( origs[i] );
			}
			
			just_had_four_bombers = false;
				
		}
		else
		{
			for( i  = 0; i < origs_2.size; i++ )
			{
				level thread ambient_high_bomber_path( origs_2[i] );
			}	
			
			just_had_four_bombers = true;
			
		}
		
		wait( RandomIntRange( 15, 18 ) );
		
	}
	
}



ambient_high_bomber_path( start_point )
{

	ambient_bomber = spawn( "script_model", start_point.origin );
	ambient_bomber setmodel( "vehicle_usa_aircraft_b17_dist" );
	ambient_bomber.angles = start_point.angles;
	
	target_spot = getstruct( start_point.target, "targetname" );
	
	ambient_bomber moveto( target_spot.origin, 49 );
	
	ambient_bomber waittill( "movedone" );
	
	ambient_bomber delete();
	
}



///////////////////
//
// infinite respawn rifle_grenade for player to use 
//
///////////////////////////////

rifle_grenade_respawn()
{

	level thread players_rifle_gren_pickup();

	respawn_origin = (1676.1, -1352.1, 51.4);
	respawn_rifle_gren = spawn( "weapon_m1garand_gl", respawn_origin, 1 );
	respawn_angles = (0, 276.2, -90);
	respawn_rifle_gren.angles = respawn_angles;		

	// glowy model
	glowy_model = spawn( "script_model", respawn_origin );
	glowy_model.angles = respawn_angles;
	glowy_model SetModel( "weapon_usa_m1garand_rifle_grenade_obj" );

	while( 1 )
	{
	
		if( !isdefined( respawn_rifle_gren ) )
		{
			
			// remove glowy model once the rifle grenade garand is picked up
			if( isdefined( glowy_model ) )
			{
				glowy_model delete();
			}			
			
			respawn_rifle_gren = spawn( "weapon_m1garand_gl", respawn_origin, 1 );
			respawn_rifle_gren.angles = respawn_angles;		
			
			wait( 2 );	
		}	
	
		wait( 1 );
		
	}

}



///////////////////
//
// sets up hud text for rifle grenade pickup
//
///////////////////////////////

players_rifle_gren_pickup()
{

	players = get_players();
	array_thread( players, ::players_rifle_gren_pickup_watch );
	
}



///////////////////
//
// checks for when the player picks up an m7 launcher for the first time
//
///////////////////////////////

players_rifle_gren_pickup_watch()
{
	
	while( 1 )
	{
	
		if( self hasweapon( "m1garand_gl" ) )
		{
			self thread do_rifle_gren_hud_elem();
			break;	
		}
	
		wait( 0.15 );
		
	}
	
}



///////////////////
//
// creates & displays the rifle grenade hud text/hint
//
///////////////////////////////

do_rifle_gren_hud_elem()
{
	
	// the text
	elem_text = newclienthudelem( self );
	
	elem_text.label = &"PEL2_RIFLE_GRENADE_TEXT";
	
	elem_text.x = 260; 
	elem_text.y = 190; 
	elem_text.alpha = 0; 

	elem_text.foreground = true; 

	// fade into white
	elem_text FadeOverTime( 0.2 ); 
	elem_text.alpha = 1; 

	// the icon
	elem = newclienthudelem( self );
	
	elem.x = 288; 
	elem.y = 204; 
	elem.alpha = 0; 

	elem.foreground = true; 
	elem SetShader( "hud_icon_grenade_launcher_dpad", 64, 64 ); 

	// fade into white
	elem FadeOverTime( 0.2 ); 
	elem.alpha = 1; 	
	
	
	wait( 4.5 );
	
	elem_text FadeOverTime( 1.0 ); 
	elem_text.alpha = 0;
	
	
	elem MoveOverTime( 1.5 );
	elem.y = 430;
	elem.x = elem.x + 4;
	elem ScaleOverTime( 1.5, 8, 8 ); 
	
	wait( 1.2 );
	
	elem FadeOverTime( 0.2 ); 
	elem.alpha = 0;
	wait( 0.2 );
	elem destroy();
	elem_text destroy();
	
}



///////////////////
//
// spawn these manually when the event starts, to save on entities at load time
//
///////////////////////////////

spawn_admin_pickup_weapons()
{

	admin_weapons = [];
	
	// rifle grenades near truck
	admin_weapons[0] = spawnstruct();
	admin_weapons[0].weapon_name = "weapon_m1garand_gl";
	admin_weapons[0].origin = (1676.1, -1352.1, 51.4);
	admin_weapons[0].angles = (0, 276.2, -90);

	admin_weapons[1] = spawnstruct();
	admin_weapons[1].weapon_name = "weapon_m1garand_gl";
	admin_weapons[1].origin = (1657, -1337.1, 42.6);
	admin_weapons[1].angles = (299.998, 18.1176, -120.214);
	
	spawn_pickup_weapons( admin_weapons );
	
}



#using_animtree( "generic_human" );
collectible_corpse()
{

	orig = getstruct( "orig_collectible_loop", "targetname" );

	corpse = spawn( "script_model", orig.origin );
	corpse.angles = orig.angles;
	corpse character\char_jap_pel2_rifle::main();
	corpse detach( corpse.gearModel );
	corpse UseAnimTree( #animtree );
	corpse.animname = "collectible";
	corpse.targetname = "collectible_corpse";

	level thread anim_loop_solo( corpse, "collectible_loop", undefined, "stop_collectible_loop", orig );
	
}