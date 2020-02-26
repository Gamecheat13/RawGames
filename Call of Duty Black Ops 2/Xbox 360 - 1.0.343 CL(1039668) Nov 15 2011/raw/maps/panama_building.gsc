#include common_scripts\utility;
#include maps\_utility;
#include maps\_dialog;
#include maps\_scene;
#include maps\panama_utility;

#insert raw\common_scripts\utility.gsh;
#insert raw\maps\_utility.gsh;

skipto_building()
{
	skipto_setup();
	
	level.mason = init_hero( "mason" );
	level.noriega = init_hero( "noriega" );
	a_heroes = array( level.mason, level.noriega );
	
	start_teleport( "player_skipto_building", a_heroes );	
	
	wait 1;
}

main()
{
	flag_set( "panama_building_start" );

	// event setup
	level thread start_crying_woman();
	
	// event flow
	clinic_spookies();
	level thread clinic_move_heroes();	// threaded in case player sprints through
	digbat_tackle();
	digbat_gauntlet();
	gauntlet_recover();
	building_stairwell();
}

init_flags()
{
	flag_init( "panama_building_start" );
	flag_init( "player_at_clinic" );
	flag_init( "clinic_enter_hall_1" );
	flag_init( "clinic_enter_hall_2" );
	
	flag_init( "clinic_ceiling_collapsed" );
	
	flag_init( "post_gauntlet_player_fired" );
	flag_init( "post_gauntlet_mason_open_door" );
	
}

/*************************************************************************************************************
	Clinic Walk
*************************************************************************************************************/
clinic_move_heroes()
{
	level endon( "digbat_tackle_started" );
	
	level thread run_scene( "clinic_walk_start_idle" );	// idle outside the clinic
	
	iprintln( "Mason: We need to pass through this clinic." );
	
	flag_wait( "player_at_clinic" );					// set by one of two triggers
	
	run_scene( "clinic_walk_door_to_idle" ); 		// from outside to the first stop point
	level thread run_scene( "clinic_walk_idle_1" ); // first stop point idle
	
	flag_wait( "clinic_enter_hall_1" );				// set by trigger (targetname clinic_enter_hall_1)
	run_scene( "clinic_walk_move_to_idle2" );		// move through first hall
	level thread run_scene( "clinic_walk_idle_2" );	// second stop point idle
	
	flag_wait( "clinic_enter_hall_2" );				// set by trigger (targetname clinic_enter_hall_2)
	run_scene( "clinic_walk_move_to_split" );		// move through second hall
	if( flag( "clinic_ceiling_collapsed" ) )
	{
		run_scene( "clinic_walk_path_v1" );			// run to the last stop point, ceiling already collapsed, don't react
		level thread run_scene( "clinic_walk_end_idle_v1" ); // idle at the end after no react
	}
	else
	{
		run_scene( "clinic_walk_path_v2" );			// run to the last stop point, react to ceiling collapse
		level thread run_scene( "clinic_walk_end_idle_v2" );	// idle at the end after react
	}
	
	iprintln( "Mason: Do you hear that?" );
}



clinic_door_kicked_in()
{
	m_door_clip = GetEnt( "clinic_frontdoor_clip", "targetname" );
	m_door = GetEnt( "clinic_frontdoor", "targetname" );
	
	m_door LinkTo( m_door_clip );

	m_door_clip RotateYaw( 100, 0.7, 0.0, 0.5 );

	//if the player is close shake camera and controller rumble
	n_distance = Distance2D( m_door.origin, level.player.origin );
	if( n_distance < 200 )
	{
		Earthquake(0.1, 0.5, level.player.origin, 256);
		level.player PlayRumbleOnEntity( "damage_light" );
	}

	m_door_clip waittill("rotatedone");
	m_door_clip RotateYaw( -3, 0.5, 0.0, 0.2 );
}


clinic_spookies()			// feel free to rename
{
	autosave_by_name( "clinic_entrance" );
	
	level thread clinic_ceiling_collapse();
	level thread clinic_light_shake();
	level thread clinic_gurney_shake();		//TODO: change to a notetrack
}


clinic_ceiling_collapse()	
{
	//set by one of two triggers
	flag_wait( "clinic_ceiling_collapsed" );		

	//start the fx
	level notify( "fxanim_ceiling_collapse_start" );
	
	//origin of collapse
	v_ceiling_position = getstruct( "building_ceiling_collapse", "targetname" ).origin;
	
	//shake and rumble	
	Earthquake( 0.3, .5, v_ceiling_position, 1000 );
		
	//sounds
	e_sound_pos = Spawn( "script_origin", v_ceiling_position );
	level.player PlaySound( "evt_be_explo2d" );
	e_sound_pos PlaySound( "evt_be_roof_collapse" );
	e_sound_pos Delete();
	
	level.player PlayRumbleLoopOnEntity( "damage_heavy" );
	wait 0.5;
	level.player StopRumble( "damage_heavy" );
}

