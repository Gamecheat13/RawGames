#using scripts\codescripts\struct;

#using scripts\shared\callbacks_shared;
#using scripts\shared\clientfield_shared;
#using scripts\shared\duplicaterender_mgr;
#using scripts\shared\flag_shared;
#using scripts\shared\flagsys_shared;
#using scripts\shared\system_shared;
#using scripts\shared\util_shared;
#using scripts\shared\visionset_mgr_shared;
#using scripts\shared\audio_shared;
#using scripts\shared\postfx_shared;

    	   	                                                                                                                         	                                                                                                                                                                                                                                                                                                                                                                    	        	     	             	    	   	                           	                               	                                	                                                              	                                                                                                              	                            	                                     	                                       	                                                               	   	                  	       	                                                    	                   	                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                       	                                                                                        	           	                        	                                            	                                             	                                                   	                                                             	                                                         	                                                                    	                                                                                                                                                                                                    	                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                     	                                                              	                                                          	                                   	                                   	                                                    	                                       
                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                            	                                                                                                                                                                                                                                                                                                                                                                                       
                                                                           
        	                               	                    	                                 	                                        	                            	                                                                  	                               



//Time sitrep takes to fade down when pulsed

//Time sitrep takes to fade back up when pulsed






#namespace oed;

function autoexec __init__sytem__() {     system::register("oed",&__init__,undefined,undefined);    }

function __init__()
{
	clientfield::register( "toplayer", "ev_toggle",				1, 1, "int",		&ev_player_toggle,		!true, !true );
	clientfield::register( "toplayer", "sitrep_toggle",			1, 1, "counter",	&sitrep_player_toggle,	!true, !true );
	clientfield::register( "toplayer", "tmode_toggle",			1, 1, "int",		&tmode_player_toggle,	!true, !true );

	clientfield::register( "actor", "thermal_active",			1, 1, "int",		&ent_thermal_callback,	!true, !true );
	clientfield::register( "actor", "sitrep_material",			1, 2, "int",		&ent_material_callback,	!true, !true );
	clientfield::register( "actor",	"force_tmode",				1, 1, "int",		&tmode_force_toggle,	!true, !true );
	clientfield::register( "actor", "tagged",					1, 1, "int",		&tagged_toggle,			!true, !true );

	clientfield::register( "vehicle", "thermal_active",			1, 1, "int",		&ent_thermal_callback,	!true, !true );
	clientfield::register( "vehicle", "sitrep_material",		1, 2, "int",		&ent_material_callback,	!true, !true );

	clientfield::register( "scriptmover", "thermal_active",		1, 1, "int",		&ent_thermal_callback,	!true, !true );
	clientfield::register( "scriptmover", "sitrep_material",	1, 2, "int",		&ent_material_callback,	!true, !true );

	duplicate_render::set_dr_filter_offscreen( "sitrep_keyline", 25, "keyline_active", "keyfill_active", 2, "mc/hud_outline_model_z_white" );
	duplicate_render::set_dr_filter_offscreen( "sitrep_fill", 25, "keyfill_active", "keyline_active", 2, "mc/hud_outline_model_orange_alpha" );
	duplicate_render::set_dr_filter_offscreen( "sitrep_keyfill", 30, "keyline_active,keyfill_active", undefined, 2, "mc/hud_outline_model_orange_calpha" );

	visionset_mgr::register_visionset_info( "tac_mode", 1, 15, undefined, "tac_mode_blue" );

	callback::on_spawned( &on_player_spawned );

	//	Temp Enhanced Vision tuning variables until API is implemented
	SetDvar( "r_thermalRange",			1500 );			//TODO This needs to be replaced by an API call
	SetDvar( "r_thermalLineRange",		1000 );		//TODO This needs to be replaced by an API call
	SetDvar( "r_thermalTargetRange",	2500 );		//TODO This needs to be replaced by an API call
 //	SetDvar( "r_thermalBlur",			OED_THERMAL_BLUR );				//TODO This needs to be replaced by an API call
//	SetDvar( "r_thermalNoise",			OED_THERMAL_NOISE );			//TODO This needs to be replaced by an API call
	SetDvar( "r_thermalLine",			0.1 );	//TODO This needs to be replaced by an API call

	SetDvar( "r_tacScanFx_enable", 0 );
	
	level flag::init( "activate_tmode" );
	level flag::init( "activate_thermal" );
}

