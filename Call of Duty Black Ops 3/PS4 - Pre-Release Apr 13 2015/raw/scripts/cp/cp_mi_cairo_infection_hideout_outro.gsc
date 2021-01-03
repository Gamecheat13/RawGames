#using scripts\codescripts\struct;

#using scripts\shared\ai_shared;
#using scripts\shared\array_shared;
#using scripts\shared\callbacks_shared;
#using scripts\shared\clientfield_shared;
#using scripts\shared\exploder_shared;
#using scripts\shared\hud_shared;
#using scripts\shared\util_shared;
#using scripts\shared\flag_shared;
#using scripts\shared\scene_shared;
#using scripts\shared\spawner_shared;

    	   	                                                                                                                         	                                                                                                                                                                                                                                                                                                                                                                    	        	     	             	    	   	                           	                               	                                	                                                              	                                                                                                              	                            	                                     	                                       	                                                               	   	                  	       	                                                    	                   	                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                       	                                                                                        	           	                        	                                            	                                             	                                                   	                                                             	                                                         	                                                                    	                                                                                                                                                                                                    	                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                     	                                                              	                                                          	                                   	                                   	                                                    	                                       
                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                            	                                                                                                                                                                                                                                                                                                                                                                                       
                                               	                                                          	              	                                                                                           

#using scripts\cp\_dialog;
#using scripts\cp\_objectives;
#using scripts\cp\_skipto;
#using scripts\cp\_util;

#using scripts\cp\cp_mi_cairo_infection_util;
#using scripts\cp\cp_mi_cairo_infection_zombies;



#precache( "material", "t7_hud_cp_placard_temp_igc" );
#precache( "fx", "explosions/fx_exp_nuke_full_inf" );
#precache( "model", "veh_t7_drone_siege" );
#precache( "string", "cp_infection_fs_hideout" );
#precache( "string", "cp_infection_fs_citybarren" );

#namespace hideout_outro;
//--------------------------------------------------------------------------------------------------
//		MAIN
//--------------------------------------------------------------------------------------------------
function main()
{
	init_clientfields();

	//init so shows in world.
	level thread scene::init( "p7_fxanim_cp_infection_house_ceiling_02_bundle" );	
	
	level flag::init( "underwater_done" );
		
	level._effect[ "nuke_fx" ] 		= "explosions/fx_exp_nuke_full_inf";
}

function init_clientfields()
{
	n_clientbits = GetMinBitCountForNum( 4 );
	
	clientfield::register("world", "infection_hideout_fx", 1, 1, "int" );
	clientfield::register("world", "hideout_stretch", 1, 1, "int" );
	clientfield::register("world", "stalingrad_rise_nuke", 1, 2, "int" );
	clientfield::register("world", "city_tree_passed", 1, 1, "int" );
	clientfield::register("world", "stalingrad_tree_init", 1, 2, "int" );
	clientfield::register("world", "stalingrad_city_ceilings", 1, n_clientbits, "int" );
	clientfield::register("world", "stalingrad_nuke_fog", 1, 2, "int" );
}
	
//--------------------------------------------------------------------------------------------------
//		HIDEOUT - AQUIFER
//		45 sec. cinematic
//		can walk around
//--------------------------------------------------------------------------------------------------
function hideout_main(str_objective, b_starting)
{
	level notify( "update_billboard" );

	//init the scene
	//scene::add_scene_func("cin_inf_13_01_hideout_vign_briefing", &hideout_scene_done , "done" );
	scene::add_scene_func("cin_inf_13_01_hideout_vign_briefing", &vo_hideout , "play" );
	scene::add_scene_func("p7_fxanim_cp_infection_hideout_stretch_bundle", &stretch_lights_play , "play" );


	level thread scene::init( "cin_inf_13_01_hideout_vign_briefing" );

	skipto::teleport_players( str_objective, false );

	level flag::wait_till( "all_players_spawned" );

	util::screen_fade_out( 0, "black" );
	//level infection_util::movie_transition( "cp_infection_fs_hideout" );

	level thread scene::play( "cin_inf_12_01_underwater_1st_fall_hideout03" );

	array::thread_all(level.players, &infection_util::player_enter_cinematic );	
	
	level thread util::screen_fade_in( 1, "black" );	
	level clientfield::set("infection_hideout_fx", 1);

	//play the scene
	level thread scene::play( "cin_inf_13_01_hideout_vign_briefing" );

	level waittill( "hideout_scene_stretch" );
	
	//level clientfield::set("hideout_stretch", 1);
	level thread scene::play( "p7_fxanim_cp_infection_hideout_stretch_bundle" );

	level waittill( "hideout_scene_fade" );
		
	foreach(player in level.players)
	{
		player PlayRumbleOnEntity( "cp_infection_hideout_stretch" );
	}		
		
	level thread util::screen_fade_out( 5, "black" );
		
	wait 5;	
	level thread hideout_scene_done();
}

