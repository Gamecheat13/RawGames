#include common_scripts\utility;
#include maps\_utility;
#include maps\_shg_common;
#include maps\_anim;
#include maps\castle_code;
#include maps\_audio;

// Start Functions	/////////////////////////////////////////////////////////////////////////////////////
start_destroy_wet_wall()
{
	move_player_to_start( "start_into_wet_wall" );
	setup_price_for_start( "start_into_wet_wall" );
	
	flag_set( "price_across_bridge" );

	level thread thundercracker();
	maps\_utility::vision_set_fog_changes( "castle_interior", 0 );

}
	
start_into_wet_wall()
{
	move_player_to_start( "start_into_wet_wall" );
	setup_price_for_start( "start_into_wet_wall" );

	set_lightning( 7, 10, (330, 315, 0), "lightning_wet_wall" );
	level thread thundercracker();
	maps\_utility::vision_set_fog_changes( "castle_interior", 0 );
}

// Init Functions	/////////////////////////////////////////////////////////////////////////////////////

init_event_flags()
{
	flag_init( "objective_time_wall_charge" );

	flag_init( "wet_wall_start" );
	flag_init( "price_ready_for_lightning" );
	flag_init( "okay_to_detonate" );
	flag_init( "wet_wall_goofed" );
	flag_init( "wet_wall_destroyed" );
	flag_init( "going_to_die" );
	
	flag_init( "wall_climb_start" );
	flag_init( "waiting_for_input" );
	flag_init( "price_climb_wait_end" );
	flag_init( "peephole_start" );
	flag_init( "player_slips" );
	flag_init( "tv_off" );
	flag_init( "peephole_react" );	// guards react to peeping
	flag_init( "stop_peeping" );

	// Price dialog flags
	flag_init( "price_say_discover_wet_wall" );
//	flag_init( "price_say_set_detcord" );
	flag_init( "price_say_time_explosion" );
}


// Main Functions	/////////////////////////////////////////////////////////////////////////////////////


//
//  Encompasses:
//		Price checking the wire hole and planting detcord
//		Player times detonation with thunder clap
destroy_wet_wall()
{
	//hide various destroyed walls for the segment
	m_wall_destroyed = GetEntArray( "wet_wall_destroyed", "targetname" );
	foreach( wall in m_wall_destroyed )
	{
		wall Hide();
	}
	m_anim_wall = GetEnt( "fxanim_castle_enter_wall_mod", "targetname" );
	m_anim_wall Hide();
	
	m_kitchen_destroyed = GetEnt( "kitchen_wall_destroyed", "targetname" );
	m_kitchen_destroyed Hide();
	
	flag_wait_all( "price_across_bridge", "wet_wall_start" );
	
	exploder(1030);
	
	//level thread player_stealth_fail();

	set_lightning( 7, 10, (330, 315, 0), "lightning_wet_wall" );
	level thread thundercracker();
	
	level thread manage_lightning_lights();
	
	level.price thread price_destroy_wet_wall_dialog();

	level wall_detonation();
}


/*player_stealth_fail()
{
	//this function ends once courtyard is spawned, a more elaborate function takes over
	level endon( "wet_wall_goofed" );
	level endon( "player_slips" );
		
	//wait until player fires his weapon or throws a grenade
	while( 1 )
	{
		msg = level.player waittill_any_return( "weapon_fired", "grenade_fire" );
		if( msg == "grenade_fire" )
			break;
		if( msg == "weapon_fired" )
		{
			weap = level.player GetCurrentWeapon(); 
			if( ( weap != level.castle_main_weapon ) && ( weap != level.castle_side_weapon ) && ( weap != "c4" ) )
    			break;
		}
	}
	
	flag_set( "going_to_die" );
	level.price thread dialogue_queue( "castle_pri_spotted" );
		
	//spawn based on player position
	aigroup = undefined;
	if( level.player.origin[1] > 3000 )
	{
		a_sp_alert = GetEntArray( "spawn_wetwall_alerted_south", "targetname" );
		aigroup = "wetwall_alert_south";
		array_thread( a_sp_alert, ::spawn_ai );
	}
	else
	{
		a_sp_alert = GetEntArray( "spawn_wetwall_alerted_north", "targetname" );
		aigroup = "wetwall_alert_north";
		array_thread( a_sp_alert, ::spawn_ai );
	}
	
	level.price.allowdeath = true;	// just in case
	level.price stop_magic_bullet_shield();
	
	level.price delayThread( 10, ::die );
	
	level.price waittill( "death", other );

	quote = undefined;
	if ( isplayer( other ) )
		// Friendly fire will not be tolerated.
		quote = &"SCRIPT_MISSIONFAIL_KILLTEAM_BRITISH";
	else
		// Your actions got Captain Price killed.
		quote = &"CASTLE_YOUR_ACTIONS_GOT_PRICE";

	setDvar( "ui_deadquote", quote );
	missionFailedWrapper();
}*/

