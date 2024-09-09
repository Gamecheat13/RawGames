#include common_scripts\utility;
#include maps\mp\_utility;
#include maps\mp\gametypes\_hud_util;


giveChallenge( challengeIndex )
{
	challengeReference = level.intelChallengeStruct.challengeName[challengeIndex];
	
	switch( challengeReference )
	{
		case "ch_headshots":
		case "ch_kills":
		case "ch_killtopenemy":
		case "ch_knifekill":
		case "ch_explosivekill":
		case "ch_crouchkills":
		case "ch_pronekills":
		case "ch_backshot":
		case "ch_target":
		case "ch_jumpshot":
		case "ch_secondarykills":
		case "ch_foundshot":
		case "ch_assists":
			self thread intelHeadshotChallenge(challengeIndex);
			return;
	}

}

awardPlayerChallengeComplete( index )
{
	self endon( "disconnect" );
	
	self replenishAmmo();
	self maps\mp\gametypes\_rank::giveRankXP( "challenge", Int( level.intelChallengeStruct.challengeReward[index] ), undefined, undefined, undefined );
	self thread IntelchallengeSplashNotify( index );	

}

intelChallengeSplashNotify( challengeRef )
{
	self endon ( "disconnect" );
	
	challengeTarget = 1;
	
	actionData = spawnStruct();
	actionData.type = "challenge";
	actionData.optionalNumber = challengeTarget;
	actionData.name = level.intelChallengeStruct.challengeName[challengeRef];
	actionData.sound = tableLookup( "mp/splashTable.csv", 0, actionData.name, 9 );
	actionData.slot = 0;

	self thread maps\mp\gametypes\_hud_message::actionNotify( actionData );
}

replenishAmmo()
{
	weaponList = self GetWeaponsListAll();
	
	foreach ( weaponName in weaponList )
	{
		self giveMaxAmmo( weaponName );
	}
}

              
intelHeadshotChallenge( index )
{
	self endon("disconnect");
	
	//Splash headshot description
	//self thread maps\mp\gametypes\_hud_message::splashNotifyDelayed( text, optionalNumber )
	
	numHeadshots = 0;
	headshotTarget = Int( level.intelChallengeStruct.challengeTarget[index] );
	
	while( numHeadshots < headshotTarget )
	{
		self waittill( "headshot" );
		numHeadshots++;
	}
	
	self awardPlayerChallengeComplete( index );
}
              	
           
              	
              

