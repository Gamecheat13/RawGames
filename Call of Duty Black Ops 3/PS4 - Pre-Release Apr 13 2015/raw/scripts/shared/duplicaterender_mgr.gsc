#using scripts\codescripts\struct;

#using scripts\shared\callbacks_shared;
#using scripts\shared\gameobjects_shared;
#using scripts\shared\system_shared;
#using scripts\shared\util_shared;

    	   	                                                                                                                         	                                                                                                                                                                                                                                                                                                                                                                    	        	     	             	    	   	                           	                               	                                	                                                              	                                                                                                              	                            	                                     	                                       	                                                               	   	                  	       	                                                    	                   	                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                        	                                                                                        	           	                        	                                            	                                             	                                                   	                                                             	                                                         	                                                                    	                                                                                                                                                                                                    	                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                      	                                                              	                                                          	                                   	                                   	                                                    	                                       

#namespace entityheadicons;

function init_shared()
{
	callback::on_start_gametype( &start_gametype );	
}

function start_gametype()
{
	if ( isdefined( level.initedEntityHeadIcons ) )
	{
		return;
	}

	level.initedEntityHeadIcons = true;
	
	assert( isdefined(game["entity_headicon_allies"]), "Allied head icons are not defined.  Check the team set for the level.");
	assert( isdefined(game["entity_headicon_axis"]), "Axis head icons are not defined.  Check the team set for the level.");
	
	if ( !level.teamBased )
	{
		return;
	}
	
	if (!IsDefined(level.setEntityHeadIcon) )
	{
		level.setEntityHeadIcon = &setEntityHeadIcon;
	}
	
	level.entitiesWithHeadIcons = [];
}


