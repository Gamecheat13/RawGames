#using scripts\codescripts\struct;

#using scripts\shared\ai_shared;
#using scripts\shared\array_shared;
#using scripts\shared\clientfield_shared;
#using scripts\shared\colors_shared;
#using scripts\shared\exploder_shared;
#using scripts\shared\flag_shared;
#using scripts\shared\gameobjects_shared;
#using scripts\shared\math_shared;
#using scripts\shared\scene_shared;
#using scripts\shared\spawner_shared;
#using scripts\shared\trigger_shared;
#using scripts\shared\util_shared;
#using scripts\shared\vehicle_shared;

#using scripts\cp\_dialog; 
#using scripts\cp\_objectives;
#using scripts\cp\_spawn_manager;
#using scripts\cp\_skipto;
#using scripts\cp\_util;
#using scripts\cp\_oed;
#using scripts\cp\_hacking;
#using scripts\cp\cybercom\_cybercom_util;

#using scripts\cp\cp_mi_sing_sgen;
#using scripts\cp\cp_mi_sing_sgen_util;
#using scripts\cp\cp_mi_sing_sgen_sound;

    	   	                                                                                                                         	                                                                                                                                                                                                                                                                                                                                                                    	        	     	             	    	   	                           	                               	                                	                                                              	                                                                                                              	                            	                                     	                                       	                                                               	   	                  	       	                                                    	                   	                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                       	                                                                                        	           	                        	                                            	                                             	                                                   	                                                             	                                                         	                                                                    	                                                                                                                                                                                                    	                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                     	                                                              	                                                          	                                   	                                   	                                                    	                                       
                                                                                       
                                                                                                      	                       	     	                                                                     

// 	Mapping Drone defines
	// For normal movement in front of the player
	// 
	//
	// For catching up or getting in front of the player
	// For full accelleration
	// Accelleration rate
	// Decelleration rate

#using scripts\cp\cp_mi_sing_sgen_exterior;
	


#precache( "fx", "light/fx_glow_robot_control_gen_2_head" );
#precache( "lui_menu_data", "close_current_menu" );

#precache( "objective", "cp_standard_breadcrumb" );

//	SKIPTO FUNCS

///////////////////////////////////////////////////////////////////
//	Discover Data
///////////////////////////////////////////////////////////////////

function skipto_discover_data_init( str_objective, b_starting )
{		
	if ( b_starting )
	{
		sgen::init_hendricks( str_objective );
		level.ai_hendricks ai::set_behavior_attribute( "cqb", true );
		level.ai_hendricks ai::set_behavior_attribute( "sprint", true );
	
		objectives::complete( "cp_level_sgen_enter_sgen" );
		objectives::set( "cp_level_sgen_investigate_sgen" );
	
		level thread cp_mi_sing_sgen_exterior::open_silo_doors();
		scene::init( "p7_fxanim_cp_sgen_overhang_building_glass_bundle" );	
		
		//turn off the trigger that moves hendricks and drone after the discover data event
		trig_post_discover_data = GetEnt( "trig_post_discover_data", "targetname" );
		trig_post_discover_data TriggerEnable( false );
		
		sgen::wait_for_all_players_to_spawn();
		
		//open the silo door on skipto
		level flag::set( "hendricks_at_silo_doors" );
		level flag::set( "silo_door_opened" );	

		foreach( player in level.players )
		{
			player clientfield::set_to_player( "sndSiloBG", 1 );
		}	
		
		//setup function here to highlight model when drone flies by it
		scene::add_scene_func( "p7_fxanim_cp_sgen_hendricks_railing_kick_bundle", &drone_highlights_glass, "init" );			
		
		scene::init( "p7_fxanim_cp_sgen_hendricks_railing_kick_bundle" );
	}
		
	level flag::wait_till( "silo_door_opened" );
	
	//init fxanim falling glass debris through silo interior
	level thread building_glass_debris();
	
	level thread discover_data_vo();
	
	// EMF trigger
	t_emf_device = GetEnt( "trig_emf_device", "targetname" );
	t_emf_device SetHintString( "Press and Hold ^3[{+activate}]^7 to Hack Device" );
	t_emf_device SetCursorHint( "HINT_NOICON");
	t_emf_device TriggerEnable( false );
	
	// Intro Hendricks
	level thread scene::play( "cin_sgen_05_01_discoverdata_vign_lookaround_hendricks" );
	level.ai_hendricks waittill( "idle_started" );	// notify notetrack added to the idle anim

    level flag::wait_till( "kane_data_callout" );
	
	// Give objective to find EMF Device
	objectives::set( "cp_level_sgen_locate_emf" );

	/#
		iPrintLnBold( "Discover EMF Source" );
	#/
		
	snd_emf = spawn( "script_origin", (t_emf_device.origin));
    snd_emf playloopsound ( "evt_emf_signal" );	
	t_emf_device TriggerEnable( true );
	t_emf_device thread emf_waypoint();
		
	t_emf_device waittill( "trigger", e_player );
	
	level flag::set( "data_discovered" );
	snd_emf stoploopsound ();	
	t_emf_device Delete();
	objectives::complete( "cp_level_sgen_locate_emf" );

	level scene::add_scene_func( "cin_sgen_05_01_discoverdata_1st_handgesture_player_dataacquired", &player_data_aquired, "play" );
	level scene::play( "cin_sgen_05_01_discoverdata_1st_handgesture_player_dataacquired", e_player );
	
	//first time spawn of the drone through natural progression
	spawn_mapping_drone();
	
	level.ai_hendricks thread discover_data_hendricks_notetracks();
	
	level thread scene::play( "cin_sgen_06_01_followleader_vign_activate_eac_drone" );
	level thread scene::play( "cin_sgen_06_01_followleader_vign_activate_eac_hendricks" );
	
	sgen_util::setup_mappy_path();
	
	//flag on trigger after glass wall
//	level flag::set( "post_discover_data" );
		
	skipto::objective_completed( str_objective );
}

function player_data_aquired( a_ents )
{
	//hacking hud progress bar - do not pass the player since he is in an animation already
	level thread hacking::hack( 2 );
	
	foreach ( e_in_scene in a_ents )
	{
		if ( IsPlayer( e_in_scene ) )
		{
			e_in_scene cybercom::cyberCom_armPulse(1);
		}
	}
}

function building_glass_debris()
{
	level thread glass_debris_timeout();
	level thread player_lookat_building();
	
	level flag::wait_till( "play_building_glass_debris" );
	
	level thread scene::play( "p7_fxanim_cp_sgen_overhang_building_glass_bundle" );	
}

function player_lookat_building()
{
	level endon( "play_building_glass_debris" );
	
	//setup triggers to have lookat
	trig_lookat_glass_debris = GetEnt( "trig_lookat_glass_debris", "targetname" );
	
	level.players[0] util::waittill_player_looking_at( trig_lookat_glass_debris.origin, 0.8, false );	
	level flag::set( "play_building_glass_debris" );
}

function glass_debris_timeout()
{
	level endon( "play_building_glass_debris" );
	
	wait 10;
	level flag::set( "play_building_glass_debris" );
}

//railing is grabbed from railing fxanim 
//highlight notify comes from drone eac anim
//kick notify comes from hendricks eac anim

function drone_highlights_glass( a_scene_ents )
{
	level flag::wait_till( "highlight_railing_glass" ); //called from the drone bundle
	
	//highlight the railing model
	a_scene_ents[ "railing_kick" ] clientfield::set( "structural_weakness", 1 );
	
	//turn off once hendricks kicks it
	level flag::wait_till( "glass_railing_kicked" );
	
	a_scene_ents[ "railing_kick" ] clientfield::set( "structural_weakness", 0 );	
}

//leaving the commented VO that are played in the animation for a timeline guide here
function discover_data_vo()
{	
//	These bodies have been here for a few days
	//level.players[0] dialog::say( "plyr_these_bodies_have_be_0" );
	
//	This look like Taylor’s work, Hendricks?
	//level dialog::remote( "kane_this_look_like_taylo_0" );
	
//	Maybe. Single shots to the head.
	//level.ai_hendricks dialog::say( "hend_maybe_single_shots_0" ); 
	
//	But in all honesty -  you have to know how dumb a question that is. Of course it’s Taylor’s work - CIA   sent them here because these fucking goons were sniffing around.
	//level.ai_hendricks dialog::say( "hend_but_in_all_honesty_0" );  
	
//	Hey.
	//level.players[0] dialog::say( "plyr_hey_0" );
	
//	Pay no heed Kane, I’m just in a bad mood.
	//level.ai_hendricks dialog::say( "hend_pay_no_heed_kane_i_0" ); 
	
	level.ai_hendricks waittill( "idle_started" );
	
//	I’m picking up an EMF source in this area - likely a small electronic device.
//	(beat)
//	Could be on one of the bodies.	
	level dialog::remote( "kane_i_m_picking_up_an_em_0" );
	
	//data ready to be found
	level flag::set( "kane_data_callout" );
	
	//wait for player grabbing data
	level flag::wait_till( "data_discovered" );
	
//	Got it... uploading data.
//	(beat)
//	Anything useful?
	level.players[0] dialog::player_say( "plyr_got_it_uploading_0" );
		
//	The looters didn’t just stumble in here - they were tipped off by the CDP.
	level dialog::remote( "kane_the_looters_didn_t_j_0" );
	
	/////////////////////////////////////////////////////////
	//
	//Hendricks releases drone here
	//
	/////////////////////////////////////////////////////////
	
	//wait until hendricks says his line from his anim, then play kanes response
	//	hend_we_re_at_the_silo_0 We’re at the silo - Activating recon drone.
//	level.ai_hendricks dialog::say( "hend_we_re_at_the_silo_0" );	
	level.ai_hendricks waittill( "activate_drone_vo_done" );
	
//	Message received and understood, Hendricks. 
//	(beat)
//	Synching Drone mapping coordinates to your HUD.
	level dialog::remote( "kane_message_received_and_0" );
	
//	You know what they say about staring too long into the abyss?
//	level.ai_hendricks dialog::say( "hend_you_know_what_they_s_0" );
	
//	level.ai_hendricks dialog::say( "hend_let_s_go_0" ); //Let’s go.
	
	//send both hendricks and drone up
	level flag::wait_till( "post_discover_data" );
	
	//	You trying to send us down a damned rabbit hole, Kane?
	level.ai_hendricks dialog::say( "hend_you_trying_to_send_u_0" );
	
//	"I just want the same thing you do, Hendricks.
//	(beat)
//	To do the right thing. Shut this situation down before it gets any worse."
	level dialog::remote( "kane_i_just_want_the_same_0" );	
}

function skipto_discover_data_done( str_objective, b_starting, b_direct, player )
{
}

//
//	Show emf location
function emf_waypoint()
{
	a_player_hud_elements = [];

	while ( !level flag::get( "data_discovered" ) )
	{
		foreach ( player in level.players )
		{
			if ( DistanceSquared( player.origin, self.origin ) < ( 256 * 256 ) &&
				 DistanceSquared( player.origin, self.origin ) > ( 64 * 64 ) &&
				 player util::is_player_looking_at( self.origin, 0.65, false ) &&
				 SightTracePassed( player.origin + ( 0, 0, 64 ), self.origin + ( 0, 0, 64 ), false, undefined ) )
			{
				if ( !IsDefined( a_player_hud_elements[ player.entnum ] ) )
				{
					hud_emf = NewClientHudElem( player );
					hud_emf.x = self.origin[ 0 ];
					hud_emf.y = self.origin[ 1 ];
					hud_emf.z = self.origin[ 2 ] + 30;
					hud_emf.alpha = 0.61;
					hud_emf.archived = true;
					hud_emf SetShader( "t7_hud_prompt_beacon_64", 7, 7);
					hud_emf SetWaypoint( true ) ;

					a_player_hud_elements[ player.entnum ] = hud_emf;
				}
			}
			else
			{
				if ( IsDefined( a_player_hud_elements[ player.entnum ] ) )
				{
					a_player_hud_elements[ player.entnum ] Destroy();
				}
			}
		}

		wait randomfloatrange(0.1-0.1/3,0.1+0.1/3);
	}
	
	// Kill all indicators
	foreach ( player in level.players )
	{
		if ( IsDefined( a_player_hud_elements[ player.entnum ] ) )
		{
			a_player_hud_elements[ player.entnum ] Destroy();
		}
	}
}
	
	

