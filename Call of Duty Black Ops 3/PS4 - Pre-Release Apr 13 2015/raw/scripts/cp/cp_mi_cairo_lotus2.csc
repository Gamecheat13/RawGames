#using scripts\shared\callbacks_shared;
#using scripts\shared\clientfield_shared;
#using scripts\shared\scene_shared;
#using scripts\shared\trigger_shared;
#using scripts\shared\util_shared;

#using scripts\cp\_load;
#using scripts\cp\cp_mi_cairo_lotus2_fx;
#using scripts\cp\cp_mi_cairo_lotus2_sound;

 	               	                    

    	   	                                                                                                                         	                                                                                                                                                                                                                                                                                                                                                                    	        	     	             	    	   	                           	                               	                                	                                                              	                                                                                                              	                            	                                     	                                       	                                                               	   	                  	       	                                                    	                   	                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                       	                                                                                        	           	                        	                                            	                                             	                                                   	                                                             	                                                         	                                                                    	                                                                                                                                                                                                    	                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                     	                                                              	                                                          	                                   	                                   	                                                    	                                       
                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                            	                                                                                                                                                                                                                                                                                                                                                                                       

function main()
{
	init_clientfields();
	
	cp_mi_cairo_lotus2_fx::main();
	cp_mi_cairo_lotus2_sound::main();
	
	load::main();

	callback::on_spawned( &on_player_spawned );

	util::waitforclient( 0 );	// This needs to be called after all systems have been registered.
}

function init_clientfields()
{
	clientfield::register( "toplayer", "sand_fx", 1, 1, "int", &player_sand_fx_logic, !true, !true );
}

// self == player
function player_sand_fx_logic( localClientNum, oldVal, newVal, bNewEnt, bInitialSnap, fieldName, bWasDemoJump )
{
	if ( newVal == 1 )
	{
		self thread player_sand_fx_loop( localClientNum );
	}
	else
	{
		self notify( "sand_fx_stop" );
		
		if ( IsDefined( self.n_fx_id ) )
		{
			DeleteFX( localClientNum, self.n_fx_id, true );
		}
	}
}

// self == player
function player_sand_fx_loop( localClientNum )
{
	self endon( "disconnect" );
	self endon( "entityshutdown" );
	self endon( "sand_fx_stop" );

	while ( true )
	{	
		v_eye = self GetEye();
		self.n_fx_id = PlayFX( localClientNum, level._effect[ "player_sand" ], v_eye );
		
		wait 0.1;
	}
}

function on_player_spawned( localClientNum )
{
	level thread mobile_shop_2_ride( localClientNum );
	
	level thread ambient_skybridge( localClientNum );
}

function mobile_shop_2_ride( localClientNum )
{
	// threads for clientside triggers
	for( i = 135; i <= 165; i += 5 )
	{
		str_triggername = "mobile_shop_2_floor_" + i;
		e_trigger = GetEnt( localClientNum, str_triggername, "targetname" );
		e_trigger._localClientNum = localClientNum;
		e_trigger waittill( "trigger", trigPlayer );
		level thread trig_mobile_shop_2( e_trigger );
	}
}

function trig_mobile_shop_2( e_trigger )
{
	level thread scene::play( e_trigger.targetname, "targetname" );
	wait 5;
	level thread scene::stop( e_trigger.targetname, "targetname" );
}

function ambient_skybridge( localClientNum )
{
	e_trigger = GetEnt( localClientNum, "ambient_skybridge_siege_02", "targetname" );
	e_trigger waittill( "trigger" );
	level thread scene::play( "ambient_skybridge_siege_02", "targetname" );
	
	e_trigger = GetEnt( localClientNum, "ambient_skybridge_siege_03", "targetname" );
	e_trigger waittill( "trigger" );
	level thread scene::play( "ambient_skybridge_siege_03", "targetname" );
}
