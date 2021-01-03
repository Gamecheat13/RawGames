#using scripts\codescripts\struct;

#using scripts\shared\callbacks_shared;
#using scripts\shared\clientfield_shared;
#using scripts\shared\filter_shared;
#using scripts\shared\util_shared;
#using scripts\shared\array_shared;

    	   	                                                                                                                                         	                                	                                                                                                                                                                                                                                                                                                                                                                    	        	     	             	    	   	               	                                              	                                                           	                               	                     	                                                                                                           	                                                                 	                                                              	                                                                                                              	                            	                                     	                                       	                                                                                                              	   	                  	       	                                                    	                   	                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                        	                                  	                                                                                        	           	                        	                                            	                                             	                                                   	                                                             	                                                         	                                                                    	                                                                                                                                                                                                    	                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                         	                                                              	                                                          	                                   	                                   	                                                    	                                       	                                           	     	                                                                                                                                                                                                                                                      	                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                     
                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                            	                           	                           	                                                                                                                                                                                                                                                            	                                                                                                                                                                                                                                                                                                                                                                                       

#using scripts\zm\_filter;
#using scripts\shared\util_shared;

                                                                                       	                                

#namespace zm_perks;

// Client side perks functionality

function init()
{	
	callback::on_start_gametype( &init_perk_machines_fx );
	
	//PERKS
	init_custom_perks();
	
	perks_register_clientfield();
	
	init_perk_custom_threads();
}

function perks_register_clientfield()
{
	if( ( isdefined( level.zombiemode_using_perk_intro_fx ) && level.zombiemode_using_perk_intro_fx ))
	{

		clientfield::register( "scriptmover", "clientfield_perk_intro_fx" , 1,1,"int", &perk_meteor_fx, !true, !true);
	}
	
	// register all custom perk client fields
	if ( level._custom_perks.size > 0 )
	{
		a_keys = GetArrayKeys( level._custom_perks );
		for ( i = 0; i < a_keys.size; i++ )
		{
			if ( IsDefined( level._custom_perks[ a_keys[ i ] ].clientfield_register ) )
			{
				level [[ level._custom_perks[ a_keys[ i ] ].clientfield_register ]]();
			}
		}
	}	
	
	level thread perk_init_code_callbacks();	
}

function perk_init_code_callbacks()
{
	wait(0.1);        // This won't run - until after all the client field registration has finished.
	
	// handle custom perk code callbacks 
	if ( level._custom_perks.size > 0 )
	{
		a_keys = GetArrayKeys( level._custom_perks );
		
		for ( i = 0; i < a_keys.size; i++ )
		{
			if ( IsDefined( level._custom_perks[ a_keys[ i ] ].clientfield_code_callback ) )
			{
				level [[ level._custom_perks[ a_keys[ i ] ].clientfield_code_callback ]]();
			}
		}
	}
}

function init_custom_perks()
{
	if ( !IsDefined( level._custom_perks ) )
	{
		level._custom_perks = [];
	}
}


/@
"Name: register_perk_clientfields( <str_perk>, <func_clientfield_register>, <func_code_callback> )"
"Module: Zombie Perks"
"Summary: Registers functions to register and set clientfields for a perk. These are used to set and clear hud elements when the perk is toggled."
"MandatoryArg: <str_perk>: the name of the specialty that this perk uses. This should be unique, and will identify this perk in system scripts."
"MandatoryArg: <func_clientfield_register>: sets up the clientfield for the perk. Should call clientfield::register(). This is not threaded."
"MandatoryArg: <func_code_callback>: sets code callback for perk. Should internally call SetupClientFieldCodeCallbacks(). This is not threaded."
"Example: register_perk_clientfields( "specialty_vultureaid", &vulture_client_field_func, &vulture_code_callback_func );"
"SPMP: multiplayer"
@/
function register_perk_clientfields( str_perk, func_clientfield_register, func_code_callback )
{
	_register_undefined_perk( str_perk );
	
	if ( !IsDefined( level._custom_perks[ str_perk ].clientfield_register ) )
	{
		level._custom_perks[ str_perk ].clientfield_register = func_clientfield_register;
	}
	
	if ( !IsDefined( level._custom_perks[ str_perk ].clientfield_code_callback ) )
	{
		level._custom_perks[ str_perk ].clientfield_code_callback = func_code_callback;
	}
}