///////////////////////////////////////////////////////////////////
//	Follow the Leader 1
///////////////////////////////////////////////////////////////////

function skipto_aquarium_shimmy_init( str_objective, b_starting )
{
	if ( b_starting )
	{
		sgen::init_hendricks( str_objective );
		spawn_mapping_drone();
	
		level.ai_hendricks ai::set_behavior_attribute( "cqb", true );
		level.ai_hendricks ai::set_behavior_attribute( "sprint", true );	
		
		//get the drone on its path		
		nd_first = GetVehicleNode( "nd_post_discover_data", "targetname" );
		level.vh_mapper.origin = nd_first.origin;		
		
		//remove player clip
		bm_discover_data_player_clip = GetEnt( "bm_discover_data_player_clip", "targetname" );
		bm_discover_data_player_clip Delete();		
		
		objectives::complete( "cp_level_sgen_enter_sgen" );
		objectives::set( "cp_level_sgen_investigate_sgen" );
		
		//skipto VO
		level thread follow_1_vo();

		sgen::wait_for_all_players_to_spawn();
		sgen_util::setup_mappy_path();
		
		foreach( player in level.players )
		{
			player clientfield::set_to_player( "sndSiloBG", 1 );
		}	
		
		//to bypass hold from discover data anim
		level flag::set( "hendricks_data_anim_done" );
		
		// The glass has been kicked already, so put in the last frame
		level scene::skipto_end( "p7_fxanim_cp_sgen_hendricks_railing_kick_bundle" );		
	}

	level thread dust_fx_follow();
	level thread post_discover_data_breadcrumb();
	
	//set up the shimmy wall trigger and hide it
	trig_player_shimmy_start = GetEnt( "trig_player_shimmy_start", "targetname" );
	trig_player_shimmy_start SetHintString( "Press and Hold ^3[{+activate}]^7 to Shimmy across" );
	trig_player_shimmy_start SetCursorHint( "HINT_NOICON");	
	trig_player_shimmy_start TriggerEnable( false );
	
	level.ai_hendricks colors::disable();	
	
	level.ai_hendricks thread post_discover_data_hendricks();
	level.vh_mapper thread drone_lead_player_post_data();
	level thread fish_swim_by();

	level thread catwalk_shimmy_rock_falls();
	
	// End
	level flag::wait_till( "follow_gen_lab" );
	
	skipto::objective_completed( str_objective );
}

function skipto_aquarium_shimmy_done( str_objective, b_starting, b_direct, player )
{
}

function catwalk_shimmy_rock_falls()
{
	//rocks that crush bench
	level flag::wait_till( "hendricks_follow1_wait2" );	
	level clientfield::set( "debris_catwalk", 1 ); //p7_fxanim_cp_sgen_silo_debris_catwalk_bundle
	
	//rocks above shimmy wall
	level flag::wait_till( "play_shimmy_wall_debris" );	
	level clientfield::set( "debris_wall", 1 ); //p7_fxanim_cp_sgen_silo_debris_wall_bundle
}

function post_discover_data_breadcrumb()
{
	level flag::wait_till( "hendricks_data_anim_done" );
	
	//delete trigger hurt
	trig_discover_data_kill = GetEnt( "trig_discover_data_kill", "targetname" );
	if ( isdefined( trig_discover_data_kill ) )
	{
		trig_discover_data_kill Delete();			
	}
	
	//obj crumb on glass railing edge
	s_post_data_breadcrumb = struct::get( "post_data_breadcrumb" );
	objectives::set( "cp_standard_breadcrumb", s_post_data_breadcrumb );
	level flag::wait_till( "post_discover_data" );
	objectives::complete( "cp_standard_breadcrumb", s_post_data_breadcrumb );	
	
	//first jump
	s_obj_first_jump_down = struct::get( "obj_first_jump_down" );
	objectives::set( "cp_standard_breadcrumb", s_obj_first_jump_down );
	level flag::wait_till( "hendricks_follow1_jump1" );
	objectives::complete( "cp_standard_breadcrumb", s_obj_first_jump_down );	
	
	//obj_aquarium
	s_obj_aquarium = struct::get( "obj_aquarium" );
	objectives::set( "cp_standard_breadcrumb", s_obj_aquarium );
	level flag::wait_till( "clear_obj_aquarium" ); //on color trigger
	objectives::complete( "cp_standard_breadcrumb", s_obj_aquarium );		

	//obj_second_jump_down
	s_obj_second_jump_down = struct::get( "obj_second_jump_down" );
	objectives::set( "cp_standard_breadcrumb", s_obj_second_jump_down );
	level flag::wait_till( "hendricks_follow1_wait3" ); 
	objectives::complete( "cp_standard_breadcrumb", s_obj_second_jump_down );		

}

//	Notetracks from cin_sgen_06_01_followleader_vign_activate_eac_hendricks
//	self is Hendricks
function discover_data_hendricks_notetracks()
{
	level flag::wait_till( "glass_railing_kicked" ); //notetrack on hendricks anim
	
	level thread scene::play( "p7_fxanim_cp_sgen_hendricks_railing_kick_bundle" );
	
	//remove player clip
	bm_discover_data_player_clip = GetEnt( "bm_discover_data_player_clip", "targetname" );
	bm_discover_data_player_clip Delete();
	
	//turn on the trigger once hendricks has opened the path
	trig_post_discover_data = GetEnt( "trig_post_discover_data", "targetname" );
	trig_post_discover_data TriggerEnable( true );	
}

//	Hendricks movement through Follow 1
//	self is Hendricks
function post_discover_data_hendricks()
{	
	//wait until cin_sgen_06_01_followleader_vign_activate_eac_hendricks is done
	level flag::wait_till( "hendricks_data_anim_done" );
	
	//send both hendricks and drone up
	level flag::wait_till( "post_discover_data" );
	
	level scene::play( "cin_sgen_06_02_followtheleader_vign_hendricks_traversal_start" );
	
	level flag::wait_till( "hendricks_follow1_jump1" );
	
	level scene::play( "cin_sgen_06_02_followtheleader_vign_hendricks_traversal_finish" );

	//turn on hendricks colors
	self colors::enable();	
	
	//send hendricks to color chain after first jump
	trigger::use( "trig_color_post_first_jump", undefined, undefined, false );

	//hendricks is in color node behavior until this trigger is hit, before traversals down to slide
	level flag::wait_till( "hendricks_follow1_wait3" );	

	//DO reach to slide, jump down using traversals
	level scene::play( "cin_sgen_06_02_followleader_vign_slide_hendricks" );
	
	level.n_players_no_double_jump = 0;
	
	foreach( e_player in level.players )
	{
		if ( e_player HasCyberComRig( "cybercom_playermovement" ) ) 	 //== CCOM_STATUS_UPGRADED
		{
			level flag::set( "player_has_double_jump" );
		}
		else
		{
			level.n_players_no_double_jump++;
		}
	}

	if ( level flag::get( "player_has_double_jump" ) )
	{
		self hendricks_double_jump();	
	}
	else
	{
		// Go down another level, before shimmy
		self hendricks_wall_shimmy();	
	}
}

//this is only called from a skipto to maintain last portion of the conversation
function follow_1_vo()
{
	level flag::wait_till( "post_discover_data" );
	
	level.ai_hendricks dialog::say( "hend_hey_let_s_go_0" );
	level.ai_hendricks dialog::say( "hend_you_trying_to_send_u_0", 1 );
	level dialog::remote( "kane_i_just_want_the_same_0", 1 );		
}

function dust_fx_follow()
{
	t_dust = GetEnt( "dust_fx", "targetname" );
	t_dust endon( "death" );
	
	while( true )
	{
		t_dust waittill( "trigger", who );
		if( IsPlayer( who ) )
		{
			t_dust SetInvisibleToPlayer( who );
			who clientfield::set_to_player( "dust_motes", 1 );
		}
	}	
}

//self = hendricks 
function hendricks_double_jump()
{
	level flag::wait_till( "player_near_shimmy" ); //this is on a trigger
	
	level.ai_hendricks thread dialog::say( "hend_watch_your_boost_cro_0" ); //Watch your boost crossing the gap, that's a long way to fall...	
	
	nd_hendricks_double_jump = GetNode( "nd_hendricks_double_jump", "targetname" );
	self ai::force_goal( nd_hendricks_double_jump.origin, 32 );
	
	//spawn anchor
	e_double_jump_anchor = util::spawn_model( "tag_origin", self.origin, self.angles );
	
	s_double_jump_start = struct::get( "double_jump_start", "targetname" );
	s_double_jump_next_pos = struct::get( s_double_jump_start.target, "targetname" );
	
	self LinkTo( e_double_jump_anchor );
	
	e_double_jump_anchor MoveTo( s_double_jump_start.origin, 2 );
	e_double_jump_anchor RotateTo( s_double_jump_start.angles, 2 );
	e_double_jump_anchor waittill( "movedone" );
	wait 0.25;
	e_double_jump_anchor MoveTo( s_double_jump_next_pos.origin, 2 );
	e_double_jump_anchor RotateTo( s_double_jump_next_pos.angles, 2 );
	e_double_jump_anchor waittill( "movedone" );	
	e_double_jump_anchor Delete();
	
	self Unlink();
	
	level.ai_hendricks thread gen_lab_hendricks();	
}

//self = hendricks
function hendricks_wall_shimmy()
{
	level thread player_wall_shimmy_watcher();
	
	self colors::disable();
	
	self thread dialog::say( "hend_stick_to_the_ledge_0" ); //Stick to the ledge, that's a long way down... I'll take point.
	
	level scene::play( "cin_sgen_06_02_followleader_vign_shimmy_hendricks_start" );
	
	level.ai_hendricks thread gen_lab_hendricks();	
}

function player_wall_shimmy_watcher()
{
	level flag::wait_till( "hendricks_shimmy_halfway" ); //sent from hendricks anim
	
	//turns on trigger
	trig_player_shimmy_start = GetEnt( "trig_player_shimmy_start", "targetname" );
	trig_player_shimmy_start TriggerEnable( true );
	
	while( level.n_players_no_double_jump > 0 )
	{
		// place objective marker to interact with trigger to start shimmy
		s_player_shimmy_start = struct::get( "s_player_shimmy_start" );
		objectives::set( "cp_level_sgen_use_3d", s_player_shimmy_start );		
		
		trig_player_shimmy_start waittill( "trigger", e_player );
		trig_player_shimmy_start TriggerEnable( false );
		level.n_players_no_double_jump--;
		
		objectives::complete( "cp_level_sgen_use_3d", s_player_shimmy_start );		
		
		e_player thread player_shimmy_anim();
		
		e_player flag::wait_till( "player_shimmy_section_01" );
		
		wait 1;
	}
	
	if ( isdefined( trig_player_shimmy_start ) )
	{
		trig_player_shimmy_start Delete();
	}
}

//self = player
function player_shimmy_anim()
{
	self endon( "death" );
	
	self flag::init( "player_shimmy_start" );
	self flag::init( "player_shimmy_section_01" );
	self flag::init( "player_shimmy_section_02" );
	self flag::init( "player_shimmy_done" );
	
	self flag::set( "player_shimmy_start" );
	
	level scene::play( "cin_sgen_06_02_followleader_vign_shimmy_player_cinematic01", self );
	
	//TODO: wait for thumbstick movement here
	self flag::set( "player_shimmy_section_01" );
	
	level scene::play( "cin_sgen_06_02_followleader_vign_shimmy_player_cinematic02", self );
	
	//TODO: wait for thumbstick movement here
	self flag::set( "player_shimmy_section_02" );
	
	level scene::play( "cin_sgen_06_02_followleader_vign_shimmy_player_cinematic03", self );
	
	self flag::set( "player_shimmy_done" );
	
	self flag::clear( "player_shimmy_start" );
	self flag::clear( "player_shimmy_section_01" );
	self flag::clear( "player_shimmy_section_02" );	
	self flag::clear( "player_shimmy_done" );
}

