#include common_scripts\utility;

init()
{
	if (isdefined(level.initedEntityHeadIcons))
		return;
		
	if ( level.createFX_enabled )
		return;

	level.initedEntityHeadIcons = true;
	
	assert( IsDefined(game["entity_headicon_allies"]), "Allied head icons are not defined.  Check the team set for the level.");
	assert( IsDefined(game["entity_headicon_axis"]), "Axis head icons are not defined.  Check the team set for the level.");
	PreCacheShader( game["entity_headicon_allies"] );
	precacheShader( game["entity_headicon_axis"] );
	
	if (!level.teamBased)
		return;
	
	level.entitiesWithHeadIcons = [];
}

setEntityHeadIcon(team, owner, offset, icon, constant_size) // "allies", "axis", "all", "none"
{
	if (!level.teamBased && !IsDefined(owner) )
		return;
	
	if( !IsDefined( constant_size ) )
	{
		constant_size = false;
	}

	if (!isdefined(self.entityHeadIconTeam)) 
	{
		self.entityHeadIconTeam = "none";
		self.entityHeadIcons = [];
	}

	if ( level.teamBased && !IsDefined(owner) )
	{
		if (team == self.entityHeadIconTeam)
			return;
		
		self.entityHeadIconTeam = team;
	}
	
	if (isdefined(offset))
		self.entityHeadIconOffset = offset;
	else
		self.entityHeadIconOffset = (0,0,0);

	// destroy existing head icons for this entity
	for (i = 0; i < self.entityHeadIcons.size; i++)
		if (isdefined(self.entityHeadIcons[i]))
			self.entityHeadIcons[i] destroy();
	self.entityHeadIcons = [];
	
	self notify("kill_entity_headicon_thread");
	
	if ( !IsDefined( icon ) )
	{
		icon = game["entity_headicon_" + team];
	}
	
	if ( IsDefined(owner) && !level.teamBased )
	{
		// sometimes owner comes in as not a player, for instance, the care package crate
		// unfortunately the updateEntityHeadClientIcon calls newClientHudElem and it needs to be a player entity
		if( !IsPlayer( owner ) )
		{
			assert( IsDefined( owner.owner ), "entity has to have an owner if it's not a player");
			owner = owner.owner;
		}
		owner updateEntityHeadClientIcon(self, icon, constant_size );
	}
	else if ( IsDefined(owner) && team != "none") 
	{
		owner updateEntityHeadTeamIcon(self, team, icon, constant_size );
	}

	// add to level.entitiesWithHeadIcons
//	newarray = [];
//	for (i = 0; i < level.entitiesWithHeadIcons.size; i++) {
//		if (level.entitiesWithHeadIcons[i] != self)
//			newarray[newarray.size] = level.entitiesWithHeadIcons[i];
//	}
//	if (team != "none")
//		newarray[newarray.size] = self;
//	level.entitiesWithHeadIcons = newarray;
	self thread destroyHeadIconsOnDeath();
}

updateEntityHeadTeamIcon(entity, team, icon, constant_size )
{
	headicon = NewTeamHudElem(team);
	headicon.archived = true;
	headicon.x = entity.entityHeadIconOffset[0];
	headicon.y = entity.entityHeadIconOffset[1];
	headicon.z = entity.entityHeadIconOffset[2];
	headicon.alpha = .8;
	headicon setShader(icon, 6, 6);
	headicon setwaypoint( constant_size ); // false = uniform size in 3D instead of uniform size in 2D
	headicon SetTargetEnt( entity );
	
	// update entityHeadIcons arrays so we can delete this later when either the entity or the player don't want it
	entity.entityHeadIcons[entity.entityHeadIcons.size] = headicon;
}

updateEntityHeadClientIcon(entity, icon, constant_size )
{
	headicon = newClientHudElem(self);
	headicon.archived = true;
	headicon.x = entity.entityHeadIconOffset[0];
	headicon.y = entity.entityHeadIconOffset[1];
	headicon.z = entity.entityHeadIconOffset[2];
	headicon.alpha = .8;
	headicon setShader(icon, 6, 6);
	headicon setwaypoint( constant_size ); // false = uniform size in 3D instead of uniform size in 2D
	headicon SetTargetEnt( entity );
	
	// update entityHeadIcons arrays so we can delete this later when either the entity or the player don't want it
	entity.entityHeadIcons[entity.entityHeadIcons.size] = headicon;
}

destroyHeadIconsOnDeath()
{
	self waittill_any ( "death", "hacked" );

	for (i = 0; i < self.entityHeadIcons.size; i++) 
	{
		if (isdefined(self.entityHeadIcons[i]))
			self.entityHeadIcons[i] destroy();
	}	
}

destroyEntityHeadIcons()
{
	if( isDefined( self.entityHeadIcons ) )
	{
		for (i = 0; i < self.entityHeadIcons.size; i++) 
		{
			if (isdefined(self.entityHeadIcons[i]))
				self.entityHeadIcons[i] destroy();
		}	
	}
}

updateEntityHeadIconPos(headicon)
{
	headicon.x = self.origin[0] + self.entityHeadIconOffset[0];
	headicon.y = self.origin[1] + self.entityHeadIconOffset[1];
	headicon.z = self.origin[2] + self.entityHeadIconOffset[2];
}
