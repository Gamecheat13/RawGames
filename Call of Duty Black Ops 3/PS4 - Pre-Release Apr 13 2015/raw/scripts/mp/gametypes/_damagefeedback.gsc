#using scripts\codescripts\struct;

#using scripts\shared\callbacks_shared;
#using scripts\shared\gameobjects_shared;
#using scripts\shared\system_shared;
#using scripts\shared\util_shared;

    	   	                                                                                                                         	                                                                                                                                                                                                                                                                                                                                                                    	        	     	             	    	   	                           	                               	                                	                                                              	                                                                                                              	                            	                                     	                                       	                                                               	   	                  	       	                                                    	                   	                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                        	                                                                                        	           	                        	                                            	                                             	                                                   	                                                             	                                                         	                                                                    	                                                                                                                                                                                                    	                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                      	                                                              	                                                          	                                   	                                   	                                                    	                                       

#using scripts\mp\gametypes\_globallogic_utils;

#precache( "objective", "headicon_dead" );

#namespace deathicons;

function autoexec __init__sytem__() {     system::register("deathicons",&__init__,undefined,undefined);    }
	
function __init__()
{
	callback::on_start_gametype( &init );
	callback::on_connect( &on_player_connect );
}

function init()
{
	if ( !isdefined( level.ragdoll_override ) )
	{
		level.ragdoll_override = &ragdoll_override;	
	}
	if (!level.teambased)
		return;
}

function on_player_connect()
{
	self.selfDeathIcons = []; // icons that other people see which point to this player when he's dead
}

function update_enabled()
{
	//if (!self.enableDeathIcons)
	//	self removeOtherDeathIcons();
}

function add( entity, dyingplayer, team, timeout )
{
	if ( !level.teambased )
		return;
	
	iconOrg = entity.origin;
	
	dyingplayer endon("spawned_player");
	dyingplayer endon("disconnect");
	
	wait .05;
	util::WaitTillSlowProcessAllowed();
	
	assert(isdefined( level.teams[team] ));
	assert(isdefined( level.teamIndex[team] ));
	
	if ( GetDvarString( "ui_hud_showdeathicons" ) == "0" )
		return;

	if ( level.hardcoreMode )
		return;

	deathIconObjId = gameobjects::get_next_obj_id();
	objective_add( deathIconObjId, "active", iconOrg, &"headicon_dead" );
	objective_team( deathIconObjId, team );

	level thread destroy_slowly( timeout, deathIconObjId );
}

function destroy_slowly( timeout, deathIconObjId )
{
	wait timeout;
	
	objective_state( deathIconObjId, "done" );
	
	wait 1.0;

	objective_delete( deathIconObjId );
	gameobjects::release_obj_id( deathIconObjId );
}


function ragdoll_override( iDamage, sMeansOfDeath, sWeapon, sHitLoc, vDir, vAttackerOrigin, deathAnimDuration, eInflictor, ragdoll_jib, body )
{
	if ( sMeansOfDeath == "MOD_FALLING" && self IsOnGround() == true )
	{
		body startRagDoll();
		
		if ( !isDefined( self.switching_teams ) )
			thread add( body, self, self.team, 5.0 );
		return true;
	}
	return false;
}

