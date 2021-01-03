#using scripts\codescripts\struct;

#using scripts\shared\callbacks_shared;
#using scripts\shared\challenges_shared;
#using scripts\shared\clientfield_shared;
#using scripts\shared\killcam_shared;
#using scripts\shared\hud_util_shared;
#using scripts\shared\system_shared;
#using scripts\shared\util_shared;
#using scripts\shared\weapons\_tacticalinsertion;

    	   	                                                                                                                                         	                                	                                                                                                                                                                                                                                                                                                                                                                    	        	     	             	    	   	               	                                              	                                                           	                               	                     	                                                                                                           	                                                                 	                                                              	                                                                                                              	                            	                                     	                                       	                                                                                                              	   	                  	       	                                                    	                   	                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                        	                                  	                                                                                        	           	                        	                                            	                                             	                                                   	                                                             	                                                         	                                                                    	                                                                                                                                                                                                    	                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                         	                                                              	                                                          	                                   	                                   	                                                    	                                       	                                           	     	                                                                                                                                                                                                                                                      	                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                     
                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                            	                           	                           	                                                                                                                                                                                                                                                            	                                                                                                                                                                                                                                                                                                                                                                                       

#using scripts\mp\gametypes\_globallogic;
#using scripts\mp\gametypes\_globallogic_spawn;
#using scripts\mp\gametypes\_spectating;

#using scripts\mp\_challenges;
#using scripts\mp\_util;

#precache( "material", "white" );
#precache( "string", "PLATFORM_PRESS_TO_SKIP" );
#precache( "string", "PLATFORM_PRESS_TO_RESPAWN" );
#precache( "eventstring", "pre_killcam_transition" );
#precache( "eventstring", "post_killcam_transition" );

#namespace killcam;

function autoexec __init__sytem__() {     system::register("killcam",&__init__,undefined,undefined);    }
	
function __init__()
{
	callback::on_start_gametype( &init );
	// clientuimodels are registered client-side in raw/ui/uieditor/clientfieldmodels.lua
	clientfield::register( "clientuimodel", "hudItems.killcamAllowRespawn", 1, 1, "int" );
}

function init()
{

	level.killcam = GetGametypeSetting( "allowKillcam" );
	level.finalkillcam = GetGametypeSetting( "allowFinalKillcam" );
	
	init_final_killCam();
}

function init_final_killCam()
{
	level.finalKillcamSettings = [];

	init_final_killCam_team( "none" );
	
	foreach( team in level.teams )
	{
		init_final_killCam_team( team );
	}
	
	level.finalKillCam_winner = undefined;
}

function init_final_killCam_team( team )
{
	level.finalKillcamSettings[team] = SpawnStruct();

	clear_final_killcam_team( team );
}

function clear_final_killcam_team( team )
{
	level.finalKillcamSettings[team].spectatorclient = undefined;
	level.finalKillcamSettings[team].weapon = undefined;
	level.finalKillcamSettings[team].deathTime = undefined;
	level.finalKillcamSettings[team].deathTimeOffset = undefined;
	level.finalKillcamSettings[team].offsettime = undefined;
	level.finalKillcamSettings[team].killcam_entity_info = undefined;
	level.finalKillcamSettings[team].targetentityindex = undefined;
	level.finalKillcamSettings[team].perks = undefined;
	level.finalKillcamSettings[team].killstreaks = undefined;
	level.finalKillcamSettings[team].attacker = undefined;
}

