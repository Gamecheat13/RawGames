#include clientscripts\mp\_utility;
#include clientscripts\mp\_utility_code;
#include clientscripts\mp\_vehicle;
#include clientscripts\mp\_airsupport;
#include clientscripts\mp\_rewindobjects;

init()
{
	level.fx_jet_trail = loadfx("trail/fx_geotrail_jet_contrail");
	level.fx_airstrike_afterburner = loadfx("vehicle/exhaust/fx_exhaust_jet_afterburner");
	level.fx_airstrike_bomb = "weapon/napalm/fx_napalm_drop_mp";
	//level.fx_airstrike_bomb_explosion = loadfx ( "weapon/napalm/fx_napalm_drop_mp" );
//	level.fx_bomb_explosion = loadfx ("weapon/clusterbomb/fx_clusterbomb_exp_mp");
	level._client_flag_callbacks["plane"][level.const_flag_napalm] = ::planeNapalmSounds;
}

planeNapalmSounds( localClientNum, set )
{
	if ( !set )
		return;

	self SetCompassIcon("compass_objpoint_napalmstrike");
	self thread playPlaneFx(localClientNum);
	self thread clientscripts\mp\_airsupport::planeSounds( localClientNum, "null", "evt_us_napalm_wash", undefined );
}

addPlaneEvent( localClientNum, eventType, data, messageGeneratedTime )
{
	planeRewindObject = clientscripts\mp\_rewindobjects::getRewindWatcher( localClientNum, eventType );
	assert( isdefined( planeRewindObject ) );
	planeRewindObject addRewindableEventToWatcher( messageGeneratedTime, data );
}

playPlaneFx( localClientNum )
{
	level endon( "demo_jump" + localClientNum );
	self endon( "entityshutdown" );
	self waittill_dobj(localClientNum);
	playfxontag( localClientNum, level.fx_airstrike_afterburner, self, "tag_engine_l" );
	playfxontag( localClientNum, level.fx_airstrike_afterburner, self, "tag_engine_r" );
	playfxontag( localClientNum, level.fx_jet_trail, self, "tag_right_wingtip" );
	playfxontag( localClientNum, level.fx_jet_trail, self, "tag_left_wingtip" );
}

flyPlane( localClientNum, planeStartTime, timeOffset, data )
{
	level endon( "demo_jump" + localClientNum );
	
	planeModel 		= data.planeModel;
	team 			= data.team;
	exitType 		= data.exitType;	
	owner 			= data.owner;
	startPoint 		= data.startPoint;
	endPoint 		= data.endPoint;
	flyTime 		= data.flyTime;
	direction 		= data.direction;
	yaw 			= data.yaw;
	flyBySound	 	= data.flyBySound;
	washSound 		= data.washSound;
	apexTime		= data.apexTime;
	bombsite		= data.bombsite;
	planeFlySpeed	= data.flySpeed;
	planeFlyHeight	= data.flyHeight;

	if ( timeOffset > 0 )
		isFirstPlane	= true;
	else
		isFirstPlane	= false;

	// Spawn the planes
	destRatio = 0.5;
	destPoint = getPointOnLine( startPoint, endPoint, destRatio );
	timeElapsed = ( level.serverTime - planeStartTime ) * 0.001;
	duration = flyTime * destRatio;
	
	if ( level.serverTime > planeStartTime + ( duration * 1000 ) )
		return;
					
	// Spawn the planes
	plane = spawnPlane( localClientNum, startPoint, planeModel, team, owner, "compass_objpoint_napalmstrike" );
	level thread removeClientEntOnJump( plane, localClientNum );
	plane.angles = direction;

	plane planeSounds( flyBySound, washSound, undefined, apexTime ); 
	
	plane thread playPlaneFx( localClientNum );
	if ( plane serverTimedMoveTo( localClientNum, startPoint, destPoint, planeStartTime, duration ) )
		plane waittill( "movedone" );
	planeExit( localClientNum, plane, yaw, flytime - 2, destPoint, endPoint, destratio, exitType, isFirstPlane, planeStartTime + ( duration * 1000) );
	
	plane notify( "delete" );
	plane notify( "complete" );
	plane delete();
}

planeExit( localClientNum, plane, yaw, flytime, startPoint, endPoint, destratio, exitType, isFirstPlane, exitStartTime )
{
	level endon( "demo_jump" + localClientNum );
	halflife = GetDvarFloatDefault( "scr_napalmhalflife", 2.0 );

	exitType = int ( exitType );
	if ( exitType != -1 )
	{	
		if ( isFirstPlane )
			exitType = exitType % 3;
		else
			exitType = int( exitType / 2 );
	}
	switch( exitType )
	{
		case 0:
			planeGoStraight( localClientNum, plane, startPoint, endPoint, flyTime * ( 1 - destRatio ), exitStartTime );
			break;
		case 1:
			planeTurnLeft( localClientNum, plane, yaw,  halflife * 2 * ( 1 - destRatio ), exitStartTime );
			break;
		case 2:
			planeTurnRight( localClientNum, plane, yaw,  halflife * 2 * ( 1 - destRatio ), exitStartTime );
			break;
		default:
			planeGoStraight( localClientNum, plane, startPoint, endPoint, flyTime * ( 1 - destRatio ), exitStartTime );
			break;	
	}
}
