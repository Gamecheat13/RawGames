// This file includes all the default rusher animations. Faction specfic rusher override calls should go in its own anims_table_*.gsc
#include common_scripts\Utility;

#using_animtree ("generic_human");
setup_rusher_anims()
{
	switch( self.animType )
	{		
		case "spetsnaz":
			self animscripts\anims_table_spetsnaz::setup_spetsnaz_rusher_anim_array();
			break;

		default:
			self setup_default_rusher_anim_array();
			break;
	}

	self animscripts\anims::clearAnimCache();
}

reset_rusher_anims()
{
	switch( self.animType )
	{
		case "default":
		case "spetsnaz":
		case "vc":
			self reset_default_rusher_anim_array();
			break;		
	}

	self animscripts\anims::clearAnimCache();
}

setup_default_rusher_anim_array()
{
	if( !IsDefined( self.anim_array ) )
	{
		self.anim_array = [];
	}

	// replace regular run and gun animations with faster versions
	assert( IsDefined( self.rusherType ), "Call this function after setting the rusherType on the AI" );

	if( self.rusherType == "default" || self.rusherType == "semi" )
	{	
		// nothing special to do here, leaving it here so that we know what all type of rushers are there
		
		self.anim_array[self.animType]["move"]["stand"]["rifle"]["step_left_rh"]			= array( %ai_spets_rusher_step_45l_2_run_01, %ai_spets_rusher_step_45l_2_run_02 );
		self.anim_array[self.animType]["move"]["stand"]["rifle"]["step_left_lh"]			= array( %ai_spets_rusher_step_45l_2_run_a_01, %ai_spets_rusher_step_45l_2_run_a_02 );
	
		self.anim_array[self.animType]["move"]["stand"]["rifle"]["step_right_rh"]			= array( %ai_spets_rusher_step_45r_2_run_01, %ai_spets_rusher_step_45r_2_run_02 );
		self.anim_array[self.animType]["move"]["stand"]["rifle"]["step_right_lh"]			= array( %ai_spets_rusher_step_45r_2_run_a_01, %ai_spets_rusher_step_45r_2_run_a_02 );
	
		self.anim_array[self.animType]["move"]["stand"]["rifle"]["roll_left_rh"]			= array( %ai_spets_rusher_roll_45l_2_run_01, %ai_spets_rusher_roll_45l_2_run_02);
		self.anim_array[self.animType]["move"]["stand"]["rifle"]["roll_left_lh"]			= array( %ai_spets_rusher_roll_45l_2_run_a_01, %ai_spets_rusher_roll_45l_2_run_a_02 );
	
		self.anim_array[self.animType]["move"]["stand"]["rifle"]["roll_right_rh"]			= array( %ai_spets_rusher_roll_45r_2_run_01, %ai_spets_rusher_roll_45r_2_run_02 );
		self.anim_array[self.animType]["move"]["stand"]["rifle"]["roll_right_lh"]			= array( %ai_spets_rusher_roll_45r_2_run_a_01, %ai_spets_rusher_roll_45r_2_run_a_02 );
	
		self.anim_array[self.animType]["move"]["stand"]["rifle"]["roll_forward_rh"]			= array( %ai_spets_rusher_roll_forward_01, %ai_spets_rusher_roll_forward_02 );
		self.anim_array[self.animType]["move"]["stand"]["rifle"]["roll_forward_lh"]			= array( %ai_spets_rusher_roll_forward_01, %ai_spets_rusher_roll_forward_02 );
	
		self.anim_array[self.animType]["move"]["stand"]["rifle"]["rusher_run_f_rh"]			= array( %ai_spets_rusher_run_f_01, %ai_spets_rusher_run_f_02, %ai_spets_rusher_run_f_03 );
		self.anim_array[self.animType]["move"]["stand"]["rifle"]["rusher_run_f_lh"]			= array( %ai_spets_rusher_run_f_a_01, %ai_spets_rusher_run_f_a_02, %ai_spets_rusher_run_f_a_03 );

	}
	else if( self.rusherType == "pistol" )
	{			
		self.anim_array[self.animType]["move"]["stand"]["pistol"]["step_left_rh"]			= array( %ai_spets_pistol_rusher_step_45l_2_run_01 );
		self.anim_array[self.animType]["move"]["stand"]["pistol"]["step_left_lh"]			= array( %ai_spets_pistol_rusher_step_45l_2_run_01 );
	
		self.anim_array[self.animType]["move"]["stand"]["pistol"]["step_right_rh"]			= array( %ai_spets_pistol_rusher_step_45r_2_run_01 );
		self.anim_array[self.animType]["move"]["stand"]["pistol"]["step_right_lh"]			= array( %ai_spets_pistol_rusher_step_45r_2_run_01 );
	
		self.anim_array[self.animType]["move"]["stand"]["pistol"]["roll_left_rh"]			= array( %ai_spets_pistol_rusher_roll_45l_2_run_01 );
		self.anim_array[self.animType]["move"]["stand"]["pistol"]["roll_left_lh"]			= array( %ai_spets_pistol_rusher_roll_45l_2_run_01 );
	
		self.anim_array[self.animType]["move"]["stand"]["pistol"]["roll_right_rh"]			= array( %ai_spets_pistol_rusher_roll_45r_2_run_01 );
		self.anim_array[self.animType]["move"]["stand"]["pistol"]["roll_right_lh"]			= array( %ai_spets_pistol_rusher_roll_45r_2_run_01 );
	
		self.anim_array[self.animType]["move"]["stand"]["pistol"]["roll_forward_rh"]		= array( %ai_spets_pistol_rusher_roll_forward_01 );
		self.anim_array[self.animType]["move"]["stand"]["pistol"]["roll_forward_lh"]		= array( %ai_spets_pistol_rusher_roll_forward_01 );
	
		self.anim_array[self.animType]["move"]["stand"]["pistol"]["rusher_run_f_rh"]		= array( %ai_pistol_rusher_run_f );
		self.anim_array[self.animType]["move"]["stand"]["pistol"]["rusher_run_f_lh"]		= array( %ai_pistol_rusher_run_f );
	}
	else if( self.rusherType == "shotgun" )
	{
		// replace run cycles
		self.anim_array[self.animType]["move"]["stand"]["spread"]["combat_run_f"]			= %ai_rusher_shotgun_walk_lowready_f;
		self.anim_array[self.animType]["move"]["stand"]["spread"]["combat_run_r"]			= %ai_rusher_shotgun_walk_lowready_r;
		self.anim_array[self.animType]["move"]["stand"]["spread"]["combat_run_l"]			= %ai_rusher_shotgun_walk_lowready_l;
		self.anim_array[self.animType]["move"]["stand"]["spread"]["combat_run_b"]			= %ai_rusher_shotgun_walk_lowready_b;
			
		// replace run and gun animations
		self.anim_array[self.animType]["move"]["stand"]["spread"]["run_n_gun_f"]			= %ai_rusher_shotgun_walk_n_gun_f;
		self.anim_array[self.animType]["move"]["stand"]["spread"]["run_n_gun_r"]			= %ai_rusher_shotgun_walk_n_gun_r;
		self.anim_array[self.animType]["move"]["stand"]["spread"]["run_n_gun_l"]			= %ai_rusher_shotgun_walk_n_gun_l;
		self.anim_array[self.animType]["move"]["stand"]["spread"]["run_n_gun_b"]			= %ai_rusher_shotgun_walk_n_gun_b;
		
		// replace turn animations
		self.anim_array[self.animType]["turn"]["stand"]["spread"]["turn_f_l_45"]			= %ai_rusher_shotgun_walk_lowready_f_turn_45_l;
		self.anim_array[self.animType]["turn"]["stand"]["spread"]["turn_f_l_90"]			= %ai_rusher_shotgun_walk_lowready_f_turn_90_l;
		self.anim_array[self.animType]["turn"]["stand"]["spread"]["turn_f_l_180"]			= %ai_rusher_shotgun_walk_lowready_f_turn_180_l;
		self.anim_array[self.animType]["turn"]["stand"]["spread"]["turn_f_r_45"]			= %ai_rusher_shotgun_walk_lowready_f_turn_45_r;
		self.anim_array[self.animType]["turn"]["stand"]["spread"]["turn_f_r_90"]			= %ai_rusher_shotgun_walk_lowready_f_turn_90_r;
		self.anim_array[self.animType]["turn"]["stand"]["spread"]["turn_f_r_180"]			= %ai_rusher_shotgun_walk_lowready_f_turn_180_r;
	}

}

