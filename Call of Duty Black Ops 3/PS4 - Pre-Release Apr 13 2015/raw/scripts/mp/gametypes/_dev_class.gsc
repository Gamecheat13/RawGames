#using scripts\codescripts\struct;

#using scripts\shared\callbacks_shared;
#using scripts\shared\clientfield_shared;
#using scripts\shared\gameobjects_shared;
#using scripts\shared\hostmigration_shared;
#using scripts\shared\objpoints_shared;
#using scripts\shared\scoreevents_shared;
#using scripts\shared\system_shared;
#using scripts\shared\util_shared;

    	   	                                                                                                                         	                                                                                                                                                                                                                                                                                                                                                                    	        	     	             	    	   	                           	                               	                                	                                                              	                                                                                                              	                            	                                     	                                       	                                                               	   	                  	       	                                                    	                   	                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                        	                                                                                        	           	                        	                                            	                                             	                                                   	                                                             	                                                         	                                                                    	                                                                                                                                                                                                    	                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                      	                                                              	                                                          	                                   	                                   	                                                    	                                       

#using scripts\mp\_util;
#using scripts\mp\gametypes\_globallogic_audio;
#using scripts\mp\gametypes\_globallogic_score;
#using scripts\mp\gametypes\_hostmigration;

#namespace dogtags;

#precache( "fx", "_t6/maps/mp_maps/fx_mp_kill_confirmed_vanish" );

//REGISTER_SYSTEM( "dogtags", &__init__, undefined )
//	
//function __init__()
//{
//	callback::on_start_gametype( &init );
//	
//	level.shellshockOnPlayerDamage = &on_damage;
//}

function init()
{
	level.antiBoostDistance = GetGametypeSetting( "antiBoostDistance" );
	level.dogtags = [];
	level.dogtag_fx["vanish"] = "_t6/maps/mp_maps/fx_mp_kill_confirmed_vanish";
}

