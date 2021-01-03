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







	


// Distance at which interact object names are shown.


#namespace oed;

function autoexec __init__sytem__() {     system::register("oed",&__init__,undefined,undefined);    }

function __init__()
{
	clientfield::register( "toplayer", "ev_toggle",				1, 1, "int",		&ev_player_toggle,		!true, !true );
	clientfield::register( "toplayer", "sitrep_toggle",			1, 1, "int",		&sitrep_player_toggle,	!true, !true );
	clientfield::register( "toplayer", "tmode_toggle",			1, 1, "int",		&tmode_player_toggle,	!true, !true );
	clientfield::register( "toplayer", "active_dni_fx",			1, 1, "counter",	&active_DNI_bootup_fx,	!true, !true );

	clientfield::register( "actor", "thermal_active",			1, 1, "int",		&ent_thermal_callback,	!true, !true );
	clientfield::register( "actor", "sitrep_material",			1, 1, "int",		&ent_material_callback,	!true, !true );
	clientfield::register( "actor",	"force_tmode",				1, 1, "int",		&tmode_force_toggle,	!true, !true );
	clientfield::register( "actor", "tagged",					1, 1, "int",		&tagged_toggle,			!true, !true );

	clientfield::register( "vehicle", "thermal_active",			1, 1, "int",		&ent_thermal_callback,	!true, !true );
	clientfield::register( "vehicle", "sitrep_material",		1, 1, "int",		&ent_material_callback,	!true, !true );

	clientfield::register( "scriptmover", "thermal_active",		1, 1, "int",		&ent_thermal_callback,	!true, !true );
	clientfield::register( "scriptmover", "sitrep_material",	1, 1, "int",		&ent_material_callback,	!true, !true );
	
	clientfield::register( "item", "sitrep_material",			1, 1, "int",		&ent_material_callback,	!true, !true );

	duplicate_render::set_dr_filter_offscreen( "sitrep_keyline", 25, "keyline_active", "keyfill_active", 2, "mc/hud_outline_model_z_white", 0 );
	duplicate_render::set_dr_filter_offscreen( "sitrep_fill", 25, "keyfill_active", "keyline_active", 2, "mc/hud_outline_model_orange_alpha", 0 );
	duplicate_render::set_dr_filter_offscreen( "sitrep_keyfill", 30, "keyline_active,keyfill_active", undefined, 2, "mc/hud_outline_model_orange_calpha", 0 );
	duplicate_render::set_dr_filter_offscreen( "enemy_thermal", 24, "thermal_enemy_active", undefined, 2, "mc/hud_outline_model_z_red", 0 );
	duplicate_render::set_dr_filter_offscreen( "friendly_thermal", 24, "thermal_friendly_active", undefined, 2, "mc/hud_outline_model_z_green", 0 );

	visionset_mgr::register_visionset_info( "tac_mode", 1, 15, undefined, "tac_mode_blue" );

	callback::on_spawned( &on_player_spawned );

	/*EV Dvars have now been replaced, please use EVSetRanges()
	 * r_thermalRange
	 * r_thermalLineRange
	 * r_thermalTargetRange
	 * r_thermalLine
	 * */
	
	level flag::init( "activate_tmode" );
	level flag::init( "activate_thermal" );
}

function on_player_spawned( localClientNum )
{
	// EV Defaults
	self.b_ev_active = false;
	n_ev_geo_range = 10500;
	n_ev_target_range = 3000;
	if( isdefined( level.n_override_ev_geo_range ) )
	{
		n_ev_geo_range = level.n_override_ev_geo_range;
	}
	if( isdefined( level.n_override_ev_target_range ) )
	{
		n_ev_target_range = level.n_override_ev_target_range;
	}
	EVSetRanges( localClientNum, n_ev_geo_range, n_ev_target_range );

	//Set sitrep defaults
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
}