reset_default_rusher_anim_array()
{
	Assert( IsDefined( self.anim_array ) );
	assert( self.rusher == true, "This AI is not a rusher." );
	
	// set run cycles to default
	self.anim_array[self.animType]["move"]["stand"]["rifle"]["combat_run_f"]		= undefined;
	self.anim_array[self.animType]["move"]["stand"]["rifle"]["combat_run_r"]		= undefined;
	self.anim_array[self.animType]["move"]["stand"]["rifle"]["combat_run_l"]		= undefined;
	self.anim_array[self.animType]["move"]["stand"]["rifle"]["combat_run_b"]		= undefined;
		
	// set run and gun animations to default
	self.anim_array[self.animType]["move"]["stand"]["rifle"]["run_n_gun_f"]			= undefined;
	self.anim_array[self.animType]["move"]["stand"]["rifle"]["run_n_gun_r"]			= undefined;
	self.anim_array[self.animType]["move"]["stand"]["rifle"]["run_n_gun_l"]			= undefined;
	self.anim_array[self.animType]["move"]["stand"]["rifle"]["run_n_gun_b"]			= undefined;

	// set turn animations to default
	self.anim_array[self.animType]["turn"]["stand"]["rifle"]["turn_f_l_45"]			= undefined;
	self.anim_array[self.animType]["turn"]["stand"]["rifle"]["turn_f_l_90"]			= undefined;
	self.anim_array[self.animType]["turn"]["stand"]["rifle"]["turn_f_l_180"]		= undefined;
	self.anim_array[self.animType]["turn"]["stand"]["rifle"]["turn_f_r_45"]			= undefined;
	self.anim_array[self.animType]["turn"]["stand"]["rifle"]["turn_f_r_90"]			= undefined;
	self.anim_array[self.animType]["turn"]["stand"]["rifle"]["turn_f_r_180"]		= undefined;
}
