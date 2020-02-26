#include maps\_utility;
#include common_scripts\utility;
#include maps\_anim;
#include maps\_vehicle_aianim;

main()
{
	precachemodel( "fastrope_arms" );
	// add the starts before _load because _load handles starts now
	
	default_start( ::ride_start );
	add_start( "ride", ::ride_start );
	add_start( "landed", ::landed_start );
	add_start( "hq2tv", ::hq2tv_start );
	add_start( "intel", ::intel_start );
	add_start( "tv", ::tv_start );
	
	
	precacheturret( "heli_minigun_noai" );
	precachemodel( "weapon_saw_MG_setup" );
	

	maps\_mig29::main( "vehicle_mig29_desert" );


	maps\_breach_explosive_left::main(); 

	maps\_breach::main();
	maps\_technical::main( "vehicle_pickup_technical" );
	//maps\_seaknight::main( "vehicle_ch46e" );
	maps\_blackhawk::main( "vehicle_blackhawk" );
	level.vehicle_aianimthread["snipe"] = maps\armada_anim::guy_snipe;

	
	maps\armada_fx::main();
	maps\_load::main();
	maps\armada_anim::main();
	maps\_claymores_sp::main();
	maps\_compass::setupMiniMap( "compass_map_armada" );
	
	level.mortar_min_dist = 500;
	level thread maps\_mortar::bog_style_mortar();
	level.noMaxMortarDist = true;
	level.scr_sound[ "mortar" ][ "incomming" ]				= "mortar_incoming";
	level.scr_sound[ "mortar" ][ "dirt" ]					= "mortar_explosion_dirt";
	level.scr_sound[ "mortar" ][ "mud" ]					= "mortar_explosion_water";
	level._effect[ "mortar" ][ "dirt" ]						= loadfx( "explosions/grenadeExp_dirt" );
	
//	battlechatter_off( "allies" );
//	battlechatter_off( "axis" );
	
	//setExpFog( 400, 4000, .90625, 0.850225, 0.71311, 0 );
	//setExpFog( 400, 6000, 1, 1, 1, 0 );
	//setCullFog( 0, 10000, .583, .644 , .587, 0 );	
	//setExpFog( 800, 6000, .583, .644 , .587, 0 );
	maps\createart\armada_art::main();
	
	flag_init( "hq_entered" );	
	flag_init( "end_water" );	
	
	array_thread( getvehiclenodearray( "plane_sound", "script_noteworthy" ), maps\_mig29::plane_sound_node );
	
	thread circling_heli_turrets();
	//thread circling_helis_rpg_guy_spawner();
	
	thread hq_breach();
	thread tv_breach();
	thread objectives();
	thread razor_wire();
	thread hq_entered_wait();
	thread HQ_finished();
	thread on_ground();
	thread barbed_wire_dialog();
	thread on_me_to_building();
	thread sit_rep_dialog();
	thread end_of_script();
//	thread enemy_mass();
	thread kill_rooftop_ignore_groups();
	thread tv_station_visionset();
	
	createThreatBiasGroup( "left_rooftop_enemies" ); 
	createThreatBiasGroup( "right_rooftop_enemies" ); 
	createThreatBiasGroup( "players_group" ); 
	level.player setthreatbiasgroup( "players_group" );
	ignoreEachOther( "left_rooftop_enemies", "players_group" );
	ignoreEachOther( "right_rooftop_enemies", "players_group" );
	
	price_spawner = getentarray( "price", "script_noteworthy" );
	array_thread( price_spawner, ::add_spawn_function, ::price_think );
	array_thread( price_spawner, ::add_spawn_function, ::set_threatbias_group, "players_group" );
	
	breacher_spawner = getentarray( "breacher", "script_noteworthy" );
	array_thread( breacher_spawner, ::add_spawn_function, ::breacher_think );
	array_thread( breacher_spawner, ::add_spawn_function, ::set_threatbias_group, "players_group" );
	
	hq_breachers = getentarray( "hq_breachers", "script_noteworthy" );
	array_thread( hq_breachers, ::add_spawn_function, ::hq_breachers_think );
	
	left_rooftop_enemies = getentarray( "left_rooftop_enemies", "script_noteworthy" );
	array_thread( left_rooftop_enemies, ::add_spawn_function, ::set_threatbias_group, "left_rooftop_enemies" );
	
	right_rooftop_enemies = getentarray( "right_rooftop_enemies", "script_noteworthy" );
	array_thread( right_rooftop_enemies, ::add_spawn_function, ::set_threatbias_group, "right_rooftop_enemies" );
	
	
	right_rooftop_enemies_d_trigger = getent( "right_rooftop_enemies_d_trigger", "targetname" );
	right_rooftop_enemies_d_trigger thread player_breaks_ignore( "right_rooftop_enemies" );
	
	left_rooftop_enemies_d_trigger = getent( "left_rooftop_enemies_d_trigger", "targetname" );
	left_rooftop_enemies_d_trigger thread player_breaks_ignore( "left_rooftop_enemies" );
	
	
	magic_grenade_trigger = getentarray( "magic_grenade_trigger", "targetname" );
	array_thread( magic_grenade_trigger, ::magic_grenade_trigger_think );
	
	purple_2_red_triggers = getentarray( "purple_2_red", "targetname" );
	array_thread( purple_2_red_triggers, ::purple_2_red );
	
	reinforcements_triggers = getentarray( "reinforcements_trigger", "targetname" );
	array_thread( reinforcements_triggers, ::reinforcements_think );
	
	thread one_red_to_orange();
	thread refill_red_with_green();
}