function hideout_scene_done( a_ents )
{
	array::thread_all(level.players, &infection_util::player_leave_cinematic );

	level notify( "hideout_done" );
	
	level thread skipto::objective_completed("hideout");
}	

function stretch_lights_play( a_ents )
{
	a_str_lights = array( "light_fx_01", "light_fx_02", "light_fx_03", "light_fx_04", 
	"fx_light_1", "fx_light_2", "fx_light_3", "fx_light_5", "fx_light_6", "fx_light_7", "fx_light_9" );
	
	foreach( string in a_str_lights )
	{
		e_light = GetEnt( string, "targetname" );
		e_light thread link_hideout_lights( a_ents );
	}
}

function link_hideout_lights( a_ents )
{
	self LinkTo( a_ents[ "hideout_stretch" ], self.targetname + "_jnt" );

	level waittill( "hideout_done" );

	self UnLink();
	self Delete();
}

// ----------------------------------------------------------------------------
// DIALOG: Hideout vo
// ----------------------------------------------------------------------------
function vo_hideout( a_ents )
{
	wait 1;
	level dialog::player_say( "plyr_where_did_you_go_sa_0", 1.0 ); //Where did you go, Sarah? Did you find somewhere safe?
	level.players[0] dialog::say( "hall_we_held_up_in_the_ol_0", 1.0 ); //We held up in the old aquifers...
	level.players[0] thread dialog::say( "hall_and_made_our_pla_0", 0.0 ); //... and made our plan to snatch Salim.
}

//---- CLEANUP -------------------------------------------------------------------------------------
function hideout_cleanup(str_objective, b_starting, b_direct, player)
{
	
}
//--------------------------------------------------------------------------------------------------
//		interrogation - KEBECHET
//		1 min cinematic
//		can walk around
//--------------------------------------------------------------------------------------------------
function Interrogation_Main(str_objective, b_starting)
{
	level notify( "update_billboard" );

	//init the scene
	scene::add_scene_func("cin_inf_14_01_nasser_vign_interrogate", &interrogation_scene_play , "init" );
	scene::add_scene_func("cin_inf_14_01_nasser_vign_interrogate", &interrogation_scene_done , "done" );
//	level thread scene::init( "cin_inf_14_01_nasser_vign_interrogate" );

	skipto::teleport_players( str_objective, false );

	level flag::wait_till( "all_players_spawned" );

	util::screen_fade_out( 0, "black" );
	level thread util::screen_fade_in( 2, "black" );	

	array::thread_all(level.players, &infection_util::player_enter_cinematic );

	//prestream next closeup scene
	level thread util::set_streamer_hint( 5 );

	//play the scene
	level thread scene::play( "cin_inf_14_01_nasser_vign_interrogate" );

	level waittill( "interrogation_scene_fade" );

	exploder::exploder( "exploder_interrogation_transition" );

	level thread util::screen_fade_out( 3, "white" );
}

function interrogation_scene_play( a_ents )
{
	siegebot_int_panel = GetEnt( "siegebot_int_panel", "targetname" );
	siegebot_int_roof = GetEnt( "siegebot_int_roof", "targetname" );
	siegebot_spotlight = GetEnt( "siegebot_spotlight", "targetname" );

	siegebot_int_panel LinkTo( a_ents[ "sarah_bot" ], "tag_control_panel_light" );
	siegebot_int_roof LinkTo( a_ents[ "sarah_bot" ], "tag_turret_canopy_animate" );
	siegebot_spotlight LinkTo( a_ents[ "sarah_bot" ], "tag_light_attach_left" );

	level waittill( "interrogation_done" );

	siegebot_int_panel UnLink();
	siegebot_int_roof UnLink();
	siegebot_spotlight UnLink();
	
	siegebot_int_panel Delete();
	siegebot_int_roof Delete();
	siegebot_spotlight Delete();
}	