// self == player//TODO - let's make sure none of this is needed and delete on the next pass
//
//function tmode_set_team_cont( localClientNum )
//{
//	self endon( "tmode_cancel" );
//	self endon( "death" );
//	self endon( "entityshutdown" );
//
//	while( true )
//	{
//		self tmode_refresh_all_ents( localClientNum );
//		wait 1;
//	}
//}

//function tmode_refresh_all_ents( localClientNum )
//{
//	// Make sure we're doing this for a local player.
//
//	if ( !isdefined( self ) )
//	{
//		return;
//	}
//
//	if ( !self IsLocalPlayer() )
//	{
//		return;
//	}
//	
//	self notify( "tmode_set_team" );
//	self endon( "tmode_set_team" );
//
//	a_all_entities = GetEntArray( localClientNum );
//
// 	foreach ( entity in a_all_entities )
// 	{
//	    // do not outline non-entities
// 		if ( !isdefined( entity ) )
// 		{
// 			continue;
// 		}
//
//		// do not outline myself
//	    if ( entity == self )
// 		{
// 			continue;
// 		}
//
//		// do not outline dead entities
//		if ( !IsAlive( entity ) )
// 		{
// 			continue;
// 		}
//
//  		// do not outline entities without a team
// 		if ( !isdefined( entity.team ) )
//		{
//	      	continue;
//		}
//
//		if ( entity.team == "axis" )
//		{
//			if ( entity IsAI() || entity IsRobot() )
//			{
//				if ( IsVisibleByPlayer( entity ) || IS_TRUE( entity.b_force_tmode ) )
//				{
//				 	entity addduplicaterenderoption( DR_TYPE_OFFSCREEN, DR_METHOD_CUSTOM_MATERIAL, 51 );
//				 	entity.tmode_set = true;
//				}
//				else
//				{
//			   		entity DisableDuplicateRendering();
//	 				entity.tmode_set = false;
//				}
//			}
//		}
//   		else if ( entity.team == "allies" )
//		{
//			if ( entity IsPlayer() )
//			{
//				entity addduplicaterenderoption( DR_TYPE_OFFSCREEN, DR_METHOD_CUSTOM_MATERIAL, 50 );
//				entity.tmode_set = true; //-- so we can skip entities later
//			}
//			else
//			{
//				entity addduplicaterenderoption( DR_TYPE_OFFSCREEN, DR_METHOD_CUSTOM_MATERIAL, 54 );
//				entity.tmode_set = true;
//			}
//		}
//	}
//}

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
 			//entity DisableDuplicateRendering();
 			entity.tmode_set = false;
 			entity TModeClearFlag( 4 );
 		}
	}
}

/////////////////////////////////////////////////////////////////////////
//Enhanced Vision (EV) functions
/////////////////////////////////////////////////////////////////////////
function ev_player_toggle( localClientNum, oldVal, newVal, bNewEnt, bInitialSnap, fieldName, bWasDemoJump )
{
	if ( !self isLocalPlayer() )
	{
		return;
	}

	if ( !isDefined( self GetLocalClientNumber() ) )
	{
		return;
	}
	
	if ( self GetLocalClientNumber() != localClientNum )
	{
		return;
	}
	
	if ( level flagsys::get( "menu_open" ) )
	{
		return;
	}

	if ( IsDemoPlaying() && IsSpectating( localClientNum ) )
	{
		newVal = false;
	}

	self player_toggle_ev( localClientNum, newVal );
}

function ev_force_off( localClientNum )
{
   	audio::stoploopat( "gdt_oed_loop", (1,2,3) );
  	deactivate_thermal_ents();
  	{wait(.016);};//Give ents time to deactivate
  	GadgetSetInfrared( localClientNum, 0 );
  	level flag::clear( "activate_thermal" );
}

function tmode_force_off( localClientNum )
{
	self tmodeEnable(0);
	self thread tmode_remove_all_ents( localClientNum );
 	{wait(.016);};//Give ents time to deactivate
	level flag::clear( "activate_tmode" );
}


