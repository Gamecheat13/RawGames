#using scripts\codescripts\struct;

#using scripts\shared\clientfield_shared;
#using scripts\shared\killstreaks_shared;
#using scripts\shared\popups_shared;
#using scripts\shared\scoreevents_shared;
#using scripts\shared\system_shared;
#using scripts\shared\util_shared;
#using scripts\shared\vehicle_shared;

#using scripts\mp\_util;
#using scripts\mp\killstreaks\_killstreaks;
#using scripts\mp\killstreaks\_killstreak_bundles;

  
                                                                                                  	  	                          	                                         	                     	                 	                                                                         	                       	                                                      	                                                      	                                                       	                                                                                                  	                                                           	                 	                                                                                                           	                	                                          	                                      	       	  	             	                                                     	                                                                             	                         	                                                                	                                                             	                                                             	                                                                                      	                                                         	                                                         	                                                               	                                                               	                                                   	                                                                	                                                     	                                                	                                                	                                                        	                                                                                                  	                                                                             	                                            	                                                                                    	                                          	                     	                                              	                                        	         	     
    	   	                                                                                                                                         	                                	                                                                                                                                                                                                                                                                                                                                                                    	        	     	             	    	   	               	                                              	                                                           	                               	                     	                                                                                                           	                                                                 	                                                              	                                                                                                              	                            	                                     	                                       	                                                                                                              	   	                  	       	                                                    	                   	                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                        	                                  	                                                                                        	           	                        	                                            	                                             	                                                   	                                                             	                                                         	                                                                    	                                                                                                                                                                                                    	                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                         	                                                              	                                                          	                                   	                                   	                                                    	                                       	                                           	     	                                                                                                                                                                                                                                                      	                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                     
                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                            	                           	                           	                                                                                                                                                                                                                                                            	                                                                                                                                                                                                                                                                                                                                                                                       

#namespace killstreak_hacking;

function enable_hacking( killstreakName, preHackFunction, postHackFunction )
{
	killstreak = self;
	
	killstreak.killstreak_hackedCallback = &_hacked_callback;
	killstreak.killstreakPreHackFunction = preHackFunction;
	killstreak.killstreakPostHackFunction = postHackFunction;
	killstreak.hackerToolInnerTimeMs = killstreak killstreak_bundles::get_hack_tool_inner_time();
	killstreak.hackerToolOuterTimeMs = killstreak killstreak_bundles::get_hack_tool_outer_time();
	killstreak.hackerToolInnerRadius = killstreak killstreak_bundles::get_hack_tool_inner_radius();
	killstreak.hackerToolOuterRadius = killstreak killstreak_bundles::get_hack_tool_outer_radius();
	killstreak.hackerToolRadius = killstreak.hackerToolOuterRadius;
	killstreak.killstreakHackLoopFX = killstreak killstreak_bundles::get_hack_loop_fx();
	killstreak.killstreakHackFX = killstreak killstreak_bundles::get_hack_fx();
	killstreak.killstreakHackScoreEvent = killstreak killstreak_bundles::get_hack_scoreevent();
	killstreak.killstreakHackLostLineOfSightLimitMs = killstreak killstreak_bundles::get_lost_line_of_sight_limit_msec();
	
	killstreak.killstreak_hackedProtection = killstreak killstreak_bundles::get_hack_protection();
}

function disable_hacking()
{
	killstreak = self;
	
	killstreak.killstreak_hackedCallback = undefined;
}

function hackerFX()
{
	killstreak = self;

	if ( isdefined( killstreak.killstreakHackFX ) && killstreak.killstreakHackFX  != "" )
	{
		playfxontag( killstreak.killstreakHackFX, killstreak, "tag_origin" );
	}
}

function hackerLoopFX()
{
	killstreak = self;

	if ( isdefined( killstreak.killstreakLoopHackFX ) && killstreak.killstreakLoopHackFX  != "" )
	{
		playfxontag( killstreak.killstreakLoopHackFX, killstreak, "tag_origin" );
	}
}