function record_settings( spectatorclient, targetentityindex, weapon, deathTime, deathTimeOffset, offsettime, killcam_entity_info, perks, killstreaks, attacker )
{
	if( level.teambased && isdefined( attacker ) && isdefined( attacker.team ) && isdefined( level.teams[attacker.team] ) )
	{
		team = attacker.team;
		
		level.finalKillcamSettings[ team ].spectatorclient = spectatorclient;
		level.finalKillcamSettings[ team ].weapon = weapon;
		level.finalKillcamSettings[ team ].deathTime = deathTime;
		level.finalKillcamSettings[ team ].deathTimeOffset = deathTimeOffset;
		level.finalKillcamSettings[ team ].offsettime = offsettime;
		level.finalKillcamSettings[ team ].killcam_entity_info = killcam_entity_info;
		level.finalKillcamSettings[ team ].targetentityindex = targetentityindex;
		level.finalKillcamSettings[ team ].perks = perks;
		level.finalKillcamSettings[ team ].killstreaks = killstreaks;
		level.finalKillcamSettings[ team ].attacker = attacker;
	}

	level.finalKillcamSettings[ "none" ].spectatorclient = spectatorclient;
	level.finalKillcamSettings[ "none" ].weapon = weapon;
	level.finalKillcamSettings[ "none" ].deathTime = deathTime;
	level.finalKillcamSettings[ "none" ].deathTimeOffset = deathTimeOffset;
	level.finalKillcamSettings[ "none" ].offsettime = offsettime;
	level.finalKillcamSettings[ "none" ].killcam_entity_info = killcam_entity_info;
	level.finalKillcamSettings[ "none" ].targetentityindex = targetentityindex;
	level.finalKillcamSettings[ "none" ].perks = perks;
	level.finalKillcamSettings[ "none" ].killstreaks = killstreaks;
	level.finalKillcamSettings[ "none" ].attacker = attacker;
}

function erase_final_killcam()
{
	clear_final_killcam_team( "none" );
	
	foreach( team in level.teams )
	{
		clear_final_killcam_team( team );
	}
	
	level.finalKillCam_winner = undefined;
}

function final_killcam_waiter()
{
	if ( !isdefined( level.finalKillCam_winner ) )
		return false;
	
	level waittill( "final_killcam_done" );

	return true;
}

function post_round_final_killcam()
{
	if ( isdefined( level.sidebet ) && level.sidebet )
	{
		return;
	}
	level notify( "play_final_killcam" );
	globallogic::resetOutcomeForAllPlayers();
	final_killcam_waiter();	
}

function do_final_killcam()
{
	level waittill ( "play_final_killcam" );
	
	LUINotifyEvent( &"pre_killcam_transition" );
	wait( 1.0 );

	level.inFinalKillcam = true;

	winner = "none";
	if( isdefined( level.finalKillCam_winner ) )
	{
		winner = level.finalKillCam_winner;
	}
	 
	if( !isdefined( level.finalKillcamSettings[ winner ].targetentityindex ) )
	{
		level.inFinalKillcam = false;
		level notify( "final_killcam_done" );
		return;
	}

	if ( isdefined ( level.finalKillcamSettings[ winner ].attacker ) ) 
	{
		challenges::getFinalKill( level.finalKillcamSettings[ winner ].attacker );
	}

	visionSetNaked( GetDvarString( "mapname" ), 0.0 );

	players = level.players;
	for ( index = 0; index < players.size; index++ )
	{
		player = players[index];
		player closeInGameMenu();
		player thread final_killcam( winner );
	}
	
	wait( 0.1 );

	while ( are_any_players_watching() )
		{wait(.05);};

	level notify( "final_killcam_done" );
	level.inFinalKillcam = false;
}

function startLastKillcam()
{
}


function are_any_players_watching()
{
	players = level.players;
	for ( index = 0; index < players.size; index++ )
	{
		player = players[index];
		if ( isdefined( player.killcam ) )
			return true;
	}
	
	return false;
}

