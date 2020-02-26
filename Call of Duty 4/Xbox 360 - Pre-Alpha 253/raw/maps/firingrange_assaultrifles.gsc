#include maps\_utility;
#include maps\firingrange_share;
#include common_scripts\utility;

main()
{
	maps\createart\bog_b_art::main();
	maps\_load::main();
	
	animated_model_setup();
	level.weaponslotsthread = ::weaponslots;

	level.player giveWeapon("m16_basic");
	level.player giveWeapon("m4_grenadier");
	level.player giveWeapon("fraggrenade");
	level.player giveWeapon("flash_grenade");
	level.player switchtoWeapon("m16_basic");
	level.player setOffhandSecondaryClass( "flash" );
	level.player giveWeapon("claymore");
	level.player SetActionSlot( 3, "weapon" , "claymore" );
	level.player setViewmodel( "viewmodel_base_viewhands" );
				
	init();
	
	setExpFog(800, 6000, 0.627076, 0.611153, 0.5, 0);
	
	level.dofDefault["nearStart"] = 0;
	level.dofDefault["nearEnd"] = 0;
	level.dofDefault["farStart"] = 5000;
	level.dofDefault["farEnd"] = 12000;
	level.dofDefault["nearBlur"] = 5.62756;
	level.dofDefault["farBlur"] = 1.15985;

	
}

weaponslots()
{
	weaponslots = [];
	weaponslots = weaponadd("ak47",weaponslots);
	//weaponslots = weaponadd("gp25",weaponslots);
	weaponslots = weaponadd("ak74u",weaponslots);
	weaponslots = weaponadd("g36c",weaponslots);
	weaponslots = weaponadd("m16_basic",weaponslots);
	weaponslots = weaponadd("m16_grenadier",weaponslots);
	weaponslots = weaponadd("m4_grunt",weaponslots);
	weaponslots = weaponadd("m4_grenadier",weaponslots);
	weaponslots = weaponadd("g3",weaponslots);
	//weaponslots = weaponadd("m203_m4",weaponslots);
	//weaponslots = weaponadd("m203",weaponslots);
	weaponslots = weaponadd("m4m203_silencer",weaponslots);
	//weaponslots = weaponadd("c4",weaponslots);
	//weaponslots = weaponadd("claymore",weaponslots);
	//weaponslots = weaponadd("claymore2",weaponslots);
	weaponslots = weaponadd("m4_silencer",weaponslots);
	weaponslots = weaponadd("ak47_grenadier",weaponslots);
	//weaponslots = weaponadd("m203_m4_silencer",weaponslots);
	
	weaponslots = weaponadd("saw",weaponslots);
	weaponslots = weaponadd("rpd",weaponslots);
	weaponslots = weaponadd("at4",weaponslots);
	weaponslots = weaponadd("winchester1200",weaponslots);
	weaponslots = weaponadd("rpg",weaponslots);
	weaponslots = weaponadd("mp5",weaponslots);
	weaponslots = weaponadd("beretta",weaponslots);
	weaponslots = weaponadd("dragunov",weaponslots);
	weaponslots = weaponadd("m14_scoped",weaponslots);
	weaponslots = weaponadd("m40a3",weaponslots);
	weaponslots = weaponadd("usp",weaponslots);
	weaponslots = weaponadd("uzi",weaponslots);
	weaponslots = weaponadd("skorpion",weaponslots);
	weaponslots = weaponadd("m60e4",weaponslots);
	weaponslots = weaponadd("c4",weaponslots);
	weaponslots = weaponadd("claymore",weaponslots);
	weaponslots = weaponadd("claymore2",weaponslots);
	weaponslots = weaponadd("mp5_silencer",weaponslots);
	weaponslots = weaponadd("colt45",weaponslots);
	weaponslots = weaponadd("m1014",weaponslots);
	return weaponslots;
}

#using_animtree( "animated_props" );
animated_model_setup()
{
	level.anim_prop_models[ "foliage_tree_palm_med_2" ][ "still" ] = %palmtree_med2_still;
	level.anim_prop_models[ "foliage_tree_palm_med_2" ][ "strong" ] = %palmtree_med2_sway;
	level.anim_prop_models[ "foliage_tree_palm_bushy_3" ][ "still" ] = %palmtree_bushy3_still;
	level.anim_prop_models[ "foliage_tree_palm_bushy_3" ][ "strong" ] = %palmtree_bushy3_sway;
	level.anim_prop_models[ "foliage_tree_palm_bushy_2" ][ "still" ] = %palmtree_bushy2_still;
	level.anim_prop_models[ "foliage_tree_palm_bushy_2" ][ "strong" ] = %palmtree_bushy2_sway;
	level.anim_prop_models[ "foliage_tree_palm_med_1" ][ "still" ] = %palmtree_med1_still;
	level.anim_prop_models[ "foliage_tree_palm_med_1" ][ "strong" ] = %palmtree_med1_sway;
}