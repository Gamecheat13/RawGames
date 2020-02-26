#include maps\mp\_utility;
#include maps\mp\gametypes\_hud_util;

main()
{
	maps\mp\gametypes\war::main();
	
	makeDvarServerInfo( "ui_hud_hardcore", 1 );
	makeDvarServerInfo( "cg_drawCrosshair", 0 );
	makeDvarServerInfo( "cg_drawCrosshairNames", 0 );
	makeDvarServerInfo( "ui_hud_hitnotify", 0 );
	setDvar( "ui_hud_hardcore", 1 );
	setDvar( "cg_drawCrosshair", 0 );
	setDvar( "cg_drawCrosshairNames", 0 );
	setDvar( "ui_hud_hitnotify", 0 );
//	setDvar( "scr_player_numlives", 1 );
	setDvar( "scr_team_fftype", 1 );
	setDvar( "scr_hardpoint_allowartillery", 0 );
	setDvar( "scr_hardpoint_allowuav", 0 );
	setDvar( "scr_hardpoint_allowsupply", 0 );
	setDvar( "scr_hardpoint_allowhelicopter", 0 );
	setDvar( "scr_hardpoint_allowac130", 0 );
	setDvar( "scr_hardpoint_allowradar", 0 );
	setDvar( "scr_hardpoint_allowsupplycache", 0 );
	setDvar( "scr_player_maxhealth", 30 );
	setDvar( "scr_player_healthregentime", 0 );
	setDvar( "scr_game_spectatetype", 2 );
	setDvar( "scr_game_allowkillcam", 0 );
	setDvar( "scr_team_respawntime", 20 );
	setDvar( "ui_hud_showtimer", 0 );
	setDvar( "ui_hud_showscore", 0 );
	
	maps\mp\gametypes\_globallogic::registerTimeLimitDvar( level.gameType, 5, 0, 1440 );
	maps\mp\gametypes\_globallogic::registerScoreLimitDvar( level.gameType, 750, 0, 5000 );
	maps\mp\gametypes\_globallogic::registerRoundLimitDvar( level.gameType, 1, 0, 10 );
//	maps\mp\gametypes\_globallogic::registerNumLivesDvar( "thc", 0, 0, 10 );	
}
				