//
//	Visual interest for the sea view
function fish_swim_by()
{
	mdl_fish = GetEnt( "oarfish", "targetname" );
	level flag::wait_till( "hendricks_follow1_wait2" );

	mdl_fish.angles += (-15, 0, 0);	// Pitch upward initially
	
	n_time = 10;
	s_target = mdl_fish;	// this is only an ent in the initial seed.  It will be a struct 
	while ( isdefined( s_target.target ) )
	{
		s_target = struct::get( s_target.target, "targetname" );
		mdl_fish MoveTo( s_target.origin, n_time );
		mdl_fish RotateTo( s_target.angles, n_time, n_time / 2, n_time / 2 );
		wait n_time;
	}
}

///////////////////////////////////////////////////////////////////
//	Genetics Lab
///////////////////////////////////////////////////////////////////
function skipto_gen_lab_init( str_objective, b_starting )
{
	if ( b_starting )
	{
		sgen::init_hendricks( str_objective );
		spawn_mapping_drone();

		objectives::complete( "cp_level_sgen_enter_sgen" );
		objectives::set( "cp_level_sgen_investigate_sgen" );		
		
		sgen::wait_for_all_players_to_spawn();
		sgen_util::setup_mappy_path();
		
		level flag::set( "hendricks_gen_lab_start" );
		
		level.ai_hendricks thread gen_lab_hendricks();
		level.vh_mapper thread drone_lead_player_gen_lab();
		
		foreach( player in level.players )
		{
			player clientfield::set_to_player( "sndSiloBG", 1 );
			player clientfield::set_to_player( "dust_motes", 1 );
		}	
		
	}
	
	level thread gen_lab_objective_breadcrumbs();
	
	//hide player trigger at the end of the gen lab
	trig_gen_lab_door_player_check = GetEnt( "trig_gen_lab_door_player_check", "targetname" );
	trig_gen_lab_door_player_check TriggerEnable( false );
	
	level thread gen_lab_spawning();	
	
	level thread scene::init( "p7_fxanim_cp_sgen_lab_ceiling_light_01_bundle" );
	level thread scene::init( "p7_fxanim_cp_sgen_lab_ceiling_light_02_bundle" );
		
	// End
	level flag::wait_till( "gen_lab_door_opened" );

	skipto::objective_completed( str_objective );
}

function gen_lab_objective_breadcrumbs()
{
	//wall run objective crumb
	s_obj_gen_lab_wallrun = struct::get( "obj_gen_lab_wallrun" );
	objectives::set( "cp_standard_breadcrumb", s_obj_gen_lab_wallrun );
	level flag::wait_till( "hendricks_gen_lab_start" ); 
	objectives::complete( "cp_standard_breadcrumb", s_obj_gen_lab_wallrun );	
	
	//gen lab entrance crumb
	s_obj_gen_lab_entrance = struct::get( "obj_gen_lab_entrance" );
	objectives::set( "cp_standard_breadcrumb", s_obj_gen_lab_entrance );
	level flag::wait_till( "hendricks_gen_lab_intro_color" ); 
	objectives::complete( "cp_standard_breadcrumb", s_obj_gen_lab_entrance );			
		
	//wait until the room is cleared
	level flag::wait_till( "gen_lab_cleared" );
	
	//obj_gen_lab_end_door	
	s_obj_gen_lab_end_door = struct::get( "obj_gen_lab_end_door" );
	objectives::set( "cp_standard_breadcrumb", s_obj_gen_lab_end_door );
	level flag::wait_till( "player_at_gen_lab_door" ); //flag is on the trigger
	objectives::complete( "cp_standard_breadcrumb", s_obj_gen_lab_end_door );		
}

function gen_lab_spawning()
{
	level flag::wait_till( "trig_spawn_gen_lab" );
		
	//spawn enemies wave 1
	level thread hendricks_color_wave_1_count();
	level thread wave_1_enemy_color_chain();

	//run check on player for gunfire
	level.ai_hendricks thread monitor_hendricks_gunfire();
	
	foreach( e_player in level.players )
	{
		e_player thread monitor_player_gunfire();
	}	
	
	//wait on trigger to forcefully set the hot flag
	level thread force_gen_lab_hot();
	
	//wait until player hits mid trigger or kills x amount of guys
	level flag::wait_till( "player_mid_gen_lab" );
	
	spawner::simple_spawn( "gen_lab_enemy_wave_2", &setup_wave_2_gen_lab_guy ); 
	
	level thread wait_till_lab_cleared();
}

function setup_wave_2_gen_lab_guy()
{
	self oed::set_force_tmode();
	
	self.goalradius = 1024;
	
	e_vol_gen_lab_fallback = GetEnt( "vol_gen_lab_fallback", "targetname" );
	self SetGoal( e_vol_gen_lab_fallback );	
}

function wave_1_enemy_color_chain()
{
	level flag::wait_till( "gen_lab_gone_hot" );
	
	//spawn in additional guys from the back
	spawner::simple_spawn( "gen_lab_reinforcements" );
}

function force_gen_lab_hot()
{
	//forcing the even to go hot if he moves up passed this threshold in gen lab
	level flag::wait_till( "player_front_gen_lab" );
	
	level flag::set( "gen_lab_gone_hot" );		
}

//self = hendricks
function monitor_hendricks_gunfire()
{
	//hendricks set to go quiet
	self ai::set_ignoreme( true );
	self ai::set_ignoreall( true );
	
	level flag::wait_till( "gen_lab_gone_hot" );
	
	self ai::set_ignoreme( false );
	self ai::set_ignoreall( false );		
}

function monitor_player_gunfire()
{
	self ai::set_ignoreme( true );
	self ai::set_ignoreall( true );
	
	self thread monitor_gen_lab_gunfire();
	
	level flag::wait_till( "gen_lab_gone_hot" );
	
	self ai::set_ignoreme( false );
	self ai::set_ignoreall( false );		
}

function monitor_gen_lab_gunfire()
{
	self waittill( "weapon_fired" );
	level flag::set( "gen_lab_gone_hot" );
}

function hendricks_color_wave_1_count()
{
//	level endon( "player_mid_gen_lab" ); //this is a flag the color trigger if player hits it physically
	
	spawner::waittill_ai_group_amount_killed( "gen_lab_enemies", 3 );
	trigger::use( "gen_lab_color_chain_front", undefined, undefined, false );
	
	//wait until until x amount are kill then triggering the second wave trigger if the player hasnt done so
	spawner::waittill_ai_group_amount_killed( "gen_lab_enemies", 6 );
	
	//TODO: also check if the warlord is down, makes more sense to move up this postion when hes dead
	
	trigger::use( "gen_lab_color_chain_mid", undefined, undefined, false );
}

function setup_patrol_scene( a_scene_ents )
{
	level endon( "gen_lab_gone_hot" );

	a_scene_ents[ "gen_lab_enemy_1" ] thread monitor_patrol_damage();
	a_scene_ents[ "gen_lab_enemy_2" ] thread monitor_patrol_damage();
	a_scene_ents[ "gen_lab_enemy_3" ] thread monitor_patrol_damage();
	a_scene_ents[ "gen_lab_enemy_4" ] thread monitor_patrol_damage();
	a_scene_ents[ "gen_lab_enemy_5" ] thread monitor_patrol_damage();
	
	a_scene_ents[ "gen_lab_warlord" ] thread monitor_patrol_damage();
}

//self = gen lab enemy in scene
function monitor_patrol_damage()
{
	level endon( "gen_lab_gone_hot" );
	
	//1- wait until ai gets damaged
	//2 - kill scene he's in if he's still in it
	//3 - set the event to hot
	
	self waittill( "damage" );
	
	sgen_util::scene_stop_if_active( self.current_scene );	
	
	level flag::set( "gen_lab_gone_hot" );
}

function setup_gen_lab_guy()
{
	self endon( "death" );
	
	self.old_MaxSightDistSqrd = self.MaxSightDistSqrd;
	self.MaxSightDistSqrd = 600 * 600;
	
	self.fovcosine = 0.95;
	
	self thread gen_lab_sight_check();
	
	self oed::set_force_tmode();
	
	self ai::set_ignoreme( true );
	self ai::set_ignoreall( true );
	
	if ( self.script_string === "gen_lab_force_hot_guy" )
	{
		self thread gen_lab_force_hot_patrol();
	}	
	
	level flag::wait_till( "gen_lab_gone_hot" );
	
	self.MaxSightDistSqrd = self.old_MaxSightDistSqrd;
	
	self.fovcosine = 0;
			
	self ai::set_ignoreme( false );
	self ai::set_ignoreall( false );	
	
	self.goalradius = 1024;
	
	//use the warlord volume
	vol_gen_lab_warlord = GetEnt( "vol_gen_lab_warlord", "targetname" );
	self SetGoal( vol_gen_lab_warlord );	

	//wait until second wave spawns and send these guys back
	level flag::wait_till( "player_mid_gen_lab" );
	
	e_vol_gen_lab_fallback = GetEnt( "vol_gen_lab_fallback", "targetname" );
	self SetGoal( e_vol_gen_lab_fallback );
}

function gen_lab_sight_check()
{
	level endon( "gen_lab_gone_hot" );
	self endon( "death" );
	
	while( true )
	{
		foreach( player in level.players )
		{
			if ( self Cansee( player ) )
			{
				level flag::set( "gen_lab_gone_hot" );
			}
		}
		
		wait 0.3;
	}
}

function gen_lab_force_hot_patrol()
{
	level endon( "gen_lab_gone_hot" );	
	self endon( "death" );
	
	level flag::wait_till( "hendricks_in_gen_lab" );
	
	//put him on his path now that hendricks is in position
	nd_gen_lab_patrol_force_hot = GetNode( "nd_gen_lab_patrol_force_hot", "targetname" );
	self thread ai::patrol( nd_gen_lab_patrol_force_hot );
	
	//wait until patroller hits this node
	level waittill( "nd_gen_lab_getting_close" );
	
	//play dialog of hendricks warning of patroller getting close
	level.ai_hendricks dialog::say( "I got one here, getting close. Make your move!" );
	
	//wait until patroller hits this node
	level waittill( "nd_gen_lab_force_hot" );
	
	level.ai_hendricks dialog::say( "Fuck it! DOING IT LIVE!" );
	
	//DOING IT LIVE!
	level flag::set( "gen_lab_gone_hot" );
	
}

function setup_gen_lab_warlord()
{
	self endon( "death" );
	
	self oed::set_force_tmode();
	
	self ai::set_ignoreme( true );
	self ai::set_ignoreall( true );
	
	level flag::wait_till( "gen_lab_gone_hot" );

	self ai::set_ignoreme( false );
	self ai::set_ignoreall( false );	
	
	//use the warlord volume to contain him
	vol_gen_lab_warlord = GetEnt( "vol_gen_lab_warlord", "targetname" );
	self SetGoal( vol_gen_lab_warlord );
}

function skipto_gen_lab_done( str_objective, b_starting, b_direct, player )
{
}


//	Function blocks until the lab is cleared, or someone gets to the back 
//	of the lab
function wait_till_lab_cleared()
{	
	spawner::waittill_ai_group_cleared( "gen_lab_enemies" );
	level flag::set( "gen_lab_cleared" );
}
	
