//_createart generated.  modify at your own risk. Changing values should be fine.
#include common_scripts\utility;
#include maps\_utility;

#define SKYBOX_TRANS_TIME 5

main()
{
	level.tweakfile = true;
 

	VisionSetNaked( "yemen_start", 1 );
	
	r_rimIntensity_debug = GetDvar( "r_rimIntensity_debug" );
    SetSavedDvar( "r_rimIntensity_debug", 1 );
    
    r_rimIntensity = GetDvar( "r_rimIntensity" );
    SetSavedDvar( "r_rimIntensity", 8 );
	
	capture_swap_vision_and_sky();
}
// change vision set and skybox
capture_swap_vision_and_sky()
{
	level waittill( "capture_started" );
	
	const TRANSITION_TIME = 2;
	
	level thread lerp_dvar( "r_skyTransition", 1, TRANSITION_TIME, true ); // change skybox texture
	VisionSetNaked( "yemen_end02", TRANSITION_TIME ); // change vision
}


menendez_intro()
{
VisionSetNaked( "yemen_start", 1 );

	 n_near_start = 1;
	 n_near_end = 2;
	 n_far_start = 10;
	 n_far_end = 800;
	 n_near_blur = 6;
	 n_far_blur = 1;
	 n_time = 2;
	
	level.player depth_of_field_tween( n_near_start, n_near_end, n_far_start, n_far_end, n_near_blur, n_far_blur, n_time );	
	
	r_rimIntensity_debug = GetDvar( "r_rimIntensity_debug" );
    SetSavedDvar( "r_rimIntensity_debug", 1 );
    
    r_rimIntensity = GetDvar( "r_rimIntensity" );
    SetSavedDvar( "r_rimIntensity", 3 );
}


large_crowd()
{
VisionSetNaked( "yemen_start", 1 );

r_rimIntensity_debug = GetDvar( "r_rimIntensity_debug" );
    SetSavedDvar( "r_rimIntensity_debug", 1 );
    
    r_rimIntensity = GetDvar( "r_rimIntensity" );
    SetSavedDvar( "r_rimIntensity", 8 );
}


market()
{
VisionSetNaked( "yemen_start", 1 );
}

alleyway()
{
VisionSetNaked( "yemen_start", 1 );
}

market_2()
{
VisionSetNaked( "yemen_start", 1 );
}

outdoors()
{
VisionSetNaked( "yemen_start", 1 );
}


end_start()
{
VisionSetNaked( "yemen_start", 1 );
}


end_menendez()
{
VisionSetNaked( "yemen_start", 1 );
}

/////DOF/////


/////DOF_INTRO_FIRE/////
dof_menendez(m_player_body)
{
	 n_near_start = 1;
	 n_near_end = 2;
	 n_far_start = 10;
	 n_far_end = 200;
	 n_near_blur = 6;
	 n_far_blur = 1;
	 n_time = 2;
	
	level.player depth_of_field_tween( n_near_start, n_near_end, n_far_start, n_far_end, n_near_blur, n_far_blur, n_time );	
}



dof_room(m_player_body)
{
	 n_near_start = 1;
	 n_near_end = 2;
	 n_far_start = 200;
	 n_far_end = 20000;
	 n_near_blur = 6;
	 n_far_blur = 1;
	 n_time = .1;
	
	level.player depth_of_field_tween( n_near_start, n_near_end, n_far_start, n_far_end, n_near_blur, n_far_blur, n_time );	
}


dof_menendez_1(m_player_body)
{
	 n_near_start = 1;
	 n_near_end = 2;
	 n_far_start = 200;
	 n_far_end = 20000;
	 n_near_blur = 6;
	 n_far_blur = 1;
	 n_time = .1;
	
	level.player depth_of_field_tween( n_near_start, n_near_end, n_far_start, n_far_end, n_near_blur, n_far_blur, n_time );	
}



dof_goons(m_player_body)
{
	 n_near_start = 1;
	 n_near_end = 2;
	 n_far_start = 200;
	 n_far_end = 20000;
	 n_near_blur = 6;
	 n_far_blur = 1;
	 n_time = .1;
	
	level.player depth_of_field_tween( n_near_start, n_near_end, n_far_start, n_far_end, n_near_blur, n_far_blur, n_time );	
}



