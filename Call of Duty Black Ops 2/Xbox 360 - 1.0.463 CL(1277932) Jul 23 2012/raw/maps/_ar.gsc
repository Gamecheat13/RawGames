init()
{
	PrecacheString( &"ar_activate_target" );
	PrecacheString( &"ar_show_target" );
	PrecacheString( &"ar_hide_target" );
	level.ar_target_id = 0;
}

add_ar_target( entity, infoString, visibleRadius, activateRadius, offset )
{	
	targetID = level.ar_target_id;
	level.ar_target_id++;
	
	self thread ar_target_think( targetID, entity, infoString, visibleRadius, activateRadius, offset );
	
	return targetID;
}

kill_ar_target( targetID )
{
	level notify( "kill_ar_target_"+targetID );
	LUINotifyEvent( &"ar_hide_target", 1, targetID );
}

ar_target_think( targetID, entity, infoString, visibleRadius, activateRadius, offset )
{
	self endon( "death" );
	level endon( "kill_ar_target_"+targetID );
	entityEntNum = -1;
	if ( IsDefined( entity ) )
	{
		entity endon( "death" );
		entityEntNum = entity GetEntityNumber();
	}
	visibleRadiusSquared = visibleRadius * visibleRadius;
	activateRadiusSquared = activateRadius * activateRadius;
	visible = false;
	activated = false;
	if ( !IsDefined( offset ) )
	{
		offset = (0,0,0);
	}
	
	for ( ;; )
	{
		entityOrigin = offset;
		if ( IsDefined( entity ) )
		{
			entityOrigin += entity.origin;
		}
		sqDistance = DistanceSquared( self.origin, entityOrigin );
		if ( sqDistance < activateRadiusSquared )
		{
			if ( !activated )
			{
				activated = true;
				visible = false;
				LUINotifyEvent( &"ar_activate_target", 6, targetID, entityEntNum, infoString, int(offset[0]), int(offset[1]), int(offset[2]) );
			}
		}
		else if ( sqDistance < visibleRadiusSquared )
		{
			if ( !visible )
			{
				activated = false;
				visible = true;
				LUINotifyEvent( &"ar_show_target", 5, targetID, entityEntNum, int(offset[0]), int(offset[1]), int(offset[2]) );
			}
		}
		else
		{
			if ( activated || visible )
			{
				activated = false;
				visible = false;
				LUINotifyEvent( &"ar_hide_target", 1, targetID );
			}
		}
		wait 0.05;
	}
}