/@
"Name: register_perk_clientfields( <str_perk>, <func_clientfield_register>, <func_code_callback> )"
"Module: Zombie Perks"
"Summary: Registers functions to register and set clientfields for a perk. These are used to set and clear hud elements when the perk is toggled."
"MandatoryArg: <str_perk>: the name of the specialty that this perk uses. This should be unique, and will identify this perk in system scripts."
"MandatoryArg: <func_clientfield_register>: sets up the clientfield for the perk. Should call clientfield::register(). This is not threaded."
"MandatoryArg: <func_code_callback>: sets code callback for perk. Should internally call SetupClientFieldCodeCallbacks(). This is not threaded."
"Example: register_perk_clientfields( "specialty_vultureaid", &vulture_client_field_func, &vulture_code_callback_func );"
"SPMP: multiplayer"
@/
function register_perk_effects( str_perk, str_light_effect )
{
	_register_undefined_perk( str_perk );
	
	if ( !IsDefined( level._custom_perks[ str_perk ].machine_light_effect ) )
	{
		level._custom_perks[ str_perk ].machine_light_effect = str_light_effect;
	}
}

/@
"Name: register_perk_init_thread( <str_perk>, <func_init_thread> )"
"Module: Zombie Perks"
"Summary: Sets a function that will be threaded on level after all perk clientfields have been set"
"MandatoryArg: <str_perk>: the name of the specialty that this perk uses. This should be unique, and will identify this perk in system scripts."
"MandatoryArg: <func_init_thread>: function that should run after clientfields are set"
"Example: register_perk_init_thread( "specialty_vultureaid", &init_vulture );"
"SPMP: multiplayer"
@/
function register_perk_init_thread( str_perk, func_init_thread )
{
	_register_undefined_perk( str_perk );
	
	if ( !IsDefined( level._custom_perks[ str_perk ].init_thread ) )
	{
		level._custom_perks[ str_perk ].init_thread = func_init_thread;
	}
}

function init_perk_custom_threads()
{
	if ( level._custom_perks.size > 0 )
	{
		a_keys = GetArrayKeys( level._custom_perks );
		for ( i = 0; i < a_keys.size; i++ )
		{
			if ( IsDefined( level._custom_perks[ a_keys[ i ] ].init_thread ) )
			{
				level thread [[ level._custom_perks[ a_keys[ i ] ].init_thread ]]();
			}
		}
	}
}

function _register_undefined_perk( str_perk )
{
	if ( !IsDefined( level._custom_perks ) )
	{
		level._custom_perks = [];
	}
	
	if ( !IsDefined( level._custom_perks[ str_perk ] ) )
	{
		level._custom_perks[ str_perk ] = SpawnStruct();
	}
}

function perk_meteor_fx (localClientNum, oldVal, newVal, bNewEnt, bInitialSnap, fieldName, bWasDemoJump )
{
	if(newVal )
	{
		self.meteor_fx = playfxontag( localClientNum, level._effect[ "perk_meteor" ], self, "tag_origin" );
	}
	else
	{
		if(isDefined(self.meteor_fx))
		{
			StopFX(localClientNum,self.meteor_fx);
			
		}
	}
}

function init_perk_machines_fx( localclientnum )
{
	if( !level.enable_magic )
	{
		return;
	}
	
	wait 0.1;

	machines = struct::get_array( "zm_perk_machine", "targetname" );
	array::thread_all(machines, &perk_start_up);
}

function perk_start_up()
{
	if(IsDefined(self.script_int))
	{
		power_zone = self.script_int;
		
		int = undefined;
		while( int != power_zone)
		{
			level waittill("power_on", int);	// Zombie power on.
		}			
	}	
	else //doesn't care if zone controlled. global
	{
		level waittill("power_on");	// Zombie power on.
	}	

	timer = 0;
	duration = 0.1;	
	
	while( true )
	{
		if ( IsDefined( level._custom_perks[ self.script_noteworthy ] ) && IsDefined( level._custom_perks[ self.script_noteworthy ].machine_light_effect ) )
		{
			self thread vending_machine_flicker_light( level._custom_perks[ self.script_noteworthy ].machine_light_effect, duration );
		}
		
		timer += duration;
		duration += 0.2;
		if( timer >= 3 )
		{
			break;
		}
		waitrealtime( duration );
	}
}

function vending_machine_flicker_light( fx_light, duration )
{		
	players = level.localPlayers;
	for( i = 0; i < players.size; i++ )
	{
		self thread play_perk_fx_on_client( i, fx_light, duration );
	}
}

function play_perk_fx_on_client( client_num, fx_light, duration )
{	
	fxObj = spawn( client_num, self.origin +( 0, 0, -50 ), "script_model" ); 
	fxobj setmodel( "tag_origin" ); 
	//fxobj.angles = self.angles;
	playfxontag( client_num, level._effect[fx_light], fxObj, "tag_origin" ); 	 
	waitrealtime( duration );
	fxobj delete();
}