tv_station_visionset()
{
	flag_wait( "tvstation_entered" );

	VisionSetNaked( "armada_tvs", 3 );
}

reinforcements_think()
{
	self waittill( "trigger" );
	
	
	guys = get_force_color_guys( "allies", "r" );
	reinforcements_needed =( 5 - guys.size );
	
	if( reinforcements_needed < 2 )
	{
		soldier = get_closest_ai( level.player getOrigin(), "allies" );
		soldier custom_battlechatter( "move_generic" );
		return;
	}
	
	reinforcement_dialog = [];
	reinforcement_dialog[ 0 ] = "armada_reinforcements1"; //"Friendly reinforcements coming up!"
	reinforcement_dialog[ 1 ] = "armada_reinforcements2"; //"Friendlies coming up!"
	reinforcement_dialog[ 2 ] = "armada_reinforcements3"; //"Check your fire! Friendlies at your six!"
	reinforcement_dialog[ 3 ] = "armada_reinforcements4"; //"Heads up! Friendlies on your six!"
	reinforcement_dialog[ 3 ] = "armada_reinforcements5"; //"Watch your fire! Friendlies coming up!"
	
	selection = reinforcement_dialog[ randomint( reinforcement_dialog.size ) ];
	
	soldier = get_closest_ai( level.player getOrigin(), "allies" );
	soldier playsound( selection );
		
	spawners = getentarray( self.target, "targetname" );
	for( i=0;i<reinforcements_needed;i++ )
		guy = spawners[ i ] maps\_spawner::spawn_ai();
}

refill_red_with_green()
{
	refill_red_with_green = getent( "refill_red_with_green", "targetname" );
	refill_red_with_green waittill( "trigger" );
	

	
	greens = get_force_color_guys( "allies", "g" );
	
	if( greens.size > 0 )
	{
		reds = get_force_color_guys( "allies", "r" );
		reinforcements_needed =( 5 - reds.size );
	
		for( i=0;i<reinforcements_needed;i++ )
			greens[ i ] set_force_color( "r" );
	}
	
//	iprintlnbold( "MARINE: We've got the TV Station locked down sir." );
	soldier = get_closest_ai( level.player getOrigin(), "allies" );
	soldier playsound( "armada_tv_locked_down" );
	wait 2;
//	iprintlnbold( "PRICE: Good. Get in position to breach." );
	level.price playsound( "armada_position_to_breach" );
}

purple_2_red()
{
	self waittill( "trigger" );
	
	purples = get_force_color_guys( "allies", "p" );
	array_thread( purples, ::set_force_color, "r" );
}

one_red_to_orange()
{
	one_red_to_orange = getent( "one_red_to_orange", "targetname" );
	one_red_to_orange waittill( "trigger" );
	
	reds = get_force_color_guys( "allies", "r" );
	third_guy = reds[ 0 ];
	third_guy set_force_color( "o" );
	
	third_guy thread replace_on_death();
}

kill_rooftop_ignore_groups()
{
	flag_wait( "regrouped" );
	
	setThreatBias( "players_group", "left_rooftop_enemies", 0 );
	setThreatBias( "players_group", "right_rooftop_enemies", 0 );
	
	road_friendly = getentarray( "road_friendly", "script_noteworthy" );
	for( i=0;i<road_friendly.size;i++ )
		road_friendly[ i ] delete();	
}

enemy_mass()
{
	enemy_mass_trigger = getent( "enemy_mass_trigger", "targetname" );
	enemy_mass_trigger waittill( "trigger" );
	
	
}

