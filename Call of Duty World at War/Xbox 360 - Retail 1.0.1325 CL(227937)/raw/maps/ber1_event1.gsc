// scripting by Bloodlust
// level design by BSouds

#include maps\_anim;
#include maps\_utility;
#include maps\ber1_util;
#include maps\pel2_util;
#include common_scripts\utility;
#include maps\_music;

#using_animtree("generic_human");

// main function for handling Event 1
main()
{
	train_ride();
}



train_ride()
{

	//Kevin's notify for train sounds.
	SetClientSysState("levelNotify","train_ride");	
	
	level thread trainride_vo();
	level thread exit_train_pathing();
	level thread populate_katyusha_crews();
	
	//disable player weapons
	players = get_players();
	for( i = 0; i < players.size; i++ )
	{
		players[i] disableWeapons();
	}
	
	russians = getaiarray( "allies" );
	russians = put_reznov_in_spot_8( russians );
	for( i = 0; i < russians.size; i++ )
	{
		russians[i].animname = "russian_" + (i);
		russians[i].ignoreall = true;
		russians[i].ignoreme = true;
		
		// to prevent clipping issue
		if( russians[i].animname == "russian_10" )
		{
			russians[i] detach( russians[i].gearModel );
		}
		
	}
	
	//TUEY set music state to INTRO
	setmusicstate("INTRO");

	boxcar = getEnt( "boxcar_intro", "targetname" );
	boxcar.animname = "boxcar";
	org = boxcar getTagOrigin( "tag_origin" );
	
	boxcar thread maps\ber1_anim::close_traincar_door();
	
	link_train_cars();
	level thread unload_train_drones();

	wait_network_frame();

	event1_threads();
	spawn_tanks();
	
	players = get_players();
	players[0] thread train_turbulence();

	// Jesse: Changed the order of linkTo and the anim_single calls to prevent crazy flipping guys
	for( i = 0; i < russians.size; i++ )
	{
		russians[i] linkTo( boxcar, "tag_origin" );
	}
	
	
	
	
	
	
	
	
	// Squad Anims for getting out of the train
	/////////////////////////////
	
	
//	delayed_guys = undefined;
	
	for( i = 0; i < russians.size; i++ )
	{
		
		anime = "train_intro_" + i;

//		russians[i] thread event1_unlink_at_animation_end( anime , boxcar );

		// guys that have 3 anims to play (includes idle) to exit the train
		if( i == 3 || i == 5 || i == 7 )
		{
//			delayed_guys = add_to_array( delayed_guys, russians[i] );					
			russians[i] thread train_exit_triple_anim( boxcar, i );
		}
		// guys that have 2 anims to play to exit the train
		else
		{

			russians[i] thread train_exit_double_anim( boxcar );
			// play their intro animations
//			boxcar thread anim_single_solo_earlyout( russians[i], anime, "tag_origin", undefined, undefined, undefined, 0.25 );			
		}
	
		
	}






	players = get_Players();

	link_players_to_train( boxcar, players );
	boxcar thread move_train( boxcar );
	
	// TRAIN IS STOPPED
	/////////////////////
	flag_wait( "train_has_stopped" );
	
	wait( 6 );
	
	unlink_players_from_train( players );
//	level thread delayed_train_exit( boxcar, delayed_guys );
	
	intro_barrage();
	
}



train_exit_double_anim( boxcar )
{

	boxcar anim_single_solo( self, "train_intro", "tag_origin" );
	
	self Unlink();
	
	boxcar anim_single_solo_earlyout( self, "train_intro_exit", "tag_origin", undefined, undefined, undefined, 0.25 );
	
}



train_exit_triple_anim( boxcar, index )
{
	
	boxcar anim_single_solo( self, "train_intro", "tag_origin" );
	
	self Unlink();
	
	// stagger the guys by having them play the same idle over again
	if( index == 3 )
	{
//		self thread guzzo_print_3d( "wait guy 1" );
		level thread anim_loop_solo( self, "train_intro_idle", "tag_origin", "end_train_idle_1", boxcar  );
		wait( 4 );
		level notify( "end_train_idle_1" );
	}
	if( index == 5 )
	{
//		self thread guzzo_print_3d( "wait guy 2" );
		level thread anim_loop_solo( self, "train_intro_idle", "tag_origin", "end_train_idle_2", boxcar  );		
		wait( 4.5 );
		level notify( "end_train_idle_2" );
	}
	if( index == 7 )
	{
//		self thread guzzo_print_3d( "wait guy 3" );
		level thread anim_loop_solo( self, "train_intro_idle", "tag_origin", "end_train_idle_3", boxcar  );		
		wait( 5 );
		level notify( "end_train_idle_3" );
	}
	
	boxcar anim_single_solo_earlyout( self, "train_intro_exit", "tag_origin", undefined, undefined, undefined, 0.25 );	
	
}



///////////////////
//
// handles guys that exit the train slightly later in order to avoid bunching up
//
///////////////////////////////

//delayed_train_exit( boxcar, guys )
//{
//
//	boxcar anim_single( guys, "train_intro_idle", "tag_origin" );
//
////	wait( 4.85 );
////	boxcar thread anim_single_earlyout( guys_to_animate, "train_intro_delayed", "tag_origin", undefined, undefined, undefined, 0.25 );
//	
//	
//	// get the guys that are meant to exit later
//	for( i  = 0; i < guys.size; i++ )
//	{
//		
//		if( isdefined( guys_to_check[i].animname ) && ( guys_to_check[i].animname == "russian_3" ) )
//		{
//			boxcar thread anim_single_solo_earlyout( guys_to_check[i], "train_intro_delayed", "tag_origin", undefined, undefined, undefined, 0.25 );
//		}
//		else if( isdefined( guys_to_check[i].animname ) && ( guys_to_check[i].animname == "russian_5" ) )
//		{
//			wait( 1 );
//			boxcar thread anim_single_solo_earlyout( guys_to_check[i], "train_intro_delayed", "tag_origin", undefined, undefined, undefined, 0.25 );
//		}
//		else if( isdefined( guys_to_check[i].animname ) && ( guys_to_check[i].animname == "russian_7" ) )
//		{
//			wait( 1 );
//			boxcar thread anim_single_solo_earlyout( guys_to_check[i], "train_intro_delayed", "tag_origin", undefined, undefined, undefined, 0.25 );
//		}				
//		
//	}	
//	
//}



event1_unlink_at_animation_end( anime, boxcar )
{
	
	anim_time = GetAnimLength( level.scr_anim[self.animname][anime] ); 
	wait( anim_time - 0.25 );	
//	boxcar waittill( anime );

	self Unlink();
}



link_players_to_train( boxcar, players )
{

	// link players to their start points for the train ride	
	level.train_attach_points = [];
	for( i = 0; i < 4; i++ )
	{
		level.train_attach_points[i] = getent( "player_train_start" + i, "targetname" );
		level.train_attach_points[i] linkTo( boxcar );
	}

	for( i = 0; i < players.size; i++ )
	{
		players[i] setOrigin( level.train_attach_points[i].origin );
		players[i] playerLinkTo( level.train_attach_points[i] );
	}

	level.players_linked_to_train = true;
	
}



unlink_players_from_train( players )
{
	
	level.players_linked_to_train = false;

	// unlink player and start points
	for( i = 0; i < 4; i++ )
	{
		level.train_attach_points[i] unlink();
	}
	
	for(i = 0; i < players.size; i++)
	{
		players[i] unlink();
		players[i] enableWeapons();
	}
	
	// delete player start points
	for( i = 0; i < 4; i++ )
	{
		level.train_attach_points[i] delete();
	}	
	
}