clinic_light_shake()
{
	trigger_wait( "clinic_light_shake" );
	
	iprintln( "Mason: this building isn't safe" );
	
	iprintlnbold( "light overhead shakes" );
	level.player playsound( "evt_be_explo2d" );
	earthquake( 0.5, 1.5, level.player.origin, 250 );
	
	e_light = getent( "clinic_light", "targetname" );
	e_light RotatePitch( 25, .5, .25, .25 );
	e_light waittill( "rotatedone" );
	e_light RotatePitch( -50, 1, .25, .25 );
	e_light waittill( "rotatedone" );
	e_light RotatePitch( 25, .5, .25, .25 );
}

clinic_gurney_shake()
{
	trigger_wait( "clinic_light_shake" );
	
	e_gurney = getent( "clinic_gurney", "targetname" );
	v_start_pos = e_gurney.origin;
	
	level.player playsound( "evt_be_explo2d" );
	earthquake( 0.5, 1.5, level.player.origin, 250 );
	e_gurney MoveTo( (24812, 35328, 588), 1, .25, .5 );	// will be fxanim

	flag_wait( "clinic_enter_hall_2" );
	wait 1;
	e_gurney MoveTo( v_start_pos, .5, .05, .25 );	// will be fxanim
}



/*************************************************************************************************************
	Digbat Tackle/Defend
*************************************************************************************************************/
start_crying_woman()
{
	level thread run_scene( "crying_woman_idle" );
}

digbat_tackle()
{
	trigger_wait( "trig_tackle_start" );
	
	//clear out previous allies and axis
	a_ai = GetAIArray( "axis", "allies" );
	foreach( ai in a_ai )
	{
		if( ai is_hero() )
		{
			continue;
		}	
		ai Delete();
	}	
	
	a_vehicles = GetEntArray( "slums_vehicle", "script_noteworthy" );
	foreach( vehicle in a_vehicles )
	{
		VEHICLE_DELETE( vehicle );
	}
	
	autosave_by_name( "digbat_tackle" );
	
	level notify( "digbat_tackle_started" );
		
	level thread run_scene( "digbat_tackle" );
		
	level.player.current_weapon = level.player GetCurrentWeapon();
	level.player.gauntlet_weapons = level.player GetWeaponsList();
	level.player TakeAllWeapons();
	
	level.player GiveWeapon( "m1911_sp" );
	level.player SwitchToWeapon( "m1911_sp" );
	
	//TODO Replace wait with a notetrack in the anim
	wait 1.5;
	level notify( "fxanim_wall_tackle_start" );
	
	//play the sound of the wall breaking
	level.player PlaySound ("evt_dingbat_wall_break");
	
	scene_wait( "digbat_tackle" );
	level thread run_scene( "digbat_tackle_body" );
	
	nd_mason_gauntlet = GetNode( "mason_gauntlet_node", "targetname" );
	level.mason SetGoalNode( nd_mason_gauntlet );
	
	level.player DisableWeaponCycling();
	level.player ShowViewModel();
	level.player EnableWeapons();
	level.player SetClientDvar("cg_drawFriendlyNames", 1);
		
}

digbat_gauntlet()
{
	level.gauntlet_death = 1;
	
	n_wave_count 		= 8;	// number of waves that spawn
//	n_wave_size			= 1;	// number of AI that spawn each wave
//	n_wave_size_inc		= 0;	// number of AI to add to n_wave_size with each successive wave
//	n_wave_spawn_delay 	= 3;	// time between a new wave spawning
//	n_guy_spawn_delay	= 0.7;	// time between each AI spawn within a wave
//	
//	a_digbat_guantlet_spawners = GetEntArray( "digbat_gauntlet_spawner", "targetname" );
//	
//	// level thread debug_gauntlet_count();
//	
//	for ( i = 0; i < n_wave_count; i++ )
//	{
//		// IPrintLn( "Spawning wave of " + n_wave_size + " guys" );
//		level thread digbat_gauntlet_spawn_wave( a_digbat_guantlet_spawners, n_wave_size, n_guy_spawn_delay );
//		
//		n_wave_size += n_wave_size_inc;
//		
//		wait n_wave_spawn_delay;
//	}

	sp_gauntlet = GetEnt( "digbat_tackle_spawner", "targetname" );
	sp_gauntlet add_spawn_function( ::digbat_gauntlet_think );
	for( i = 1; i < n_wave_count; i++ )
	{
		e_digbat = sp_gauntlet spawn_ai( true );
		e_digbat.animname = "digbat_" + i;
		
		level thread run_scene( "digbat_gauntlet_" + i );
		
		waittill_notify_or_timeout( "gauntlet_death", 3.0 );
	}
	
	while( level.gauntlet_death < n_wave_count )
	{
		wait 0.5;
	}
	
}

digbat_gauntlet_think()
{
	self.health = 30;
	//self.goalradius = 64;
	//self.ignoresuppression = true;
	//self SetGoalPos( level.mason.origin );

	//self set_grenadeammo( 0 );
	//self.script_ignore_suppression = true;
	
	self waittill( "death" );
	level notify( "gauntlet_death" );	
	level.gauntlet_death++;
}