//
//  Encompasses:
//		Spider climb up the wet wall
//		Peep show with Makarov
//		Fall into the kitchen
into_wet_wall()
{
	flag_wait( "wet_wall_destroyed" );

	level thread tv_room_movie();

	exploder( 1001 );	// detcord explosion
	
	
	m_anim_wall = GetEnt( "fxanim_castle_enter_wall_mod", "targetname" );
	m_anim_wall Show();
	m_anim_wall.animname = "wet_wall";
	m_anim_wall assign_animtree();
	m_anim_wall thread anim_single_solo( m_anim_wall, "detonate" );

	if ( Distance( m_anim_wall.origin, level.player.origin ) < 50 )
	{
		level.player DoDamage( 1000, m_anim_wall.origin );
		//level.player StunPlayer( 4.0 );
		//level.player ShellShock( "default", 4.0 );
	}
	
	if ( Distance( m_anim_wall.origin, level.player.origin ) > 50 && Distance( m_anim_wall.origin, level.player.origin ) < 150 )
	{
		level.player DoDamage( 100, m_anim_wall.origin );
		level.player StunPlayer( 4.0 );
		level.player ShellShock( "default", 4.0 );
	}
	
	//swap walls
	//m_wall_destroyed = GetEnt( "wet_wall_destroyed", "targetname" );
	
	m_wall_destroyed = GetEntArray( "wet_wall_destroyed", "targetname" );
	foreach( wall in m_wall_destroyed )
	{
		wall Show();
	}
	//m_wall_destroyed Show();
	m_wall = GetEntArray( "wet_wall_full", "targetname" );
	foreach( piece in m_wall )
	{
		piece Delete();
	}
	
	
	Earthquake( 0.4, 0.8, level.player.origin, 2000 );
	level.player PlayRumbleOnEntity( "damage_heavy" );
	
	if( flag( "wet_wall_goofed" ) )
	{
		flag_waitopen( "wet_wall_goofed" );
	}

	level thread wet_wall_climb();

	flag_wait( "wall_climb_start" );

	set_lightning( 5, 10 );
	//battlechatter_off( "axis" );

	level thread into_wet_wall_cleanup();
}


//
//	Support Functions
//


//
//	Delayed thunder sound
thundercracker()
{
	level endon( "wall_climb_start" );
	
	s_loc = GetEnt( "thunder_loc", "targetname" );
	while (1)
	{
		level waittill( "lightning_bolt" );
		//wait( 3.0 );
		wait( 2.0 );

		if ( flag( "price_ready_for_lightning" ) )
		{
			s_loc PlaySound( "scn_castle_detcord_wall_thunder" );
		}
		else
		{
			s_loc PlaySound( "elm_thunder_strike" );
		}
	}
}

// turn off lightning spotlights for wetwall if you backtrack outside.
manage_lightning_lights()
{
	level endon("peephole_start");

	while(1)
	{
		flag_clear("show_wetwall_lightning");
		flag_wait("show_wetwall_lightning");
		set_lightning( 7, 10, (330, 315, 0), "lightning_wet_wall" );

		flag_clear("hide_wetwall_lightning");
		flag_wait("hide_wetwall_lightning");
		_disable_local_lightning_lights( "lightning_wet_wall" );
	}
}

//
//	Price finds a space that will get them up to their target location
//	So we need to blow it open
wall_detonation()
{
	level.price endon( "death" );
	
	s_align = get_new_anim_node( "spiderclimb" );
	
	// Price investigates the hole and then rigs it to blow
	s_align anim_reach_solo( level.price, "wet_wall_investigate" );
	
	aud_send_msg("price_set_detcord");
	
	// Pull out the fiber optic cam
	flag_set( "price_say_discover_wet_wall" );

	m_camera = spawn_anim_model( "camera" );
	a_actors = [ level.price, m_camera ];
	s_align anim_single( a_actors, "wet_wall_investigate" );
	m_camera Delete();
	
	// Price lines the wall with detcord
	m_detcord = spawn_anim_model( "detcord" );
	a_actors = [ level.price, m_detcord ];
	s_align anim_single( a_actors, "wet_wall_place_detcord" );

	// Hard save wait so the dialog isn't cut off from the save
	level thread autosave_by_name( "timing detcord" );
	stop_exploder(1030);

	// Price goes to the window to watch for lightning flashes
	flag_set( "price_say_time_explosion" );
	s_align anim_reach_solo( level.price, "wet_wall_signal_move_to_window" );
	s_align thread anim_single_solo( level.price, "wet_wall_signal_move_to_window" );
	
	wait(3.25); //anim is 4.40s
	// Player has to time detonation to the thunderclap
	level.player thread player_time_explosion();
	level.price waittillmatch( "single anim", "end" );
	
	level.price thread price_time_explosion( s_align );
	
	flag_wait( "price_ready_for_lightning" );
//---JZ trying slightly less random lightning delay, resetting time.
	//set_lightning( 7.0, 8.0, (330, 315, 0), "lightning_wet_wall" );

	// Okay now prepare to detonate the wall
	// Player has to time detonation to the thunderclap
	//level.player thread player_time_explosion();
	flag_wait("wet_wall_destroyed" );

//---JZ setting back to default
	set_lightning( 7, 10, (330, 315, 0));
	
	m_detcord Delete();
	s_align notify( "end_signal_idle");	//
	if ( flag( "wet_wall_goofed" ) )
	{
		aigroup = undefined;
		if( level.player.origin[1] > 3000 )
		{
			a_sp_alert = GetEntArray( "spawn_wetwall_alerted_south", "targetname" );
			aigroup = "wetwall_alert_south";
			array_thread( a_sp_alert, ::spawn_ai );
		}
		else
		{
			a_sp_alert = GetEntArray( "spawn_wetwall_alerted_north", "targetname" );
			aigroup = "wetwall_alert_north";
			array_thread( a_sp_alert, ::spawn_ai );
		}
		
		//thread allow_price_to_die();
		
		level thread wall_detonation_goes_hot( aigroup );
	}
}

