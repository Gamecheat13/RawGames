#include maps\_utility;
#include common_scripts\utility;
#include maps\_loadout_code;

init_loadout()
{
	if ( !IsDefined( level.campaign ) )
		level.campaign = "american";
	give_loadout();
	loadout_complete();
}

give_loadout()
{
	if( IsDefined( level.dodgeloadout ) )
		return;
    	loadout_name = get_loadout();
	level.player SetDefaultActionSlot();
	level.has_loadout = false;
	
	Campaign( "british" );
	
		 //   Levelname    PrevLoadout    secondary_offhand   
	Persist( "innocent", "london"	, "flash" );

		 //   Levelname 	   Starting_Weapon 						   Weapon2 		   Weapon3 		    Weapon4 	   Set_View_Model 		     Offhand_Secondary   
	LoadOut( "ship_graveyard", "mp5_underwater"						, undefined		, undefined		 , undefined	, "viewhands_udt"		  , undefined );
	LoadOut( "jungle_ghosts", "iw5_ak47_sp_acog_silencerunderbarrel", "fraggrenade" , undefined		 , undefined	, "viewhands_sas_woodland", undefined );
	LoadOut( "london"		, "mp5_silencer_eotech"					, "fraggrenade" , "flash_grenade", undefined	, "viewhands_sas"		  , "flash" );
	LoadOut( "innocent"		, "mp5_silencer_eotech"					, "usp_silencer", "flash_grenade", "fraggrenade", "viewhands_sas"		  , "flash" );
	
	Campaign( "delta" );
	
	//   Levelname    	Starting_Weapon 		    Weapon2 	    Weapon3 	     Weapon4 	    Set_View_Model 			    Offhand_Secondary   
	LoadOut( "berlin"	, "m14ebr_scope"	 , "acr_hybrid_berlin" , "fraggrenade", "ninebang_grenade", "viewhands_delta"		 , "flash" );
	LoadOut( "ny_harbor"	, "mp5_silencer_reflex"	 , "usp_no_knife" , "fraggrenade", "ninebang_grenade", "viewhands_udt"		 , "flash" );
	LoadOut( "hamburg"	, "m4m203_acog_payback"	 , "smaw_nolock" , "flash_grenade", "fraggrenade", "viewhands_delta"		 , "flash" );
	LoadOut( "prague"	, "rsass_hybrid_silenced", "usp_silencer", "flash_grenade", "fraggrenade", "viewhands_yuri_europe"	 , "flash" );
	LoadOut( "payback"	, "m4m203_acog_payback"	 , "deserteagle" , "flash_grenade", "fraggrenade", "viewhands_yuri"			 , "flash" );
	LoadOut( "black_ice", "m4_grunt_reflex", "ksg_grip", "flash_grenade", "fraggrenade", "viewmodel_base_viewhands", "flash" );
	
	
	Campaign( "xslice" );
	
	//			Levelname		PrevLoadout		secondary_offhand
	Persist( 	"sanfran_b", 	"sanfran", 		"flash" );
	
	//   	Levelname    Starting_Weapon 		    		 Weapon2 	   Weapon3 	     Weapon4 	    Set_View_Model 		Offhand_Secondary   
	LoadOut( "fusion", "iw5_m160_sp_deam160_variablereddot", undefined, "fraggrenade", "flash_grenade", "viewhands_s1_pmc", "flash" );
	LoadOut( "sanfran", "iw5_bal27_sp_variablereddot", "iw5_microdronelauncher_sp", "flash_grenade", "fraggrenade", "viewhands_sentinel", "flash" );
	LoadOut( "sanfran_b", "iw5_bal27_sp_variablereddot", "iw5_microdronelauncher_sp", "flash_grenade", "fraggrenade", "viewhands_sentinel", "flash" );
	LoadOut( "lab", "freerunner", undefined, "fraggrenade", "flash_grenade", "viewhands_s1_pmc", "flash" );
	
	default_loadout_if_notset();
}