function interrogation_scene_done( a_ents )
{
	array::thread_all(level.players, &infection_util::player_leave_cinematic );

	level notify( "interrogation_done" );
	
	level thread skipto::objective_completed("interrogation");
}	

//---- CLEANUP -------------------------------------------------------------------------------------
function interrogation_cleanup(str_objective, b_starting, b_direct, player)
{
	if(IsDefined(level.interrogation_bot))
		level.interrogation_bot delete();	 		 	
}
//--------------------------------------------------------------------------------------------------
//		STALINGRAD CREATION
//		30 sec. cinematic
//		camera locked in place, look around
//--------------------------------------------------------------------------------------------------
function stalingrad_creation_main(str_objective, b_starting)
{
	level notify( "update_billboard" );

	//force to black wait for streamers
	util::screen_fade_out( 0, "white" );

	if( b_starting )
	{
		util::set_streamer_hint( 5 );
	}

	scene::add_scene_func("cin_inf_16_01_nazizombies_vign_treemoment_intro", &stalingrad_creation_play , "play" );
	scene::add_scene_func("cin_inf_16_01_nazizombies_vign_treemoment_intro", &stalingrad_creation_done , "done" );

	skipto::teleport_players( str_objective, true );

	level flag::wait_till( "all_players_spawned" );

//----Close up -----------------------------------------------------------------------------
	level thread util::screen_fade_in( 1, "white" );	

	level scene::play( "cin_inf_14_04_sarah_vign_05" );

	//clear streamer hint after scene done
	util::clear_streamer_hint();
		
	util::screen_fade_out( 1, "white" );

	level thread util::screen_fade_in( 2, "white" );	
//----Close up -----------------------------------------------------------------------------

	level thread scene::play( "cin_inf_16_01_nazizombies_vign_treemoment_intro" );

	wait 5;

	level thread growing_tree_init();
	
	//wait on empty landscape then start city rise
	wait 5;

	level thread stalingrad_rise_think();

	foreach ( player in level.players )
	{
		player playrumbleonentity( "cp_infection_hideout_stretch" );
	}
}

function stalingrad_creation_play( a_ents )
{
	a_ents[ "player 1" ] waittill( "start_house_fx" );
	level thread scene::play( "p7_fxanim_cp_infection_reverse_stalingrad_house_bundle" );

	//a_ents[ "player 1" ] waittill( "start_flash" ); //can't teleport player until scene is done
}

function stalingrad_creation_done( a_ents )
{
	level thread skipto::objective_completed("city_barren");
}

function stalingrad_rise_think()
{
	level.players[0] playsound( "evt_city_rise" );
	
	level clientfield::set("stalingrad_rise_nuke", 1);
}	

//---- CLEANUP -------------------------------------------------------------------------------------
function stalingrad_creation_cleanup(str_objective, b_starting, b_direct, player)
{
	
}	

//--------------------------------------------------------------------------------------------------
// GROWING TREE
//--------------------------------------------------------------------------------------------------
function growing_tree_init()
{
	level clientfield::set("stalingrad_tree_init", 1);
		
	level.players[0] playsound("evt_tree_grow");
}

//--------------------------------------------------------------------------------------------------
//		PAVLOVS HOUSE
//		Combat
//--------------------------------------------------------------------------------------------------
function pavlovs_house_main(str_objective, b_starting)
{
	level notify( "update_billboard" );

	skipto::teleport_players( str_objective, true );
	level flag::wait_till( "all_players_spawned" );

	if( b_starting )
	{
		util::screen_fade_out( 0, "black" );
			
		//preset init for buildings and tree to be there.
		level clientfield::set("stalingrad_tree_init", 1);
		
		//TODO: temporarily commenting out rise 
		level clientfield::set("stalingrad_rise_nuke", 1);	
			
		wait 3;
		level thread util::screen_fade_in( 0, "black" );			
	}
	
	infection_util::enable_exploding_deaths( true );
	level thread random_lightning();
	level thread pavlov_house_fxanim_init();

	//wait till sarah done talking.
	level flag::clear("spawn_zombies");
			
	level notify("start_zombie_sequence");

	level flag::wait_till( "sarah_tree" );
	level thread skipto::objective_completed("city");
}


