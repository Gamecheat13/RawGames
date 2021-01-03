#using scripts\codescripts\struct;

#using scripts\shared\array_shared;
#using scripts\shared\beam_shared;
#using scripts\shared\clientfield_shared;
#using scripts\shared\util_shared;
#using scripts\shared\scene_shared;
#using scripts\shared\postfx_shared;

    	   	                                                                                                                         	                                                                                                                                                                                                                                                                                                                                                                    	        	     	             	    	   	                           	                               	                                	                                                              	                                                                                                              	                            	                                     	                                       	                                                               	   	                  	       	                                                    	                   	                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                       	                                                                                        	           	                        	                                            	                                             	                                                   	                                                             	                                                         	                                                                    	                                                                                                                                                                                                    	                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                     	                                                              	                                                          	                                   	                                   	                                                    	                                       
                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                            	                                                                                                                                                                                                                                                                                                                                                                                       

#using scripts\cp\_load;
#using scripts\cp\_util;

#using scripts\cp\cp_mi_cairo_ramses_arena_defend;
#using scripts\cp\cp_mi_cairo_ramses2_fx;
#using scripts\cp\cp_mi_cairo_ramses2_sound;
#using scripts\cp\cp_mi_cairo_ramses_utility;
#using scripts\shared\vehicles\_quadtank;

                      

function main()
{
	util::set_streamer_hint_function( &force_streamer, 4 );
	
	init_clientfields();
	
	// These Fxanims have different setups and tag names, so we need different functions to do the beams
	scene::add_scene_func( "p7_fxanim_cp_ramses_lotus_towers_hunters_01_bundle", &dead_system_laser1, "play" );
	scene::add_scene_func( "p7_fxanim_cp_ramses_lotus_towers_hunters_02_bundle", &dead_system_laser2, "play" );
	scene::add_scene_func( "p7_fxanim_cp_ramses_lotus_towers_hunters_02_bundle", &dead_system_laser2b, "play" );
	scene::add_scene_func( "p7_fxanim_cp_ramses_lotus_towers_hunters_03_bundle", &dead_system_laser3, "play" );
	scene::add_scene_func( "p7_fxanim_cp_ramses_lotus_towers_hunters_04_bundle", &dead_system_laser4, "play" );
	scene::add_scene_func( "p7_fxanim_cp_ramses_lotus_towers_hunters_05_bundle", &dead_system_laser5, "play" );
	
	scene::add_scene_func( "p7_fxanim_cp_ramses_lotus_towers_hunters_06_bundle", &dead_system_laser6, "play" );
	scene::add_scene_func( "p7_fxanim_cp_ramses_lotus_towers_hunters_07_bundle", &dead_system_laser7, "play" );
	scene::add_scene_func( "p7_fxanim_cp_ramses_lotus_towers_hunters_08_bundle", &dead_system_laser8, "play" );
	scene::add_scene_func( "p7_fxanim_cp_ramses_lotus_towers_hunters_09_bundle", &dead_system_laser9, "play" );
	
	scene::add_scene_func( "p7_fxanim_cp_ramses_qt_plaza_palace_wall_collapse_bundle", &qt2_intro_dead_beams, "play" );
	
	scene::add_scene_func( "p7_fxanim_cp_ramses_lotus_towers_hunters_07_vtol_igc_bundle", &dead_system_laser_vtol_igc, "play" );
	
	cp_mi_cairo_ramses2_fx::main();
	cp_mi_cairo_ramses2_sound::main();
	
	load::main();

	util::waitforclient( 0 );	// This needs to be called after all systems have been registered.
}

