#using scripts\codescripts\struct;

#using scripts\shared\array_shared;
#using scripts\shared\gameobjects_shared;
#using scripts\shared\util_shared;
#using scripts\shared\hud_util_shared;
#using scripts\shared\system_shared;
#using scripts\shared\lui_shared;
#using scripts\shared\flagsys_shared;

#using scripts\cp\gametypes\_loadout;
#using scripts\cp\gametypes\_save;

#using scripts\cp\sidemissions\_sm_ui_worldspace;

#using scripts\cp\_objectives;
#using scripts\cp\_oed;


	// How long the player's gun is down for when interacting with the armory.

    	   	                                                                                                                         	                                                                                                                                                                                                                                                                                                                                                                    	        	     	             	    	   	                           	                               	                                	                                                              	                                                                                                              	                            	                                     	                                       	                                                               	   	                  	       	                                                    	                   	                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                       	                                                                                        	           	                        	                                            	                                             	                                                   	                                                             	                                                         	                                                                    	                                                                                                                                                                                                    	                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                     	                                                              	                                                          	                                   	                                   	                                                    	                                       

#precache( "triggerstring", "COOP_MOBILE_ARMORY" );
#precache( "string", "COOP_SELECT_LOADOUT" );

#namespace mobile_armory;

function autoexec __init__sytem__() {     system::register("cp_mobile_armory",&__init__,&__main__,undefined);    }

function __init__()
{
		
}

function __main__()
{
	//wait for the first frame to set any client fields
	wait(0.05);

	a_mdl_mobile_armory = GetEntArray( "mobile_armory", "script_noteworthy" );		

	foreach ( mdl_mobile_armory in a_mdl_mobile_armory )
	{
		mobile_armory = new cMobileArmory();
		[[ mobile_armory ]]->init_mobile_armory( mdl_mobile_armory );
	}
	
}

class cMobileArmory
{
	constructor()
	{
	}

	destructor()
	{
	}

	function init_mobile_armory( mdl_mobile_armory )
	{
		e_trigger = Spawn( "trigger_radius_use", mdl_mobile_armory.origin + ( 0, 0, 3 ), 0, 94, 64 );
		e_trigger TriggerIgnoreTeam();
		e_trigger SetVisibleToAll();
		e_trigger SetTeamForTrigger( "none" );
		e_trigger SetCursorHint( "HINT_INTERACTIVE_PROMPT" );
		e_trigger SetHintString( &"COOP_SELECT_LOADOUT" );
		
		if( IsDefined( mdl_mobile_armory.script_linkto ) )
		{
			moving_platform = GetEnt( mdl_mobile_armory.script_linkto, "targetname" );
			mdl_mobile_armory LinkTo( moving_platform );
			e_trigger EnableLinkTo();
			e_trigger LinkTo( moving_platform );
		}	
		
		mdl_mobile_armory oed::enable_keyline( true );
				
		s_mobile_armory_object = gameobjects::create_use_object( "any", e_trigger, Array( mdl_mobile_armory ), ( 0, 0, 32 ), &"cp_mobile_armory" );
		s_mobile_armory_object gameobjects::allow_use( "any" );
		s_mobile_armory_object gameobjects::set_use_time( 0.5 ); //TODO: Do we want a use time?
		s_mobile_armory_object gameobjects::set_use_text( &"COOP_SELECT_LOADOUT" );
		s_mobile_armory_object gameobjects::set_owner_team( "allies" );
		s_mobile_armory_object gameobjects::set_visible_team( "any" );
		s_mobile_armory_object.onUse = &onUse;
		s_mobile_armory_object.onBeginUse = &onBeginUse;
		s_mobile_armory_object.useWeapon = undefined;
		s_mobile_armory_object.single_use = false;
	
		// Set origin/angles so it can be used as an objective target.
		s_mobile_armory_object.origin = mdl_mobile_armory.origin;
		s_mobile_armory_object.angles = s_mobile_armory_object.angles;
	
		if( !IsDefined( mdl_mobile_armory.script_linkto ) )
		{
			s_mobile_armory_object EnableLinkTo();
			s_mobile_armory_object LinkTo( e_trigger );
		}
		
		mdl_mobile_armory DisconnectPaths();
		
		mdl_mobile_armory.gameobject = s_mobile_armory_object;
	}
	
	function onBeginUse( e_player )
	{
		e_player PlaySound( "fly_ammo_crate_refill" ); //TODO: REPLACE SOUND
	}
	
	function onUse( e_player )
	{
		menu_id = e_player OpenMenu(game["menu_changeclass"]);
	
		e_player flagsys::set( "mobile_armory_in_use" );
		
		e_player util::_disableWeapon();
		
		e_player waittill( "menuresponse", str_menu, str_class_chosen );
		
		//save off hero weapon
		a_weaponlist = e_player GetWeaponsList();
		
		a_heroweapons = [];
		foreach( weapon in a_weaponlist )
		{
			if( ( isdefined( weapon.isheroweapon ) && weapon.isheroweapon ) )
			{
				if ( !isdefined( a_heroweapons ) ) a_heroweapons = []; else if ( !IsArray( a_heroweapons ) ) a_heroweapons = array( a_heroweapons ); a_heroweapons[a_heroweapons.size]=weapon;;
			}
		}

		if( str_menu == "ChooseClass_InGame" && str_class_chosen != "cancel" )
		{
			playerclass = e_player loadout::getClassChoice( str_class_chosen );
			
			e_player savegame::set_player_data(savegame::get_mission_name() + "_class", playerClass);
			e_player loadout::setClass( e_player.pers["class"] );
			e_player.tag_stowed_back = undefined;
			e_player.tag_stowed_hip = undefined;
			e_player loadout::giveLoadout( e_player.pers["team"], playerClass );
		}
		
		foreach( weapon in a_heroweapons )
		{
			e_player GiveWeapon( weapon );
			e_player SetWeaponAmmoClip( weapon, weapon.clipSize );
			e_player GiveMaxAmmo( weapon );
		}
	
		//HACK: need code support to get the presentation nice		
		e_player HideViewModel();
		e_player DisableWeapons( true ); //the quick flag doesn't work in unified executable
		wait 0.5; //delay for weapon to go down and enough time for it to feel like there was a beat before getting your loadout back
		e_player ShowViewModel();
		e_player util::_enableWeapon();
		//END HACK
		
		e_player CloseLUIMenu( menu_id );
		
		waittillframeend; //Do not clear the flag until _globallogic_ui has already returned from function menuClass( response )
		e_player flagsys::clear( "mobile_armory_in_use" );
	}

} // class cRaidSupplyAmmoCrate