function killcam(
	attackerNum, // entity number of the attacker
	targetNum, // entity number of the target
	killcam_entity_info, // struct containing killcam entity info
	weapon, // killing weapon
	deathTime, // time when the player died
	deathTimeOffset, // time between player death and beginning of killcam
	offsetTime, // something to do with how far back in time the killer was seeing the world when he made the kill; latency related, sorta
	respawn, // will the player be allowed to respawn after the killcam?
	maxtime, // time remaining until map ends; the killcam will never last longer than this. undefined = no limit
	perks, // the perks the attacker had at the time of the kill
	killstreaks, // the killstreaks the attacker had at the time of the kill
	attacker, // entity object of attacker
	keep_deathcam // remain in death-cam when the killcam ends
)
{
	// monitors killcam and hides HUD elements during killcam session
	//if ( !level.splitscreen )
	//	self thread killcam_HUD_off();
	
	self endon("disconnect");
	self endon("spawned");
	level endon("game_ended");

	if(attackerNum < 0)
		return;

	postDeathDelay = (getTime() - deathTime) / 1000;
	predelay = postDeathDelay + deathTimeOffset;
	
	killcamentitystarttime = get_killcam_entity_info_starttime( killcam_entity_info );
	
	camtime = calc_time( weapon, killcamentitystarttime, predelay, respawn, maxtime );
	postdelay = calc_post_delay();
	
	/* timeline:
	
	|        camtime       |      postdelay      |
	|                      |   predelay    |
	
	^ killcam start        ^ player death        ^ killcam end
	                                       ^ player starts watching killcam
	
	*/
	
	killcamlength = camtime + postdelay;
	
	// don't let the killcam last past the end of the round.
	if (isdefined(maxtime) && killcamlength > maxtime)
	{
		// first trim postdelay down to a minimum of 1 second.
		// if that doesn't make it short enough, trim camtime down to a minimum of 1 second.
		// if that's still not short enough, cancel the killcam.
		if (maxtime < 2)
			return;

		if (maxtime - camtime >= 1) {
			// reduce postdelay so killcam ends at end of match
			postdelay = maxtime - camtime;
		}
		else {
			// distribute remaining time over postdelay and camtime
			postdelay = 1;
			camtime = maxtime - 1;
		}
		
		// recalc killcamlength
		killcamlength = camtime + postdelay;
	}

	killcamoffset = camtime + predelay;
	
	self notify ( "begin_killcam", getTime() );
	self util::clientnotify( "sndDEDe" );
	
	killcamstarttime = (gettime() - killcamoffset * 1000);
	
	self.sessionstate = "spectator";
	self.spectatorclient = attackerNum;
	self.killcamentity = -1;
	self thread set_killcam_entities( killcam_entity_info, killcamstarttime );
	self.killcamtargetentity = targetNum;
	self.archivetime = killcamoffset;
	self.killcamlength = killcamlength;
	self.psoffsettime = offsetTime;

	//record_settings( attackerNum, targetNum, weapon, deathTime, deathTimeOffset, offsetTime, killcam_entity_info, perks, killstreaks, attacker );

	// ignore spectate permissions
	foreach( team in level.teams )
	{
		self allowSpectateTeam(team, true);
	}
	self allowSpectateTeam("freelook", true);
	self allowSpectateTeam("none", true);
	
	self thread ended_killcam_cleanup();

	// wait till the next server frame to allow code a chance to update archivetime if it needs trimming
	{wait(.05);};

	if ( self.archivetime <= predelay ) // if we're not looking back in time far enough to even see the death, cancel
	{
		self.sessionstate = "dead";
		self.spectatorclient = -1;
		self.killcamentity = -1;
		self.archivetime = 0;
		self.psoffsettime = 0;
		
		self notify ( "end_killcam" );
		
		return;
	}

	self thread check_for_abrupt_end();
	
	self.killcam = true;
	
	//self init_kc_elements();

	self add_skip_text(respawn);

	if ( !( self IsSplitscreen() ) && level.perksEnabled == 1 )
	{
		self add_timer(camtime);
		self hud::showPerks( );
//		for ( numSpecialties = 0; numSpecialties < perks.size; numSpecialties++ )
//		{
//			self hud::showPerk( numSpecialties, perks[ numSpecialties ], 10);
//		}
	}
		
	self thread spawned_killcam_cleanup();
	self thread wait_skip_killcam_button();
	self thread wait_team_change_end_killcam();
	//self thread wait_skip_killcam_safe_spawn_button();
	self thread wait_killcam_time();
	self thread tacticalinsertion::cancel_button_think();
	
	self waittill("end_killcam");

	self end(false);

	if ( ( isdefined( keep_deathcam ) && keep_deathcam ) )
		return;
	
	self.sessionstate = "dead";
	self.spectatorclient = -1;
	self.killcamentity = -1;
	self.archivetime = 0;
	self.psoffsettime = 0;
}

