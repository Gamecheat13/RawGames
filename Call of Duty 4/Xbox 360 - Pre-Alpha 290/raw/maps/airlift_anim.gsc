#include maps\_anim;
#using_animtree("generic_human");

main()
{
	anims();
	dialogue();
}

anims()
{
	level.scr_anim[ "frnd" ][ "spin" ] 								= %combatwalk_F_spin;

	/*-----------------------
	TEMP SEAKNIGHT LOADS/UNLOADS
	-------------------------*/	
	level.scr_anim[ "generic" ][ "ch46_load_1" ]					= %ch46_load_1;
	level.scr_anim[ "generic" ][ "ch46_load_2" ]					= %ch46_load_2;		
	level.scr_anim[ "generic" ][ "ch46_load_3" ]					= %ch46_load_3;
	level.scr_anim[ "generic" ][ "ch46_load_4" ]					= %ch46_load_4;	
	
	level.scr_anim[ "generic" ][ "ch46_unload_1" ]					= %ch46_unload_1;
	level.scr_anim[ "generic" ][ "ch46_unload_2" ]					= %ch46_unload_2;		
	level.scr_anim[ "generic" ][ "ch46_unload_3" ]					= %ch46_unload_3;	
	level.scr_anim[ "generic" ][ "ch46_unload_4" ]					= %ch46_unload_4;

	level.scr_anim[ "generic" ][ "ch46_unload_idle" ][0]			= %exposed_crouch_idle_alert_v1;
	//level.scr_anim[ "generic" ][ "ch46_unload_idle" ][0]			= %exposed_crouch_idle_alert_v2;
	//level.scr_anim[ "generic" ][ "ch46_unload_idle" ][0]			= %crouch_exposed_idleB;

	/*-----------------------
	RPG SEQUENCE
	-------------------------*/	
	level.scr_anim[ "frnd" ][ "AT4_fire_start" ]					= %launchfacility_a_at4_fire;
	level.scr_anim[ "frnd" ][ "AT4_fire" ]							= %launchfacility_a_at4_fire;
	level.scr_anim[ "frnd" ][ "AT4_idle" ][0]						= %corner_standr_alert_idle;
	/*-----------------------
	RPG SEQUENCE 2
	-------------------------*/	
	level.scr_anim[ "frnd" ][ "RPG_conceal_idle_start" ]			= %RPG_conceal_idle;
	level.scr_anim[ "frnd" ][ "RPG_conceal_idle" ][0]				= %RPG_conceal_idle;
	level.scr_anim[ "frnd" ][ "RPG_conceal_2_standR" ]				= %RPG_conceal_2_standR;
	level.scr_anim[ "frnd" ][ "RPG_stand_idle" ][0]					= %RPG_stand_idle;
	level.scr_anim[ "frnd" ][ "RPG_stand_fire" ]					= %RPG_stand_fire;
	level.scr_anim[ "frnd" ][ "RPG_standR_2_conceal" ]				= %RPG_standR_2_conceal;


	/*-----------------------
	SEAKNIGHT CREWCHIEF
	-------------------------*/	
	level.scr_anim[ "frnd" ][ "crewchief_idle" ][0]				= %airlift_crewchief_idle;
	
	/*-----------------------
	WOUNDED PILOT
	-------------------------*/	
	level.scr_anim[ "frnd" ][ "wounded_pullout" ]				= %airlift_pilot_getout;
	level.scr_anim[ "frnd" ][ "wounded_cockpit_shoot" ][ 0 ]	= %airlift_pilot_shooting;
	level.scr_anim[ "frnd" ][ "wounded_cockpit_wave_over" ][ 0 ]= %airlift_pilot_shooting;
	level.scr_anim[ "frnd" ][ "wounded_putdown" ]				= %airlift_pilot_putdown;

	
	
	/*-----------------------
	DEAD PILOT
	-------------------------*/	
	level.scr_anim[ "frnd" ][ "deadpilot_idle" ][ 0 ]			= %airlift_copilot_dead;
	
				

			
}

dialogue()
{
	/*-----------------------
	DIALOGUE
	-------------------------*/	
	//tbd
	
	
	
	
	
	player_carry();
	tank_crush_anims();
	seaknight_anims();
}

#using_animtree( "player" );
player_carry()
{
	//animations that will be played by the player (actually played by an invisible model the player is linked to)
	//animname will be "player_carry"
	level.scr_anim[ "player_carry" ][ "wounded_pullout" ]				= %airlift_player_getout;
	level.scr_anim[ "player_carry" ][ "wounded_putdown" ]				= %airlift_player_putdown;

	//the animtree to use with the invisible model with animname "player_carry"
	level.scr_animtree[ "player_carry" ] 								= #animtree;	
	//the invisible model with the animname "player_carry" that the anims will be played on
	level.scr_model[ "player_carry" ] 									= "viewhands_player_marines";
}	

#using_animtree( "vehicles" );
tank_crush_anims()
{
	level.scr_animtree[ "tank_crush" ]			= #animtree;
	level.scr_anim[ "sedan" ][ "tank_crush" ]	= %sedan_tankcrush_side;
	level.scr_anim[ "tank" ][ "tank_crush" ] 	= %tank_tankcrush_side;
	level.scr_sound[ "tank_crush" ]				= "airlift_tank_crush_car";
}

#using_animtree( "vehicles" );
seaknight_anims()
{
	level.scr_anim[ "seaknight" ][ "idle" ][ 0 ] 				= %sniper_escape_ch46_idle;
	level.scr_anim[ "seaknight" ][ "landing" ] 					= %sniper_escape_ch46_land;
	level.scr_anim[ "seaknight" ][ "take_off" ] 				= %sniper_escape_ch46_take_off;
	
	level.scr_animtree[ "seaknight" ] 							= #animtree;
}
