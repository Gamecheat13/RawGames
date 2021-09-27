#include common_scripts\utility;
#include maps\_utility;
#include maps\_anim;

#using_animtree( "generic_human" );
main()
{
	hamburg_player_anims();
	level_dialogue();
	vehicle_anims();
	human_anims();
	minigun_anims();
	crane_crash();
}


human_anims()
{
	// beach anims
	level.scr_anim[ "generic" ][ "death_sitting_pose_v1" ] 					= %death_sitting_pose_v1;
	
	level.scr_anim[ "generic" ][ "run_low" ] 		    	= %run_lowready_F;
	level.scr_anim[ "generic" ][ "carrier_walk_loop" ] 		    = %wounded_carry_jog_carrier;	
	level.scr_anim[ "generic" ][ "wounded_carry_fastwalk_carrier" ]  = %wounded_carry_fastwalk_carrier;	
	level.scr_anim[ "generic" ][ "wounded_three" ] 		    = %wounded_carry_sprint_carrier;	
	
	level.scr_anim[ "generic" ][ "patrol_jog" ] 		    = %patrol_jog;	
	level.scr_anim[ "generic" ][ "patrol_jog_orders" ] 		= %patrol_jog_orders;	
	
	level.scr_anim[ "generic" ][ "crouch_sprint" ] 					= %crouch_sprint;
	
	level.scr_anim[ "generic" ][ "airport_civ_dying_groupB_wounded" ] = %airport_civ_dying_groupB_wounded;
	level.scr_anim[ "generic" ][ "airport_civ_dying_groupB_wounded_death" ] = %airport_civ_dying_groupB_wounded_death;
	
	level.scr_anim[ "generic" ][ "airport_civ_dying_groupB_pull_death" ] 	= %airport_civ_dying_groupB_pull_death;
	level.scr_anim[ "generic" ][ "airport_civ_dying_groupB_pull" ] 			= %airport_civ_dying_groupB_pull;
	
	level.scr_anim[ "generic" ][ "airport_civ_dying_groupB_pull" ] 			= %airport_civ_dying_groupB_pull;
	level.scr_anim[ "generic" ][ "airport_civ_dying_groupB_pull" ] 			= %airport_civ_dying_groupB_pull;
	level.scr_anim[ "generic" ][ "airport_civ_dying_groupB_pull" ] 			= %airport_civ_dying_groupB_pull;
	
	level.scr_anim[ "generic" ][ "payback_pmc_sandstorm_stumble_1" ] 			= %payback_pmc_sandstorm_stumble_1;
	level.scr_anim[ "generic" ][ "payback_pmc_sandstorm_stumble_2" ] 			= %payback_pmc_sandstorm_stumble_2;
	level.scr_anim[ "generic" ][ "payback_pmc_sandstorm_stumble_3" ] 			= %payback_pmc_sandstorm_stumble_3;
	
	level.scr_anim[ "generic" ][ "hunted_dazed_walk_A_zombie" ] 		= %hunted_dazed_walk_A_zombie;
	level.scr_anim[ "generic" ][ "hunted_dazed_walk_B_blind" ] 			= %hunted_dazed_walk_B_blind;				
	level.scr_anim[ "generic" ][ "hunted_dazed_walk_C_limp" ] 			= %hunted_dazed_walk_C_limp;	
					
	level.scr_anim[ "generic" ][ "hamburg_tank_call" ] 			= %hamburg_tank_call;		
	level.scr_anim[ "tank_loader" ][ "idle_reload" ] 		= %abrams_loader_load;
}


#using_animtree( "player" );
hamburg_player_anims()
{
	level.scr_animtree[ "player_rig" ] 					 	= #animtree;
	level.scr_anim[ "player_rig" ][ "player_getin" ] 		 = %roadkill_hummer_player_getin;
	level.scr_model[ "player_rig" ] 						 = "viewhands_player_delta";

	level.scr_anim[ "player_rig" ][ "mount_tank" ] 		 = %hamburg_tank_entry_upperbody;

	level.scr_animtree[ "player_rig_legs" ] 					 		= #animtree;
	level.scr_model[ "player_rig_legs" ] 							= "viewlegs_generic";
	level.scr_anim[ "player_rig_legs" ][ "mount_tank" ] 							= %hamburg_tank_entry_lowerbody;
}

