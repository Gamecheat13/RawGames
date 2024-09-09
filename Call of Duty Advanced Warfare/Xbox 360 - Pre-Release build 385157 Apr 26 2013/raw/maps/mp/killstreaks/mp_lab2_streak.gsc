#include maps\mp\_utility;
#include maps\mp\gametypes\_hud_util;
#include common_scripts\utility;

init()
{
	
	
	precacheLocationSelector( "map_artillery_selector" );
	precacheString( &"KILLSTREAKS_MP_LAB2" );
	
//////// Currently don't need an item for this level killstreak because it does not cause damage	
//
//	PreCacheItem( "killstreak_lab2_mp" );
		
	thread GetLaserCameras();
	
	level.killStreakFuncs[ "mp_lab2" ] = ::tryUseMpLab2;
	
}


tryUseMpLab2( lifeId )
{
	if ( ! self validateUseStreak() )
		return false;

	if ( self isUsingRemote() )
	{
		return false;
	}

/*	if( IsDefined(self.mp_lab2_killstreak) && self.mp_lab2_killstreak.size > 0 )
	{
		self iPrintLnBold( &"MP_AIR_SPACE_TOO_CROWDED" );
		return false;
	}
*/	
	result = self TurnOnTheatDetection( lifeId );

	if ( !isDefined( result ) || !result )
		return false;
	
	return true;
}

TurnOnTheatDetection( lifeID )
{
	self thread LevelKillStreakLab2(20);
	return true;
}


LevelKillStreakLab2(duration)
{
	if (level.SweepEastArray[0].active == false)
	{
		level.SweepEastArray[0].active = true;
		thread DoLaserSweep();
	}


	self thread GreetPlayer();
	
	drawtime = 1;
	// FOR STATEMENT TO UPDATE DRAW LIST EVERY 1 SECOND SO NEW ENEMY PLAYERS OR NEWLY SPAWNED PLAYERS ARE DRAWN FOR REMAINDER OF DURRATION
	wait(1.5);
	
	thread maps\mp\_threatdetection::detection_highlight_hud_effect( self, duration + drawtime );

	for (i = 0; i < duration; i++)
	{

		foreach( player in level.players )
		{
			if ( !IsDefined( player ) || !IsAlive( player ) || self.team == player.team )
			{
				continue;
			}
			
			enemyplayer = player;
			enemyplayer maps\mp\_threatdetection::addThreatEvent( [self], drawtime + 0.05, "PAINT_KILLSTREAK", true, false );
			
		/////////////////// DAMAGE HIT INDICATE NOT NEEDED
		//	self maps\mp\gametypes\_damagefeedback::updateDamageFeedback( "paint" );
		}
		wait(drawtime);
	}
}

DoLaserSweep()
{
	RotateDistance = 90;
	RotateTime = 3;
	foreach (laser_sweep in level.SweepEastArray)
	{
		laser_sweep show();
	}

	foreach (cam_mesh in level.CameraMeshEastArray)
	{
		cam_mesh RotatePitch(RotateDistance, RotateTime);
	}
	wait(RotateTime + 0.1);
	
	foreach (cam_mesh in level.CameraMeshEastArray)
	{
		cam_mesh RotatePitch(RotateDistance *-1, RotateTime);
	}
	wait(RotateTime + 0.1);
	
	
	foreach (laser_sweep in level.SweepEastArray)
	{
		laser_sweep hide();
	}
	level.SweepEastArray[0].active = false;
	
}
DisplayClientString( text, Xoffset, Yoffset, scale )
{
	display = maps\mp\gametypes\_hud_util::createFontString("hudbig", scale);
	display maps\mp\gametypes\_hud_util::setPoint("CENTERLEFT", "CENTERLEFT", Xoffset, Yoffset);
	display.sort = 1001;
	display.color = (1,1,1);
	display.foreground = false;
	display.hidewheninmenu = true;
	display settext(text);
	
	self waittill("destroy_client_strings");
	display maps\mp\gametypes\_hud_util::destroyElem();
}
GreetPlayer()
{
	self thread displayClientString("User " + self.name + " granted admin access to Titan Secutiy v2.3",20,0,0.5);
	self thread displayClientString("// STARTING SCAN SWEEP //",20,10,0.5);
	wait(8);
	self notify("destroy_client_strings");	
}

GetLaserCameras()
{
	level.CameraMeshEastArray = [];
	level.SweepEastArray = GetEntArray("laser_sweep01","targetname");
	for (i = 0; i < level.SweepEastArray.size; i++)
	{
		level.CameraMeshEastArray[i] = GetEnt(level.SweepEastArray[i].target,"targetname");
		level.SweepEastArray[i] LinkTo(level.CameraMeshEastArray[i]);
		level.SweepEastArray[i] hide();
	}
	level.SweepEastArray[0].active = false;
}


