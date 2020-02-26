#include common_scripts\utility;
#include maps\_utility;
#include maps\_scene;
#include maps\yemen_utility;
#include maps\_glasses;


/* ------------------------------------------------------------------------------------------
	INIT functions
-------------------------------------------------------------------------------------------*/

//	event-specific flags
init_flags()
{
	flag_init( "obj_hijacked_bridge" );
	flag_init( "obj_hijacked_sitrep" );
	
	flag_init( "hijacked_cliffside_firefight" );
	flag_init( "hijacked_cliffside_building_destroyed" );
}


//
//	event-specific spawn functions
init_spawn_funcs()
{

}


/* ------------------------------------------------------------------------------------------
	SKIPTO functions
-------------------------------------------------------------------------------------------*/

//	skip-to only initialization (not run if this event skip-to isn't used)
skipto_hijacked()
{
	skipto_setup();
	
	start_teleport( "skipto_hijacked_player" );
	
	//Salazar	
	if( !IsDefined( level.salazar ) )
	{
		sp_salazar = GetEnt("skipto_hijacked_salazar_spawn", "targetname");
	    level.salazar = simple_spawn_single(sp_salazar);
	    level.salazar make_hero();
	}
}


/* ------------------------------------------------------------------------------------------
	MAIN functions 
-------------------------------------------------------------------------------------------*/

//	NOTE: This is a blocking function call.  When this function ends, the next function in 
//		your skipto sequence will be called.
main()
{
	/#
		IPrintLn( "Event Name" );
	#/
		trigger_off( "trig_hurt_hijacked_stairs", "targetname" );			
		trigger_off( "trig_hurt_hijacked_highroad_nest", "targetname" );
		trigger_off( "trig_hurt_hijacked_lowroad_nest", "targetname" );
		trigger_off( "trig_hurt_hijacked_stairs", "targetname" );
		
		flag_set( "obj_hijacked_bridge" );
		flag_set( "hijacked_cliffside_firefight" );
	
		level thread hijacked_lowroad_arch_damaged();
		level thread hijacked_bridge_soldier_fall();
		
		level thread hijacked_drones_hacked();
		level thread hijacked_bridge_drone_crash();
		level thread hijacked_drones_enter();
		level thread hijacked_cliffside_building_guys_shoot();
			
		level thread hijacked_cliffside_stairs_terrorists_advance();
		level thread hijacked_cliffside_stairs_building_explode();
		
		level thread hijacked_cliffside_ambient_gunfire();
		level thread hijacked_drones_enter_shootat();
		
		level thread hijacked_damage_collapse();
}


/* ------------------------------------------------------------------------------------------
	EVENT functions
-------------------------------------------------------------------------------------------*/
//
hijacked_drones_hacked()
{
	trigger_wait("trig_drone_conltrol_drones_offline");//Currently this trigger is drone_control.map
	
	run_scene( "hijacked_menendez_hack" );
}

//Drones come in in interesting ways
hijacked_drones_enter()
{
	a_run_triggers = GetEntArray("trig_hijacked_drones_ambush", "targetname");
	array_thread(a_run_triggers, ::hijacked_drones_enter_think);
}

hijacked_drones_enter_think()
{
	self waittill ("trigger");
	
	m_drone = GetEnt( self.target, "targetname" );
	s_movepoint = GetStruct( m_drone.target, "targetname" );

	m_drone MoveTo( s_movepoint.origin, Float( m_drone.script_noteworthy ) );
//	m_drone waittill ("movedone");
}

//Drones shoot hanging soldier
//hijacked_drones_enter()
//{
//	a_run_triggers = GetEntArray("trig_hijacked_drones_ambush", "targetname");
//	array_thread(a_run_triggers, ::hijacked_drones_enter_think);
//}

hijacked_cliffside_ambient_gunfire()
{
	trigger_wait("trig_hijacked_cliffside_ambient_gunfire");
	
//	flag_toggle( "hijacked_cliffside_gunfire" );
	
	s_gun = GetStruct( "hijacked_cliffside_gunfire" );
	
	while( flag( "drone_controller_button" ) )
	{
		MagicBullet( "deserttac_sp", s_gun.origin, s_gun.target.origin );
		wait 0.5;//time shots
	}
}

//Falling debris kills guys
hijacked_damage_collapse()
{	
	a_run_triggers = GetEntArray("trig_damage_hijacked_collapse", "targetname");
	array_thread(a_run_triggers, ::hijacked_damage_collapse_think);
}

hijacked_damage_collapse_think()
{	
	self waittill("trigger");
	
	IPrintLnBold( "damaged" );

//	trig_hurt = GetEnt( self.target, "targetname" );
	
	trigger_on( self.target, "targetname" );
	wait 1; //wait for damage to be dealt
	trigger_off( self.target, "targetname" );
}

//Destory markers
hijacked_destory_collapse_marker()
{	
	a_run_triggers = GetEntArray("trig_hijacked_destroy_marker", "targetname");
	array_thread(a_run_triggers, ::hijacked_destory_collapse_marker_think);
}

hijacked_destory_collapse_marker_think()
{
	self waittill("trigger");	
	s_marker = GetStruct( self.target, "targetname" );
//	set_objective( level.OBJ_DRONE_CONTROL_BRIDGE, s_marker, "destroy" );
}
/* ------------------------------------------------------------------------------------------
	LOW ROAD functions
-------------------------------------------------------------------------------------------*/

