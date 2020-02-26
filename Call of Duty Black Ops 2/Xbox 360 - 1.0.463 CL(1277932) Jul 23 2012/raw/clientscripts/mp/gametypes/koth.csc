#include clientscripts\mp\_utility;

main()

{
	RegisterClientField( "world", "hardpoint", 5, "int", ::hardpoint, true );
	level._effect["zoneEdgeMarker"] = LoadFX( "maps/mp_maps/fx_mp_koth_marker_neutral_1" );
	level._effect["zoneEdgeMarkerWndw"] = LoadFX( "maps/mp_maps/fx_mp_koth_marker_neutral_wndw" );

	
	wait(.05);
	onStartGameType();

}

onPrecacheGameType()
{
}

onStartGameType()
{	
	level.hardPoints = [];
	level.visuals = [];
	level.hardPointFX = [];
	
	hardpoints = getstructarray("koth_zone_center","targetname");
	foreach( point in hardpoints )
	{
    level.hardPoints[point.script_index] = point;
	}
	
	foreach( point in level.hardPoints )
	{
		level.visuals[point.script_index] = getstructarray(point.target,"targetname");
	}
}

hardpoint(localClientNum, oldVal, newVal, bNewEnt, bInitialSnap, fieldName)
{
	foreach ( fx in level.hardPointFX )
	{
		StopFx( localClientNum, fx );
	}
	level.hardPointFX = [];
	
	if ( newVal )
	{
		foreach ( visual in level.visuals[newVal] )
		{
			forward = AnglesToForward( visual.angles );
			
			level.hardPointFX[level.hardPointFX.size] = PlayFX( localClientNum, level._effect[visual.script_fxid], visual.origin, forward );

		}
	}
}