function player_toggle_ev( lcn, newVal )
{
	self.b_ev_active = newVal;

	if( newVal )
	{
		tmode_force_off( lcn );
		GadgetSetInfrared( lcn, newVal );
		level flag::set( "activate_thermal" );
		if( isdefined( level.ev_override ) )
		{
			[[ level.ev_override ]]();
		}
		playsound( lcn, "gdt_oed_on", (0,0,0) );
		audio::playloopat( "gdt_oed_loop", (1,2,3) );
		activate_thermal_ents();
	}
	else
	{
		playsound( lcn, "gdt_oed_off", (0,0,0) );
		audio::stoploopat( "gdt_oed_loop", (1,2,3) );
		deactivate_thermal_ents();
		{wait(.016);};//Give ents time to deactivate
		GadgetSetInfrared( lcn, newVal );
		level flag::clear( "activate_thermal" );
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
		self set_entity_thermal( false );
	}
	else
	{
		self.b_show_thermal = newVal;

		player = GetLocalPlayer( localClientNum );
		if( ( isdefined( player.b_ev_active ) && player.b_ev_active ) )
		{
			self set_entity_thermal( true );
		}
		else
		{
			self set_entity_thermal( false );
		}
	}
}

function set_entity_thermal( b_enabled )
{	
	if( self.team == "allies" )
	{
		self duplicate_render::set_dr_flag( "thermal_friendly_active", b_enabled );
		n_index = 6;
	}
	else
	{
		self duplicate_render::set_dr_flag( "thermal_enemy_active", b_enabled );
		n_index = 5;		
	}
	
	if( b_enabled )
	{
		self TModeSetFlag( n_index );
	}
	else
	{
		self TModeClearFlag( n_index );
	}
	
	self duplicate_render::update_dr_filters();
}

//	Show all thermal objects
function activate_thermal_ents()
{
	a_e_thermals = GetEntArray( self GetLocalClientNumber() );
	foreach( entity in a_e_thermals )
	{
		if( ( isdefined( entity.b_show_thermal ) && entity.b_show_thermal ) )//Activate Fill for all thermal objects
		{
			entity set_entity_thermal( true );
		}
	}
}