magic_grenade_trigger_think()
{
	self waittill( "trigger" );
	
	magic_grenades_orgs = getentarray( self.target , "targetname" );
	for( i=0;i<magic_grenades_orgs.size;i++ )
	{
		level.price magicgrenade( magic_grenades_orgs[ i ].origin +( 0, 0, 50 ), magic_grenades_orgs[ i ].origin, randomfloatrange( 1, 2 )  );
	}
}

player_breaks_ignore( threat_bias_group )
{
	for( ;; )
	{
		self waittill( "trigger", other );
		
		if( other == level.player )
		{
			setThreatBias( "players_group", threat_bias_group, 0 );
			break;
		}
	}
}


sit_rep_dialog()
{
	sit_rep_dialog = getent( "sit_rep_dialog", "targetname" );
	sit_rep_dialog waittill( "trigger" );	
	
	level.scr_sound[ "price" ][ "stand_down" ]				= "armada_pri_allteamsstanddown";
	level.scr_sound[ "price" ][ "roger_hq" ]				= "armada_pri_rogerhq";
	level.scr_sound[ "price" ][ "heads_up" ]				= "armada_pri_headsup";
	
	/*
	level.price playsound( "armada_pri_onetwentyonesitrep" );
	wait 2.5;
	level.player playsound( "armada_gm1_rightsideclear" );
	wait 3;
	level.price playsound( "armada_pri_onethreeonecheckin" );
	wait 2;
	level.player playsound( "armada_gm2_centerclear" );
	wait 3;
	*/
	
	//level.price playsound( "armada_pri_allteamsstanddown" );
	level.price anim_single_queue( level.price, "stand_down" );
	wait 2;
	//level.price playsound( "armada_pri_rogerhq" );
	level.price anim_single_queue( level.price, "roger_hq" );
	//wait 2;
	//level.price playsound( "armada_pri_headsup" );
	level.price anim_single_queue( level.price, "heads_up" );
}

intel_start()
{
	level.player setOrigin(( 3622, 29958, -168 ) );
}

tv_start()
{
	tv_start = getent( "tv_start", "targetname" );
	level.player setOrigin( tv_start.origin );
	level.player setPlayerAngles( tv_start.angles );
	tv_start_spawners = getentarray( "tv_start_spawners", "targetname" );
	array_thread( tv_start_spawners, maps\_spawner::spawn_ai ); 
	
	flag_set( "hq_entered" );
	flag_set( "hq_cleared" );
	flag_set( "on_ground" );
	flag_set( "regrouped" );
	
	thread maps\_vehicle::create_vehicle_from_spawngroup_and_gopath( 9 );
}

hq2tv_start()
{
	hq2tv_start = getent( "hq2tv_start", "targetname" );
	level.player setOrigin( hq2tv_start.origin );
	level.player setPlayerAngles( hq2tv_start.angles );
	hq2tv_start_spawners = getentarray( "hq2tv_start_spawners", "targetname" );
	array_thread( hq2tv_start_spawners, maps\_spawner::spawn_ai ); 
	
//	hq2tv_red_starts = getent( "hq2tv_red_starts", "targetname" );
//	hq2tv_red_starts notify( "trigger" );
	
	flag_set( "hq_entered" );
	flag_set( "hq_cleared" );
	flag_set( "on_ground" );
	
	//thread maps\_vehicle::scripted_spawn( 9 );
	thread maps\_vehicle::create_vehicle_from_spawngroup_and_gopath( 9 );
}

end_of_script()
{
	end_of_scripting = getent( "end_of_scripting", "targetname" );
	end_of_scripting waittill( "trigger" );
	
	iprintlnbold( &"SCRIPT_DEBUG_LEVEL_END" );
}


objectives()
{
	obj = getent( "outside_hq_obj", "targetname" );
	objective_add( 1, "active", "Get into position to breach the HQ building.", obj.origin );
	objective_current( 1 );	
	
	flag_wait( "hq_entered" ); 
	
	trigger2 = getent( "inside_hq_obj", "targetname" );
	objective_state( 1, "done" );
	objective_add( 2, "active", "Search the HQ building for Al Assad.", trigger2.origin );
	objective_current( 2 );	
	
	flag_wait( "hq_cleared" ); 
//	trigger2 waittill( "trigger" );
	
	regroup_obj = getent( "regroup_obj", "targetname" );
	objective_state( 2, "done" );
	objective_add( 3, "active", "Regroup with first squad.", regroup_obj.origin );
	objective_current( 3 );	
	
	flag_wait( "regrouped" );
	
	//entered_tvstation = getent( "entered_tvstation", "targetname" );
	objective_state( 3, "done" );
	objective_add( 4, "active", "Make your way to the TV Station.", ( 2808, 23672, -24 ) );
	objective_current( 4 );	
	
	flag_wait( "tvstation_entered" );
	//entered_tvstation waittill( "trigger" );
	
	objective_state( 4, "done" );
}

