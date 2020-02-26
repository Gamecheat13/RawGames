#include maps\mp\_utility;
#include common_scripts\firingrange_share;
#include common_scripts\utility;

main()
{
	maps\mp\mp_firingrange_precache::main();
	maps\mp\_load::main();
	
	game[ "attackers" ] = "axis";
	game[ "defenders" ] = "allies";
	
	level.additional_weaponlist = [];
	
	//Add weapons here..
	add_mp_weapon( "kriss_mp" );
	add_mp_weapon( "kriss_acog_mp" );
	add_mp_weapon( "kriss_eotech_mp" );
	add_mp_weapon( "kriss_reflex_mp" );
	add_mp_weapon( "kriss_silencer_mp" );
	add_mp_weapon( "kriss_thermal_mp" );
	add_mp_weapon( "mp5k_mp" );
	add_mp_weapon( "mp5k_acog_mp" );
	add_mp_weapon( "mp5k_eotech_mp" );
	add_mp_weapon( "mp5k_reflex_mp" );
	add_mp_weapon( "mp5k_silencer_mp" );
	add_mp_weapon( "mp5k_thermal_mp" );
	add_mp_weapon( "p90_mp" );
	add_mp_weapon( "p90_acog_mp" );
	add_mp_weapon( "p90_eotech_mp" );
	add_mp_weapon( "p90_reflex_mp" );
	add_mp_weapon( "p90_silencer_mp" );
	add_mp_weapon( "p90_thermal_mp" );
	add_mp_weapon( "pp2000_mp" );
	add_mp_weapon( "pp2000_eotech_mp" );
	add_mp_weapon( "pp2000_reflex_mp" );
	add_mp_weapon( "pp2000_silencer_mp" );

	add_mp_weapon( "ump45_mp" );
	add_mp_weapon( "ump45_eotech_mp" );
	add_mp_weapon( "ump45_silencer_mp" );
	add_mp_weapon( "ump45_thermal_mp" );
	add_mp_weapon( "ump45_reflex_mp" );
	add_mp_weapon( "ump45_acog_mp" );
	add_mp_weapon( "uzi_mp" );
	add_mp_weapon( "uzi_acog_mp" );
	add_mp_weapon( "uzi_eotech_mp" );
	add_mp_weapon( "uzi_reflex_mp" );
	add_mp_weapon( "uzi_silencer_mp" );
	add_mp_weapon( "uzi_thermal_mp" );

	add_mp_weapon( "aug_grip_mp" );

	add_mp_weapon( "barrett_acog_mp" );
	add_mp_weapon( "barrett_mp" );
	add_mp_weapon( "barrett_thermal_mp" );
	add_mp_weapon( "barrett_heartbeat_mp" );
	add_mp_weapon( "cheytac_mp" );
	add_mp_weapon( "cheytac_thermal_mp" );
	add_mp_weapon( "cheytac_acog_mp" );
	add_mp_weapon( "cheytac_silencer_mp" );
	add_mp_weapon( "cheytac_thermal_mp" );
	add_mp_weapon( "cheytac_heartbeat_mp" );
	add_mp_weapon( "cheytac_xmags_mp" );
	add_mp_weapon( "cheytac_fmj_mp" );
	add_mp_weapon( "m21_thermal_mp" );
	add_mp_weapon( "m21_mp" );
	add_mp_weapon( "m21_acog_mp" );
	add_mp_weapon( "m21_fmj_mp" );
	add_mp_weapon( "m21_heartbeat_mp" );
	add_mp_weapon( "m21_silencer_mp" );
	add_mp_weapon( "m21_xmags_mp" );
	add_mp_weapon( "wa2000_mp" );
	add_mp_weapon( "wa2000_heartbeat_mp" );

	add_mp_weapon( "at4_mp" );
	add_mp_weapon( "m79_mp" );
	add_mp_weapon( "rpg_mp" );

	//add_mp_weapon( "ak47_acog_mp" );
	//add_mp_weapon( "ak47_eotech_mp" );
	//add_mp_weapon( "ak47_gl_mp" );
	//add_mp_weapon( "ak47_heartbeat_mp" );
	add_mp_weapon( "ak47_mp" );
	//add_mp_weapon( "ak47_reflex_mp" );
	//add_mp_weapon( "ak47_silencer_mp" );
	//add_mp_weapon( "ak47_shotgun_mp" );
	//add_mp_weapon( "ak47_thermal_mp" );
	add_mp_weapon( "fal_acog_mp" );
	add_mp_weapon( "fal_eotech_mp" );
	add_mp_weapon( "fal_gl_mp" );
	add_mp_weapon( "fal_heartbeat_mp" );
	add_mp_weapon( "fal_mp" );
	add_mp_weapon( "fal_reflex_mp" );
	add_mp_weapon( "fal_shotgun_mp" );
	add_mp_weapon( "fal_silencer_mp" );
	add_mp_weapon( "fal_thermal_mp" );
	//add_mp_weapon( "famas_acog_mp" );
	//add_mp_weapon( "famas_eotech_mp" );
	//add_mp_weapon( "famas_gl_mp" );
	//add_mp_weapon( "famas_heartbeat_mp" );
	add_mp_weapon( "famas_mp" );
	//add_mp_weapon( "famas_reflex_mp" );
	//add_mp_weapon( "famas_shotgun_mp" );
	//add_mp_weapon( "famas_silencer_mp" );
	//add_mp_weapon( "famas_thermal_mp" );
	add_mp_weapon( "fn2000_acog_mp" );
	add_mp_weapon( "fn2000_eotech_mp" );
	add_mp_weapon( "fn2000_gl_mp" );
	add_mp_weapon( "fn2000_heartbeat_mp" );
	add_mp_weapon( "fn2000_mp" );
	add_mp_weapon( "fn2000_reflex_mp" );
	add_mp_weapon( "fn2000_shotgun_mp" );
	add_mp_weapon( "fn2000_silencer_mp" );
	add_mp_weapon( "fn2000_thermal_mp" );
	add_mp_weapon( "m16_acog_mp" );
	add_mp_weapon( "m16_eotech_mp" );
	add_mp_weapon( "m16_gl_mp" );
	add_mp_weapon( "m16_heartbeat_mp" );
	add_mp_weapon( "m16_mp" );
	add_mp_weapon( "m16_reflex_mp" );
	add_mp_weapon( "m16_shotgun_mp" );
	add_mp_weapon( "m16_silencer_mp" );
	add_mp_weapon( "m16_thermal_mp" );
	add_mp_weapon( "m4_acog_mp" );
	add_mp_weapon( "m4_eotech_mp" );
	add_mp_weapon( "m4_gl_mp" );
	add_mp_weapon( "m4_heartbeat_mp" );
	add_mp_weapon( "m4_mp" );
	add_mp_weapon( "m4_reflex_mp" );
	add_mp_weapon( "m4_shotgun_mp" );
	add_mp_weapon( "m4_silencer_mp" );
	add_mp_weapon( "m4_thermal_mp" );
	add_mp_weapon( "masada_acog_mp" );
	add_mp_weapon( "masada_eotech_mp" );
	add_mp_weapon( "masada_gl_mp" );
	add_mp_weapon( "masada_heartbeat_mp" );
	add_mp_weapon( "masada_mp" );
	add_mp_weapon( "masada_reflex_mp" );
	add_mp_weapon( "masada_silencer_mp" );
	add_mp_weapon( "masada_shotgun_mp" );
	add_mp_weapon( "masada_thermal_mp" );
	add_mp_weapon( "scar_acog_mp" );
	add_mp_weapon( "scar_eotech_mp" );
	add_mp_weapon( "scar_gl_mp" );
	add_mp_weapon( "scar_heartbeat_mp" );
	add_mp_weapon( "scar_mp" );
	add_mp_weapon( "scar_reflex_mp" );
	add_mp_weapon( "scar_shotgun_mp" );
	add_mp_weapon( "scar_silencer_mp" );
	add_mp_weapon( "scar_thermal_mp" );
	add_mp_weapon( "tavor_acog_mp" );
	add_mp_weapon( "tavor_eotech_mp" );
	add_mp_weapon( "tavor_gl_mp" );
	add_mp_weapon( "tavor_heartbeat_mp" );
	add_mp_weapon( "tavor_mp" );
	add_mp_weapon( "tavor_reflex_mp" );
	add_mp_weapon( "tavor_shotgun_mp" );
	add_mp_weapon( "tavor_silencer_mp" );
	add_mp_weapon( "tavor_thermal_mp" );

	//add_mp_weapon( "m60e4_acog_mp" );
	//add_mp_weapon( "m60e4_grip_mp" );
	//add_mp_weapon( "m60e4_mp" );
	//add_mp_weapon( "m60e4_reflex_mp" );
	//add_mp_weapon( "rpd_acog_mp" );
	add_mp_weapon( "rpd_mp" );	
	//add_mp_weapon( "rpd_acog_mp" );	
	//add_mp_weapon( "rpd_eotech_mp" );	
	//add_mp_weapon( "rpd_grip_mp" );
	//add_mp_weapon( "rpd_heartbeat_mp" );
	//add_mp_weapon( "rpd_reflex_mp" );
	//add_mp_weapon( "rpd_silencer_mp" );
	//add_mp_weapon( "rpd_thermal_mp" );
	add_mp_weapon( "sa80_acog_mp" );
	add_mp_weapon( "sa80_grip_mp" );
	add_mp_weapon( "sa80_mp" );
	add_mp_weapon( "sa80_reflex_mp" );
	add_mp_weapon( "sa80_eotech_mp" );
	add_mp_weapon( "sa80_thermal_mp" );
	add_mp_weapon( "sa80_heartbeat_mp" );
	add_mp_weapon( "sa80_silencer_mp" );
	//add_mp_weapon( "saw_acog_mp" );
	//add_mp_weapon( "saw_grip_mp" );
	//add_mp_weapon( "saw_mp" );
	//add_mp_weapon( "saw_reflex_mp" );

	add_mp_weapon( "aug_mp" );
	add_mp_weapon( "aug_fmj_mp" );
	add_mp_weapon( "aug_reflex_mp" );
	add_mp_weapon( "aug_acog_mp" );
	add_mp_weapon( "aug_silencer_mp" );
	add_mp_weapon( "aug_eotech_mp" );
	add_mp_weapon( "aug_grip_mp" );
	add_mp_weapon( "aug_thermal_mp" );

	add_mp_weapon( "mg4_mp" );
   	add_mp_weapon( "mg4_grip_mp" );
   	add_mp_weapon( "mg4_silencer_mp" );
  	add_mp_weapon( "mg4_thermal_mp" );
  	add_mp_weapon( "mg4_acog_mp" );
  	add_mp_weapon( "mg4_reflex_mp" );
  	add_mp_weapon( "mg4_eotech_mp" );
   	 
   	add_mp_weapon( "m240_mp" );
    	add_mp_weapon( "m240_acog_mp" );
    	add_mp_weapon( "m240_eotech_mp" );
    	add_mp_weapon( "m240_grip_mp" );
   	add_mp_weapon( "m240_heartbeat_mp" );
   	add_mp_weapon( "m240_reflex_mp" );
	add_mp_weapon( "m240_silencer_mp" );
	add_mp_weapon( "m240_thermal_mp" );
    



	add_mp_weapon( "beretta_mp" );
	add_mp_weapon( "beretta393_mp" );
	add_mp_weapon( "beretta393_silencer_mp" );
	add_mp_weapon( "beretta393_eotech_mp" );
	add_mp_weapon( "beretta393_reflex_mp" );
	add_mp_weapon( "beretta393_akimbo_mp" );
	add_mp_weapon( "beretta_tactical_mp" );
	add_mp_weapon( "coltanaconda_mp" );
	add_mp_weapon( "coltanaconda_tactical_mp" );
	add_mp_weapon( "deserteagle_mp" );
	add_mp_weapon( "deserteagle_tactical_mp" );
	add_mp_weapon( "glock_mp" );
	add_mp_weapon( "glock_eotech_mp" );
	add_mp_weapon( "glock_reflex_mp" );
	add_mp_weapon( "usp_mp" );
	add_mp_weapon( "usp_tactical_mp" );
	//add_mp_weapon( "usp_silencer_mp" );

	add_mp_weapon( "tmp_eotech_mp" );
	add_mp_weapon( "tmp_fmj_mp" );
	add_mp_weapon( "tmp_reflex_mp" );
	add_mp_weapon( "tmp_silencer_mp" );
	add_mp_weapon( "tmp_xmags_mp" );
	add_mp_weapon( "tmp_mp" );

	add_mp_weapon( "aa12_mp" );
	add_mp_weapon( "aa12_fmj_mp" );
	add_mp_weapon( "aa12_grip_mp" );
	add_mp_weapon( "aa12_reflex_mp" );
	add_mp_weapon( "aa12_silencer_mp" );
	add_mp_weapon( "aa12_xmags_mp" );
	add_mp_weapon( "aa12_eotech_mp" );
	//add_mp_weapon( "m1014_grip_mp" );
	add_mp_weapon( "m1014_mp" );
	//add_mp_weapon( "m1014_xmags_mp" );
	//add_mp_weapon( "m1014_silencer_mp" );
	//add_mp_weapon( "m1014_fmj_mp" );
	//add_mp_weapon( "m1014_reflex_mp" );
	//add_mp_weapon( "m1014_eotech_mp" );
	add_mp_weapon( "model1887_mp" );
	add_mp_weapon( "ranger_mp" );
	add_mp_weapon( "ranger_akimbo_mp" );
	add_mp_weapon( "striker_grip_mp" );
	add_mp_weapon( "striker_mp" );
	add_mp_weapon( "striker_eotech_mp" );
	add_mp_weapon( "striker_reflex_mp" );
	
	add_mp_weapon( "spas12_mp" );
	add_mp_weapon( "spas12_silencer_mp" );
	add_mp_weapon( "spas12_reflex_mp" );
	//add_mp_weapon( "spas12_heartbeat_mp" );
  	add_mp_weapon( "spas12_eotech_mp" );

	
	//add_mp_weapon( "riotshield_mp" );
	for( i=0; i < level.additional_weaponlist.size; i++ )
		precacheitem(level.additional_weaponlist[i]);

	//mp unique stuff
	level.targmarks_func = ::sp_marks_func;
	level.weaponslotsthread = ::weaponslots;
	
	mp_firing_range_start(); //delay while player gets through menu
	
	thread common_scripts\firingrange_share::init();
	
	setExpFog(800, 6000, .5, .55 , .6, 1, 0);
	thread mp_firingrange_init();
}