//
//	Hendricks' movement through the Gen Lab
//	self is Hendricks
function gen_lab_hendricks()
{	
	self colors::disable();
	
	//take cover on platform after shimmy wall and wait for player
	nd_hendricks_post_shimmy_wall = GetNode( "nd_hendricks_post_shimmy_wall", "targetname" );
	self thread ai::force_goal( nd_hendricks_post_shimmy_wall, 32 );		
	
	level flag::wait_till( "player_past_shimmy_wall" );
	
	level scene::init( "cin_sgen_06_02_follow_leader_vign_wallrun_new_hendricks" );
	
	level flag::wait_till( "hendricks_gen_lab_start" );

	level scene::play( "cin_sgen_06_02_follow_leader_vign_wallrun_new_hendricks" );
	
	level.ai_hendricks ai::set_behavior_attribute( "cqb", true );
	level.ai_hendricks ai::set_behavior_attribute( "sprint", true );		
	
	nd_hendricks_outside_gen_lab = GetNode( "nd_hendricks_outside_gen_lab", "targetname" );
	self thread ai::force_goal( nd_hendricks_outside_gen_lab, 32 );	
	
	level flag::wait_till( "hendricks_gen_lab_intro_color" );

	nd_hendricks_front_gen_lab = GetNode( "nd_hendricks_front_gen_lab", "targetname" );
	self ai::force_goal( nd_hendricks_front_gen_lab, 32 );
	level flag::set( "hendricks_in_gen_lab" );
	self colors::enable();
	
	level thread hendricks_gen_lab_vo();
	
	// Hendricks will move up with color triggers
	level flag::wait_till( "gen_lab_cleared" );
	trigger::use( "gen_lab_hendricks_move_end", undefined, undefined, false );
	
	nd_gen_lab_door = GetNode( "nd_gen_lab_door", "targetname" );
	self ai::force_goal( nd_gen_lab_door, 32 );
	level flag::set( "hendricks_at_gen_lab_door" );
	
	// Hendricks idles outside of the Gen Lab
	level flag::wait_till( "gen_lab_door_opened" ); 

	//rocks that fall just outside doorway of gen lab exit
	level clientfield::set( "debris_fall", 1 ); //p7_fxanim_cp_sgen_silo_debris_fall_bundle
	
	level.ai_hendricks thread post_gen_lab_hendricks();
}

function hendricks_gen_lab_vo()
{
	level endon( "gen_lab_gone_hot" );
	
	//wait for hendricks to be in position to say his line
	level flag::wait_till( "hendricks_in_gen_lab" );
	
//	Take the first shot, we move on you.
	level.ai_hendricks dialog::say( "hend_take_the_first_shot_0" );		
}

///////////////////////////////////////////////////////////////////
//	Post Gen Lab
///////////////////////////////////////////////////////////////////


function skipto_post_gen_lab_init( str_objective, b_starting )
{
	if ( b_starting )
	{
		sgen::init_hendricks( str_objective );
		spawn_mapping_drone();

		objectives::complete( "cp_level_sgen_enter_sgen" );
		objectives::set( "cp_level_sgen_investigate_sgen" );
		
		sgen::wait_for_all_players_to_spawn();
		sgen_util::setup_mappy_path();
		
		level.vh_mapper thread drone_lead_player_post_gen_lab();
		level.ai_hendricks thread post_gen_lab_hendricks();	
		
		//remove the door at the end of the gen lab
		e_gen_lab_end_door = GetEnt( "gen_lab_end_door", "targetname" );
		e_gen_lab_end_door Delete();		
		
		level flag::set( "gen_lab_door_opened" ); //on trigger at the end of the gen lab		
		
		foreach( player in level.players )
		{
			player clientfield::set_to_player( "sndSiloBG", 1 );
			player clientfield::set_to_player( "dust_motes", 1 );
		}	
	}
	
	//turn off bridge hurt trigger
	trig_bridge_kill_trigger = GetEnt( "trig_bridge_kill_trigger", "targetname" );
	trig_bridge_kill_trigger TriggerEnable( false );
	
	level thread post_gen_objective_breadcrumbs();
	
	// End
	level flag::wait_till( "follow_chem_lab" );
		
	skipto::objective_completed( str_objective );
}

function skipto_post_gen_lab_done( str_objective, b_starting, b_direct, player )
{
}

//	Hendricks movement after gen lab and over bridge and to chem lab
//	self is Hendricks
function post_gen_lab_hendricks()
{
	level thread bridge_collapse_notetrack();
	level thread bridge_rock_fall();
	
	//Watch your step... this place ain’t exactly stable.
	level.ai_hendricks thread dialog::say( "hend_watch_your_step_t_1", 1 );	
	
	// Double-jump down a long way
	level scene::play( "cin_sgen_08_01_followleader_2_vign_pathfinding_aie_jumpdown_hendricks" );
	
	level notify ("skr"); //starts robot knocks music creepy music and plays a stinger
	
	level flag::wait_till( "hendricks_follow2_wallrun_trick" );
	
	scene::add_scene_func( "p7_fxanim_cp_sgen_bridge_silo_edge_break_bundle", &player_bridge_debris_kill, "play" );			

	//bridge fxanim
	level thread scene::play( "p7_fxanim_cp_sgen_bridge_silo_edge_break_bundle" );	
	
	//spawn and start the robots knocking for audio. This should play once the player has jumped down the platforms to the bridge.
	level thread scene::play( "cin_sgen_09_01_chemlab_vign_windowknock_robots_start" );
	
	//wall run to bridge
	level scene::play( "cin_sgen_06_02_follow_leader_vign_wallrun" );

	level.ai_hendricks ai::set_behavior_attribute( "cqb", true );
	level.ai_hendricks ai::set_behavior_attribute( "sprint", true );	
	
	self thread chem_lab_hendricks();
}

function player_bridge_debris_kill( a_scene_ents )
{
	level flag::wait_till( "bridge_debris_player_kill" ); //notetrack sent from bridge anim
	
	//turn on hurt trigger
	trig_bridge_kill_trigger = GetEnt( "trig_bridge_kill_trigger", "targetname" );
	trig_bridge_kill_trigger TriggerEnable( true );
	
	//wait until notetrack to TURN IT OFF
	while ( level flag::get( "bridge_debris_player_kill" ) )
	{
		wait 0.05;	
	}

	trig_bridge_kill_trigger TriggerEnable( false );
	trig_bridge_kill_trigger Delete();
}

function post_gen_objective_breadcrumbs()
{
	//obj_bridge_jump_1	
	s_obj_bridge_jump = struct::get( "obj_bridge_jump" );
	objectives::set( "cp_standard_breadcrumb", s_obj_bridge_jump );
	level flag::wait_till( "hendricks_follow2_jumpdown" ); //flag is on the trigger
	objectives::complete( "cp_standard_breadcrumb", s_obj_bridge_jump );		
	
	//wall run	
	s_obj_bridge_wallrun = struct::get( "obj_bridge_wallrun" );
	objectives::set( "cp_standard_breadcrumb", s_obj_bridge_wallrun );
	level flag::wait_till( "hendricks_follow2_wallrun_trick" ); //flag is on the trigger
	objectives::complete( "cp_standard_breadcrumb", s_obj_bridge_wallrun );		
	
	s_obj_chem_lab_entrance = struct::get( "obj_chem_lab_entrance" );
	objectives::set( "cp_standard_breadcrumb", s_obj_chem_lab_entrance );
	level flag::wait_till( "follow_chem_lab" ); //flag is on the trigger
	objectives::complete( "cp_standard_breadcrumb", s_obj_chem_lab_entrance );	

	s_obj_near_shimmy_breadcrumb = struct::get( "s_player_shimmy_start" );
	objectives::set( "cp_standard_breadcrumb", s_obj_near_shimmy_breadcrumb );
	level flag::wait_till( "player_near_shimmy" ); //this is on a trigger
	objectives::complete( "cp_standard_breadcrumb", s_obj_near_shimmy_breadcrumb );
}

function bridge_collapse_notetrack()
{
	//notetrack that breaks bridge - called from debris anim - p7_fxanim_cp_sgen_silo_debris_bridge_bundle
	level flag::wait_till( "bridge_hit_1" );
	
	//delete clip
	e_silo_bridge_clip_before = GetEntArray( "silo_bridge_clip_before", "targetname" );
	array::run_all( e_silo_bridge_clip_before, &Delete );
	
	s_bridge_hit_pos = struct::get( "s_bridge_hit_pos", "targetname" );
	e_bridge_hit_pos = util::spawn_model( "tag_origin", s_bridge_hit_pos.origin, s_bridge_hit_pos.angles );
	Earthquake( 0.3, 1, e_bridge_hit_pos.origin, 10000 );	
	
	foreach( e_player in level.players )
	{
		e_player PlayRumbleOnEntity( "tank_damage_heavy_mp" );		
	}
	
	//notetrack when bridge hits the bottom - called from debris anim - p7_fxanim_cp_sgen_silo_debris_bridge_bundle
	level flag::wait_till( "bridge_hit_2" );

	Earthquake( 0.1, 1, e_bridge_hit_pos.origin, 10000 );

	foreach( e_player in level.players )
	{
		e_player PlayRumbleOnEntity( "tank_damage_heavy_mp" );		
	}	
}

function bridge_rock_fall()
{
	level flag::wait_till( "post_bridge_collapse_rocks" );	
	level clientfield::set( "debris_bridge", 1 ); //p7_fxanim_cp_sgen_silo_debris_bridge_bundle
}

///////////////////////////////////////////////////////////////////
//	Chem Lab
///////////////////////////////////////////////////////////////////


function skipto_chem_lab_init( str_objective, b_starting )
{
	if ( b_starting )
	{
		sgen::init_hendricks( str_objective );
		spawn_mapping_drone();
		level.vh_mapper thread drone_lead_player_chem_lab();
		level.ai_hendricks thread chem_lab_hendricks();

		objectives::complete( "cp_level_sgen_enter_sgen" );
		objectives::set( "cp_level_sgen_investigate_sgen" );
		
		//put bridge collapse at last frame of its animation
		level scene::skipto_end( "p7_fxanim_cp_sgen_bridge_silo_edge_break_bundle" );		
		
		//spawn and start the robots knocking for audio
		level thread scene::play( "cin_sgen_09_01_chemlab_vign_windowknock_robots_start" );
		
		sgen::wait_for_all_players_to_spawn();
		sgen_util::setup_mappy_path();
		
		foreach( player in level.players )
		{
			player clientfield::set_to_player( "sndSiloBG", 1 );
			player clientfield::set_to_player( "dust_motes", 1 );	
		}
	}

	level scene::init( "cin_sgen_09_02_chem_lab_vign_opendoor_hendricks" );
	level scene::init( "cin_sgen_11_02_silofloor_vign_notice_hendricks" ); //silo grate model spawns and sets to first frame
	
	level thread chem_lab_breadcrumbs();
	
	//spawns and initializes risers
	level thread setup_silo_robot_risers();	
	
	level thread chem_lab_robots();
	
	//turn off trigger that starts the silo battle
	trig_player_at_silo_floor = GetEnt( "trig_player_at_silo_floor", "targetname" );
	trig_player_at_silo_floor TriggerEnable( false );		
		
	// End
	level flag::wait_till( "follow3_1" );

	skipto::objective_completed( str_objective );
}


function skipto_chem_lab_done( str_objective, b_starting, b_direct, player )
{
}

function chem_lab_breadcrumbs()
{
	//obj_bridge_jump_1	
	s_obj_chem_lab_mid = struct::get( "obj_chem_lab_mid" );
	objectives::set( "cp_standard_breadcrumb", s_obj_chem_lab_mid );
	level flag::wait_till( "player_in_chem_lab" ); //flag is on the trigger
	objectives::complete( "cp_standard_breadcrumb", s_obj_chem_lab_mid );			

	//wait until hendricks is at the door loop
	level waittill( "hendricks_chem_door_loop" );	
	
	s_obj_chem_lab_door = struct::get( "obj_chem_lab_door" );
	objectives::set( "cp_standard_breadcrumb", s_obj_chem_lab_door );
	level flag::wait_till( "start_chem_lab_robot_scare" ); //flag is on the trigger just outside the door
	objectives::complete( "cp_standard_breadcrumb", s_obj_chem_lab_door );	

}