hq_entered_wait()
{
	trigger = getent( "trigger_volume_room01", "targetname" );
	trigger waittill( "trigger" );
	flag_set( "hq_entered" );	
	
	barbed_wire_guys = getentarray( "barbed_wire_guys", "script_noteworthy" );
	for( i=0;i<barbed_wire_guys.size;i++ )
		barbed_wire_guys[ i ] delete();
}

HQ_finished()
{
	flag_wait( "hq_cleared" ); 
	
	exit = getent( "hq_building_exit_door", "targetname" );
	exit connectpaths();
	exit delete();
	
	hq_breachers = getentarray( "hq_breachers", "script_noteworthy" );
	for( i=0;i<hq_breachers.size;i++ )
	{
		if( isalive( hq_breachers[ i ] ) )
			hq_breachers[ i ] doDamage( hq_breachers[ i ].health + 100, hq_breachers[ i ].origin );
	}
		
	small_gate1 = getent( "small_gate1", "targetname" );
	small_gate1 rotateyaw( -90 , .1 );
	small_gate1 connectpaths();
	//small_gate1 delete();
	
	small_gate2 = getent( "small_gate2", "targetname" );
	small_gate2 rotateyaw( 90 , .1 );
	small_gate2 connectpaths();
	//small_gate2 delete();
}

get_abarbed_wire_ai()
{
	array = getentarray( "barbed_wire_guys", "script_noteworthy" );
	for(i=0;i<array.size;i++)
		if(isai(array[i]))
			return array[i];
}

razor_wire_setup(  )
{
	trigger = getent( "first_fly_away_trigger", "targetname" );

	node = getnode("barbed_wire_node","targetname");
	barbed_wire_long = getent( "barbed_wire_long", "targetname" );
	barbed_wire_long.animname = "barbed_wire_long";
	barbed_wire_long SetAnimTree();
	
	node thread anim_single_solo( barbed_wire_long, "razor_idle",undefined, node );

//	anim_loop( guys, anime, tag, ender, entity )
	flag_wait("on_ground");
	

	guy = get_abarbed_wire_ai();
	guy.animname = "razorwire_guy";
	
	assert(isdefined(guy));
	assert(isdefined(barbed_wire_long));
	
	sceneobjects = [];
	sceneobjects[0] = guy;
	sceneobjects[1] = barbed_wire_long;

//	node anim_reach_solo( guy, "razor_setup", undefined, undefined, barbed_wire_long );

	node thread anim_single( sceneobjects, "razor_idle",undefined, node );


	trigger waittill ("trigger");


	node anim_single( sceneobjects, "razor_setup",undefined, node );
//	node anim_single( sceneobjects, "razor_endidle",undefined, node );
	
	
	
	
}

razor_wire()
{
	
	flag_wait( "hq_cleared" ); 

	node = getnode("barbed_wire_node","targetname");
	barbed_wire_long = getent( "barbed_wire_long", "targetname" );
	barbed_wire_long.animname = "barbed_wire_long";
	barbed_wire_long SetAnimTree();
	node thread anim_single_solo( barbed_wire_long, "razor_idle",undefined, node );
		
	barbed_wire_clip = getent( "barbed_wire_clip", "targetname" );
	barbed_wire_clip connectpaths();
	barbed_wire_clip delete();
}



ride_start()
{

	level thread maps\_introscreen::introscreen_delay( &"ARMADA_INTRO", &"ARMADA_DATE", &"ARMADA_PLACE", &"CARGOSHIP_INFO", .5, .5, 0 );

	VisionSetNaked( "armada_water" );
	musicPlay( "music_armada_ride" ); 
	
	setsaveddvar( "sm_sunSampleSizeNear", 4.0825 );
	//&"Charlie Don't Surf", &"Nov 23, 2008", &"The Persian Gulf"
	thread razor_wire_setup();
	thread maps\armada_amb::main();
	thread start_helicopters();
	thread technical_setup();
	thread end_water_visionset();
	
	battlechatter_off( "allies" );

	thread feet_dry();
	thread taking_fire();
	thread was_close();
	thread target_in_view();
	thread five_seconds();
	thread down_ropes();
	
	//nate 
	waittillframeend;
	level.player_heli notify ("groupedanimevent","snipe");
	wait 6;
	level.player playsound( "armada_hp1_shorelineinview" );
	wait 1.5;
	level.player playsound( "armada_fhp_copystrikersixfour" );
	
	//nate
	
	
}