level_dialogue()
{
	//Sandman: Has NSA geolocated his beacon?
	radio_add( "tank_snd_locatedbeacon" );
	//Overlord: Negative - we lost all contact 10 minutes ago.
	radio_add( "tank_hqr_lostallcontact" );
	//Sandman: Send the last known location of the HVI as well as recent photos of all AMCITS on site!
	radio_add( "tank_snd_sendlast" );
	//Overlord: Uploading now…
	radio_add( "tank_hqr_uploadingnow" );
	//Sandman: Get me OPCON of all available ISR assets in the area! And one more thing. I’ll need execute authority. Goalpost’s survival is gonna come down to seconds, not minutes.
	radio_add( "tank_snd_getmeopcon" );
	radio_add( "hamburg_op2_raptorinbound" );
	
	radio_add( "hamburg_snd_regroup" );
	
	level.scr_sound[ "sandman" ][ "hamburg_snd_holdup" ]		= "hamburg_snd_holdup";
	level.scr_sound[ "sandman" ][ "hamburg_snd_sniper" ]		= "hamburg_snd_sniper";
	radio_add( "tank_rh1_wherearetargets" );
	level.scr_sound[ "sandman" ][ "hamburg_snd_hititnow" ]		= "hamburg_snd_hititnow";
	
	level.scr_sound[ "sandman" ][ "hamburg_snd_onminigun" ]		= "hamburg_snd_onminigun";
	level.scr_sound[ "sandman" ][ "hamburg_snd_upyougo" ]		= "hamburg_snd_upyougo";
	level.scr_sound[ "sandman" ][ "hamburg_snd_getongun" ]		= "hamburg_snd_getongun";

	level.scr_sound[ "sandman" ][ "hamburg_snd_rightflank" ]		= "hamburg_snd_rightflank";
	level.scr_sound[ "sandman" ][ "hamburg_snd_goinright" ]		= "hamburg_snd_goinright";
	level.scr_sound[ "sandman" ][ "hamburg_snd_sticktoright" ]		= "hamburg_snd_sticktoright";

	level.scr_sound[ "sandman" ][ "hamburg_snd_letsgomove" ]		= "hamburg_snd_letsgomove";

	radio_add( "hamburg_snd_nevermadeit" );
	


		/*-----------------------
	MORTAR EFFECTS & SOUNDS
	-------------------------*/	
	level._effect[ "mortar" ][ "bunker_ceiling" ]		 = LoadFX( "dust/ceiling_dust_bunker" );
	level._effect[ "mortar" ][ "bunker_ceiling_green" ]	 = LoadFX( "dust/ceiling_dust_bunker_green" );
	level._effect[ "mortar" ][ "concrete" ]				 = LoadFX( "explosions/grenadeExp_concrete_1_low" );
	
	level.scr_sound[ "mortar" ][ "incomming" ]				 = "mortar_incoming";
	level.scr_sound[ "mortar" ][ "dirt" ]					 = "mortar_explosion_dirt";
	level.scr_sound[ "mortar" ][ "dirt_large" ]				 = "mortar_explosion_dirt";
	level.scr_sound[ "mortar" ][ "concrete" ]				 = "mortar_explosion_dirt";
	level.scr_sound[ "mortar" ][ "mud" ]					 = "mortar_explosion_water";
	level.scr_sound[ "mortar" ][ "water" ]					 = "mortar_explosion_water";
	level.scr_sound[ "mortar" ][ "water_ocean" ]					 = "mortar_explosion_water";
}

#using_animtree( "vehicles" );
vehicle_anims()
{
	level.scr_anim[ "generic" ][ "hovercraft_tank_back_exit" ] 		= %lcac_tank_exit_02	;	
	level.scr_anim[ "generic" ][ "hovercraft_tank_forward_exit" ] 		= %lcac_tank_exit_01	;	
	
	level.scr_anim[ "suburban_hands" ][ "player_getin" ] 					 = %hamburg_minigun_mount;
	level.scr_model[ "suburban_hands" ] 											= "weapon_m1a1_minigun";
	level.scr_animtree[ "suburban_hands" ]					 				 = #animtree;
}

#using_animtree( "script_model" );
crane_crash()
{
	level.scr_animtree[ "crane" ] 					 	= #animtree;
	level.scr_anim[ "crane" ][ "crash" ] 				= %hamburg_crane_crash_crane;
	
}

#using_animtree( "vehicles" );
minigun_anims()
{
	level.scr_animtree[ "minigun_m1a1" ] 					= #animtree;	
	level.scr_model[ "minigun_m1a1" ] 						= "weapon_m1a1_minigun";
	level.scr_anim[ "minigun_m1a1" ][ "mount_tank" ]				= %hamburg_tank_entry_minigun;
}
