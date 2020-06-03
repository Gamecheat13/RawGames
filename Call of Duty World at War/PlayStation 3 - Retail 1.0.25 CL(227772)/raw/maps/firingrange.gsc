#include maps\_utility;
#include maps\firingrange_share;
#include common_scripts\utility;
#include maps\engagement_dist_share;

main()
{
	viewarms_setup();
	
	PrecacheModel("weapon_rus_flag");	// only for the russian flag
	PrecacheItem( "napalmblob" );  // for the molotov

	level._effect["character_fire_pain_sm"] = LoadFx( "env/fire/fx_fire_player_sm" );
	level._effect["character_fire_death_sm"] = LoadFx( "env/fire/fx_fire_player_md" );
	level._effect["character_fire_death_torso"] = LoadFx( "env/fire/fx_fire_player_torso" );
	level._effect["character_fire_death_torso"] = LoadFx( "env/fire/fx_fire_player_torso" );
		
	maps\_bayonet::init();
	maps\_load::main();
	
	level.weaponslotsthread = ::weaponslots;

	maps\firingrange_share::init();

	setExpFog(800, 6000, 0.627076, 0.611153, 0.5, 0);

	wait 1;
}

// for hot-swappable viewmodel arms
viewarms_setup()
{
	// sp/mp
	level.viewarms[0] = "viewmodel_rus_guard_arms";
	level.viewarms[1] = "viewmodel_usa_marine_arms";
	level.viewarms[2] = "viewmodel_usa_raider_arms";
	level.viewarms_lastSPIndex = 2;
	
	// mp only
	level.viewarms[3] = "viewmodel_ger_waffen_rolledup_arms";
	level.viewarms[4] = "viewmodel_ger_wermacht_arms";
	level.viewarms[5] = "viewmodel_jap_infantry_arms";
	level.viewarms[6] = "viewmodel_jap_infantry_rolledup_arms";
	level.viewarms[7] = "viewmodel_rus_guard_padded_arms";
	level.viewarms[8] = "viewmodel_usa_marine_rolledup_arms";
	level.viewarms[9] = "viewmodel_jap_infantry_ghillie_arms";
	level.viewarms[10] = "viewmodel_rus_sniper_arms";
	
	for( i = 0; i < level.viewarms.size; i++ )
	{
		PrecacheModel( level.viewarms[i] );
	}
}

weaponslots()
{
	weaponslots = [];
	
	// US:
	weaponslots = weaponadd("m1garand", weaponslots);
	weaponslots = weaponadd("m1garand_gl", weaponslots);
	weaponslots = weaponadd("m1garand_bayonet", weaponslots);
	weaponslots = weaponadd("thompson", weaponslots);
	weaponslots = weaponadd("30cal", weaponslots);
	weaponslots = weaponadd("30cal_bipod", weaponslots);
	weaponslots = weaponadd("bar", weaponslots);
	weaponslots = weaponadd("bar_bipod", weaponslots);
	weaponslots = weaponadd("m1carbine", weaponslots);
	weaponslots = weaponadd("springfield", weaponslots);
	weaponslots = weaponadd("springfield_scoped", weaponslots);
	weaponslots = weaponadd("m7_launcher", weaponslots);
	weaponslots = weaponadd("bazooka", weaponslots);
	weaponslots = weaponadd("shotgun", weaponslots);
	weaponslots = weaponadd("doublebarrel", weaponslots);
	weaponslots = weaponadd("doublebarrel_sawed_grip", weaponslots);
	weaponslots = weaponadd("m2_flamethrower", weaponslots);
	weaponslots = weaponadd("m8_white_smoke", weaponslots);
	weaponslots = weaponadd("colt", weaponslots);
	weaponslots = weaponadd("sw_357", weaponslots);
	weaponslots = weaponadd("mk2_frag", weaponslots);
						
	// German:
	weaponslots = weaponadd("panzerschrek", weaponslots);
	weaponslots = weaponadd("stick_grenade", weaponslots);
	weaponslots = weaponadd("walther", weaponslots);
	weaponslots = weaponadd("mp40", weaponslots);
	weaponslots = weaponadd("gewehr43", weaponslots);
	weaponslots = weaponadd("stg44", weaponslots);
	weaponslots = weaponadd("mg42", weaponslots);
	weaponslots = weaponadd("mg42_bipod", weaponslots);
	weaponslots = weaponadd("fg42", weaponslots);
	weaponslots = weaponadd("fg42_bipod", weaponslots);
	weaponslots = weaponadd("fg42_scoped", weaponslots);
	weaponslots = weaponadd("kar98k", weaponslots);
	weaponslots = weaponadd("kar98k_scoped", weaponslots);
	weaponslots = weaponadd("Stielhandgranate", weaponslots);
	weaponslots = weaponadd("kar98k_bayonet", weaponslots);
			
	// Russian:
	weaponslots = weaponadd("molotov", weaponslots);
	weaponslots = weaponadd("tokarev", weaponslots);
	weaponslots = weaponadd("ppsh", weaponslots);
	weaponslots = weaponadd("dp28", weaponslots);
	weaponslots = weaponadd("dp28_bipod", weaponslots);
	weaponslots = weaponadd("svt40", weaponslots);
	weaponslots = weaponadd("mosin_launcher", weaponslots);
	weaponslots = weaponadd("mosin_rifle", weaponslots);
	weaponslots = weaponadd("mosin_rifle_scoped", weaponslots);
	weaponslots = weaponadd("mosin_rifle_bayonet", weaponslots);
	weaponslots = weaponadd("ptrs41", weaponslots);
	//weaponslots = weaponadd("russian_flag", weaponslots);\
		
	// Japanese:
	weaponslots = weaponadd("nambu", weaponslots);
	weaponslots = weaponadd("type100_smg", weaponslots);
	weaponslots = weaponadd("type99_lmg", weaponslots);
	weaponslots = weaponadd("type99_lmg_bipod", weaponslots);
	weaponslots = weaponadd("type99_rifle", weaponslots);
	weaponslots = weaponadd("type99_rifle_scoped", weaponslots);
	weaponslots = weaponadd("type97_frag", weaponslots);
	weaponslots = weaponadd("type99_rifle_bayonet", weaponslots);
		
	// Brit:
	// SRS 3/31/08: removed british weapons, snip snip
	//weaponslots = weaponadd("lee_enfield_launcher", weaponslots);
	//weaponslots = weaponadd("lee_enfield", weaponslots);
	//weaponslots = weaponadd("lee_enfield_scoped", weaponslots);
	//weaponslots = weaponadd("lee_enfield_bayonet", weaponslots);
	//weaponslots = weaponadd("sten", weaponslots);
	//weaponslots = weaponadd("bren_bipod", weaponslots);
	//weaponslots = weaponadd("bren", weaponslots);
	//weaponslots = weaponadd("no36_mills_frag", weaponslots);
		
	return weaponslots;
}