dof_menendez_2(m_player_body)
{
	 n_near_start = 1;
	 n_near_end = 2;
	 n_far_start = 200;
	 n_far_end = 20000;
	 n_near_blur = 6;
	 n_far_blur = 1;
	 n_time = .1;
	
	level.player depth_of_field_tween( n_near_start, n_near_end, n_far_start, n_far_end, n_near_blur, n_far_blur, n_time );	
}


dof_vtol(m_player_body)
{
	 n_near_start = 1;
	 n_near_end = 2;
	 n_far_start = 200;
	 n_far_end = 20000;
	 n_near_blur = 6;
	 n_far_blur = 1;
	 n_time = .1;
	
	level.player depth_of_field_tween( n_near_start, n_near_end, n_far_start, n_far_end, n_near_blur, n_far_blur, n_time );	
}



dof_menendez_3(m_player_body)
{
	 n_near_start = 1;
	 n_near_end = 2;
	 n_far_start = 20;
	 n_far_end = 5000;
	 n_near_blur = 6;
	 n_far_blur = 1;
	 n_time = .1;
	
	level.player depth_of_field_tween( n_near_start, n_near_end, n_far_start, n_far_end, n_near_blur, n_far_blur, n_time );	
	
	wait 3;
	
	 n_near_start = 1;
	 n_near_end = 2;
	 n_far_start = 20;
	 n_far_end = 5000;
	 n_near_blur = .1;
	 n_far_blur = .1;
	 n_time = .1;
	
	level.player depth_of_field_tween( n_near_start, n_near_end, n_far_start, n_far_end, n_near_blur, n_far_blur, n_time );	
	
	level.player thread depth_of_field_off( .01 );
}



/////MORALS_DOF/////

dof_shoot_vtol1(m_player_body)
{
	 n_near_start = 1;
	 n_near_end = 50;
	 n_far_start = 200;
	 n_far_end = 20000;
	 n_near_blur = 6;
	 n_far_blur = .1;
	 n_time = .5;
	
	level.player depth_of_field_tween( n_near_start, n_near_end, n_far_start, n_far_end, n_near_blur, n_far_blur, n_time );	
}


dof_shoot_vtol2(m_player_body)
{
	 n_near_start = 1;
	 n_near_end = 2;
	 n_far_start = 200;
	 n_far_end = 5000;
	 n_near_blur = 6;
	 n_far_blur = 1.8;
	 n_time = .1;
	
	level.player depth_of_field_tween( n_near_start, n_near_end, n_far_start, n_far_end, n_near_blur, n_far_blur, n_time );	
}

dof_shoot_vtol3(m_player_body)
{
	 n_near_start = 1;
	 n_near_end = 2;
	 n_far_start = 100;
	 n_far_end = 5000;
	 n_near_blur = 6;
	 n_far_blur = 1.8;
	 n_time = .1;
	
	level.player depth_of_field_tween( n_near_start, n_near_end, n_far_start, n_far_end, n_near_blur, n_far_blur, n_time );	
}


dof_shoot_vtol4(m_player_body)
{
	 n_near_start = 1;
	 n_near_end = 2;
	 n_far_start = 100;
	 n_far_end = 700;
	 n_near_blur = 6;
	 n_far_blur = 1.8;
	 n_time = .5;
	
	level.player depth_of_field_tween( n_near_start, n_near_end, n_far_start, n_far_end, n_near_blur, n_far_blur, n_time );	
}

dof_shoot_vtol5(m_player_body)
{
	 n_near_start = 1;
	 n_near_end = 2;
	 n_far_start = 100;
	 n_far_end = 2000;
	 n_near_blur = 6;
	 n_far_blur = 1.8;
	 n_time = .5;
	
	level.player depth_of_field_tween( n_near_start, n_near_end, n_far_start, n_far_end, n_near_blur, n_far_blur, n_time );	
}


dof_shoot_vtol6(m_player_body)
{
	  n_near_start = 1;
	 n_near_end = 2;
	 n_far_start = 100;
	 n_far_end = 2000;
	 n_near_blur = 6;
	 n_far_blur = 1.8;
	 n_time = .5;
	
	level.player depth_of_field_tween( n_near_start, n_near_end, n_far_start, n_far_end, n_near_blur, n_far_blur, n_time );	
}


