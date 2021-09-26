init()
{
	precacheShader("objpoint_default");

	level.objpoints_allies = spawnstruct();
	level.objpoints_allies.array = [];
	level.objpoints_axis = spawnstruct();
	level.objpoints_axis.array = [];
	level.objpoints_allplayers = spawnstruct();
	level.objpoints_allplayers.array = [];
	level.objpoints_allplayers.hudelems = [];
	
	if(level.splitscreen)
		level.objpoint_scale = 14;
	else
		level.objpoint_scale = 7;
	
	level thread onPlayerConnect();
}

onPlayerConnect()
{
	for(;;)
	{
		level waittill("connecting", player);
		
		player.objpoints = [];

		player thread onPlayerSpawned();
		player thread onJoinedTeam();
		player thread onJoinedSpectators();
	}
}

onJoinedTeam()
{
	self endon("disconnect");
	
	for(;;)
	{
		self waittill("joined_team");
		self thread clearPlayerObjpoints();
	}
}

onJoinedSpectators()
{
	self endon("disconnect");
	
	for(;;)
	{
		self waittill("joined_spectators");
		self thread clearPlayerObjpoints();
	}
}

onPlayerSpawned()
{
	self endon("disconnect");
	
	for(;;)
	{
		self waittill("spawned_player");

		self thread updatePlayerObjpoints();		
		self thread onPlayerKilled();
	}
}

onPlayerKilled()
{
	self endon("disconnect");

	for(;;)
	{
		self waittill("killed_player");
		
		self thread clearPlayerObjpoints();
	}
}

addObjpoint(origin, name, material)
{
	thread addTeamObjpoint(origin, name, "all", material);
}

addTeamObjpoint(origin, name, team, material)
{
	assert(team == "allies" || team == "axis" || team == "all");
	if(team == "allies")
	{
		assert(isdefined(level.objpoints_allies));
		objpoints = level.objpoints_allies;
	}
	else if(team == "axis")
	{
		assert(isdefined(level.objpoints_axis));
		objpoints = level.objpoints_axis;
	}
	else
	{
		assert(isdefined(level.objpoints_allplayers));
		objpoints = level.objpoints_allplayers;
	}

	// Rebuild objpoints array minus named
	cleanpoints = [];
	for(i = 0; i < objpoints.array.size; i++)
	{
		objpoint = objpoints.array[i];
	
		if(isdefined(objpoint.name) && objpoint.name != name)
			cleanpoints[cleanpoints.size] = objpoint;
	}
	objpoints.array = cleanpoints;
	
	newpoint = spawnstruct();
	newpoint.name = name;
	newpoint.x = origin[0];
	newpoint.y = origin[1];
	newpoint.z = origin[2];
	newpoint.archived = false;

	if(isdefined(material))
		newpoint.material = material;
	else
		newpoint.material = "objpoint_default";

	objpoints.array[objpoints.array.size] = newpoint;

	//update objpoints for team specified
	
	if (team == "all")
	{
		clearGlobalObjpoints();
		
		for(j = 0; j < objpoints.array.size; j++)
		{
			objpoint = objpoints.array[j];
			
			newobjpoint = newHudElem();
			newobjpoint.name = objpoint.name;
			newobjpoint.x = objpoint.x;
			newobjpoint.y = objpoint.y;
			newobjpoint.z = objpoint.z;
			newobjpoint.alpha = .61;
			newobjpoint.archived = objpoint.archived;
			newobjpoint setShader(objpoint.material, level.objpoint_scale, level.objpoint_scale);
			newobjpoint setwaypoint(true);
			
			level.objpoints_allplayers.hudelems[level.objpoints_allplayers.hudelems.size] = newobjpoint;
		}
	}
	else
	{
		players = getentarray("player", "classname");
		for(i = 0; i < players.size; i++)
		{
			player = players[i];
			
			if(isDefined(player.pers["team"]) && player.pers["team"] == team && player.sessionstate == "playing")
			{
				player clearPlayerObjpoints();
	
				for(j = 0; j < objpoints.array.size; j++)
				{
					objpoint = objpoints.array[j];
					
					newobjpoint = newClientHudElem(player);
					newobjpoint.name = objpoint.name;
					newobjpoint.x = objpoint.x;
					newobjpoint.y = objpoint.y;
					newobjpoint.z = objpoint.z;
					newobjpoint.alpha = .61;
					newobjpoint.archived = objpoint.archived;
					newobjpoint setShader(objpoint.material, level.objpoint_scale, level.objpoint_scale);
					newobjpoint setwaypoint(true);
					
					player.objpoints[player.objpoints.size] = newobjpoint;
				}
			}
		}
	}
}

removeObjpoints()
{
	thread removeTeamObjpoints("all");
}

removeTeamObjpoints(team)
{
	assert(team == "allies" || team == "axis" || team == "all");
	if(team == "allies")
	{
		assert(isdefined(level.objpoints_allies));
		level.objpoints_allies.array = [];
	}
	else if(team == "axis")
	{
		assert(isdefined(level.objpoints_axis));
		level.objpoints_axis.array = [];
	}
	else
	{
		assert(isdefined(level.objpoints_allplayers));
		assert(isdefined(level.objpoints_allplayers.hudelems));
		level.objpoints_allplayers.array = [];
		for (i=0;i<level.objpoints_allplayers.hudelems.size;i++)
			level.objpoints_allplayers.hudelems[i] destroy();
		level.objpoints_allplayers.hudelems = [];
		return;
	}

	//clear objpoints for team specified
	players = getentarray("player", "classname");
	for(i = 0; i < players.size; i++)
	{
		player = players[i];
		
		if(isDefined(player.pers["team"]) && player.pers["team"] == team && player.sessionstate == "playing")
			player clearPlayerObjpoints();
	}
}

updatePlayerObjpoints()
{
	if(isDefined(self.pers["team"]) && self.pers["team"] != "spectator" && self.sessionstate == "playing")
	{
		assert(self.pers["team"] == "allies" || self.pers["team"] == "axis");
		if(self.pers["team"] == "allies")
		{
			assert(isdefined(level.objpoints_allies));
			objpoints = level.objpoints_allies;
		}
		else
		{
			assert(isdefined(level.objpoints_axis));
			objpoints = level.objpoints_axis;
		}
		
		self clearPlayerObjpoints();
		
		for(i = 0; i < objpoints.array.size; i++)
		{
			objpoint = objpoints.array[i];
			
			newobjpoint = newClientHudElem(self);
			newobjpoint.name = objpoint.name;
			newobjpoint.x = objpoint.x;
			newobjpoint.y = objpoint.y;
			newobjpoint.z = objpoint.z;
			newobjpoint.alpha = .61;
			newobjpoint.archived = objpoint.archived;
			newobjpoint setShader(objpoint.material, level.objpoint_scale, level.objpoint_scale);
			newobjpoint setwaypoint(true);
			
			self.objpoints[self.objpoints.size] = newobjpoint;
		}
	}
}

clearPlayerObjpoints()
{
	for(i = 0; i < self.objpoints.size; i++)
		self.objpoints[i] destroy();
	
	self.objpoints = [];
}

clearGlobalObjpoints()
{
	for(i = 0; i < level.objpoints_allplayers.hudelems.size; i++)
		level.objpoints_allplayers.hudelems[i] destroy();
	
	level.objpoints_allplayers.hudelems = [];
}

//removePlayerObjpoint(name)
//{
//	for(i = 0; i < self.objpoints.size; i++)
//	{
//		objpoint = self.objpoints[i];
//		
//		if(isdefined(objpoint.name) && objpoint.name == name)
//			objpoint destroy();
//	}
//}