feet_dry()
{
	wait 10;
	level.player playsound( "armada_hp1_feetdrytenseconds" );
	wait 1.5;
	level.player playsound( "armada_fhp_copy" );
}

taking_fire()
{
	wait 19;
	level.player playsound( "armada_hp1_takingfirehere" );
	wait 1.5;
	level.player playsound( "armada_fhp_rogerthat" );
}

was_close()
{
	wait 31;
	level.player playsound( "armada_hp1_thatwasclose" );
}

target_in_view()
{
	wait 35;
	level.player playsound( "armada_fhp_gotvisual" );
	//wait 1.5;
	//level.player playsound( "armada_fhp_copy" );
}

five_seconds()
{
	wait 43;
	level.player playsound( "armada_hp1_fiveseconds" );
	wait 5;
	level.player playsound( "armada_hp1_standbygreenlight" );
}

down_ropes()
{
	flag_wait( "end_water" );	
	level.player_heli waittill( "unload" );
	level.price playsound( "armada_pri_downtheropes" );
	wait 5;
	level.breacher playsound( "armada_gm1_gogogo" );
}


on_ground()
{
	flag_wait( "on_ground" );
	
	battlechatter_on( "allies" );
	
	VisionSetNaked( "armada_ground", 3 );
	setsaveddvar( "sm_sunSampleSizeNear", .25 );
	setculldist( 11000 );
}

barbed_wire_dialog()
{
	barbed_wire_dialog = getent( "barbed_wire_dialog", "targetname" );

	barbed_wire_dialog waittill( "trigger" );

	
	//what is this? I'm going to put some animation stuff here. and let you sort it out -Nate  
	
	barbed_wire_dialog playsound( "armada_gm2_moveitmoveit" );
	wait 2;
	barbed_wire_dialog playsound( "armada_gm3_blockingpositions" );
}

on_me_to_building()
{	
	on_me_to_building = getent( "on_me_to_building", "targetname" );
	on_me_to_building waittill( "trigger" );
	level.price playsound( "armada_pri_secondsquadonme" );
}

end_water_visionset()
{
	end_water_visionset = getent( "end_water_visionset", "targetname" );
	end_water_visionset waittill( "trigger" );
	
	flag_set( "end_water" );	
	VisionSetNaked( "armada", 3 );
}

start_helicopters()
{
	thread maps\_vehicle::create_vehicle_from_spawngroup_and_gopath( 0 );
	thread maps\_vehicle::create_vehicle_from_spawngroup_and_gopath( 2 );
	thread maps\_vehicle::create_vehicle_from_spawngroup_and_gopath( 3 );
	thread maps\_vehicle::create_vehicle_from_spawngroup_and_gopath( 4 );
	
	
	level.player_heli = maps\_vehicle::waittill_vehiclespawn_noteworthy( "players_helicopter" );
	//level.player_heli = getent( "players_helicopter", "script_noteworthy" );

	thread player_fastrope();
	wait 1;
	
	level.helis = getentarray( "heli", "targetname" );
	first_fly_away_trigger = getent( "first_fly_away_trigger", "targetname" );
	fly_away_trigger = getent( "fly_away_trigger", "targetname" );
	
	thread rpg_guys();
	
	for( i=0;i<level.helis.size;i++ )
	{
		level.helis[ i ].exitpoint = level.helis[ i ].origin;
		//level.helis[ i ] thread debug();
		level.helis[ i ] thread maps\_vehicle::godon();
		if( isdefined( level.helis[ i ].script_noteworthy ) )
		{
			if( level.helis[ i ].script_noteworthy == "ai_dropper" || level.helis[ i ].script_noteworthy == "players_helicopter" )
			{
				level.helis[ i ] thread helicopters_fly_away( fly_away_trigger );
			}
			if( level.helis[ i ].script_noteworthy == "first_fly_away" )
			{
				level.helis[ i ] thread helicopters_fly_away( first_fly_away_trigger );
			}
			/*
			if( level.helis[ i ].script_noteworthy == "unload_late" )
			{
				unload_node = getent( level.helis[ i ].script_parameters, "targetname" );
				level.helis[ i ] thread unload_late( unload_node );
			}
			*/
		}
	}
	
	delete_heli_nodes = getentarray( "delete_heli", "script_noteworthy" );
//	array_thread( delete_heli_nodes, ::delete_heli_think );
}

unload_late( unload_node )
{
	flag_wait( "on_ground" ); 
	self vehicle_detachfrompath(); 
	self vehicle_dynamicpath( unload_node, false ); 
}

