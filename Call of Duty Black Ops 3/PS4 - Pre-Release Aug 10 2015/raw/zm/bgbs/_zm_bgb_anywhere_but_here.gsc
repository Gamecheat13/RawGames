#using scripts\codescripts\struct;

#using scripts\shared\array_shared;
#using scripts\shared\flag_shared;
#using scripts\shared\system_shared;
#using scripts\shared\util_shared;

    	   	                                                                                                                                         	                                	                                                                                                                                                                                                                                                                                                                                                                    	        	     	             	    	   	               	                                              	                                                           	                               	                     	                                                                                                           	                                                                 	                                                              	                                                                                                              	                            	                                     	                                       	                                                                                                              	   	                  	       	                                                    	                   	                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                        	                                  	                                                                                        	           	                        	                                            	                                             	                                                   	                                                             	                                                         	                                                                    	                                                                                                                                                                                                    	                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                         	                                                              	                                                          	                                   	                                   	                                                    	                                       	                                           	     	                                                                                                                                                                                                                                                      	                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                     
                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                            	                           	                           	                                                                                                                                                                                                                                                            	                                                                                                                                                                                                                                                                                                                                                                                       

#using scripts\zm\_zm_bgb;
#using scripts\zm\_zm_powerups;
#using scripts\zm\_zm_utility;
#using scripts\zm\_zm_zonemgr;

                                                                                                             	     	                                                                                                                                                                
        

                                                                 
                                                                                                                               

#namespace zm_bgb_anywhere_but_here;

#precache( "fx", "zombie/fx_bgb_anywhere_but_here_teleport_zmb" );
#precache( "fx", "zombie/fx_bgb_anywhere_but_here_teleport_aoe_zmb" );
#precache( "fx", "zombie/fx_bgb_anywhere_but_here_teleport_aoe_kill_zmb" );


function autoexec __init__sytem__() {     system::register("zm_bgb_anywhere_but_here",&__init__,undefined,"bgb");    }

function __init__()
{
	if ( !( isdefined( level.bgb_in_use ) && level.bgb_in_use ) )
	{
		return;
	}

	level._effect["teleport_splash"] 	= "zombie/fx_bgb_anywhere_but_here_teleport_zmb";
	level._effect["teleport_aoe"]		= "zombie/fx_bgb_anywhere_but_here_teleport_aoe_zmb";
	level._effect["teleport_aoe_kill"]	= "zombie/fx_bgb_anywhere_but_here_teleport_aoe_kill_zmb";

	bgb::register( "zm_bgb_anywhere_but_here", "activated", 2, undefined, undefined, undefined, &activation );
}



function activation()
{
	// make sure player doesn't get smacked until can get bearings
	self.wasignoreme = self.ignoreme;
	self.ignoreme = true;

	// player instantly teleports to a random respawn point
	a_s_respawn_points = struct::get_array( "player_respawn_point", "targetname" );
	a_s_valid_respawn_points = [];
	foreach( s_respawn_point in a_s_respawn_points )
	{
		if( zm_utility::is_point_inside_active_zone( s_respawn_point.origin ) )
		{
			if ( !isdefined( a_s_valid_respawn_points ) ) a_s_valid_respawn_points = []; else if ( !IsArray( a_s_valid_respawn_points ) ) a_s_valid_respawn_points = array( a_s_valid_respawn_points ); a_s_valid_respawn_points[a_s_valid_respawn_points.size]=s_respawn_point;;
		}
	}

	s_respawn_point = array::random( a_s_valid_respawn_points );

	self SetOrigin( s_respawn_point.origin );
	self FreezeControls( true );
	
	v_return_pos = self.origin + ( 0, 0, 60 );
			
	a_ai = GetAITeamArray( level.zombie_team ); //	GetAIArray();
	a_closest = [];
	ai_closest = undefined;
	
	if ( a_ai.size )
	{
		// face the closest zombie
		a_closest = ArraySortClosest( a_ai, self.origin );
		
		foreach ( ai in a_closest )
		{
			n_trace_val = ai SightConeTrace( v_return_pos, self );
			
			if ( n_trace_val > .2 )
			{
				ai_closest = ai;
				break;
			}
		}
		
		if ( isdefined( ai_closest ) )
		{
			self SetPlayerAngles( VectorToAngles( ai_closest GetCentroid() - v_return_pos ) );
		}
	}

	wait 0.5; // short time after teleporting to play FX

	self Show();
	self PlaySound( "evt_beastmode_exit" );
	
	PlayFX( level._effect[ "teleport_splash" ], self.origin );
	PlayFX( level._effect[ "teleport_aoe" ], self.origin );
	
	// local concussive blast
	a_ai = GetAIArray();
	a_aoe_ai = ArraySortClosest( a_ai, self.origin, a_ai.size, 0, 200 );
	foreach ( ai in a_aoe_ai )
	{
		if ( IsActor( ai ) )
		{
			if ( ( ai.archetype === "zombie" ) )
				PlayFX( level._effect[ "teleport_aoe_kill" ], ai GetTagOrigin( "j_spineupper" ) );
			else
				PlayFX( level._effect[ "teleport_aoe_kill" ], ai.origin );
			ai.marked_for_recycle = 1;
			ai.has_been_damaged_by_player = false;
			ai DoDamage( ai.health + 1000, self.origin, self );
		}
	}
	
	wait 0.2;
	
	self FreezeControls( false );
	
	wait 3;
	
	self.ignoreme = self.wasignoreme;

	self bgb::do_one_shot_use();
}