function init_clientfields()
{
	// To Player
	clientfield::register( "toplayer", "player_spike_plant_postfx", 1, 1, "counter", &player_spike_plant_postfx, !true, !true );

	// World
	clientfield::register( "world", "arena_defend_fxanim_hunters", 1, 1, "int", &arena_defend_fxanim_hunters, !true, !true );	
	clientfield::register( "world", "alley_fxanim_hunters", 1, 1, "int", &alley_fxanim_hunters, !true, !true );	
	clientfield::register( "world", "vtol_igc_fxanim_hunter", 1, 1, "int", &vtol_igc_fxanim_hunters, !true, !true );
	clientfield::register( "world", "qt_plaza_fxanim_hunters", 1, 1, "int", &qt_plaza_fxanim_hunters, !true, !true );
	clientfield::register( "world", "theater_fxanim_swap", 1, 1, "int", &theater_fxanim_swap, !true, !true );
	clientfield::register( "world", "qt_plaza_outro_exposure", 1, 1, "int", &set_exposure_for_qt_plaza_outro, !true, !true );
	clientfield::register( "world", "arena_defend_mobile_wall_damage", 1, 1, "int", &miscmodel_mobile_wall_damage, !true, !true );
}

function force_streamer( n_zone )
{
	switch ( n_zone )
	{
		case 1:
		
			ForceStreamBundle( "cin_ram_05_01_block_1st_rip" );
			
//			StreamTextureList( "ramses2_vtol_igc" );
//			ForceStreamXModel( "Hendricks_foor" );
			break;
		
		case 2:
			ForceStreamBundle( "cin_ram_05_demostreet_3rd_sh010" );
			ForceStreamBundle( "cin_ram_05_demostreet_3rd_sh010_female" );
			ForceStreamBundle( "cin_ram_05_demostreet_3rd_sh020" );
			ForceStreamBundle( "cin_ram_05_demostreet_3rd_sh020_female" );
			ForceStreamBundle( "cin_ram_05_demostreet_3rd_sh030" );
			ForceStreamBundle( "cin_ram_05_demostreet_3rd_sh030_female" );
			ForceStreamBundle( "cin_ram_05_demostreet_3rd_sh040" );
			ForceStreamBundle( "cin_ram_05_demostreet_3rd_sh040_female" );
			ForceStreamBundle( "cin_ram_05_demostreet_3rd_sh050" );
			ForceStreamBundle( "cin_ram_05_demostreet_3rd_sh050_female" );
			ForceStreamBundle( "cin_ram_05_demostreet_3rd_sh060" );
			ForceStreamBundle( "cin_ram_05_demostreet_3rd_sh060_female" );
			ForceStreamBundle( "cin_ram_05_demostreet_3rd_sh070" );
			ForceStreamBundle( "cin_ram_05_demostreet_3rd_sh070_female" );
			ForceStreamBundle( "cin_ram_05_demostreet_3rd_sh080" );
			ForceStreamBundle( "cin_ram_05_demostreet_3rd_sh080_female" );
			ForceStreamBundle( "cin_ram_05_demostreet_3rd_sh090" );
			ForceStreamBundle( "cin_ram_05_demostreet_3rd_sh090_female" );
			ForceStreamBundle( "cin_ram_05_demostreet_3rd_sh100" );
			ForceStreamBundle( "cin_ram_05_demostreet_3rd_sh100_female" );
			ForceStreamBundle( "cin_ram_05_demostreet_3rd_sh110" );
			ForceStreamBundle( "cin_ram_05_demostreet_3rd_sh110_female" );
			ForceStreamBundle( "cin_ram_05_demostreet_3rd_sh120" );
			ForceStreamBundle( "cin_ram_05_demostreet_3rd_sh130" );
			ForceStreamBundle( "cin_ram_05_demostreet_3rd_sh130_female" );
			ForceStreamBundle( "cin_ram_05_demostreet_3rd_sh140" );
			break;
		
		case 3:
			ForceStreamXModel( "c_ega_vitol_pilot_1_fb" );
			ForceStreamMaterial( "mc/mtl_veh_t7_vtol_egypt_body_d0_glass" );
			break;
		
		case 4:
			ForceStreamBundle( "cin_ram_08_gettofreeway_3rd_sh010" );
			ForceStreamBundle( "cin_ram_08_gettofreeway_3rd_sh020" );
			ForceStreamBundle( "cin_ram_08_gettofreeway_3rd_sh030" );
			ForceStreamBundle( "cin_ram_08_gettofreeway_3rd_sh040" );
			break;
	}
}