function set_entity( killcamentityindex, delayms )
{
	self endon("disconnect");
	self endon("end_killcam");
	self endon("spawned");
	
	if ( delayms > 0 )
		wait delayms / 1000;
	
	self.killcamentity = killcamentityindex;
}

function set_killcam_entities( entity_info, killcamstarttime )
{
	for ( index = 0; index < entity_info.entity_indexes.size; index++ )
	{
		delayms = entity_info.entity_spawntimes[index] - killcamstarttime - 100;
	
		thread set_entity(entity_info.entity_indexes[index], delayms );
		
		// return if this entity spawned before the killcam start time
		// we dont want any older entities
		if ( delayms <=0 )
			return;
	}
}

function wait_killcam_time()
{
	self endon("disconnect");
	self endon("end_killcam");

	wait(self.killcamlength - 0.05);
	self notify("end_killcam");
}

function wait_final_killcam_slowdown( deathTime, startTime )
{
	self endon("disconnect");
	self endon("end_killcam");
	secondsUntilDeath = ( ( deathTime - startTime ) / 1000 );
	deathTime = getTime() + secondsUntilDeath * 1000;
	waitBeforeDeath = 2;

	wait( max(0, (secondsUntilDeath - waitBeforeDeath) ) );
	
	util::setClientSysState("levelNotify", "sndFKsl" );

	if( util::wasLastRound() )
	{
		util::setClientSysState("levelNotify", "streamFKsl" );
	}

	setSlowMotion( 1.0, 0.25, waitBeforeDeath ); // start timescale, end timescale, lerp duration
	wait( waitBeforeDeath + .5 );
	setSlowMotion( 0.25, 1, 1.0 );

	wait(.5);
}

function wait_skip_killcam_button()
{
	self endon("disconnect");
	self endon("end_killcam");

	while(self useButtonPressed())
		wait .05;

	while(!(self useButtonPressed()))
		wait .05;

	self notify("end_killcam");    
	self util::clientNotify("fkce");
}



function wait_team_change_end_killcam()
{
	self endon("disconnect");
	self endon("end_killcam");
	
	self waittill("changed_class");

	end( false );
}


function wait_skip_killcam_safe_spawn_button()
{
	self endon("disconnect");
	self endon("end_killcam");
	
	while(self fragButtonPressed())
		wait .05;

	while(!(self fragButtonPressed()))
		wait .05;
	
	self.wantSafeSpawn = true;

	self notify("end_killcam");
}

function end( final )
{
	if(isdefined(self.kc_skiptext))
		self.kc_skiptext.alpha = 0;
	//if(isdefined(self.kc_skiptext2))
	//	self.kc_skiptext2.alpha = 0;
	if(isdefined(self.kc_timer))
		self.kc_timer.alpha = 0;
	
	self.killcam = undefined;

	self thread spectating::set_permissions();
}

function check_for_abrupt_end()
{
	self endon("disconnect");
	self endon("end_killcam");
	
	while(1)
	{
		// code may trim our archivetime to zero if there is nothing "recorded" to show.
		// this can happen when the person we're watching in our killcam goes into killcam himself.
		// in this case, end the killcam.
		if ( self.archivetime <= 0 )
			break;
		wait .05;
	}
	
	self notify("end_killcam");
}

function spawned_killcam_cleanup()
{
	self endon("end_killcam");
	self endon("disconnect");

	self waittill("spawned");
	self end(false);
}

function spectator_killcam_cleanup( attacker )
{
	self endon("end_killcam");
	self endon("disconnect");
	attacker endon ( "disconnect" );

	attacker waittill ( "begin_killcam", attackerKcStartTime );
	waitTime = max( 0, (attackerKcStartTime - self.deathTime) - 50 );
	wait (waitTime);
	self end(false);
}

function ended_killcam_cleanup()
{
	self endon("end_killcam");
	self endon("disconnect");

	level waittill("game_ended");
	self end(false);
}

