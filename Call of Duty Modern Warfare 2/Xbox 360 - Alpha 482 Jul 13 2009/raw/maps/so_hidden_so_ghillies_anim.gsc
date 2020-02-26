#include common_scripts\utility;
#include maps\_utility;
#include maps\_anim;

main()
{
	maps\_patrol_anims::main();
	maps\so_ghillies_anim::main();
	
	dialog();
}

dialog()
{
// RADIATION
	//Careful…there's pockets of radiation all over this area. If you absorb too much, you're a dead man.
	level.scr_radio[ "scoutsniper_mcm_deadman" ]	= "scoutsniper_mcm_deadman";
	
// STEALTH KILLS
	//Good night.
	level.scr_radio[ "scoutsniper_mcm_goodnight" ]	= "scoutsniper_mcm_goodnight";
	//Beautiful.
	level.scr_radio[ "scoutsniper_mcm_beautiful" ]	= "scoutsniper_mcm_beautiful";
	//That's how it's done, lets go.
	level.scr_radio[ "scoutsniper_mcm_howitsdone" ]	= "scoutsniper_mcm_howitsdone";

// QUIET KILLS
	//Topped him
	level.scr_radio[ "scoutsniper_mcm_toppedhim" ]	= "scoutsniper_mcm_toppedhim";
	//Got him
	level.scr_radio[ "scoutsniper_mcm_gothim" ]		= "scoutsniper_mcm_gothim";
	//Tango down
	level.scr_radio[ "scoutsniper_mcm_tangodown" ]	= "scoutsniper_mcm_tangodown";

// BASIC KILLS
	//Are you insane?
	level.scr_radio[ "scoutsniper_mcm_youinsane" ]	= "scoutsniper_mcm_youinsane";
	//Whew, that was close.
	level.scr_radio[ "scoutsniper_mcm_whew" ]		= "scoutsniper_mcm_whew";
	//He's down.
	level.scr_radio[ "scoutsniper_mcm_hesdown" ]	= "scoutsniper_mcm_hesdown";
}