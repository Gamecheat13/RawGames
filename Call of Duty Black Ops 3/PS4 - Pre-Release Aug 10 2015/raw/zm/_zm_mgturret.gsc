#using scripts\codescripts\struct;

    	   	                                                                                                                                         	                                	                                                                                                                                                                                                                                                                                                                                                                    	        	     	             	    	   	               	                                              	                                                           	                               	                     	                                                                                                           	                                                                 	                                                              	                                                                                                              	                            	                                     	                                       	                                                                                                              	   	                  	       	                                                    	                   	                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                        	                                  	                                                                                        	           	                        	                                            	                                             	                                                   	                                                             	                                                         	                                                                    	                                                                                                                                                                                                    	                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                         	                                                              	                                                          	                                   	                                   	                                                    	                                       	                                           	     	                                                                                                                                                                                                                                                      	                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                     

function main()
{
	// TODO: what does this main do exactly?
	// TODO: change this dvar name to turret or something; really? we have a dvar named mg42
	if( GetDvarString( "mg42" ) == "" )
	{
		SetDvar( "mgTurret", "off" ); 
	}

	level.magic_distance = 24; 

	turretInfos = getEntArray( "turretInfo", "targetname" );
	for( index = 0; index < turretInfos.size; index++ )
	{
		turretInfos[index] Delete();
	}
}

function set_difficulty( difficulty )
{
	init_turret_difficulty_settings();

	turrets = GetEntArray( "misc_turret", "classname" ); 

	for( index = 0; index < turrets.size; index++ )
	{
		if( isdefined( turrets[index].script_skilloverride ) )
		{
			switch( turrets[index].script_skilloverride )
			{
			case "easy":
				difficulty = "easy"; 
				break; 
			case "medium":
				difficulty = "medium"; 
				break; 
			case "hard":
				difficulty = "hard"; 
				break; 
			case "fu":
				difficulty = "fu"; 
				break; 
			default:
				continue; 
			}
		}
		turret_set_difficulty( turrets[index], difficulty ); 
	}
}

function init_turret_difficulty_settings()
{
	level.mgTurretSettings["easy"]["convergenceTime"] = 2.5; 
	level.mgTurretSettings["easy"]["suppressionTime"] = 3.0; 
	level.mgTurretSettings["easy"]["accuracy"] = 0.38; 
	level.mgTurretSettings["easy"]["aiSpread"] = 2; 
	level.mgTurretSettings["easy"]["playerSpread"] = 0.5; 	

	level.mgTurretSettings["medium"]["convergenceTime"] = 1.5; 
	level.mgTurretSettings["medium"]["suppressionTime"] = 3.0; 
	level.mgTurretSettings["medium"]["accuracy"] = 0.38; 
	level.mgTurretSettings["medium"]["aiSpread"] = 2; 
	level.mgTurretSettings["medium"]["playerSpread"] = 0.5; 	

	level.mgTurretSettings["hard"]["convergenceTime"] = .8; 
	level.mgTurretSettings["hard"]["suppressionTime"] = 3.0; 
	level.mgTurretSettings["hard"]["accuracy"] = 0.38; 
	level.mgTurretSettings["hard"]["aiSpread"] = 2; 
	level.mgTurretSettings["hard"]["playerSpread"] = 0.5; 	

	level.mgTurretSettings["fu"]["convergenceTime"] = .4; 
	level.mgTurretSettings["fu"]["suppressionTime"] = 3.0; 
	level.mgTurretSettings["fu"]["accuracy"] = 0.38; 
	level.mgTurretSettings["fu"]["aiSpread"] = 2; 
	level.mgTurretSettings["fu"]["playerSpread"] = 0.5; 	
}

function turret_set_difficulty( turret, difficulty )
{
	turret.convergenceTime = level.mgTurretSettings[difficulty]["convergenceTime"]; 
	turret.suppressionTime = level.mgTurretSettings[difficulty]["suppressionTime"]; 
	turret.accuracy = level.mgTurretSettings[difficulty]["accuracy"]; 
	turret.aiSpread = level.mgTurretSettings[difficulty]["aiSpread"]; 
	turret.playerSpread = level.mgTurretSettings[difficulty]["playerSpread"]; 	
}

function turret_suppression_fire( targets ) // self == turret
{
	self endon( "death" ); 
	self endon( "stop_suppression_fire" ); 
	if( !isdefined( self.suppresionFire ) )
	{
		self.suppresionFire = true; 
	}

	for( ;; )
	{
		while( self.suppresionFire )
		{
			self SetTargetEntity( targets[RandomInt( targets.size )] ); 
			wait( 2 + RandomFloat( 2 ) ); 
		}

		self ClearTargetEntity(); 
		while( !self.suppresionFire )
		{
			wait( 1 ); 
		}
	}
}

// returns a time frame for the burst fire depending on the setting parameter
function burst_fire_settings( setting )
{
	if( setting == "delay" )
	{
		return 0.2; 
	}
	else if( setting == "delay_range" )
	{
		return 0.5; 
	}
	else if( setting == "burst" )
	{
		return 0.5; 
	}
	else if( setting == "burst_range" )
	{
		return 4; 
	}
}