function on_player_spawned( localClientNum )
{
	// EV Defaults
	self.b_ev_active = false;

	//Set sitrep defaults
	self oed_sitrepscan_enable( 1 );
	self oed_sitrepscan_setoutline( 1 );
	self oed_sitrepscan_setlinewidth( 1 );
    self oed_sitrepscan_setradius( 1800 );
	self oed_sitrepscan_setfalloff( 0.01 );

	//Setup Tactical Mode
	self tmode_init_ent_shader_materials();
}

//TACTICAL MODE////////////////////////////////////////////////////////////////

function tmode_init_ent_shader_materials()
{
	//TODO: make these material IDs defines
    self Map_Material( 50, "mc/hud_outline_model_z_green" );
    self Map_Material( 51, "mc/hud_outline_model_z_red" );
    self Map_Material( 52, "mc/hud_outline_model_z_orange" );
    self Map_Material( 53, "mc/hud_outline_model_z_white" );

    self Map_Material( 54, "mc/hud_outline_model_z_green_alpha" );
    self Map_Material( 55, "mc/hud_outline_model_red_alpha" );
    self Map_Material( 56, "mc/hud_outline_model_orange_alpha" );
    self Map_Material( 57, "mc/hud_outline_model_white_alpha" );

    self Map_Material( 58, "mc/hud_outline_model_green_calpha" );
    self Map_Material( 59, "mc/hud_outline_model_red_calpha" );
    self Map_Material( 60, "mc/hud_outline_model_orange_calpha" );
    self Map_Material( 61, "mc/hud_outline_model_white_calpha" );
}

// self == player
//
function tmode_set_team_cont( localClientNum )
{
	self endon( "tmode_cancel" );
	self endon( "death" );

	while( true )
	{
		self tmode_refresh_all_ents( localClientNum );
		wait 1;
	}
}

function tmode_refresh_all_ents( localClientNum )
{

	self notify( "tmode_set_team" );
	self endon( "tmode_set_team" );

	// Make sure we're doing this for a local player.

	if( !self islocalplayer() )
	{
		return;
	}

	a_all_entities = GetEntArray( localClientNum );

 	foreach( entity in a_all_entities )
 	{
	    // do not outline non-entities
 		if ( !isdefined( entity ) )
 		{
 			continue;
 		}

		// do not outline myself
	    if ( entity == self )
 		{
 			continue;
 		}

		// do not outline dead entities
		if ( !IsAlive( entity ) )
 		{
 			continue;
 		}

  		// do not outline entities without a team
 		if ( !isdefined( entity.team ) )
		{
	      	continue;
		}



		if ( entity.team == "axis" )
		{
			if ( entity IsAI() || entity IsRobot() )
			{
				if ( IsVisibleByPlayer( entity ) || ( isdefined( entity.b_force_tmode ) && entity.b_force_tmode ) )
				{
				 	entity addduplicaterenderoption( 2, 3, 51 );
				 	entity.tmode_set = true;
				}
				else
				{
			   		entity DisableDuplicateRendering();
	 				entity.tmode_set = false;
				}
			}
		}
   		else if ( entity.team == "allies" )
		{
				if ( entity IsPlayer() )
				{
					entity addduplicaterenderoption( 2, 3, 50 );
	    			entity.tmode_set = true; //-- so we can skip entities later
				}
				else
				{
			    	entity addduplicaterenderoption( 2, 3, 54 );
	    			entity.tmode_set = true;
				}
		}
	}
}

