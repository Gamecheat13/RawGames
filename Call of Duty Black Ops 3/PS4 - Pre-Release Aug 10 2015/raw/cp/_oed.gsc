#using scripts\codescripts\struct;

#using scripts\shared\array_shared;
#using scripts\shared\callbacks_shared;
#using scripts\shared\clientfield_shared;
#using scripts\shared\flagsys_shared;
#using scripts\shared\spawner_shared;
#using scripts\shared\system_shared;
#using scripts\shared\util_shared;
#using scripts\shared\visionset_mgr_shared;

#using scripts\cp\gametypes\_save;

    	   	                                                                                                                                         	                                	                                                                                                                                                                                                                                                                                                                                                                    	        	     	             	    	   	               	                                              	                                                           	                               	                     	                                                                                                           	                                                                 	                                                              	                                                                                                              	                            	                                     	                                       	                                                                                                              	   	                  	       	                                                    	                   	                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                        	                                  	                                                                                        	           	                        	                                            	                                             	                                                   	                                                             	                                                         	                                                                    	                                                                                                                                                                                                    	                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                         	                                                              	                                                          	                                   	                                   	                                                    	                                       	                                           	     	                                                                                                                                                                                                                                                      	                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                     
                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                            	                           	                           	                                                                                                                                                                                                                                                            	                                                                                                                                                                                                                                                                                                                                                                                       
                                                                          	                                         	   	     	    	     	   		   	                                                                       	                                                                                    	        	                                                                          	    	         	           		       	                                                                                                                                                                    	   	                 	   	                                 	          	                          	              	                        	                        	                    	                      	                                                                        	
    	                               	                    	                                 	                                        	                            	                                                                  	                                                 

#namespace oed;

function autoexec __init__sytem__() {     system::register("oed",&__init__,&__main__,undefined);    }
	
//TODO - add in support for the animated portion of the hud/lui when it comes online

function __init__()
{
	clientfield::register( "toplayer",		"ev_toggle",		1, 1, "int" );
	clientfield::register( "toplayer",		"sitrep_toggle",	1, 1, "int" );
	clientfield::register( "toplayer",		"tmode_toggle",		1, 1, "int" );
	clientfield::register( "toplayer", 		"active_dni_fx",	1, 1, "counter" );
	
	clientfield::register( "actor",			"thermal_active",	1, 1, "int" );
	clientfield::register( "actor",			"sitrep_material",	1, 1, "int" );
	clientfield::register( "actor",			"force_tmode",		1, 1, "int" );
	clientfield::register( "actor",			"tagged",			1, 1, "int" );

	clientfield::register( "vehicle",		"thermal_active",	1, 1, "int" );
	clientfield::register( "vehicle",		"sitrep_material",	1, 1, "int" );

	clientfield::register( "scriptmover",	"thermal_active",	1, 1, "int" );
	clientfield::register( "scriptmover",	"sitrep_material",	1, 1, "int" );
	
	clientfield::register( "item",			"sitrep_material",	1, 1, "int" );

	if ( !IsDefined( level.vsmgr_prio_visionset_tmode ) )
	{
		level.vsmgr_prio_visionset_tmode = 50;
	}
	visionset_mgr::register_info( "visionset", "tac_mode", 1, level.vsmgr_prio_visionset_tmode, 15, true, &visionset_mgr::ramp_in_out_thread_per_player, false );

	callback::on_spawned( &on_player_spawned );

	// Have all enemies show up on thermal
	spawner::add_global_spawn_function( "axis", &enable_thermal_on_spawned );
	
	level.b_enhanced_vision_enabled = true;
	level.b_tactical_mode_enabled = true;
	level.b_player_scene_active = false;

	level thread _disable_oed_watcher();
	level thread _enable_oed_watcher();
	
	level.enable_thermal = &enable_thermal;
	level.disable_thermal = &disable_thermal;
}

function __main__()
{
	keyline_weapons();
}

function keyline_weapons()
{
	waittillframeend; // clientfields can't be set before a wait
	if ( level.b_tactical_mode_enabled )
	{
		array::thread_all(
			util::query_ents(
				AssociativeArray( "classname", "weapon_" ), true,
				[],
				true,
				true
			 ), &enable_keyline );
	}
}

function on_player_spawned()
{
	self.b_enhanced_vision_enabled = level.b_enhanced_vision_enabled;
	self.b_enhanced_vision = false;
	self.b_tactical_mode_enabled = level.b_tactical_mode_enabled;
	
	self.b_tmode_on =  false;
	self.b_ev_on =  false;

	// tmode init
 	self.tmode_active = self savegame::get_player_data("tmode");
  	if( !IsDefined( self.tmode_active ) )
    	self.tmode_active = false;
    self.b_tmode_on =  self.tmode_active;	
   	self clientfield::set_to_player( "tmode_toggle", self.tmode_active );
	   
	self clientfield::set_to_player( "sitrep_toggle", 1 );
	self thread oed_toggle();
	self thread init_heroes();


}