/***********************************
 * FXANIM HUNTERS
 * ********************************/
 
// TODO: we don't want the beams to be active for the whole animation
// but a bug with self notify notetracks is preventing us from timing these
// out in notetracks right now.  Update when that's fixed.  Also, call beam::kill
// to kill the beam.

///////////////////////////////////

function dead_system_laser1( a_ents )
{
	a_ents[ "hunter" ] waittillmatch( "_anim_notify_", "hunter01_hit_by_dead" );
	
	level beam::launch( a_ents[ "hunter" ], "tag_fx_jnt", a_ents[ "hunter" ], "drone_01_link_jnt", "dead_turret_beam" );
	
	a_ents[ "hunter" ] waittillmatch( "_anim_notify_", "hunter01_explodes" );
	
	level beam::kill( a_ents[ "hunter" ], "tag_fx_jnt", a_ents[ "hunter" ], "drone_01_link_jnt", "dead_turret_beam" );
}

function dead_system_laser2( a_ents )
{
	a_ents[ "hunter" ] waittillmatch( "_anim_notify_", "hunter02_hit_by_dead" );
	
	level beam::launch( a_ents[ "hunter" ], "tag_fx_jnt", a_ents[ "hunter" ], "drone_02_link_jnt", "dead_turret_beam" );
	
	a_ents[ "hunter" ] waittillmatch( "_anim_notify_", "hutner02_explodes" );
	
	level beam::kill( a_ents[ "hunter" ], "tag_fx_jnt", a_ents[ "hunter" ], "drone_02_link_jnt", "dead_turret_beam" );
}

function dead_system_laser2b( a_ents )
{
	a_ents[ "hunter" ] waittillmatch( "_anim_notify_", "hunter02_b_hit_by_dead" );
	
	level beam::launch( a_ents[ "hunter" ], "tag_fx_b_jnt", a_ents[ "hunter" ], "drone_02_b_link_jnt", "dead_turret_beam" );
	
	a_ents[ "hunter" ] waittillmatch( "_anim_notify_", "hunter02_b_explodes" );
	
	level beam::kill( a_ents[ "hunter" ], "tag_fx_b_jnt", a_ents[ "hunter" ], "drone_02_b_link_jnt", "dead_turret_beam" );
}

function dead_system_laser3( a_ents )
{
	a_ents[ "hunter" ] waittillmatch( "_anim_notify_", "hunter03_hit_by_dead" );
	
	level beam::launch( a_ents[ "hunter" ], "tag_fx_jnt", a_ents[ "hunter" ], "drone_03_link_jnt", "dead_turret_beam" );
	
	a_ents[ "hunter" ] waittillmatch( "_anim_notify_", "hunter03_explodes" );
	
	level beam::kill( a_ents[ "hunter" ], "tag_fx_jnt", a_ents[ "hunter" ], "drone_03_link_jnt", "dead_turret_beam" );
}

function dead_system_laser4( a_ents )
{
	a_ents[ "hunter" ] waittillmatch( "_anim_notify_", "hunter04_hit_by_dead" );
	
	level beam::launch( a_ents[ "hunter" ], "tag_fx_jnt", a_ents[ "hunter" ], "drone_04_link_jnt", "dead_turret_beam" );
	
	a_ents[ "hunter" ] waittillmatch( "_anim_notify_", "hunter04_explodes" );
	
	level beam::kill( a_ents[ "hunter" ], "tag_fx_jnt", a_ents[ "hunter" ], "drone_04_link_jnt", "dead_turret_beam" );
}