//	Hendricks' movement through the chem lab
//	self is Hendricks
function chem_lab_hendricks()
{
	self ai::set_ignoreme( true );
	self ai::set_ignoreall( true );
	
	//this is a temp fix - hendricks was not reaching to the scene. probably because the scene bundle is just an idle in the main field with do_reach
	nd_hendricks_temp_cover_pos = GetNode( "hendricks_temp_cover_pos", "targetname" );
	level.ai_hendricks ai::force_goal( nd_hendricks_temp_cover_pos, 32 );
	
	s_hendricks_chem_lab_startidle = struct::get( "chem_lab_hendricks_startidle" );//TODO - Shabs, do reach is broken on this since the anim starts in the wall, so it was turned off for now
	s_hendricks_chem_lab_startidle thread scene::play( "cin_sgen_09_01_chemlab_vign_windowknock_hendricks_start_idle" );
	
	level waittill( "hendricks_chem_start_idle" );
	
	level flag::wait_till( "chem_lab_start" );
	
	s_chem_lab_hendricks_move_in = struct::get( "chem_lab_hendricks_move_in" );
	s_chem_lab_hendricks_move_in thread scene::play( level.ai_hendricks ); // cin_sgen_09_01_chemlab_vign_windowknock_hendricks_moveinroom
//	level thread scene::play( "cin_sgen_09_01_chemlab_vign_windowknock_robots_start" ); // playing this in the gen lab now
	level thread chem_lab_vo();
	
	level waittill( "hendricks_at_spook_idle" );
	
	//wait until the player reaches the room
	level flag::wait_till( "player_in_chem_lab" ); //flag on trigger in chem lab
			
	level thread scene::play( "cin_sgen_09_01_chemlab_vign_windowknock_robots_stop" );
	level thread scene::play( "cin_sgen_09_02_chem_lab_vign_workerbot_robot01_breakfree" );
	
	s_chem_lab_hendricks_move_to_door = struct::get( "chem_lab_hendricks_move_to_door" );//TODO - still need to evaluate the worth of this anim since it doesn't actually reach to the door
	s_chem_lab_hendricks_move_to_door scene::play( level.ai_hendricks ); // cin_sgen_09_01_chemlab_vign_windowknock_hendricks_move2door
	
	level flag::set( "hendricks_door_line" );
	
	//hendricks then runs to the door and loops
	level thread scene::play( "cin_sgen_09_02_chem_lab_vign_opendoor_hendricks" );
	
	level waittill( "hendricks_chem_door_loop" );	
	level thread chem_door_nag_lines();

	e_chem_lab_door_player_clip = GetEnt( "chem_lab_door_player_clip", "targetname" );
	e_chem_lab_door_player_clip Delete();
	
	level flag::set( "chem_door_open" ); //notifies mapping drone to move forward on its path
	
	//trigger with "requires all player" checked
	trigger::wait_till( "trig_silo_floor_player_check" );
	level flag::set( "all_players_outside_chem_lab" );
	
	level scene::play( "cin_sgen_09_02_chem_lab_vign_exitdoor_hendricks" );

	level.ai_hendricks ai::set_ignoreme( false );
	level.ai_hendricks ai::set_ignoreall( false );	
	
	self thread post_chem_lab_hendricks();
}

function chem_door_nag_lines()
{
	level endon( "all_players_outside_chem_lab" );
	level endon( "start_chem_lab_robot_scare" );
	
	//wait here until playing nag lines
	wait 5;
	level.ai_hendricks dialog::say( "hend_i_m_not_gonna_hold_i_0" );  //I'm not gonna hold it forever, move your ass.

	wait 5;
	level.ai_hendricks dialog::say( "hend_wanna_pick_up_the_pa_0" );  //Wanna pick up the pace? We gotta locate that signal's source.	
}

function chem_lab_vo()
{
	//TODO: notetrack to kick this off
	wait 7;
	
	//	Kane, are you seeing this?
	//	(beat)
	//	Why would every bot in this place be acting so weird?
	level.players[0] dialog::player_say( "plyr_kane_are_you_seeing_0" );	
	
	//	Could be some kind of power surge.
	level dialog::remote( "kane_could_be_some_kind_o_0" );	
	
	level flag::wait_till( "hendricks_door_line" );
	
	level.ai_hendricks dialog::say( "hend_i_got_the_door_go_u_0" );  //I got the door, go under and take point.
}

function chem_lab_robots()
{
	scene::init( "cin_sgen_09_02_chem_lab_vign_workerbot_robot01_breakfree" ); //cin_sgen_09_02_chem_lab_vign_workerbot_robot01_breakfree
	
	//get him in first frame, and in position
	level thread robot_breaks_glass_notetrack();
	
	level flag::wait_till( "start_chem_lab_robot_scare" );

	level thread scene::play( "cin_sgen_09_02_chem_lab_vign_workerbot_robot01_breakfree_stop" ); //cin_sgen_09_02_chem_lab_vign_workerbot_robot01_breakfree
}

function robot_breaks_glass_notetrack()
{
	level waittill( "chem_lab_break_glass" );
	level notify ("skrd"); //kills the creepy music and plays a stinger
	//SHIT!
	level.players[0] thread dialog::player_say( "plyr_shit_1", 1.0 );
	
	level clientfield::set( "w_robot_window_break", 1 );
}

///////////////////////////////////////////////////////////////////
//	Follow the Leader 3
///////////////////////////////////////////////////////////////////


function skipto_post_chem_lab_init( str_objective, b_starting )
{
	if ( b_starting )
	{
		sgen::init_hendricks( str_objective );
		level.ai_hendricks ai::set_behavior_attribute( "cqb", true );
		level.ai_hendricks ai::set_behavior_attribute( "sprint", true );		
		
		spawn_mapping_drone();
		level.vh_mapper thread drone_lead_player_post_chem_lab();
		level.ai_hendricks thread post_chem_lab_hendricks();

		objectives::complete( "cp_level_sgen_enter_sgen" );
		objectives::set( "cp_level_sgen_investigate_sgen" );

		//put the bridge collapse in the last frame
		level scene::skipto_end( "p7_fxanim_cp_sgen_bridge_silo_edge_break_bundle" );		
		
		//setup function to take care of the grate getting highlighted
		scene::add_scene_func( "cin_sgen_11_02_silofloor_vign_notice_hendricks", &drone_highlights_grate, "init" );			
		
		level scene::init( "cin_sgen_11_02_silofloor_vign_notice_hendricks" ); //silo grate model spawns and sets to first frame
		
		//spawns and initializes risers
		level thread setup_silo_robot_risers();
		
		sgen::wait_for_all_players_to_spawn();
		sgen_util::setup_mappy_path();
		
		foreach( player in level.players )
		{
			player clientfield::set_to_player( "sndSiloBG", 1 );
			player clientfield::set_to_player( "dust_motes", 1 );
		}	
		
		//to get the drone to move from this skipto
		level flag::set( "follow3_1" );
			
		//turn off trigger that starts the silo battle
		trig_player_at_silo_floor = GetEnt( "trig_player_at_silo_floor", "targetname" );
		trig_player_at_silo_floor TriggerEnable( false );		
	}
	
	level thread post_chem_lab_breadcrumbs();
	
	// End
	level flag::wait_till( "player_at_silo_floor" ); //on radius trigger on the bottom
	
	skipto::objective_completed( str_objective );
}


function skipto_post_chem_lab_done( str_objective, b_starting, b_direct, player )
{
}

function post_chem_lab_breadcrumbs()
{
	//slide crumb
	s_obj_chem_lab_slide = struct::get( "obj_chem_lab_slide" );
	objectives::set( "cp_standard_breadcrumb", s_obj_chem_lab_slide );
	level flag::wait_till( "hendricks_follow3_wait1" ); //flag is on the trigger at chem lab exit
	objectives::complete( "cp_standard_breadcrumb", s_obj_chem_lab_slide );			
	
	//obj_bridge_jump_1	
	s_obj_silo_floor_drop = struct::get( "obj_silo_floor_drop" );
	objectives::set( "cp_standard_breadcrumb", s_obj_silo_floor_drop );
	level flag::wait_till( "clear_obj_silo_drop" ); //flag is on the trigger
	objectives::complete( "cp_standard_breadcrumb", s_obj_silo_floor_drop );			
	
}

//
//	Hendricks' movement down to the silo floor from the chem lab
//	self is Hendricks
function post_chem_lab_hendricks()
{
	level thread post_chem_lab_vo();
	
	level.ai_hendricks.goalradius = 32;
	nd_hendricks_post_chem_lab = GetNode( "nd_hendricks_post_chem_lab", "targetname" );
	level.ai_hendricks SetGoal( nd_hendricks_post_chem_lab.origin, true );
		
	level flag::wait_till( "hendricks_follow3_wait1" );
	
	//second slide post chem lab
	level scene::play( "cin_sgen_10_01_followleader3_vign_slide" );
	
	//send him down to a guard node after the slide
	nd_hendricks_silo_floor = GetNode( "hendricks_silo_floor", "targetname" );
	level.ai_hendricks ai::force_goal( nd_hendricks_silo_floor, 32 );	
	
	self thread silo_floor_hendricks();
}

function post_chem_lab_vo()
{
//	"Kane - Could someone be plugged in  to the building systems?
//	(beat)
//	Controlling the robots?"
	level dialog::remote( "plyr_kane_could_someone_0" );	
	
//	It’s unlikely that any systems are operational after the disaster.
//	(beat)
//	But in all honesty - we don’t have any idea what’s down there.	
	level dialog::remote( "kane_it_s_unlikely_that_a_0" );	
}

function ev_player_tutorial()
{
	//on trigger in fan silo
	level flag::wait_till( "player_ev_tutorial" );
	
	//TODO: create message on how to use EV, monitor if players are setting it to turn their message off clientside	
	level thread util::screen_message_create( "Press Up on the D-Pad to enable EV" );
	wait 5;
	util::screen_message_delete();	
}

///////////////////////////////////////////////////////////////////
//	Silo Floor Battle
///////////////////////////////////////////////////////////////////


function skipto_silo_floor_init( str_objective, b_starting )
{
	if ( b_starting )
	{
		sgen::init_hendricks( str_objective );
		level.ai_hendricks ai::set_behavior_attribute( "cqb", true );
		level.ai_hendricks ai::set_behavior_attribute( "sprint", true );
	
		level.ai_hendricks thread silo_floor_hendricks();

		spawn_mapping_drone();
		level.vh_mapper thread drone_lead_player_silo_battle();

		objectives::complete( "cp_level_sgen_enter_sgen" );
		objectives::set( "cp_level_sgen_investigate_sgen" );

		//put the bridge collapse in the last frame
		level scene::skipto_end( "p7_fxanim_cp_sgen_bridge_silo_edge_break_bundle" );			

		//setup function to take care of the grate getting highlighted
		scene::add_scene_func( "cin_sgen_11_02_silofloor_vign_notice_hendricks", &drone_highlights_grate, "init" );				
		
		level scene::init( "cin_sgen_11_02_silofloor_vign_notice_hendricks" );	
		
		//to get the drone to move from this skipto
		level flag::set( "follow3_1" );
		
		//spawns and initializes risers
		level thread setup_silo_robot_risers();
		
		sgen::wait_for_all_players_to_spawn();
		sgen_util::setup_mappy_path();
		
		foreach( player in level.players )
		{
			player clientfield::set_to_player( "sndSiloBG", 1 );
			player clientfield::set_to_player( "dust_motes", 1 );		
		}	
		
		//start the battle off for skipto
		level flag::set( "start_silo_floor_battle" ); //on radius trigger on the bottom	
	}
	
	level thread silo_floor_battle_vo();
	
	silo_floor_battle();
	
	skipto::objective_completed( str_objective );
}

