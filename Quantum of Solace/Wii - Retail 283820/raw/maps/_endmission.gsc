#include maps\_utility;
#include common_scripts\utility;

main()
{
	missionSettings = [];

	
	missionIndex = 0; 

	missionSettings = createMission();
	missionSettings addLevel( "whites_estate", false, "PROGRESSION_WHITES", "Open_Credits", undefined );
	missionSettings addLevel( "siena", true, undefined, undefined, 2 );
	missionSettings addLevel( "siena_rooftops", false, undefined, undefined, 2 );
	missionSettings addLevel( "operahouse", false, undefined, undefined, 4 );
	missionSettings addLevel( "sink_hole", false, "PROGRESSION_OPERA", undefined, 0);
	missionSettings addLevel( "shantytown", false, undefined, undefined, undefined );
	missionSettings addLevel( "constructionsite", false, "PROGRESSION_CONSTRUCTION", undefined, 1 );
	missionSettings addLevel( "sciencecenter_a", true, undefined, undefined, undefined );
	missionSettings addLevel( "sciencecenter_b", false, undefined, undefined, undefined );
	missionSettings addLevel( "airport", false, "PROGRESSION_AIRPORT", undefined, 3 );
	missionSettings addLevel( "montenegrotrain", false, undefined, undefined, 0 );
	missionSettings addLevel( "casino", false, undefined, undefined, 2 );
	missionSettings addLevel( "casino_poison", false, "PROGRESSION_CASINO", undefined, undefined );
	missionSettings addLevel( "barge", false, undefined, undefined, 0);
	missionSettings addLevel( "gettler", false, "PROGRESSION_GETTLER", undefined, undefined );
	missionSettings addLevel( "eco_hotel", false, undefined, "Haines_Estate_Load", undefined);
	
	

	level.missionSettings = missionSettings;
}


nextmission()
{
	level.nextmission = true;
	level.player enableinvulnerability();	
	
	levelIndex = undefined;
	
	setsaveddvar( "ui_nextMission", "1" );
	setdvar( "ui_showPopup", "0" );
	setdvar( "ui_popupString", "" );
	
	levelIndex = level.missionSettings getLevelIndex( level.script );
	
	if ( !isDefined( levelIndex ) )
		return;
		
	
	level.missionSettings setLevelCompleted( levelIndex );
	
	
	
	
		
	UpdateGamerProfile();

	if ( level.missionSettings hasAchievement( levelIndex ) && getdvar("mis_cheat") == "0" )
		giveachievement( level.missionSettings getAchievement( levelIndex ) );
		
	if( level.missionSettings getKeepWeapons(levelIndex) )
		SavePlayerWeaponStatePersistent( level.missionSettings getLevelName( levelIndex ) );

	switch ( level.missionSettings getLowestSkill() )
	{
		case 4:
			giveachievement( "MASTERY_DOUBLEOH" );
		case 3:
			giveachievement( "MASTERY_AGENT" );
		case 2:
			giveachievement( "MASTERY_RECRUIT" );
		case 1:
			giveachievement( "MASTERY_CIVILIAN" );
		default:
			break;
	}

	nextLevelIndex = level.missionSettings.levels.size;
	if ( level.script == "eco_hotel" )
	{
		if ( level.missionSettings hasMissionSuccessMovie( levelIndex ) )
		{
			SetSavedDVar("cg_draw2D", "0");
			SetDVar("missionsuccess_movie", level.missionSettings getMissionSuccessMovie( levelIndex ));
		}
		setsaveddvar( "ui_nextMission", "0" );
		
		
		changelevel( "credits", level.missionSettings getKeepWeapons( levelIndex ), 0 );
		return;
	}
	else
	{
		nextLevelIndex = levelIndex + 1;
	}

	if ( level.missionSettings hasMissionSuccessMovie( levelIndex ) )
	{
		SetSavedDVar("cg_draw2D", "0");
		SetDVar("missionsuccess_movie", level.missionSettings getMissionSuccessMovie( levelIndex ));
		changelevel( level.missionSettings getLevelName( nextLevelIndex ), level.missionSettings getKeepWeapons( levelIndex ), 0 );
	}
	else if( level.missionSettings hasFadeTime( levelIndex ) )
	{
		changelevel( level.missionSettings getLevelName( nextLevelIndex ), level.missionSettings getKeepWeapons( levelIndex ), level.missionSettings getFadeTime( levelIndex ) );
	}
	else
	{
		changelevel( level.missionSettings getLevelName( nextLevelIndex ), level.missionSettings getKeepWeapons( levelIndex ) );
	}
}
 
setLevelCompleted( levelIndex )
{
	
	if ( level.missionSettings getLevelName( levelIndex ) == "siena" )
		return;

	levelOffset = getMissionDvarIndex( levelIndex );

	missionString = getdvar( "mis_difficulty" );
	
	if ( int( missionString[ levelOffset ] ) > level.gameskill )
		return;
		
	newString = "";
	gameskill = level.gameskill;
	
	for ( index = 0; index < missionString.size; index++ )
	{
		if ( index != levelOffset )
			newString += missionString[ index ];
		else
			newString += gameskill + 1;
	}
	_setMissionDvar( "mis_difficulty", newString );	
}

