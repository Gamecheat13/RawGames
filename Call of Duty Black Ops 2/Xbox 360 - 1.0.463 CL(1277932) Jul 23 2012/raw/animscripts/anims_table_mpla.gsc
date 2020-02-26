#include common_scripts\Utility;

#using_animtree ("generic_human");

setup_mpla_anim_array( animType, array )
{
	return animscripts\anims_table_digbats::setup_digbat_anim_array( animType, array );
}

setup_melee_mpla_anim_array()
{
	self animscripts\anims::clearAnimCache();

	if( !IsDefined( self.anim_array ) )
	{
		self.anim_array = [];
	}

	self.anim_array[self.animType]["combat"]["stand"]["none"]["melee_0"]				= %ai_digbat_melee_1; 
	self.anim_array[self.animType]["combat"]["stand"]["none"]["stand_2_melee_0"]		= %ai_digbat_melee_1;
	self.anim_array[self.animType]["combat"]["stand"]["none"]["run_2_melee_0"]			= %ai_digbat_melee_1;

	self.anim_array[self.animType]["combat"]["stand"]["none"]["run_n_gun_f"]			= %ai_digbat_melee_run_f;
	self.anim_array[self.animType]["move"]["stand"]["none"]["combat_run_f"]				= %ai_digbat_melee_run_f;
	self.anim_array[self.animType]["move"]["stand"]["none"]["combat_run_r"]				= %ai_digbat_melee_run_f;
	self.anim_array[self.animType]["move"]["stand"]["none"]["combat_run_l"]				= %ai_digbat_melee_run_f;
	self.anim_array[self.animType]["move"]["stand"]["none"]["combat_run_b"]				= %ai_digbat_melee_run_f;
	
	self.anim_array[self.animType]["stop"]["stand"]["none"]["idle_trans_in"]			= %ai_digbat_melee_casual_idle;
	self.anim_array[self.animType]["stop"]["stand"]["none"]["idle"]						= array( array(%ai_digbat_melee_casual_idle) );
	self.anim_array[self.animType]["combat"]["stand"]["none"]["exposed_idle"]			= array( %ai_digbat_melee_idle );
	self.anim_array[self.animType]["combat"]["stand"]["none"]["straight_level"]			= %ai_digbat_melee_fake_aim;
	
	self.anim_array[self.animType]["move"]["stand"]["none"]["tactical_walk_f"]			= %ai_digbat_melee_run_f;
	self.anim_array[self.animType]["move"]["stand"]["none"]["start_stand_run_f"]		= %ai_digbat_melee_run_f;
	
	self.anim_array[self.animType]["combat"]["stand"]["none"]["turn_left_45"]			= %ai_digbat_melee_tracking_turn45l;
	self.anim_array[self.animType]["combat"]["stand"]["none"]["turn_left_90"]			= %ai_digbat_melee_tracking_turn90l;
	self.anim_array[self.animType]["combat"]["stand"]["none"]["turn_left_135"]			= %ai_digbat_melee_tracking_turn135l;
	self.anim_array[self.animType]["combat"]["stand"]["none"]["turn_left_180"]			= %ai_digbat_melee_tracking_turn180l;
	self.anim_array[self.animType]["combat"]["stand"]["none"]["turn_right_45"]			= %ai_digbat_melee_tracking_turn45r;
	self.anim_array[self.animType]["combat"]["stand"]["none"]["turn_right_90"]			= %ai_digbat_melee_tracking_turn90r;
	self.anim_array[self.animType]["combat"]["stand"]["none"]["turn_right_135"]			= %ai_digbat_melee_tracking_turn135r;
	self.anim_array[self.animType]["combat"]["stand"]["none"]["turn_right_180"]			= %ai_digbat_melee_tracking_turn180l;

}