function silo_floor_battle_vo()
{
	//check if hendricks is where he needs to be	
	level flag::wait_till( "hendricks_at_silo_floor" );
	
	//then wait until a player has dropped down	
	level flag::wait_till( "player_at_silo_floor" );	
	
	level flag::set( "send_drone_over_grate" );
	
	//Recon Drone says they came through here.
	level.ai_hendricks dialog::say( "hend_recon_drone_says_the_0" ); 
	
	//Anyone wanna bet a hundred against us finding some fucked up shit down here? 
	level.ai_hendricks dialog::say( "hend_anyone_wanna_bet_a_h_0" );	
	
	//wait until the dialog is finish, this kicks off the ambush logic
	playsoundatposition ("evt_metal_bang", (-624,995,-2569));
	wait (1);
	playsoundatposition( "mus_coalescence_theme_silo", (-624,995,-2569) );
	wait(1);
	level notify ("ambush"); //for robot spawn sounds
	wait (3);
	
	
	level flag::set( "start_floor_risers" );	
	
	level.ai_hendricks dialog::say( "hend_whoa_what_the_hel_0" ); //Whoa -- what the hell?
	level.ai_hendricks dialog::say( "hend_whoa_whoa_0", 2 ); //Whoa, whoa--	
	
	//AMBUSH
	level flag::wait_till( "start_silo_ambush" );
	
	level.ai_hendricks dialog::say( "hend_ambush_0" );	

}

//	Hendricks' movement for the silo floor.  It's mainlty combatfor
//	self is Hendricks
function silo_floor_hendricks()
{
	//send drone to grate to highlight it
	level flag::set( "hendricks_at_silo_floor" );
	
	//turn on player trigger at the bottom of the silo
	trig_player_at_silo_floor = GetEnt( "trig_player_at_silo_floor", "targetname" );
	trig_player_at_silo_floor TriggerEnable( true );
	
	//wait until a player has dropped down	
	level flag::wait_till( "player_at_silo_floor" );
	
	//send hendricks up
	nd_hendricks_silo_front = GetNode( "nd_hendricks_silo_front", "targetname" );
	level.ai_hendricks ai::force_goal( nd_hendricks_silo_front, 32 );	
		
	//the dialog thread kicks this off
	level flag::wait_till( "start_silo_ambush" );
	
	self ai::set_ignoreme( false );
	self ai::set_ignoreall( false );		
	
	//update objectives
	objectives::set( "cp_level_sgen_silo_kill" );			

	//play scene of hendricks reacting and pointing to ambush
	//level scene::play( "cin_sgen_11_01_silofloor_vign_react_ambush_hendricks" );//TODO - this scene does not work with the current setup, we need to evaluate this sequence
	
	//send hendricks back, then let him use the goal radius of these cover nodes so he is a bit more mobile
	nd_hendricks_silo_fallback = GetNode( "nd_hendricks_silo_fallback", "targetname" );
	level.ai_hendricks ai::force_goal( nd_hendricks_silo_fallback, 32 );
}

function silo_floor_battle()
{		
	//rushers in the silo battle - These guys are green in radiant
	array::thread_all( GetSpawnerArray( "silo_robot_rusher", "script_noteworthy" ), &spawner::add_spawn_function, &init_silo_robot_rusher );
	
	//middle room guys
	array::thread_all( GetSpawnerArray( "middle_room_robots", "targetname" ), &spawner::add_spawn_function, &init_silo_robots );
	array::thread_all( GetSpawnerArray( "silo_ambush_robots", "targetname" ), &spawner::add_spawn_function, &init_silo_robots );
	
	level flag::wait_till( "start_silo_ambush" );
	
	level thread cp_mi_sing_sgen_sound::sndMusicSet( "dark_battle" );
	
	if ( level.players.size > 1 )
	{
		n_delay = 20;
	}
	else
	{
		n_delay = 30;
	}
	
	level thread flag::delay_set( n_delay, "spawn_silo_robots" );
	
	spawner::simple_spawn( "middle_room_robots" );
	
	level thread monitor_middle_room_robots();
	
	level flag::wait_till( "spawn_silo_robots" );
	
	spawner::simple_spawn( "silo_ambush_robots" );
		
	//wait until everyone is dead
	spawner::waittill_ai_group_cleared( "silo_floor_robots" );
	level notify ("srcdd"); //for music system clear

	level.ai_hendricks thread dialog::say( "hend_all_clear_who_the_h_0", 1.0 ); //All clear! Who the hell’s controlling this grunts?		
	
	level flag::set( "silo_floor_cleared" );
	
	level thread cp_mi_sing_sgen_sound::sndMusicSet( "dark_battle", true );
	
	objectives::complete( "cp_level_sgen_silo_kill" );
}

function monitor_middle_room_robots()
{
	if ( level.players.size > 1 )
	{
		n_killed = 7;
	}
	else
	{
		n_killed = 9;
	}
	
	spawner::waittill_ai_group_amount_killed( "silo_floor_robots", n_killed );
	
	level flag::set( "spawn_silo_robots" );
}

//once a trigger his hit by an enemy, we should a magic bullet with nosound/impact to ensure we break the window
//self = trigger
function break_window_hack()
{
	//bullet start/end
	s_bullet_end = struct::get( self.target, "targetname" );
	s_bullet_start = struct::get( s_bullet_end.target, "targetname" );
	
	self waittill( "trigger", ai_guy );
	
	if ( isalive( ai_guy ) )
	{
		for( i=0; i < 15; i++ )
		{
			MagicBullet( level.ai_hendricks.weapon, s_bullet_start.origin, s_bullet_end.origin );
			wait 0.05;
		}
	}
}

function setup_silo_robot_risers()
{
	array::thread_all( GetEntArray( "trig_enemy_silo_window", "targetname" ), &break_window_hack );
	
	//setup riser spawner
	sp_robot_riser = GetEnt( "robot_riser_spawner", "targetname" );
	spawner::add_spawn_function_group( "robot_riser_spawner", "targetname", &init_silo_robots_riser );
	
	//initialize risers
	//front guys
	s_front_robot_riser_01 = struct::get( "front_robot_riser_01" );
	s_front_robot_riser_02 = struct::get( "front_robot_riser_02" );
	s_front_robot_riser_03 = struct::get( "front_robot_riser_03" );
	
	ai_front_robot_riser_01 = sp_robot_riser spawner::spawn( true );
	ai_front_robot_riser_02 = sp_robot_riser spawner::spawn( true );
	ai_front_robot_riser_03 = sp_robot_riser spawner::spawn( true );
	
	ai_front_robot_riser_01 thread play_silo_floor_rise( s_front_robot_riser_01, 1 );
	ai_front_robot_riser_02 thread play_silo_floor_rise( s_front_robot_riser_02, 3.5 );
	ai_front_robot_riser_03 thread play_silo_floor_rise( s_front_robot_riser_03, 2.5 );
	
	//spawn and initialize middle room guys
	a_middle_room_riser = struct::get_array( "middle_room_riser", "targetname" );
	
	foreach( s_riser in a_middle_room_riser )
	{
		ai_riser = sp_robot_riser spawner::spawn( true );
		ai_riser thread setup_middle_room_robots( s_riser );
	}
	
	level flag::wait_till( "start_floor_risers" );
	
	level flag::set( "start_middle_room_risers" );
	
	wait 1;//Wait a bit before the event goes hot
	
	level flag::set( "start_silo_ambush" );
}

//self = riser on floor
function play_silo_floor_rise( s_align, n_delay )
{
	self endon( "death" );
	
	s_align thread scene::init( self );
	
	level flag::wait_till( "start_floor_risers" );
	
	if ( isdefined( n_delay ) )
    {
		wait( n_delay );
    }
	
	s_align thread scene::play( self );
}

//self = riser in middle room
function setup_middle_room_robots( s_align )
{
	self endon( "death" );
		
	s_align thread scene::init( self );

	level flag::wait_till( "start_middle_room_risers" );

	s_align scene::play( self );

	self ai::set_behavior_attribute( "force_cover", false );
	
	nd_goal = GetNode( s_align.target, "targetname" );
	self SetGoal( nd_goal, true );
	
	//if he's still alive in 5 seconds, then use the volume
	wait 10;
	
	//use the volume once they rise
	e_silo_floor_volume = GetEnt( "silo_floor_volume", "targetname" );
	self SetGoal( e_silo_floor_volume );	
}

//self = robot siser
function init_silo_robots_riser()
{
	self endon( "death" );
	
	level flag::wait_till( "start_floor_risers" );	
	
	//wait on the notify from the anim
//	self waittill( "turn_on_robot_eyes" );
	wait 2;
	
	self thread sgen_util::robot_eye_fx_on();	
	
	//use the volume once they rise
	e_silo_floor_volume = GetEnt( "silo_floor_volume", "targetname" );
	self SetGoal( e_silo_floor_volume );
}

function monitor_right_side_robots()
{	
	flag::wait_till( "spawn_left_side_robots" );
	
	spawner::simple_spawn( "silo_left_side_robots" );
}

function init_silo_robots()
{
	self endon( "death" );
	
	self thread sgen_util::robot_eye_fx_on();
	
	if ( isdefined( self.target ) )
	{
		//top level guys
		if ( self.script_string === "top_level_robot" )
		{			
			//dont fire until at goal
			self ai::set_ignoreall( true );
			
			nd_goal = GetNode( self.target, "targetname" );
			self ai::force_goal( nd_goal, 32 );
			
			self ai::set_ignoreall( false );
			
			//wait a bit until jumping all the way down
			if ( level.players.size > 1 )
			{
				wait 5;	
			}
			else
			{
				wait RandomFloatRange( 6.0, 7.5 );
			}
				
			//use the volume once you get to position
			e_silo_floor_volume = GetEnt( "silo_floor_volume", "targetname" );
			self SetGoal( e_silo_floor_volume, true );
		}
	}
	else
	{	
		//use the volume once you get to position
		e_silo_floor_volume = GetEnt( "silo_floor_volume", "targetname" );
		self SetGoal( e_silo_floor_volume, true );
	}	
}

function init_silo_robot_rusher()
{
	self endon( "death" );
	
	self thread sgen_util::robot_eye_fx_on();
	
	if ( level.players.size == 1 )
	{
		wait RandomFloatRange( 0.5, 2.5 );
	}
	
	self ai::set_behavior_attribute( "move_mode", "rusher" );
	self ai::set_behavior_attribute( "sprint", true );	
}

function skipto_silo_floor_done( str_objective, b_starting, b_direct, player )
{
}

///////////////////////////////////////////////////////////////////
//	Under Silo Floor 
///////////////////////////////////////////////////////////////////


function skipto_under_silo_init( str_objective, b_starting )
{
	if ( b_starting )
	{	
		sgen::init_hendricks( str_objective );
		level.ai_hendricks ai::set_behavior_attribute( "cqb", true );
		level.ai_hendricks ai::set_behavior_attribute( "sprint", true );		
		
		spawn_mapping_drone();
		level.vh_mapper thread drone_lead_player_silo_floor();
		
		level scene::skipto_end( "p7_fxanim_cp_sgen_bridge_silo_edge_break_bundle" );
		
		//setup function to take care of the grate getting highlighted
		scene::add_scene_func( "cin_sgen_11_02_silofloor_vign_notice_hendricks", &drone_highlights_grate, "init" );	
		
		level scene::init( "cin_sgen_11_02_silofloor_vign_notice_hendricks" );
		
		objectives::complete( "cp_level_sgen_enter_sgen" );
		objectives::set( "cp_level_sgen_investigate_sgen" );

		//send the drone to position to scan the grate
		level flag::set( "silo_floor_cleared" );
		
		//set this so we get past grate highlights
		level flag::set( "drone_over_grate" ); 
		level flag::set( "start_silo_ambush" );	
		
		sgen::wait_for_all_players_to_spawn();
		sgen_util::setup_mappy_path();
		
		foreach( player in level.players )
		{
			player clientfield::set_to_player( "sndSiloBG", 1 );
		}
	}

	// Allow things to float
	level clientfield::set( "w_underwater_state", 1 );	
	
	// Start corvus entrance fxanims
	level clientfield::set( "fallen_soldiers_client_fxanims", 1 );
	
	level thread under_silo_objective_breadcrumbs();
	level.ai_hendricks under_silo_hendricks();

	// End
	level flag::wait_till( "enter_corvus" );
	
	foreach( player in level.players )
	{
		player clientfield::set_to_player( "sndSiloBG", 0 );
		player clientfield::set_to_player( "dust_motes", 0 );//TODO - SHABS, please hook this up to get called when the player drops through the grate
	}

	objectives::complete( "cp_level_sgen_investigate_sgen" );

	skipto::objective_completed( str_objective );
}

