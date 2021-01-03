#using scripts\codescripts\struct;

#using scripts\shared\array_shared;
#using scripts\shared\audio_shared;
#using scripts\shared\callbacks_shared;
#using scripts\shared\clientfield_shared;
#using scripts\shared\filter_shared;
#using scripts\shared\postfx_shared;
#using scripts\shared\scene_shared;
#using scripts\shared\util_shared;

    	   	                                                                                                                         	                                                                                                                                                                                                                                                                                                                                                                    	        	     	             	    	   	                           	                               	                                	                                                              	                                                                                                              	                            	                                     	                                       	                                                               	   	                  	       	                                                    	                   	                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                       	                                                                                        	           	                        	                                            	                                             	                                                   	                                                             	                                                         	                                                                    	                                                                                                                                                                                                    	                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                     	                                                              	                                                          	                                   	                                   	                                                    	                                       
                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                            	                                                                                                                                                                                                                                                                                                                                                                                       

#using scripts\cp\_load;
#using scripts\cp\_util;

#using scripts\cp\cp_mi_cairo_ramses_fx;
#using scripts\cp\cp_mi_cairo_ramses_sound;
#using scripts\cp\cp_mi_cairo_ramses_utility;
#using scripts\shared\vehicles\_quadtank;

                    



function main()
{
	util::set_streamer_hint_function( &force_streamer, 2 );
	init_clientfields();
	
	cp_mi_cairo_ramses_fx::main();
	cp_mi_cairo_ramses_sound::main();
	
	callback::on_localclient_connect( &on_player_connect );
	
	load::main();

	util::waitforclient( 0 );	// This needs to be called after all systems have been registered.
	
	level thread set_foley_context();
	
}

function on_player_connect( localClientNum )
{
	filter::init_filter_ev_interference( self );
}

function init_clientfields()
{
	// Intro IGC
	clientfield::register( "toplayer", "intro_reflection_extracam", 1, 1, "int", &intro_reflection_extracam, !true, !true );
	clientfield::register( "scriptmover", "attach_cam_to_train", 1, 1, "int", &attach_camera_to_train, !true, !true );
	
	// Station Walkthrough
	clientfield::register( "world", "hide_station_miscmodels", 1, 1, "int", &show_hide_staiton_props, !true, !true );
	clientfield::register( "world", "turn_on_rotating_fxanim_fans", 1, 1, "int", &turn_on_rotating_fxanim_fans, !true, !true );
	clientfield::register( "world", "turn_on_rotating_fxanim_lights", 1, 1, "int", &turn_on_rotating_fxanim_lights, !true, !true );
	clientfield::register( "world", "delete_fxanim_fans", 1, 1, "int", &delete_fxanim_fans, !true, !true );
	
	// Nasser Interview
	clientfield::register( "toplayer", "nasser_interview_extra_cam", 1, 1, "int", &nasser_interview_extra_cam, !true, !true );
	
	// Station Battle
	clientfield::register( "world", "ramses_station_lamps", 1, 1, "int", &ramses_station_lamps, !true, !true );
	clientfield::register( "toplayer", "rap_blood_on_player", 1, 1, "counter", &player_rap_blood_postfx, !true, !true );
	
	// Staging Area
	clientfield::register( "world", "staging_area_intro", 1, 1, "int", &staging_area_intro, !true, !true );
	clientfield::register( "toplayer", "filter_ev_interference_toggle", 1, 1, "int", &filter_ev_interference_toggle, !true, !true );
}

function force_streamer( n_zone )
{
	switch ( n_zone )
	{
		case 1:
			ForceStreamBundle( "cin_ram_01_01_enterstation_1st_ride" );
			break;
			

		case 2:
			ForceStreamBundle( "cin_ram_03_01_defend_1st_rapsintro" );
			break;
			
		default:
			//	StreamTextureList( "ramses2_vtol_igc" );
			//	ForceStreamXModel( "Hendricks_foor" );
			break;
	}
}

function turn_on_rotating_fxanim_fans( localClientNum, oldVal, newVal, bNewEnt, bInitialSnap, fieldName, bWasDemoJump )
{
	if( !scene::is_playing( "p7_fxanim_gp_fan_digital_small_bundle" ) )
	{
		level thread scene::play( "p7_fxanim_gp_fan_digital_small_bundle" );
	}
}

function turn_on_rotating_fxanim_lights( localClientNum, oldVal, newVal, bNewEnt, bInitialSnap, fieldName, bWasDemoJump )
{
	if( !scene::is_playing( "p7_fxanim_gp_light_emergency_military_01_bundle" ) )
	{
		level thread scene::play( "p7_fxanim_gp_light_emergency_military_01_bundle" );
	}
}


function delete_fxanim_fans( localClientNum, oldVal, newVal, bNewEnt, bInitialSnap, fieldName, bWasDemoJump )
{
	if( scene::is_active( "p7_fxanim_gp_fan_digital_small_bundle" ) )
	{
		level thread scene::stop( "p7_fxanim_gp_fan_digital_small_bundle", true ); //-- force delete fans in stop call
	}
}