mp_firing_range_start()
{
	//little hack to get player going.
	while ( !isdefined( getentarray( "player", "classname" )[ 0 ] ) )
		wait .05;
	level.player = getentarray( "player", "classname" )[ 0 ];	
	level.player setorigin((2516, -341, 52));
	level.player thread PlayerUnlimitedAmmoThread();
	
	level.player thread AltWeaponThread();
}

	
mp_firingrange_init()
{
	
//	SetDvar( "g_entinfo", "1" );
	SetDvar( "scr_war_timelimit", "99999" );

	wait 10.0;
	IPrintLnBold( "===========================================" );
	IPrintLnBold( "To disable unlimited ammo, set dvar:" );
	IPrintLnBold( "'UnlimitedAmmoOff' to '1'." );
	IPrintLnBold( "===========================================" );

	thread TestBlar();

}


TestBlar()
{
	for ( ;; )
    {
		wait( 0.05 );
		blar = getdvar( "blar" );

		if ( blar == "" )
			continue;

		if ( blar == "shieldon" )
		{
			level.players[1] AttachShieldModel( "weapon_riot_shield_mp", "tag_weapon_left" );
		}
		else if ( blar == "shieldoff" )
		{
		}

        setdvar( "blar", "" );
	}
}


weaponslots()
{
	
	weaponslots = [];
//	//add remaining weapons.
//	for( i=0; i < level.weaponlist.size; i++ )
//	{
//		weaponslots = weaponadd( level.weaponlist[i], weaponslots );
//	}
	return weaponslots;
}

mp_marks_func(loc,normal)
{
	print3d (loc, "O", (1.0, 0.8, 0.5), 1, 2,5*20);
}

sp_marks_func(loc,normal)
{
	thread plot_circle_fortime(5,3,(0,0,1),loc,normal,4);
//	thread plot_circle_fortime(1,5,(1,0,0),loc,normal);
}


altWeaponThread()
{
	for ( ;; )
	{
		self waittill ( "spawned" );
		wait ( 0.05 );
		self SetActionSlot( 2, "altMode" );
	}
}


add_mp_weapon( weaponname )
{
	level.additional_weaponlist[ level.additional_weaponlist.size ] =  weaponname;
}