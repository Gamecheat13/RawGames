#include maps\mp\_utility;
#include common_scripts\utility;


init()
{
	level.teamEMPed["allies"] = false;
	level.teamEMPed["axis"] = false;
	level.empPlayer = undefined;
	
	if ( level.teamBased )
		level thread EMP_TeamTracker();
	else
		level thread EMP_PlayerTracker();
	
	level.killstreakFuncs["emp"] = ::EMP_Use;
	
	level thread onPlayerConnect();
	
}



onPlayerConnect()
{
	for(;;)
	{
		level waittill("connected", player);
		player thread onPlayerSpawned();
	}
}


onPlayerSpawned()
{
	self endon("disconnect");

	for(;;)
	{
		self waittill( "spawned_player" );
		
		if ( (level.teamBased && level.teamEMPed[self.team]) || (!level.teamBased && isDefined( level.empPlayer ) && level.empPlayer != self) )
			self setEMPJammed( true );
	}
}


EMP_Use( lifeId )
{
	assert( isDefined( self ) );

	myTeam = self.pers["team"];
	otherTeam = level.otherTeam[myTeam];
	
	if ( level.teamBased )
		self thread EMP_JamTeam( otherTeam, 45.0 );
	else
		self thread EMP_JamPlayers( self, 45.0 );

	self maps\mp\_matchdata::logKillstreakEvent( "emp", self.origin );
	self notify( "used_emp" );

	return true;
}


EMP_JamTeam( teamName, duration )
{
	level endon ( "game_ended" );
	
	assert( teamName == "allies" || teamName == "axis" );

	wait ( 5.0 );

	thread teamPlayerCardSplash( "used_emp", self );

	level notify ( "EMP_JamTeam" + teamName );
	level endon ( "EMP_JamTeam" + teamName );
	
	foreach ( player in level.players )
	{
		player playLocalSound( "emp_activate" );
		
		if ( player.team != teamName )
			continue;
		
		if ( player _hasPerk( "specialty_localjammer" ) )
			player RadarJamOff();
	}
	
	visionSetNaked( "coup_sunblind", 0.05 );
	wait ( 0.05 );
	visionSetNaked( getDvar( "mapname" ), 3.0 );
	
	level.teamEMPed[teamName] = true;
	level notify ( "emp_update" );
	
	foreach ( heli in level.helis )
		radiusDamage( heli.origin, 384, 5000, 5000, self );

	foreach ( littleBird in level.littleBird )
		radiusDamage( littleBird.origin, 384, 5000, 5000, self );
	
	foreach ( turret in level.turrets )
		radiusDamage( turret.origin, 16, 5000, 5000, self );

	foreach ( rocket in level.rockets )
		rocket notify ( "death" );
	
	foreach ( uav in level.uavModels[teamName] )
		radiusDamage( uav.origin, 384, 5000, 5000, self );
	
	if ( isDefined( level.ac130player ) )
		level.ac130.planeModel notify ( "damage", 5000, self, (0,0,0), (0,0,0), "MOD_EXPLOSIVE" );
		//radiusDamage( level.ac130.planeModel.origin, 1000, 5000, 5000, self ); // doesn't work
	
	wait ( duration );
	
	level.teamEMPed[teamName] = false;
	
	foreach ( player in level.players )
	{
		if ( player.team != teamName )
			continue;
		
		if ( player _hasPerk( "specialty_localjammer" ) )
			player RadarJamOn();
	}
	
	
	level notify ( "emp_update" );
}


EMP_JamPlayers( owner, duration )
{
	level notify ( "EMP_JamPlayers" );
	level endon ( "EMP_JamPlayers" );
	
	assert( isDefined( owner ) );
	
	wait ( 5.0 );
	
	foreach ( player in level.players )
	{
		player playLocalSound( "emp_activate" );
		
		if ( player == owner )
			continue;
		
		if ( player _hasPerk( "specialty_localjammer" ) )
			player RadarJamOff();
	}
	
	visionSetNaked( "coup_sunblind", 0.05 );
	wait ( 0.05 );
	visionSetNaked( getDvar( "mapname" ), 3.0 );
	
	level notify ( "emp_update" );
	
	foreach ( heli in level.helis )
		radiusDamage( heli.origin, 384, 5000, 5000, self );

	foreach ( littleBird in level.littleBird )
		radiusDamage( littleBird.origin, 384, 5000, 5000, self );
	
	foreach ( turret in level.turrets )
		radiusDamage( turret.origin, 16, 5000, 5000, self );

	foreach ( rocket in level.rockets )
		rocket notify ( "death" );
	
	foreach ( uav in level.uavModels )
		radiusDamage( uav.origin, 384, 5000, 5000, self );
	
	if ( isDefined( level.ac130player ) )
		level.ac130.planeModel notify ( "damage", 5000, self, (0,0,0), (0,0,0), "MOD_EXPLOSIVE" );
	
	level.empPlayer = owner;
	level notify ( "emp_update" );
	
	wait ( duration );
	
	foreach ( player in level.players )
	{
		if ( player == owner )
			continue;
		
		if ( player _hasPerk( "specialty_localjammer" ) )
			player RadarJamOn();
	}
	
	level.empPlayer = undefined;
	level notify ( "emp_update" );
}


EMP_TeamTracker()
{
	level endon ( "game_ended" );
	
	for ( ;; )
	{
		level waittill_either ( "joined_team", "emp_update" );
		
		foreach ( player in level.players )
		{
			if ( player.team == "spectator" )
				continue;
				
			player setEMPJammed( level.teamEMPed[player.team] );
		}
	}
}


EMP_PlayerTracker()
{
	level endon ( "game_ended" );
	
	for ( ;; )
	{
		level waittill_either ( "joined_team", "emp_update" );
		
		foreach ( player in level.players )
		{
			if ( player.team == "spectator" )
				continue;
				
			if ( isDefined( level.empPlayer ) && level.empPlayer != player )
				player setEMPJammed( true );
			else
				player setEMPJammed( false );				
		}
	}
}