function nasser_interview_extra_cam( localClientNum, oldVal, newVal, bNewEnt, bInitialSnap, fieldName, bWasDemoJump ) // self = player
{
	if( newVal == 1 )
	{
		s_org = struct::get( "nasser_interview_extracam", "targetname" );
		self.e_extracam = spawn( localClientNum, s_org.origin, "script_origin" );
		self.e_extracam.angles = s_org.angles;
	
		// Turn on Extra Cam
		self.e_extracam SetExtraCam( 0 );
		SetDvar( "r_extracam_custom_aspectratio", -1 );
		SetExtraCamActive( localClientNum, 1 );
		playsound( 0, "uin_pip_open", (0,0,0) );
	}
	else
	{
		// Turn off Extra Cam
		SetExtraCamActive( localClientNum, 0 );
		
		if( IsDefined( self.e_extracam ) )
		{
			playsound( 0, "uin_pip_close", (0,0,0) );
			self.e_extracam Delete();
		}
	}
}

function staging_area_intro( localClientNum, oldVal, newVal, bNewEnt, bInitialSnap, fieldName, bWasDemoJump )
{
	if( newVal == 1 ) // 1 is init because 0 can't be set first
	{
		level scene::init( "p7_fxanim_cp_ramses_tarp_gust_01_bundle" );
	}
	else
	{
		level thread scene::play( "p7_fxanim_cp_ramses_tarp_gust_01_bundle" );
		level thread scene::play( "cin_ram_04_01_staging_vign_crowd_highway" );
		level thread scene::play( "cin_ram_04_01_staging_vign_crowd_test" );
		
		wait 4; // TODO: trying various timings
		
		level scene::play( "cin_ram_04_01_staging_vign_crowd_loop" );
	}
}
	
function ramses_station_lamps( localClientNum, oldVal, newVal, bNewEnt, bInitialSnap, fieldName, bWasDemoJump ) 
{
	if ( newVal )
	{
		self scene::play( "ramses_station_lamps", "targetname" );
	}
}

//-- self == train
function attach_camera_to_train( localClientNum, oldVal, newVal, bNewEnt, bInitialSnap, fieldName, bWasDemoJump )
{
	if( newVal == 1 )
	{
		s_org = struct::get( "train_extra_cam", "targetname" );
		self.e_extracam = spawn( localClientNum, s_org.origin, "script_origin" );
		self.e_extracam.angles = s_org.angles;
	
		// Turn on Extra Cam
		self.e_extracam LinkTo( self );
		
		level.e_train_extra_cam = self.e_extracam;
	}
	else
	{
		if( IsDefined( self.e_extracam ) )
		{
			self.e_extracam Delete();
		}
	}
}

function intro_reflection_extracam( localClientNum, oldVal, newVal, bNewEnt, bInitialSnap, fieldName, bWasDemoJump ) // self = player
{
	if( newVal == 1 )
	{
		Assert( isdefined( level.e_train_extra_cam ), "Train extra cam was not created" );
		
		level.e_train_extra_cam SetExtraCam( 0 );
		
		SetExtraCamActive( localClientNum, 1 );
		
		SetDvar( "r_extracam_custom_aspectratio", 0.769 );
	}
	else
	{
		// Turn off Extra Cam
		SetExtraCamActive( localClientNum, 0 );
		SetDvar( "r_extracam_custom_aspectratio", -1 );
		if( IsDefined( level.e_train_extra_cam ) )
		{
			level.e_train_extra_cam Delete();
		}
	}
}

function player_rap_blood_postfx( localClientNum, oldVal, newVal, bNewEnt, bInitialSnap, fieldName, bWasDemoJump )
{	
	setsoundcontext( "foley", "normal" );	
	
	if ( newVal == 1 )
	{
		self thread postfx::PlayPostfxBundle( "pstfx_blood_spatter" );
	}
}

function show_hide_staiton_props( localClientNum, oldVal, newVal, bNewEnt, bInitialSnap, fieldName, bWasDemoJump )
{
	// this grabs all the misc models with targetname = 'station_shells' and hides them
	a_misc_model = FindStaticModelIndexArray( "station_shells" );
	
	if ( newVal == 1 )
	{		
		const MAX_HIDE_PER_CLIENT_FRAME = 25;
		
		foreach ( i, model in a_misc_model )
		{
			HideStaticModel( model );
			
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
			UnhideStaticModel( model );
			
			if ( ( i % MAX_UNHIDE_PER_CLIENT_FRAME ) == 0 )
			{
				{wait(.016);};
			}
		}
	}
}

// Self is a player
// UNDONE: just set the filter so it can be seen in game
function filter_ev_interference_toggle( localClientNum, oldVal, newVal, bNewEnt, bInitialSnap, fieldName, bWasDemoJump )
{
	if( newVal == 0 )
	{
		filter::disable_filter_ev_interference( self, 0 );
	}
	else
	{
		filter::enable_filter_ev_interference( self, 0 );
		filter::set_filter_ev_interference_amount( self, 0, 1 );
	}
}

function set_foley_context()
{
	level waittill ("sndIGC");
	setsoundcontext( "foley", "igc" );	
}