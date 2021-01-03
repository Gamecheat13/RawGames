#using scripts\codescripts\struct;

#using scripts\shared\callbacks_shared;
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
	add_hazard( "heat",		500, 50, 1 );
	add_hazard( "filter",	500, 50, 2 );
	add_hazard( "o2",		500, 50, 3 );
	add_hazard( "radation",	500, 50, 4 );
	
	callback::on_spawned( &on_player_spawned );
	callback::on_player_killed( &on_player_killed );
}

function add_hazard( str_name, n_max_protection, n_regen_rate, n_type )
{
	if(!isdefined(level.hazards))level.hazards=[];
	if(!isdefined(level.hazards[ str_name ]))level.hazards[ str_name ]=SpawnStruct();
	
	level.hazards[ str_name ].n_max_protection = n_max_protection;
	level.hazards[ str_name ].n_regen_rate = n_regen_rate;
	level.hazards[ str_name ].n_type = n_type;
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

function do_damage( str_name, n_damage )
{
	Assert( isdefined( level.hazards[ str_name ] ), "No hazard with name '" + str_name + "' registered." );
	
	s_hazard = level.hazards[ str_name ];
	
	self.hazard_damage[ str_name ] = Min( self.hazard_damage[ str_name ] + n_damage, s_hazard.n_max_protection );
	
	if ( self.hazard_damage[ str_name ] < s_hazard.n_max_protection )
	{
		self thread _fill_hazard_protection( str_name );
		return true;
	}
	
	return false;
}

function private _fill_hazard_protection( str_name )
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
				
		{wait(.05);};
		
		self.hazard_damage[ str_name ] -= s_hazard.n_regen_rate * .05;
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
