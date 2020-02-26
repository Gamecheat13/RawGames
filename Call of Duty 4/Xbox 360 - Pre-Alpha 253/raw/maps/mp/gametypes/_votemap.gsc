/* TODO:
	Show a timer (needs code support)
	"11 out of 20 players have voted." message?
	Figure out how to disable players being allowed to close the vote menu. (code support)
*/

init()
{
	game["menu_votemap"] = "votemap";

	precacheMenu(game["menu_votemap"]);
	
	level.maps = [];
	level.maps[0] = "mp_crash";
	level.maps[1] = "mp_facility";
	level.maps[2] = "mp_strike";
	level.maps[3] = "mp_palace";
	level.maps[4] = "mp_backlot";
	level.maps[5] = "mp_pipeline";
	level.maps[6] = "mp_citystreets";
	level.maps[7] = "mp_argun";
	level.maps[8] = "mp_convoy";
	level.maps[9] = "mp_dusk";

	level.votes = [];
	level.votetimer = 15;

	level.votemapdvars = [];
	level.votemapdvars[0] = "ui_votemap1";
	level.votemapdvars[1] = "ui_votemap2";
	level.votemapdvars[2] = "ui_votemap3";
	level.votemapdvars[3] = "ui_votemap4";
	level.votemapdvars[4] = "ui_votemap5";

	level.votecountdvars = [];
	level.votecountdvars[0] = "ui_votecount1";
	level.votecountdvars[1] = "ui_votecount2";
	level.votecountdvars[2] = "ui_votecount3";
	level.votecountdvars[3] = "ui_votecount4";
	level.votecountdvars[4] = "ui_votecount5";

	for ( i = 0; i < level.votemapdvars.size; i++ )
	{
		setdvar(level.votemapdvars[i], "");	
		makedvarserverinfo(level.votemapdvars[i], "");
	}

	for ( i = 0; i < level.votecountdvars.size; i++ )
	{
		setdvar(level.votecountdvars[i], "");	
		makedvarserverinfo(level.votecountdvars[i], "");
	}

	if(getdvar("scr_votemap") == "")
		setdvar("scr_votemap", "1");
	
	for(;;)
	{
		updateVoteMapSettings();
		wait 1;
	}
}


onPlayerDisconnect()
{
	self waittill("disconnect");

	level thread updateVotes();
}


holdVote()
{
	// disabled on PC (TEMP) and xenon splitscreen
	if(!level.votemap || !level.consoleGame || level.splitscreen)
		return;

	players = getentarray( "player", "classname" );
	for ( i = 0; i < players.size; i++ )
	{
		player = players[i];

		// spawn all players as spectators and disable their esc key menu
		player maps\mp\gametypes\_globallogic::spawnSpectator();
		player setclientdvar("g_scriptMainMenu", "");

		player thread getVote();
		player thread onPlayerDisconnect();
	}

	wait level.votetimer;
	
	nextmap = undefined;
	if(isdefined(level.votes[0]) && isdefined(level.votes[0].map))
		nextmap = level.maps[level.votes[0].map];
	
	if(isdefined(nextmap))
		return(nextmap);
	else
		return;
}


getVote()
{
	self endon( "disconnect" );

	self maps\mp\gametypes\_globallogic::spawnSpectator();
	
	self openMenu( game["menu_votemap"] );

	self waittill( "menuresponse", menu, map );
	//iprintln("^6", map);
	self.map = int(map);
		
	thread updateVotes();
}


addVote(value, array)
{
	current = undefined;
	for(i = 0; i < array.size; i++)
	{
		if ( array[i].map != value )
			continue;

		current = array[i];		
		break;
	}

	if ( !isDefined( current ) )
	{
		current = spawnstruct();
		current.map = value;
		current.count = 0;
		array[array.size] = current;
	}

	current.count++;
	
	return array;
}


updateVotes()
{
	level.votes = [];
	
	players = getentarray( "player", "classname" );
	for ( i = 0; i < players.size; i++ )
	{
		player = players[i];

		if(isdefined(player.map))
			level.votes = addVote(player.map, level.votes);
	}

	thread updateVoteDisplay();
}


updateVoteDisplay()
{
	for( i = 1; i < level.votes.size; i++ )
	{
		vote = level.votes[i];
		for ( j = i - 1; j >= 0 && level.votes[j].count < vote.count; j-- )
			level.votes[j + 1] = level.votes[j];
		level.votes[j + 1] = vote;
	}

	displaycount = level.votes.size;
	if(level.votes.size > 5)
		displaycount = 5;
		
	for(i = 0; i < displaycount; i++)
	{
		setdvar(level.votemapdvars[i], level.votes[i].map);
		setdvar(level.votecountdvars[i], level.votes[i].count);
	}

	//if ordered size is less than 5, clear out all dvars from size+1 to 5
	if(level.votes.size < 5)
	{
		for(i = level.votes.size + 1; i < 5; i++)
		{
			setdvar(level.votemapdvars[i], "");	
			setdvar(level.votecountdvars[i], "");	
		}
	}
}


updateVoteMapSettings()
{
	votemap = getdvarInt("scr_votemap");
	if(votemap > 1)
		votemap = 1;
	else if(votemap < 0)
		votemap = 0;
	
	if(!isdefined(level.votemap) || level.votemap != votemap)
	{
		level.votemap = votemap;
		setdvar("scr_votemap", level.votemap);
	}
}
