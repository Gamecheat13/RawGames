/*
 * Created by ScriptDevelop.
 * User: mslone
 * Date: 4/11/2012
 * Time: 4:24 PM
 * 
 * To change this template use Tools | Options | Coding | Edit Standard Headers.
 */
#include common_scripts\utility;
#include maps\_utility;

main()
{
	level.tweakfile = true;
	
	//////rimlighting////////
    SetDvar( "r_rimIntensity_debug", 1 );
    SetDvar( "r_rimIntensity", 15 );	
    
    n_near_start = 8;
	n_near_end = 24;
	n_far_start = 128;
	n_far_end = 768;
	n_near_blur = 4;
	n_far_blur = 1.5;
	n_time = 0.05;
	
	//-- flag gets set when level.player is valid
	flag_wait( "level.player" );
	
	level.do_not_use_dof = true; //-- turn off default dof settings from _art.gsc
	level.player depth_of_field_tween( n_near_start, n_near_end, n_far_start, n_far_end, n_near_blur, n_far_blur, n_time );
}

//////////DOF////////////////

dof_frontend()
{
	n_near_start = 8;
	n_near_end = 24;
	n_far_start = 128;
	n_far_end = 768;
	n_near_blur = 4;
	n_far_blur = 1.5;
	n_time = 0.05;
	
	level.player thread depth_of_field_tween( n_near_start, n_near_end, n_far_start, n_far_end, n_near_blur, n_far_blur, n_time );
}