function under_silo_objective_breadcrumbs()
{
	//set marker below fan
	//hendricks 1st stop
	s_under_silo_obj_breadcrumb_1 = struct::get( "under_silo_obj_breadcrumb_1", "targetname" );
	objectives::set( "cp_standard_breadcrumb", s_under_silo_obj_breadcrumb_1 );
	level flag::wait_till( "hendricks_under_silo_second_jump" ); //flag is on the trigger
	objectives::complete( "cp_standard_breadcrumb", s_under_silo_obj_breadcrumb_1 );		

	//hendricks 2nd stop
	s_under_silo_obj_breadcrumb_2 = struct::get( "under_silo_obj_breadcrumb_2", "targetname" );
	objectives::set( "cp_standard_breadcrumb", s_under_silo_obj_breadcrumb_2 );
	level flag::wait_till( "hendricks_under_silo_third_jump" ); //flag is on the trigger
	objectives::complete( "cp_standard_breadcrumb", s_under_silo_obj_breadcrumb_2 );	

	//hendricks 3rd stop
	s_under_silo_obj_breadcrumb_3 = struct::get( "under_silo_obj_breadcrumb_3", "targetname" );
	objectives::set( "cp_standard_breadcrumb", s_under_silo_obj_breadcrumb_3 );
	level flag::wait_till( "hendricks_under_silo_fourth_jump" ); //flag is on the trigger
	objectives::complete( "cp_standard_breadcrumb", s_under_silo_obj_breadcrumb_3 );		
	
	//just before bottom
	s_under_silo_obj_breadcrumb_4 = struct::get( "under_silo_obj_breadcrumb_4", "targetname" );
	objectives::set( "cp_standard_breadcrumb", s_under_silo_obj_breadcrumb_4 );
	level flag::wait_till( "hendricks_under_silo_fifth_jump" ); //on trigger radius that engulfs silo
	objectives::complete( "cp_standard_breadcrumb", s_under_silo_obj_breadcrumb_4 );	
	
	//corvus entrance breadcrumb
	s_under_silo_obj_breadcrumb_5 = struct::get( "under_silo_obj_breadcrumb_5", "targetname" );
	objectives::set( "cp_standard_breadcrumb", s_under_silo_obj_breadcrumb_5 );
	level flag::wait_till( "enter_corvus" ); //on trigger radius that engulfs silo
	objectives::complete( "cp_standard_breadcrumb", s_under_silo_obj_breadcrumb_5 );		

}

function skipto_under_silo_done( str_objective, b_starting, b_direct, player )
{
	level flag::set( "silo_grate_open" );

	// Get rid of dead bodies
	a_bodies = GetCorpseArray();
	foreach( corpse in a_bodies )
	{
		if( isdefined( corpse ) )
		{
			corpse delete();
			wait( 0.05 );
		}
	}
}

function drone_highlights_grate( a_scene_ents )
{
	//first highlight
	level flag::wait_till( "drone_over_grate" );
	
	a_scene_ents[ "silo_floor_grate" ] clientfield::set( "structural_weakness", 1 );
		
	level flag::wait_till( "start_silo_ambush" );
	
	a_scene_ents[ "silo_floor_grate" ] clientfield::set( "structural_weakness", 0 );

	//second highlight
	level flag::wait_till( "drone_over_grate_real" );

	a_scene_ents[ "silo_floor_grate" ] clientfield::set( "structural_weakness", 1 );
	
	level flag::wait_till( "silo_grate_open" );
	
	a_scene_ents[ "silo_floor_grate" ] clientfield::set( "structural_weakness", 0 );
}

//self = hendricks
function under_silo_hendricks()
{
	//if players arent in the vicinity of hendricks anim position, wait for then
	level flag::wait_till( "silo_floor_regroup" ); //this is on a trigger 

	level thread ev_player_tutorial();
	
	level thread under_silo_vo();	
	
	//wait until the drone has come downa nd highlighted the grate after the battle
	level flag::wait_till( "drone_over_grate_real" );
	
	//hendricks plays scene of him walking to grate and opening
	scene::play( "cin_sgen_11_02_silofloor_vign_notice_hendricks" );
		
	level thread util::clientnotify( "sound_kill_thunder" );
	
	// Hendricks jumps down
	level scene::play( "cin_sgen_11_02_silofloor_traverse_vign_hendricks_firstjump" );
	level.ai_hendricks waittill( "idle_started" );	// notify notetrack added to the idle anim
	
	//give it a second before starting
	wait 1;
	
	level flag::wait_till( "hendricks_under_silo_second_jump" ); //on trigger radius that engulfs silo
	
	// Do the second jump
	level thread scene::play( "cin_sgen_11_02_silofloor_traverse_vign_hendricks_secondjump" );
	level.ai_hendricks waittill( "idle_started" );	// notify notetrack added to the idle anim

	level flag::wait_till( "hendricks_under_silo_third_jump" ); //on trigger radius that engulfs silo
	
	level thread scene::play( "cin_sgen_11_02_silofloor_traverse_vign_hendricks_thirdjump" );
	level.ai_hendricks waittill( "idle_started" );	// notify notetrack added to the idle anim

	level flag::wait_till( "hendricks_under_silo_fourth_jump" ); //on trigger radius that engulfs silo
		
	level thread scene::play( "cin_sgen_11_02_silofloor_traverse_vign_hendricks_fourthjump" );
	level.ai_hendricks waittill( "idle_started" );	// notify notetrack added to the idle anim
	
	level flag::wait_till( "hendricks_under_silo_fifth_jump" ); //on trigger radius that engulfs silo
	
	level scene::play( "cin_sgen_11_02_silofloor_traverse_vign_hendricks_fifthjump" );
	
	//wait at door, enter_corvus flag on trig sends him into fallen soldier skpto
	nd_post_jump_downs = GetNode( "nd_post_jump_downs", "targetname" );
	self thread ai::force_goal( nd_post_jump_downs, 32 );
}

function under_silo_vo()
{
	//waittill grate is open, then send drone and say this
	level flag::wait_till( "silo_grate_open" );
	
//	Alright... Sending recon drone ahead.
	level.ai_hendricks dialog::say( "hend_alright_sending_r_0" );
	
	//Let’s go see how far down this rabbit hole goes...
	level.ai_hendricks dialog::say( "hend_let_s_go_see_how_far_0", 2 );
	
	//wait until player gets below
	level flag::wait_till( "hendricks_under_silo_second_jump" ); //on trigger radius that engulfs silo
	
//	Hustle, Recon Drone ain’t gonna wait on us.
	level.ai_hendricks dialog::say( "hend_hustle_recon_drone_0" );
	
	//wait until the drone dies
	level flag::wait_till( "drone_died" );
	
//	Kane - We lost the feed. Problem at your end?
	level.ai_hendricks dialog::say( "hend_kane_we_lost_the_f_0" );
	
//	Negative.
//	(beat)
//	Blueprints end at the silo’s floor. Without the drone - We’re blind.	
	level.players[0] dialog::player_say( "kane_negative_beat_blu_0" );
	
//	Fucking Tech...
	level.ai_hendricks dialog::say( "hend_fucking_tech_0" );
	
//	Keep moving - GPS coordinates put the  alarm just up ahead.
	level dialog::remote( "kane_keep_moving_gps_co_0" );
}

//----------------------------------------------------------------
//	MAPPING DRONE
//----------------------------------------------------------------

function spawn_mapping_drone( str_start_node )
{
	level.vh_mapper = vehicle::simple_spawn_single( "mapping_drone" );
	level.vh_mapper.animname = "mapping_drone";
	level.vh_mapper SetCanDamage( false );

	if ( isdefined( str_start_node ) )
	{
		nd_start = GetVehicleNode( str_start_node, "targetname" );
		if ( isdefined( nd_start ) )
		{
			level.vh_mapper.origin = nd_start.origin;
			level.vh_mapper.angles = nd_start.angles;
		}
	}
	
	level.vh_mapper clientfield::set( "show_mappy_path", 1 );
}


//
//	Wait for a flag if specified and then proceed along the vehicle spline segment.
//	self is the mapping drone
//
//TODO We might need a separate handler for the drone's pathing so that
//		1) We can vary the speed depending on player progress
//		2) we can't accidentally cause the drone to jump to a later track because of multiple calls to this func.
function drone_follow_path( str_start_node, str_flag, b_draw_path = true )
{
	nd_first = GetVehicleNode( str_start_node, "targetname" );
	self.origin = nd_first.origin;

	// spawn vtol, fly in and land
	if ( isdefined( str_flag ) )
	{
		level flag::wait_till( str_flag );
	}

	self thread vehicle::get_on_path( str_start_node );
	self StartPath();
	self thread drone_speed_regulator();
	
	if ( b_draw_path )
	{
//		set clientfield::set( "show_mappy_path", 1 );
	}
	
	self waittill( "reached_end_node" );

	wait( 0.05 );	// Wait until after any previous "reached_end_node" has been processed.
					// Continuing without a wait caused the temp_draw_path to sometimes end prematurely.
					// Or the Drone to continue on its path
}


//
//	Cause drone to move at this speed
//	self is the mapping drone
function drone_set_speed_override( n_speed )
{
	self.n_speed_override = n_speed;
	self SetSpeed( self.n_speed_override, 35, 35 );
}


//
//	self is the mapping drone
function drone_clear_speed_override()
{
	self.n_speed_override = undefined;
}


//
//	This will try to keep the drone in front of players.  It will travel slowly if the player is too far
//	and it will travel quickly if the player is ahead or too close to the drone.
//	self is the mapping drone
function drone_speed_regulator()
{
	self endon( "stop_speed_regulator" );
	self endon( "reached_end_node" );

	const N_TOO_CLOSE_DIST_SQ		= 140625;		// 375^2	Need to speed up when players are too close
	const N_WAIT_DIST_SQ			= 562500;		// 750^2	How far out do I wait for players to catch up?
	const N_IN_RANGE_DIST_SQ		= 1000000;		// 1000^2	How far out do I care about detecting players?
	const N_PLAYER_HEIGHT_OFFSET	= 72;			// Offset to use when comparing player height to the drone
	const N_MAX_HEIGHT_DIFFERENCE	= 96;			// Range at which a Player is considered to be on the same level
	N_FORWARD_VIEW					= Cos( 89 );	// Forward view of the drone, cosine.  Used for dot product checks

	self.n_speed = 0;	// Drone speed
	while ( true )
	{
		if ( IsDefined( self.n_speed_override ) )
		{
			self.n_speed = self.n_speed_override;
			self SetSpeed( self.n_speed_override, 35, 35 );
			wait( 0.05 );
			
			continue;
		}
		
		n_lowest_height_offset	= 10000;
		n_closest_dist_sq		= 9000000;	// 3000^2
		e_lowest_player 		= level.players[0];
		e_closest_player 		= level.players[0];
		b_player_is_ahead = false;	// Do I need to catch up to the player?
		foreach( player in level.players )
		{
			if ( !IsAlive( player ) )
			{
				continue;
			}
			
			n_height_offset = player.origin[2] + N_PLAYER_HEIGHT_OFFSET - self.origin[2];
			n_dist_sq = DistanceSquared( player.origin, self.origin );

			// Find lowest player
			if ( n_height_offset < n_lowest_height_offset )
			{
				n_lowest_height_offset = n_height_offset;
				e_lowest_player = player;
			}

			// Find closest player
			if ( n_dist_sq < n_closest_dist_sq )
			{
				n_closest_dist_sq = n_dist_sq;
				e_closest_player = player;
			}

			// Is someone in "front" of the drone?
			//	Roughly at the same height and in a forward arc of the drone
			if ( ( Abs( n_height_offset ) < N_MAX_HEIGHT_DIFFERENCE ) )
			{
				if ( util::within_fov( self.origin, self.angles, player.origin, N_FORWARD_VIEW ) )
				{
					b_player_is_ahead = true;
				}
			}
		}

		// If everyone is far away, I may need to wait
		if ( n_closest_dist_sq > N_WAIT_DIST_SQ )
	    {
	    	b_wait_for_player = true;
		}
		else
		{
	    	b_wait_for_player = false;
		}
		
		// Is anyone too low under the drone OR 
		//	too close OR 
		//	on roughly the same level AND in front of the drone?
		// Speed up
		if ( n_lowest_height_offset < -1*N_MAX_HEIGHT_DIFFERENCE ||
		   	 n_closest_dist_sq <= N_TOO_CLOSE_DIST_SQ ||
		   	 b_player_is_ahead )
		{
			self.n_speed = 25;
		}
		//	else are they too far away?
		// Stop
		else if ( b_wait_for_player )
		{
			self.n_speed = 0;
			self vehicle::pause_path();
			
			if ( !level flag::get( "drone_scanning" ) )
			{
				self thread drone_fake_scan( 60, 90, 15, 50 );	
			}
		}
		// Travel normal speed
		else
		{
			self.n_speed = 5;
			self vehicle::resume_path();
			
			if ( level flag::get( "drone_scanning" ) )
			{
				level flag::clear( "drone_scanning" );
			}
		}
		
		self SetSpeed( self.n_speed, 35, 35 );
		wait( 0.05 );	// Check interval
	}
}