function tmode_remove_all_ents( localClientNum )
{
	// Make sure we're doing this for a local player.
	if( !self islocalplayer() )
	{
		return;
	}

	a_all_entities = GetEntArray( localClientNum );

 	foreach( entity in a_all_entities )
 	{
 		if ( ( isdefined( entity.tmode_set ) && entity.tmode_set ) )
 		{
 			entity DisableDuplicateRendering();
 			entity.tmode_set = false;
 		}
	}
}

/////////////////////////////////////////////////////////////////////////
//Nightvision functions
/////////////////////////////////////////////////////////////////////////
function ev_player_toggle( localClientNum, oldVal, newVal, bNewEnt, bInitialSnap, fieldName, bWasDemoJump )
{
	if(!self isLocalPlayer() )
	{
		return;
	}

	if(!isDefined(self GetLocalClientNumber() ))
	{
		return;
	}
	if ( self GetLocalClientNumber() != localClientNum )
	{
		return;
	}

	if ( IsDemoPlaying() && IsSpectating( localClientNum ) )
	{
		newVal = false;
	}

	self player_toggle_ev( localClientNum, newVal );
}

function player_toggle_ev( lcn, newVal )
{
	self.b_ev_active = newVal;
	if( newVal )
	{
		level flag::set( "activate_thermal" );
		if( isdefined( level.ev_override ) )
		{
			[[ level.ev_override ]]();
		}
		SetDvar( "R_thermalFX_enable", 1);	//TODO This needs to be replaced by an API call
		playsound( lcn, "gdt_oed_on", (0,0,0) );
		audio::playloopat( "gdt_oed_loop", (1,2,3) );
		activate_thermal_ents();
	}
	else
	{
		level flag::clear( "activate_thermal" );
		SetDvar( "R_thermalFX_enable", 0);	//TODO This needs to be replaced by an API call
		playsound( lcn, "gdt_oed_off", (0,0,0) );
		audio::stoploopat( "gdt_oed_loop", (1,2,3) );
		deactivate_thermal_ents();
	}
}


//
//	Callback for activating thermal on an entity
function ent_thermal_callback( localClientNum, oldVal, newVal, bNewEnt, bInitialSnap, fieldName, bWasDemoJump )
{
	self endon( "entityshutdown" );

	level flagsys::wait_till( "duplicaterender_registry_ready" );//Wait for materials to get registered by manager

	Assert( isdefined(self), "Entity trying to add thermal was deleted before the system was ready" );

	if( newVal == 0 )
	{
		self.b_show_thermal = false;
		self duplicate_render::set_entity_thermal( 0 );
	}
	else
	{
		self.b_show_thermal = newVal;

		player = GetLocalPlayer( localClientNum );
		if( ( isdefined( player.b_ev_active ) && player.b_ev_active ) )
		{
			self duplicate_render::set_entity_thermal( 1 );
		}
		else
		{
			self duplicate_render::set_entity_thermal( 0 );
		}
	}
}


//	Show all thermal objects
function activate_thermal_ents()
{
	a_e_thermals = GetEntArray( self GetLocalClientNumber() );
	foreach( entity in a_e_thermals )
	{
		if( ( isdefined( entity.b_show_thermal ) && entity.b_show_thermal ) )//Activate Fill for all thermal objects
		{
			entity duplicate_render::set_entity_thermal( 1 );
		}
	}
}


//	Turn off thermal objects
function deactivate_thermal_ents()
{
	a_e_thermals= GetEntArray( self GetLocalClientNumber() );
	foreach( entity in a_e_thermals )
	{
		if( ( isdefined( entity.b_show_thermal ) && entity.b_show_thermal ) )
		{
			entity duplicate_render::set_entity_thermal( 0 );
		}
	}
}


//
//	Callback for activating structural weakness on an entity
function structural_weakness_callback( localClientNum, oldVal, newVal, bNewEnt, bInitialSnap, fieldName, bWasDemoJump )
{
	self endon( "entityshutdown" );

	level flagsys::wait_till( "duplicaterender_registry_ready" );//Wait for materials to get registered by manager

	Assert( isdefined(self), "Entity trying to add thermal was deleted before the system was ready" );

	if( newVal )
	{
		self duplicate_render::set_item_enemy_equipment( newVal );
	}
}

