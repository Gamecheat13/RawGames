#using scripts\codescripts\struct;

#using scripts\shared\callbacks_shared;
#using scripts\shared\clientfield_shared;
#using scripts\shared\util_shared;
#using scripts\shared\system_shared;

    	   	                                                                                                                                         	                                	                                                                                                                                                                                                                                                                                                                                                                    	        	     	             	    	   	               	                                              	                                                           	                               	                     	                                                                                                           	                                                                 	                                                              	                                                                                                              	                            	                                     	                                       	                                                                                                              	   	                  	       	                                                    	                   	                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                        	                                  	                                                                                        	           	                        	                                            	                                             	                                                   	                                                             	                                                         	                                                                    	                                                                                                                                                                                                    	                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                         	                                                              	                                                          	                                   	                                   	                                                    	                                       	                                           	     	                                                                                                                                                                                                                                                      	                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                     

#namespace hazard;








#precache( "lui_menu_data", "hudItems.hess1.type" );
#precache( "lui_menu_data", "hudItems.hess2.type" );
#precache( "lui_menu_data", "hudItems.hess1.ratio" );
#precache( "lui_menu_data", "hudItems.hess2.ratio" );

function autoexec __init__sytem__() {     system::register("hazard",&__init__,undefined,undefined);    }

function __init__()
{
	add_hazard( "heat",			500, 50, 1, &update_heat );
	add_hazard( "filter",		500, 50, 2 );
	add_hazard( "o2",			500, 60, 3, &update_o2 );
	add_hazard( "radation",		500, 50, 4 );
	add_hazard( "biohazard",	500, 50, 5 );
	
	callback::on_spawned( &on_player_spawned );
	callback::on_player_killed( &on_player_killed );
}

function add_hazard( str_name, n_max_protection, n_regen_rate, n_type, func_update )
{
	if(!isdefined(level.hazards))level.hazards=[];
	if(!isdefined(level.hazards[ str_name ]))level.hazards[ str_name ]=SpawnStruct();
	
	level.hazards[ str_name ].n_max_protection = n_max_protection;
	level.hazards[ str_name ].n_regen_rate = n_regen_rate;
	level.hazards[ str_name ].n_type = n_type;
	level.hazards[ str_name ].b_regen = true;
	level.hazards[ str_name ].func_update = func_update;
}

function on_player_spawned()
{
	foreach ( str_name, _ in level.hazards )
	{
		self.hazard_damage[ str_name ] = 0;
	}
	
	self.hazard_ui_models = [];
	self.hazard_ui_models[ "hudItems.hess1" ] = 0;
	self.hazard_ui_models[ "hudItems.hess2" ] = 0;
	
	self SetControllerUIModelValue( "hudItems.hess1.type", 0 );
	self SetControllerUIModelValue( "hudItems.hess2.type", 0 );
}

function on_player_killed()
{
	self.hazard_ui_models[ "hudItems.hess1" ] = 0;
	self.hazard_ui_models[ "hudItems.hess2" ] = 0;
	
	self SetControllerUIModelValue( "hudItems.hess1.type", 0 );
	self SetControllerUIModelValue( "hudItems.hess2.type", 0 );
}


//
//	Instantly restores damage health
function reset_damage( str_name )
{
	Assert( isdefined( level.hazards[ str_name ] ), "No hazard with name '" + str_name + "' registered." );

	self.hazard_damage[ str_name ] = 0;
}


//	Do n_damage of the str_name hazard type to self
//	self is a player
function do_damage( str_name, n_damage, e_ent )
{
	Assert( isdefined( level.hazards[ str_name ] ), "No hazard with name '" + str_name + "' registered." );
	
	s_hazard = level.hazards[ str_name ];
	
	self.hazard_damage[ str_name ] = Min( self.hazard_damage[ str_name ] + n_damage, s_hazard.n_max_protection );
	
	if ( self.hazard_damage[ str_name ] < s_hazard.n_max_protection )
	{
		self thread _fill_hazard_protection( str_name, e_ent );
		return true;
	}
	
	// Means of Death
	switch ( str_name )
	{
		case "o2":
			str_mod = "MOD_DROWN";
			break;
			
		case "heat":
			str_mod = "MOD_BURNED";
			break;
			
		default:
			str_mod = "MOD_UNKNOWN";
	}
	
	self DoDamage( self.health, self.origin, undefined, undefined, undefined, str_mod ); // No more hazard protection, kill the player
	
	return false;
}


//	Returns the damage value for the given hazard 
function get_damage( str_name )
{
	Assert( isdefined( self.hazard_damage[ str_name ] ), "No hazard with name '" + str_name + "' registered." );
	
	return self.hazard_damage[ str_name ];	
}


//	Returns the fraction of damage received over the maximum protection
function get_damage_fraction( str_name )
{
	Assert( isdefined( self.hazard_damage[ str_name ] ), "No hazard with name '" + str_name + "' registered." );
	
	return self.hazard_damage[ str_name ] / level.hazards[ str_name ].n_max_protection;
}


//toggles regeneration of the damage type
function toggle_regen( str_name, b_regen = true )
{
	Assert( isdefined( level.hazards[ str_name ] ), "No hazard with name '" + str_name + "' registered." );
	level.hazards[ str_name ].b_regen = b_regen;
}