//	look around within the given parameters
//		NOTE: The values must be Whole numbers (0, 1, 2, 3 etc.)
// self is the drone
function drone_fake_scan( n_yaw_left = 90, n_yaw_right = 90, n_pitch_down = 10, n_pitch_up = 30 )
{
	level flag::set( "drone_scanning" );

	//	Use current direction as base look
	e_base = Spawn( "script_origin", self.origin );
	e_base.angles = self.angles;
	self LinkTo( e_base );

	v_base_look = self.angles;
	while( level flag::get( "drone_scanning" ) )
	{
		v_look_offset = ( RandomFloatRange( -n_pitch_down, n_pitch_up ), RandomFloatRange( -n_yaw_left, n_yaw_right ), 0 );
		v_look_angles = v_base_look + v_look_offset;
		e_base RotateTo( v_look_angles, 0.5, 0.2, 0.2 );
		e_base waittill( "rotatedone" );
		
		wait randomfloatrange(1.5-1.5/3,1.5+1.5/3);
	}

	e_base Delete();
}


//	Follow the path in sequence.  Don't allow a competing thread to make it jump.
//	self is the mapping drone
function drone_lead_player_post_data()
{
	self thread speed_up_at_shimmy();
	
	level flag::wait_till( "post_discover_data" );
	
	//stop the idle after discover data 
	if ( level scene::is_active( "cin_sgen_06_01_followleader_vign_activate_eac_drone" ) )
	{
		level scene::stop( "cin_sgen_06_01_followleader_vign_activate_eac_drone" );
	}	
	
	self drone_follow_path( "nd_post_discover_data", "post_discover_data" ); 	
	
	//wait until player reaches a point and have the drone speed up and reach the gen lab
	//then play scene
	level flag::wait_till( "player_past_shimmy_wall" );
	
	//init gen lab scene to get corpse(s) in place
	level scene::init( "cin_sgen_07_01_genlab_vign_patrol" );
	
	self thread drone_lead_player_gen_lab();
}

//had to call an endon the regulator function because of the player anim and a player origin issue
//self = drone, getting off the regulator so it reaches it end node in time
function speed_up_at_shimmy()
{
	level flag::wait_till( "player_past_shimmy_wall" );
	
	self notify( "stop_speed_regulator" );
	
	if ( level flag::get( "drone_scanning" ) )
	{
		level flag::clear( "drone_scanning" );
	}
	
	self drone_set_speed_override( 15 );
}

function private close_menu_with_delay(menuHandle, delay)
{
	self SetLUIMenuData( menuHandle, "close_current_menu", 1 );
	wait delay;
	self CloseLUIMenu(menuHandle);
}

//self = drone
function gen_lab_pip_think()
{
	// PIP On
	self clientfield::set( "extra_cam_ent", 1 );
	foreach( player in level.players )
	{
		player.menu_pip = player OpenLUIMenu( "drone_pip" );
	}

	/#
		iPrintLnBold( "WARNING: Hostiles detected!" );
	#/
	
	level flag::wait_till( "gen_lab_pip_off" );

	// PIP off
	foreach( player in level.players )
	{
		player thread close_menu_with_delay( player.menu_pip, 1.25 );
		player.menu_pip = undefined;
	}
	self clientfield::set( "extra_cam_ent", 0 );
}

function pre_gen_lab_vo()
{
//	Shit... Damn 54i are already ahead of us.
//	(beat)
//	What you think we should do?
	level.ai_hendricks dialog::say( "hend_shit_damn_54i_are_0" );	
	
//	I think it’s time we introduce ourselves.
	level.players[0] dialog::player_say( "plyr_i_think_it_s_time_we_0" );
}

//	self is the mapping drone
function drone_lead_player_gen_lab()
{
	self drone_set_speed_override( 30 );
	self drone_follow_path( "nd_start_gen_lab", undefined, false );

	level thread pre_gen_lab_vo();
	
	scene::add_scene_func( "cin_sgen_07_01_genlab_vign_patrol", &setup_patrol_scene, "play" );	
	
	//spawn guys, then play scene
	spawner::simple_spawn_single( "gen_lab_warlord", &setup_gen_lab_warlord ); 
	spawner::simple_spawn_single( "gen_lab_enemy_1", &setup_gen_lab_guy ); 
	spawner::simple_spawn_single( "gen_lab_enemy_2", &setup_gen_lab_guy ); 
	spawner::simple_spawn_single( "gen_lab_enemy_3", &setup_gen_lab_guy ); 
	spawner::simple_spawn_single( "gen_lab_enemy_4", &setup_gen_lab_guy ); 
	spawner::simple_spawn_single( "gen_lab_enemy_5", &setup_gen_lab_guy ); 
	
	self thread gen_lab_pip_think();	
	
	level scene::play( "cin_sgen_07_01_genlab_vign_patrol" );
	level flag::set( "gen_lab_pip_off" );
	
	//have drone move to position after anim without setting a trail
	self drone_follow_path( "nd_gen_lab_battle", undefined, false ); 
	self thread drone_fake_scan( 60, 90, 15, 50 );
	
	level flag::wait_till( "player_mid_gen_lab" );
	
	//stop the drone scanning behavior
	level flag::clear( "drone_scanning" );
	
	//wait until player hits mid trigger or kills x amount of guys
	self drone_follow_path( "nd_follow_gen_lab_passthru", "player_mid_gen_lab", false ); 

	// Catch up after lab is cleared
	level flag::wait_till( "gen_lab_cleared" );
	
	self drone_set_speed_override( 25 );
	self drone_follow_path( "nd_follow_gen_lab_mid" );
	
	//wait until hendricks is in positions
	level flag::wait_till( "hendricks_at_gen_lab_door" );
	
	//now turn on the trigger to check if the player is next to them
	trig_gen_lab_door_player_check = GetEnt( "trig_gen_lab_door_player_check", "targetname" );
	trig_gen_lab_door_player_check TriggerEnable( true );		
	level flag::wait_till( "player_at_gen_lab_door" ); //flag is on the trigger
	
//	then open door
	e_gen_lab_end_door = GetEnt( "gen_lab_end_door", "targetname" );
	e_gen_lab_end_door MoveZ( 100, 2, 1 );
	e_gen_lab_end_door playsound( "evt_genlab_door_open" );
	e_gen_lab_end_door waittill( "movedone" );
	
	level flag::set( "gen_lab_door_opened" );
	
	self thread drone_lead_player_post_gen_lab();
}

//	self is the mapping drone
function drone_lead_player_post_gen_lab()
{
	self drone_set_speed_override( 15 );
	self drone_follow_path( "nd_post_gen_lab_start" );
	
	//wait until player triggers wall run trig
	self drone_set_speed_override( 30 );
	self drone_follow_path( "nd_drone_bridge_path", "hendricks_follow2_wallrun_trick" );
	
	level flag::wait_till( "follow_chem_lab" );
	
	self thread drone_lead_player_chem_lab();
}

//	self is the mapping dronechem_lab_trigger
function drone_lead_player_chem_lab()
{
	//reset speed override
	self drone_clear_speed_override();
	
	self drone_set_speed_override( 5 );
	self drone_follow_path( "nd_follow_chem_lab", "chem_lab_start" ); //flag is on the trigger that also sends hendricks into the room

	//wait until hendricks has opened the door, then move to the next position
	self drone_follow_path( "nd_post_chem_lab", "chem_door_open" );
	
	self thread drone_lead_player_post_chem_lab();
}

//	self is the mapping drone
function drone_lead_player_post_chem_lab()
{
	self drone_set_speed_override( 10 );
	self drone_follow_path( "nd_pre_ambush", "follow3_1" );
	
	self thread drone_lead_player_silo_battle();
}

function drone_lead_player_silo_battle()
{
	//wait until hendricks is in position, then fly over to grate and highlight it
	self drone_set_speed_override( 15 );
	self drone_follow_path( "nd_highlight_grate", "send_drone_over_grate", false );
	
	//notify to the scene func
	level flag::set( "drone_over_grate" );
	
	//wait until risers, then react to it, then fly away to a safe place
	self drone_set_speed_override( 15 );
	self drone_follow_path( "nd_ambush_react", "start_floor_risers", false );

	self thread drone_lead_player_silo_floor();	
}

//	self is the mapping drone
function drone_lead_player_silo_floor()
{
	//turn off mapping shader until it moves down
	level.vh_mapper clientfield::set( "show_mappy_path", 0 );
	
	//wait until enemies are all dead to fly over the grate again, and highlight it for realsies
	self drone_set_speed_override( 15 );
	self drone_follow_path( "nd_silo_grate", "silo_floor_cleared", false ); //drone moves down once hendricks opens the floor grate
	
	//drone idles waiting for hendricks to lift grate
	level thread scene::init( "cin_sgen_11_02_silofloor_vign_notice_drone" );	
	
	//highlight grate
	level flag::set( "drone_over_grate_real" );
	
	//notetrack from hendricks anim
	level flag::wait_till( "silo_grate_open" );
	
	//turn on pathing shader
	level.vh_mapper clientfield::set( "show_mappy_path", 1 );
	
	//play drone going down through grate
	level scene::play( "cin_sgen_11_02_silofloor_vign_notice_drone" );
	
	self thread drone_discover_corvus();
	
	//main path down
	self drone_set_speed_override( 30 );
	self drone_follow_path( "nd_silo_floor_platform_1", "hendricks_under_silo_second_jump" );
}

// self is the drone
function drone_discover_corvus()
{
	//these notifies are on the vehicle nodes themselves
	self waittill( "near_corvus" );
	
	// slow it down so we don't over step the next part
	self drone_set_speed_override( 15 );
	self waittill( "show_corvus_entrance" );

	// What's this?
	self drone_set_speed_override( 5 );

	/#	
		iPrintlnBold( "Off-map location discovered." );
	#/
	
	// PIP On
	self clientfield::set( "extra_cam_ent", 2 );
	foreach( player in level.players )
	{
		player.menu_pip = player OpenLUIMenu( "drone_pip" );
	}
	
	//allow the feed to be on for a little bit
	wait 2;
	
	self waittill( "drone_death" );
	level flag::set( "drone_died" );
	
	// PIP off
	foreach( player in level.players )
	{
		player thread close_menu_with_delay( player.menu_pip, 1.25 );
		player.menu_pip = undefined;
	}
	self clientfield::set( "extra_cam_ent", 0 );

	//TODO Need a black screen or something
	wait 1;	//	Dramatic pause
	
	/#
		// Get destroyed
		iPrintlnBold( "Drone signal lost. Last known location indicated." );
	#/
	
	PlayFX( level._effect[ "drone_sparks" ], self.origin );
	self vehicle::lights_off();
	self vehicle::toggle_sounds(0);
	self clientfield::set( "show_mappy_path", 0 );
	sgen_util::setup_mappy_path( 0 );
}
