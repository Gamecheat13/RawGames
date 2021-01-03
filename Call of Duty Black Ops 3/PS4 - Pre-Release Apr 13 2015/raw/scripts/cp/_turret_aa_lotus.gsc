#using scripts\codescripts\struct;

#using scripts\shared\clientfield_shared;
#using scripts\shared\flag_shared;
#using scripts\shared\statemachine_shared;
#using scripts\shared\system_shared;
#using scripts\shared\turret_shared;
#using scripts\shared\util_shared;
#using scripts\shared\math_shared;
#using scripts\shared\vehicle_death_shared;
#using scripts\shared\vehicle_shared;

    	   	                                                                                                                         	                                                                                                                                                                                                                                                                                                                                                                    	        	     	             	    	   	                           	                               	                                	                                                              	                                                                                                              	                            	                                     	                                       	                                                               	   	                  	       	                                                    	                   	                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                       	                                                                                        	           	                        	                                            	                                             	                                                   	                                                             	                                                         	                                                                    	                                                                                                                                                                                                    	                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                     	                                                              	                                                          	                                   	                                   	                                                    	                                       
       

#namespace turret_aa_lotus;

function autoexec __init__sytem__() {     system::register("turret_aa_lotus",&__init__,undefined,undefined);    }

function __init__()
{
	vehicle::add_main_callback( "turret_aa_lotus", &turret_aa_lotus_init );
}

function turret_aa_lotus_init()
{
	self.default_pitch = -15;
	
	self thread main();
}

function isADS( player )
{
	return ( player playerADS() > 0.7 );
}

function main()
{
	self endon( "death" );

	while ( IsAlive( self ) )
	{
		driver = self GetSeatOccupant( 0 );

		if ( !isdefined( driver ) || !isalive( driver ) )
		{
			self waittill( "enter_vehicle" );
		}

		self thread thread_check_lock_on();

		self waittill( "exit_vehicle" );
		{wait(.05);};
	}
}

function thread_check_lock_on()
{
	self endon( "enter_vehicle" );
	self endon( "exit_vehicle" );

	driver = self GetSeatOccupant( 0 );

	while ( isdefined( driver ) )
	{
		if ( isPlayer( driver ) )
		{
			if ( isADS( driver ) )
			{
				vh_gunship = GetEnt( "gunship_vh", "targetname" );
				enemyarray = [];
				if ( !isdefined( enemyarray ) ) enemyarray = []; else if ( !IsArray( enemyarray ) ) enemyarray = array( enemyarray ); enemyarray[enemyarray.size]=vh_gunship;;

				aimForward = AnglesToForward( self GetTagAngles( "tag_aim" ) );
				aimOrigin = self GetTagOrigin( "tag_aim" );

				bestEnemy = undefined;
				bestDot = cos( 30 );
				foreach( enemy in enemyarray )
				{
					dirToEnemy = VectorNormalize( enemy.origin - aimOrigin );
					dot = VectorDot( aimForward, dirToEnemy );
					if ( dot > bestDot )
					{
						bestDot = dot;
						bestEnemy = enemy;
					}
				}

				if ( isdefined( driver ) && isdefined( bestEnemy ) )
				{
					driver WeaponLockStart( bestEnemy );
					lockSucceed = true;
					lockTime = 3;
					startTime = GetTime();

					maintainDot = cos( 25 );
					while ( GetTime() < startTime + lockTime * 1000 )
					{
						aimForward = AnglesToForward( self GetTagAngles( "tag_aim" ) );
						dirToEnemy = VectorNormalize( bestEnemy.origin - aimOrigin );
						dot = VectorDot( aimForward, dirToEnemy );

						percent = MapFloat( maintainDot, 1, 0, 1, dot );
						util::debug_line( driver.origin, bestEnemy.origin, ((1 - percent), percent, 0), 0.8, false, 1 );

						if ( dot < maintainDot )
						{
							lockSucceed = false;
							iPrintLn( "Turret: lock failed" );
							break;
						}

						{wait(.05);};
					}

					if ( lockSucceed )
					{
						iPrintLn( "Turret: lock succeed" );
						lockTime = 1;
						startTime = GetTime();
						while ( isdefined( driver ) && isdefined( bestEnemy ) && GetTime() < startTime + lockTime * 1000 )
						{
							util::debug_line( driver.origin, bestEnemy.origin, (0, 0, 1), 0.8, false, 1 );
							driver WeaponLockFinalize( bestEnemy );
							{wait(.05);};
						}
					}
				}
				else
				{
					iPrintln( "Turret: no target" );
				}
			}
		}

		{wait(.05);};
		driver = self GetSeatOccupant( 0 );
	}
}

function turret_off(angles)
{
	self vehicle::lights_off();
	self LaserOff();
	self vehicle::toggle_sounds( 0 );
	self vehicle::toggle_exhaust_fx( 0 );
	
	if(!isdefined(angles))
		angles = self GetTagAngles( "tag_flash" );
		
	target_vec = self.origin + AnglesToForward( ( 0, angles[1], 0 ) ) * 1000;
	target_vec = target_vec + ( 0, 0, -1700 );
	self SetTargetOrigin( target_vec );		
	self.off = true;
	if( !isdefined( self.emped ) )
	{
		self DisableAimAssist();
	}
}


function turret_on()
{
	self playsound ("veh_pallas_turret_boot");
	self vehicle::lights_on();
	self EnableAimAssist();
	self vehicle::toggle_sounds( 1 );
	self vehicle::toggle_exhaust_fx( 1 );
	self.off = undefined;
	self LaserOn();
}
