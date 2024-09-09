#include common_scripts\utility;
#include maps\mp\_utility;
#include maps\mp\gametypes\_hud_util;


init()
{
	/*
	precachemodel( "com_metal_briefcase" );
	
	level thread populateIntelChallenges();
	level thread onPlayerConnect();
	
	level.intelActive = false;
	*/
}

populateIntelChallenges()
{
	level endon ( "game_ended" );
	
	wait(0.05);
	
	level.intelChallengeStruct = spawnStruct();
	
	level.intelChallengeStruct.challengeName = [];
	level.intelChallengeStruct.challengeCategory = [];
	level.intelChallengeStruct.challengeReward = [];
	level.intelChallengeStruct.challengeTarget = [];
	
	//Challenge Name
	challengeTempField = "temp";
	while(challengeTempField != "")
	{
		challengeTempField = tableLookupByRow("mp/intelChallenges.csv", level.intelChallengeStruct.challengeName.size, 0 );
		
		if ( challengeTempField != "" )
			level.intelChallengeStruct.challengeName[level.intelChallengeStruct.challengeName.size] = challengeTempField;	
	}
	
	//Challenge Category
	challengeTempField = "temp";
	while(challengeTempField != "")
	{
		challengeTempField = tableLookupByRow("mp/intelChallenges.csv", level.intelChallengeStruct.challengeCategory.size, 3 );
		
		if ( challengeTempField != "" )
			level.intelChallengeStruct.challengeCategory[level.intelChallengeStruct.challengeCategory.size] = challengeTempField;	
	}
	
	//Challenge Reward
	challengeTempField = "temp";
	while(challengeTempField != "")
	{
		challengeTempField = tableLookupByRow("mp/intelChallenges.csv", level.intelChallengeStruct.challengeReward.size, 4 );
		
		if ( challengeTempField != "" )
			level.intelChallengeStruct.challengeReward[level.intelChallengeStruct.challengeReward.size] = challengeTempField;	
	}
	
	//Challenge Target
	challengeTempField = "temp";
	while(challengeTempField != "")
	{
		challengeTempField = tableLookupByRow("mp/intelChallenges.csv", level.intelChallengeStruct.challengeTarget.size, 5 );
		
		if ( challengeTempField != "" )
			level.intelChallengeStruct.challengeTarget[level.intelChallengeStruct.challengeTarget.size] = challengeTempField;	
	}

}

onPlayerConnect()
{
	for(;;)
	{
		level waittill( "connected", player );
		
		player thread intelFirstDeathWatcher();
	}
}

intelFirstDeathWatcher()
{
	level endon ( "game_ended" );
	level endon ( "intelSpawned" );
	self endon( "disconnect" );
	
		self waittill( "death" );
		
		if( !level.intelActive )
		{
			level.intelActive = true;
		self spawnIntel();
		level notify("intelSpawned");
		}
		}

spawnIntel()
{
	position = self.origin;
	
	visuals[0] = spawn( "script_model", position );
	visuals[0].angles = (0,0,0);
	visuals[0] setModel( "com_metal_briefcase" );
	
	cloneTrigger = spawn( "trigger_radius", position, 0, 96, 60 );
	intelEnt = cloneTrigger;
	
	intelTrigger = maps\mp\gametypes\_gameobjects::createCarryObject( "friendly", intelEnt, visuals, (0,0,28) );
	intelTrigger maps\mp\gametypes\_gameobjects::setUseTime( 0.5 );
	intelTrigger maps\mp\gametypes\_gameobjects::setUseText( &"MP_AQUIRING_INTEL" );
	intelTrigger maps\mp\gametypes\_gameobjects::setVisibleTeam( "any" );
	intelTrigger maps\mp\gametypes\_gameobjects::allowCarry( "any" );
	intelTrigger maps\mp\gametypes\_gameobjects::setCarrierVisible( false );
	
	intelTrigger thread intelSpinAnimate();
	
	intelTrigger.onPickup = ::onPickupIntel;
	intelTrigger.onDrop = ::onDropIntel;
	intelTrigger.allowWeapons = true;
	intelTrigger.oldRadius = intelEnt.radius;

	level.intelTrigger = intelTrigger;
	}
	
intelSpinAnimate()
{
	level endon( "game_ended" );
	
	self endon( "reset" );
	self endon( "pickup_object" );	
	
	bottomPos = self.curOrigin + (0,0,24);
	topPos = self.curOrigin + (0,0,32);
	
	while( true )
	{
		self.visuals[0] moveTo( topPos, 0.5, 0.15, 0.15 );
		self.visuals[0] rotateYaw( 180, 0.5 );
		
		wait( 0.5 );
		
		self.visuals[0] moveTo( bottomPos, 0.5, 0.15, 0.15 );
		self.visuals[0] rotateYaw( 180, 0.5 );	
		
		wait( 0.5 );		
	}
}

onDropIntel( player )
{
	player spawnIntel();
	
	level notify("intelSpawned");
	player.hasIntel = false;
	}
	
onPickupIntel( player )
{
	player.hasIntel = true;
	
	if ( isDefined( level.intelTrigger ) )
		level.intelTrigger Delete();
	
	//need to bucket challenges for specific game modes
	if ( level.gametype == "sd" )
		challengeNum = RandomIntRange( 3, 12 );
	else
	challengeNum = RandomIntRange( 0, 13 );
	player maps\mp\gametypes\_intelchallenges::giveChallenge( challengeNum );
}