// makes the turret burst fire with delays in between
function burst_fire( turret, manual_target )
{
	turret endon( "death" ); // MikeD: Incase we delete the turret.
	turret endon( "stopfiring" ); 
	self endon( "stop_using_built_in_burst_fire" ); 


	if( isdefined( turret.script_delay_min ) )
	{
		turret_delay = turret.script_delay_min; 
	}
	else
	{
		turret_delay = burst_fire_settings( "delay" ); 
	}

	if( isdefined( turret.script_delay_max ) ) 
	{
		turret_delay_range = turret.script_delay_max - turret_delay; 
	}
	else
	{
		turret_delay_range = burst_fire_settings( "delay_range" ); 
	}

	if( isdefined( turret.script_burst_min ) )
	{
		turret_burst = turret.script_burst_min; 
	}
	else
	{
		turret_burst = burst_fire_settings( "burst" ); 
	}

	if( isdefined( turret.script_burst_max ) ) 
	{
		turret_burst_range = turret.script_burst_max - turret_burst; 
	}
	else
	{
		turret_burst_range = burst_fire_settings( "burst_range" ); 
	}

	while( 1 )
	{	
		turret StartFiring(); 
		


		if( isdefined( manual_target ) )
		{
			turret thread random_spread( manual_target ); 
		}
		turret do_shoot();

		wait( turret_burst + RandomFloat( turret_burst_range ) ); 

		turret StopShootTurret();

		turret StopFiring(); 

		wait( turret_delay + RandomFloat( turret_delay_range ) ); 
	}
}

// auto targeting and burst firing at the targets
function burst_fire_unmanned() // self == turret
{
	self notify( "stop_burst_fire_unmanned" );
	self endon( "stop_burst_fire_unmanned" );
	self endon( "death" ); 
	self endon( "remote_start" );
	level endon( "game_ended" );

	if ( isdefined( self.controlled ) && self.controlled )
	{
		return;
	}

	if( isdefined( self.script_delay_min ) )
	{
		turret_delay = self.script_delay_min; 
	}
	else
	{
		turret_delay = burst_fire_settings( "delay" ); 
	}

	if( isdefined( self.script_delay_max ) ) 
	{
		turret_delay_range = self.script_delay_max - turret_delay; 
	}
	else
	{
		turret_delay_range = burst_fire_settings( "delay_range" ); 
	}

	if( isdefined( self.script_burst_min ) )
	{
		turret_burst = self.script_burst_min; 
	}
	else
	{
		turret_burst = burst_fire_settings( "burst" ); 
	}

	if( isdefined( self.script_burst_max ) ) 
	{
		turret_burst_range = self.script_burst_max - turret_burst; 
	}
	else
	{
		turret_burst_range = burst_fire_settings( "burst_range" ); 
	}

	pauseUntilTime = GetTime(); 
	turretState = "start";
	// SRS 05/02/07 - added this for link_turrets() so we can accurately tell when the function is
	//  actually firing or just waiting between bursts (IsFiringTurret() returns true the whole time)
	self.script_shooting = false;

	for( ;; )
	{
		if( isdefined( self.manual_targets ) )
		{
			self ClearTargetEntity();
			self SetTargetEntity( self.manual_targets[RandomInt( self.manual_targets.size )] );
		}

		duration = ( pauseUntilTime - GetTime() ) * 0.001; 
		if( self IsFiringTurret() && (duration <= 0) )
		{
			if( turretState != "fire" )
			{
				turretState = "fire";
				self playsound ("mpl_turret_alert"); // Play a state change sound CDC						

				self thread do_shoot();
				self.script_shooting = true;
			}

			duration = turret_burst + RandomFloat( turret_burst_range ); 

			//println( "fire duration: ", duration ); 
			self thread turret_timer( duration );

			self waittill( "turretstatechange" ); // code or script

			self.script_shooting = false;

			duration = turret_delay + RandomFloat( turret_delay_range ); 
			//println( "stop fire duration: ", duration ); 

			pauseUntilTime = GetTime() + Int( duration * 1000 ); 
		}
		else
		{
			if( turretState != "aim" )
			{
				turretState = "aim"; 
			}

			//println( "aim duration: ", duration ); 
			self thread turret_timer( duration );

			// TODO: make the turret scan back and forth

			self waittill( "turretstatechange" ); // code or script
		}
	}
}


function avoid_synchronization(time)
{
	if (!isdefined(level._zm_mgturret_firing))
		level._zm_mgturret_firing = 0;
	level._zm_mgturret_firing++;
	wait time;
	level._zm_mgturret_firing--;
}



function do_shoot()
{
	self endon( "death" ); 
	self endon( "turretstatechange" ); // code or script

	for( ;; )
	{
		while (( isdefined( level._zm_mgturret_firing ) && level._zm_mgturret_firing ))
			wait 0.1;
		thread avoid_synchronization(0.1);
		//ent = self GetTargetEntity(); 
		//ent DoDamage( ent.health + 666, ent.origin );
		self ShootTurret();
		wait( 0.112 ); 
	}
}

// waits for a duration and sends a turret state change notify
function turret_timer( duration )
{
	if( duration <= 0 )
	{
		return; 
	}

	self endon( "turretstatechange" ); // code

	//println( "start turret timer" ); 

	wait( duration ); 
	if( isdefined( self ) )
	{
		self notify( "turretstatechange" ); 
	}

	//println( "end turret timer" ); 
}

function random_spread( ent )
{
	self endon( "death" ); 

	self notify( "stop random_spread" ); 
	self endon( "stop random_spread" ); 

	self endon( "stopfiring" ); 
	self SetTargetEntity( ent ); 

	self.manual_target = ent;

	while( 1 )
	{

		// SCRIPTER_MOD
		// MikeD( 3/21/2007 ): No more level.player
		//		if( ent == level.player )
		//			ent.origin = self.manual_target GetOrigin(); 
		//		else
		//			ent.origin = self.manual_target.origin; 

		if( IsPlayer( ent ) )
		{
			ent.origin = self.manual_target GetOrigin(); 
		}
		else
		{
			ent.origin = self.manual_target.origin; 
		}

		ent.origin += ( 20 - RandomFloat( 40 ), 20 - RandomFloat( 40 ), 20 - RandomFloat( 60 ) ); 
		wait( 0.2 ); 
	}
}