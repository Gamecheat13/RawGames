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
}

reset_default_rusher_anim_array()
{
	Assert( IsDefined( self.anim_array ) );
	assert( self.rusher == true, "This AI is not a rusher." );
	
	// AI - nothing really needs to be done here currently.
}