helicopters_fly_away( trigger )
{
	thread wait_for_unload();
		
	trigger waittill( "trigger" );
	
	if( !isdefined( self.armada_unloaded ) )
		self waittill( "unloaded" );
	
	self vehicle_detachfrompath(); 
	self cleargoalyaw(); //clear this thing
	self clearlookatent(); //clear that other thing
	self cleartargetyaw(); //clear the stuff
	self setvehgoalpos( self.exitpoint, 1 ); //1= stop
	//add delete
}

wait_for_unload()
{
	self waittill( "unloaded" );
	self.armada_unloaded = true;
}

delete_heli_think()
{
	self waittill( "trigger" , vehicle );
	vehicle delete();
}


player_fastrope()
{		
	//level.player playerlinktodelta( <linkto entity>, <tag>, <viewpercentag fraction>, <right arc>, <left arc>, <top arc>, <bottom arc> )
	//level.player playerlinktodelta( level.player_heli, "tag_playerride", 1, 45, 45, 30, 30 );
	//level.player playerlinktodelta( level.player_heli, "tag_playerride", 1 );
	level.player_heli thread maps\_vehicle::loadplayer( 3 );
	
	level.player allowprone( false );
	level.player allowstand( false );
	level.player EnableInvulnerability();
	level.player.ignoreme = true;
	wait .5;
	level.player setplayerangles(( 0, 35, 0 ) );
	
	
	level.player_heli waittill( "unload" );
	//level.player disableweapons();
	//level.player_heli setgoalyaw( 180 );
	//level.player unlink();
	//level.player_heli thread maps\_vehicle::loadplayer( 7, 2.4 );  
	// 7 here is the position, 3 is time to subtract from the animation before detaching the player
	wait 6;	
	autosave_by_name( "on_the_ground" );
	level.player allowprone( false );
	level.player allowstand( true );
	level.player allowcrouch( false ); // bounce the player out of crouch
	wait .05;
	level.player allowprone( true );
	level.player allowcrouch( true );
	level.player DisableInvulnerability();
	level.player.ignoreme = false;
	//level.player enableweapons();
	
	/*
	level.player_heli waittill( "reached_stop_node" );
	level.player_heli setgoalyaw( 270 );
	
	wait 1;
	
	level.player unlink();
	player_fudge_moveto(( 927, 31690, 10 ) );
	autosave_by_name( "on_the_ground" );
	
	wait 12;
	
	e = getent( "exit_point", "targetname" );
	level.player_heli setvehgoalpos( e.origin );
	*/
}


landed_start()
{
	street_start = getent( "street_start", "targetname" );
	level.player setOrigin( street_start.origin );
	level.player setPlayerAngles( street_start.angles );
	streets_start_spawners = getentarray( "streets_start_spawners", "targetname" );
	array_thread( streets_start_spawners, maps\_spawner::spawn_ai ); 
	flag_set( "on_ground" );
	
	thread maps\_vehicle::create_vehicle_from_spawngroup_and_gopath( 9 );
}

tv_breach()
{
	trigger = getent( "trigger_tv_breach", "targetname" );
	trigger waittill( "trigger" );
	
	eVolume = getent( "tv_volume", "targetname" );
//	thread breach_dialog( eVolume );
	
	level.price set_force_color( "o" );
	
	reds = get_force_color_guys( "allies", "r" );
	level.tv_breacher = reds[ 0 ];
	level.tv_breacher set_force_color( "o" );
	level.tv_breacher thread replace_on_death();
	
//	aBreachers = getentarray( "friendly_breachers", "script_noteworthy" );
	aBreachers = [];
	aBreachers = add_to_array( aBreachers, level.price );
	aBreachers = add_to_array( aBreachers, level.tv_breacher );
	sBreachType = "explosive_breach_left";
	eVolume thread maps\_breach::breach_think( aBreachers, sBreachType );
	
	while( !eVolume.breached )
            wait( 0.05 );
	

	level.price enable_ai_color();
	level.tv_breacher enable_ai_color();
}

hq_breach()
{
	trigger = getent( "start_breach", "targetname" );
	trigger waittill( "trigger" );
	
	eVolume = getent( "volume_room01", "targetname" );
	thread breach_dialog( eVolume );
	
//	aBreachers = getentarray( "friendly_breachers", "script_noteworthy" );
	aBreachers = [];
	aBreachers = add_to_array( aBreachers, level.price );
	aBreachers = add_to_array( aBreachers, level.breacher );
	sBreachType = "explosive_breach_left";
	eVolume thread maps\_breach::breach_think( aBreachers, sBreachType );
	
	while( !eVolume.breached )
            wait( 0.05 );

	level.price enable_ai_color();
	level.breacher enable_ai_color();
}

