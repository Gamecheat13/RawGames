// Quantum Bomb client side scripts
#include clientscripts\mp\_utility;
#include clientscripts\mp\_music;
#include clientscripts\mp\zombies\_zm_weapons;
#include clientscripts\mp\zombies\_zm;

init()
{
	level.zombie_quantum_bomb_spawned_func = ::quantum_bomb_spawned;
	
	if ( GetDvar( "createfx" ) == "on" )
	{
		return;
	}
	
	if ( !clientscripts\mp\zombies\_zm_weapons::is_weapon_included( "zombie_quantum_bomb" ) )
	{
		return;
	}
	
	level._effect["quantum_bomb_viewmodel_twist"]	= LoadFX( "weapon/quantum_bomb/fx_twist" );
	level._effect["quantum_bomb_viewmodel_press"]	= LoadFX( "weapon/quantum_bomb/fx_press" );

	level thread quantum_bomb_notetrack_think();
}


quantum_bomb_notetrack_think()
{
	for ( ;; )
	{
		level waittill( "notetrack", localclientnum, note );
		
		//println( "@@@ Got notetrack: " + note + " for client: " + localclientnum );

		switch( note )
		{
		case "quantum_bomb_twist":
			PlayViewmodelFx( localclientnum, level._effect["quantum_bomb_viewmodel_twist"], "tag_weapon" );
		break;

		case "quantum_bomb_press":
			PlayViewmodelFx( localclientnum, level._effect["quantum_bomb_viewmodel_press"], "tag_weapon" );
		break;

		}
	}
}


quantum_bomb_spawned( localClientNum, play_sound ) // self == the grenade
{
	temp_ent = spawn( 0, self.origin, "script_origin" );
	temp_ent playsound( 0, "wpn_quantum_rise" );
	
	while( isdefined( self ) )
	{
		temp_ent.origin = self.origin;
		wait(.05);
	}
	
	temp_ent delete();
}
