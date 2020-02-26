// Here be where all animations shall one day live.
#include common_scripts\Utility;
#include maps\_utility;
#include animscripts\anims_table;

#using_animtree ("generic_human");

#insert raw\common_scripts\utility.gsh;
#insert raw\animscripts\utility.gsh;

//-------------------------------------------------------------------------------------
// Some of the CQB anims are stored on the AI itself, so that we can vary them a little 
// and the animation lookup will not play combat animations in cover
//-------------------------------------------------------------------------------------
setup_self_elite_anim_array()
{
	Assert( self.subclass == "elite" );
	
	self animscripts\anims::clearAnimCache();
	
	if( !IsDefined( self.anim_array ) )
		self.anim_array = [];
			
//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
// Begin Stop Actions
//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
	
	self.anim_array[self.animType]["stop"]["stand"]["rifle"]["idle_trans_in"]				= %ai_elite_casual_stand_idle_trans_in;
	self.anim_array[self.animType]["stop"]["stand"]["rifle"]["idle"]							= array( array( %ai_elite_casual_stand_idle, 
	                                                                                      						%ai_elite_casual_stand_idle_twitch, 
	                                                                                      						%ai_elite_casual_stand_idle_twitchb 
	                                                                                      					) );
	
//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
// End Stop Actions
//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
		
//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
// Begin Combat Stand Rifle Actions
//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
	
	self.anim_array[self.animType]["combat"]["stand"]["rifle"]["exposed_idle"]			= array( %ai_elite_exposed_idle_alert_v1 );
	self.anim_array[self.animType]["combat"]["stand"]["rifle"]["idle_trans_out"]			= %ai_elite_casual_stand_idle_trans_out;
		
	self.anim_array[self.animType]["combat"]["stand"]["rifle"]["fire"]					= %ai_elite_exposed_shoot_auto_v3;
	self.anim_array[self.animType]["combat"]["stand"]["rifle"]["single"]					= array( %ai_elite_exposed_shoot_semi2 );
	self.anim_array[self.animType]["combat"]["stand"]["rifle"]["burst2"]					= %ai_elite_exposed_shoot_burst3; // ( will be stopped after second bullet)
	self.anim_array[self.animType]["combat"]["stand"]["rifle"]["burst3"]					= %ai_elite_exposed_shoot_burst3;
	self.anim_array[self.animType]["combat"]["stand"]["rifle"]["burst4"]					= %ai_elite_exposed_shoot_burst4;
	self.anim_array[self.animType]["combat"]["stand"]["rifle"]["burst5"]					= %ai_elite_exposed_shoot_burst5;
	self.anim_array[self.animType]["combat"]["stand"]["rifle"]["burst6"]					= %ai_elite_exposed_shoot_burst6;
	self.anim_array[self.animType]["combat"]["stand"]["rifle"]["semi2"]					= %ai_elite_exposed_shoot_semi2;
	self.anim_array[self.animType]["combat"]["stand"]["rifle"]["semi3"]					= %ai_elite_exposed_shoot_semi3;
	self.anim_array[self.animType]["combat"]["stand"]["rifle"]["semi4"]					= %ai_elite_exposed_shoot_semi4;
	self.anim_array[self.animType]["combat"]["stand"]["rifle"]["semi5"]					= %ai_elite_exposed_shoot_semi5;
		
	self.anim_array[self.animType]["combat"]["stand"]["rifle"]["reload"]					= array( %ai_elite_exposed_reload ); 
	self.anim_array[self.animType]["combat"]["stand"]["rifle"]["reload_crouchhide"]		= array( %ai_elite_exposed_reload );
	
	self.anim_array[self.animType]["combat"]["stand"]["rifle"]["turn_left_45"]			= %ai_elite_exposed_tracking_turn45l;
	self.anim_array[self.animType]["combat"]["stand"]["rifle"]["turn_left_90"]			= %ai_elite_exposed_tracking_turn90l;
	self.anim_array[self.animType]["combat"]["stand"]["rifle"]["turn_left_135"]			= %ai_elite_exposed_tracking_turn135l;
	self.anim_array[self.animType]["combat"]["stand"]["rifle"]["turn_left_180"]			= %ai_elite_exposed_tracking_turn180l;
	self.anim_array[self.animType]["combat"]["stand"]["rifle"]["turn_right_45"]			= %ai_elite_exposed_tracking_turn45r;
	self.anim_array[self.animType]["combat"]["stand"]["rifle"]["turn_right_90"]			= %ai_elite_exposed_tracking_turn90r;
	self.anim_array[self.animType]["combat"]["stand"]["rifle"]["turn_right_135"]		= %ai_elite_exposed_tracking_turn135r;
	self.anim_array[self.animType]["combat"]["stand"]["rifle"]["turn_right_180"]		= %ai_elite_exposed_tracking_turn180r;		
	
	self.anim_array[self.animType]["combat"]["stand"]["rifle"]["straight_level"]			= %ai_elite_exposed_aim_5;
	self.anim_array[self.animType]["combat"]["stand"]["rifle"]["add_aim_up"]				= %ai_elite_exposed_aim_8;
	self.anim_array[self.animType]["combat"]["stand"]["rifle"]["add_aim_down"]				= %ai_elite_exposed_aim_2;
	self.anim_array[self.animType]["combat"]["stand"]["rifle"]["add_aim_left"]				= %ai_elite_exposed_aim_4;
	self.anim_array[self.animType]["combat"]["stand"]["rifle"]["add_aim_right"]				= %ai_elite_exposed_aim_6;
	
	self.anim_array[self.animType]["combat"]["stand"]["rifle"]["add_turn_aim_up"]			= %ai_elite_exposed_aim_8;
	self.anim_array[self.animType]["combat"]["stand"]["rifle"]["add_turn_aim_down"]			= %ai_elite_exposed_aim_2;
	self.anim_array[self.animType]["combat"]["stand"]["rifle"]["add_turn_aim_left"]			= %ai_elite_exposed_aim_4;
	self.anim_array[self.animType]["combat"]["stand"]["rifle"]["add_turn_aim_right"]		= %ai_elite_exposed_aim_6;
	
	self.anim_array[self.animType]["combat"]["stand"]["rifle"]["crouch_2_stand"]			= %ai_elite_exposed_crouch_2_stand;
	self.anim_array[self.animType]["combat"]["stand"]["rifle"]["stand_2_crouch"]			= %ai_elite_exposed_stand_2_crouch;
	
	self.anim_array[self.animType]["combat"]["stand"]["rifle"]["grenade_throw"]				= %ai_elite_exposed_grenadethrow_a;
	self.anim_array[self.animType]["combat"]["stand"]["rifle"]["grenade_throw_1"]			= %ai_elite_exposed_grenadethrow_a;
	self.anim_array[self.animType]["combat"]["stand"]["rifle"]["grenade_throw_2"]			= %ai_elite_exposed_grenadethrow_a;

//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
// End Combat Stand Rifle Actions
//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////


//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
// Begin Combat Crouch Rifle Actions
//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
	self.anim_array[self.animType]["combat"]["crouch"]["rifle"]["exposed_idle"]				= array( %ai_elite_exposed_crouch_idle_alert_v1 );
	
	self.anim_array[self.animType]["combat"]["crouch"]["rifle"]["fire"]						= %ai_elite_exposed_crouch_shoot_auto_v2;
	self.anim_array[self.animType]["combat"]["crouch"]["rifle"]["single"]					= array( %ai_elite_exposed_crouch_shoot_semi2 );
	self.anim_array[self.animType]["combat"]["crouch"]["rifle"]["burst2"]					= %ai_elite_exposed_crouch_shoot_burst3; // ( will be stopped after second bullet)
	self.anim_array[self.animType]["combat"]["crouch"]["rifle"]["burst3"]					= %ai_elite_exposed_crouch_shoot_burst3;
	self.anim_array[self.animType]["combat"]["crouch"]["rifle"]["burst4"]					= %ai_elite_exposed_crouch_shoot_burst4;
	self.anim_array[self.animType]["combat"]["crouch"]["rifle"]["burst5"]					= %ai_elite_exposed_crouch_shoot_burst5;
	self.anim_array[self.animType]["combat"]["crouch"]["rifle"]["burst6"]					= %ai_elite_exposed_crouch_shoot_burst6;
	self.anim_array[self.animType]["combat"]["crouch"]["rifle"]["semi2"]					= %ai_elite_exposed_crouch_shoot_semi2;
	self.anim_array[self.animType]["combat"]["crouch"]["rifle"]["semi3"]					= %ai_elite_exposed_crouch_shoot_semi3;
	self.anim_array[self.animType]["combat"]["crouch"]["rifle"]["semi4"]					= %ai_elite_exposed_crouch_shoot_semi4;
	self.anim_array[self.animType]["combat"]["crouch"]["rifle"]["semi5"]					= %ai_elite_exposed_crouch_shoot_semi5;

	self.anim_array[self.animType]["combat"]["crouch"]["rifle"]["reload"]					= array( %ai_elite_exposed_crouch_reload );
	
	self.anim_array[self.animType]["combat"]["crouch"]["rifle"]["turn_left_45"]				= %ai_elite_exposed_crouch_turn_l;
	self.anim_array[self.animType]["combat"]["crouch"]["rifle"]["turn_left_90"]				= %ai_elite_exposed_crouch_turn_l;
	self.anim_array[self.animType]["combat"]["crouch"]["rifle"]["turn_left_135"]			= %ai_elite_exposed_crouch_turn_l;
	self.anim_array[self.animType]["combat"]["crouch"]["rifle"]["turn_left_180"]			= %ai_elite_exposed_crouch_turn_l;
	self.anim_array[self.animType]["combat"]["crouch"]["rifle"]["turn_right_45"]			= %ai_elite_exposed_crouch_turn_r;
	self.anim_array[self.animType]["combat"]["crouch"]["rifle"]["turn_right_90"]			= %ai_elite_exposed_crouch_turn_r;
	self.anim_array[self.animType]["combat"]["crouch"]["rifle"]["turn_right_135"]			= %ai_elite_exposed_crouch_turn_r;
	self.anim_array[self.animType]["combat"]["crouch"]["rifle"]["turn_right_180"]			= %ai_elite_exposed_crouch_turn_r;		
	
	self.anim_array[self.animType]["combat"]["crouch"]["rifle"]["straight_level"]			= %ai_elite_exposed_crouch_aim_5;
	self.anim_array[self.animType]["combat"]["crouch"]["rifle"]["add_aim_up"]				= %ai_elite_exposed_crouch_aim_8;
	self.anim_array[self.animType]["combat"]["crouch"]["rifle"]["add_aim_down"]				= %ai_elite_exposed_crouch_aim_2;
	self.anim_array[self.animType]["combat"]["crouch"]["rifle"]["add_aim_left"]				= %ai_elite_exposed_crouch_aim_4;
	self.anim_array[self.animType]["combat"]["crouch"]["rifle"]["add_aim_right"]			= %ai_elite_exposed_crouch_aim_6;  
	
	self.anim_array[self.animType]["combat"]["crouch"]["rifle"]["add_turn_aim_up"]			= %ai_elite_exposed_crouch_aim_8;
	self.anim_array[self.animType]["combat"]["crouch"]["rifle"]["add_turn_aim_down"]		= %ai_elite_exposed_crouch_aim_2;
	self.anim_array[self.animType]["combat"]["crouch"]["rifle"]["add_turn_aim_left"]		= %ai_elite_exposed_crouch_aim_4;
	self.anim_array[self.animType]["combat"]["crouch"]["rifle"]["add_turn_aim_right"]		= %ai_elite_exposed_crouch_aim_6;
			
	self.anim_array[self.animType]["combat"]["crouch"]["rifle"]["crouch_2_stand"]			= %ai_elite_exposed_crouch_2_stand;
	self.anim_array[self.animType]["combat"]["crouch"]["rifle"]["stand_2_crouch"]			= %ai_elite_exposed_stand_2_crouch;

//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
// End Combat Crouch Rifle Actions
//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////


}

