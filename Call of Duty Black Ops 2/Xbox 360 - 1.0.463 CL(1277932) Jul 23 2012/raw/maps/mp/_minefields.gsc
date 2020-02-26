#include maps\mp\_utility;
#include common_scripts\utility;

init()
{
	minefields = getentarray("minefield", "targetname");
	if(minefields.size > 0)
	{
		level._effect["mine"] = LoadFX( "weapon/satchel/fx_explosion_satchel_generic" );
		level._effect["splash"] = LoadFX( "bio/player/fx_player_water_splash_impact" );
	}
	
	array_thread(minefields, ::minefield_function);
}

//Self is trigger. "trigger_thread" starts a function on the player that ends immediately when they leave the trigger
minefield_function()
{
	while(true)
	{	
		self waittill("trigger", ent);
		if( IsPlayer( ent ) && IsAlive( ent ) )
		{
			self thread trigger_thread(ent, ::player_in_minefield);
		}
		else if(IsDefined(ent.targetname) && ent.targetname == "rcbomb")
		{	
			//Destroy RC bomb
			ent maps\mp\killstreaks\_rcbomb::rcbomb_force_explode(); 
		}	
	}
}

//Self is trigger. "Player" is the player in the mine field.
player_in_minefield(player, endon_string)
{
	player endon ("death");
	player endon ("disconnect");
	player endon( endon_string );
	
	random_delay = RandomIntRange(2,3);
		
	wait (random_delay);
	PlayFX(level._effect["mine"], player.origin);
	playsoundatposition ("mpl_kls_artillery_impact", player.origin );	
	if(IsDefined(self.script_noteworthy) && self.script_noteworthy == "water")
	{
		PlayFX(level._effect["splash"], player.origin);
		playsoundatposition ("wpn_grenade_explode_water", player.origin  );
	}	
	physicsexplosionsphere( self.origin, 100, 80, 1, 400, 100 );
	RadiusDamage( player.origin, 40, player.health * 2, player.health * 2 );	
}