digbat_gauntlet_spawn_wave( a_spawners, n_wave_size, n_wait_time )
{
	a_spawners = array_randomize( a_spawners );	// mix up the spawners 
		
	for( i = 0; i < n_wave_size; i++ )
	{
		a_spawners[i].count = 1;
		a_spawners[i].script_aigroup = "digbat_gauntlet";	//hax!
		guy = a_spawners[i] spawn_ai( true );
		if( !IsDefined( guy ) )
		{
			IPrintLnBold( "Guy Didn't Spawn" );
		}
		
		guy.health = 30;
		wait n_wait_time;
	}			
}

gauntlet_recover()
{
	level.player HideViewModel();
	level.player EnableWeaponCycling();
	level.player TakeWeapon( "m1911_sp" );
	
	foreach( e_weapon in level.player.gauntlet_weapons )
	{
		level.player GiveWeapon( e_weapon );
	}
	
	level.player SwitchToWeapon( level.player.current_weapon );
	
	level thread run_scene( "tackle_recover_mason" );
	level thread run_scene( "tackle_recover_woman" );
	run_scene( "tackle_recover_player" );
	
	autosave_by_name( "digbat_gauntlet_over" );
}

/*************************************************************************************************************
	Building Stairwell
*************************************************************************************************************/
building_stairwell()
{
	level thread building_stairwell_mason_movement();
	level thread building_stairwell_flashlights();
	level thread building_stairwell_player_fire_listener();
	
	flag_wait( "clinic_stairwell_top" );
	
	autosave_by_name( "apache_chase_start" );
	iprintlnbold( "Woods: Let me take this." );
}

building_stairwell_mason_movement()
{
	nd_stairwell_entrance = GetNode( "stairwell_entrance", "targetname" );
	level.mason set_goalradius( 32 );
	level.mason SetGoalNode( nd_stairwell_entrance );
	wait( .5 );
	level.mason waittill( "goal" );
	
	flag_wait( "post_gauntlet_mason_open_door" );
	e_door = GetEnt( "clinic_stairwell_door", "targetname" );
	e_door Delete();
	
	if ( flag( "post_gauntlet_player_fired" ) )
	{
		run_scene( "stairwell_enter_under_fire" );
	}
	else 
	{
		run_scene( "stairwell_enter_normal" );
	}
	
	run_scene( "stairwell_climb_stairs" );
	run_scene( "stairwell_end_idle" );
}

building_stairwell_flashlights()
{	
	wait( 1 );
	
	level thread run_scene( "hallway_flashlights_enter" );
	wait( .5 );
	a_flashlights = get_model_or_models_from_scene( "hallway_flashlights_enter" );
	foreach( m_flashlight in a_flashlights )
	{
		PlayFXOnTag( level._effect["flashlight"], m_flashlight, "tag_origin" );
	}
	
	scene_wait( "hallway_flashlights_enter" );
	array_delete( a_flashlights );
	
	level thread run_scene( "hallway_flashlights_loop" );
	a_flashlights = get_model_or_models_from_scene( "hallway_flashlights_loop" );
	foreach( m_flashlight in a_flashlights )
	{
		PlayFXOnTag( level._effect["flashlight"], m_flashlight, "origin_animate_jnt" );
	}	
	
	flag_wait( "clinic_stairwell_top" );
	array_delete( a_flashlights );
}

building_stairwell_player_fire_listener()
{
	level endon( "clinic_stairwell_top" );
	
	trigger_off( "building_hallway_dmg", "targetname" );
	
	level.player waittill( "weapon_fired" );
	flag_set( "post_gauntlet_player_fired" );
	
	IPrintLn( "Soldier: Contact - Front" );
	wait( .5 );
	
	level thread building_stairwell_soldier_fire( "flashlight_hall_shot_start_1", "flashlight_hall_shot_end_1" );
	level thread building_stairwell_soldier_fire( "flashlight_hall_shot_start_2", "flashlight_hall_shot_end_2" );
	
	//bullet lights
	exploder( 540 );
	
	//damage trigger
	trigger_on( "building_hallway_dmg", "targetname" );
}

building_stairwell_soldier_fire( str_start_struct, str_end_struct )
{
	level endon( "clinic_stairwell_top" );
	
	n_burst_count_min		= 12;
	n_burst_count_max		= 15;
	n_burst_delay_min		= .1;
	n_burst_delay_max		= .15;
	n_post_burst_delay_min	= .2;
	n_post_burst_delay_max	= .3;
	
	a_start_structs = GetStructArray( str_start_struct, "targetname" );
	a_end_structs = GetStructArray( str_end_struct, "targetname" );
	
	while( true )
	{
		n_burst_count = RandomIntRange( n_burst_count_min, n_burst_count_max );
		for( i = 0;	i < n_burst_count; i++ )
		{
			s_start = a_start_structs[ RandomInt( a_start_structs.size ) ];
			s_end = a_end_structs[ RandomInt( a_end_structs.size ) ];
			MagicBullet( "m16_sp", 	s_start.origin, s_end.origin );
			
			wait RandomFloatRange( n_burst_delay_min, n_burst_delay_max );
		}
		
		wait RandomFloatRange( n_post_burst_delay_min, n_post_burst_delay_max );
	}
}
