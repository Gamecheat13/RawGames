#using scripts\codescripts\struct;

#using scripts\shared\callbacks_shared;

#using scripts\zm\_zm_utility;

    	   	                                                                                                                                         	                                	                                                                                                                                                                                                                                                                                                                                                                    	        	     	             	    	   	               	                                              	                                                           	                               	                     	                                                                                                           	                                                                 	                                                              	                                                                                                              	                            	                                     	                                       	                                                                                                              	   	                  	       	                                                    	                   	                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                        	                                  	                                                                                        	           	                        	                                            	                                             	                                                   	                                                             	                                                         	                                                                    	                                                                                                                                                                                                    	                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                         	                                                              	                                                          	                                   	                                   	                                                    	                                       	                                           	     	                                                                                                                                                                                                                                                      	                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                     

#namespace zm_ffotd;

function main_start()
{
	mapname = toLower( GetDvarString( "mapname" ) );
	gametype = GetDvarString( "ui_gametype" );

	if ( "zm_prison" == toLower( GetDvarString( "mapname" ) ) && "zgrief" == GetDvarString( "ui_gametype" ) )
	{
		level.zbarrier_script_string_sets_collision = true;
	}
}


function main_end()
{
	callback::on_finalize_initialization( &force_navcomputer_trigger_think );

	level.original_melee_miss_func = level.melee_miss_func;
	level.melee_miss_func = &ffotd_melee_miss_func;
}

function force_navcomputer_trigger_think()
{
	if ( !IsDefined( level.zombie_include_buildables ) || !level.zombie_include_buildables.size )
	{
		return;
	}

	foreach ( buildable in level.zombie_include_buildables )
	{
		if ( "sq_common" == buildable.name )
		{
			if ( IsDefined( buildable.triggerThink ) )
			{
				level [[buildable.triggerThink]]();
				trigger_think_func = buildable.triggerThink;
				buildable.triggerThink = undefined; // this will keep it from running the triggerThink again in think_buildables

				level waittill( "buildables_setup" );

				buildable.triggerThink = trigger_think_func;
				return;
			}
		}
	}
}

//-------------------------------------------------------------------------------------------------
// EXPLOIT FIX ROUTINES
//-------------------------------------------------------------------------------------------------
function player_in_exploit_area( player_trigger_origin, player_trigger_radius )
{
	if( DistanceSquared( player_trigger_origin, self.origin ) < player_trigger_radius * player_trigger_radius )
	{
/#
		iprintlnbold( "player exploit detectect" );
#/
		return true;
	}
	return false;
}

function path_exploit_fix( zombie_trigger_origin, zombie_trigger_radius, zombie_trigger_height, player_trigger_origin, player_trigger_radius, zombie_goto_point )
{
	spawnflags = 1 + 8;	// SF_TOUCH_AI_AXIS | SF_TOUCH_NOTPLAYER

	zombie_trigger = Spawn( "trigger_radius", zombie_trigger_origin, spawnflags, zombie_trigger_radius, zombie_trigger_height );
	zombie_trigger SetTeamForTrigger( level.zombie_team );
	
/#
	thread debug_exploit( zombie_trigger_origin, zombie_trigger_radius, player_trigger_origin, player_trigger_radius, zombie_goto_point );
#/

	while ( 1 )
	{
		zombie_trigger waittill( "trigger", who );
		if ( !( isdefined( who.reroute ) && who.reroute ) )
		{
			who thread exploit_reroute( zombie_trigger, player_trigger_origin, player_trigger_radius, zombie_goto_point );
		}
	}
}

function exploit_reroute( zombie_trigger, player_trigger_origin, player_trigger_radius, zombie_goto_point )
{
	self endon( "death" );
	self.reroute = true;

	while ( 1 )
	{
		if ( self istouching( zombie_trigger ) )
		{
			player = self.favoriteenemy;
			if ( isdefined( player ) && player player_in_exploit_area( player_trigger_origin, player_trigger_radius ) )
			{
				self.reroute_origin = zombie_goto_point;
			}
			else
			{
				break;	//player not in correct spot
			}
		}
		else
		{
			break;	//zombie not in correct spot
		}

		wait( 0.2 );
	}

	self.reroute = false;
}

function debug_exploit( player_origin, player_radius, enemy_origin, enemy_radius, zombie_goto_point )
{
/#
	while ( IsDefined( self ) )
	{
		Circle( player_origin, player_radius, ( 0, 0, 1 ), false, true, 1 );
		Circle( enemy_origin, enemy_radius, ( 1, 0, 0 ), false, true, 1 );

		line(player_origin, enemy_origin, (1,0,0), 1);
		line(enemy_origin, zombie_goto_point, (1,1,0), 1);

		{wait(.05);};
	}
#/
}


function ffotd_melee_miss_func()
{
	if ( isdefined( self.enemy ) )
	{
		if ( isplayer( self.enemy ) && zm_utility::is_placeable_mine( self.enemy GetCurrentWeapon() ) )
		{
			dist_sq = DistanceSquared( self.enemy.origin, self.origin );
			melee_dist_sq = self.meleeAttackDist * self.meleeAttackDist;
			if ( dist_sq < melee_dist_sq )
			{
				self.enemy DoDamage( self.meleeDamage, self.origin, self, self, "none", "MOD_MELEE" );
				return;
			}
		}
	}
	if (IsDefined(level.original_melee_miss_func))
	{
		self [[level.original_melee_miss_func]]();
	}
}

