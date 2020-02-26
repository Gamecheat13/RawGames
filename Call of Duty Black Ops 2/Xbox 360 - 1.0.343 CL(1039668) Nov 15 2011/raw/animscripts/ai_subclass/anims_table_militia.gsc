#include common_scripts\Utility;

#using_animtree ("generic_human");
setup_militia_anim_array()
{
	Assert( self.subclass == "militia" );

	subclassType = self.subclass;

	if( IsDefined( anim.anim_array[subclassType] ) )
		return;

	self animscripts\anims::clearAnimCache();
	
	anim.anim_array[subclassType] = [];
	
	anim.anim_array[subclassType]["combat"]["stand"]["rifle"]["exposed_idle"]				= array( %ai_militia_exposed_idle_alert_v1, %ai_militia_exposed_idle_alert_v2 );
	anim.anim_array[subclassType]["combat"]["stand"]["rifle"]["reload"]						= array( %ai_militia_exposed_reloada ); 
	
	anim.anim_array[subclassType]["cover_left"]["stand"]["rifle"]["rambo"]					= array( %ai_militia_corner_standl_fire90_01, %ai_militia_corner_standl_fire90_02, %ai_militia_corner_standl_fire90_03 );
	anim.anim_array[subclassType]["cover_left"]["stand"]["rifle"]["rambo_45"]				= array( %ai_militia_corner_standl_fire45_01, %ai_militia_corner_standl_fire45_02 );	
	anim.anim_array[subclassType]["cover_left"]["stand"]["rifle"]["rambo_add_aim_up"]		= %ai_militia_rambo_fireidle_aim8;
	anim.anim_array[subclassType]["cover_left"]["stand"]["rifle"]["rambo_add_aim_down"]	    = %ai_militia_rambo_fireidle_aim2;
	anim.anim_array[subclassType]["cover_left"]["stand"]["rifle"]["rambo_add_aim_left"]		= %ai_militia_rambo_fireidle_aim4;
	anim.anim_array[subclassType]["cover_left"]["stand"]["rifle"]["rambo_add_aim_right"]	= %ai_militia_rambo_fireidle_aim6;
	anim.anim_array[subclassType]["cover_left"]["stand"]["rifle"]["grenade_rambo"]			= %ai_militia_corner_standl_grenade;
	
	anim.anim_array[subclassType]["cover_right"]["stand"]["rifle"]["rambo"]					= array( %ai_militia_corner_standr_fire90_01, %ai_militia_corner_standr_fire90_02, %ai_militia_corner_standr_fire90_03 );
	anim.anim_array[subclassType]["cover_right"]["stand"]["rifle"]["rambo_45"]				= array( %ai_militia_corner_standr_fire45_01, %ai_militia_corner_standr_fire45_02, %ai_militia_corner_standr_fire45_03 );
	anim.anim_array[subclassType]["cover_right"]["stand"]["rifle"]["rambo_add_aim_up"]		= %ai_militia_rambo_fireidle_aim8;
	anim.anim_array[subclassType]["cover_right"]["stand"]["rifle"]["rambo_add_aim_down"]	= %ai_militia_rambo_fireidle_aim2;
	anim.anim_array[subclassType]["cover_right"]["stand"]["rifle"]["rambo_add_aim_left"]	= %ai_militia_rambo_fireidle_aim4;
	anim.anim_array[subclassType]["cover_right"]["stand"]["rifle"]["rambo_add_aim_right"]	= %ai_militia_rambo_fireidle_aim6;
	anim.anim_array[subclassType]["cover_right"]["stand"]["rifle"]["grenade_rambo"]			= %ai_militia_corner_standr_grenade;

	anim.anim_array[subclassType]["cover_crouch"]["crouch"]["rifle"]["rambo"]				= array( %ai_militia_cover_crouch_fire_01, %ai_militia_cover_crouch_fire_02, %ai_militia_cover_crouch_fire_03 );
	anim.anim_array[subclassType]["cover_crouch"]["crouch"]["rifle"]["rambo_add_aim_up"]	= %ai_militia_rambo_fireidle_aim8;
	anim.anim_array[subclassType]["cover_crouch"]["crouch"]["rifle"]["rambo_add_aim_down"]	= %ai_militia_rambo_fireidle_aim2;
	anim.anim_array[subclassType]["cover_crouch"]["crouch"]["rifle"]["rambo_add_aim_left"]	= %ai_militia_rambo_fireidle_aim4;
	anim.anim_array[subclassType]["cover_crouch"]["crouch"]["rifle"]["rambo_add_aim_right"]	= %ai_militia_rambo_fireidle_aim6;
	
	anim.anim_array[subclassType]["cover_crouch"]["crouch"]["rifle"]["rambo_jam"]			= array( %ai_militia_cover_crouch_gunjamA, %ai_militia_cover_crouch_gunjamB );
	anim.anim_array[subclassType]["cover_crouch"]["crouch"]["rifle"]["grenade_rambo"]		= %ai_militia_cover_crouch_grenadefireA;

	anim.anim_array[subclassType]["cover_stand"]["stand"]["rifle"]["rambo"]					= array( %ai_militia_cover_stand_fireA, %ai_militia_cover_stand_fireB, %ai_militia_cover_stand_fireC );
	anim.anim_array[subclassType]["cover_stand"]["stand"]["rifle"]["rambo_add_aim_up"]		= %ai_militia_rambo_fireidle_aim8;
	anim.anim_array[subclassType]["cover_stand"]["stand"]["rifle"]["rambo_add_aim_down"]	= %ai_militia_rambo_fireidle_aim2;
	anim.anim_array[subclassType]["cover_stand"]["stand"]["rifle"]["rambo_add_aim_left"]	= %ai_militia_rambo_fireidle_aim4;
	anim.anim_array[subclassType]["cover_stand"]["stand"]["rifle"]["rambo_add_aim_right"]	= %ai_militia_rambo_fireidle_aim6;
		
	anim.anim_array[subclassType]["cover_stand"]["stand"]["rifle"]["rambo_jam"]				= array( %ai_militia_cover_stand_gunjamA, %ai_militia_cover_stand_gunjamB );
	anim.anim_array[subclassType]["cover_stand"]["stand"]["rifle"]["grenade_rambo"]			= %ai_militia_cover_stand_grenadefireA;
	
	anim.anim_array[subclassType]["move"]["stand"]["rifle"]["run_n_gun_r"]				= %ai_militia_run_n_gun_r;
	anim.anim_array[subclassType]["move"]["stand"]["rifle"]["run_n_gun_l"]				= %ai_militia_run_n_gun_l;
	anim.anim_array[subclassType]["move"]["stand"]["rifle"]["run_n_gun_l_120"]			= %ai_militia_run_n_gun_l_120;
	anim.anim_array[subclassType]["move"]["stand"]["rifle"]["run_n_gun_r_120"]			= %ai_militia_run_n_gun_r_120;
	
	anim.anim_array[subclassType]["move"]["stand"]["rifle"]["add_l_aim_up"]				= %ai_militia_run_n_gun_l_aim_8;
	anim.anim_array[subclassType]["move"]["stand"]["rifle"]["add_l_aim_down"]			= %ai_militia_run_n_gun_l_aim_2;
	anim.anim_array[subclassType]["move"]["stand"]["rifle"]["add_l_aim_left"]			= %ai_militia_run_n_gun_l_aim_4;
	anim.anim_array[subclassType]["move"]["stand"]["rifle"]["add_l_aim_right"]			= %ai_militia_run_n_gun_l_aim_6;

	anim.anim_array[subclassType]["move"]["stand"]["rifle"]["add_r_aim_up"]				= %ai_militia_run_n_gun_r_aim_8;
	anim.anim_array[subclassType]["move"]["stand"]["rifle"]["add_r_aim_down"]			= %ai_militia_run_n_gun_r_aim_2;
	anim.anim_array[subclassType]["move"]["stand"]["rifle"]["add_r_aim_left"]			= %ai_militia_run_n_gun_r_aim_4;
	anim.anim_array[subclassType]["move"]["stand"]["rifle"]["add_r_aim_right"]			= %ai_militia_run_n_gun_r_aim_6;

	anim.anim_array[subclassType]["move"]["stand"]["rifle"]["add_l_120_aim_up"]			= %ai_militia_run_n_gun_l_120_aim_8;
	anim.anim_array[subclassType]["move"]["stand"]["rifle"]["add_l_120_aim_down"]		= %ai_militia_run_n_gun_l_120_aim_2;
	anim.anim_array[subclassType]["move"]["stand"]["rifle"]["add_l_120_aim_left"]		= %ai_militia_run_n_gun_l_120_aim_4;
	anim.anim_array[subclassType]["move"]["stand"]["rifle"]["add_l_120_aim_right"]		= %ai_militia_run_n_gun_l_120_aim_6;

	anim.anim_array[subclassType]["move"]["stand"]["rifle"]["add_r_120_aim_up"]			= %ai_militia_run_n_gun_r_120_aim_8;
	anim.anim_array[subclassType]["move"]["stand"]["rifle"]["add_r_120_aim_down"]		= %ai_militia_run_n_gun_r_120_aim_2;
	anim.anim_array[subclassType]["move"]["stand"]["rifle"]["add_r_120_aim_left"]		= %ai_militia_run_n_gun_r_120_aim_4;
	anim.anim_array[subclassType]["move"]["stand"]["rifle"]["add_r_120_aim_right"]		= %ai_militia_run_n_gun_r_120_aim_6;

	
	// AI_TODO - rename following animations and their additives for militia specifically
	//%covercrouch_blindfire_3, %covercrouch_blindfire_4
}