wall_detonation_goes_hot( aigroup )
{
	waittill_aigroupcleared( aigroup );
		
	flag_clear( "wet_wall_goofed" );
}

//
//	Price watches for lightning to help time the explosion
// self is level.Price
price_time_explosion( s_align )
{
	level endon( "wet_wall_destroyed" );

	while ( !flag("wet_wall_destroyed" ) )
	{
		s_align thread anim_loop_solo( self, "wet_wall_signal_idle", "end_signal_idle" );
		flag_wait( "price_ready_for_lightning" );	// don't start this until dialog is ready
		level waittill( "lightning_bolt" );
		//wait( 3.0 );
		wait( 2.0 );

		s_align notify( "end_signal_idle");
		s_align anim_single_solo( self, "wet_wall_signal_flash" );
	}
}


//
//	Gives the player the detonator and waits for him to pull the trigger.  
//	Wall go BOOM!
player_time_explosion( )
{
	flag_set( "objective_time_wall_charge" );
	
	level.player maps\_c4::switch_to_detonator();
	//level.player DisableWeaponSwitch();
	
	level.player waittill( "detonate" );
	
	
	level.player thread maps\_c4::remove_detonator();
	//level.player EnableWeaponSwitch();

	// Blow the detcord!
	if ( !flag( "okay_to_detonate" ) && !flag( "going_to_die" ) )
	{
		flag_set( "wet_wall_goofed" );
	}

	flag_set( "wet_wall_destroyed" );
}


//
//	If the player flubs, Price becomes vulnerable
allow_price_to_die()
{
//TODO Temp disable for now.  Need to make him not play anim if player fucks up.  Wait until it's resolved first.
	level.price stop_magic_bullet_shield();
	
	level.price waittill( "death", other );

	quote = undefined;
	if ( isplayer( other ) )
		// Friendly fire will not be tolerated.
		quote = &"SCRIPT_MISSIONFAIL_KILLTEAM_BRITISH";
	else
		// Your actions got Captain Price killed.
		quote = &"CASTLE_YOUR_ACTIONS_GOT_PRICE";

	setDvar( "ui_deadquote", quote );
	missionFailedWrapper();
}
	

//
//	Handles the player and Price climbing the wall, seeing the scene at the top and then falling into the kitchen
wet_wall_climb()
{
	level thread player_climb_wet_wall();

	level.price thread price_climb_wet_wall();

	battlechatter_off( "axis" );
	level thread tv_room_scene();

	flag_wait( "peephole_react" );	// guards react to peeping
}

remove_player_block()
{
	// Wait for Price to run up to the opening before the player can get in
	bm_clip = GetEnt( "wetwall_player_clip", "targetname" );
	bm_clip Delete();
}

