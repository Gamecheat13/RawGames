/*
THIS FILE HANDLES BOTH:
 - Chasing the guy through the village
*/


#include maps\_utility;
#include maps\pow_utility;


start_village_chase()
{
	level notify("update_objectives");
	
	//TODO: Remove this
	//-- This is a test to see if Barnes can be a badass and to play with whizby
	barnes_spawner = GetEnt("barnes_spawner", "targetname");
	barnes_spawner add_spawn_function(::barnes_whizby_badass );
	
	level thread manage_barnes_color_chain();
	level thread maps\pow_tunnels::start_tunnel_chase();
}

manage_barnes_color_chain()
{
	//-- first sm
	level thread sm_use_trig_when_cleared( "spwn_mng_1", "trig_bc_1", "targetname", true );
	level thread sm_use_trig_when_cleared( "spwn_mng_1", "targetname", true);
	
	//-- second sm
	level thread sm_use_trig_when_cleared( "spwn_mng_2", "trig_bc_2", "targetname", true);
}

barnes_whizby_badass()
{
	self endon("death");
	while(1)
	{
		self waittill("whizby", who);
		
		who.health = 1;
		self.perfectaim = true;
		self SetEntityTarget(who);
		who waittill("death");
		self ClearEntityTarget();
		wait(1);
	}
}