function setEntityHeadIcon(team, owner, offset, objective, constant_size) // "allies", "axis", "team3", "all", "none"
{
	if (!level.teamBased && !isdefined(owner) )
	{
		return;
	}
	
	if( !isdefined( constant_size ) )
	{
		constant_size = false;
	}

	if (!isdefined(self.entityHeadIconTeam)) 
	{
		self.entityHeadIconTeam = "none";
		self.entityHeadIcons = [];
		self.entityHeadObjectives = [];
	}

	if ( level.teamBased && !isdefined(owner) )
	{
		if (team == self.entityHeadIconTeam)
		{
			return;
		}
		
		self.entityHeadIconTeam = team;
	}
	
	if (isdefined(offset))
	{
		self.entityHeadIconOffset = offset;
	}
	else
	{
		self.entityHeadIconOffset = (0,0,0);
	}

	// destroy existing head icons for this entity
	if ( isdefined( self.entityHeadIcons ) )
	{
		for (i = 0; i < self.entityHeadIcons.size; i++)
		{
			if (isdefined(self.entityHeadIcons[i]))
			{
				self.entityHeadIcons[i] destroy();
			}
		}
	}

	// destroy existing head objectives for this entity
	if ( isdefined( self.entityHeadObjectives ) )
	{
		for (i = 0; i < self.entityHeadObjectives.size; i++)
		{
			if (isdefined(self.entityHeadObjectives[i]))
			{
				Objective_Delete(self.entityHeadObjectives[i]);
				self.entityHeadObjectives[i] = undefined;
			}
		}
	}
	
	self.entityHeadIcons = [];
	self.entityHeadObjectives = [];
	
	self notify("kill_entity_headicon_thread");
	
	if ( !isdefined( objective ) )
	{
		objective = game["entity_headicon_" + team];
	}
	
	if ( isdefined( objective ) )
	{
		if ( isdefined(owner) && !level.teamBased )
		{
			// sometimes owner comes in as not a player, for instance, the care package crate
			// unfortunately the updateEntityHeadClientObjective/Icon needs to be a player entity so UI knows which player to draw it for
			if( !IsPlayer( owner ) )
			{
				assert( isdefined( owner.owner ), "entity has to have an owner if it's not a player");
				owner = owner.owner;
			}
			if( isstring(objective) )
			{
				owner updateEntityHeadClientIcon(self, objective, constant_size );
			}
			else
			{
				owner updateEntityHeadClientObjective(self, objective, constant_size );
			}
		}
		else if ( isdefined(owner) && team != "none") 
		{
			if( isstring(objective) )
			{
				owner updateEntityHeadTeamIcon(self, team, objective, constant_size );
			}
			else
			{
				owner updateEntityHeadTeamObjective(self, team, objective, constant_size );
			}
		}
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

function updateEntityHeadTeamIcon(entity, team, icon, constant_size )
{
	//hard-coded the friendly blue color
	friendly_blue_color = array( 0.584, 0.839, 0.867 );
	headicon = NewTeamHudElem(team);
	headicon.archived = true;
	headicon.x = entity.entityHeadIconOffset[0];
	headicon.y = entity.entityHeadIconOffset[1];
	headicon.z = entity.entityHeadIconOffset[2];
	headicon.alpha = .8;
	headicon.color = ( friendly_blue_color[0], friendly_blue_color[1], friendly_blue_color[2] );
	headicon setShader(icon, 6, 6);
	headicon setwaypoint( constant_size ); // false = uniform size in 3D instead of uniform size in 2D
	headicon SetTargetEnt( entity );
	
	// update entityHeadIcons arrays so we can delete this later when either the entity or the player don't want it
	entity.entityHeadIcons[entity.entityHeadIcons.size] = headicon;
}

function updateEntityHeadClientIcon(entity, icon, constant_size )
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
function updateEntityHeadTeamObjective(entity, team, objective, constant_size )
{
	headIconObjectiveId = gameobjects::get_next_obj_id();
	Objective_Add( headIconObjectiveId, "active", entity, objective );
	Objective_Team( headIconObjectiveId, team );
	Objective_SetColor( headIconObjectiveId, &"FriendlyBlue" );

	// update entityHeadObjectives arrays so we can delete this later when either the entity or the player don't want it
	entity.entityHeadObjectives[entity.entityHeadObjectives.size] = headIconObjectiveId;
}

function updateEntityHeadClientObjective(entity, objective, constant_size )
{
	headIconObjectiveId = gameobjects::get_next_obj_id();
	Objective_Add( headIconObjectiveId, "active", entity, objective );
	Objective_SetInvisibleToAll( headIconObjectiveId );
	Objective_SetVisibleToPlayer( headIconObjectiveId, self );
	Objective_SetColor( headIconObjectiveId, &"FriendlyBlue" );

	// update entityHeadObjectives arrays so we can delete this later when either the entity or the player don't want it
	entity.entityHeadObjectives[entity.entityHeadObjectives.size] = headIconObjectiveId;
}

function destroyHeadIconsOnDeath()
{
	self util::waittill_any ( "death", "hacked" );

	for (i = 0; i < self.entityHeadIcons.size; i++) 
	{
		if (isdefined(self.entityHeadIcons[i]))
		{
			self.entityHeadIcons[i] destroy();
		}
	}

	for (i = 0; i < self.entityHeadObjectives.size; i++) 
	{
		if (isdefined(self.entityHeadObjectives[i]))
		{
			gameobjects::release_obj_id( self.entityHeadObjectives[i] );
			Objective_Delete( self.entityHeadObjectives[i] );
		}
	}
}

function destroyEntityHeadIcons()
{
	if( isdefined( self.entityHeadIcons ) )
	{
		for (i = 0; i < self.entityHeadIcons.size; i++) 
		{
			if (isdefined(self.entityHeadIcons[i]))
			{
				self.entityHeadIcons[i] destroy();
			}
		}
	}

	if( isdefined( self.entityHeadObjectives ) )
	{
		for (i = 0; i < self.entityHeadObjectives.size; i++) 
		{
			if (isdefined(self.entityHeadObjectives[i]))
			{
				gameobjects::release_obj_id( self.entityHeadObjectives[i] );
				Objective_Delete( self.entityHeadObjectives[i] );
			}
		}	
	}

	self.entityHeadObjectives = [];
}

function updateEntityHeadIconPos(headicon)
{
	headicon.x = self.origin[0] + self.entityHeadIconOffset[0];
	headicon.y = self.origin[1] + self.entityHeadIconOffset[1];
	headicon.z = self.origin[2] + self.entityHeadIconOffset[2];
}

function setEntityHeadIconsHiddenWhileControlling()
{
	if( isdefined( self.entityHeadIcons ) )
	{
		foreach( icon in self.entityHeadIcons )
		{
			icon.hidewhileremotecontrolling = true;
		}
	}
}
