#include clientscripts\mp\_utility;
#include clientscripts\mp\_rewindobjects;

#insert raw\maps\mp\_clientflags.gsh;

#using_animtree ( "mp_riotshield" );

init()
{
	RegisterClientField( "scriptmover", "riotshield_state", 2, "int", ::shield_state_change, false );

	level._effect["riotshield_light"] = loadfx( "weapon/riotshield/fx_riotshield_depoly_lights" );
	level._effect["riotshield_dust"] = loadfx( "weapon/riotshield/fx_riotshield_depoly_dust" );
}

//******************************************************************
//                                                                 *
//                                                                 *
//******************************************************************
shield_state_change( localClientNum, oldVal, newVal, bNewEnt, bInitialSnap, fieldName )
{
	self endon("entityshutdown");

	switch( newVal )
	{
		case 1:
		{
			self thread riotshield_deploy_anim( localClientNum );	
			break;
		}
		case 2:
		{
			self thread riotshield_destroy_anim( localClientNum );
			break;
		}
	}
}

//******************************************************************
//                                                                 *
//                                                                 *
//******************************************************************
riotshield_deploy_anim( localClientNum )
{
	self endon("entityshutdown");

	self thread watch_riotshield_damage();

	self UseAnimTree( #animtree );
	self SetAnim( %o_riot_stand_deploy, 1.0, 0.0, 1.0 );

	PlayFXOnTag( localClientNum, level._effect["riotshield_dust"], self, "tag_origin" );

	wait( 0.8 );

	self.shieldLightFx = PlayFXOnTag( localClientNum, level._effect["riotshield_light"], self, "tag_fx" );
}

//******************************************************************
//                                                                 *
//                                                                 *
//******************************************************************
watch_riotshield_damage()
{
	self endon("entityshutdown");

	while (1)
	{
		self waittill( "damage", damage_loc, damage_type );

		self UseAnimTree( #animtree );

		//println("CLIENT: Riotshield hit - " + damage_type + " " + damage_loc );

		if ( damage_type == "MOD_MELEE" )
		{
			self SetAnim( %o_riot_stand_melee_front, 1.0, 0.0, 1.0 );
		}
		else
		{
			self SetAnim( %o_riot_stand_shot, 1.0, 0.0, 1.0 );
		}
	}
}

//******************************************************************
//                                                                 *
//                                                                 *
//******************************************************************
riotshield_destroy_anim( localClientNum )
{
	if ( IsDefined( self.shieldLightFx ))
	{
		stopfx( localClientNum, self.shieldLightFx );
	}

	// tagTMR<NOTE>: Don't update the anim the same frame as the model swap
	wait (0.05);

	self PlaySound( localClientNum, "wpn_shield_destroy" );

	self UseAnimTree( #animtree );
	self SetAnim( %o_riot_stand_destroyed, 1.0, 0.0, 1.0 );
}