function ended_final_killcam_cleanup()
{
	self endon("end_killcam");
	self endon("disconnect");

	level waittill("game_ended");
	self end(true);
}

function cancel_use_button()
{
	return self useButtonPressed();
}

function cancel_safe_spawn_button()
{
	return self fragButtonPressed();
}

function cancel_callback()
{
	self.cancelKillcam = true;
}

function cancel_safe_spawn_callback()
{
	self.cancelKillcam = true;
	self.wantSafeSpawn = true;
}

function cancel_on_use()
{
	self thread cancel_on_use_specific_button(&cancel_use_button,&cancel_callback );
	//self thread cancel_on_use_specific_button(&cancel_safe_spawn_button,&cancel_safe_spawn_callback );
}

function cancel_on_use_specific_button( pressingButtonFunc, finishedFunc )
{
	self endon ( "death_delay_finished" );
	self endon ( "disconnect" );
	level endon ( "game_ended" );
	
	for ( ;; )
	{
		if ( !self [[pressingButtonFunc]]() )
		{
			{wait(.05);};
			continue;
		}
		
		buttonTime = 0;
		while( self [[pressingButtonFunc]]() )
		{
			buttonTime += 0.05;
			{wait(.05);};
		}
		
		if ( buttonTime >= 0.5 )
			continue;
		
		buttonTime = 0;
		
		while ( !self [[pressingButtonFunc]]() && buttonTime < 0.5 )
		{
			buttonTime += 0.05;
			{wait(.05);};
		}
		
		if ( buttonTime >= 0.5 )
			continue;
			
		self [[finishedFunc]]();
		return;
	}	
}

function final_killcam_internal( winner )
{
	killcamSettings = level.finalKillcamSettings[ winner ];
	
	postDeathDelay = (getTime() - killcamSettings.deathTime) / 1000;
	predelay = postDeathDelay + killcamSettings.deathTimeOffset;
	
	killcamentitystarttime = get_killcam_entity_info_starttime( killcamSettings.killcam_entity_info );

	camtime = calc_time( killcamSettings.weapon, killcamentitystarttime, predelay, false, undefined );
	postdelay = calc_post_delay();

	killcamoffset = camtime + predelay;
	killcamlength = camtime + postdelay - 0.05; // We do the -0.05 since we are doing a wait below.

	killcamstarttime = (gettime() - killcamoffset * 1000);

	self notify ( "begin_killcam", getTime() );
	util::setClientSysState("levelNotify", "sndFKs" );

	self.sessionstate = "spectator";
	self.spectatorclient = killcamSettings.spectatorclient;
	self.killcamentity = -1;
	self thread set_killcam_entities( killcamSettings.killcam_entity_info, killcamstarttime );
	self.killcamtargetentity = killcamSettings.targetentityindex;
	self.archivetime = killcamoffset;
	self.killcamlength = killcamlength;
	self.psoffsettime = killcamSettings.offsettime;

	// ignore spectate permissions
	foreach( team in level.teams )
	{
		self allowSpectateTeam(team, true);
	}
	self allowSpectateTeam("freelook", true);
	self allowSpectateTeam("none", true);

	self thread ended_final_killcam_cleanup();
	
	// wait till the next server frame to allow code a chance to update archivetime if it needs trimming
	{wait(.05);};

	if ( self.archivetime <= predelay ) // if we're not looking back in time far enough to even see the death, cancel
	{
		// self.sessionstate = "dead"; // DO NOT SET to state "dead" in final killcam
		self.spectatorclient = -1;
		self.killcamentity = -1;
		self.archivetime = 0;
		self.psoffsettime = 0;

		self notify ( "end_killcam" );
		
		return;
	}
	
	self thread check_for_abrupt_end();

	self.killcam = true;

	if ( !( self IsSplitscreen() ) )
	{
		self add_timer(camtime);
	}
	
	self thread wait_killcam_time();
	self thread wait_final_killcam_slowdown( level.finalKillcamSettings[ winner ].deathTime, killcamstarttime );

	self waittill("end_killcam");
}