//////////////////////////////////////////////////////////////////////////////////
/// OED
//////////////////////////////////////////////////////////////////////////////////
function oed_toggle()  //TODO - temp OED functionality
{
	self endon( "death" );
	self endon("killOEDMonitor");
	
	while( 1 )
	{
		/# level flagsys::wait_till_clear( "menu_open" ); #/
		
		if ( level.b_enhanced_vision_enabled && self.b_enhanced_vision_enabled && !level.b_player_scene_active && self ActionSlotOneButtonPressed() )
		{
			if ( !self.b_enhanced_vision )
			{
				self set_player_ev( true );
				
				while( self ActionSlotOneButtonPressed() )
				{
					{wait(.05);};	
				}
			}
			else
			{
				self set_player_ev( false );
			}
			
			while( self ActionSlotOneButtonPressed() )
			{
				{wait(.05);};	
			}
		}
		
		// T-Mode Toggle
		if ( !( SessionModeIsCampaignZombiesGame() ) && level.b_tactical_mode_enabled && self.b_tactical_mode_enabled && !level.b_player_scene_active && self ActionSlotThreeButtonPressed() )
		{
			self.tmode_active = !( isdefined( self.tmode_active ) && self.tmode_active );
			self clientfield::set_to_player( "tmode_toggle", self.tmode_active );
			self savegame::set_player_data("tmode", self.tmode_active );
			self.b_tmode_on = self.tmode_active;
			
			//the tutorial moments in New World is listening for this
			if ( !self.tmode_active )
			{
				self notify( "tactical_mode_deactivated" ); 
			}
			else
			{
				self notify( "tactical_mode_activated" );
				self.b_ev_on = false;
			}
			
//			if ( self.tmode_active )
//			{
				visionset_mgr::activate( "visionset", "tac_mode", self, 0.05, 0.0, 0.8 );
				
				wait 0.05 + 0.0 + 0.8;
//			}

			while ( self ActionSlotThreeButtonPressed() )
			{
				{wait(.05);};
			}
		}	

		{wait(.05);};
	}
}

//////////////////////////////////////////////////////////////////////
///ENHANCED VISION - THERMAL
//////////////////////////////////////////////////////////////////////

//	Spawn function to automatically enable thermal on enemies
function enable_thermal_on_spawned()
{
	if ( self.team == "axis" )
	{
		self enable_thermal();
	}
}

//TODO - will likely need to add in support for hud/lui changes
//	Called externally to enable an entity to have a thermal shader when EV is activated
//	self is the entity to have a thermal signature
//	str_disable - a notify that can be used to deactivate the thermal signature
function enable_thermal( str_disable )
{
	self endon( "death" );
	
	self clientfield::set( "thermal_active", 1 );
	self thread disable_thermal_on_death();
	
	if( isdefined( str_disable ) )
	{
		level waittill( str_disable );
		
		self disable_thermal();
	}
}

//	Remove the thermal signature on death
//	self is the entity that has a thermal signature
function disable_thermal_on_death()
{
	self endon( "disable_thermal" );
	
	self waittill( "death" );

	if( isdefined( self ) )
	{
		self disable_thermal();
	}
}

//	Remove the thermal signature from the entity
//	self is the entity that has a thermal signature
function disable_thermal()
{
	self clientfield::set( "thermal_active", 0  );
	
	self notify( "disable_thermal" );
}

//Toggles the vars used to enable/disable player access to thermal mode, also called EV
//This should be used when toggling during the course of the level
//If you just want to disable thermal access by default at level start, just use level.b_enhanced_vision_enabled = false;
function toggle_thermal_mode_for_players( b_enabled = true )
{
	level.b_enhanced_vision_enabled = b_enabled;
	foreach( e_player in level.players )
	{
		e_player.b_enhanced_vision_enabled = b_enabled;	
	}
}

// self is a player
function enable_ev( b_enabled = true )
{
	self.b_enhanced_vision_enabled = b_enabled;
	if ( !b_enabled )
	{
		self set_player_ev( false );
	}
}

function set_player_ev( b_enabled = true )
{
	self.b_enhanced_vision = b_enabled;
	
	if( b_enabled )
	{
		self notify( "enhanced_vision_activated" ); //the tutorial moment in New World is listening for this	
		self.b_ev_on = true; 	 
   		self.b_tmode_on = false; 	
	}
	else
	{
		self notify( "enhanced_vision_deactivated" );	
   		self.b_ev_on = false;
	}
	
	self clientfield::set_to_player( "ev_toggle", b_enabled );			
}