breach_dialog( eVolume )
{
	level.price playsound( "armada_pri_targetbuildingleftbreach" );
	//wait 3;
	//level.breacher playsound( "armada_gm4_withyou" );
	
	//trigger_volume_room01 waittill( "trigger" );
	eVolume waittill( "detpack_about_to_blow" );
	
	wait 1;
	
	level.price playsound( "armada_pri_blowcharge" );
	wait 2;
	level.breacher playsound( "armada_gm1_breaching" );
	wait 1;
	level.price playsound( "armada_pri_gogogo" );
}


price_think()
{
	level.price = self;	
	level.price.animname = "price";
	level.price thread magic_bullet_shield();
	level.price.interval = 0;
}

breacher_think()
{	
	level.breacher = self;
	level.breacher thread magic_bullet_shield();
	level.breacher.interval = 0;
	
	flag_wait( "hq_cleared" ); 
	wait .1;
	
	level.breacher thread stop_magic_bullet_shield();
}

hq_breachers_think()
{	
	self.interval = 0;
}

technical_setup()
{
	trigger = getent( "technical_setup", "targetname" );
	trigger waittill( "trigger" );
	
	wait 1;
	
	technical = getEnt( "canal_technical", "targetname" );	
	//technical.mgturret[ 0 ].accuracy = 0;
	technical.mgturret[ 0 ] setmode( "manual_ai" ); // auto, auto_ai, manual
	technical.mgturret[ 0 ] settargetentity( level.player_heli );
	
	technical waittill( "start_vehiclepath" );
	technical.mgturret[ 0 ] startfiring();
	wait 8;
	//technical doDamage( technical.health + 100, technical.origin );
	technical delete();
}



rpg_guys()
{
    rpg_guys = getentarray( "rpg_guy", "script_noteworthy" );

    for( i=0;i<rpg_guys.size;i++ )
        rpg_guys[ i ].pacifist = true;

    for( ;; )
    {
        rpg_guys = getentarray( "rpg_guy", "script_noteworthy" );

		for( i = 0; i < rpg_guys.size; i++ )
        {
            if( !isalive( rpg_guys[ i ] ) )
                    continue;

            closest = getClosest( rpg_guys[ i ].origin, level.helis );
            dist = distance( closest.origin , rpg_guys[ i ].origin );

            if( dist < 2500 && rpg_guys[ i ].pacifist )
            {
                rpg_guys[ i ] setEntityTarget( closest );
                rpg_guys[ i ].pacifist = false;
                rpg_guys[ i ] thread kill_in_ten();
            }

            wait( .05 );
        }
        
        wait( .05 );
    }
}

kill_in_ten()
{
	wait 10;
	if( isalive( self ) )
		self doDamage( self.health + 100, self.origin );
}


helis_move()
{
	thread maps\_vehicle::gopath( self );
}


helis_move2()
{
	pathpoint = undefined;
	if( isdefined( self.target ) )
		pathpoint = getent( self.target, "targetname" );
	else 
		assertmsg( "helicopter without target" );
	arraycount = 0;
	pathpoints = [];
	while( isdefined( pathpoint ) )
	{
		pathpoints[ arraycount ] = pathpoint;
		arraycount++;
		if( isdefined( pathpoint.target ) )
			pathpoint = getent( pathpoint.target, "targetname" );
		else
			break;
	}

	radius = 512;	
	for( i=0;i<pathpoints.size;i++ )
	{
		if( isdefined( pathpoints[ i ].radius ) )
			radius = pathpoints[ i ].radius;
		self setNearGoalNotifyDist( 400 );
			
		stop = false;
		if( isdefined( pathpoints[ i ].script_stopnode ) ) //z: stop at nodes if there is a script_stopnode = 1 value
			stop = pathpoints[ i ].script_stopnode;
			
		self setvehgoalpos( pathpoints[ i ].origin, stop );
		self waittill( "near_goal" );
	}
}

debug( num )
{
	while( isdefined( self.script_parameters ) )
	{
		print3d( self.origin+( 0, 0, 128 ), self.script_parameters, ( 1, 1, 1 ), 1, 2, 1 );
		wait .05;
	}
}


set_threatbias_group( group )
{
	assert( threatbiasgroupexists( group ) );
	self setthreatbiasgroup( group );
}

