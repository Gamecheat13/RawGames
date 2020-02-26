#include maps\mp\_utility;
#include maps\mp\gametypes\_hud_util;

init()
{
	precacheShader("objpoint_default");

	level.objPointNames = [];
	level.objPoints = [];
	
	if(level.splitscreen)
		level.objPointSize = 20;
	else
		level.objPointSize = 10; 
	
	level.objpoint_alpha_default = .61;
	level.objPointScale = 1.0;
	

}


createTeamObjpoint( name, origin, team, shader, alpha, scale )
{
	assert( team == "axis" || team == "allies" || team == "all" );
	
	objPoint = getObjPointByName( name );
	
	if ( isDefined( objPoint ) )
		deleteObjPoint( objPoint );
	
	if ( !isDefined( shader ) )
		shader = "objpoint_default";

	if ( !isDefined( scale ) )
		scale = 1.0;
		
	if ( team != "all" )
		objPoint = newTeamHudElem( team );
	else
		objPoint = newHudElem();

	objPoint.name = name;
	objPoint.x = origin[0];
	objPoint.y = origin[1];
	objPoint.z = origin[2];
	objPoint.archived = false;
	objPoint.team = team;
	objPoint.isFlashing = false;
	objPoint.isShown = true;

	objPoint setShader( shader, level.objPointSize, level.objPointSize );
	objPoint setWaypoint( true );
	
	if ( isDefined( alpha ) )
		objPoint.alpha = alpha;
	else
		objPoint.alpha = level.objpoint_alpha_default;
	objPoint.baseAlpha = objPoint.alpha;
		
	objPoint.index = level.objPointNames.size;
	level.objPoints[name] = objPoint;
	level.objPointNames[level.objPointNames.size] = name;

	return objPoint;
}


deleteObjPoint( oldObjPointID )
{
	assert( level.objPoints.size == level.objPointNames.size );
	
	level.objPoints = [];
	level.objPointNames = [];
	objective_delete(oldObjPointID);
	
	
	
}


updateOrigin( origin )
{
	self.x = origin[0];
	self.y = origin[1];
	self.z = origin[2];
}


setOriginByName( name, origin )
{
	objPoint = getObjPointByName( name );
	objPoint updateOrigin( origin );
}


getObjPointByName( name )
{
	if ( isDefined( level.objPoints[name] ) )
		return level.objPoints[name];
	else
		return undefined;
}

getObjPointByIndex( index )
{
	if ( isDefined( level.objPointNames[index] ) )
		return level.objPoints[level.objPointNames[index]];
	else
		return undefined;
}

startFlashing()
{
	if ( self.isFlashing )
		return;
	
	self.isFlashing = true;
	
	for ( ;; )
	{
		self fadeOverTime( 0.75 );
		self.alpha = 0.35;
		wait ( 0.75 );
		
		if ( !self.isFlashing )
			break;
		
		self fadeOverTime( 0.75 );		
		self.alpha = 1.0;
		wait ( 0.75 );
		
		if ( !self.isFlashing )
			break;
	}
	
	self.alpha = 1.0;
}

stopFlashing()
{
	if ( !self.isFlashing )
		return;

	self.isFlashing = false;
}


startFlashingObjpoint(name)
{
	objpoint = getObjpointByName(name);

	objpoint.shouldBeFlashing = true;

	if (!isdefined(objpoint.flashthread))
		objpoint thread objpointFlashThread();
	
	objpoint notify("start_flashing");
}
stopFlashingObjpoint(name)
{
	objpoint = getObjpointByName(name);

	objpoint.shouldBeFlashing = false;
}

objpointFlashThread()
{
	self endon("death");
	
	self.flashthread = true;
	
	while(1)
	{
		if (!self.shouldBeFlashing) {
			self waittill("start_flashing");
			continue;
		}
		
		assert(self.alpha > .2);
		
		frac = (self.alpha - .2) / (1 - .2);
		
		
		
		fadetime = frac * .5;
		players = getentarray("player", "classname");
		for(i = 0; i < players.size; i++)
		{
			player = players[i];
			
			if (!isDefined(player.objpoints))
				continue;
				
			for (j = 0; j < player.objpoints.size; j++)
			{
				if (player.objpoints[j].name == self.name) {
					player.objpoints[j] fadeOverTime(fadetime);
					player.objpoints[j].alpha = .2;
					break;
				}
			}
		}
		wait(fadetime + .02);
		
		
		
		fadetime = .5;
		players = getentarray("player", "classname");
		for(i = 0; i < players.size; i++)
		{
			player = players[i];
			
			if (!isDefined(player.objpoints))
				continue;
				
			for (j = 0; j < player.objpoints.size; j++)
			{
				if (player.objpoints[j].name == self.name) {
					player.objpoints[j] fadeOverTime(fadetime);
					player.objpoints[j].alpha = 1;
					break;
				}
			}
		}
		wait(fadetime + .02);
		
		
		
		fadetime = (1 - frac) * .5;
		players = getentarray("player", "classname");
		for(i = 0; i < players.size; i++)
		{
			player = players[i];
			
			if (!isDefined(player.objpoints))
				continue;
				
			for (j = 0; j < player.objpoints.size; j++)
			{
				if (player.objpoints[j].name == self.name) {
					player.objpoints[j] fadeOverTime(fadetime);
					player.objpoints[j].alpha = self.alpha;
					break;
				}
			}
		}
		wait(fadetime + .3);
	}
}