function dead_system_laser5( a_ents )
{
	a_ents[ "hunter" ] waittillmatch( "_anim_notify_", "hunter05_hit_by_dead" );
	
	level beam::launch( a_ents[ "hunter" ], "tag_fx_jnt", a_ents[ "hunter" ], "drone_05_link_jnt", "dead_turret_beam" );
	
	a_ents[ "hunter" ] waittillmatch( "_anim_notify_", "hunter05_explodes" );
	
	level beam::kill( a_ents[ "hunter" ], "tag_fx_jnt", a_ents[ "hunter" ], "drone_05_link_jnt", "dead_turret_beam" );
}

function dead_system_laser9( a_ents )
{
	a_ents[ "hunter" ] waittillmatch( "_anim_notify_", "hunter_hit_by_dead" );
	
	level beam::launch( a_ents[ "hunter" ], "tag_fx_jnt", a_ents[ "hunter" ], "tag_body", "dead_turret_beam" );
	
	a_ents[ "hunter" ] waittillmatch( "_anim_notify_", "hunter_explodes" );
	
	level beam::kill( a_ents[ "hunter" ], "tag_fx_jnt", a_ents[ "hunter" ], "tag_body", "dead_turret_beam" );
}

/////////////////////////////////////

function dead_system_laser6( a_ents )
{
	a_ents[ "turret" ] waittillmatch( "_anim_notify_", "hunter06_hit_by_dead" );
	
	level beam::launch( a_ents[ "turret" ], "tag_fx_01_jnt", a_ents[ "hunter" ], "tag_body", "dead_turret_beam" );
	
	a_ents[ "turret" ] waittillmatch( "_anim_notify_", "hunter06_explodes" );
	
	level beam::kill( a_ents[ "turret" ], "tag_fx_01_jnt", a_ents[ "hunter" ], "tag_body", "dead_turret_beam" );
}

function dead_system_laser7( a_ents )
{
	a_ents[ "turret" ] waittillmatch( "_anim_notify_", "hunter07_hit_by_dead" );
	
	level beam::launch( a_ents[ "turret" ], "tag_fx_01_jnt", a_ents[ "hunter" ], "tag_body", "dead_turret_beam" );
	
	a_ents[ "turret" ] waittillmatch( "_anim_notify_", "hunter07_explodes" );
	
	level beam::kill( a_ents[ "turret" ], "tag_fx_01_jnt", a_ents[ "hunter" ], "tag_body", "dead_turret_beam" );
}

function dead_system_laser8( a_ents )
{
	a_ents[ "turret" ] waittillmatch( "_anim_notify_", "hunter08_hit_by_dead" );
	
	level beam::launch( a_ents[ "turret" ], "tag_fx_01_jnt", a_ents[ "hunter" ], "tag_body", "dead_turret_beam" );
	
	a_ents[ "turret" ] waittillmatch( "_anim_notify_", "hunter08_explodes" );
	
	level beam::kill( a_ents[ "turret" ], "tag_fx_01_jnt", a_ents[ "hunter" ], "tag_body", "dead_turret_beam" );
}

//////////////////////////////////////

function qt2_intro_dead_beams( a_ents )
{
	e_vtol = a_ents[ "qt_plaza_palace_wall_vtol" ];

	a_ents[ "turret_palace_wall_collapse" ] waittillmatch( "_anim_notify_", "vtol_hit_by_dead" );
	
	level beam::launch( a_ents[ "turret_palace_wall_collapse" ], "tag_fx_01_jnt", e_vtol, "tag_origin", "dead_turret_beam" );
	
	a_ents[ "turret_palace_wall_collapse" ] waittillmatch( "_anim_notify_", "vtol_explodes" );
	
	level beam::kill( a_ents[ "turret_palace_wall_collapse" ], "tag_fx_01_jnt", e_vtol, "tag_origin", "dead_turret_beam" );
}	

//////////////////////////////////////

