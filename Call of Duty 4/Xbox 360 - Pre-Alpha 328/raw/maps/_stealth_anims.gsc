main()
{
	humans();
	dogs();	
}

#using_animtree("generic_human");
humans()
{
	level.scr_anim[ "generic" ][ "_stealth_patrol_jog" ]				= %patrol_jog;				
	level.scr_anim[ "generic" ][ "_stealth_patrol_walk" ]				= %patrol_bored_patrolwalk;	
	level.scr_anim[ "generic" ][ "_stealth_combat_jog" ]				= %combat_jog;
	
	level.scr_anim[ "generic" ][ "_stealth_behavior_whizby_0" ]			= %exposed_idle_reactA;
	level.scr_anim[ "generic" ][ "_stealth_behavior_whizby_1" ]			= %exposed_idle_reactB;
	level.scr_anim[ "generic" ][ "_stealth_behavior_whizby_2" ]			= %exposed_idle_twitch;
	level.scr_anim[ "generic" ][ "_stealth_behavior_whizby_3" ]			= %exposed_idle_twitch_v4;
	level.scr_anim[ "generic" ][ "_stealth_behavior_whizby_4" ]			= %run_pain_stumble;
	
	level.scr_anim[ "generic" ][ "_stealth_behavior_generic" ]			= %exposed_idle_twitch_v4;		
	level.scr_anim[ "generic" ][ "_stealth_behavior_spotted_short" ]	= %exposed_idle_twitch_v4;		
	level.scr_anim[ "generic" ][ "_stealth_behavior_spotted_long" ]		= %exposed_idle_twitch_v4;		
}

#using_animtree("dog");
dogs()
{
	level.scr_anim[ "generic" ][ "_stealth_dog_sleeping" ][0]		= %german_shepherd_sleeping;
	
	level.scr_anim[ "generic" ][ "_stealth_dog_wakeup_fast" ]		= %german_shepherd_wakeup_fast;
	level.scr_anim[ "generic" ][ "_stealth_dog_wakeup_slow" ]		= %german_shepherd_wakeup_slow;
}