function spawn_dog_tag( victim, attacker, on_use_function, objectives_for_attacker_only )
{
	if ( isdefined( level.dogtags[victim.entnum] ) )
	{
		PlayFx( level.dogtag_fx["vanish"], level.dogtags[victim.entnum].curOrigin );
		level.dogtags[victim.entnum] notify( "reset" );
	}
	else
	{
		visuals[0] = spawn( "script_model", (0,0,0) );
		visuals[0] setModel( "p7_dogtags_enemy" );
		visuals[1] = spawn( "script_model", (0,0,0) );
		visuals[1] setModel( "p7_dogtags_friendly" );
		
		trigger = spawn( "trigger_radius", (0,0,0), 0, 32, 32 );
		
		level.dogtags[victim.entnum] = gameobjects::create_use_object( "any", trigger, visuals, (0,0,16) );
		
		level.dogtags[victim.entnum] gameobjects::set_use_time( 0 );
		level.dogtags[victim.entnum].onUse =&onUse;
		level.dogtags[victim.entnum].custom_onUse = on_use_function;
		level.dogtags[victim.entnum].victim = victim;
		level.dogtags[victim.entnum].victimTeam = victim.team;
		
		level thread clear_on_victim_disconnect( victim );
		victim thread team_updater( level.dogtags[victim.entnum] );

		if ( objectives_for_attacker_only )
		{
			//	we don't need these
			foreach( team in level.teams )
			{
				if ( team != attacker.team )
				{
					objective_delete( level.dogtags[victim.entnum].objID[team] );
					gameobjects::release_obj_id( level.dogtags[victim.entnum].objID[team] );
					objpoints::delete( level.dogtags[victim.entnum].objPoints[team] );
				}
			}
			
			objective_add( level.dogtags[victim.entnum].objId[attacker.team], "invisible", (0,0,0) );
			objective_icon( level.dogtags[victim.entnum].objId[attacker.team], "waypoint_dogtags" );	
			objective_setcolor( level.dogtags[victim.entnum].objId[attacker.team], &"EnemyOrange" );
		}
		else
		{
			foreach( team in level.teams )
			{
				objective_add( level.dogtags[victim.entnum].objId[team], "invisible", (0,0,0) );
				objective_icon( level.dogtags[victim.entnum].objId[team], "waypoint_dogtags" );	
				Objective_Team( level.dogtags[victim.entnum].objId[team], team );
				if ( team == attacker.team )
				{
					objective_setcolor( level.dogtags[victim.entnum].objId[attacker.team], &"EnemyOrange" );
				}
				else
				{
					objective_setcolor( level.dogtags[victim.entnum].objId[attacker.team], &"FriendlyBlue" );
				}
			}
		}
	}	
	
	pos = victim.origin + (0,0,14);
	level.dogtags[victim.entnum].curOrigin = pos;
	level.dogtags[victim.entnum].trigger.origin = pos;
	level.dogtags[victim.entnum].visuals[0].origin = pos;
	level.dogtags[victim.entnum].visuals[1].origin = pos;
	
	level.dogtags[victim.entnum].visuals[0]	DontInterpolate();
	level.dogtags[victim.entnum].visuals[1]	DontInterpolate();
	
	level.dogtags[victim.entnum] gameobjects::allow_use( "any" );	
			
	level.dogtags[victim.entnum].visuals[0] thread show_to_team( level.dogtags[victim.entnum], attacker.team );
	level.dogtags[victim.entnum].visuals[1] thread show_to_enemy_teams( level.dogtags[victim.entnum], attacker.team );
	
	level.dogtags[victim.entnum].attacker = attacker;
	level.dogtags[victim.entnum].attackerTeam = attacker.team;
	level.dogtags[victim.entnum].unreachable = undefined;
	level.dogtags[victim.entnum].tacInsert = false;
	//level.dogtags[victim.entnum] thread time_out( victim );
	
	foreach( team in level.teams )
	{
		if ( IsDefined( level.dogtags[victim.entnum].objId[team] ) )
		{
			objective_position( level.dogtags[victim.entnum].objId[team], pos );
			objective_state( level.dogtags[victim.entnum].objId[team], "active" );
		}
	}
	
	if ( objectives_for_attacker_only )
	{
		Objective_SetInvisibleToAll( level.dogtags[victim.entnum].objId[attacker.team] );

		if ( IsPlayer( attacker ) )
			Objective_SetVisibleToPlayer( level.dogtags[victim.entnum].objId[attacker.team], attacker );
	}	

	//PlaySoundAtPosition( "mpl_killconfirm_tags_drop", pos );
	
	level.dogtags[victim.entnum] thread bounce();
	level notify( "dogtag_spawned" );
}


function show_to_team( gameObject, show_team )
{
	self show();

	foreach( team in level.teams )
	{
		self HideFromTeam( team );
	}
	self ShowToTeam( show_team );
}

function show_to_enemy_teams( gameObject, friend_team )
{
	self show();

	foreach( team in level.teams )
	{
		self ShowToTeam( team );
	}
	self HideFromTeam( friend_team );
}

function onUse( player )
{
	self.visuals[0] playSound( "mpl_killconfirm_tags_pickup" );
	tacInsertBoost = false;
	
	//	friendly pickup
	if ( player.team != self.attackerTeam )
	{
		player AddPlayerStat( "KILLSDENIED", 1 );
		player RecordGameEvent("return");

		if ( self.victim == player  )
		{
			if ( self.tacInsert == false )
			{
				event = "retrieve_own_tags";
			}
			else
			{
				tacInsertBoost = true;
			}
		}
		else
		{
			event = "kill_denied";
		}
				
		if ( !tacInsertBoost )
		{
			player.pers["killsdenied"]++;
			player.killsdenied = player.pers["killsdenied"];
		}
	}
	else
	{
		event = "kill_confirmed";

		player AddPlayerStat( "KILLSCONFIRMED", 1 );
		player RecordGameEvent("capture");

		if ( isdefined( self.attacker ) && self.attacker != player )
		{	
			self.attacker onPickup( "teammate_kill_confirmed" );
		}
	}
	
	if ( !tacInsertBoost && isdefined( player ) )
	{
		player onPickup( event );
	}
	
	[[self.custom_onUse]]( player );
	
	//	do all this at the end now so the location doesn't change before playing the sound on the entity
	self reset_tags();		
}