function dead_system_laser_vtol_igc( a_ents )
{
	a_ents[ "turret_vtol_igc" ] waittillmatch( "_anim_notify_", "hunter07_vtol_igc_hit_by_dead" );
	
	level beam::launch( a_ents[ "turret_vtol_igc" ], "tag_fx_01_jnt", a_ents[ "hunter" ], "tag_body", "dead_turret_beam" );
	
	a_ents[ "turret_vtol_igc" ] waittillmatch( "_anim_notify_", "hunter07_vtol_igc_explodes" );
	
	level beam::kill( a_ents[ "turret_vtol_igc" ], "tag_fx_01_jnt", a_ents[ "hunter" ], "tag_body", "dead_turret_beam" );
}

//////////////////////////////////////

function arena_defend_fxanim_hunters( localClientNum, oldVal, newVal, bNewEnt, bInitialSnap, fieldName, bWasDemoJump )
{
	if( newVal == 1 )
	{
		level thread play_arena_defend_fx_anim_hunters();
	}
	else
	{
		level notify( "stop_arena_defend_fxanim_hunters" );
	}
}

function play_arena_defend_fx_anim_hunters()
{
	level endon( "stop_arena_defend_fxanim_hunters" );
	
	level thread hunters_peel_off();
		
	while( 1 )
	{
		wait( RandomFloatRange( 1.0, 3.0 ) );
		
		while( 1 )
		{
			n_fxanim = RandomIntRange( 1, 6 );

			if( !scene::is_playing( "p7_fxanim_cp_ramses_lotus_towers_hunters_0" + n_fxanim + "_bundle" ) )
			{
				break;	
			}
			
			wait 0.1;			
		}
		
		level thread scene::play( "p7_fxanim_cp_ramses_lotus_towers_hunters_0" + n_fxanim + "_bundle" );
	}	
}

function hunters_peel_off()
{
	level endon( "stop_arena_defend_fxanim_hunters" );
	
	while( 1 )
	{
		wait( RandomFloatRange( 1.0, 3.0 ) );
		
		while( 1 )
		{
			n_fxanim = RandomIntRange( 1, 5 );

			if( n_fxanim == 4 )
			{
				if( !scene::is_playing( "p7_fxanim_cp_ramses_lotus_towers_hunters_peel_off_01_bundle" ) && !scene::is_playing( "p7_fxanim_cp_ramses_lotus_towers_hunters_peel_off_02_bundle" ) )
				{
					break;	
				}
			}
			else if( !scene::is_playing( "p7_fxanim_cp_ramses_lotus_towers_hunters_peel_off_0" + n_fxanim + "_bundle" ) )
			{
				break;	
			}
			
			wait 0.05;			
		}
		
		if( n_fxanim == 4 )
		{
			level thread scene::play( "p7_fxanim_cp_ramses_lotus_towers_hunters_peel_off_01_bundle" );	
			scene::play( "p7_fxanim_cp_ramses_lotus_towers_hunters_peel_off_02_bundle" );	
		}
		else
		{
			scene::play( "p7_fxanim_cp_ramses_lotus_towers_hunters_0" + n_fxanim + "_bundle" );	
		}
	}	
}

function alley_fxanim_hunters( localClientNum, oldVal, newVal, bNewEnt, bInitialSnap, fieldName, bWasDemoJump )
{
	if( newVal == 1 )
	{
		level thread play_alley_fx_anim_hunters();
	}
	else
	{
		level notify( "stop_alley_fxanim_hunters" );
	}
}

function play_alley_fx_anim_hunters()
{
	level endon( "stop_alley_fxanim_hunters" );
		
	while( 1 )
	{
		wait( RandomFloatRange( 5.0, 10.0 ) );
		
		while( 1 )
		{
			n_fxanim = RandomIntRange( 6, 9 );

			if( !scene::is_playing( "p7_fxanim_cp_ramses_lotus_towers_hunters_0" + n_fxanim + "_bundle" ) )
			{
				break;	
			}
			
			wait 0.1;			
		}
		
		level thread scene::play( "p7_fxanim_cp_ramses_lotus_towers_hunters_0" + n_fxanim + "_bundle" );
	}
}

