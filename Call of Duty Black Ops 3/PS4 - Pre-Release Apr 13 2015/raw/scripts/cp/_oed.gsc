#using scripts\codescripts\struct;

#using scripts\shared\callbacks_shared;
#using scripts\shared\clientfield_shared;
#using scripts\shared\flagsys_shared;
#using scripts\shared\spawner_shared;
#using scripts\shared\system_shared;
#using scripts\shared\util_shared;
#using scripts\shared\visionset_mgr_shared;

    	   	                                                                                                                         	                                                                                                                                                                                                                                                                                                                                                                    	        	     	             	    	   	                           	                               	                                	                                                              	                                                                                                              	                            	                                     	                                       	                                                               	   	                  	       	                                                    	                   	                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                        	                                                                                        	           	                        	                                            	                                             	                                                   	                                                             	                                                         	                                                                    	                                                                                                                                                                                                    	                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                      	                                                              	                                                          	                                   	                                   	                                                    	                                       
                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                            	                                                                                                                                                                                                                                                                                                                                                                                       
        	                               	                    	                                 	                                        	                            	                                                                  	                               

#namespace oed;

function autoexec __init__sytem__() {     system::register("oed",&__init__,undefined,undefined);    }
	
//TODO - add in support for the animated portion of the hud/lui when it comes online

function __init__()
{
	clientfield::register( "toplayer",		"ev_toggle",		1, 1, "int" );
	clientfield::register( "toplayer",		"sitrep_toggle",	1, 1, "int" );
	clientfield::register( "toplayer",		"tmode_toggle",		1, 1, "int" );
	
	clientfield::register( "actor",			"thermal_active",	1, 1, "int" );
	clientfield::register( "actor",			"sitrep_material",	1, 2, "int" );
	clientfield::register( "actor",			"force_tmode",		1, 1, "int" );
	clientfield::register( "actor",			"tagged",			1, 1, "int" );

	clientfield::register( "vehicle",		"thermal_active",	1, 1, "int" );
	clientfield::register( "vehicle",		"sitrep_material",	1, 2, "int" );

	clientfield::register( "scriptmover",	"thermal_active",	1, 1, "int" );
	clientfield::register( "scriptmover",	"sitrep_material",	1, 2, "int" );

	if ( !IsDefined( level.vsmgr_prio_visionset_tmode ) )
	{
		level.vsmgr_prio_visionset_tmode = 50;
	}
	visionset_mgr::register_info( "visionset", "tac_mode", 1, level.vsmgr_prio_visionset_tmode, 15, true, &visionset_mgr::ramp_in_out_thread_per_player, false );

	callback::on_spawned( &on_player_spawned );

	// Have all enemies show up on thermal
	spawner::add_global_spawn_function( "axis", &enable_thermal_on_spawned );
	
	level.b_enhanced_vision_enabled = false;
	level.b_tactical_mode_enabled = true;
}

function on_player_spawned()
{
	self.b_enhanced_vision_enabled = level.b_enhanced_vision_enabled;
	self.b_enhanced_vision = false;
	self.b_tactical_mode_enabled = level.b_tactical_mode_enabled;
	
	self thread oed_toggle();
	self thread init_sitrep_bundles();
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
		
		if ( level.b_enhanced_vision_enabled && self.b_enhanced_vision_enabled && self ActionSlotOneButtonPressed() )
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
		if ( level.b_tactical_mode_enabled && self.b_tactical_mode_enabled && self ActionSlotThreeButtonPressed() )
		{
			self.tmode_active = !( isdefined( self.tmode_active ) && self.tmode_active );
			self clientfield::set_to_player( "tmode_toggle", self.tmode_active );
//			if ( self.tmode_active )
//			{
				visionset_mgr::activate( "visionset", "tac_mode", self, 0.05, 0.0, 0.8 );
				self notify( "tactical_mode_activated" ); //the tutorial moment in New World is listening for this
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


//
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
	self notify( "disable_thermal" );
	
	self clientfield::set( "thermal_active", 0  );
}


//TODO - will likely need to add in support for hud/lui changes
//Set b_interact to true if this is an interactive entity
function enable_keyline( b_interact = false, str_disable )
{
	self endon( "death" );
	
	if( b_interact )
	{
		n_color_value = 1;//Has keyline
	}
	else
	{
		n_color_value = 2;//Fill only
	}
	
	self clientfield::set( "sitrep_material", n_color_value  );
	self SetForceNoCull();
	
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
	self RemoveForceNoCull();
}

function toggle_sitrep_for_players( b_active = true )
{
	foreach( player in level.players )
	{
		player.sitrep_active = !( isdefined( player.sitrep_active ) && player.sitrep_active );	
		player clientfield::set_to_player( "sitrep_toggle", player.sitrep_active );
	}
}

function init_sitrep_bundles()
{
	a_sitrep = struct::get_array( "scriptbundle_sitrep", "classname" );
	foreach( s_instance in a_sitrep )
	{
		e_sitrep = s_instance init_sitrep_model();
		e_sitrep thread enable_keyline( e_sitrep.script_sitrep_id );
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
	
	self clientfield::set_to_player( "ev_toggle", b_enabled );			
}

//self = player
function set_player_tmode( b_enabled = true )
{
	self.tmode_active = b_enabled;
	self clientfield::set_to_player( "tmode_toggle", self.tmode_active );
}

//self = AI enemy actor that will draw in tmode for all players no matter what
function set_force_tmode( b_enabled = true )
{
	self.b_force_tmode = b_enabled;
	self clientfield::set( "force_tmode", b_enabled );
}