//
//	Price climbs the wet wall, watches a movie and then falls into the kitchen
//	self is Price
#using_animtree( "generic_human" );
price_climb_wet_wall()
{
	self endon( "death" );
	
	s_align = get_new_anim_node( "spiderclimb" );
	
	self enable_cqbwalk();

	s_align anim_reach_solo( self, "spiderclimb_enter" );
	//delayThread( 17, ::remove_player_block );
	
	self delaythread( 6.25, ::dialogue_queue, "castle_pri_climbuphere" );
	
	delayThread( 12, ::remove_player_block ); //originally 13
	s_align thread anim_single_solo( self, "spiderclimb_enter" );
	
	self disable_cqbwalk();
	
	aud_send_msg("price_start_climb");
	
	waittill_any_ents(level, "player_started_climbing", s_align, "spiderclimb_enter" );
	
	s_align thread anim_loop_solo( self, "spiderclimb_wait_idle" );
	
	flag_wait( "price_climb_wait_end" );

	aud_send_msg("price_start_climb2");
	
	s_align notify( "stop_loop" );
	
	// Restore Price's bullet shield if you messed up earlier
	if ( flag( "wet_wall_goofed" ) )
	{
		level.price thread magic_bullet_shield();
	}

	//	Let Price climb up and then idle for now
	s_align anim_single_solo( self, "spiderclimb_climb_up" );
	
	s_align thread anim_loop_solo( self, "peep_show_wait_idle" );
	flag_wait( "peephole_start" );
	s_align notify( "stop_loop" );
	
	// allow the full animation to finish before blending into peep_show
	//while( !flag( "peephole_start" ) )
	//{
	//	s_align anim_single_solo( self, "peep_show_wait_idle" );
	//}
	
	s_align anim_single_solo( self, "peep_show" );
}
	
price_vo1(guy)
{
	level.price dialogue_queue( "castle_pri_makarov" );
}

price_vo2(guy)
{
	level.price dialogue_queue( "castle_pri_timetogo" );
}

price_vo3(guy)
{
	level.price dialogue_queue( "castle_pri_thebodies" );
}

price_vo4(guy)
{
	level.price dialogue_queue( "castle_pri_withthis" );
}

//
//	Player climbs the wet wall, watches a movie and then falls into the kitchen
player_climb_wet_wall()
{
	s_align = get_new_anim_node( "spiderclimb" );
	
	flag_wait( "wall_climb_start" );

//-----JZ - forcing nightvision off with animation
	if( isDefined (level.player.nightVision_Enabled))
	{
		level.player SetActionSlot( 1, "" ); // temporarilly disable "real" nightvision
		
	    current_weapon = level.player GetCurrentWeapon();
	    level.player ForceViewmodelAnimation( current_weapon , "nvg_up" );
	    //wait(0.1);
		level.player NightVisionGogglesForceOff();
		wait(1);
		
		level.player SetActionSlot( 1, "nightvision" ); // player can now use "real" night vision
	}
//-----JZ - END forcing nightvision off with animation
	
//-----JZ - making weapon go down instead of just disappearing.
	level.player DisableWeapons();
	wait(.25);
//-----JZ - end making weapon go down instead of just disappearing.
	
	level thread notify_delay( "player_started_climbing", 3 );
	
	level.player FreezeControls( true );
	level.player AllowCrouch( false );
	level.player AllowProne( false );
	level.player SetStance( "stand" );

	// str_scene, additional_ents, b_ground_trace, b_lerp_time, b_freeze_controls, b_allow_look, n_max_left, n_max_right, n_max_up, n_max_down )
	aud_send_msg("player_start_climb");
	s_align thread player_anim_start( "wall_climb_start", undefined, false, 0.5, true, true, 0, 0, 0, 0 );
	level.player.m_player_rig DontCastShadows();
	s_align waittill( "wall_climb_start" );
	
	level.player FreezeControls( false );

	s_align climb_controller();
//	flag_set( "peephole_start" );

	level.player PlayerLinkToBlend( level.player.m_player_rig, "tag_player", 0.75 );
	//wait(.75);
	//level.player PlayerLinkToDelta( level.player.m_player_rig, "tag_player", 1.0, 0, 0, 0, 0 );
	s_align thread anim_single_solo( level.player.m_player_rig, "wall_climb_peek_start" );
	wait( 0.05 );

	s_align waittill( "wall_climb_peek_start" );
	
	level.player PlayerLinkToBlend( level.player.m_player_rig, "tag_player", 1.0 );
	level.player PlayerLinkToDelta( level.player.m_player_rig, "tag_player", 1.0, 30, 45, 25, 15 );
	s_align thread anim_loop_solo( level.player.m_player_rig, "wall_climb_peek_idle" );
	flag_wait( "player_slips" );

	// Part of the wall snaps off
	/*m_peep_hole = GetEnt( "wetwall_wood_break", "targetname" );
	m_peep_hole.animname = "peep_hole_piece";
	m_peep_hole assign_animtree();
	s_align_hole = get_new_anim_node( "spiderclimb" );
	s_align_hole thread anim_single_solo( m_peep_hole, "wall_climb_peek_slip" );*/
	
	//delayThread( 7.5, ::boards_shot );
	
	//-----JZ - making weapons available again.
	//level.player EnableWeapons();
	//-----JZ - end making weapons available again.
	
	level.player Unlink();
	//level.player PlayerLinkToBlend( level.player.m_player_rig, "tag_player", 0.5, 0.1, 0.1 );
	s_align notify( "stop_loop" );
	//s_align anim_single_solo( level.player.m_player_rig, "wall_climb_peek_slip" );
	flag_set( "stop_peeping" );
	aud_send_msg("player_wetwall_jump");
}

