init()
{
	level thread updateRichPresence();
}

updateRichPresence()
{
	for(;;)
	{
		players = getentarray("player", "classname");
		for(i = 0; i < players.size; i++)
		{
			player = players[i];
			
			if(isdefined(player))
			{
				player updatescores();
				wait .05;
			}
		}
		
		wait 60;
	}
}
