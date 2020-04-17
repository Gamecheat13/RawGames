init()
{
	precacheString(&"MP_KILLSTREAK_POTENT");
	precacheString(&"MP_KILLSTREAK_DISTINGUISHED");
	precacheString(&"MP_KILLSTREAK_COLDBLOODED");
	precacheString(&"MP_KILLSTREAK_MERCILESS");
	precacheString(&"MP_KILLSTREAK_LICENSED");
	precacheString(&"MP_KILLSTREAK_NUMKILLS");

	level.killstreaks = [];
	level.killstreaks[3] = &"MP_KILLSTREAK_POTENT";
	level.killstreaks[5] = &"MP_KILLSTREAK_DISTINGUISHED";
	level.killstreaks[7] = &"MP_KILLSTREAK_COLDBLOODED";
	level.killstreaks[10] = &"MP_KILLSTREAK_MERCILESS";
	level.killstreaks[15] = &"MP_KILLSTREAK_LICENSED";
}

printKillStreak(attacker)
{
	if ( !isDefined( attacker ) || !isDefined( attacker.cur_kill_streak ) )
		return;

	assert(isDefined(level.killstreaks));
	
	killstreak_title = level.killstreaks[attacker.cur_kill_streak];
	if (isDefined(killstreak_title))
	{
		attacker iPrintLnBold(&"MP_KILLSTREAK_NUMKILLS",attacker.cur_kill_streak);
		attacker iPrintLnBold(killstreak_title);
	}
}