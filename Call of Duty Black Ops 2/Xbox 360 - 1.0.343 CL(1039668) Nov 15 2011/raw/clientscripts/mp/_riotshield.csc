#include clientscripts\mp\_utility;
#include clientscripts\mp\_rewindobjects;

#using_animtree ( "mp_riotshield" );

init()
{
	level._client_flag_callbacks["scriptmover"][level.const_flag_riotshield_deploy] = ::riotshield_deploy_anim;
	level._client_flag_callbacks["scriptmover"][level.const_flag_riotshield_destroy] = ::riotshield_destroy_anim;
}

//******************************************************************
//                                                                 *
//                                                                 *
//******************************************************************
riotshield_deploy_anim( localClientNum, set )
{	
	if ( !set )
		return;

	self UseAnimTree( #animtree );
	self SetAnim( %o_riot_stand_deploy, 1.0, 0.0, 1.0 );

	self thread watch_riotshield_damage();
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
riotshield_destroy_anim( localClientNum, set )
{
	// tagTMR<NOTE>: Don't update the anim the same frame as the model swap
	wait (0.05);

	self UseAnimTree( #animtree );
	self SetAnim( %o_riot_stand_destroyed, 1.0, 0.0, 1.0 );
}