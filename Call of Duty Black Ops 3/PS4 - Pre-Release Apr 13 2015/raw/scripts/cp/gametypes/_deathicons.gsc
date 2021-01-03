#using scripts\codescripts\struct;

#using scripts\shared\callbacks_shared;
#using scripts\shared\system_shared;
#using scripts\shared\util_shared;

    	   	                                                                                                                         	                                                                                                                                                                                                                                                                                                                                                                    	        	     	             	    	   	                           	                               	                                	                                                              	                                                                                                              	                            	                                     	                                       	                                                               	   	                  	       	                                                    	                   	                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                       	                                                                                        	           	                        	                                            	                                             	                                                   	                                                             	                                                         	                                                                    	                                                                                                                                                                                                    	                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                     	                                                              	                                                          	                                   	                                   	                                                    	                                       

#using scripts\cp\gametypes\_globallogic_utils;

#precache( "material","headicon_dead");

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
	
	if ( GetDvarString( "ui_hud_showdeathicons" ) == "0" )
		return;
	if ( level.hardcoreMode )
		return;
	
	if ( isdefined( self.lastDeathIcon ) )
		self.lastDeathIcon destroy();
	
	newdeathicon = newTeamHudElem( team );
	newdeathicon.x = iconOrg[0];
	newdeathicon.y = iconOrg[1];
	newdeathicon.z = iconOrg[2] + 54;
	newdeathicon.alpha = .61;
	newdeathicon.archived = true;
	if ( level.splitscreen )
		newdeathicon setShader("headicon_dead", 14, 14);
	else
		newdeathicon setShader("headicon_dead", 7, 7);
	newdeathicon setwaypoint(true);
	
	self.lastDeathIcon = newdeathicon;
	
	newdeathicon thread destroy_slowly ( timeout );
}

function destroy_slowly( timeout )
{
	self endon("death");
	
	wait timeout;
	
	self fadeOverTime(1.0);
	self.alpha = 0;
	
	wait 1.0;
	self destroy();
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