function final_killcam( winner )
{
	self endon("disconnect");
	level endon("game_ended");

	if ( util::wasLastRound() )
	{
		setMatchFlag( "final_killcam", 1 );	
		setMatchFlag( "round_end_killcam", 0 );	
	}
	else
	{
		setMatchFlag( "final_killcam", 0 );	
		setMatchFlag( "round_end_killcam", 1 );	
	}

/#
	if ( GetDvarint( "scr_force_finalkillcam" ) == 1 )
	{
		setMatchFlag( "final_killcam", 1 );	
		setMatchFlag( "round_end_killcam", 0 );	
	}
#/

	if( level.console )	
		self globallogic_spawn::setThirdPerson( false );
	
/#
	while( GetDvarint( "scr_endless_finalkillcam" ) == 1 )
	{
		final_killcam_internal( winner );
	}
#/

	final_killcam_internal( winner );

	util::setClientSysState("levelNotify", "sndFKe" );

	LUINotifyEvent( &"post_killcam_transition" );
	wait 1.5;

	self end(true);
	
	setMatchFlag( "final_killcam", 0 );	
	setMatchFlag( "round_end_killcam", 0 );

	self spawn_end_of_final_killcam();
}

// This puts the player to the intermission point as a spectator once the killcam is over.
function spawn_end_of_final_killcam()
{
	[[level.spawnSpectator]]();
	self FreezeControls( true );
}

function is_entity_weapon( weapon )
{
	if ( weapon.name == "planemortar" )
	{
		return true;
	}

	return false;
}

function calc_time( weapon, entitystarttime, predelay, respawn, maxtime )
{
	camtime = 0.0;
	
	// length from killcam start to killcam end
	if (GetDvarString( "scr_killcam_time") == "") 
	{
		if ( is_entity_weapon( weapon ) )
		{
			camtime = (gettime() - entitystarttime) / 1000 - predelay - .1;
		}
		else if ( !respawn ) // if we're not going to respawn, we can take more time to watch what happened
		{
			camtime = 5.0;
		}
		else if ( weapon.isGrenadeWeapon )
		{
			camtime = 4.25; // show long enough to see grenade thrown
		}
		else
			camtime = 2.5;
	}
	else
		camtime = GetDvarfloat( "scr_killcam_time");
	
	if (isdefined(maxtime)) {
		if (camtime > maxtime)
			camtime = maxtime;
		if (camtime < .05)
			camtime = .05;
	}
	
	return camtime;
}

function calc_post_delay()
{
	postdelay = 0;
	
		// time after player death that killcam continues for
	if (GetDvarString( "scr_killcam_posttime") == "")
	{
		postdelay = 2;
	}
	else 
	{
		postdelay = GetDvarfloat( "scr_killcam_posttime");
		if (postdelay < 0.05)
			postdelay = 0.05;
	}
	
	return postdelay;
}

function add_skip_text(respawn)
{
	self clientfield::set_player_uimodel( "hudItems.killcamAllowRespawn", respawn );
}

function add_timer(camtime)
{
	/*if ( !isdefined( self.kc_timer ) )
	{
		self.kc_timer = hud::createFontString( "extrabig", 3.0 );
		if ( level.console )
			self.kc_timer hud::setPoint( "TOP", undefined, 0, 45 );
		else
			self.kc_timer hud::setPoint( "TOP", undefined, 0, 55 );
		self.kc_timer.archived = false;
		self.kc_timer.foreground = true;
	}

	self.kc_timer.alpha = 0.2;
	self.kc_timer setTenthsTimer(camtime);*/
}