populate_katyusha_crews()
{


	// LEFT TRUCK

	left_truck = getent( "katyusha_left_truck", "targetname" );
	
	// driver
	guy_1 = Spawn( "script_model", left_truck.origin );
	guy_1 character\char_rus_r_rifle::main();
	guy_1 UseAnimTree( #animtree );
	guy_1.animname = "truck";
	guy_1 detach( guy_1.hatModel );
	guy_1 detach( guy_1.gearModel );	
	
	left_truck thread anim_loop_solo( guy_1, "driver_sit_idle", "tag_driver", "stop_temp_loop" );		
	
	
	
	// CENTER TRUCK
	
	center_truck = getent( "katyusha_center_truck", "targetname" );

//	// guy in back
//	guy_2 = Spawn( "script_model", center_truck.origin );
//	guy_2 character\char_rus_r_rifle::main();
//	guy_2 UseAnimTree( #animtree );
//	guy_2.animname = "truck";
//	guy_2 detach( guy_2.hatModel );
//	guy_2 detach( guy_2.gearModel );		
//	
//	spot = getstruct( "orig_katyusha_back", "targetname" );
//	center_truck thread anim_loop_solo( guy_2, "katyusha_idle_1", undefined, "stop_temp_loop", spot );	

	// driver
	guy_3 = Spawn( "script_model", center_truck.origin );
	guy_3 character\char_rus_r_rifle::main();
	guy_3 UseAnimTree( #animtree );
	guy_3.animname = "truck";
	guy_3 detach( guy_3.hatModel );
	guy_3 detach( guy_3.gearModel );	
	
	center_truck thread anim_loop_solo( guy_3, "driver_sit_idle", "tag_driver", "stop_temp_loop" );	



	// RIGHT TRUCK

	right_truck = getent( "katyusha_right_truck", "targetname" );
	
	// driver
	guy_4 = Spawn( "script_model", right_truck.origin );
	guy_4 character\char_rus_r_rifle::main();
	guy_4 UseAnimTree( #animtree );
	guy_4.animname = "truck";
	guy_4 detach( guy_4.hatModel );
	guy_4 detach( guy_4.gearModel );	
	
	right_truck thread anim_loop_solo( guy_4, "driver_sit_idle", "tag_driver", "stop_temp_loop" );		



	flag_wait( "office_door_kick_trigger" );

	// TODO
//	at some point, just delete these guys
	
	guy_1 delete();
//	guy_2 delete();
	guy_3 delete();
	guy_4 delete();
	
}



///////////////////
//
// put reznov in index 8 of the array, so he is in the correct position for the animation
//
///////////////////////////////

put_reznov_in_spot_8( ai_array )
{

	// get reznov's index
	for( i  = 0; i < ai_array.size; i++ )
	{
		if( ai_array[i] == level.reznov )
		{
			break;	
		}
	}
	
	reznov_index = i;
	
	// swap their places in the array (we can always assume the heros are in spots 0,1,2 in the array initially, as they're not spawners)
	assertex( !is_in_array( level.heroes, ai_array[8] ), "a hero is in spot 8 of the allies array, not good!" );
	ai_array[reznov_index] = ai_array[8];
	ai_array[8] = level.reznov;
	
	return ai_array;
	
}



exit_train_pathing()
{

	allies = getaiarray( "allies" );

	trig = getent( "exit_boxcar_trigger", "targetname" );

//	println( "***" );
//	println( "*** exit_train debug guys: " + allies.size );

	for( i  = 0; i < allies.size; i++ )
	{
		allies[i].disablearrivals = true;
		allies[i].disableexits = true;
		allies[i] thread exit_train_pathing_assign( trig );
	}
	
}



exit_train_pathing_assign( trig )
{

	while( 1 )
	{

		if( self istouching( trig ) )
		{
			
			self.exit_train_pathing_num = level.exit_train_pathing_num;
			level.exit_train_pathing_num++;
			self.goalradius = 20;
			goal_node = getnode( "exit_train_pathing_" + self.exit_train_pathing_num, "targetname" );
			self setgoalnode( goal_node );
			
			self thread delay_exits_arrivals_on();
			
			println( "***" );
			println( "*** exit_train debug: " + self.exit_train_pathing_num );
			
			break;				
			
		}
	
		wait( 0.05 );
		
	}
	
}



delay_exits_arrivals_on()
{
	
	self endon( "death" );
	
	wait( 3 );
	
	self.disablearrivals = false;
	self.disableexits = false;
		
}



berm_pathing()
{

	allies = getaiarray( "allies" );
	for( i  = 0; i < allies.size; i++ )
	{
		
		if( isdefined( allies[i].exit_train_pathing_num ) )
		{
			goal_node = getnode( "berm_pathing_" + allies[i].exit_train_pathing_num, "targetname" );
			allies[i] thread berm_pathing_think( goal_node );
		}
		
	}
	
	
}


berm_pathing_think( goal_node )
{
	
	self endon( "death" );
	
	if( self.exit_train_pathing_num > 3 && self.exit_train_pathing_num <= 7 )
	{
		wait( 0.9 );
	}
	else if( self.exit_train_pathing_num > 7 && self.exit_train_pathing_num <= 11 )
	{
		wait( 1.7 );	
	}
	else if( self.exit_train_pathing_num > 11 && self.exit_train_pathing_num <= 15 )
	{
		wait( 2.6 );	
	}	
	
	if( isdefined( self.node ) && isdefined( self.node.script_delay ) )
	{
		wait( self.node.script_delay );
	}
	
	self.goalradius = 20;
	
	self setgoalnode( goal_node );	
	
	self waittill( "goal" );
	
	if( isdefined( goal_node.script_delay ) )
	{
		wait( goal_node.script_delay );	
	}
	
	new_goal = getnode( "ruins_pathing_" + self.exit_train_pathing_num, "targetname" );
	self setgoalnode( new_goal );	
	
	if( !isdefined( self.script_no_respawn ) )
	{
		self thread replace_on_death();
	}
	
	if( self == level.chernov || self == level.reznov || self == level.commissar )
	{
		self set_force_color( "c" );
	}
	else
	{
		if( self.exit_train_pathing_num < 8 )
		{
			self set_force_color( "r" );	
		}
		else
		{
			self set_force_color( "y" );	
		}
	}
	
}



trainride_vo()
{
	
	battlechatter_off();
	
	wait( 6.25 );
	
	play_vo( level.reznov, "russian_0", "on_your_feet" );
	
	wait( 7 );
	
	play_vo( level.chernov, "russian_0", "fuhrers_bday" );
	
	wait( 7.9 );
	
	play_vo( level.chernov, "russian_0", "with_your_bullets" );

	wait( 3 );

	play_vo( level.chernov, "russian_0", "do_the_same" );	
	
	wait( 3 );
	
}



berm_vo()
{

	level endon( "move_tank_3_2" );

	wait( 1 );

	play_vo( level.reznov, "vo", "charge!!!" );
	
	wait( RandomIntRange( 7, 9 ) );
	
	play_vo( level.reznov, "vo", "keep_moving" );
	
	battlechatter_on();
	
}



ruins_vo()
{

	level endon( "start_clocktower_vo" );

	flag_wait( "move_tank_3_2" );

	play_vo( level.commissar, "vo", "move_up_tanks" );
	
	wait( 3 );
	
	play_vo( level.reznov, "vo", "use_for_cover" );

	if(NumRemoteClients())	// Clear up space in the snapshot for coop by doing bad things to our allies.
	{
		allies = getaiarray( "allies" );
		
		for(i = 0; i < allies.size; i ++)
		{
			if(!is_in_array( level.heroes, allies[i] ))
			{
				allies[i] disable_replace_on_death();  
				allies[i] thread bloody_death( true, 12 + RandomFloat(31) );	// Poor red Squad, they never stood a chance in coop.
			}
		}
	}


	// wait till the battle kicks off
	flag_wait( "ruins_battle_2" );
	
	play_vo( level.reznov, "vo", "the_rats" );
	
	wait( 2.2 );
	
	play_vo( level.reznov, "vo", "clear_every" );
	
	wait( 2.2 );
	
	play_vo( level.reznov, "vo", "more_upper_floor" );
	
	// wait till the retreat
	flag_wait( "ruins_retreat_trig" );
	
	play_vo( level.chernov, "vo", "they_are_running" );
	
	wait( 2.4 );
	
	play_vo( level.reznov, "vo", "of_course" );
	
	wait( 4 );
	
	play_vo( level.reznov, "vo", "wipe_them_out" );
		
		
}



clocktower_vo()
{

	level notify( "start_clocktower_vo" );

	play_vo( level.chernov, "vo", "setup_defenses" );
	
	wait( 3.75 );
	
	play_vo( level.reznov, "vo", "mg!!!" );
	
	wait( randomfloatrange( 1.5, 2.4 ) );
	
	play_vo( level.reznov, "vo", "stay_in_cover" );
	
	wait( randomfloatrange( 3.0, 3.75 ) );

	play_vo( level.reznov, "vo", "panzerschrek!" );
	
	wait( randomfloatrange( 2.0, 3.5 ) );
	
	// only play if player is not on the 2nd floor already
	players = get_players();
	if( isdefined( players[0] ) && players[0].origin[2] > -260 )
	{
		play_vo( level.reznov, "vo", "find_a_better" );
		wait( 2 );
	}
	
	level thread clocktower_2_vo();
	
}



clocktower_2_vo()
{

	weakening_vo_played = false;
	last_chosen_index = undefined;

	while( !flag( "move_tanks_3" ) )
	{
		
		skipping_wait = false;
		
		if( !weakening_vo_played )
		{
			
			schreks_and_mgs_count = get_ai_group_count( "tank_suppressor_ai" ) + get_ai_group_count( "office_mgs" );
			if( schreks_and_mgs_count <= 2 )
			{
				play_vo( level.reznov, "vo", "they_are_weakening" );
				weakening_vo_played = true;
				wait( randomfloatrange( 5.5, 7.0 ) );
			}
		
		}
	
		
		vo_index = randomint( 11 );
		
		// make sure we don't play the same line twice in a row
		if( isdefined( last_chosen_index ) )
		{
			
			while( last_chosen_index == vo_index )
			{
				vo_index = randomint( 11 );
				wait( 0.05 );
			}
			
		}		
		
		switch( vo_index )
		{
		
			case 0:
				
				// only play this if some have been killed
				schreks_and_mgs_count = get_ai_group_count( "tank_suppressor_ai" ) + get_ai_group_count( "office_mgs" );
				if( schreks_and_mgs_count < 3 )
				{
					play_vo( level.reznov, "vo", "they_are_still_holding" );
					skipping_wait = true;
					wait( 0.05 );
				}
				break;
			
			case 1:
				
				play_vo( level.reznov, "vo", "destroy_every_last" );
				break;
			
			case 2:
				
				// only play this if there are p-schreks remaining	
				schreks_count = get_ai_group_ai( "tank_suppressor_ai" );
				if( schreks_count.size )
				{
					play_vo( level.reznov, "vo", "watch_for_panzers" );
				}
				else
				{
					skipping_wait = true;
					wait( 0.05 );
				}
				break;
				
			case 3:					
			
				play_vo( level.reznov, "vo", "break_their_line" );
				break;
			
			case 4:
				play_vo( level.reznov, "vo", "concentrate_fire" );
				break;
			
			case 5:
			
				play_vo( level.reznov, "vo", "finish_them" );
				break;
			
			case 6:
			
				play_vo( level.reznov, "vo", "keep_fire_on" );
				break;
			
			case 7:
			
				// only play this if there are p-schreks remaining	
				schreks_count = get_ai_group_ai( "tank_suppressor_ai" );
				if( schreks_count.size )
				{
					play_vo( level.reznov, "vo", "panzerschrek!" );
				}
				else
				{
					skipping_wait = true;
					wait( 0.05 );
				}				
				break;
		
			case 8:
		
				play_vo( level.reznov, "vo", "quickly_dimitri" );
				break;
			
			case 9:
			
				play_vo( level.reznov, "vo", "fire_again" );
				break;
			
			case 10:
			
				play_vo( level.reznov, "vo", "take_it_out" );		
				break;
				
				
		} // end switch
			
		last_chosen_index = vo_index;			
			
		if( !skipping_wait )
		{
			wait( randomfloatrange( 9, 14.0 ) );
		}
		
	} // end while
	
}



wall_crumble_vo()
{

	play_vo( level.chernov, "vo", "how_are_we_to" );
	
	wait( 3 );
	
	play_vo( level.chernov, "vo", "brute_force" );
	
}



spawn_tanks()
{
	
	maps\_vehicle::create_vehicle_from_spawngroup_and_gopath( 0 );
	flag_set( "spawn_tanks" );	
	
}



intro_barrage()
{

	// no need waving on an empty boxcar...
	level.waver1 notify( "stop_whistle" );
	
	// flag set on trigger
	flag_wait( "katyusha_wait" );
	
	flag_set( "calling_intro_barrage" );
	
	quick_text( "katyusha_barrage", 3, true );
	
	level thread intro_barrage_quake();
	
	// time the aftermath with the rockets hitting the ground, plus a little bit of time
	wait( 4 );
	
	org = getStruct( "aftermath_origin", "targetname" );	
	playfx( level._effect["barrage_aftermath"], org.origin );

	flag_wait( "intro_barrage_complete" );

	level thread berm_vo();
	
	blocker = getent( "brush_barrage_blocker", "targetname" );
	blocker connectpaths();
	blocker delete();
	
	autosave_by_name( "Ber1 ruins start" );
	
	//Tuey Set music state to First Fight
	setmusicstate("FIRST_FIGHT");
	
	flag_set( "ruins_charge" );
	flag_set( "objective_ruins" );
	flag_set( "move_tanks_1" );
	
	level thread ruins_vo();
	
	// reset drone run speed
	level.drone_run_speed = 120;
		
	level.waver1 playsound( "sgt_yell" );
	
	wait( 2 );
	
	berm_pathing();
	
	level thread spawn_ruins_pickup_weapons();
	level thread reset_squad_ignore_state();
}



intro_barrage_quake()
{

	wait( 1.9 );
	PlayRumbleOnPosition( "ber1_barrage", (-101, -5393, -502.3) ); 
	wait( 1.9 );
	earthquake( 0.5, 2.5, (-101, -5393, -502.3), 1000 );	
	
}



ruins_battle()
{

	level thread shutter_open_init();
	level thread rejoin_squad();
	level thread rejoin_squad_2();
	level thread save_mid_ruins();

	// flag set on trigger
	flag_wait( "ruins_battle_start" );
	quick_text( "ruins_battle_start" );

	maps\_debug::set_event_printname( "Ruins" );

	// Wii optimizations
	if( !level.wii && !NumRemoteClients())
	{
		simple_spawn( "ruins_retreaters_initial" );
	}
	
	wait( 1.5 );
	simple_floodspawn( "ruins_retreaters_right" );
	wait_network_frame(); // CLIENTSIDE to help snapshot size
	simple_floodspawn( "ruins_retreaters_left" );
	wait_network_frame(); // CLIENTSIDE to help snapshot size
	
	// Wii optimizations
	if( !level.wii && !NumRemoteClients())
	{
		simple_spawn( "ruins_retreaters_center" );
	}
	
	// Wii optimizations
	if( level.wii )
	{
		thin_out_ruins_allies_for_wii( 2 );	
	}
	
	// flag set on trigger
	flag_wait( "ruins_battle_2" );
	quick_text( "ruins_battle_2" );
	
	set_color_chain( "colortrig_r2" );
	
	ruins_battle_2();
	
}



ruins_battle_2()
{

	level thread trig_clocktower_vo();
	
	wait( 1 );
	
	// Wii optimizations
	if( level.wii )
	{
		thin_out_ruins_allies_for_wii( 2 );	
	}	
	
	simple_floodspawn( "ruins_house_guys" );
	wait_network_frame(); // CLIENTSIDE to help snapshot size
	
//	SetIgnoreMeGroup( "players", "panzershreck_threat" );
	
	// Wii optimizations
	if( !level.wii )
	{
		simple_floodspawn( "office_gunners", ::ruins_gunners_strat );
	}
	else
	{
		level thread wii_wait_to_spawn_clock_gunners();
	}
	
	// kick off next wave if most house guys have been killed
	level thread ruins_retreat_trig_early();
	
	// flag set on trigger
	flag_wait( "ruins_retreat_trig" );
	
	level thread ruins_retreat_reaction();	
	
	autosave_by_name( "Ber1 ruins retreat" );
	
	simple_floodspawn( "office_defend_spawners" );
	
	objective_string( 2, &"BER1_CLEAR_CLOCKTOWER" );
	objective_position( 2, (944, -368, -229.6) );
	
	clock_tower_battle();
	
}



wii_wait_to_spawn_clock_gunners()
{
	flag_wait( "ruins_retreat_trig" );
	simple_floodspawn( "office_gunners", ::ruins_gunners_strat );
}



thin_out_ruins_allies_for_wii( guys_to_kill )
{

	guys_thinned_out = 0;

	allies = getaiarray( "allies" );
	for( i  = 0; i < allies.size; i++ )
	{
		if( isdefined( allies[i].script_no_respawn ) )
		{
			
			println( "wii script optimization: about to kill off guy at: " + allies[i].origin );
			
			allies[i] thread bloody_death( true );	
			
			guys_thinned_out++;	
			if( guys_thinned_out == guys_to_kill )
			{
				break;	
			}
		}
	}
	
}



trig_clocktower_vo()
{
	trigger_wait( "trig_clocktower_vo", "script_noteworthy" );
	clocktower_vo();
}



///////////////////
//
// have guys fallback, killspawn floodspawners, and send up friendlies
//
///////////////////////////////

ruins_retreat_reaction()
{
	
	// killspawner
	trig = getent( "trig_killspawner_100", "targetname" );
	if( isdefined( trig ) )
	{
		trig notify( "trigger" );			
	}	
	
	// notify comes from script_notify on color chain trigger further past the buildings
	level endon( "trig_chain_ruins_end" );
	
	// only move up guys if enough of the building axis have been killed (if the player moves far ahead enough though the squad will move up)
	while( 1 )
	{
	
		left_ai = get_ai_group_count( "ruins_retreaters_left_ai" );
		right_ai = get_ai_group_count( "ruins_retreaters_right_ai" );
		top_ai = get_ai_group_count( "ruins_house_ai" );	
	
		total_ai_count = left_ai + right_ai + top_ai;
		
		if( total_ai_count < 6 )
		{
			break;
		}
	
		wait( 0.75 );
			
	}	

	// fallback guys
	trig = getent( "trig_fallback_100", "targetname" );
	trig notify( "trigger" );

	trig = getent( "trig_fallback_101", "targetname" );
	trig notify( "trigger" );

	//give fallbackers a bit of a headstart before moving up friendlies
	wait( RandomFloatRange( 0.75, 1.5 ) );

	// color chain
	trig = getent( "colortrig_r3", "targetname" );
	if( isdefined( trig ) )
	{
		trig notify( "trigger" );			
	}
	
}



///////////////////
//
// Handles the clock tower battle and when it's over
//
///////////////////////////////

clock_tower_battle()
{

	setup_clock_mgs();

	level thread office_panzers_target_tanks();
	level thread clock_tower_exploders();
	level thread tank_shreck_ricochet();
	level thread office_mgs_threatbias();
	
	blocker = getent( "blocker_clock_tank_2", "targetname" );
	blocker notsolid();
	blocker connectpaths();
	
	num_regular_guys_to_kill = undefined;

	// Wii optimizations
	if( level.wii )
	{
		wait( 1 ); // should wait a bit b/c on the wii the gunners are spawned on the preceding frame
		num_regular_guys_to_kill = 4; // wii has less spawners here, so adjust accordingly
	}
	else
	{
		num_regular_guys_to_kill = 7;
	}


	while( 1 )
	{
	
		clock_ai = get_ai_group_count( "office_guys" );
		schreks_and_mgs_count = get_ai_group_count( "tank_suppressor_ai" ) + get_ai_group_count( "office_mgs" );
	
		if( clock_ai < num_regular_guys_to_kill || !schreks_and_mgs_count )
		{
			break;
		}
	
		wait( 0.5 );
			
	}	
	
	
	quick_text( "moving tank up to shoot clocktower!" );
	
	level thread chain_closer_to_clock_tower();
	
	flag_set( "move_tanks_3" );

	level thread office_guys_retreat_inside();
	
	flag_wait( "office_wall_done" );
	
	office_building();	
	
}



///////////////////
//
// handles walls that explode
//
///////////////////////////////

clock_tower_exploders()
{
	level thread clock_tower_exploder_110();
	level thread clock_tower_exploder_111();
	level thread clock_tower_exploder_112();
	level thread clock_tower_exploder_113();	
}



///////////////////
//
// make sure clocktower mg guys don't jump off the mgs
//
///////////////////////////////

setup_clock_mgs()
{

	mg = getent( "office_mg_door", "script_noteworthy" );
	mg setturretignoregoals( true );
	
	mg = getent( "ruins_mg", "script_noteworthy" );
	mg setturretignoregoals( true );	
	
}



clock_tower_exploder_110()
{

	// notify from flag on trigger
	level endon( "tank_go_through_wall" );

	dmg_trigger = getent( "exploder_110", "targetname" );
	dmg_trigger waittill( "trigger" );
	
	mg_sandbag_cleanup( "auto1955", 103 );
	
	dmg_trigger delete();
	
}



clock_tower_exploder_111()
{

	// notify from flag on trigger
	level endon( "tank_go_through_wall" );

	dmg_trigger = getent( "exploder_111", "targetname" );
	dmg_trigger waittill( "trigger" );
	
	radiusdamage( (991.2, -755.2, -51.5), 120, 130, 80 );
	
	dmg_trigger delete();
	
}



clock_tower_exploder_112()
{

	// notify from flag on trigger
	level endon( "tank_go_through_wall" );

	dmg_trigger = getent( "exploder_112", "targetname" );
	dmg_trigger waittill( "trigger" );
	
	radiusdamage( (987.2, -757.2, 67.5), 120, 130, 80 );
	
	dmg_trigger delete();
	
}



clock_tower_exploder_113()
{

	// notify from flag on trigger
	level endon( "tank_go_through_wall" );

	dmg_trigger = getent( "exploder_113", "targetname" );
	dmg_trigger waittill( "trigger" );
	
	mg_sandbag_cleanup( "office_shelf_mg", 104 );
	
	dmg_trigger delete();
	
}



office_panzers_target_tanks()
{

	wait( randomintrange( 3, 5 ) );
	
	// get the origins moving so the guys appear to fire at new locations every time
	shrek_target = getent( "orig_office_panzers_targets_1", "targetname" );
	shrek_target.health = 1000000;
	level thread flame_move_target( shrek_target, 6 );		
	
	shrek_target = getent( "orig_office_panzers_targets_2", "targetname" );
	shrek_target.health = 1000000;
	level thread flame_move_target( shrek_target, 6 );		
	
	shrek_target = getent( "orig_office_panzers_targets_3", "targetname" );
	shrek_target.health = 1000000;
	level thread flame_move_target( shrek_target, 6 );		
	
	simple_spawn( "tank_suppressor_spawner", ::tank_suppressor_spawner_strat );
	
	flag_wait( "move_tanks_3" );
	
	guys = get_ai_group_ai( "tank_suppressor_ai" );
	
	for( i  = 0; i < guys.size; i++ )
	{
		
		guys[i] ClearEntityTarget();
		
		if( guys[i].script_noteworthy == "orig_office_panzers_targets_1" )
		{
			goal = getnode( "orig_office_panzers_targets_1", "targetname" );
		}
		else
		{
			goal = getnode( "orig_office_panzers_targets_2", "targetname" );
			
		}
		
		guys[i] thread guy_run_to_node_and_delete( goal );
		
	}
	
}



tank_suppressor_spawner_strat()
{

	self endon( "death" );
	level endon( "move_tanks_3" );
	
	//self thread tank_suppressor_spawner_death();
	
	self.ignoreme = true;
	self.ignoresuppression = true;
	
	self.a.rockets = 100;
	
	target = getent( self.script_noteworthy, "targetname" );
	
	while( 1 )
	{
	
		wait( RandomFloatRange( 1, 2.5 ) );
	
		self SetEntityTarget( target );
		
		wait( RandomIntRange( 5, 8 ) );
		
		self ClearEntityTarget();		
		
	}
	
}



///////////////////
//
// keeps track of how many of these guys were killed
//
///////////////////////////////

//tank_suppressor_spawner_death()
//{
//	self waittill( "death" );
//}



guy_run_to_node_and_delete( node )
{

	self endon( "death" );
	
	self setgoalnode( node );
	
	self waittill( "goal" );
	
	self delete();
	
}



///////////////////
//
// move color chain closer to clocktower
//
///////////////////////////////

chain_closer_to_clock_tower()
{
	wait( RandomIntRange( 4, 6 ) );
	set_color_chain( "chain_closer_to_clock_tower" );
}



///////////////////
//
// have the guys outside of the office building retreat inside when the tanks move up
//
///////////////////////////////

office_guys_retreat_inside()
{

	//TUEY SET MUSIC STATE TO TANK_ROLLS_IN
	setmusicstate("TANK_ROLLS_IN");
	
	// turn off spawners
	maps\_spawner::kill_spawnernum( 101 );
	maps\_spawner::kill_spawnernum( 104 );
	
	retreat_nodes = getnodearray( "node_office_retreat", "targetname" );
	
	guys_in_volume = getAIarrayTouchingVolume( "axis", "vol_office_outside" );
	
	quick_text( "retreating " + guys_in_volume.size + " guys to office" );
	
	for( i  = 0; i < guys_in_volume.size; i++ )
	{
	
		// in case there are more retreat guys than nodes...
		if( !isdefined( retreat_nodes[i] ) )
		{
			break;	
		}
		
		guys_in_volume[i].goalradius = 30;
		guys_in_volume[i].ignoresuppression = true;
		guys_in_volume[i] setgoalnode( retreat_nodes[i] );
		
	}
	
	getent( "vol_office_outside", "targetname" ) delete();
	
	// failsafe for this guy
	panzer_killer = get_specific_single_ai( "office_panzer_killer_ai" );
	if( isdefined( panzer_killer ) )
	{
		panzer_killer setcandamage( true );
	}
	
}



///////////////////
//
// kick off next wave if most house guys have been killed
//
///////////////////////////////

ruins_retreat_trig_early()
{
	
	while( 1 )
	{
	
		left_ai = get_ai_group_count( "ruins_retreaters_left_ai" );
		right_ai = get_ai_group_count( "ruins_retreaters_right_ai" );
		top_ai = get_ai_group_count( "ruins_house_ai" );	
	
		total_ai_count = left_ai + right_ai + top_ai;
		
		if( total_ai_count < 5 )
		{
			quick_text( "ruins_retreat_trig_early!" );
			break;
		}
	
		wait( 0.75 );
			
	}

	trig = getent( "ruins_retreat_trig", "script_noteworthy" );
	if( isdefined( trig ) )
	{
		trig notify( "trigger" );			
	}

}



ruins_gunners_strat()
{
	
	level endon( "start_office_building" );
	
	self setthreatbiasgroup( "office_gunner_threat" );
	
	self waittill( "death" );
	
	wait( randomfloatrange( 0.25, 0.9 ) );
	
	if( !level.playing_reznov_yes_vo )
	{
		level.playing_reznov_yes_vo = true;
		play_vo( level.reznov, "vo", "yes!!!" );
		wait( 2 );
		level.playing_reznov_yes_vo = false;
	}
	
}




///////////////////
//
// used for ruins skipto only
//
///////////////////////////////

ruins_split_color_squads()
{
	
	allies = getaiarray( "allies" );
	
	for (i = 0; i < allies.size; i++)
	{
		
		allies[i] thread replace_on_death();
		
		// if is an even number of the array
		if ( i % 2 == 0 )
		{
			allies[i] set_force_color("y");
		}
		else // odd
		{
			allies[i] set_force_color("r");
		}
	}
	
	set_color_heroes( "c" );
	
}



///////////////////
//
// sets up shutters that open
//
///////////////////////////////

shutter_open_init()
{
	
	shutter_pair_1 = [];
	shutter_pair_1[0] = getent( "l_shutter3", "script_noteworthy" ); 
	shutter_pair_1[1] = getent( "r_shutter3", "script_noteworthy" );
	
	level thread shutterpair_open_watch( shutter_pair_1 );
	
	shutter_pair_3 = [];		
	shutter_pair_3[0] = getent( "l_shutter1", "script_noteworthy" ); 
	shutter_pair_3[1] = getent( "r_shutter1", "script_noteworthy" );	

	level thread shutterpair_open_watch( shutter_pair_3 );	
	
}



///////////////////
//
// this opens the shutter when AI are nearby
//
///////////////////////////////

shutterpair_open_watch( shutterpair )
{
	
	while( 1 )
	{
		
		axis = getaiarray( "axis" );
		
		for (i = 0; i < axis.size; i++)
		{
			
			if ( distancesquared(axis[i].origin, shutterpair[0].origin) < 70 * 70 )
			{
				shutterpair_open( shutterpair );
				return;
			}
			
			else if ( distancesquared(axis[i].origin, shutterpair[1].origin) < 70 * 70 )
			{
				shutterpair_open( shutterpair );
				return;
			}
			
		}
		
		wait( 0.2 );
		
	}
	
}



// actually open the shutters
shutterpair_open( shutterpair )
{
	
	// get the origin that points to the shutter
	shutterpair[0].linker = getent( shutterpair[0].targetname, "target" );
	shutterpair[1].linker = getent( shutterpair[1].targetname, "target" );
	
	// link to the point
	shutterpair[0] linkto ( shutterpair[0].linker );
	shutterpair[1] linkto ( shutterpair[1].linker );
	
	wait( randomfloatrange( 0.1, 1.25 ) );
	
	level thread shutterpair_move( shutterpair );
	
}



// sometime the left one will open first, sometimes the second
shutterpair_move( shutterpair )
{
	
	if( randomint( 2 ) )
	{
		shutterpair_move_bounce( shutterpair[0].linker, randomfloatrange(165, 170) * (-1), randomfloatrange(0.4, 0.6) );
		shutterpair[0] playsound( "window_shutter" );
		wait ( randomfloatrange(0.1, 0.3) );
		shutterpair_move_bounce( shutterpair[1].linker, randomfloatrange(165, 170), randomfloatrange(0.4, 0.6) );
		shutterpair[1] playsound( "window_shutter" );
	}
	else
	{
		shutterpair_move_bounce( shutterpair[1].linker, randomfloatrange(165, 170), randomfloatrange(0.4, 0.6) );
		shutterpair[1] playsound( "window_shutter" );
		wait( randomfloatrange(0.1, 0.3) );
		shutterpair_move_bounce( shutterpair[0].linker, randomfloatrange(165, 170) * (-1), randomfloatrange(0.4, 0.6) );
		shutterpair[0] playsound( "window_shutter" );
	}
	
}



// this actually opens them then bouces them against the wall a bit
shutterpair_move_bounce( obj, yaw, time )
{
	
	obj rotateyaw( yaw, time );
	obj waittill ( "rotatedone" );
	
	if ( yaw > 0 )
	{
		obj rotateyaw( randomfloatrange(3, 10) * (-1), time * 10 );
	}
	else
	{
		obj rotateyaw( randomfloatrange(3, 10), time * 10 );
	}	
	
}



// link all the train cars together to be moved
link_train_cars()
{
	
	boxcar = getEnt( "boxcar_intro", "targetname" );
	
	traincars = getEntArray( "intro_traincar", "script_noteworthy" );
	for( i = 0; i < traincars.size; i++ )
	{
		traincars[i] linkTo( boxcar, "tag_origin" );
	}

//	lightfx_points = getEntArray( "boxcar_light_fx", "targetname" );
//	for(i = 0; i < lightfx_points.size; i++)
//	{
//		lightfx_points[i] linkTo( boxcar, "tag_origin" );
//		lightfx_points[i] thread do_boxcar_sun_rays();
//		wait_network_frame();
//	}
	
	smoketrail_points = getEntArray( "boxcar_smoke_fx", "targetname" );
	for(i = 0; i < smoketrail_points.size; i++)
	{
		smoketrail_points[i] linkTo( boxcar, "tag_origin" );
		smoketrail_points[i] thread do_boxcar_smoketrail_fx();
		wait_network_frame();
	}
	
	
}



//// play sunbeam fx inside the boxcar
//do_boxcar_sun_rays()
//{
//	fxmodel = spawn( "script_model", self.origin );	// spawn a script model
//	fxmodel setmodel ( "tag_origin" );				// set it to "tag_origin" which is a model with just a "tag_origin" tag
//	fxmodel linkTo ( self );						// link it to the parent enitiy which should move with the train
//	
//	// play fx on tag should move the fx with the model, and when the ent is deleted, the fx will go away with it
//	while( 1 )
//	{
//		playFXontag( level._effect["train_sun_rays"], fxmodel, "tag_origin" );
//		wait( 0.5 );
//		
//	}
//
//	// instead of ending the thread with this notify, we'll wait until this notify then delete the model
//	flag_wait( "calling_intro_barrage" );
//	
//	fxmodel delete();
//	self delete();
//}



// fake a smoke trail on the train
do_boxcar_smoketrail_fx()
{
	
	while( !flag( "train_door_opened") )
	{
		playFX( level._effect["train_smoke_trail_fx"], self.origin );
		wait( 0.3 );
	}
	
	wait( 1 );
	self delete();
}



// move the train for the intro rail
// self = the boxcar the players start in
move_train( boxcar )
{
	
	// TEMP OFF
	//players = get_players();	
	//array_thread( players, ::player_jolt_view );
	
	PlayRumbleOnPosition( "ber1_train", boxcar.origin ); 
	
	level thread player_shake_view();
	
	dest = getStruct( "train_stop", "targetname" );
	
	self moveto( dest.origin, 11.5, 0, 5 );
	
	while( self.origin != dest.origin )
	{
		wait( 0.1 );
	}
	
	flag_set( "train_has_stopped" );
	
}



player_shake_view()
{
	
	level waittill ( "train slowing" );
	
	host = get_players()[0];
	
	earthquake(0.5, 2.5, host.origin, 4000);
	wait( 1 );
	earthquake(0.4, 2.5, host.origin, 4000);
	wait( 1 );
	earthquake(0.3, 2.5, host.origin, 4000);
	wait( 1 );
	earthquake(0.2, 2.5, host.origin, 4000);
	wait( 1 );
	earthquake(0.1, 2.5, host.origin, 4000);
	
}



player_jolt_view()
{
	
	level waittill ("train slowing");
	self endon ("death");
	self endon ("disconnect");
	
	org = spawn ("script_origin", self.origin);
	//org.angles = self.angles;
	//org linkto (self);
	self playerSetGroundReferenceEnt( org );
	
	org rotatepitch(-25, 1.0, 0.2);
	org waittill ("rotatedone");
	wait 2.75;
	org rotatepitch(25, 2, 1.5);
	org waittill ("rotatedone");
	self playerSetGroundReferenceEnt( undefined );
	
}



///////////////////
//
// shake the player's camera
//
///////////////////////////////

train_turbulence()
{
   
    level endon( "train_has_stopped" );
    
    while( 1 )
    {
        scale = 0.1;
		source = self getOrigin();
        duration = ( (randomfloat(1) * 0.75) + 0.05 );
        radius = 1500;
        
        earthquake( scale, duration, source, radius );
        
        wait( duration );
    }
    
}



event1_threads()
{
	
	level thread katyushas();
	level thread train_wavers();
	level thread intro_house_collapse();
	level thread move_tanks();

	level thread ruins_battle();
	
}


katyusha_trucks()
{
	
	level thread katyusha_intro_trucks();
	level thread katyusha_intro_truck_left_trigger();
	level thread katyusha_intro_truck_center_trigger();
	level thread rear_katyushas();
	
}



///////////////////
//
// fire rockets from the trucks behind the train as it comes to a stop
//
///////////////////////////////

rear_katyushas()
{

	trigger_wait( "fire_rear_katyushas", "targetname" );

	for( i = 0; i < 5; i++ )
	{
		level thread fire_katyusha_rockets( 6, "katyusha_distant", true, false );
		wait( randomfloatrange( 0.5, 1 ) );
	}
}



///////////////////
//
// handles the Katyusha rockets throughout the level
//
///////////////////////////////

katyushas()
{
	thread katyusha_monitor();
	level thread katyusha_trucks();
	
	wait_network_frame();
	
	level thread ambient_rockets( "katyusha_distant", "train_door_opened", true, true );
	level thread ambient_rockets( "katyusha_close", "calling_intro_barrage", true, true );
	
	flag_wait( "katyusha_wait" );
	
	//client notify for Kevins audio
	SetClientSysState("levelNotify","fake_battle_done");
	
	for(i = 0; i < 8; i++)
	{
		level thread fire_katyusha_rockets( 8, "katyusha_barrage", true, true, 1500 );
	}
	
	wait( 5 );
	flag_set( "intro_barrage_complete" );
	
	level thread ambient_rockets( "katyusha_random", "surrender_begin", true, true );
	
}



// fire rockets from the Katyusha trucks in front of the train
katyusha_intro_trucks()
{
	level thread katyusha_trucks_fire( "fire_left_truck_rockets", "katyusha_left_truck", 2000, 210 );
	wait_network_frame();
	level thread katyusha_trucks_fire( "fire_center_truck_rockets", "katyusha_center_truck", 2250, 135 );
	wait_network_frame();
	level thread katyusha_trucks_fire( "fire_right_truck_rockets", "katyusha_right_truck", 2200, 210 );
}



// forward left hand side Katyusha truck
katyusha_intro_truck_left_trigger()
{
	trigger_wait( "katyusha_left_trigger", "targetname" );
	level notify( "fire_left_truck_rockets" );
}



// forward center Katyusha truck (the one on the road)
// and the forward right side truck
katyusha_intro_truck_center_trigger()
{
	
	trigger_wait( "exit_boxcar_trigger", "targetname" );
	
	level notify( "fire_center_truck_rockets" );	
	wait( randomfloatrange( 1.5, 2.5 ) );	
	level notify( "fire_right_truck_rockets" );
	
}



// setup the forward Katyusha trucks and rockets then fire them
// catenary is the flatness of the rockets trajectory
// z_moveto_offset is helps determine how to move them along the truck's platform
katyusha_trucks_fire( notice, truck_name, catenary, z_moveto_offset )
{
	truck = getEnt( truck_name, "targetname" );
	truck_rockets = [];
	
	tag = undefined;
	tag_pos = undefined;
	tag_angles = undefined;
	rocket = undefined;
	
	
	numRockets = 16;
	
	if(NumRemoteClients())
	{
		numRockets = 8;
	}
	
	for(i = 0; i < numRockets; i++)
	{
		if(i <= 9)
		{
			tag = "tag_rocket0" + i;
			tag_pos = truck getTagOrigin(tag);
			tag_angles = truck getTagAngles(tag);
		}
		else
		{
			tag = "tag_rocket" + i;
			tag_pos = truck getTagOrigin(tag);
			tag_angles = truck getTagAngles(tag);
		}
		
		if( isDefined( tag_pos ) )
		{
			while(!rocket_ok())
			{
				wait_network_frame();
			}
			
			rocket = spawn("script_model", tag_pos);
			level._numRockets ++;
			rocket.angles = ( tag_angles );
			rocket setmodel("katyusha_rocket");
			truck_rockets[truck_rockets.size] = rocket;
		}
	}
	
	targets = getStructArray(truck_name + "_targets", "targetname");
	target = targets[randomInt(targets.size)];
	
	close_targets = [];
	
	for(i = 0; i < targets.size; i++)
	{
		dist = distancesquared(target.origin, targets[i].origin);
		
		if(dist <= 512*512)
		{
			close_targets[close_targets.size] = targets[i];
		}
	}
	
	level waittill(notice);
	
	for(i = 0; i < truck_rockets.size; i++)
	{
		target_pos = close_targets[randomInt(close_targets.size)];
		truck_rockets[i] thread fire_intro_truck_rockets( target_pos, truck, tag_pos, catenary, z_moveto_offset );
	}
	
}



// move the rocket and play the fx
//self = the rocket
fire_intro_truck_rockets( target_pos, truck, tag_pos, catenary, z_moveto_offset )
{
	
	wait( randomfloatrange( 1, 3 ) );
	
	self thread fire_rocket( target_pos.origin, tag_pos, true, catenary, z_moveto_offset );
	
	self playsound( "katyusha_launch_rocket" );
	playFxOnTag( level._effect["rocket_launch"], self, "tag_fx" );
	
	wait( 0.1 );
	
	//**self playloopsound( "katy_rocket_run" );
	playFxOnTag( level._effect["rocket_trail"], self, "tag_fx" );
	
}



// make the left side house collapse
intro_house_collapse()
{
	
	org_node = getNode( "introhouse_animnode", "targetname" );
	pieces = getEntArray( "introhouse_chunk", "targetname" );
	fx_org = getStruct( "introhouse_fx", "targetname" );
	
	flag_wait( "calling_intro_barrage" );
	
	wait( 4.25 );
	
	structs = getStructArray( "katyusha_introhouse", "targetname" );
	for( i = 0; i < structs.size; i++ )
	{
		playFX( level._effect["rocket_explode"], structs[i].origin );
		playSoundAtPosition( "shell_explode_default", structs[i].origin );
	}
	
	wait( randomfloatrange( 0.5, 1.3 ) );
	
	level thread maps\_anim::anim_ents( pieces, "collapse", undefined, undefined, org_node, "intro_house" );
	
	//client notify for Kevins audio
	SetClientSysState( "levelNotify","house1_collapse" );
	
	wait( randomfloatrange( 1.5, 2 ) );
	playfx( level._effect["intro_house_collapse"], fx_org.origin );
	
}



///////////////////
//
// reset some fields
//
///////////////////////////////

reset_squad_ignore_state()
{
	
	guys = getAIArray( "allies" );
	
	for(i = 0; i < guys.size; i++)
	{
		guys[i].ignoreme = false;
		guys[i].ignoreall = false;
	}
	
}



///////////////////
//
// rejoin the squad on the Red color group
//
///////////////////////////////

rejoin_squad()
{
	
	level endon( "trig_chain_ruins_end" );
	
	trigger_wait( "colortrig_r3", "targetname" );
	
	set_color_allies( "r" );
	set_color_heroes( "c" );
	
}



///////////////////
//
// rejoin the squad on the Red color group
//
///////////////////////////////

rejoin_squad_2()
{
	
	level endon( "start_office_building" );
	
	trigger_wait( "chain_ruins_end", "targetname" );
	
	set_color_allies( "r" );
	set_color_heroes( "c" );
	
}



// wait for players to clear out the office building
office_building()
{
	
	autosave_by_name( "Ber1 office pacing" );
	
	level thread office_crawlers();
	level thread office_objective_update();
	
	flag_wait( "start_office_building" );

	// get everyone back on the red chain
	set_color_allies( "r" );	
	
	old_color_trig = getent( "chain_ruins_end", "targetname" );
	if( isdefined( old_color_trig ) )
	{
		old_color_trig delete();	
	}
	
	if( !flag( "in_office_building" ) )
	{
		set_color_chain( "colortrig_r4" );
	}
	
	level thread office_building_entry_vo();
	level thread make_sure_only_have_8_guys();
	level thread kill_all_axis_ai_bloody();
	level thread cafe_area();
	
}



cafe_area()
{

	// flag set on trigger
	flag_wait( "surrender_start" );
	
	level thread delete_drones();
	
	if( !is_german_build() )
	{
		level thread execution_vignette();
	}
	else
	{
		flag_set( "execution_over" );
		allies = simple_spawn( "execution_allies", ::execution_allies_german_safe_strat );	
	}
	
	maps\ber1_event2::main();
	
}




office_building_entry_vo()
{

	wait( randomfloatrange( 0.7, 1.4 ) );

	play_vo( level.commissar, "vo", "move_forward" );
	
	wait( 3 );
	
	play_vo( level.reznov, "vo", "this_way_into_building" );
	
	flag_wait( "in_office_building" );
	
	play_vo( level.reznov, "vo", "upstairs" );	
	
	wait( 3 );
	
	play_vo( level.chernov, "vo", "there_are_survivors" );
	
	wait( 3 );
	
	play_vo( level.commissar, "vo", "these_animals" );
	
	wait( 6 );
	
	play_vo( level.commissar, "vo", "deserve_none" );	
	
}



make_sure_only_have_8_guys()
{

	allies = getaiarray( "allies" );
	
	regular_guys_taken_off = 0;
	
	left_behind_guys = [];
	left_behind_nodes = getnodearray( "node_ruins_guys_left_behind", "script_noteworthy" );
	
	// take them off the color chain
	// POLISH TODO make them go to cover nodes so it looks more realistic?
	for( i  = 0; i < allies.size; i++ )
	{
		// non-respawners dont need to follow to next event
		if( isdefined( allies[i].script_no_respawn ) )
		{
			
			allies[i] disable_ai_color();
			
			if( isdefined( left_behind_nodes[i] ) )
			{
				allies[i] setgoalnode( left_behind_nodes[i] );
			}
			else
			{
				allies[i] setgoalpos( allies[i].origin );	
			}
			
			left_behind_guys[left_behind_guys.size] = allies[i];
			
		}
		else if( regular_guys_taken_off < 2 )
		{
			if( !is_in_array( level.heroes, allies[i] ) )
			{
				allies[i] disable_ai_color();
				
				if( isdefined( left_behind_nodes[i] ) )
				{
					allies[i] setgoalnode( left_behind_nodes[i] );
				}
				else
				{
					allies[i] setgoalpos( allies[i].origin );	
				}
				
				regular_guys_taken_off++;
				left_behind_guys[left_behind_guys.size] = allies[i];
			}
			
		}
		
	}
	
	// wait till next event, then kill them if they're still alive
	flag_wait( "tank_wall_crumble" );
	wait( 5 );
	
	for( i  = 0; i < left_behind_guys.size; i++ )
	{

		if( isdefined( left_behind_guys[i] ) && isalive( left_behind_guys[i] ) )
		{
			left_behind_guys[i] thread bloody_death( true );	
		}
	}
	
}



///////////////////
//
// injured guys on the 2nd floor of clock tower building, after the tanks have assaulted it
//
///////////////////////////////

office_crawlers()
{

	flag_wait( "office_crawlers" );

	crawls = [];
	crawls[0]["crawl"] 			= "crawl_1";
	crawls[0]["crawl_death"] 	= level.scr_anim["office"]["crawl_1_death"];
	crawls[1]["crawl"] 			= "crawl_2";
	crawls[1]["crawl_death"] 	= level.scr_anim["office"]["crawl_2_death"];
	crawls[2]["crawl"] 			= "crawl_3";
	crawls[2]["crawl_death"] 	= level.scr_anim["office"]["crawl_3_death"];
	crawls[3]["crawl"] 			= "crawl_4";
	crawls[3]["crawl_death"] 	= level.scr_anim["office"]["crawl_4_death"];

	crawls = array_randomize( crawls );

	level thread office_crawler_1( crawls[0] );
	level thread office_crawler_2( crawls[1] );
	level thread office_crawler_3( crawls[2] );
	
}



office_crawler_1( crawl_array )
{

	guy = simple_spawn_single( "office_crawler_1" );

	guy endon( "death" );

	guy thread crawler_ignore_delay( 6 );
	
	anim_node = getnode( "node_office_crawl_1", "targetname" );
	
	guy.health = 5;
	guy.animname = "office";
	guy.allowdeath = true;
	guy.deathanim = crawl_array["crawl_death"];
	
	guy animscripts\shared::placeWeaponOn( guy.primaryweapon, "none");

	anim_single_solo( guy, crawl_array["crawl"], undefined, anim_node );
	guy dodamage( 1000, ( 0, 0, 0 ) );		
	
}



office_crawler_2( crawl_array )
{

	wait( 0.5 );

	guy = simple_spawn_single( "office_crawler_2" );
	
	guy endon( "death" );
	
	guy thread crawler_ignore_delay( 6 );
	
	anim_node = getnode( "node_office_crawl_2", "targetname" );
	
	guy.health = 5;
	guy.animname = "office";
	guy.allowdeath = true;
	guy.deathanim = crawl_array["crawl_death"];
	
	guy animscripts\shared::placeWeaponOn( guy.primaryweapon, "none");
	
	anim_single_solo( guy, crawl_array["crawl"], undefined, anim_node );
	guy dodamage( 1000, ( 0, 0, 0 ) );		
	
}



office_crawler_3( crawl_array )
{

	wait( 0.5 );

	guy = simple_spawn_single( "office_crawler_3" );
	
	guy endon( "death" );	
	
	guy thread crawler_ignore_delay( 6 );
	
	anim_node = getnode( "node_office_crawl_3", "targetname" );
	
	guy.health = 5;
	guy.animname = "office";
	guy.allowdeath = true;
	guy.deathanim = crawl_array["crawl_death"];
	
	guy animscripts\shared::placeWeaponOn( guy.primaryweapon, "none");
	
	anim_single_solo( guy, crawl_array["crawl"], undefined, anim_node );
	guy dodamage( 1000, ( 0, 0, 0 ) );		
	
}



crawler_ignore_delay( wait_time )
{
	self endon( "death" );
	wait( wait_time );
	self.ignoreme = 0;
}




office_objective_update()
{

	// flag set on trigger
	flag_wait( "office_door_kick_trigger" );
	
	flag_set( "objective_office_2" );
	
	autosave_by_name( "Ber1 office execution" );
		
}



///////////////////
//
// play anim of office wall crumbling
//
///////////////////////////////

office_wall_crumble()
{
	
	autosave_by_name( "Ber1 office crumble" );
	
	shelf = getEnt("office_mg_shelf", "targetname");
	shelf delete();
	level thread kill_mgs( "office_shelf_mg", "targetname" );
	
	// kills guys that stand on the brush models are being deleted
	kill_noteworthy_group( "office_right_gunner" );
	kill_noteworthy_group( "office_right_gunner_beneath" );
	
	wait ( 0.2 );
	fx = getStruct( "office_building_fx", "targetname" );	
	playFX( level._effect["office_collapse"], fx.origin );

	//delete wall pieces
	pieces = getEntArray( "office_wall_chunk", "targetname" );
	for ( i = 0; i < pieces.size; i++ )
	{
		pieces[i] delete();
	}
		
	exploder( 102 );		
		
	wait( 0.7 );
	
	playFX( level._effect["explosion_papers"], fx.origin );
	
	flag_set( "office_wall_done" );
	
}



///////////////////
//
// make the office building MG42s love or hate the players
// if inside one of the houses, dont fire on the player
//
///////////////////////////////

office_mgs_threatbias()
{

	vol_1 = getEnt( "left_house_vol", "targetname" );
	vol_2 = getEnt( "right_house_vol", "targetname" );
	
	while( !flag( "move_tanks_3" ) )
	{
		
		players = get_players();
		for(i = 0; i < players.size; i++)
		{
			if( players[i] isTouching( vol_1 ) || players[i] isTouching( vol_2 ) )
			{
				SetIgnoreMeGroup( "players", "office_gunner_threat" );
			}
			else
			{
				setthreatbias( "players", "office_gunner_threat", -600 );
			}
		}
		
		wait( 0.75 );
		
	}
	
	vol_1 delete();
	vol_2 delete();
	
}



///////////////////
//
// the guys that wave you on into the ruins
//
///////////////////////////////

train_wavers()
{
	level thread train_waver_1();
	level thread train_waver_2();
}


train_waver_1()
{
	
	level.waver1 = simple_spawn_single( "train_waver1", ::intro_waver1_strat );	
	
	flag_wait( "train_door_opened" );	
	
	level.waver1 thread anim_loop_solo( level.waver1, "wave1", undefined, "stop_whistle" );	
	
	wait( randomintrange( 5, 8 ) );
	
	level.waver1 notify( "stop_whistle" );
	level.waver1.goalradius = 60;
	level.waver1 stop_magic_bullet_shield();
	level.waver1.ignoreall = false;
	level.waver1.ignoreme = false;
	
	level.waver1.exit_train_pathing_num = 13;
	
	goal_node = getnode( "exit_train_pathing_" + level.waver1.exit_train_pathing_num, "targetname" );
	level.waver1 setgoalnode( goal_node );	
	
	flag_wait( "ruins_charge" );
	
	wait( 2.6 );
	
	goal_node = getnode( "berm_pathing_" + level.waver1.exit_train_pathing_num, "targetname" );
	level.waver1 thread berm_pathing_think( goal_node );
	
}



train_waver_2()
{

	level.waver2 = simple_spawn_single( "train_waver2", ::intro_waver2_strat );
	
	flag_wait( "train_door_opened" );
	
	level.waver2 thread anim_loop_solo( level.waver2, "wave2", undefined, "stop_whistle" );
	
	flag_wait( "calling_intro_barrage" );
	
	level.waver2 notify( "stop_whistle" );
	
	flag_wait( "ruins_charge" );
	
	level.waver2 notify( "join_squad" );
	level.waver2.goalradius = 60;
	level.waver2 stop_magic_bullet_shield();
	level.waver2.ignoreall = false;
	level.waver2.ignoreme = false;
	
	level.waver2.exit_train_pathing_num = 14;	

	wait( 2.6 );

	goal_node = getnode( "berm_pathing_" + level.waver2.exit_train_pathing_num, "targetname" );
	level.waver2 thread berm_pathing_think( goal_node );
	
}



intro_waver1_strat()
{
	self.animname = "russian";
	self.goalradius = 16;
	self.ignoreall = true;
	self.ignoreme = true;
	self.allowdeath = true;
	self thread magic_bullet_shield();
}



intro_waver2_strat()
{
	self.animname = "russian";
	self.goalradius = 16;
	self.ignoreall = true;
	self.ignoreme = true;
	self.allowdeath = true;
	self thread magic_bullet_shield();
}




// soldiers yelling as they charge the ruins
//squad_battle_cries()
//{
//	wait( randomfloat( 2 ) );
//	self playsound("russian_battle_cry");
//}



///////////////////
//
// move the tanks throughout Event 1
//
///////////////////////////////

move_tanks()
{
	level thread tank_1();
	level thread tank_2();
	level thread tank_3();
}



// handles the actions of Tank 1
tank_1()
{
	
	flag_wait( "spawn_tanks" );
	
	wait( 0.05 );
	
	tank = getEnt( "ev1_tank1", "targetname" );
	
	tank maps\_vehicle::godon();
	tank.rollingdeath = 1;
	tank thread tank_rolling_death();
	
	tank thread maps\_vehicle::mgoff();						
	
	tank veh_stop_at_node( "tank1_stop1" );
	
	flag_wait( "move_tanks_1" );
	tank resumespeed( 8 );

	tank veh_stop_at_node( "tank1_stop2" );	
	
	flag_wait( "move_tanks_2" );
	tank resumespeed( 8 );

	// split this so we can start in the middle of the ruins
	tank1_part2( tank );
	
}



// handles the actions of Tank 2
tank_2()
{
	
	flag_wait( "spawn_tanks" );
	
	wait( 0.05 );
	
	tank = getEnt( "ev1_tank2","targetname" );
	
	tank maps\_vehicle::godon();
	
	tank thread maps\_vehicle::mgoff();	
	
	tank veh_stop_at_node( "tank2_stop1" );

	flag_wait( "move_tanks_1" );
	tank resumespeed( 8 );
	
	tank veh_stop_at_node( "tank2_stop2" );

	flag_wait( "move_tanks_2" );
	tank resumespeed( 8 );

	// split so we can start in mid ruins
	tank2_part2( tank );
	
}



// handles the actions of Tank 3
tank_3()
{
	
	flag_wait( "spawn_tanks" );
	
	wait( 0.05 );
	
	tank = getEnt( "tank_3","targetname" );
	
	tank maps\_vehicle::godon();
	
	tank thread tank_3_shoot_strat();
	tank thread maps\_vehicle::mgoff();	
	
	tank veh_stop_at_node( "tank_3_stop_1" );


	flag_wait( "move_tanks_1" );
	tank resumespeed( 8 );
	
	tank veh_stop_at_node( "tank_3_stop_2" );
	
	
	flag_wait( "move_tank_3_2" );
	tank resumespeed( 8 );

	tank veh_stop_at_node( "tank_3_stop_3" );


	flag_wait( "ruins_battle_2" );
	tank resumespeed( 8 );

	tank veh_stop_at_node( "tank_3_stop_4" );

	flag_wait( "chimney_collapsed" );
	tank tank_reset_turret( 2.5 );
	wait( RandomFloatRange( 0.75, 1.9 ) );
	tank resumespeed( 8 );
	
	tank waittill( "reached_end_node" );
	
	flag_set( "ruins_tank_at_end" );
	
}



tank_rolling_death()
{

	self waittill( "death" );
	
	while( 1 )
	{
	
		if ( ( self getspeedMPH() ) == 0 )
		{
			break;
		}
		
		wait( 0.05 );
		
	}
		
	wait( 0.05 );
	
	// manually notify this cuz i'm not really using crashpaths. kill() in _vehicle wants this notify when the tank is dead & done moving
	self notify( "deathrolloff" );

}



///////////////////
//
// middle tank (that moves up with squad) shoot strat as it moves up through the ruins
//
///////////////////////////////

tank_3_shoot_strat()
{
	
	chimney_targ = getstruct( "orig_ruins_tank_target_chimney", "targetname" );
	
	random_targs = [];
	random_targs[random_targs.size] = getstruct( "orig_ruins_tank_target_1", "targetname" );
	random_targs[random_targs.size] = getstruct( "orig_ruins_tank_target_2", "targetname" );
	random_targs[random_targs.size] = getstruct( "orig_ruins_tank_target_3", "targetname" );
	
	flag_wait( "move_tank_3_2" );
	wait( 2 );
	
	while( !flag( "ruins_battle_2" ) )
	{
		self tank_fire_at_struct( random_targs[randomint(random_targs.size)] );
		
		// if flag is set while firing at struct, don't wait for wait(), just break out now
		if( flag( "ruins_battle_2" ) )
		{
			break;	
		}
		
		wait( RandomIntRange( 5, 7 ) );
	}
	
	wait( 3 );
	
	// Blows up chimney if player doesn't look at the lookat trigger but moves far ahead enough
	level thread trig_override( "trig_lookat_chimney" );
	// wait for player to look at the bookcase area
	trigger_wait( "trig_lookat_chimney", "targetname" );
	
	self tank_fire_at_struct( chimney_targ );
	
	level thread maps\ber1_anim::ruins_chimney();
	
	flag_set( "chimney_collapsed" );
	
	// waittill it gets to the end of its path
	flag_wait( "ruins_tank_at_end" );
	
	level thread tank_3_gets_shot();
	
	random_targs = [];
	random_targs[random_targs.size] = getstruct( "orig_ruins_tank_target_4", "targetname" );
	random_targs[random_targs.size] = getstruct( "orig_ruins_tank_target_5", "targetname" );
	
	// fire at the office building
	fire_count = 0;
	while( fire_count < 2 )
	{
		self tank_fire_at_struct( random_targs[randomint(random_targs.size)] );
		wait( RandomIntRange( 4, 5 ) );
		fire_count++;
	}
	
	flag_set( "tank_3_ready_to_die" );
	
}



tank_3_gets_shot()
{
	
	level endon( "execution_over" );
	
	guy = simple_spawn_single( "office_panzer_killer" );

	guy setcandamage( false );
	guy.ignoreme = true;
	guy.ignoresuppression = true;
	guy.pacifist = true;
	guy.pacifistwait = 0.05;
	
	tank = getent( "tank_3", "targetname" );
	
	flag_wait( "tank_3_ready_to_die" );

	goal = getnode( "node_panzer_killer", "targetname" );
	guy setgoalnode( goal );
	
	guy waittill( "goal" );

	wait( 0.5 );

	orig = getent( "orig_tank_3_death", "targetname" );
	orig.health = 100000;
	guy SetEntityTarget( orig );	

	level thread tank_3_gets_shot_failsafe( tank );

	while( !flag( "tank_3_shot_failsafe" ) )
	{	
		
		tank waittill( "damage", damage_amount, attacker, direction_vec, point, type );
		
		if( attacker == guy )
		{
			radiusdamage( tank.origin, 50, tank.health + 50, tank.health + 50 );
			break;
		}
		
	}
	
	level thread tanks_torn_apart_vo();
	
	level notify( "tank_3_dead" );
	
	guy ClearEntityTarget();
	guy setcandamage( true );

	guy endon( "death" );

	flag_wait( "move_tanks_3" );
	
	goal = getnode( "auto4068", "targetname" );
	guy thread guy_run_to_node_and_delete( goal );
	
}



tank_3_gets_shot_failsafe( tank )
{

	level endon( "tank_3_dead" );

	wait( 8 );

	quick_text( "tank_3_gets_shot_failsafe" );

	flag_set( "tank_3_shot_failsafe" );
	
	rocket_origin = getstruct( "orig_panzer_killer_failsafe", "targetname" );
	
	level thread fire_shrecks( rocket_origin, tank, undefined, "rpg_impact_boom", 0.9 );
	
	wait( 0.9 );
	
	radiusdamage( tank.origin, 50, tank.health + 50, tank.health + 50 );	
	
}



tanks_torn_apart_vo()
{
	wait( RandomFloatRange( 1.4, 2.5 ) );
	play_vo( level.reznov, "vo", "tanks_torn_apart" );	
}



tank1_part2( tank )
{	
	
	tank veh_stop_at_node( "tank1_stop3" );		
	
	tank thread tanks_fire_at_office();
	
	flag_wait( "move_tanks_3" );

	tank tank_reset_turret( 1.5 );
	
	tank resumespeed( 10 );
	
	tank veh_stop_at_node( "tank1_fire_at_wall" );

	println( "tank firing at wall!" );
	
	crumble = getstruct( "make_office_wall_crumble", "targetname" );
	tank setTurretTargetVec( crumble.origin );
	tank waittill_notify_or_timeout( "turret_on_target", 3 );
	wait( 0.4 );
	tank fireWeapon();
	
	level thread office_wall_crumble();
	
	wait( 1.25 );
	tank resumespeed( 2 );
	
	final_target = getstruct( "tank1_final_target", "targetname" );
	tank setTurretTargetVec( final_target.origin );
	
	wait( randomfloatrange( 1, 1.2 ) );
	
	level notify( "tank_shreck_ricochet" );

	flag_set( "tank1_disabled" );
	
	// TODO need some kind of failsafe here
	while( !flag( "tank1_destroyed" ) )
	{
	
		tank waittill( "damage", amount, attacker );
		
		if( attacker == level.shrek_bounce_guy )
		{
			radiusdamage( tank.origin, 50, tank.health + 50, tank.health + 50 );
			flag_set( "tank1_destroyed" );			
		}
			
	}
	
}



///////////////////
//
// middle tank (that moves up with squad) shoot strat when at the end of its path
//
///////////////////////////////

tanks_fire_at_office()
{
	
	level endon( "move_tanks_3" );
	
	random_targs = [];
	random_targs[random_targs.size] = getstruct( "orig_ruins_tank_target_4", "targetname" );
	random_targs[random_targs.size] = getstruct( "orig_ruins_tank_target_5", "targetname" );
	random_targs[random_targs.size] = getstruct( "orig_ruins_tank_target_6", "targetname" );	
	random_targs[random_targs.size] = getstruct( "orig_ruins_tank_target_7", "targetname" );	
	random_targs[random_targs.size] = getstruct( "orig_ruins_tank_target_8", "targetname" );	
	
	while( 1 )
	{
		self tank_fire_at_struct( random_targs[randomint( random_targs.size)] );
		wait( randomIntRange( 5, 7 ) );
	}
	
}



tank2_part2( tank )
{
	
	tank veh_stop_at_node( "tank2_stop3" );	
	
	tank thread tanks_fire_at_office();
	
	flag_wait( "move_tanks_3" );
	tank thread tank_reset_turret( 2 );
	wait( 2.5 );
	tank resumespeed( 10 );
	
	tank veh_stop_at_node( "tank2_stop4" );

	wall_hole = getstruct( "office_wall_hole", "targetname" );	
	tank setTurretTargetVec( wall_hole.origin );
	tank waittill_notify_or_timeout( "turret_on_target", 3 );
	wait( 0.4 );
	tank fireWeapon();
	
	wait( 0.1 );
	playfx( level._effect["tank_shell_explode"], wall_hole.origin );
	
	wait( randomfloatrange( 4, 5.5 ) );
	
	ground = getstruct( "tank2_target", "targetname" );
	tank setTurretTargetVec( ground.origin );
	tank waittill_notify_or_timeout( "turret_on_target", 3 );
	wait( 0.4 );
	tank fireWeapon();
	
	wait( 0.1 );
	playfx( level._effect["tank_shell_explode"], ground.origin );
	
	
	// waittill tank 1 has been disabled by the rocket
	///////////////
	flag_wait( "tank1_disabled" );
	
	finger1 = getStruct( "finger_shreck", "targetname" );
	tank setTurretTargetVec( finger1.origin );
	tank waittill_notify_or_timeout( "turret_on_target", 3 );
	wait( 0.4 );
	tank fireWeapon();
	
	flag_wait( "tank1_destroyed" );
	
	window = getstruct( "office_lower_window", "targetname" );
	tank setTurretTargetVec( window.origin );
	tank waittill( "turret_on_target" );
	wait( 0.4 );
	tank fireWeapon();
	wait( 0.1 );
	exploder( 101 );
	
	kill_guys_in_vol_119();
	
	wait( 0.5 );
	tank tank_reset_turret( 3 );
	
	flag_set( "start_office_building" );
	
	wait( 5.5 );
	
	level thread clock_tank_blocker_delay();
	
	tank resumespeed( 5 );
	
	tank veh_stop_at_node( "tank2_stop5" );
	
	flag_wait( "start_office_building" );
	
	maps\_debug::set_event_printname( "Office" );
	
	// tank moves up to the surrender area to break through the wall
	tank2_surrender( tank );
	
}



clock_tank_blocker_delay()
{
	wait( 4.5 );
	
	blocker = getent( "blocker_clock_tank_2", "targetname" );
	blocker solid();
	blocker disconnectpaths();

	wait( 2 );

	maps\ber1_tankride::remove_tank_blocker( "blocker_clock_tank_1" );
	
	wait( 3.5 );
	
	blocker connectpaths();
	blocker delete();
	
}



tank2_surrender( tank )
{
	
	tank resumespeed( 5 );
	
	tank veh_stop_at_node( "node_wait_pre_crumble" );	
	
	// flag set on trigger
	flag_wait( "surrender_start" );

	tank resumespeed( 5 );
	turn_turret_struct = getstruct( "turn_turret", "targetname" );
	tank SetTurretTargetVec( turn_turret_struct.origin );
	
	tank veh_stop_at_node( "node_wait_pre_crumble_1" );	
	
	flag_wait( "execution_over" );
	
	wait( randomfloatrange( 0.8, 1.5 ) );
	
	tank resumespeed( 5 );	
	
	tank veh_stop_at_node( "node_wait_pre_crumble_2" );	
	
	// flag set on trigger
	flag_wait( "tank_go_through_wall" );
	
	level thread wall_crumble_vo();
	
	tank resumespeed( 5 );	
	
	// ai cleanup	
	kill_all_axis_ai();
	
	flag_wait( "tank_ambush" );

	panzershrek_1_spawn = getstruct( "ps1_spawn", "targetname" );
	
	level thread fire_shrecks( panzershrek_1_spawn, tank, (0,0,50), "iron_gate_explo", 1.1 );
	//panzershrek_1_spawn playSound( "weap_pnzr_fire" );
	
	set_color_chain( "colortrig_r8" );
	flag_set( "objective_surrender" );
	
	tank setTurretTargetVec( panzershrek_1_spawn.origin );
	tank waittill_notify_or_timeout( "turret_on_target", 5 );
	tank fireWeapon();	
	
	wait( randomfloatrange( 1.5, 2 ) );
	
	level thread fire_shrecks( panzershrek_1_spawn, tank, (0,0,50), "rpg_impact_boom", 1.1 );
	//panzershrek_1_spawn playsound( "weap_pnzr_fire" );
	
	wait( 1.1 );
	
	radiusdamage( tank.origin, 50, tank.health + 50, tank.health + 50 );	
	
}



kill_guys_in_vol_119()
{

	guys = getAIarrayTouchingVolume( "axis", "vol_119" );
	
	for( i  = 0; i < guys.size; i++ )
	{
		
		if( IsDefined( guys[i].magic_bullet_shield ) && guys[i].magic_bullet_shield )
		{
			continue;
		}
		
		guys[i] dodamage( guys[i].health + 50, (0,0,0) );	
	
	}
	
}



#using_animtree ("generic_human");
execution_vignette()
{

	battlechatter_off();

	anim_node = getnode( "execution_start", "targetname" );

	allies = simple_spawn( "execution_allies", ::execution_allies_strat );	
	assertex( allies.size == 2, "execution_allies != 2" );
	
	allies[0].animname = "execution_ally_1";
	allies[1].animname = "execution_ally_2";
	
	
	axis = simple_spawn( "execution_axis", ::execution_axis_strat );	
	assertex( axis.size == 4, "execution_axis != 4" );
	
	axis[0].animname = "execution_axis_1";
	axis[1].animname = "execution_axis_2";
	axis[2].animname = "execution_axis_3";
	axis[3].animname = "execution_axis_4";
	
	axis[1] thread execution_half_shield();
	
	anim_guys = array_combine( allies, axis );

	level thread execution_vignette_interrupt_watch();
	level thread execution_vignette_interrupt_end_watch();
	
	level endon( "execution_over" );
	
	anim_single( anim_guys, "execution", undefined, undefined, anim_node );	
	
	for( i  = 0; i < axis.size; i++ )
	{
		if( isalive( axis[i] ) )
		{
			axis[i].a.nodeath = true;
			axis[i] dodamage( axis[i].health, (0,0,0) );
		}
	}
	
	flag_set( "execution_over" );
	
	battlechatter_on();
	
}



execution_axis_strat()
{

	self animscripts\shared::placeWeaponOn( self.primaryweapon, "none");

	self.ignoreme = true;
	self.ignoreall = true;
	self.pacifist = true;
	self.pacifistwait = 0.05;
	self.grenadeawareness = 0;
	self.allowdeath = true;
	self.health = 1;
	
	self endon( "death" );
	
	
	
	// at this point the vignette is far enough along, we don't want any reaction from these guys if the player shoots them
	wait( 7.75 );
	quick_text( "nodeath here" );
	self.a.nodeath = true;
	
}



execution_allies_strat()
{

	self.ignoreme = true;
	self.pacifist = true;
	self.pacifistwait = 0.05;
	self.grenadeawareness = 0;
	self setcandamage( false );
	

	flag_wait( "execution_over" );
	
	self.goalradius = 70;
	self.ignoreme = false;
	self.pacifist = false;
	self.pacifistwait = 20; // _spawner default
	self maps\_gameskill::grenadeAwareness(); // set to default
	
	self.walkdist = 1000;
	
	goal_node = getnode( self.script_noteworthy, "targetname" );
	self setgoalnode( goal_node );
	
	flag_wait( "objective_surrender" );
	
	self.walkdist = 16;
	
	self set_force_color( "r" );
	self thread replace_on_death();
	self setcandamage( true );

}




execution_allies_german_safe_strat()
{
	
	self setcandamage( false );
	
	goal_node = getnode( self.script_noteworthy, "targetname" );
	self setgoalnode( goal_node );	
	
	flag_wait( "objective_surrender" );
	
	self setcandamage( true );
	
	self set_force_color( "r" );
	self thread replace_on_death();	
	
}



execution_vignette_interrupt_watch()
{
	
	level endon( "execution_over" );
	
	//flag_wait_all( "execution_right_over", "execution_left_over" );
	while( 1 )
	{
	
		axis = get_ai_group_ai( "execution_axis_ai" );
		
		if( !axis.size )
		{
			break;	
		}
		
		wait( 0.05 );
			
		
	}
	
	allies = get_ai_group_ai( "execution_ally_ai" );
	for( i  = 0; i < allies.size; i++ )
	{
		allies[i] notify( "killanimscript" );
	}
	
	
	flag_set( "execution_over" );
	
}



execution_vignette_interrupt_end_watch()
{

	wait( 10 );
	
	axis = get_ai_group_ai( "execution_axis_ai" );
		
	// return if guy 2 is still alive; we want the rest of the anim to play out
	for( i  = 0; i < axis.size; i++ )
	{
		if( axis[i].animname == "execution_axis_2" )
		{
			return;
		}
	}
	
	level notify( "stop_execution_half_shields" );
	
	// if guy 2 has been killed, make sure all the rest are dead so the anim can end
	for( i  = 0; i < axis.size; i++ )
	{
		if( isalive( axis[i] ) )
		{
			axis[i].a.nodeath = true;
			axis[i] dodamage( axis[i].health, (0,0,0) );
		}
	}
		
	
}



///////////////////
//
// Protect the execution guy from all damage except from the player
//
///////////////////////////////

execution_half_shield()
{

	level endon( "stop_execution_half_shields" );
	self endon( "death" );
	
	self.pel2_real_health = self.health;
	self.health = 10000;
	
	attacker = undefined; 
	
	while( self.health > 0 )
	{
		
		self waittill( "damage", amount, attacker, direction_vec, point, type, modelName, tagName );
		
		type = tolower( type );
		
		// if it's not the player, and also a bullet weapon (non-player friendlies should still be able to kill them with their grenades)
		if( !isplayer(attacker) && issubstr( type, "bullet" ) )
		{
			//iprintln( "attacked by non-player!" );
			self.health = 10000;  // give back health for these things	
		}
		else
		{
			self.health = self.pel2_real_health;
			self dodamage( amount, (0,0,0) );
			self.pel2_real_health = self.health;
			// put ff shield back on
			self.health = 10000;
		}
	}	
	
}



///////////////////
//
// bounce the shreck off the tank in front of the office building
//
///////////////////////////////

tank_shreck_ricochet()
{
	
	shreck = getEnt( "tank1_shreck", "targetname" );
	shreck hide();
	
	level waittill( "tank_shreck_ricochet" );
	
	level.shrek_bounce_guy = simple_spawn_single( "shrek_bounce_spawner", ::shrek_bounce_spawner_strat );
	
	wait( 2.3 );
	
	level notify( "bounce_shrek_fired" );
	
	vnode = getVehicleNode( "auto4365", "targetname" );
	shreck attachPath( vnode );
	shreck startPath();
	shreck show();
	
	playFxOnTag( level._effect["shreck_trail"], shreck, "tag_fx" );
	shreck playloopsound( "rpg_rocket" );
	
	vnode = getVehicleNode( "ricochet", "script_noteworthy" );
	vnode waittill( "trigger" );
	
	thread play_sound_in_space( "tank_shreck_ricochet", shreck.origin, true );
	playFX( level._effect["schrek_bounce_off_tank"], shreck.origin );
	
	shreck waittill( "reached_end_node" );
	
	shreck hide();
	playfx( level._effect["shreck_explode"], shreck.origin );
	shreck stoploopsound(.1);
	shreck playsound( "rpg_impact_boom" );
	radiusdamage( shreck.origin, 128, 300, 35 );
	earthquake( 0.5, 1.5, shreck.origin, 512 );
	wait( 3 );
	
	shreck delete();
	
}



shrek_bounce_spawner_strat()
{

	self setcandamage( false );
	self.pacifist = true;
	self.pacifistwait = 0.05;
	self.ignoresuppression = true;
	self.ignoreme = true;
	self.a.rockets = 7;
	
	level waittill( "bounce_shrek_fired" );
	
	wait( 1 );
	
	goal = getnode( "node_shrek_bounce_end", "targetname" );
	self setgoalnode( goal );
	
	self waittill( "goal" );
	
	wait( 1 );
	
	goal = getnode( self.target, "targetname" );
	self setgoalnode( goal );
	self waittill( "goal" );
	
	tank = getent( "ev1_tank1", "targetname" );
	
	self SetEntityTarget( tank );
	
	// TODO hax for coop failing
	wait( 2 );
	self shoot();
	level thread tank_1_death_failsafe();
	
	goal = getnode( "node_shrek_bounce_end", "targetname" );
	self setgoalnode( goal );
	
	self waittill( "goal" );	
	
	self delete();
	
}



tank_1_death_failsafe()
{
	
	wait( 1 );
	
	tank = getEnt( "ev1_tank1", "targetname" );
	
	if( !flag( "tank1_destroyed" ) )
	{
		radiusdamage( tank.origin, 50, tank.health + 50, tank.health + 50 );
		flag_set( "tank1_destroyed" );		
	}
	
}





// call the threads for the train drone intro
unload_train_drones()
{
	if(!NumRemoteClients())	// If were running over the network, reduce number of drones
	{
		level thread unload_and_make_drones("boxcar_a", 5);
	//	level thread unload_and_make_drones("boxcar_b", 6);
		level thread unload_and_make_drones("boxcar_d", 7);
		level thread unload_and_make_drones("boxcar_e", 7);
	}
}



// spawn in script_models, play the unload anim, turn them into drones
#using_animtree ("generic_human");
unload_and_make_drones( boxcar_name, num )
{
	
	pos = undefined;
	wait( randomfloatrange( 1.5, 3 ) );
	
	boxcar = getEnt( boxcar_name, "targetname" );
	org = boxcar getTagOrigin( "tag_origin" );
	boxcar.animname = "boxcar";
	
	for( i = 0; i < num; i++ )
	{
		
		sd_struct = getStruct( boxcar_name + "_" + i, "targetname" );
		
		if( isDefined( sd_struct ) )
		{
			pos = sd_struct;
			
			subdrone = spawn( "script_model", sd_struct.origin );
			subdrone.angles = sd_struct.angles;
			subdrone.targetname = "drone_" + boxcar_name;
			subdrone.target = subdrone.targetname + i;
			subdrone.script_noteworthy = i;
			subdrone.animname = "russian" + (i);
			subdrone character\char_rus_r_rifle::main();
			subdrone attach( "weapon_rus_mosinnagant_rifle", "tag_weapon_right" );
			subdrone UseAnimTree(#animtree);
		}
		else
		{
			continue;
		}
		
	}
	
	boxcar thread maps\ber1_anim::open_drone_traincar_door();
		
	drones = getEntArray( "drone_" + boxcar_name, "targetname" );
	
	for( i = 0; i < drones.size; i++ )
	{
		drones[i] hide();
		drones[i] linkTo( boxcar, "tag_origin" );
	}
	
	boxcar thread anim_single( drones, "train_intro", "tag_origin" );
	
	flag_wait( "train_door_opened" );
	
	for( i = 0; i < drones.size; i++ )
	{
		drones[i] show();
		drones[i] thread unload_boxcars();
	}
	
}



// turn the animated script_models into drones
#using_animtree ("fakeShooters");
unload_boxcars()
{
	
	self waittill( "guy_unlink" );
	
	self UseAnimTree(#animtree);
	
	self setcandamage( true );
	self.animname = "drone";
	
	self.a = spawnstruct();
	self makeFakeAI();
	self.team = "allies";
	
	// if self.targetname = "drone_boxcar_b"
	// and self.script_noteworthy = "7"
	// then self.target = "drone_boxcar_b7"
	// there must be a script_struct with a targetname of "drone_boxcar_b7"
	// for the new drone to target and run to!
	self.target = self.targetname + self.script_noteworthy;
	self.targetname = "drone";
	self.drone_run_cycle = %combat_run_fast_3;
	self.fakeDeath = true;
	self.health = 35;
	self thread maps\_drones::drone_setName();
	self thread maps\_drones::drones_clear_variables();
	structarray_add( level.drones[self.team], self );
	level notify ( "new_drone" );
	
	self thread maps\_drones::build_struct_targeted_origins();
	self thread maps\_drones::drone_runChain( self );
	
	flag_wait( "ruins_charge" );
	
	wait( randomfloatrange( 0.5, 2 ) );
	self notify( "drone out of cover" );

}



// ambient rockets until notifed to stop
ambient_rockets( targets, endon_flag, geotrail, far, lob_factor )
{
	while( !flag(endon_flag) )
	{
		thread fire_katyusha_rockets( 6, targets, geotrail, far, lob_factor );
		wait randomfloatrange(5, 8);
	}
}

katyusha_monitor()
{
	level._numRockets = 0;
	
	if(NumRemoteClients())
	{
		while(1)
		{
			wait_network_frame();
			level._numRockets = 0;
		}
	}
}

rocket_ok()
{
	if(NumRemoteClients() && level._numRockets > 4)
	{
		return false;
	}
	
	return true;
}

//	fire the Katyusha rockets
fire_katyusha_rockets( amount, targets_name, geotrail, far, lob_factor )
{

	katyusha_id = randomint( 6 );
	truck = getEnt( "katyusha_truck" + katyusha_id, "targetname" );
	
	targets = getStructArray( targets_name + "_truck" + katyusha_id, "targetname" );
	rocket_target = targets[randomInt(targets.size)];
	
	close_targets = [];
	
	for(i = 0; i < targets.size; i++)
	{
		dist_sqrd = distancesquared( rocket_target.origin, targets[i].origin );
		
		if( dist_sqrd <= 512*512 )
		{
			close_targets[close_targets.size] = targets[i];
		}
	}
	
	for(i = 0; i < amount; i++)
	{
		
		dest = close_targets[randomInt(close_targets.size)];
		
		//wait randomfloatrange(.112, .192);
		//Kevin changed it to just wait
		wait( 0.2 );
		
		x = randomint( 15 );
		
		if( x <= 9 )
		{
			tag = "tag_rocket0" + x;
		}
		else
		{
			tag = "tag_rocket" + x;
		}
		
		tag_org = truck getTagOrigin( tag );
		pos_angles = truck getTagAngles( tag );
		
		while(!rocket_ok())
		{
			wait_network_frame();
		}
		rocket = spawn( "script_model", tag_org );
		level._numRockets ++;
		rocket.angles = ( pos_angles );
		rocket setmodel( "katyusha_rocket" );
		
		rocket playsound( "katyusha_launch_rocket" );
		playFxOnTag( level._effect["rocket_launch"], rocket, "tag_fx" );
		
		if( geotrail )
		{
			playFxOnTag( level._effect["rocket_trail"], rocket, "tag_fx" );
		}

		// sound of rocket flying through the air
		// TEMP OFF
		//rocket playloopsound("katy_rocket_run");

		if( isdefined( lob_factor ) )
		{
			rocket thread fire_rocket( dest.origin, tag_org, far, lob_factor );
		}
		else
		{
			rocket thread fire_rocket( dest.origin, tag_org, far, 2200 );
		}
		
		if(NumRemoteClients())	// If we're network cooped, give the network some breathing room
		{
			if(i % 2)
			{
				wait_network_frame();
			}
		}		
	}
	
}



// fire the katyusha rockets
fire_rocket( target_pos, tag_org, far, catenary, z_moveto_offset )
{

	if( !isdefined( z_moveto_offset ) )
	{
		z_moveto_offset = 110;	
	}
	
	// move the rocket flatly along the rocket rack
	moveto_pos = tag_org + ( 0, 200, z_moveto_offset );
	self moveTo( moveto_pos, 0.2 );	
	wait( 0.2 );
	
	// get the rocket's new position
	// this is where the trajectory math will begin
	start_pos = self.origin;
	
	///////// Math Section
	// Reverse the gravity so it's negative, you could change the gravity
	// by just putting a number in there, but if you keep the dvar, then the
	// user will see it change.
	gravity = getDvarInt("g_gravity") * -1;
	
	// Get the distance
	dist = distance( start_pos, target_pos );
	
	// Figure out the time depending on how fast we are going to
	// throw the object... 2200 changes the "strength" of the velocity.
	// To make it more lofty, lower the number.
	// To make it more of a bee-line throw, increase the number.
	// Katyushas need a flatter trajectory due to the rocket rack
	time = dist / catenary; // 2200 is default for ambient rockets
	time_to_wait = time / 3;
	
	// Get the delta between the 2 points.
	delta = target_pos - start_pos;
	
	// Here's the math I stole from the grenade code. :) First figure out
	// the drop we're going to need using gravity and time squared.
	drop = 0.5 * gravity * (time * time);
	
	// Now figure out the trajectory to throw the object at in order to
	// hit our map, taking drop and time into account.
	velocity = ((delta[0] / time), (delta[1] / time), (delta[2] - drop) / time);
	///////// End Math Section
	
	
	self MoveGravity( velocity, time );
	self playloopsound("katy_rocket_run",.1);
	
	// from pel1
	self rotatepitch( 100, time ); 
	
	self thread rotate_rocket_at_midpoint( time_to_wait );
	wait( time );
	//Kevin Stopping the looped sound
	self stoploopsound(1);

	if(far)
	{
		playFX(level._effect["rocket_explode_far"], self.origin);
	}
	else
	{
		playFX(level._effect["rocket_explode"], self.origin);
	}
	
	earthquake( 0.3, 2, self.origin, 512 );
	//Kevin putting a wait the same time as the loop fade
	//I had to do this or all the rockets clip on impact.
	//I put the wait before the delete so the particle isn't delayed.
	wait 1;

	self delete();
	
}



// make the Katyusha rocket's nose follow the flight path
rotate_rocket_at_midpoint( time )
{
	wait( time );
	self rotatePitch( 20, time / 1.5 );
}



///////////////////
//
// piggybacking autosaves onto other triggers, to save entities
//
///////////////////////////////	

save_mid_ruins()
{
	trigger_wait( "colortrig_r2", "targetname" );
	autosave_by_name( "Ber1 midruins" );
}



///////////////////
//
// spawn these manually when the event starts, to save on entities at load time
//
///////////////////////////////

spawn_ruins_pickup_weapons()
{

	ruins_weapons = [];
	
	ruins_weapons[0] = spawnstruct();
	ruins_weapons[0].weapon_name = "weapon_panzerschrek";
	ruins_weapons[0].origin = (1427.9, -1695.4, -234.5);
	ruins_weapons[0].angles = (287.17, 355.56, -50.1497);
	ruins_weapons[0].count = 3;

	ruins_weapons[1] = spawnstruct();
	ruins_weapons[1].weapon_name = "weapon_panzerschrek";
	ruins_weapons[1].origin = (571.5, -1579.8, -230.5);
	ruins_weapons[1].angles = (287.17, 48.8599, -50.1497);
	ruins_weapons[1].count = 3;

	spawn_pickup_weapons( ruins_weapons );
	
}