//	Turn off thermal objects
function deactivate_thermal_ents()
{
	a_e_thermals = GetEntArray( self GetLocalClientNumber() );
	foreach( entity in a_e_thermals )
	{
		if( ( isdefined( entity.b_show_thermal ) && entity.b_show_thermal ) )
		{
			entity set_entity_thermal( false );
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
		self TmodeSetFlag( 1 );
	}
	else
	{
		self.b_force_tmode = false;
		self TmodeClearFlag( 1 );
	}
}

function tagged_toggle( localClientNum, oldVal, newVal, bNewEnt, bInitialSnap, fieldName, bWasDemoJump )
{
	ForceTModeVisible( self, newVal );
}

function active_DNI_bootup_fx( localClientNum, oldVal, newVal, bNewEnt, bInitialSnap, fieldName, bWasDemoJump )
{
	self thread postfx::PlayPostfxBundle( "pstfx_tactical_bootup" );
}

function tmode_Off(localClientNum)
{
	self tmodeEnable(0);
	if (!isdefined( level.tmode_fx_override ))
	{
		self thread postfx::PlayPostfxBundle( "pstfx_tactical_bootup" );
	}
	self thread tmode_remove_all_ents( localClientNum );
	self PlaySound( 0, "uin_tac_mode_off" );
	level flag::clear( "activate_tmode" );
}

function tmode_On(localClientNum)
{
	ev_force_off( localClientNum );

	level flag::set( "activate_tmode" );	
	self tmodeEnable(1);

	if( isdefined( level.tmode_override ) )
	{
		[[ level.tmode_override ]]();
	}
	if (!isdefined( level.tmode_fx_override ))
	{
		self thread postfx::PlayPostfxBundle( "pstfx_tactical_bootup" );
	}
	self PlaySound( 0, "uin_tac_mode_on" );
}

function tmode_player_toggle( localClientNum, oldVal, newVal, bNewEnt, bInitialSnap, fieldName, bWasDemoJump )
{
	if ( !self isLocalPlayer() )
	{
		return;
	}

	if ( !isdefined( self.localClientNum ) )
	{
		return;
	}
	
	if ( self.localClientNum != localClientNum )
	{
		return;
	}
	
	if ( level flagsys::get( "menu_open" ) )
	{
		return;
	}

	if ( IsDemoPlaying() && IsSpectating( localClientNum ) )
	{
		newVal = false;
	}

	self notify( "tmode_cancel" );
	self.tmode_status = newVal;
	
	if ( newVal )
	{
		self tmode_On( localClientNum );
	}
	else
	{
		self tmode_Off( localClientNum );
	}
}

/////////////////////////////////////////////////////////////////////////
//Sitrep functions
/////////////////////////////////////////////////////////////////////////
function sitrep_player_toggle( localClientNum, oldVal, newVal, bNewEnt, bInitialSnap, fieldName, bWasDemoJump )
{
	if ( !self isLocalPlayer() )
	{
		return;
	}

	if( !isdefined( self.localClientNum ) )
	{
		return;
	}
	if ( self.localClientNum != localClientNum )
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
	self.sitrep_active = newVal;
	
	self oed_sitrepscan_enable( newVal );
}

function ent_material_callback( localClientNum, oldVal, newVal, bNewEnt, bInitialSnap, fieldName, bWasDemoJump )
{
	self endon( "entityshutdown" );
	Assert( isdefined(self), "Entity trying to keyline is not valid" );
	level flagsys::wait_till( "duplicaterender_registry_ready" );//Wait for materials to get registered by manager
	Assert( isdefined(self), "Entity trying to keyline was deleted before the system was ready" );

	if( newVal == 0 )
	{
		self notify( "keyline_disabled" );
		self.b_interact_tracker_active = undefined;		
		self duplicate_render::change_dr_flags( undefined, "keyline_active,keyfill_active" );
		self TmodeSetFlag( 2 );
	}
	else
	{
		self duplicate_render::change_dr_flags( "keyline_active", "keyfill_active" );
		self.b_keyline_enabled = true;
		self TmodeClearFlag( 2 );
		if( !isdefined( self.b_interact_tracker_active ) )
		{
			self.b_interact_tracker_active = true;
			self thread interact_tracker( localClientNum );
		}		
	}
}

function interact_tracker( localClientNum )//self = interactable entity
{
	self endon( "death" );
	self endon( "entityshutdown" );
	self endon( "keyline_disabled" );
	
	player = GetLocalPlayer( localClientNum );
	player endon( "disconnect" );
	player endon( "entityshutdown" );
	
	n_interact_advert_dist = 0;
	n_interact_advert_dist = GetDvarFloat( "interactivePromptNearToDist", 8.4 );
	n_interact_advert_dist *= 39.370;		// Convert to units
	
	while( true )
	{
		n_dist = Distance( self.origin, player.origin );
		is_active_thermal = level flag::get( "activate_thermal" );
		is_active_tmode = false;	//level flag::get( "activate_tmode" );
		
		if( ( ( n_dist <= 90 || n_dist > n_interact_advert_dist ) && self.b_keyline_enabled && !is_active_thermal && !is_active_tmode ) || ( ( is_active_thermal || is_active_tmode ) && self.b_keyline_enabled )  )
		{
			self duplicate_render::change_dr_flags( undefined, "keyline_active,keyfill_active" );
			self TmodeClearFlag( 2 );
			self.b_keyline_enabled = false;
		}
		else if( ( n_dist > 90 && n_dist <= n_interact_advert_dist && !self.b_keyline_enabled && !is_active_thermal && !is_active_tmode ) )
		{
			self duplicate_render::change_dr_flags( "keyline_active", "keyfill_active" );
			self TmodeSetFlag( 2 );
			self.b_keyline_enabled = true;			
		}
		
		wait( .016 * RandomIntRange( 1,10 ) );//wait a random number of frames 1-10 - helps spread the work of multiple threads around - 23 active in one measured spot in ramses2
	}
}