function pavlov_house_fxanim_init()
{
	a_t_ceilings = GetEntArray( "t_house_ceiling", "targetname" );
	array::thread_all( a_t_ceilings, &pavlov_house_fxanim_play );
}

function pavlov_house_fxanim_play()
{
	if( isdefined( self.target ) )
	{
		s_target = struct::get( self.target, "targetname" );
	}

	//give it a few seconds for players to start moving around the house
	wait 3;
	
	while( true )
	{
		self waittill( "trigger", who );
		
		if( IsPlayer( who ) )
		{	
			if( isdefined( s_target ) )
			{	
				self thread player_look_at_watcher( who, s_target );
				self util::waittill_any_timeout( 5, "trigger_fxanim_ceiling" );
				self notify( "fxanim_ceiling_set" );	
			}
		
			if( self.script_int == 2 ) //only serversided one.
			{
				level thread scene::play( "p7_fxanim_cp_infection_house_ceiling_02_bundle" );
			}
			else
			{			
				level clientfield::set("stalingrad_city_ceilings", self.script_int);
			}
			self Delete();
			return;
		}		
	}
}	

function player_look_at_watcher( player, s_target )
{
	self endon( "fxanim_ceiling_set" );
	player endon( "death" );
	
	while( !player infection_util::IsLookingAtStruct( s_target ) )
	{
		wait 0.1;	
	}
	self notify( "trigger_fxanim_ceiling" );	
}	

//---- CLEANUP -------------------------------------------------------------------------------------
function pavlovs_house_cleanup(str_objective, b_starting, b_direct, player)
{
	objectives::complete( "cp_level_infection_access_sarah" );
	objectives::complete( "cp_level_infection_kill_sarah" );
	
	//ceiling collapse triggers no longer needed past this point	
	a_t_ceilings = GetEntArray( "t_house_ceiling", "targetname" );
	foreach( trig in a_t_ceilings )
	{
		trig Delete();
	}	
}

//--------------------------------------------------------------------------------------------------
//		SPECIAL SKIPTO FOR ZOMBIE END
//--------------------------------------------------------------------------------------------------
function pavlovs_house_end(str_objective, b_starting)
{
	level thread clientfield::set("city_tree_passed", 1);
	level.city_skipped = true;

	if(b_starting)
	{
		util::screen_fade_out( 0, "black" );
		
		//preset init for buildings and tree to be there.
		level clientfield::set("stalingrad_rise_nuke", 1);
		level clientfield::set("stalingrad_tree_init", 1);
	
		level flag::wait_till( "all_players_spawned" );

		//force house collapses to end. others on client.
		level thread scene::skipto_end( "p7_fxanim_cp_infection_house_ceiling_02_bundle" );	
		n_ceilings = 4;
		for( i=0; i < n_ceilings; i++ )
		{
			level clientfield::set("stalingrad_city_ceilings", i );
		}	

		wait 3;
		level thread util::screen_fade_in( 0, "black" );	 		

		infection_util::enable_exploding_deaths( true );
		level thread random_lightning();
	
		//to keep zombies from spawning till sarah at tree and set firewall to end point
		level flag::clear("spawn_zombies");

 		level.round_number = 4;
			
		level notify("start_zombie_sequence");

		level flag::set("zombies_final_round");
		level flag::set("spawn_zombies");
	}

	level flag::wait_till("zombies_completed");

	array::thread_all(level.players, &clientfield::set_to_player, "zombie_fire_overlay_init", 0 );

	level thread skipto::objective_completed("city_tree");
	infection_util::enable_exploding_deaths( false );
	
}

