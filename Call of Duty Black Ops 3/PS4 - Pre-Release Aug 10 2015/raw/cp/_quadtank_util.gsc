/*
 * Created by ScriptDevelop.
 * User: jalexander
 * Date: 7/1/2015
 * Time: 8:15 AM
 * 
 * Added new file for cp-specific quad tank utility functions. Keeps levels without quadtanks from breaking
 */
 
#using scripts\shared\util_shared;
#using scripts\shared\callbacks_shared;
#using scripts\shared\vehicles\_quadtank;
#using scripts\cp\_util;


	
#namespace quadtank_util;

#precache( "string", "OBJECTIVES_QUAD_TANK_HINT_ROCKET" );
#precache( "string", "OBJECTIVES_QUAD_TANK_HINT_TROPHY" );
	
/////////////////////////////
//QUAD TANK HINT TEXT
/@
"Name: init_quad_tank_hint_text()"
"Summary: Sets up a hint text reminder when fighting a quad tank. Call on a quadtank"
"Module: Utility"
"Example: vh_quad_tank init_quad_tank_hint_text();"
@/
function init_quad_tank_hint_text()
{
	self thread quad_tank_trophy_hint();
	callback::on_vehicle_damage( &quad_tank_bullet_damage_hint_tracker, self );
}
	
//self is a quad tank
//show hints to players whenever multiple rockets are repulsed
function quad_tank_trophy_hint()
{
	self endon( "death" );
	self endon( "quad_tank_end_trophy_hint_text" );
	
	n_rocket_count = 0;
	n_hint_threshold = 2;
	
	w_player_rocket = GetWeapon( "launcher_standard" );
	
	while ( true )
	{
		//if two rockets are repulsed, show hint text for that
		self notify( "quad_tank_trophy_hint_disable" );
		self waittill( "projectile_applyattractor", missile );
		
		if( missile.weapon === w_player_rocket ) //check for rockets fired from player rocket launchers
		{
			n_rocket_count++;
		
			if( n_rocket_count >= n_hint_threshold )
			{				
				n_rocket_count = 0;
				
				foreach( player in level.activeplayers )
				{
					player thread util::show_hint_text( &"OBJECTIVES_QUAD_TANK_HINT_TROPHY", false, "quad_tank_trophy_hint_disable" );
					player thread quad_tank_trophy_hint_disable( self );
				}
			
				n_hint_threshold = n_hint_threshold * 2; //increase the number of rockets required to trigger hints after the first one. if the player understood the first hint message, they probably won't see it again.
			}
			
			wait 2; //wait a bit before checking for the next player rocket so notify isn't hit twice
		}
	}
}

//self is a player
//end any active hint text if the trophy system gets disabled 
function quad_tank_trophy_hint_disable( e_quad_tank )
{
	e_quad_tank endon( "quad_tank_trophy_hint_disable" );
	e_quad_tank endon( "death" );
	self endon( "death" );
	
	e_quad_tank util::waittill_any( "trophy_system_disabled", "trophy_system_destroyed" );
	
	self notify( "quad_tank_trophy_hint_disable" );
	e_quad_tank notify( "quad_tank_trophy_hint_disable" );
}

//self is a quad tank
//track bullet only damage from players, and when enough is done, show hint
function quad_tank_bullet_damage_hint_tracker( obj, params )
{	
	if( IsPlayer( params.eAttacker ) && self quadtank::trophy_disabled() && IsSubStr( params.sMeansOfDeath, "BULLET" ) )
	{
		player = params.eAttacker;
			
		if( isdefined( player.n_quad_tank_bullet_hint_damage ) )
		{
			player.n_quad_tank_bullet_hint_damage += params.iDamage;
		}
		else
		{
			player.n_quad_tank_bullet_hint_damage = params.iDamage;
		}
		
		if( player.n_quad_tank_bullet_hint_damage >= 999 )
		{
			player.n_quad_tank_bullet_hint_damage = 0;
			
			player notify( "quad_tank_rocket_hint_disable" );
			player thread util::show_hint_text( &"OBJECTIVES_QUAD_TANK_HINT_ROCKET", false, "quad_tank_rocket_hint_disable" );
			player thread quad_tank_rocket_hint_disable( self );
		}
	}
}

//self is a player
//get rid of any active hints if quad tank is damaged by a rocket
function quad_tank_rocket_hint_disable( e_quad_tank )
{
	e_quad_tank endon( "death" );
	self endon( "death" );
	self endon( "quad_tank_rocket_hint_disable" );
	
	while( true )
	{
		e_quad_tank waittill( "damage", n_damage, e_attacker, direction_vec, v_impact_point, damageType, modelName, tagName, partName, weapon, iDFlags );
		
		if( weapon.weapclass === "rocketlauncher" && IsPlayer( e_attacker ) )
		{
			e_quad_tank notify( "quad_tank_rocket_hint_disable" );
			self notify( "quad_tank_rocket_hint_disable" );
		}
	}
}
//////////////////////