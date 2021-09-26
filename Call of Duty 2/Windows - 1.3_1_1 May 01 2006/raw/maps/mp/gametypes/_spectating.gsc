init()
{
	if(getCvar("scr_spectatefree") == "")
		setCvar("scr_spectatefree", "1");
	level.spectatefree = getCvarInt("scr_spectatefree");

	if(getCvar("scr_spectateenemy") == "")
		setCvar("scr_spectateenemy", "1");
	level.spectateenemy = getCvarInt("scr_spectateenemy");

	for(;;)
	{
		updateSpectateSettings();
		wait 1;
	}
}

updateSpectateSettings()
{
	spectatefree = getCvarInt("scr_spectatefree");
	spectateenemy = getCvarInt("scr_spectateenemy");
	update = false;
	
	if(level.spectatefree != spectatefree)
	{
		level.spectatefree = spectatefree;
		update = true;
	}
	
	if(level.spectateenemy != spectateenemy)
	{
		level.spectateenemy = spectateenemy;
		update = true;
	}

	if(update)
		level thread updateSpectatePermissions();
}

updateSpectatePermissions()
{
	players = getentarray("player", "classname");

	for(i = 0; i < players.size; i++)
		players[i] thread setSpectatePermissions();
}

setSpectatePermissions()
{
	if(isdefined(self.killcam))
		return;
	
	if((!isdefined(level.spectatefree)) || (!isdefined(level.spectateenemy)))
		return;
	
	spectatefree = true;
	if(level.spectatefree <= 0)
		spectatefree = false;
	
	spectateenemy = true;
	if(level.spectateenemy <= 0)
		spectateenemy = false;
	
	switch(self.sessionteam)
	{
	case "allies":
		self allowSpectateTeam("allies", true);
		self allowSpectateTeam("axis", spectateenemy);
		self allowSpectateTeam("freelook", spectatefree);
		self allowSpectateTeam("none", false);
		break;
		
	case "axis":
		self allowSpectateTeam("allies", spectateenemy);
		self allowSpectateTeam("axis", true);
		self allowSpectateTeam("freelook", spectatefree);
		self allowSpectateTeam("none", false);
		break;
		
	default:
		self allowSpectateTeam("allies", true);
		self allowSpectateTeam("axis", true);
		self allowSpectateTeam("freelook", true);
		self allowSpectateTeam("none", true);
		break;
	}
}
