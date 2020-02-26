// _gamemode.gsc
// Handles setup for additional game modes in co-op
// DSL

shouldSaveOnStartup()
{
	gt = GetDvar( "g_gametype");
	
	switch(gt)
	{
		case "vs":
			return false;
		default:
			break;
	}

	return true;
}