#include maps\_utility;
#include common_scripts\utility;

#using_animtree( "generic_human" );

// must be called before maps::\_load::main()
main()
{
	if ( isdefined( level.juggernaut_initialized ) )
		return;
		
	level.juggernaut_initialized = true;

	if ( !isdefined( level.subclass_spawn_functions ) )
		level.subclass_spawn_functions = [];

	level.subclass_spawn_functions[ "juggernaut" ] = ::subclass_juggernaut;
}

subclass_juggernaut()
{
	self.juggernaut = true;

	//self.health = 1800;//moved to ai type
	self.minPainDamage = 200;

	self.grenadeAmmo = 0;
	self.doorFlashChance = .05;
	self.aggressivemode = true;
	self.ignoresuppression = true;
	self.no_pistol_switch = true;
	self.noRunNGun = true;
	self.dontMelee = true;
	self.disableExits = true;
	self.disableArrivals = true;
	self.disableBulletWhizbyReaction = true;
	self.combatMode = "no_cover";
	self.neverSprintForVariation = true;
	
	self disable_turnAnims();
	self disable_surprise();
	
	init_juggernaut_animsets();

	self add_damage_function( animscripts\pain::additive_pain );
	self add_damage_function( maps\_spawner::pain_resistance );

	if( !self isBadGuy() )
		return;

	self.bullet_resistance = 40;
	self add_damage_function( maps\_spawner::bullet_resistance );
	self thread juggernaut_hunt_immediately_behavior();

	self.pathEnemyFightDist = 128;
	self.pathenemylookahead = 128;
	level notify( "juggernaut_spawned" );

	self waittill( "death" );

	level notify( "juggernaut_died" );

}

juggernaut_hunt_immediately_behavior()
{
	self endon( "death" );

	self.useChokePoints = false;

	self thread juggernaut_sound_when_player_close();

	//small goal at the player so they can close in aggressively
	while ( 1 )
	{
		wait .5;
		if ( isdefined( self.enemy ) )
		{
			self setgoalpos( self.enemy.origin );
			self.goalradius = 128;
		}
	}
}

juggernaut_sound_when_player_close()
{
	self endon( "death" );
	dist = 900;

	while ( 1 )
	{
		wait .3;
		player = get_closest_player( self.origin );
		if ( distance( player.origin, self.origin ) >= dist )
			continue;
			
		if ( BulletTracePassed( self getEye(), player getEye(), false, undefined ) )
			break;
	}
	level notify( "juggernaut_attacking" );
	//iprintlnbold( "juggernaut" );
	array_thread( level.players, ::playLocalSoundWrapper, "_juggernaut_attack" );
}


init_juggernaut_animsets()
{
	self.walkDist = 500;
	self.walkDistFacingMotion = 500;

	self set_move_animset( "run", %Juggernaut_runF, %Juggernaut_sprint );
	self set_move_animset( "walk", %Juggernaut_walkF );
	self set_move_animset( "cqb", %Juggernaut_walkF );
	self set_combat_stand_animset( %Juggernaut_stand_fire_burst, %Juggernaut_aim5, %Juggernaut_stand_idle, %Juggernaut_stand_reload );
}