setup_elite_anim_array()
{
	Assert( self.subclass == "elite" );

	subclassType = self.subclass;

	setup_self_elite_anim_array();
	
	if( IsDefined( anim.anim_array[subclassType] ) )
		return;

	self animscripts\anims::clearAnimCache();
	
	anim.anim_array[subclassType] = [];

//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
// Begin Run Actions
//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

	anim.anim_array[subclassType]["move"]["stand"]["rifle"]["combat_run_f"]				= %ai_elite_run_lowready_f;
	
	anim.anim_array[subclassType]["move"]["stand"]["rifle"]["sprint"]						= array( %ai_elite_sprint_f );
	
//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
// End Run Actions
//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
// Begin Cover Arrival Actions
//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

	anim.anim_array[subclassType]["move"]["stand"]["rifle"]["arrive_exposed"][1]			= %ai_elite_exposed_arrival_1;
	anim.anim_array[subclassType]["move"]["stand"]["rifle"]["arrive_exposed"][2]			= %ai_elite_exposed_arrival_2;
	anim.anim_array[subclassType]["move"]["stand"]["rifle"]["arrive_exposed"][3]			= %ai_elite_exposed_arrival_3;
	anim.anim_array[subclassType]["move"]["stand"]["rifle"]["arrive_exposed"][4]			= %ai_elite_exposed_arrival_4;
	anim.anim_array[subclassType]["move"]["stand"]["rifle"]["arrive_exposed"][6]			= %ai_elite_exposed_arrival_6;
	anim.anim_array[subclassType]["move"]["stand"]["rifle"]["arrive_exposed"][7]			= %ai_elite_exposed_arrival_7;
	anim.anim_array[subclassType]["move"]["stand"]["rifle"]["arrive_exposed"][8]			= %ai_elite_exposed_arrival_8;
	anim.anim_array[subclassType]["move"]["stand"]["rifle"]["arrive_exposed"][9]			= %ai_elite_exposed_arrival_9;

	anim.anim_array[subclassType]["move"]["stand"]["rifle"]["arrive_exposed_crouch"][1]	= %ai_elite_exposed_crouch_arrival_1;
	anim.anim_array[subclassType]["move"]["stand"]["rifle"]["arrive_exposed_crouch"][2]	= %ai_elite_exposed_crouch_arrival_2;
	anim.anim_array[subclassType]["move"]["stand"]["rifle"]["arrive_exposed_crouch"][3]	= %ai_elite_exposed_crouch_arrival_3;
	anim.anim_array[subclassType]["move"]["stand"]["rifle"]["arrive_exposed_crouch"][4]	= %ai_elite_exposed_crouch_arrival_4;
	anim.anim_array[subclassType]["move"]["stand"]["rifle"]["arrive_exposed_crouch"][6]	= %ai_elite_exposed_crouch_arrival_6;
	anim.anim_array[subclassType]["move"]["stand"]["rifle"]["arrive_exposed_crouch"][7]	= %ai_elite_exposed_crouch_arrival_7;
	anim.anim_array[subclassType]["move"]["stand"]["rifle"]["arrive_exposed_crouch"][8]	= %ai_elite_exposed_crouch_arrival_8;
	anim.anim_array[subclassType]["move"]["stand"]["rifle"]["arrive_exposed_crouch"][9]	= %ai_elite_exposed_crouch_arrival_9;

//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
// End Cover Arrival Actions
//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
// Begin Cover Exit Actions
//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

	anim.anim_array[subclassType]["move"]["stand"]["rifle"]["exit_exposed"][1]				= %ai_elite_exposed_exit_1;
	anim.anim_array[subclassType]["move"]["stand"]["rifle"]["exit_exposed"][2]				= %ai_elite_exposed_exit_2;
	anim.anim_array[subclassType]["move"]["stand"]["rifle"]["exit_exposed"][3]				= %ai_elite_exposed_exit_3;
	anim.anim_array[subclassType]["move"]["stand"]["rifle"]["exit_exposed"][4]				= %ai_elite_exposed_exit_4;
	anim.anim_array[subclassType]["move"]["stand"]["rifle"]["exit_exposed"][6]				= %ai_elite_exposed_exit_6;
	anim.anim_array[subclassType]["move"]["stand"]["rifle"]["exit_exposed"][7]				= %ai_elite_exposed_exit_7;
	anim.anim_array[subclassType]["move"]["stand"]["rifle"]["exit_exposed"][8]				= %ai_elite_exposed_exit_8;
	anim.anim_array[subclassType]["move"]["stand"]["rifle"]["exit_exposed"][9]				= %ai_elite_exposed_exit_9;
	
	anim.anim_array[subclassType]["move"]["stand"]["rifle"]["exit_exposed_crouch"][1]		= %ai_elite_exposed_crouch_exit_1;
	anim.anim_array[subclassType]["move"]["stand"]["rifle"]["exit_exposed_crouch"][2]		= %ai_elite_exposed_crouch_exit_2;
	anim.anim_array[subclassType]["move"]["stand"]["rifle"]["exit_exposed_crouch"][3]		= %ai_elite_exposed_crouch_exit_3;
	anim.anim_array[subclassType]["move"]["stand"]["rifle"]["exit_exposed_crouch"][4]		= %ai_elite_exposed_crouch_exit_4;
	anim.anim_array[subclassType]["move"]["stand"]["rifle"]["exit_exposed_crouch"][6]		= %ai_elite_exposed_crouch_exit_6;
	anim.anim_array[subclassType]["move"]["stand"]["rifle"]["exit_exposed_crouch"][7]		= %ai_elite_exposed_crouch_exit_7;
	anim.anim_array[subclassType]["move"]["stand"]["rifle"]["exit_exposed_crouch"][8]		= %ai_elite_exposed_crouch_exit_8;
	anim.anim_array[subclassType]["move"]["stand"]["rifle"]["exit_exposed_crouch"][9]		= %ai_elite_exposed_crouch_exit_9;

//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
// End Cover Exit Actions
//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
// Begin Exposed Stand Pains
//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
		
	anim.anim_array[subclassType]["pain"]["stand"]["rifle"]["chest"]						= %ai_elite_exposed_pain_chest;
	anim.anim_array[subclassType]["pain"]["stand"]["rifle"]["groin"]						= %ai_elite_exposed_pain_groin;
	anim.anim_array[subclassType]["pain"]["stand"]["rifle"]["head"]						= %ai_elite_exposed_pain_groin;
	anim.anim_array[subclassType]["pain"]["stand"]["rifle"]["left_arm"]					= %ai_elite_exposed_pain_left_arm;
	anim.anim_array[subclassType]["pain"]["stand"]["rifle"]["right_arm"]					= %ai_elite_exposed_pain_right_arm;
	anim.anim_array[subclassType]["pain"]["stand"]["rifle"]["leg"]							= array( %ai_elite_exposed_pain_right_leg, %ai_elite_exposed_pain_left_leg );
	anim.anim_array[subclassType]["pain"]["stand"]["rifle"]["big"]							= %ai_elite_exposed_pain_groin;
	anim.anim_array[subclassType]["pain"]["stand"]["rifle"]["drop_gun"]					= %ai_elite_exposed_pain_groin;

//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
// End Exposed Stand Pains
//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
	
//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
// Begin Exposed Crouch Pains
//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
	
	anim.anim_array[subclassType]["pain"]["crouch"]["rifle"]["chest"]						= %ai_elite_exposed_crouch_pain_chest;
	anim.anim_array[subclassType]["pain"]["crouch"]["rifle"]["head"]						= %ai_elite_exposed_crouch_pain_head;
	anim.anim_array[subclassType]["pain"]["crouch"]["rifle"]["left_arm"]					= %ai_elite_exposed_crouch_pain_left_arm;
	anim.anim_array[subclassType]["pain"]["crouch"]["rifle"]["right_arm"]					= %ai_elite_exposed_crouch_pain_right_arm;
	anim.anim_array[subclassType]["pain"]["crouch"]["rifle"]["flinch"]						= %ai_elite_exposed_crouch_pain_groin;
		
//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
// End Exposed Crouch Pains
//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////


//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
// Begin Cover Left Stand Actions
//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
	
	anim.anim_array[subclassType]["cover_left"]["stand"]["rifle"]["lean_fire"]				= %ai_elite_cornerstndl_shoot_auto_v3;
	anim.anim_array[subclassType]["cover_left"]["stand"]["rifle"]["lean_semi2"]			= %ai_elite_cornerstndl_shoot_semi2;
	anim.anim_array[subclassType]["cover_left"]["stand"]["rifle"]["lean_semi3"]			= %ai_elite_cornerstndl_shoot_semi3;
	anim.anim_array[subclassType]["cover_left"]["stand"]["rifle"]["lean_semi4"]			= %ai_elite_cornerstndl_shoot_semi4;
	anim.anim_array[subclassType]["cover_left"]["stand"]["rifle"]["lean_semi5"]			= %ai_elite_cornerstndl_shoot_semi5;
	anim.anim_array[subclassType]["cover_left"]["stand"]["rifle"]["lean_burst2"]			= %ai_elite_cornerstndl_shoot_burst3;
	anim.anim_array[subclassType]["cover_left"]["stand"]["rifle"]["lean_burst3"]			= %ai_elite_cornerstndl_shoot_burst3;
	anim.anim_array[subclassType]["cover_left"]["stand"]["rifle"]["lean_burst4"]			= %ai_elite_cornerstndl_shoot_burst4;
	anim.anim_array[subclassType]["cover_left"]["stand"]["rifle"]["lean_burst5"]			= %ai_elite_cornerstndl_shoot_burst5;
	anim.anim_array[subclassType]["cover_left"]["stand"]["rifle"]["lean_burst6"]			= %ai_elite_cornerstndl_shoot_burst6;
	anim.anim_array[subclassType]["cover_left"]["stand"]["rifle"]["lean_single"]			= array( %ai_elite_cornerstndl_shoot_semi2 );
	
	anim.anim_array[subclassType]["cover_left"]["stand"]["rifle"]["lean_aim_down"]			= %ai_elite_cornerstndl_lean_aim_2;
	anim.anim_array[subclassType]["cover_left"]["stand"]["rifle"]["lean_aim_left"]			= %ai_elite_cornerstndl_lean_aim_4;
	anim.anim_array[subclassType]["cover_left"]["stand"]["rifle"]["lean_aim_straight"]		= %ai_elite_cornerstndl_lean_aim_5;
	anim.anim_array[subclassType]["cover_left"]["stand"]["rifle"]["lean_aim_right"]		= %ai_elite_cornerstndl_lean_aim_6;
	anim.anim_array[subclassType]["cover_left"]["stand"]["rifle"]["lean_aim_up"]			= %ai_elite_cornerstndl_lean_aim_8;
	
	anim.anim_array[subclassType]["cover_left"]["stand"]["rifle"]["lean_idle"]			= array( %ai_elite_cornerstndl_lean_idle );
	
	anim.anim_array[subclassType]["cover_left"]["stand"]["rifle"]["lean_to_alert"]		= array( %ai_elite_cornerstndl_lean_2_alert );
	anim.anim_array[subclassType]["cover_left"]["stand"]["rifle"]["alert_to_lean"]		= array( %ai_elite_cornerstndl_alert_2_lean );
	
	anim.anim_array[subclassType]["pain"]["stand"]["rifle"]["cover_left_lean"]			= %ai_elite_cornerstndl_lean_pain;

	anim.anim_array[subclassType]["cover_left"]["stand"]["rifle"]["alert_to_A"]			= array( %ai_elite_cornerstndl_alert_2_a );
	anim.anim_array[subclassType]["cover_left"]["stand"]["rifle"]["alert_to_B"]			= array( %ai_elite_cornerstndl_alert_2_b );
	anim.anim_array[subclassType]["cover_left"]["stand"]["rifle"]["A_to_alert"]			= array( %ai_elite_cornerstndl_a_2_alert );
	anim.anim_array[subclassType]["cover_left"]["stand"]["rifle"]["A_to_B"    ]			= array( %ai_elite_cornerstndl_a_2_b );
	
	anim.anim_array[subclassType]["cover_left"]["stand"]["rifle"]["B_to_alert"]			= array( %ai_elite_cornerstndl_b_2_alert );
	
 	anim.anim_array[subclassType]["cover_left"]["stand"]["rifle"]["B_to_A"    ]			= array( %ai_elite_cornerstndl_b_2_a );

	anim.anim_array[subclassType]["pain"]["stand"]["rifle"]["cover_left_A"]				= %ai_elite_cornerstndl_pain_a_2_alert;
	anim.anim_array[subclassType]["pain"]["stand"]["rifle"]["cover_left_B"]				= %ai_elite_cornerstndl_pain_b_2_alert;
	
//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
// End Cover Left Stand Actions
//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
// Begin Cover Left Crouch Actions
//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
	
	anim.anim_array[subclassType]["cover_left"]["crouch"]["rifle"]["lean_fire"]			= %ai_elite_cornercl_shoot_auto_v2;
	anim.anim_array[subclassType]["cover_left"]["crouch"]["rifle"]["lean_semi2"]			= %ai_elite_cornercl_shoot_semi2;
	anim.anim_array[subclassType]["cover_left"]["crouch"]["rifle"]["lean_semi3"]			= %ai_elite_cornercl_shoot_semi3;
	anim.anim_array[subclassType]["cover_left"]["crouch"]["rifle"]["lean_semi4"]			= %ai_elite_cornercl_shoot_semi4;
	anim.anim_array[subclassType]["cover_left"]["crouch"]["rifle"]["lean_semi5"]			= %ai_elite_cornercl_shoot_semi5;
	anim.anim_array[subclassType]["cover_left"]["crouch"]["rifle"]["lean_burst2"]			= %ai_elite_cornercl_shoot_burst3;
	anim.anim_array[subclassType]["cover_left"]["crouch"]["rifle"]["lean_burst3"]			= %ai_elite_cornercl_shoot_burst3;
	anim.anim_array[subclassType]["cover_left"]["crouch"]["rifle"]["lean_burst4"]			= %ai_elite_cornercl_shoot_burst4;
	anim.anim_array[subclassType]["cover_left"]["crouch"]["rifle"]["lean_burst5"]			= %ai_elite_cornercl_shoot_burst5;
	anim.anim_array[subclassType]["cover_left"]["crouch"]["rifle"]["lean_burst6"]			= %ai_elite_cornercl_shoot_burst6;
	anim.anim_array[subclassType]["cover_left"]["crouch"]["rifle"]["lean_single"]			= array( %ai_elite_cornercl_shoot_semi1 );

	anim.anim_array[subclassType]["cover_left"]["crouch"]["rifle"]["lean_aim_down"]		= %ai_elite_cornercl_lean_aim_2;
	anim.anim_array[subclassType]["cover_left"]["crouch"]["rifle"]["lean_aim_left"]		= %ai_elite_cornercl_lean_aim_4;
	anim.anim_array[subclassType]["cover_left"]["crouch"]["rifle"]["lean_aim_straight"]	= %ai_elite_cornercl_lean_aim_5;
	anim.anim_array[subclassType]["cover_left"]["crouch"]["rifle"]["lean_aim_right"]		= %ai_elite_cornercl_lean_aim_6;
	anim.anim_array[subclassType]["cover_left"]["crouch"]["rifle"]["lean_aim_up"]			= %ai_elite_cornercl_lean_aim_8;
	
	anim.anim_array[subclassType]["cover_left"]["crouch"]["rifle"]["lean_idle"]			= array( %ai_elite_cornercl_lean_idle );

	anim.anim_array[subclassType]["cover_left"]["crouch"]["rifle"]["lean_to_alert"]		= array( %ai_elite_cornercl_lean_2_alert );
	anim.anim_array[subclassType]["cover_left"]["crouch"]["rifle"]["alert_to_lean"]		= array( %ai_elite_cornercl_alert_2_lean );
	
	anim.anim_array[subclassType]["pain"]["crouch"]["rifle"]["cover_left_lean"]			= %ai_elite_cornercl_lean_pain;
	
	anim.anim_array[subclassType]["cover_left"]["crouch"]["rifle"]["alert_to_A"]			= array( %ai_elite_cornercl_alert_2_a );
	anim.anim_array[subclassType]["cover_left"]["crouch"]["rifle"]["alert_to_B"]			= array( %ai_elite_cornercl_alert_2_b );
	anim.anim_array[subclassType]["cover_left"]["crouch"]["rifle"]["A_to_alert"]			= array( %ai_elite_cornercl_a_2_alert );
		
	anim.anim_array[subclassType]["cover_left"]["crouch"]["rifle"]["A_to_B"    ]			= array( %ai_elite_cornercl_a_2_b );
	anim.anim_array[subclassType]["cover_left"]["crouch"]["rifle"]["B_to_alert"]			= array( %ai_elite_cornercl_b_2_alert );
 	
	anim.anim_array[subclassType]["cover_left"]["crouch"]["rifle"]["B_to_A"    ]			= array( %ai_elite_cornercl_b_2_a     );

	anim.anim_array[subclassType]["pain"]["crouch"]["rifle"]["cover_left_A"]				= %ai_elite_cornercl_pain_a_2_alert;
	anim.anim_array[subclassType]["pain"]["crouch"]["rifle"]["cover_left_B"]				= %ai_elite_cornercl_pain_b_2_alert;
	
//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
// End Cover Left Crouch Actions
//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
// Begin Cover Right Stand Actions
//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
	
	anim.anim_array[subclassType]["cover_right"]["stand"]["rifle"]["lean_fire"]			= %ai_elite_cornerstndr_shoot_auto_v3;
	anim.anim_array[subclassType]["cover_right"]["stand"]["rifle"]["lean_semi2"]			= %ai_elite_cornerstndr_shoot_semi2;
	anim.anim_array[subclassType]["cover_right"]["stand"]["rifle"]["lean_semi3"]			= %ai_elite_cornerstndr_shoot_semi3;
	anim.anim_array[subclassType]["cover_right"]["stand"]["rifle"]["lean_semi4"]			= %ai_elite_cornerstndr_shoot_semi4;
	anim.anim_array[subclassType]["cover_right"]["stand"]["rifle"]["lean_semi5"]			= %ai_elite_cornerstndr_shoot_semi5;
	anim.anim_array[subclassType]["cover_right"]["stand"]["rifle"]["lean_burst2"]			= %ai_elite_cornerstndr_shoot_burst3;
	anim.anim_array[subclassType]["cover_right"]["stand"]["rifle"]["lean_burst3"]			= %ai_elite_cornerstndr_shoot_burst3;
	anim.anim_array[subclassType]["cover_right"]["stand"]["rifle"]["lean_burst4"]			= %ai_elite_cornerstndr_shoot_burst4;
	anim.anim_array[subclassType]["cover_right"]["stand"]["rifle"]["lean_burst5"]			= %ai_elite_cornerstndr_shoot_burst5;
	anim.anim_array[subclassType]["cover_right"]["stand"]["rifle"]["lean_burst6"]			= %ai_elite_cornerstndr_shoot_burst6;
	anim.anim_array[subclassType]["cover_right"]["stand"]["rifle"]["lean_single"]			= array( %ai_elite_cornerstndr_shoot_semi2 );
	
	anim.anim_array[subclassType]["cover_right"]["stand"]["rifle"]["lean_aim_down"]		= %ai_elite_cornerstndr_lean_aim_2;
	anim.anim_array[subclassType]["cover_right"]["stand"]["rifle"]["lean_aim_left"]		= %ai_elite_cornerstndr_lean_aim_4;
	anim.anim_array[subclassType]["cover_right"]["stand"]["rifle"]["lean_aim_straight"]	= %ai_elite_cornerstndr_lean_aim_5;
	anim.anim_array[subclassType]["cover_right"]["stand"]["rifle"]["lean_aim_right"]		= %ai_elite_cornerstndr_lean_aim_6;
	anim.anim_array[subclassType]["cover_right"]["stand"]["rifle"]["lean_aim_up"]			= %ai_elite_cornerstndr_lean_aim_8;
	
	anim.anim_array[subclassType]["cover_right"]["stand"]["rifle"]["lean_idle"]			= array( %ai_elite_cornerstndr_lean_idle );
	
	anim.anim_array[subclassType]["cover_right"]["stand"]["rifle"]["lean_to_alert"]		= array( %ai_elite_cornerstndr_lean_2_alert );
	anim.anim_array[subclassType]["cover_right"]["stand"]["rifle"]["alert_to_lean"]		= array( %ai_elite_cornerstndr_alert_2_lean );
	
	anim.anim_array[subclassType]["pain"]["stand"]["rifle"]["cover_right_lean"]			= %ai_elite_cornerstndr_lean_pain;
	

	anim.anim_array[subclassType]["cover_right"]["stand"]["rifle"]["alert_to_A"]			= array( %ai_elite_cornerstndr_alert_2_a );
	anim.anim_array[subclassType]["cover_right"]["stand"]["rifle"]["alert_to_B"]			= array( %ai_elite_cornerstndr_alert_2_b );
	anim.anim_array[subclassType]["cover_right"]["stand"]["rifle"]["A_to_alert"]			= array( %ai_elite_cornerstndr_a_2_alert );
	
	anim.anim_array[subclassType]["cover_right"]["stand"]["rifle"]["A_to_B"    ]			= array( %ai_elite_cornerstndr_a_2_b );
	anim.anim_array[subclassType]["cover_right"]["stand"]["rifle"]["B_to_alert"]			= array( %ai_elite_cornerstndr_b_2_alert );
	
 	anim.anim_array[subclassType]["cover_right"]["stand"]["rifle"]["B_to_A"    ]			= array( %ai_elite_cornerstndr_b_2_a );

	anim.anim_array[subclassType]["pain"]["stand"]["rifle"]["cover_right_A"]				= %ai_elite_cornerstndr_pain_a_2_alert;
  	anim.anim_array[subclassType]["pain"]["stand"]["rifle"]["cover_right_B"]				= %ai_elite_cornerstndr_pain_b_2_alert;

//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
// End Cover Right Stand Actions
//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
// Begin Cover Right Crouch Actions
//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
	
	anim.anim_array[subclassType]["cover_right"]["crouch"]["rifle"]["lean_fire"]			= %ai_elite_cornercr_shoot_auto_v2;
	anim.anim_array[subclassType]["cover_right"]["crouch"]["rifle"]["lean_semi2"]			= %ai_elite_cornercr_shoot_semi2;
	anim.anim_array[subclassType]["cover_right"]["crouch"]["rifle"]["lean_semi3"]			= %ai_elite_cornercr_shoot_semi3;
	anim.anim_array[subclassType]["cover_right"]["crouch"]["rifle"]["lean_semi4"]			= %ai_elite_cornercr_shoot_semi4;
	anim.anim_array[subclassType]["cover_right"]["crouch"]["rifle"]["lean_semi5"]			= %ai_elite_cornercr_shoot_semi5;
	anim.anim_array[subclassType]["cover_right"]["crouch"]["rifle"]["lean_burst2"]			= %ai_elite_cornercr_shoot_burst3;
	anim.anim_array[subclassType]["cover_right"]["crouch"]["rifle"]["lean_burst3"]			= %ai_elite_cornercr_shoot_burst3;
	anim.anim_array[subclassType]["cover_right"]["crouch"]["rifle"]["lean_burst4"]			= %ai_elite_cornercr_shoot_burst4;
	anim.anim_array[subclassType]["cover_right"]["crouch"]["rifle"]["lean_burst5"]			= %ai_elite_cornercr_shoot_burst5;
	anim.anim_array[subclassType]["cover_right"]["crouch"]["rifle"]["lean_burst6"]			= %ai_elite_cornercr_shoot_burst6;
	anim.anim_array[subclassType]["cover_right"]["crouch"]["rifle"]["lean_single"]			= array( %ai_elite_cornercr_shoot_semi1 );

	anim.anim_array[subclassType]["cover_right"]["crouch"]["rifle"]["lean_aim_down"]		= %ai_elite_cornercr_lean_aim_2;
	anim.anim_array[subclassType]["cover_right"]["crouch"]["rifle"]["lean_aim_left"]		= %ai_elite_cornercr_lean_aim_4;
	anim.anim_array[subclassType]["cover_right"]["crouch"]["rifle"]["lean_aim_straight"]	= %ai_elite_cornercr_lean_aim_5;
	anim.anim_array[subclassType]["cover_right"]["crouch"]["rifle"]["lean_aim_right"]		= %ai_elite_cornercr_lean_aim_6;
	anim.anim_array[subclassType]["cover_right"]["crouch"]["rifle"]["lean_aim_up"]			= %ai_elite_cornercr_lean_aim_8;
	
	anim.anim_array[subclassType]["cover_right"]["crouch"]["rifle"]["lean_idle"]			= array( %ai_elite_cornercr_lean_idle );
	
	anim.anim_array[subclassType]["cover_right"]["crouch"]["rifle"]["alert_to_lean"]		= array( %ai_elite_cornercr_alert_2_lean );
	anim.anim_array[subclassType]["cover_right"]["crouch"]["rifle"]["lean_to_alert"]		= array( %ai_elite_cornercr_lean_2_alert );
	
	anim.anim_array[subclassType]["pain"]["crouch"]["rifle"]["cover_right_lean"]			= %ai_elite_cornercr_lean_pain;
	
	anim.anim_array[subclassType]["cover_right"]["crouch"]["rifle"]["alert_to_A"]			= array( %ai_elite_cornercr_alert_2_a );
	anim.anim_array[subclassType]["cover_right"]["crouch"]["rifle"]["alert_to_B"]			= array( %ai_elite_cornercr_alert_2_b );
	anim.anim_array[subclassType]["cover_right"]["crouch"]["rifle"]["A_to_alert"]			= array( %ai_elite_cornercr_a_2_alert );
	
	anim.anim_array[subclassType]["cover_right"]["crouch"]["rifle"]["A_to_B"    ]			= array( %ai_elite_cornercr_a_2_b     );
	anim.anim_array[subclassType]["cover_right"]["crouch"]["rifle"]["B_to_alert"]			= array( %ai_elite_cornercr_b_2_alert );
 	
	anim.anim_array[subclassType]["cover_right"]["crouch"]["rifle"]["B_to_A"    ]			= array( %ai_elite_cornercr_b_2_a     );

	anim.anim_array[subclassType]["pain"]["crouch"]["rifle"]["cover_right_A"]				= %ai_elite_cornercr_pain_a_2_alert;
	anim.anim_array[subclassType]["pain"]["crouch"]["rifle"]["cover_right_B"]				= %ai_elite_cornercr_pain_b_2_alert;	
	

//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
// End Cover Right Crouch Actions
//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
// Begin Cover Pillar Left Stand Actions
//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

	anim.anim_array[subclassType]["cover_pillar_left"]["stand"]["rifle"]["alert_to_A"]			= array( %ai_elite_pillar_stand_idle_2_a_left );
	anim.anim_array[subclassType]["cover_pillar_left"]["stand"]["rifle"]["alert_to_B"]			= array( %ai_elite_pillar_stand_idle_2_b_left );
	anim.anim_array[subclassType]["cover_pillar_left"]["stand"]["rifle"]["A_to_alert"]			= array( %ai_elite_pillar_stand_a_left_2_idle );
	
	anim.anim_array[subclassType]["cover_pillar_left"]["stand"]["rifle"]["A_to_B"    ]			= array( %ai_elite_pillar_stand_a_left_2_b_left     );
	anim.anim_array[subclassType]["cover_pillar_left"]["stand"]["rifle"]["B_to_alert"]			= array( %ai_elite_pillar_stand_b_left_2_idle );
 	
	anim.anim_array[subclassType]["cover_pillar_left"]["stand"]["rifle"]["B_to_A"    ]			= array( %ai_elite_pillar_stand_b_left_2_a_left     );

//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
// End Cover Pillar Left Stand Actions
//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
// Begin Cover Pillar Left Crouch Actions
//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

	anim.anim_array[subclassType]["cover_pillar_left"]["crouch"]["rifle"]["alert_to_A"]			= array(%ai_elite_pillar_crouch_idle_2_a_left);
	anim.anim_array[subclassType]["cover_pillar_left"]["crouch"]["rifle"]["alert_to_B"]			= array(%ai_elite_pillar_crouch_idle_2_b_left);
	anim.anim_array[subclassType]["cover_pillar_left"]["crouch"]["rifle"]["A_to_alert"]			= array(%ai_elite_pillar_crouch_a_left_2_idle);
	
	anim.anim_array[subclassType]["cover_pillar_left"]["crouch"]["rifle"]["A_to_B"    ]			= array(%ai_elite_pillar_crouch_a_left_2_b_left);
	anim.anim_array[subclassType]["cover_pillar_left"]["crouch"]["rifle"]["B_to_alert"]			= array(%ai_elite_pillar_crouch_b_left_2_idle);
 	
	anim.anim_array[subclassType]["cover_pillar_left"]["crouch"]["rifle"]["B_to_A"    ]			= array(%ai_elite_pillar_crouch_b_left_2_a_left);
	
//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
// End Cover Pillar Left Crouch Actions
//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////


//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
// Begin Cover Pillar Right Stand Actions
//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

	anim.anim_array[subclassType]["cover_pillar_right"]["stand"]["rifle"]["alert_to_A"]			= array( %ai_elite_pillar_stand_idle_2_a_right );
	anim.anim_array[subclassType]["cover_pillar_right"]["stand"]["rifle"]["alert_to_B"]			= array( %ai_elite_pillar_stand_idle_2_b_right );
	anim.anim_array[subclassType]["cover_pillar_right"]["stand"]["rifle"]["A_to_alert"]			= array( %ai_elite_pillar_stand_a_right_2_idle );
	
	anim.anim_array[subclassType]["cover_pillar_right"]["stand"]["rifle"]["A_to_B"    ]			= array( %ai_elite_pillar_stand_a_right_2_b_right);
	anim.anim_array[subclassType]["cover_pillar_right"]["stand"]["rifle"]["B_to_alert"]			= array( %ai_elite_pillar_stand_b_right_2_idle);
 	
	anim.anim_array[subclassType]["cover_pillar_right"]["stand"]["rifle"]["B_to_A"    ]			= array( %ai_elite_pillar_stand_b_right_2_a_right);

//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
// End Cover Pillar Right Stand Actions
//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
// Begin Cover Pillar Right Crouch Actions
//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

	anim.anim_array[subclassType]["cover_pillar_right"]["crouch"]["rifle"]["alert_to_A"]			= array(%ai_elite_pillar_crouch_idle_2_a_right);
	anim.anim_array[subclassType]["cover_pillar_right"]["crouch"]["rifle"]["alert_to_B"]			= array(%ai_elite_pillar_crouch_idle_2_b_right);
	anim.anim_array[subclassType]["cover_pillar_right"]["crouch"]["rifle"]["A_to_alert"]			= array(%ai_elite_pillar_crouch_a_right_2_idle);
	
	anim.anim_array[subclassType]["cover_pillar_right"]["crouch"]["rifle"]["A_to_B"    ]			= array(%ai_elite_pillar_crouch_a_right_2_b_right);
	anim.anim_array[subclassType]["cover_pillar_right"]["crouch"]["rifle"]["B_to_alert"]			= array(%ai_elite_pillar_crouch_b_right_2_idle);
 	
	anim.anim_array[subclassType]["cover_pillar_right"]["crouch"]["rifle"]["B_to_A"    ]			= array(%ai_elite_pillar_crouch_b_right_2_a_right);

//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
// End Cover Pillar Right Crouch Actions
//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////


//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
// Begin Cover Pillar Stand Pains
//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
	anim.anim_array[subclassType]["pain"]["stand"]["rifle"]["cover_pillar_left_A"]		= %ai_elite_pillar_stand_left_a_pain;
	anim.anim_array[subclassType]["pain"]["stand"]["rifle"]["cover_pillar_left_B"]		= %ai_elite_pillar_stand_left_b_pain;
	
	anim.anim_array[subclassType]["pain"]["stand"]["rifle"]["cover_pillar_right_A"]		= %ai_elite_pillar_stand_right_a_pain;
	anim.anim_array[subclassType]["pain"]["stand"]["rifle"]["cover_pillar_right_B"]		= %ai_elite_pillar_stand_right_b_pain;
	
	anim.anim_array[subclassType]["pain"]["crouch"]["rifle"]["cover_pillar_left_A"]		= %ai_elite_pillar_crouch_left_a_pain;
	anim.anim_array[subclassType]["pain"]["crouch"]["rifle"]["cover_pillar_left_B"]		= %ai_elite_pillar_crouch_left_b_pain;
	
	anim.anim_array[subclassType]["pain"]["crouch"]["rifle"]["cover_pillar_right_A"]	= %ai_elite_pillar_crouch_right_a_pain;
	anim.anim_array[subclassType]["pain"]["crouch"]["rifle"]["cover_pillar_right_B"]	= %ai_elite_pillar_crouch_right_b_pain;
	
//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
// End Cover Pillar Stand Pains
//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////


	animscripts\anims_table::setup_delta_arrays( anim.anim_array, anim );
}

reset_elite_anim_array()
{
	Assert( IS_TRUE(self.elite) );
	//Assert( self.subclass == "elite" ); - not checking this here as we might have overwritten this
		
	self animscripts\anims::clearAnimCache();
	
	if( IsDefined( self.anim_array ) && IsDefined( self.anim_array[self.animType] ) )
		self.anim_array[self.animType] = undefined;
}