//First Bridge arch damaged
hijacked_lowroad_arch_damaged()
{
	trigger_wait("trig_hijacked_lowroad_arch_damaged");
	
	s_rpg = GetStruct( "s_hijacked_cliffside_magicbullet_rpg_window", "targetname" );
	s_rpg_target = GetStruct( "s_hijacked_lowroad_arch", "targetname" );

	MagicBullet( "rpg_magic_bullet_sp", s_rpg.origin, s_rpg_target.origin );
	
//	PlayFX( level._effect["dirthit_libya"], s_bridge_damage.origin );//temp to test for timing
}

/* ------------------------------------------------------------------------------------------
	BRIDGE functions
-------------------------------------------------------------------------------------------*/

//Suicide drone hits bridge
hijacked_bridge_drone_crash()
{
	trigger_wait("trig_hijacked_explode_bridge");
	
	m_drone = GetEnt( "m_hijacked_bridge_drone_crash", "targetname" );
	s_crashpoint = GetStruct( "s_hijacked_bridge_explode", "targetname" );

	m_drone MoveTo( s_crashpoint.origin, 1 );
	m_drone waittill ("movedone");
	m_drone Delete();
	
	self thread hijacked_bridge_explode();
}

//Bridge explodes
hijacked_bridge_explode()
{
	exploder( 750 );
	
	level notify( "fxanim_bridge_explode_start" );
	
	self thread hijacked_bridge_soldier_hang();
}

//Soldier hanging from bridge
hijacked_bridge_soldier_hang()
{	
	run_scene( "hijacked_bridge_hang" );
}

//Drones come in and shoot at something
hijacked_drones_enter_shootat()
{
	a_run_triggers = GetEntArray("trig_hijacked_drones_ambush_and_shoot", "targetname");
	array_thread(a_run_triggers, ::hijacked_drones_enter_shootat_think);
}

hijacked_drones_enter_shootat_think()
{
	self waittill ("trigger");
	
	m_drone = GetEnt( self.target, "targetname" );
	s_movepoint = GetStruct( m_drone.target, "targetname" );
	
	trig_target = GetEnt("trig_dmg_hijacked_bridge_soldier_hanging", "targetname" );
	ai_guy_hang = GetEnt( "sp_hijacked_soldier_hang_ai", "targetname" );
	
	m_drone MoveTo( s_movepoint.origin, Float( m_drone.script_noteworthy ) );
	m_drone waittill ("movedone");
	
	//TODO: get rid of copied code
	if ( isDefined( ai_guy_hang ) )
	{
		IPrintLnBold( "guy exists" );
		//rapid fire at guy
		for ( i = 0; i < 30; i++ )
			{
				MagicBullet( "mp7_sp", s_movepoint.origin, trig_target.origin );
				
				wait 0.1;
			}
	}
	else
	{
		IPrintLnBold( "you exist" );
		//rapid fire at guy
		for ( i = 0; i < 30; i++ )
			{
				MagicBullet( "mp7_sp", s_movepoint.origin, level.player.origin );
				
				wait 0.1;
			}
	}
	
	trigger_off( "trig_dmg_hijacked_bridge_soldier_hanging", "targetname" );
}

//Soldier falls from bridge when player gets close
hijacked_bridge_soldier_fall()
{	
	trigger_wait("trig_hijacked_bridge_fall");
	
	level notify( "fxanim_bridge_drop_start" );
	
	flag_set( "obj_hijacked_sitrep" );	

}

//Ambient shooting on cliffside
//TODO: get rid of all of this copied stuff
hijacked_cliffside_building_guys_shoot()
{
	s_gun1 = GetStruct( "s_hijacked_cliffside_magicbullet_gun1", "targetname" );
	s_gun1_target = GetStruct( s_gun1.target, "targetname" );
	s_gun2 = GetStruct( "s_hijacked_cliffside_magicbullet_gun2", "targetname" );
	s_gun2_target = GetStruct( s_gun2.target, "targetname" );
	s_gun3 = GetStruct( "s_hijacked_cliffside_magicbullet_gun3", "targetname" );
	s_gun3_target = GetStruct( s_gun3.target, "targetname" );
	
	while(flag("hijacked_cliffside_firefight"))
	{
		for ( i = 0; i < 60; i++ )
			{
				MagicBullet( "mp7_sp", s_gun1.origin, s_gun1_target.origin );
				MagicBullet( "mp7_sp", s_gun2.origin, s_gun2_target.origin );
				MagicBullet( "mp7_sp", s_gun3.origin, s_gun3_target.origin );
					
				wait 0.1;
			}
		
		wait 0.1;
	}
}

//Terrorists move down stairs, American rocket hits building
hijacked_cliffside_stairs_terrorists_advance()
{
	trigger_wait( "trig_hijacked_cliffside_stairs_ai", "targetname" );
	
	s_rpg = GetStruct( "s_hijacked_cliffside_magicbullet_rpg_building_collapse", "targetname" );
	s_target = GetStruct( s_rpg.target, "targetname" );
	
	MagicBullet( "rpg_sp", s_rpg.origin, s_target.origin );
}

//Building explodes
hijacked_cliffside_stairs_building_explode()
{
	trigger_wait( "trig_dmg_hijacked_stairs", "targetname" );
	
	level notify( "fxanim_rock_slide_start" );
	wait 1; //wait for fx anim to proceed a bit
	trigger_on( "trig_hurt_hijacked_stairs", "targetname" );
}