circling_heli_turrets()
{
	flag_wait( "hq_cleared" ); 
	
	thread turret_target_finder();
	wait 1;
	//h = maps\_vehicle::waittill_vehiclespawn_noteworthy( "circling_heli" );
	circling_helis = get_vehiclearray( "circling_heli", "script_noteworthy" );
	//for( i = 0; i < circling_helis.size; i++ )
	//	circling_helis[ i ] notsolid();
	
	//circling_helis[ 0 ] thread setup_circling_heli_turret();
	array_thread( circling_helis, ::setup_circling_heli_turret );
}

setup_circling_heli_turret()
{
	tag = "tag_gun_l";
	//tag = "tag_turret";
    turret = spawnturret( "misc_turret", self gettagorigin( tag ), "heli_minigun_noai" );
    turret setmodel( "weapon_saw_MG_setup" );
    turret linkto( self, tag, ( 0, 0, -24 ), ( 0, 90, 0 ) );
    turret maketurretunusable();
    turret setmode( "manual" );
    turret setturretteam( "allies" );
    turret setconvergencetime( 0, "yaw" );
    turret setconvergencetime( 0, "pitch" );

    default_target = spawn( "script_model", self gettagorigin( tag ) );
    default_target linkto( self, tag, ( 300, 0, 0 ), self.angles );

    turret thread heli_minigun_firethread( default_target, self ); 
    turret thread heli_minigun_targetthread( default_target, self );
}

heli_minigun_firethread( default_target, helicopter ) 
{
    self endon( "stop_firing" );
   
    while( true )
	{
        burst = randomintrange( 3, 7 );
        for( i = 0; i < burst; i++ )
        {
            self shootturret();
            wait( 0.1 );
        }
        
		if( randomint( 3 ) == 0 )
		{
			wait randomintrange( 5, 8 );
		}
		
		wait randomfloat( 0.5, 2 );
		
    }
}

heli_minigun_targetthread( default_target, helicopter ) 
{
    self endon( "stop_firing" );    
    target = getent( "minigun_target", "targetname" );
    self settargetentity( target );
	
	
    while( true )
	{
        wait 10;
		num_guys = level.enemies.size;
		if( num_guys > 0 )
		{
			target = level.enemies[ randomint( num_guys ) ];
			if( isalive( target ) )
	    	    self settargetentity( target );
    	}
    }
    
}

turret_target_finder()
{
	flag_wait( "hq_cleared" ); 
	
	while( true )
	{
		level.enemies = getaiarray( "axis" );
		wait 4;
	}
}

get_vehiclearray( key1, key2 )
{
	vehicle_array = getentarray( key1, key2 );
	
	j = 0;
	new_vehicle_array = [];
	for( i = 0; i < vehicle_array.size; i++ )
	{
		if( vehicle_array[ i ].classname == "script_vehicle" )
		{
			new_vehicle_array[ j ] = vehicle_array[ i ];
			j++;
		}
	}
			
	return new_vehicle_array;
}

circling_helis_rpg_guy_spawner()
{
	circling_heli_rpg_spawners = getentarray( "circling_heli_rpg_guy", "script_noteworthy" );
	total_spawners = circling_heli_rpg_spawners.size;
	circling_heli_rpg_spawners = array_randomize( circling_heli_rpg_spawners );
	array_thread( circling_heli_rpg_spawners, ::add_spawn_function, ::circling_helis_rpg_guy_think );
	//array_thread( circling_heli_rpg_spawners, ::add_spawn_function, ::kill_in_ten );
	
	flag_wait( "hq_cleared" ); 
	wait 1;
	level.circling_helis = get_vehiclearray( "circling_heli", "script_noteworthy" );
	
	i = 0;
	//while( ! flag( "some_flag" ) )
	while( 1 )
	{
		living_rpg_guys = getentarray( "circling_heli_rpg_guy", "script_noteworthy" );
		level.living_rpg_guys = get_living( living_rpg_guys );
		
		spawner = circling_heli_rpg_spawners[ i ];
		spawner.count = 1;
		if( level.living_rpg_guys.size < 4 )
		{
			guy = spawner maps\_spawner::spawn_ai();
			i++;
		}
		if( i >= total_spawners )
		{
			i = 0;
		}
		wait 1;
    }
}


get_living( array )
{
	
	j = 0;
	living = [];
	for( i = 0; i < array.size; i++ )
	{
		if( isalive( array[ i ] ) )
		{
			living[ j ] = array[ i ];
			j++;
		}
	}
			
	return living;
}

    
circling_helis_rpg_guy_think()
{
	while( isalive( self ) )
	{
		closest = getClosest( self.origin, level.circling_helis );
		self setEntityTarget( closest );
		wait 1;
	}
}