//---- CLEANUP -------------------------------------------------------------------------------------
function pavlovs_end_cleanup(str_objective, b_starting, b_direct, player)
{
	level notify("zombies_completed");
	level flag::set("zombies_completed");

	zombies = GetAiSpeciesArray( level.zombie_team, "all" );
	if(IsDefined(zombies))
	{
		for( i=0; i < zombies.size; i++ )
		{
			zombies[i] delete();
		}
	}
	
	if(IsDefined(level.pavlov_sarah))
	{
		level.pavlov_sarah delete();
	}		

	t_fire_trig = GetEnt("pavlov_house_fire","targetname");
	if( isdefined( t_fire_trig ) ) 
	{
		t_fire_trig Delete();
	}
	
	t_fire_warning_trig = GetEnt("pavlov_house_fire_warning","targetname");
	if( isdefined( t_fire_warning_trig ) ) 
	{
		t_fire_warning_trig Delete();
	}

	//firewall fx delete
	firewallfx = GetEntArray("firewall_firepos", "targetname");
	foreach( ent in firewallfx )
	{
		ent clientfield::set("zombie_fire_wall_fx", 0);
		util::wait_network_frame();
		ent delete();	
	}
}

// ----------------------------------------------------------------------------
// DIALOG: Stalingrad VO
// ----------------------------------------------------------------------------
function pavlovs_temp_messages()
{
	level endon("zombies_completed");
	self endon("death");

	if(!( isdefined( level.city_skipped ) && level.city_skipped ))
	{	
		//start zombies spawing after she talks.
		level flag::set("spawn_zombies");

		self thread vo_sarah_between_rounds();
		level thread vo_player_fire_warning();
	}
}

function vo_sarah_between_rounds()
{
	level endon("zombies_completed");
	self endon("death");
	self endon("running_out");

	level waittill( "sarah_speaks_surge" );	

	wait 2; //wait for player to recover from killing last zombie from onslaught
	
	level thread infection_zombies::sarah_flash_kill();

	self scene::play( "cin_inf_16_01_nazizombies_vign_treemoment_talk01", self ); //"the last second surge..."
	self thread scene::play( "cin_inf_16_01_nazizombies_vign_treemoment_gameplay_loop", self );
		
	//start zombie spawning again (final round)
	level flag::set("zombies_final_round");
	level flag::set("spawn_zombies");
}

function vo_player_fire_warning()
{
	//wait till end of round 2
	while( level.round_number < 3)
	{
		level waittill( "end_of_round" );
	}
		
	level dialog::player_say( "plyr_hall_we_can_t_stay_0", 0.0 ); //Hall, we can’t stay here. The fire’s consuming the house! 
	
	
}		

//---- Environmental -------------------------------------------------------------------------------
function random_lightning()
{
	fadetowhite = newhudelem();

	fadetowhite.x = 0;
	fadetowhite.y = 0;
	fadetowhite.alpha = 0;

	fadetowhite.horzAlign = "fullscreen";
	fadetowhite.vertAlign = "fullscreen";
	fadetowhite.foreground = true;
	fadetowhite SetShader( "white", 640, 480 );

// TODO: temp only doing once till proper lightning fx hudelem.
//	while(!level flag::get( "zombies_completed" ))
//	{
		fadetowhite FadeOverTime( 0.2 );
		fadetowhite.alpha = 0.7;
		playsoundatposition( "evt_infection_thunder_special", (0,0,0) );
	
		wait 0.5;
		fadetowhite FadeOverTime( 1.0 );
		fadetowhite.alpha = 0;
		
		wait(randomfloatrange(6, 36));
//	}

	wait 1;
	fadetowhite destroy();

	//TODO: just playing repeated sfx till overlay available.
	while(!level flag::get( "zombies_completed" ))
	{
		playsoundatposition( "evt_infection_thunder_special", (0,0,0) );
		wait(randomfloatrange(6, 36));
	}
	

}

//--------------------------------------------------------------------------------------------------
//		STALINGRAD NUKED
//		20 sec. cinematic
//		camera locked - 1st person
//--------------------------------------------------------------------------------------------------
function stalingrad_nuke_main(str_objective, b_starting)
{
	level notify( "update_billboard" );
	
	if(b_starting)
	{
		util::screen_fade_out( 0, "black" );
			
		//preset init for buildings and tree to be there.
		level clientfield::set("stalingrad_rise_nuke", 1);
		level clientfield::set("stalingrad_tree_init", 1);

		skipto::teleport_players( str_objective, false );
	
		level flag::wait_till( "all_players_spawned" );

		//force house collapses to end.
		level thread scene::skipto_end( "p7_fxanim_cp_infection_house_ceiling_02_bundle" );	
		n_ceilings = 4;
		for( i=0; i < n_ceilings; i++ )
		{
			level clientfield::set("stalingrad_city_ceilings", i );
		}

		wait 6;
		level thread util::screen_fade_in( 0, "black" );
	}
	
	//force players into set low ready, etc.
	array::thread_all(level.players, &infection_util::player_enter_cinematic );
			
	level thread vo_stalingrad_nuke();

	level thread stalingrad_nuke_think();
	
	level waittill( "stalingrad_destroyed" );
	
	level thread skipto::objective_completed("city_nuked");
}
	