function init_kc_elements()
{
	if ( !isdefined( self.kc_skiptext ) )
	{
		self.kc_skiptext = newClientHudElem(self);
		self.kc_skiptext.archived = false;
		self.kc_skiptext.x = 0;
		self.kc_skiptext.alignX = "center";
		self.kc_skiptext.alignY = "top";
		self.kc_skiptext.horzAlign = "center_adjustable";
		self.kc_skiptext.vertAlign = "top_adjustable";
		self.kc_skiptext.sort = 1; // force to draw after the bars
		self.kc_skiptext.font = "default";
		self.kc_skiptext.foreground = true;
		self.kc_skiptext.hideWhenInMenu = true;
		
		if ( self IsSplitscreen() )
		{
			self.kc_skiptext.y = 20;
			self.kc_skiptext.fontscale = 1.2; // 1.8/1.5
		}
		else
		{
			self.kc_skiptext.y = 32;
			self.kc_skiptext.fontscale = 1.8;
		}
	}
	
	if ( !isdefined( self.kc_othertext ) )
	{
		self.kc_othertext = newClientHudElem(self);
		self.kc_othertext.archived = false;
		self.kc_othertext.y = 48;
		self.kc_othertext.alignX = "left";
		self.kc_othertext.alignY = "top";
		self.kc_othertext.horzAlign = "center";
		self.kc_othertext.vertAlign = "middle";
		self.kc_othertext.sort = 10; // force to draw after the bars
		self.kc_othertext.font = "small";
		self.kc_othertext.foreground = true;
		self.kc_othertext.hideWhenInMenu = true;
		
		if ( self IsSplitscreen() )
		{
			self.kc_othertext.x = 16;
			self.kc_othertext.fontscale = 1.2;
		}
		else
		{
			self.kc_othertext.x = 32;
			self.kc_othertext.fontscale = 1.6;
		}
	}

	if ( !isdefined( self.kc_icon ) )
	{
		self.kc_icon = newClientHudElem(self);
		self.kc_icon.archived = false;
		self.kc_icon.x = 16;
		self.kc_icon.y = 16;
		self.kc_icon.alignX = "left";
		self.kc_icon.alignY = "top";
		self.kc_icon.horzAlign = "center";
		self.kc_icon.vertAlign = "middle";
		self.kc_icon.sort = 1; // force to draw after the bars
		self.kc_icon.foreground = true;
		self.kc_icon.hideWhenInMenu = true;		
	}

	if ( !( self IsSplitscreen() ) )
	{
		if ( !isdefined( self.kc_timer ) )
		{
			self.kc_timer = hud::createFontString( "hudbig", 1.0 );
			self.kc_timer.archived = false;
			self.kc_timer.x = 0;
			self.kc_timer.alignX = "center";
			self.kc_timer.alignY = "middle";
			self.kc_timer.horzAlign = "center_safearea";
			self.kc_timer.vertAlign = "top_adjustable";
			self.kc_timer.y = 42;
			self.kc_timer.sort = 1; // force to draw after the bars
			self.kc_timer.font = "hudbig";
			self.kc_timer.foreground = true;
			self.kc_timer.color = (0.85,0.85,0.85);
			self.kc_timer.hideWhenInMenu = true;
		}
	}
}

function get_closest_killcam_entity( attacker, killCamEntities, depth )
{
	if ( !isdefined( depth ) )
		depth = 0;
		
	closestKillcamEnt = undefined;
	closestKillcamEntIndex = undefined;
	closestKillcamEntDist = undefined;
	origin = undefined;
	
	foreach( killcamEntIndex, killcamEnt in killCamEntities )
	{
		if ( killcamEnt == attacker )
			continue;
		
		origin = killcamEnt.origin;
		if ( isdefined( killcamEnt.offsetPoint ) )
			origin += killcamEnt.offsetPoint;

		dist = DistanceSquared( self.origin, origin );

		if ( !isdefined( closestKillcamEnt ) || dist < closestKillcamEntDist )
		{
			closestKillcamEnt = killcamEnt;
			closestKillcamEntDist = dist;
			closestKillcamEntIndex = killcamEntIndex;
		}
	}
	
	// check to see if the player is visible at time of death
	if ( depth < 3 && isdefined( closestKillcamEnt ) )
	{
		if ( !BulletTracePassed( closestKillcamEnt.origin, self.origin, false, self ) )
		{
			killCamEntities[closestKillcamEntIndex] = undefined;
			
			betterKillcamEnt = get_closest_killcam_entity( attacker, killCamEntities, depth + 1 );
			
			if ( isdefined( betterKillcamEnt ) )
			{
				closestKillcamEnt = betterKillcamEnt;
			}
		}
	}

	return closestKillcamEnt;
}