// Callback on AI actor to force them to draw for players in tmode
function tmode_force_toggle( localClientNum, oldVal, newVal, bNewEnt, bInitialSnap, fieldName, bWasDemoJump )
{
	if( newVal == 1 )
	{
		self.b_force_tmode = true;
	}
	else
	{
		self.b_force_tmode = false;
	}
}

function tagged_toggle( localClientNum, oldVal, newVal, bNewEnt, bInitialSnap, fieldName, bWasDemoJump )
{
	ForceTModeVisible( self, newVal );
}

function tmode_player_toggle( localClientNum, oldVal, newVal, bNewEnt, bInitialSnap, fieldName, bWasDemoJump )
{
	if(!isDefined(self GetLocalClientNumber() ))
	{
		return;
	}
	if ( self GetLocalClientNumber() != localClientNum )
	{
		return;
	}

	if ( IsDemoPlaying() && IsSpectating( localClientNum ) )
	{
		newVal = false;
	}

	self notify( "tmode_cancel" );
	if  ( newVal )
	{
		level flag::set( "activate_tmode" );
		if( isdefined( level.tmode_override ) )
		{
			[[ level.tmode_override ]]();
		}
		SetDvar( "r_tacScanFx_enable", newVal );
		self thread postfx::PlayPostfxBundle( "pstfx_tactical_bootup" );
		self thread tmode_set_team_cont( localClientNum );
		self PlaySound( 0, "uin_tac_mode_on" );
	}
	else
	{
		level flag::clear( "activate_tmode" );
		SetDvar( "r_tacScanFx_enable", newVal );
		self thread postfx::PlayPostfxBundle( "pstfx_tactical_bootup" );
		self thread tmode_remove_all_ents( localClientNum );
		self PlaySound( 0, "uin_tac_mode_off" );
	}
}

/////////////////////////////////////////////////////////////////////////
//Sitrep functions
/////////////////////////////////////////////////////////////////////////
function sitrep_player_toggle( localClientNum, oldVal, newVal, bNewEnt, bInitialSnap, fieldName, bWasDemoJump )
{
	if(!isDefined(self GetLocalClientNumber() ))
	{
		return;
	}
	if ( self GetLocalClientNumber() != localClientNum )
	{
		return;
	}

	if ( IsDemoPlaying() && IsSpectating( localClientNum ) )
	{
		newVal = false;
	}

	self thread player_toggle_sitrep( localClientNum, newVal );
}

function player_toggle_sitrep( lcn, newVal )
{
	self notify( "activate_sitrep" );
	self endon( "activate_sitrep" );

	self.sitrep_active = newVal;

	self oed_sitrepscan_setdesat( newVal );

	if( newVal )
	{
		playsound( lcn, "wpn_sitrep_on", (0,0,0) );
		self oed_sitrepscan_setsolid( 1 );//Sitrep fill, instant on
		activate_keyline();
		self thread fade_sitrep_down_over_time( 4 );
	}
	else
	{
		deactivate_keyline();
	}
}


function ent_material_callback( localClientNum, oldVal, newVal, bNewEnt, bInitialSnap, fieldName, bWasDemoJump )
{
	self endon( "entityshutdown" );
	Assert( isdefined(self), "Entity trying to keyline is not valid" );
	level flagsys::wait_till( "duplicaterender_registry_ready" );//Wait for materials to get registered by manager
	Assert( isdefined(self), "Entity trying to keyline was deleted before the system was ready" );

	if( newVal == 0 )
	{
		self.script_sitrep_id = undefined;
		self duplicate_render::change_dr_flags( undefined, "keyline_active,keyfill_active" );
	}
	else
	{
		self.script_sitrep_id = newVal;

		player = GetLocalPlayer( localClientNum );
		if( ( isdefined( player.sitrep_active ) && player.sitrep_active ) )//Sitrep is already active for this player, activate if keyline or fill object
		{
			switch( self.script_sitrep_id )
			{
				case 2://Fill only
					self duplicate_render::change_dr_flags( "keyfill_active", "keyline_active" );
					break;

				default://Default to keyline fill
					self duplicate_render::change_dr_flags( "keyline_active,keyfill_active", undefined );
					break;
			}
		}
		else//Sitrep is inactive, only activate if keyline object
		{
			switch( newVal )
			{
				case 1://Keyline
					self duplicate_render::change_dr_flags( "keyline_active", "keyfill_active" );
					break;
			}
		}
	}
}