function stalingrad_nuke_think()
{
	nuke_pos = struct::get("nuke_fx_pos", "targetname");
	forward = AnglesToForward(nuke_pos.angles);	
	up = (0, 0, 1);
	time_nuke = 4;	
	time_fade = 4.5;

	//roots pull out of house
	level clientfield::set("zombie_root_grow", 0);

	//move tree out past city to nuke position
	level clientfield::set("stalingrad_tree_init", 2);

	//tree reaches position, nuke explosion (can no longer use move notify, on client)
	wait 4;
	level clientfield::set("stalingrad_nuke_fog", 1);

	PlayFX( level._effect["nuke_fx"], nuke_pos.origin, forward, up );

	array::thread_all(level.players, &nuke_earth_quake, ( time_nuke + time_fade ) );

	//play destroys building from nuke. blast wave on client and expoding buildings.
	level clientfield::set("stalingrad_rise_nuke", 2);

	wait time_nuke;
	
	level clientfield::set("stalingrad_nuke_fog", 2);//takes 4 seconds

	//can't get notify back from client, timed to fade just as scene finishes.
 	wait time_fade;
	level thread util::screen_fade_out( 0, "black" );
	wait 2;
		
	level notify("stalingrad_destroyed");
}

function nuke_earth_quake( time )
{
	start_time = GetTime();
	time_passed	= 0;
	scale = 0.1;

	//initial quake on explosion
	self PlayRumbleOnEntity( "tank_damage_heavy_mp" );
	Earthquake( 0.6, 1, self.origin, 100 );

	//buildup as wave approaches
	while( time_passed < time )
	{
		self PlayRumbleOnEntity( "damage_heavy" );
		Earthquake( scale, 1, self.origin, 100 );
		wait 0.25;

		scale = scale + 0.015;	
		time_passed = ( GetTime() - start_time ) / 1000.0;
	}
}

// ----------------------------------------------------------------------------
// DIALOG: Stalingrad Nuke
// ----------------------------------------------------------------------------
function vo_stalingrad_nuke()
{
	level.players[0] dialog::say( "corv_listen_only_to_the_s_1", 1.0 );//Listen only to the sound of my voice.
	level.players[0] dialog::say( "corv_let_your_mind_relax_1", 1.0 );//Let your mind relax.
	level.players[0] dialog::say( "corv_imagine_yourself_in_1", 0.0 );//Imagine yourself in a frozen forest.
}

//---- CLEANUP -------------------------------------------------------------------------------------
function stalingrad_nuke_cleanup(str_objective, b_starting, b_direct, player)
{
	level clientfield::set("stalingrad_nuke_fog", 0);
}	

//--------------------------------------------------------------------------------------------------
//		OUTRO - KEBECHET
//		20 sec. cinematic
//		camera locked - 1st person
//--------------------------------------------------------------------------------------------------
function outro_main(str_objective, b_starting)
{
	level notify( "update_billboard" );

	//init the scene
	scene::add_scene_func("cin_inf_18_outro_3rd_sh060", &outro_scene_done , "done" );
	level thread scene::init( "cin_inf_18_outro_3rd_sh010" );

	skipto::teleport_players( str_objective, false );
	
	level flag::wait_till( "all_players_spawned" );

	util::screen_fade_out( 0, "white" );
	level thread util::screen_fade_in( 2, "white" );	

	//play the scene
	level thread scene::play( "cin_inf_18_outro_3rd_sh010" );
}	

function outro_scene_done( a_ents )
{
	level thread skipto::objective_completed("outro");
}	

//---- CLEANUP -------------------------------------------------------------------------------------
function outro_cleanup(str_objective, b_starting, b_direct, player)
{

}
	