function init_heroes()
{
	a_e_heroes = GetEntArray();
	foreach( e_hero in a_e_heroes )
	{
		if( ( isdefined( e_hero.is_hero ) && e_hero.is_hero ) )
		{
			e_hero thread enable_thermal();
		}
	}
}

///////////////////////////////////////////////////////////////////////////
/// TACTICAL MODE
///////////////////////////////////////////////////////////////////////////

//Toggles the vars used to enable/disable player access to tactical mode
//This should be used when toggling during the course of the level
//If you just want to disable tac mode access by default at level start, just use level.b_tactical_mode_enabled = false;
function toggle_tac_mode_for_players( b_enabled = true )
{
	level.b_tactical_mode_enabled = b_enabled;
	foreach( e_player in level.players )
	{
		e_player.b_tactical_mode_enabled = b_enabled;	
	}
}

function enable_tac_mode( b_enabled = true )
{
	self.b_tactical_mode_enabled = b_enabled;
	if ( !b_enabled )
	{
		self set_player_tmode( false );
	}
}

//self = player
function set_player_tmode( b_enabled = true )
{
	self.tmode_active = b_enabled;
	self.b_tmode_on = b_enabled;

	self clientfield::set_to_player( "tmode_toggle", self.tmode_active );
  
   	if ( b_enabled )
		self.b_ev_on = false;
}

//self = AI enemy actor that will draw in tmode for all players no matter what
function set_force_tmode( b_enabled = true )
{
	self.b_force_tmode = b_enabled;
	self clientfield::set( "force_tmode", b_enabled );
}

//////////////////////////////////////////////////////////////////////////
/// SITREP - KEYLINE
//////////////////////////////////////////////////////////////////////////

//Set b_interact to true if this is an interactive entity//TODO we may need support now for non-interactable, for now we assume this is an interact object
function enable_keyline( b_interact = false, str_disable )
{
	self endon( "death" );
	
	self clientfield::set( "sitrep_material", 1  );
	
	self thread disable_on_death();
	
	if( isdefined( str_disable ) )
	{
		level waittill( str_disable );
		self disable_keyline();
	}
}

function disable_on_death()
{
	self waittill( "death" );
	if( isdefined( self ) )
	{
		self disable_keyline();
	}
}

function disable_keyline()
{
	self clientfield::set( "sitrep_material", 0  );
}

function toggle_sitrep_for_players( b_active = true )
{
	foreach( player in level.players )
	{
		player.sitrep_active = !( isdefined( player.sitrep_active ) && player.sitrep_active );	
		player clientfield::set_to_player( "sitrep_toggle", player.sitrep_active );
	}
}

function init_sitrep_model()
{
	if( !IsDefined(self.angles) )
	{	
		self.angles = (0, 0 ,0 );
	}
		
	s_sitrep_bundle = level.scriptbundles[ "sitrep" ][ self.scriptbundlename ];
	
	e_sitrep = util::spawn_model( s_sitrep_bundle.model, self.origin, self.angles );
	
	if( isdefined( s_sitrep_bundle.sitrep_interact ) )
	{
		e_sitrep.script_sitrep_id =	s_sitrep_bundle.sitrep_interact;
	}
	else
	{
		e_sitrep.script_sitrep_id = 0;
	}
	
	return e_sitrep;
}

/////////////////////////////////////////////////////////////
/// INTERNAL FUNCTIONS
/////////////////////////////////////////////////////////////

//used to track when an igc starts, we want to turn off all oed systems
function _disable_oed_watcher()
{
	level notify( "disable_oed_watcher" );
	level endon( "disable_oed_watcher" );
	
	while( true )
	{
		level waittill( "disable_oed" );

		level.b_player_scene_active = true;

  		// to be replaced with a client side call IGCActive( localClientNum, 1 );
		  
		//foreach( player in level.players )
		//{
		//	player set_player_ev( false );
		//	player clientfield::set_to_player( "tmode_toggle", 0 );
		//	player clientfield::set_to_player( "sitrep_toggle", 0 );
		//}
	}	
}

//used to track when an igc stops, we want to turn back on sitrep
function _enable_oed_watcher()
{
	level notify( "enable_oed_watcher" );
	level endon( "enable_oed_watcher" );
	
	while( true )
	{
		level waittill( "enable_oed" );

		// to be replaced with a client side call IGCActive( localClientNum, 0 );

		//foreach( player in level.players )
		//{
		//	if ( IS_TRUE( player.b_ev_on ) )
		//	{
		//		player set_player_ev( 1 );
		//	}
			
		//	if ( IS_TRUE( player.b_tmode_on ) )
		//	{
		//		player clientfield::set_to_player( "tmode_toggle", 1 );
		//	}

		//	player clientfield::set_to_player( "sitrep_toggle", 1 );
 		//}
		
		level.b_player_scene_active = false;
	}	
}