function activate_keyline()
{
	a_keyline = GetEntArray( self GetLocalClientNumber() );
	foreach( entity in a_keyline )
	{
		if( isdefined( entity ) && isdefined( entity.script_sitrep_id ) )//Activate Fill for all sitrep objects
		{
			switch( entity.script_sitrep_id )
			{
					case 2://Fill only
						entity duplicate_render::change_dr_flags( "keyfill_active", "keyline_active" );
						break;

					default://Default to keyline fill
						entity duplicate_render::change_dr_flags( "keyline_active,keyfill_active", undefined );
						break;
			}
		}
	}
}

function deactivate_keyline()
{
	a_keyline = GetEntArray( self GetLocalClientNumber() );
	foreach( entity in a_keyline )
	{
		if( isdefined( entity.script_sitrep_id ) )
		{
			switch( entity.script_sitrep_id )
			{
				case 1://Is a keyline object, needs to change back to keyline only
					entity duplicate_render::change_dr_flags( "keyline_active", "keyfill_active" );
					break;

				default://Is a fill only object, needs to turn off completely
					entity duplicate_render::change_dr_flags( undefined, "keyline_active,keyfill_active" );
					break;
			}
		}
	}

    self thread fade_keyline_up_over_time( .05 );
    //self.sitrep_active = false;
}

function fade_sitrep_down_over_time( n_fade_time )
{
	self endon( "activate_sitrep" );

	n_ticks = n_fade_time / .016;
	n_ticks_left = Int(n_ticks);

	// Change of intensity each frame
	n_intensity_frame_change = 1 / n_ticks_left;

	// Intensity of outline
	n_outline_intensity = 1;

	// Start at 1 and fade out
	while( n_ticks_left > 0 )
	{
		self oed_sitrepscan_setsolid( n_outline_intensity );
		//self oed_sitrepscan_setoutline( n_outline_intensity );
		self oed_sitrepscan_setdesat( n_outline_intensity );
		n_ticks_left--;
		util::server_wait( self GetLocalClientNumber(), .016 );	//TODO - we need a better way to wait by time on the client, GetTime is not supported in coop
		n_outline_intensity -= n_intensity_frame_change;
	}

	self oed_sitrepscan_setsolid( 0 );
	//self oed_sitrepscan_setoutline( 0 );
	self oed_sitrepscan_setdesat( 0 );
	deactivate_keyline();
}

//TODO - keep until we know for sure if we are fading or not
function fade_keyline_up_over_time( n_fade_time )
{
	self endon( "activate_sitrep" );

	{wait(.016);};//give disable a frame to shut down

	n_ticks = n_fade_time / .016;
	n_ticks_left = Int(n_ticks);

	// Change of intensity each frame
	n_intensity_frame_change = 1 / n_ticks_left;

	// Intensity of outline
	n_outline_intensity = 0;

	// Only fade outline to 1
	n_outline_intensity += n_intensity_frame_change;

	n_ramp_up_speed = 1.2 * n_intensity_frame_change;	// try larger e.g. 2 for smoother look
  	while( n_outline_intensity < 1 )
	{
	  	//self oed_sitrepscan_setoutline( n_outline_intensity );
		self oed_sitrepscan_setsolid( n_outline_intensity );
	 	util::server_wait( self GetLocalClientNumber(), .016 );//TODO - we need a better way to wait by time on the client, GetTime is not supported in coop
	  	n_outline_intensity += n_ramp_up_speed;
	}

 	//self oed_sitrepscan_setoutline( 1 );
 	self oed_sitrepscan_setsolid( 1 );
 	self.sitrep_active = false;
}