dof_shoot_vtol7(m_player_body)
{
	 n_near_start = 1;
	 n_near_end = 10;
	 n_far_start = 20;
	 n_far_end = 200;
	 n_near_blur = 6;
	 n_far_blur = 3;
	 n_time = .1;
	
	level.player depth_of_field_tween( n_near_start, n_near_end, n_far_start, n_far_end, n_near_blur, n_far_blur, n_time );	
}


dof_shoot_vtol8(m_player_body)
{
	 n_near_start = 1;
	 n_near_end = 24;
	 n_far_start = 25;
	 n_far_end = 1000;
	 n_near_blur = 6;
	 n_far_blur = 1.2;
	 n_time = .8;
	
	level.player depth_of_field_tween( n_near_start, n_near_end, n_far_start, n_far_end, n_near_blur, n_far_blur, n_time );	
}

dof_shoot_vtol9(m_player_body)
{
	 n_near_start = 1;
	 n_near_end = 24;
	 n_far_start = 200;
	 n_far_end = 2000;
	 n_near_blur = 6;
	 n_far_blur = 1.8;
	 n_time = .8;
	
	level.player depth_of_field_tween( n_near_start, n_near_end, n_far_start, n_far_end, n_near_blur, n_far_blur, n_time );	
}

dof_shoot_vtol10(m_player_body)
{
	 n_near_start = 1;
	 n_near_end = 24;
	 n_far_start = 200;
	 n_far_end = 2000;
	 n_near_blur = 6;
	 n_far_blur = 1.8;
	 n_time = .5;
	
	level.player depth_of_field_tween( n_near_start, n_near_end, n_far_start, n_far_end, n_near_blur, n_far_blur, n_time );	
	
	wait 2.0;
	
	level.player thread depth_of_field_off( .01 );
}


/////MORALS_DOF_SHOOT_HARPER/////

dof_shoot_vtol11(m_player_body)
{
	 n_near_start = 1;
	 n_near_end = 30;
	 n_far_start = 600;
	 n_far_end = 2000;
	 n_near_blur = 4.5;
	 n_far_blur = 1.8;
	 n_time = .2;
	
	level.player depth_of_field_tween( n_near_start, n_near_end, n_far_start, n_far_end, n_near_blur, n_far_blur, n_time );	
}

dof_shoot_vtol12(m_player_body)
{
	 n_near_start = 1;
	 n_near_end = 2;
	 n_far_start = 30;
	 n_far_end = 700;
	 n_near_blur = 6;
	 n_far_blur = 1.8;
	 n_time = .2;
	
	level.player depth_of_field_tween( n_near_start, n_near_end, n_far_start, n_far_end, n_near_blur, n_far_blur, n_time );	
}

dof_shoot_vtol13(m_player_body)
{
	 n_near_start = 1;
	 n_near_end = 2;
	 n_far_start = 100;
	 n_far_end = 8000;
	 n_near_blur = 6;
	 n_far_blur = 1.8;
	 n_time = .5;
	
	level.player depth_of_field_tween( n_near_start, n_near_end, n_far_start, n_far_end, n_near_blur, n_far_blur, n_time );	
	
	wait 3.0;
	
	level.player thread depth_of_field_off( .01 );
}





dof_shoot_vtol14(m_player_body)
{
	 n_near_start = 1;
	 n_near_end = 2;
	 n_far_start = 200;
	 n_far_end = 20000;
	 n_near_blur = 6;
	 n_far_blur = 1;
	 n_time = .1;
	
	level.player depth_of_field_tween( n_near_start, n_near_end, n_far_start, n_far_end, n_near_blur, n_far_blur, n_time );	
}

dof_shoot_vtol15(m_player_body)
{
	 n_near_start = 1;
	 n_near_end = 2;
	 n_far_start = 200;
	 n_far_end = 20000;
	 n_near_blur = 6;
	 n_far_blur = 1;
	 n_time = .1;
	
	level.player depth_of_field_tween( n_near_start, n_near_end, n_far_start, n_far_end, n_near_blur, n_far_blur, n_time );	
	
	wait 1.0;
	
	level.player thread depth_of_field_off( .01 );
}