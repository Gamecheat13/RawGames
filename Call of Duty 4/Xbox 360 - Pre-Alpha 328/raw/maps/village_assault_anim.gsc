#using_animtree( "generic_human" );
main()
{
	// Chess Game
	level.scr_anim[ "chessplayer1" ][ "idle" ][ 0 ]		= %parabolic_chessgame_idle_a;
	level.scr_anim[ "chessplayer1" ][ "react" ] 		= %parabolic_chessgame_surprise_a;
	level.scr_anim[ "chessplayer1" ][ "death" ] 		= %parabolic_chessgame_death_a;
	level.scr_anim[ "chessplayer2" ][ "idle" ][ 0 ]		= %parabolic_chessgame_idle_b;
	level.scr_anim[ "chessplayer2" ][ "react" ]			= %parabolic_chessgame_surprise_b;
	level.scr_anim[ "chessplayer2" ][ "death" ] 		= %parabolic_chessgame_death_b;
	
	// Sleeping Guard
	level.scr_anim[ "sleeping_guard" ][ "idle" ][ 0 ]	= %parabolic_guard_sleeper_idle;
	level.scr_anim[ "sleeping_guard" ][ "react" ]		= %parabolic_guard_sleeper_react;
	
	// Smoking Guard
	level.scr_anim[ "smoking_guard" ][ "idle" ][ 0 ]	= %parabolic_leaning_guy_smoking_idle;
	level.scr_anim[ "smoking_guard" ][ "idle" ][ 1 ]	= %parabolic_leaning_guy_smoking_idle;
	level.scr_anim[ "smoking_guard" ][ "idle" ][ 2 ]	= %parabolic_leaning_guy_smoking_twitch;
	
	// Leaning Guard
	level.scr_anim[ "leaning_guard" ][ "idle" ][ 0 ]	= %parabolic_leaning_guy_idle;
	level.scr_anim[ "leaning_guard" ][ "idle" ][ 1 ]	= %parabolic_leaning_guy_idle;
	level.scr_anim[ "leaning_guard" ][ "idle" ][ 2 ]	= %parabolic_leaning_guy_twitch;
	
	// Standing Patrol Guard
	level.scr_anim[ "patrolstand" ][ "idle" ][ 0 ]		= %patrolstand_idle;
	level.scr_anim[ "patrolstand" ][ "idle" ][ 1 ]		= %patrolstand_look;
	level.scr_anim[ "patrolstand" ][ "idle" ][ 2 ]		= %patrolstand_twitch;
	
	// Assasination Animations for Loyalist Russians
	level.scr_anim[ "executioner" ][ "idle" ][ 0 ]		= %patrolstand_idle;
	level.scr_anim[ "executioner" ][ "idle" ][ 1 ]		= %patrolstand_look;
	level.scr_anim[ "executioner" ][ "idle" ][ 2 ]		= %patrolstand_twitch;
	
	level.scr_anim[ "assasinated" ][ "knees_fall" ]			= %hostage_knees_fall;
	level.scr_anim[ "assasinated" ][ "knees_idle" ][ 0 ]	= %hostage_knees_idle;
	level.scr_anim[ "assasinated" ][ "stand_fall" ]			= %hostage_stand_fall;
	level.scr_anim[ "assasinated" ][ "stand_idle1" ]		= %hostage_stand_idle;
	level.scr_anim[ "assasinated" ][ "stand_idle2" ]		= %hostage_stand_idle_2;
	
	// Dead civilian poses
	//cargoship_dead_dude
}