function get_killcam_entity( attacker, eInflictor, weapon )
{
	if ( !isdefined( eInflictor ) )
		return undefined;

	// if there is a killcam entity stored on the player who died
	if ( isdefined(self.killcamKilledByEnt) )
		return self.killcamKilledByEnt;
		
	if ( eInflictor == attacker )
	{
		if( !isdefined( eInflictor.isMagicBullet ) )
			return undefined;
		if( isdefined( eInflictor.isMagicBullet ) && !eInflictor.isMagicBullet )
			return undefined;
	}
	else if ( isdefined( level.levelSpecificKillcam ) )
	{
		levelSpecificKillcamEnt = self [[level.levelSpecificKillcam]]();
		if ( isdefined( levelSpecificKillcamEnt ) )
			return levelSpecificKillcamEnt;
	}
	
	if ( weapon.name == "hero_gravityspikes" )
		return undefined;
	
	if ( attacker IsRemoteControlling() && ( weapon.name == "sentinel_turret" ) )
		return undefined;
	if ( attacker IsRemoteControlling() && ( weapon.name == "helicopter_gunner_turret_primary" ) )
		return undefined;
	if ( attacker IsRemoteControlling() && ( weapon.name == "helicopter_gunner_turret_secondary" ) )
		return undefined;
	if ( attacker IsRemoteControlling() && ( weapon.name == "helicopter_gunner_turret_tertiary" ) )
		return undefined;
	
	if ( weapon.name == "dart" )
		return undefined;

	if ( isdefined(eInflictor.killCamEnt) )
	{
		// this is the case with the player helis
		if ( eInflictor.killCamEnt == attacker )
			return undefined;
			
		return eInflictor.killCamEnt;
	}
	else if ( isdefined(eInflictor.killCamEntities) )
	{
		return get_closest_killcam_entity( attacker, eInflictor.killCamEntities );
	}
	
	if ( isdefined( eInflictor.script_gameobjectname ) && eInflictor.script_gameobjectname == "bombzone" )
		return eInflictor.killCamEnt;
	
	return eInflictor;
}

function get_secondary_killcam_entity(entity, entity_info )
{
	if( !isdefined(entity) || !isdefined( entity.killcamentityindex ) )
		return;
	
	entity_info.entity_indexes[entity_info.entity_indexes.size] = entity.killcamentityindex;
	entity_info.entity_spawntimes[entity_info.entity_spawntimes.size] = entity.killcamentitystarttime;
}

function get_primary_killcam_entity(attacker, eInflictor, weapon, entity_info )
{
	killcamentity = self get_killcam_entity( attacker, eInflictor, weapon );
	killcamentitystarttime = killcam::get_killcam_entity_start_time( killcamentity );
	killcamentityindex = -1;

	if ( isdefined( killcamentity ) )
	{
		killcamentityindex = killcamentity getEntityNumber(); // must do this before any waiting lest the entity be deleted
	}
	
	entity_info.entity_indexes[entity_info.entity_indexes.size] = killcamentityindex;
	entity_info.entity_spawntimes[entity_info.entity_spawntimes.size] = killcamentitystarttime;
	
	get_secondary_killcam_entity( killcamentity, entity_info );
}

function get_killcam_entity_info(attacker, eInflictor, weapon)
{
	entity_info = SpawnStruct();
	
	entity_info.entity_indexes = [];
	entity_info.entity_spawntimes = [];
	
	get_primary_killcam_entity(attacker, eInflictor, weapon, entity_info);
	
	return entity_info;
}

function get_killcam_entity_info_starttime( entity_info )
{
	if ( entity_info.entity_spawntimes.size == 0 )
		return 0;
	
	// the last one should be the oldest
	return entity_info.entity_spawntimes[entity_info.entity_spawntimes.size - 1];
}