function private _fill_hazard_protection( str_name, e_ent )
{
	self notify( "_hazard_protection_" + str_name );
	self endon( "_hazard_protection_" + str_name );
	
	self endon( "death" );
	
	s_hazard = level.hazards[ str_name ];
	
	str_ui_model = "";
	
	// Find active UI for same hazard type
	foreach ( model, type in self.hazard_ui_models )
	{
		if ( type == s_hazard.n_type )
		{
			str_ui_model = model;
			break;
		}
	}
	
	if ( str_ui_model == "" )
	{
		// Didn't find active UI for same hazard type.  Look for free UI slot.
		foreach ( model, type in self.hazard_ui_models )
		{
			if ( type == 0 )
			{
				str_ui_model = model;
				break;
			}
		}
	}
	
	if ( str_ui_model != "" )
	{		
		self SetControllerUIModelValue( str_ui_model + ".type", s_hazard.n_type );
		self.hazard_ui_models[ str_ui_model ] = s_hazard.n_type;
	}
	
	do
	{
		n_frac = MapFloat( 0, s_hazard.n_max_protection, 1, 0, self.hazard_damage[ str_name ] );
		
		if ( str_ui_model != "" )
		{
			self SetControllerUIModelValue( str_ui_model + ".ratio", n_frac );
		}
		
		if ( isdefined( s_hazard.func_update ) )
		{
			[[s_hazard.func_update]]( n_frac, e_ent );
		}
		
		{wait(.05);};
		
		if( level.hazards[ str_name ].b_regen == true )
		{
			self.hazard_damage[ str_name ] -= s_hazard.n_regen_rate * .05;
		}
	}
	while ( self.hazard_damage[ str_name ] >= 0 );	

	if ( str_ui_model != "" )
	{
		self SetControllerUIModelValue( str_ui_model + ".type", 0 );
		self.hazard_ui_models[ str_ui_model ] = 0;
	}
	else
	{
		Assert( "Invalid UI model." );
	}
}


function update_heat( n_damage_frac, e_ent )
{
	if( !isdefined( e_ent ) )
	{
		self.b_hazard_burning = undefined;
		self clientfield::set( "burn", 0 );
		return;
	}

	if ( !( isdefined( self.b_hazard_burning ) && self.b_hazard_burning ) && self IsTouching( e_ent ) )
	{
		self clientfield::set( "burn", 1 );
	}
	else
	{
		self.b_hazard_burning = undefined;
		self clientfield::set( "burn", 0 );
	}
}


//	Warning to the player that their oxygen is low
function drown_warning()
{
	self endon( "death" );
	
	self clientfield::set_to_player("player_cam_bubbles", 1);
	wait( 4.0 );
	
	self clientfield::set_to_player("player_cam_bubbles", 0);
}


// Handle drowning
//	n_drown_frac_curr
function update_o2( n_drown_frac_curr, e_ent )
{
	if ( !isdefined( self.n_hazard_drown_frac_last ) )
	{
		self.n_hazard_drown_frac_last = 0.0;
	}
	
	// Blow bubbles at 2 threshholds
	if ( n_drown_frac_curr <= 0.2 )
	{
		if ( self.n_hazard_drown_frac_last > 0.2 )
		{
			self thread drown_warning();
		}
	}
	else if ( n_drown_frac_curr <= 0.1 )
	{
		if ( self.n_hazard_drown_frac_last > 0.1 )
		{
			self thread drown_warning();
		}
	}
	
	self.n_hazard_drown_frac_last = n_drown_frac_curr;
}


//	Thread to run when player is underwater
function hazard_dot_o2( n_time, n_goal_frac = 1.0 )
{
	self thread hazard_dot( "o2", 4, n_time, n_goal_frac );
}


//	Does damage over time
//		str_hazard - type of hazard
//		n_hazard_damage - damage to do every second
//		n_time - target time to do damage
//		n_goal_frac - goal fraction of damage of max protection (0.0 - 1.0).  Hazard damage may be increased in order to reach the goal fraction within the time specified.
function hazard_dot( str_hazard, n_hazard_damage, n_time, n_goal_frac )
{	
	Assert( isdefined( level.hazards[ str_hazard ] ), "No hazard with name '" + str_hazard + "' registered." );

	self notify( "stop_hazard_dot_" + str_hazard );
	self endon( "stop_hazard_dot_" + str_hazard );
	self endon( "death" );
	
	self hazard::toggle_regen( str_hazard, false );
	b_protected = true;
	s_hazard = level.hazards[ str_hazard ];
	n_damage = n_hazard_damage;	// damage to do every second - also scope declaration

	if ( isdefined( n_time ) )
	{
		n_curr_damage = self get_damage( str_hazard );			// current hazard damage amount
		n_max_protect = s_hazard.n_max_protection;				// maximum hazard damage protection
		n_goal_damage = n_goal_frac * n_max_protect;			// target damage amount
		
		n_damage_diff = n_goal_damage - n_curr_damage;	// difference in goal vs. current damage
		if ( n_damage_diff > 0 )
		{
			n_damage = n_damage_diff / n_time;	// need to do increased damage in order to reach the goal on time
		}
	}

	while( true )
	{
		wait 1;	// evaluation interval
		
		b_protected = self hazard::do_damage( str_hazard, n_damage ); 
		
		n_damage_frac_curr = self get_damage_fraction( str_hazard );
		if ( n_damage > n_hazard_damage && n_damage_frac_curr >= n_goal_frac )
		{
			n_damage = n_hazard_damage;
		}
	}
}

function stop_hazard_dot( str_hazard )
{
	self notify( "stop_hazard_dot_" + str_hazard );
	self hazard::toggle_regen( str_hazard, true );
}