_setMissionDvar( dvar, string )
{
	if(getdvar("mis_cheat") == "1")
		return;
	setMissionDvar( dvar, string );	
}


getLevelSkill( levelIndex )
{
	levelOffset = getMissionDvarIndex( levelIndex );
	
	missionString = getdvar( "mis_difficulty" );
	return( int( missionString[ levelOffset ] ) );
}


getMissionDvarIndex( levelIndex )
{
	
	
	if ( !levelIndex )
		return levelIndex;
	else
		return levelIndex - 1;
}


getLowestSkill()
{
	missionString = getdvar( "mis_difficulty" );
	lowestSkill = 4;
		

	
	for ( index = 0; index < self.levels.size - 1; index++ )
	{
		if ( int( missionString[  index ] ) < lowestSkill )
			lowestSkill = int( missionString[ index ] );
	}
	return( lowestSkill );
}


createMission()
{
	mission = spawnStruct();
	mission.levels = [];
	mission.prereqs = [];
	return( mission );
}

addLevel( levelName, keepWeapons, achievement, missionSuccessMovie, fadeTime )
{
	assert(isdefined(keepweapons));
	levelIndex = self.levels.size;
	self.levels[ levelIndex ] = spawnStruct();
	self.levels[ levelIndex ].name = levelName;
	self.levels[ levelIndex ].keepWeapons = keepWeapons;
	self.levels[ levelIndex ].achievement = achievement;
	self.levels[ levelIndex ].missionSuccessMovie = missionSuccessMovie;
	self.levels[ levelIndex ].fadeTime = fadeTime; 
}

addPreReq( missionIndex )
{
	preReqIndex = self.prereqs.size;
	self.prereqs[ preReqIndex ] = missionIndex;
}

getLevelIndex( levelName )
{
	for ( levelIndex = 0; levelIndex < self.levels.size; levelIndex++ )
	{
		if ( self.levels[ levelIndex ].name != levelName )
			continue;
			
		return( levelIndex );
	}
	return( undefined );
}

getLevelName( levelIndex )
{
	return( self.levels[ levelIndex ].name );
}

getKeepWeapons( levelIndex )
{
	return( self.levels[ levelIndex ].keepWeapons );
}

getAchievement( levelIndex )
{
	return( self.levels[ levelIndex ].achievement );
}

hasAchievement( levelIndex )
{
	if ( isDefined( self.levels[ levelIndex ].achievement ) )
		return( true );
	else
		return( false );
}

getMissionSuccessMovie( levelIndex )
{
	return ( self.levels[ levelIndex ].missionSuccessMovie );
}

hasMissionSuccessMovie( levelIndex )
{
	if ( !isDefined( self.levels[ levelIndex ].missionSuccessMovie ) )
		return false;
	return true;
}

hasFadeTime( levelIndex )
{
	if ( isDefined( self.levels[ levelIndex ].fadeTime ) )
		return( true );
	else
		return ( false );
}

getFadeTime( levelIndex )
{
	return ( self.levels[ levelIndex ].fadeTime );
}

getNextLevelIndex()
{
	for ( index = 0; index < self.levels.size; index++ )
	{
		if ( !self getLevelSkill( index ) )
			return( index );
	}
	return( 0 );
}

force_all_complete()
{
	println("tada!");
	missionString = getdvar( "mis_difficulty" );
	newString = "";
	for ( index = 0; index < missionString.size; index++ )
	{
		if(index < 20)
			newString += 2;
		else
			newstring += 0;
	}
	setMissionDvar( "mis_difficulty", newString );	
	setMissionDvar( "mis_01", 20 );	
}

clearall()
{
	setMissionDvar( "mis_difficulty", "00000000000000000000000000000000000000000000000000" );	
	setMissionDvar( "mis_01", 0 );	
}

SavePlayerWeaponStatePersistent( slot )
{
	current = level.player getCurrentWeapon();
	if ( ( !isdefined( current ) ) || ( current == "none" ) )
		assertmsg( "Player's current weapon is 'none' or undefined. Make sure 'disableWeapons()' has not been called on the player when trying to save weapon states." );
	game[ "weaponstates" ][ slot ][ "current" ] = current;

	offhand = level.player getcurrentoffhand();
	game[ "weaponstates" ][ slot ][ "offhand" ] = offhand;

	game[ "weaponstates" ][ slot ][ "list" ] = [];
	weapList = level.player GetWeaponsList();
	for ( weapIdx = 0; weapIdx < weapList.size; weapIdx++ )
	{
		game[ "weaponstates" ][ slot ][ "list" ][ weapIdx ][ "name" ] = weapList[ weapIdx ];

		
		game[ "weaponstates" ][ slot ][ "list" ][ weapIdx ][ "clip" ] = level.player GetWeaponAmmoClip( weapList[ weapIdx ] );
		game[ "weaponstates" ][ slot ][ "list" ][ weapIdx ][ "stock" ] = level.player GetWeaponAmmoStock( weapList[ weapIdx ] );
	}
}