function vtol_igc_fxanim_hunters( localClientNum, oldVal, newVal, bNewEnt, bInitialSnap, fieldName, bWasDemoJump )
{
	if( newVal == 1 )
	{
		s_fxanim = struct::get( "vtol_igc_fxanim_hunter", "targetname" );
		
		s_fxanim scene::play();
		
		s_fxanim scene::stop( true );
	}
}

function qt_plaza_fxanim_hunters( localClientNum, oldVal, newVal, bNewEnt, bInitialSnap, fieldName, bWasDemoJump )
{
	if( newVal == 1 )
	{
		level thread play_qt_plaza_fx_anim_hunters();
	}
	else
	{
		level notify( "stop_qt_plaza_fxanim_hunters" );
	}
}

function play_qt_plaza_fx_anim_hunters()
{
	level endon( "stop_qt_plaza_fxanim_hunters" );
	
	a_s_fxanim = struct::get_array( "qt_plaza_hunters", "targetname" );

	while( 1 )
	{
		wait( RandomFloatRange( 5.0, 10.0 ) );
		
		while( 1 )
		{
			s_fxanim = array::random( a_s_fxanim );
			
			if( !s_fxanim scene::is_playing() )
			{
				break;				
			}
			
			wait 0.05;
		}
		
		s_fxanim scene::play();
	}	
}

function theater_fxanim_swap( localClientNum, oldVal, newVal, bNewEnt, bInitialSnap, fieldName, bWasDemoJump )
{
	// this grabs all the misc models with targetname = 'destroyed_interior' and hides them
	a_misc_model = FindStaticModelIndexArray( "destroyed_interior" );
	
	if ( newVal == 1 )
	{		
		const MAX_HIDE_PER_CLIENT_FRAME = 25;
		
		foreach ( i, model in a_misc_model )
		{
			HideStaticModel( model );
			
			if ( ( i % MAX_HIDE_PER_CLIENT_FRAME ) == 0 )  // stagger this for performance; this is hidden during a third person IGC
			{
				{wait(.016);};
			}
		}
	}
	else 
	{
		foreach ( model in a_misc_model )
		{
			UnhideStaticModel( model );
		}		
	}
}

//plays dust in player's face when they plant the spike launchers
function player_spike_plant_postfx( localClientNum, oldVal, newVal, bNewEnt, bInitialSnap, fieldName, bWasDemoJump )
{		
	if ( newVal == 1 )
	{
		self thread postfx::PlayPostfxBundle( "pstfx_dust_chalk" );
		self thread postfx::PlayPostfxBundle( "pstfx_dust_concrete" );
	}
	else
	{
		self thread postfx::StopPostfxBundle();
	}
}

function set_exposure_for_qt_plaza_outro( localClientNum, oldVal, newVal, bNewEnt, bInitialSnap, fieldName, bWasDemoJump )
{
	if ( newVal == 1 )
	{
		SetExposureActiveBank( localClientNum, 2 );
	}
}

function miscmodel_mobile_wall_damage( localClientNum, oldVal, newVal, bNewEnt, bInitialSnap, fieldName, bWasDemoJump )
{
	// this grabs all the misc models with targetname = 'destroyed_interior' and hides them
	a_misc_model = FindStaticModelIndexArray( "mobile_wall_sidewalk_smash_after" );
	
	if ( newVal == 1 )
	{		
		const MAX_HIDE_PER_CLIENT_FRAME = 25;
		
		foreach ( i, model in a_misc_model )
		{
			HideStaticModel( model );
			
			if ( ( i % MAX_HIDE_PER_CLIENT_FRAME ) == 0 )  // stagger this for performance; this is hidden during a third person IGC
			{
				{wait(.016);};
			}
		}
	}
	else 
	{
		foreach ( model in a_misc_model )
		{
			UnhideStaticModel( model );
		}		
	}
}