#using_animtree( "script_model" );
boards_shot()
{
	m_boards = GetEnt( "fxanim_castle_peep_hole_boards_mod", "targetname" );
	m_boards.animname = "peep_hole_fx";
	m_boards UseAnimTree( #animtree );
	m_boards thread anim_single_solo( m_boards, "wall_climb_peek_slip" );	
}

//	This handles climbing sequence
//	If you want to disable inputs, modify the notetrack_handler
//
#using_animtree( "player" );

CLIMB_CLAMP_LEFT = 30;
CLIMB_CLAMP_RIGHT = 30;
CLIMB_CLAMP_UP = 65;
CLIMB_CLAMP_DOWN = 40;

climb_controller()
{
	ANIM_FORWARD = level.scr_anim[ "player_rig" ][ "wall_climb_full" ];

	anim_current = ANIM_FORWARD;
	anim_dest = ANIM_FORWARD;
	
	m_player_rig = level.player.m_player_rig;

	m_player_rig thread climb_notetrack_handler( );

	m_player_rig StopAnimScripted();	// makes sure the climb in anim is cleared out
	m_player_rig SetFlaggedAnim( "wall_climb_full", anim_current, 1, 0, 0 );
	m_player_rig SetAnimTime( anim_current, 0 );
	
	level.player Unlink();
	level.player PlayerLinkToBlend( level.player.m_player_rig, "tag_player", 0.2 );
	level.player PlayerLinkToDelta( level.player.m_player_rig, "tag_player", 1.0, 30, 30, 25, 30 );
	
	n_current_time = 0;
	MAX_SPEED_SCALE = 1.5;
	
	while ( ( n_current_time < 1 ) || ( anim_current != ANIM_FORWARD ) )
	{
		wait 0.05;

		if ( flag( "waiting_for_input" ) || !IsAlive( level.player ) )
		{
			forward_movement = 0;
		}
		else
		{
			// Play animation at 100-150% speed
			normalized_movement = level.player GetNormalizedMovement();
			forward_movement = 1 + (normalized_movement[0] * 0.5);
		}

		n_current_time = m_player_rig GetAnimTime( anim_current );

		if ( anim_current != anim_dest )
		{
			anim_fraction = 1 - n_current_time;
			
			m_player_rig ClearAnim( anim_current, 0 );
			m_player_rig SetFlaggedAnim( "wall_climb_full", anim_dest, 1, 0, clamp( abs( forward_movement ), 0, MAX_SPEED_SCALE ) );
			m_player_rig SetAnimTime( anim_dest, anim_fraction );
			
			anim_current = anim_dest;
			n_current_time = anim_fraction;
		}
		else
		{
			m_player_rig SetFlaggedAnim( "wall_climb_full", anim_current, 1, 0, clamp( abs( forward_movement ), 0, MAX_SPEED_SCALE ) );
		}
	}
}


// Notetrack functions for particles when the hand is planted on the walls
//
right_hand_plant( m_player_rig )
{
	// Orientation of the vector perpendicular to the right wall is the opposite of the align node
	s_align = GetStruct( "spiderclimb", "targetname" );
	v_forward = AnglesToForward( s_align.angles + (0,-90,0) );
	
	v_tag_pos = m_player_rig GetTagOrigin( "J_Wrist_RI" );
	PlayFX( level._effect["wall_hand_plant"], v_tag_pos, v_forward );
	level.player PlayRumbleOnEntity( "damage_light" );
}
//
//
left_hand_plant( m_player_rig )
{
	// Orientation of the vector perpendicular to the left wall is the same as the align node
	s_align = GetStruct( "spiderclimb", "targetname" );
	v_forward = AnglesToForward( s_align.angles + (0,-90,0) );
	
	v_tag_pos = m_player_rig GetTagOrigin( "J_Wrist_LE" );
	PlayFX( level._effect["wall_hand_plant"], v_tag_pos, v_forward );
	level.player PlayRumbleOnEntity( "damage_light" );
}

//Notetrack functions for audio
//
aud_cstl_wetwall_grip()
{
	ent = Spawn("script_origin", level.player.origin);
	ent PlaySound("cstl_wetwall_grip", "sounddone");
	ent waittill("sounddone");
	ent Delete();
}

aud_cstl_wetwall_step()
{
	ent = Spawn("script_origin", level.player.origin);
	ent PlaySound("cstl_wetwall_step", "sounddone");
	ent waittill("sounddone");
	ent Delete();
}

aud_cstl_wetwall_foley()
{
	ent = Spawn("script_origin", level.player.origin);
	ent PlaySound("cstl_wetwall_foley", "sounddone");
	ent waittill("sounddone");
	ent Delete();
}


//
// self is the player rig
//	str_notetrack is the notetrack to listen for
//	str_input is the button to wait for
climb_notetrack_handler()
{
	self endon( "death" );
	
	while ( 1 )
	{
		self waittill( "wall_climb_full", str_notetrack );

		switch( str_notetrack )
		{
			case "left_hand_on":
				level thread left_hand_plant( self );
				break;
			case "right_hand_on":
				level thread right_hand_plant( self );
				break;
			case "input_left":
				flag_set( "waiting_for_input" );
				//				get_input( "LT" );
				get_forward_movement();
				break;
			case "input_right":
				flag_set( "waiting_for_input" );
				//				get_input( "RT" );
				get_forward_movement();

				flag_set( "price_climb_wait_end" );
				break;
			case "input_both":
				flag_set( "waiting_for_input" );
				//				get_input( "LT+RT" );
				get_forward_movement();
				break;
				
			//audio
			case "ps_cstl_wetwall_grip":
				{
				thread aud_cstl_wetwall_grip();
				}
				break;
			case "ps_cstl_wetwall_step":
				{
				thread aud_cstl_wetwall_step();
				}
				break;
			case "ps_cstl_wetwall_foley":
				{
				thread aud_cstl_wetwall_foley();
				}
				break;
		}
	}
}


//
//	self = player
player_wall_climb_cycle( s_main_align )
{
//  	level endon( "peephole_start" );
	
  	// angle
	s_align = Spawn( "script_origin", level.player.origin );
	s_align.angles = s_main_align.angles;	// Need to face inside the wall

	n_iterations = 0;
	while ( !flag( "peephole_start" ) )
	{
		if ( n_iterations == 0 )
		{
			idle_until_input( "RT", 	s_align, "wall_climb_start_idle",	"wall_climb_right_hand" );
		}
		else
		{
			idle_until_input( "RT", 	s_align, "wall_climb_idle",			"wall_climb_right_hand" );
		}

		idle_until_input( "LT", 	s_align, "wall_climb_right_hand_idle",	"wall_climb_left_hand" );
		
		idle_until_input( "LT+RT", 	s_align, "wall_climb_both_hands_idle",	"wall_climb_both_hands_push_up" );
		
		// Price thinks you can handle climbing now
		n_iterations++;
		switch( n_iterations )
		{
		case 1:
			flag_set( "price_climb_wait_end" );
			level.player Unlink();
			level.player PlayerLinkToDelta( level.player.m_player_rig, "tag_player", 0.9, 30, 30, 25, 30);
			break;
		case 2:
			level.player Unlink();
			level.player PlayerLinkToDelta( level.player.m_player_rig, "tag_player", 0.7, 30, 30, 25, 30 );
			break;
		case 3:
			level.player Unlink();
			level.player PlayerLinkToDelta( level.player.m_player_rig, "tag_player", 0.4, 30, 30, 25, 30 );
			break;
		case 4:
			break;
		}
	}

	s_align notify( "stop_idle" );

	s_align Delete();
}


//
//	Wait for input, but make sure the player's not just holding the button down.
//idle_until_input( str_input, s_align, str_climb_anim, str_idle_anim )
idle_until_input( str_input, s_align, str_idle_anim, str_climb_anim )
{
//	level endon( "peephole_start" );
	
	str_kill_anim_msg = "stop_idle";

	// Loop the idle until the input comes in
	if ( !flag( "peephole_start" ) )
	{
		level thread get_input( str_input, s_align, str_kill_anim_msg );

		// Play loop animation
		s_align.origin = level.player.m_player_rig.origin;
		s_align anim_loop_solo( level.player.m_player_rig, str_idle_anim, str_kill_anim_msg );
	}

	// Now play the next anim in the sequence
	s_align.origin = level.player.m_player_rig.origin;
	s_align anim_single_solo( level.player.m_player_rig, str_climb_anim );
}


//
//	Wait until the desired input is received.
get_input( str_input, s_align, str_kill_anim_msg )
{
	str_hint = "";	// scope declaration
	switch( str_input )
	{
		case "LT":
			str_hint = &"CASTLE_HINT_CLIMB_LEFT";
			break;

		case "RT":
			str_hint = &"CASTLE_HINT_CLIMB_RIGHT";
			break;

		case "LT+RT":
			str_hint = &"CASTLE_HINT_CLIMB_UP";
			break;
	}
	level thread hint( str_hint );

	b_got_input = false;

//	b_waiting_for_release = true;
	b_waiting_for_release = false;	// Temp allow people to hold buttons down
	
	// Make sure the player isn't already holding down the button we want
	while ( !b_got_input || b_waiting_for_release )
	{
		switch( str_input )
		{
			case "LB":
				b_got_input = level.player SecondaryOffhandButtonPressed();
				break;
				
			case "RB":
				b_got_input = level.player FragButtonPressed();
				break;
				
			case "LT":
				b_got_input = level.player AdsButtonPressed();
				break;

			case "RT":
				b_got_input = level.player AttackButtonPressed();
				break;

			case "LT+RT":
				b_got_input = level.player AdsButtonPressed() && level.player AttackButtonPressed();
				break;
		}
		
		// If the player isn't holding down the button already, 
		// then we can accept the input the next time it is pressed.
		if ( b_waiting_for_release && !b_got_input )
		{
			b_waiting_for_release = false;			
		}
		
		wait( 0.05 );
	}
	
	level thread hint_fade();
	
	flag_clear( "waiting_for_input" );
//	s_align notify( str_kill_anim_msg );
}


//
//	Loop until we get forward movement on the stick
get_forward_movement()
{
	forward_movement = 0;
	
	level thread climb_hint();
	
	while ( forward_movement < 0.25 )
	{
		normalized_movement = level.player GetNormalizedMovement();
		forward_movement = normalized_movement[0];
		
		wait( 0.05 );
	}
	
	level notify( "stop_hint" );
	level thread hint_fade();
	
	flag_clear( "waiting_for_input" );
}

climb_hint()
{
	level endon( "stop_hint" );
	
	wait 2.0;
	
	level thread hint( &"CASTLE_HINT_CLIMB");
}

//
//	Handles the actors and events occurring inside the TV room
tv_room_scene()
{
	s_align = get_new_anim_node( "spiderclimb" );

	a_sp_tv_room_guys = GetEntArray( "tv_room_guy", "targetname" );
	array_thread( a_sp_tv_room_guys, ::add_spawn_function, ::guy_tv_room_scene, s_align );
	
	activate_trigger( "trig_tv_room_guys", "targetname" );
	
	flag_wait( "peephole_start" );
	
	a_lights = GetEntArray( "lightning_wet_wall", "targetname" );
	level.a_e_local_lightning = array_remove_array( level.a_e_local_lightning, a_lights );
	foreach( light in a_lights )
	{
		light SetLightIntensity( 0 );
	}

	//	Start their scene
	level.ai_president thread anim_single_solo( level.ai_president, "tv_scene" );
	level.ai_makarov   thread anim_single_solo( level.ai_makarov, "tv_scene" );
	
	s_align thread anim_single_solo( level.ai_tv_room_guy4, "peep_show" );
	
	a_ai_tv_room_guys = get_ai_group_ai( "tv_room_guys" );
	s_align anim_single( a_ai_tv_room_guys, "peep_show" );

	flag_set( "peephole_react" );

	s_align anim_single( a_ai_tv_room_guys, "peep_show_react" );
}


//
//	Notetrack callback.  Start playing the player slip anim.
slip_start( guy )
{
	flag_set( "player_slips" );
}

//
//	Setup the guys for the TV room scene, also clean him up at the end
guy_tv_room_scene( s_align )
{
	self.ignoreall = true;
	self.animname = self.script_noteworthy;
	switch ( self.animname )
	{
		
		case "president":
			level.ai_president = self;
			break;
		case "makarov":
			level.ai_makarov = self;
			break;
		case "alexi":
			level.ai_alexi = self;
			break;
		case "tv_room_guy1":
			level.ai_tv_room_guy1 = self;
			break;
		case "tv_room_guy2":
			level.ai_tv_room_guy2 = self;
			break;
		case "tv_room_guy3":
			level.ai_tv_room_guy3 = self;
			break;
		case "tv_room_guy4":
			level.ai_tv_room_guy4 = self;
	}
	add_cleanup_ent( self, "wet_wall" );
}


//
//	Notetrack callback - plays the bullet hole FX in the wall
wet_wall_bullet_holes( ai_guy )
{
	//exploder( 1002 );	// Bullet holes
}


//
//	Play scene in the TV room to show important plot point
//	uses bink movie on a texture
tv_room_movie()
{
	flag_wait( "tv_start_static" );
	
	SetSavedDvar( "cg_cinematicFullScreen", "0" );
	CinematicInGameLoopResident( "castle_static" );
	
	flag_wait( "peephole_start" );
	//SetSavedDvar( "cg_cinematicFullScreen", "0" );
	CinematicInGame( "castle_tv" );
	
	level.ai_alexi waittillmatch( "single anim", "alarm_start" );
	
	CinematicInGameLoopResident( "castle_static" );

	flag_wait( "tv_off" );

	StopCinematicInGame();
}

alarm_start( guy )
{
	aud_send_msg("play_alarm");
}

//---Price throws grenade at end of scene
wetwall_grenade(guy)
{
	grenade_rig = spawn_anim_model( "peep_hole_grenade" );
	s_align = get_new_anim_node( "spiderclimb" );
	grenade = GetEnt( "wetwall_grenade", "targetname" );
	
	sound_loc = spawn_tag_origin();
	sound_loc.origin = grenade.origin;
	sound_loc.angles = grenade.angles;
	
	s_align thread anim_first_frame_solo( grenade_rig, "wall_climb_grenade_toss" );
	
	rig_origin = grenade_rig GetTagOrigin( "J_prop_1" );
	rig_angles = grenade_rig GetTagAngles( "J_prop_1" );

	grenade.origin = rig_origin;
	grenade.angles = rig_angles;
		
	grenade linkto( grenade_rig , "J_prop_1" );
	
	s_align thread anim_single_solo( grenade_rig, "wall_climb_grenade_toss" );
	
	//AUDIO/FX - put sounds/FX here.
	
	grenade_rig waittillmatch( "single anim", "grenade_bounce" );
	sound_loc PlaySound( "grenade_bounce_concrete" );	
	
	grenade_rig waittillmatch( "single anim", "grenade_bounce2" );
	sound_loc PlaySound( "grenade_bounce_concrete" );
	
	grenade_rig waittillmatch( "single anim", "bounce_to_roll" );
	sound_loc PlaySound( "grenade_bounce_concrete" );	
	
	grenade_rig waittillmatch( "single anim", "grenade_explode" );
	sound_loc PlaySound( "grenade_explode_concrete" );
	exploder ( 834 ); //Grenade FX
}

//
//	Cleanup any mess we created
into_wet_wall_cleanup()
{
	flag_wait( "kitchen_start" );

	// Cleanup the TV room
	cleanup_ents( "wet_wall" );
	
	//turn off TVs in level	
	flag_set( "tv_off" );
}

//	dialog lines for wetwall discovery 
//	self is Price
price_destroy_wet_wall_dialog()
{
	self endon( "death" );
	level endon( "going_to_die" );
	
	flag_wait( "price_say_discover_wet_wall" );

	self dialogue_queue( "castle_pri_holdon" );
	wait(3.5);
	self dialogue_queue( "castle_pri_changeofplan" );
	wait(.75);
	self dialogue_queue( "castle_pri_justaboveus" );
	wait(2.5);
	self dialogue_queue( "castle_pri_shootourway" );

//	flag_wait( "price_say_set_detcord" );

	flag_wait( "price_say_time_explosion" );
	
	set_lightning( 6.0, 7.0, (330, 315, 0));
	self dialogue_queue( "castle_pri_waitformysignal2" );

	flag_set( "price_ready_for_lightning" );
		
	level.price price_wet_wall_lightning_dialog();

	if ( flag( "wet_wall_goofed" ) )
	{
		self dialogue_queue( "castle_pri_pisspoor" );
		//self anim_single_solo( self, "castle_pri_stupid" );
		adjust_price_attitude( -5 );
	}
	else
	{
		adjust_price_attitude( 5 );	// well done
	}
}


//	Price's dialog for the wetwall detonation section
//	self is Price
price_wet_wall_lightning_dialog()
{
	level endon( "wet_wall_destroyed" );

	level.n_lightning_misses = 0;
	while ( !flag( "wet_wall_destroyed" ) )
	{
		level waittill( "lightning_bolt" );
		
		wait( 2.0 );	// thunder should occur 2 seconds after the flash
		
		flag_set( "okay_to_detonate" );
		random_nag = RandomIntRange( 0, 3 );
		switch( random_nag )
		{
			case 0:
				self dialogue_queue( "castle_pri_now3" );
				break;
			case 1:
				self dialogue_queue( "castle_pri_go3" );
				break;
			case 2:
				self dialogue_queue( "castle_pri_blowit" );
				break;	
			case 3:
				self dialogue_queue( "castle_pri_doit2" );
				break;					
		}
		
		
		wait( 1.5 );
		
		flag_clear( "okay_to_detonate" );
		
		level.n_lightning_misses++;
		switch( level.n_lightning_misses )
		{
			case 1:
				self dialogue_queue( "castle_pri_areyoudim" );
				break;
			case 3:
				self dialogue_queue( "castle_pri_focusyuri" );
				adjust_price_attitude( -1 );
				break;
			case 5:
				self dialogue_queue( "castle_pri_payattention" );
				adjust_price_attitude( -1 );
				break;				                    
		}
	}
}

alexi_vo1(guy)
{
	level.ai_alexi dialogue_queue( "castle_alx_checkwith" );
}

alexi_vo2(guy)
{
	level.ai_alexi dialogue_queue( "castle_alx_yessir" );
}

alexi_vo3(guy)
{
	level.ai_alexi dialogue_queue( "castle_alx_thedaughter" );
}

alexi_vo4(guy)
{
	level.ai_alexi dialogue_queue( "castle_alx_whatgoingon" );
}

henchman3_vo(guy)
{
	level.ai_tv_room_guy3 dialogue_queue( "castle_ru1_noresponse" );
}

henchman1_vo(guy)
{
	level.ai_tv_room_guy1 dialogue_queue( "castle_ru1_grenade" );
}