function reset_tags()
{
	self.attacker = undefined;
	self.unreachable = undefined;
	self notify( "reset" );
	self.visuals[0] hide();
	self.visuals[1] hide();
	self.curOrigin = (0,0,1000);
	self.trigger.origin = (0,0,1000);
	self.visuals[0].origin = (0,0,1000);
	self.visuals[1].origin = (0,0,1000);
	self.tacInsert = false;
	self gameobjects::allow_use( "none" );	
	
	foreach( team in level.teams )
	{
		objective_state( self.objId[team], "invisible" );	
	}
}


function onPickup( event )
{
	scoreevents::processScoreEvent( event, self );
}


function clear_on_victim_disconnect( victim )
{
	level endon( "game_ended" );	
	
	guid = victim.entnum;
	victim waittill( "disconnect" );
	
	if ( isdefined( level.dogtags[guid] ) )
	{
		//	block further use
		level.dogtags[guid] gameobjects::allow_use( "none" );
		
		//	play vanish effect, reset, and wait for reset to process
		PlayFx( level.dogtag_fx["vanish"], level.dogtags[guid].curOrigin );
		level.dogtags[guid] notify( "reset" );		
		{wait(.05);};
		
		//	sanity check before removal
		if ( isdefined( level.dogtags[guid] ) )
		{
			//	delete objective and visuals
			foreach( team in level.teams )
			{
					objective_delete( level.dogtags[guid].objId[team] );
			}
			level.dogtags[guid].trigger delete();
			for ( i=0; i<level.dogtags[guid].visuals.size; i++ )
				level.dogtags[guid].visuals[i] delete();
			level.dogtags[guid] notify ( "deleted" );
			
			//	remove from list
			level.dogtags[guid] = undefined;		
		}	
	}	
}

function on_spawn_player()
{
	if ( level.rankedMatch || level.leagueMatch )
	{
		if ( isdefined(self.tacticalInsertionTime) && self.tacticalInsertionTime + 100 > GetTime() )
		{
			minDist = level.antiBoostDistance;
			minDistSqr = minDist * minDist;
			
			distSqr = DistanceSquared( self.origin, level.dogtags[self.entnum].curOrigin );
			
			// tac insert spawn
			if ( distSqr < minDistSqr )
			{
				level.dogtags[self.entnum].tacInsert = true;
			}
		}
	}
}

function team_updater( tags )
{
	level endon( "game_ended" );
	self endon( "disconnect" );
	
	while( true )
	{
		self waittill( "joined_team" );
		
		tags.victimTeam = self.team;
		tags reset_tags();
	}
}

function time_out( victim )
{
	level  endon( "game_ended" );
	victim endon( "disconnect" );
	self notify( "timeout" );
	self endon( "timeout" );
	
	level hostmigration::waitLongDurationWithHostMigrationPause( 30.0 );
	
	self.visuals[0] hide();
	self.visuals[1] hide();
	self.curOrigin = (0,0,1000);
	self.trigger.origin = (0,0,1000);
	self.visuals[0].origin = (0,0,1000);
	self.visuals[1].origin = (0,0,1000);
	self.tacInsert = false;
	self gameobjects::allow_use( "none" );			
}

function bounce()
{
	level endon( "game_ended" );
	self endon( "reset" );	
	
	bottomPos = self.curOrigin;
	topPos = self.curOrigin + (0,0,12);
	
	while( true )
	{
		self.visuals[0] moveTo( topPos, 0.5, 0.15, 0.15 );
		self.visuals[0] rotateYaw( 180, 0.5 );
		self.visuals[1] moveTo( topPos, 0.5, 0.15, 0.15 );
		self.visuals[1] rotateYaw( 180, 0.5 );
		
		wait( 0.5 );
		
		self.visuals[0] moveTo( bottomPos, 0.5, 0.15, 0.15 );
		self.visuals[0] rotateYaw( 180, 0.5 );	
		self.visuals[1] moveTo( bottomPos, 0.5, 0.15, 0.15 );
		self.visuals[1] rotateYaw( 180, 0.5 );
		
		wait( 0.5 );		
	}
}