function private _hacked_callback( hacker )
{
	killstreak = self;
	
	originalOwner = killstreak.owner;
	
	if ( isdefined( killstreak.killstreakHackScoreEvent ) )
	{
		scoreevents::processscoreevent( killstreak.killstreakHackScoreEvent, hacker, originalOwner, level.weaponHackerTool );
	}
	
	if ( isdefined( killstreak.killstreakPreHackFunction ) )
	{
		killstreak thread [[killstreak.killstreakPreHackFunction]]( hacker );
	}
	
	killstreak killstreaks::configure_team_internal( hacker, true );
	killstreak clientfield::set( "enemyvehicle", 2 );
	if ( isdefined ( killstreak.killstreakHackFX ) ) 
	{
		killstreak thread hackerFX();		
	}
	if ( isdefined ( killstreak.killstreakHackLoopFX ) ) 
	{
		killstreak thread hackerLoopFX();		
	}

	if ( isdefined( killstreak.killstreakPostHackFunction ) )
	{
		killstreak thread [[killstreak.killstreakPostHackFunction]]( hacker );
	}

	killstreakType = killstreak.killstreakType;
	if ( isdefined ( killstreak.hackedKillstreakRef ) ) 
	{
		killstreakType = killstreak.hackedKillstreakRef;
	}

	level thread popups::DisplayKillstreakHackedTeamMessageToAll( killstreakType, hacker );
	
	killstreak _update_health( hacker );
}

function override_hacked_killstreak_reference( KillstreakRef ) 
{
	killstreak = self;
		
	killstreak.hackedKillstreakRef = KillstreakRef;
}

function get_hacked_timeout_duration_ms()
{
	killstreak = self;
	
	timeout = killstreak killstreak_bundles::get_hack_timeout();
	
		
	if ( !isdefined( timeout ) || timeout <= 0 )
	{
/# 
		assertmsg( "get_hacked_timeout_duration_ms(): Set \"" + killstreak.killstreakType + "\" to a greater than zero value, in the killstreaks GDT" );
#/
		return;
	}
	
	return timeout * 1000;	
}

function set_vehicle_drivable_time_starting_now( killstreak, duration_ms = (-1) ) // self == player
{
	if ( duration_ms == -1 )
		duration_ms = killstreak get_hacked_timeout_duration_ms();
	
	return self vehicle::set_vehicle_drivable_time_starting_now( duration_ms );
}

function _update_health( hacker )
{
	killstreak = self;	
	
	if ( isdefined ( killstreak.hackedHealthUpdateCallback ) )
	{
		killstreak [[ killstreak.hackedHealthUpdateCallback ]]( hacker );
	}
	else if ( IsSentient( killstreak ) )
	{
		hackedHealth = killstreak_bundles::get_hacked_health( killstreak.killstreakType );
		assert( isdefined( hackedHealth ) );
		if ( self.health > hackedhealth )
		{
			self.health = hackedhealth;	
		}
	}
	else
	{
		hacker iprintlnbold( "Hacked but no update of health occured" );
	}
}

/#
function killstreak_switch_team_end()
{
	killstreakEntity = self;
	killstreakEntity notify( "killstreak_switch_team_end" );	
}
	
function killstreak_switch_team( owner )
{
	killstreakEntity = self;
	killstreakEntity notify( "killstreak_switch_team_singleton" );
	killstreakEntity endon( "killstreak_switch_team_singleton" );
	killstreakEntity endon( "death" );

	//Init my dvar
	SetDvar("scr_killstreak_switch_team", "");

	while( true )
	{
		wait(0.5);

		//Grab my dvar every .5 seconds in the form of an int
		devgui_int = GetDvarint( "scr_killstreak_switch_team");

		//"" returns as zero with GetDvarInt
		if(devgui_int != 0)
		{
			// spawn a larry to be the opposing team
			team = "autoassign";
			
			if( isdefined( level.getEnemyTeam ) && isdefined( owner ) && isdefined( owner.team ) )
			{
				team = [[level.getEnemyTeam]]( owner.team );
			}

			if ( isdefined( level.devOnGetOrMakeBot ) )
			{
				player = [[level.devOnGetOrMakeBot]]( team );
			}
			
			if( !isdefined( player ) ) 
			{
				println("Could not add test client");
				wait 1;
				continue;
			}

			if ( !isdefined( killstreakEntity.killstreak_hackedCallback ) )
			{
/#
				iprintlnbold( "missing hacked callback" );
#/
				return;
			}
			killstreakEntity notify( "killstreak_hacked", player );
			killstreakEntity.previouslyHacked = true;
			killstreakEntity [[ killstreakEntity.killstreak_hackedCallback ]]( player );
			
			wait( 0.5 );
			SetDvar("scr_killstreak_switch_team", "0");
			return;
		}
	}
}
#/

