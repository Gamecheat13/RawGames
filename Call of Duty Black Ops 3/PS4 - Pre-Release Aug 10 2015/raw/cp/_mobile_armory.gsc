#using scripts\codescripts\struct;

#using scripts\shared\array_shared;
#using scripts\shared\gameobjects_shared;
#using scripts\shared\util_shared;
#using scripts\shared\hud_util_shared;
#using scripts\shared\system_shared;
#using scripts\shared\lui_shared;
#using scripts\shared\flagsys_shared;
#using scripts\shared\flag_shared;
#using scripts\shared\scene_shared;
#using scripts\shared\trigger_shared;
#using scripts\shared\weapons\_weapons;

#using scripts\cp\gametypes\_loadout;
#using scripts\cp\gametypes\_save;

#using scripts\cp\sidemissions\_sm_ui_worldspace;

#using scripts\cp\_objectives;
#using scripts\cp\_oed;
#using scripts\cp\_bb;

	// How long the player's gun is down for when interacting with the armory.
	// Minimum time that the Mobile armory needs to be open before closing
	// How close the player has to be before the mobile armory starts animating (squared)


    	   	                                                                                                                                         	                                	                                                                                                                                                                                                                                                                                                                                                                    	        	     	             	    	   	               	                                              	                                                           	                               	                     	                                                                                                           	                                                                 	                                                              	                                                                                                              	                            	                                     	                                       	                                                                                                              	   	                  	       	                                                    	                   	                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                        	                                  	                                                                                        	           	                        	                                            	                                             	                                                   	                                                             	                                                         	                                                                    	                                                                                                                                                                                                    	                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                         	                                                              	                                                          	                                   	                                   	                                                    	                                       	                                           	     	                                                                                                                                                                                                                                                      	                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                     

#precache( "triggerstring", "COOP_MOBILE_ARMORY" );
#precache( "triggerstring", "COOP_SELECT_LOADOUT" );

#precache( "lui_menu_data", "isInMobileArmory" );

#namespace mobile_armory;

function autoexec __init__sytem__() {     system::register("cp_mobile_armory",&__init__,&__main__,undefined);    }

function __init__()
{
		
}

function __main__()
{
	if( ( SessionModeIsCampaignZombiesGame() ) )
	{
		return;
	}
	else
	{
		if( IsDefined(level.BZM_OnMobileArmoryCleanupCallback) )
			[[level.BZM_OnMobileArmoryCleanupCallback]]();			
	}
	
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
	var mdl_armory; 			// the script_model
	var t_armory_use; 			// the use trigger for the game object
	var b_is_animating;			// bool is if mobile armory is animating
		
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
		e_trigger UseTriggerRequireLookAt();
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
				
		s_mobile_armory_object = gameobjects::create_use_object( "any", e_trigger, Array( mdl_mobile_armory ), ( 0, 0, 52 ), &"cp_mobile_armory" );
		s_mobile_armory_object gameobjects::allow_use( "any" );
		s_mobile_armory_object gameobjects::set_use_time( 0.5 ); //TODO: Do we want a use time?
		s_mobile_armory_object gameobjects::set_use_text( &"COOP_SELECT_LOADOUT" );
		s_mobile_armory_object gameobjects::set_owner_team( "allies" );
		s_mobile_armory_object gameobjects::set_visible_team( "any" );
		s_mobile_armory_object.onUse = &onUse;
		s_mobile_armory_object.onBeginUse = &onBeginUse;
		s_mobile_armory_object.onUse_thread = true;
		s_mobile_armory_object.useWeapon = undefined;
		s_mobile_armory_object.single_use = false;
		
		s_mobile_armory_object.classObj = self;
	
		// Set origin/angles so it can be used as an objective target.
		s_mobile_armory_object.origin = mdl_mobile_armory.origin;
		s_mobile_armory_object.angles = s_mobile_armory_object.angles;
	
		if( !IsDefined( mdl_mobile_armory.script_linkto ) )
		{
			s_mobile_armory_object EnableLinkTo();
			s_mobile_armory_object LinkTo( e_trigger );
		}
		
		mdl_mobile_armory.gameobject = s_mobile_armory_object;
		
		//save off class vars
		mdl_armory = mdl_mobile_armory;
		mdl_armory.b_is_animating = false;
		t_armory_use = e_trigger;
				
		radius_trigger = Spawn( "trigger_radius", e_trigger.origin, 0, 94, 64 );
		radius_trigger SetVisibleToAll();
		radius_trigger SetTeamForTrigger( "allies" );
		radius_trigger thread animate_on_trigger( mdl_armory );
		
	}
	
	function onBeginUse( e_player )
	{
		e_player PlaySound( "fly_ammo_crate_refill" ); //TODO: REPLACE SOUND
	}
	
	function onUse( e_player )
	{
		menu_id = e_player OpenLUIMenu(game["menu_changeclass"]);
		e_player setluimenudata( menu_id, "isInMobileArmory", 1 );
	
		e_player flagsys::set( "mobile_armory_in_use" );
		
		e_player util::_disableWeapon();
		
		e_player waittill( "menuresponse", str_menu, str_class_chosen );
		
		//save off hero weapon
		a_weaponlist = e_player GetWeaponsList();
		
		//get the weapons in the players selected loadout, so we can check against the weapons the player currently has
		primary_loadout = e_player GetLoadoutWeapon( e_player.class_num , "primary" );
		secondary_loadout = e_player GetLoadoutWeapon( e_player.class_num , "secondary" );		
		
		a_heroweapons = [];
		foreach( weapon in a_weaponlist )
		{
			if( ( isdefined( weapon.isheroweapon ) && weapon.isheroweapon ) )
			{
				if ( !isdefined( a_heroweapons ) ) a_heroweapons = []; else if ( !IsArray( a_heroweapons ) ) a_heroweapons = array( a_heroweapons ); a_heroweapons[a_heroweapons.size]=weapon;;
			}
			//if player has copycat, and has a non-hero weapon that's not in their selected loadout, drop it on the ground so it can be picked up instead of vanishing
			else if( e_player HasCyberComRig( "cybercom_copycat" ) && ( weapon.inventorytype == "primary" || weapon.inventorytype == "secondary" ) && ( weapon != primary_loadout && weapon != secondary_loadout ) )
			{
				/# iPrintLn( "DROPPING COPYCAT WEAPON" ); #/
					
				e_player mobile_armory_drop_weapon( weapon );
			}
		}

		if( str_menu == "ChooseClass_InGame" && str_class_chosen != "cancel" )
		{
			playerclass = e_player loadout::getClassChoice( str_class_chosen );
			
			e_player savegame::set_player_data(savegame::get_mission_name() + "_class", playerClass);
			e_player loadout::setClass( playerclass );
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
		
		bb::logPlayerMapNotification("mobile_armory_used", e_player);
		
		waittillframeend; //Do not clear the flag until _globallogic_ui has already returned from function menuClass( response )
		e_player flagsys::clear( "mobile_armory_in_use" );
	}
	
	function mobile_armory_drop_weapon( weapon ) //self = player using mobile armory
	{
		clipAmmo = self GetWeaponAmmoClip( weapon );
		stockAmmo = self GetWeaponAmmoStock( weapon );
		
		stockMax = weapon.maxAmmo;
		if ( stockAmmo > stockMax )
		{
			stockAmmo = stockMax;
		}
		
		item = self DropItem( weapon , "tag_origin" );
	
		if ( !isdefined( item ) )
		{
			/# iprintlnbold( "dropItem: was not able to drop weapon " + weapon.name + "because it was out of ammo" ); #/
			return;
		}
	
		level weapons::drop_limited_weapon( weapon, self, item );
	
		item ItemWeaponSetAmmo( clipAmmo, stockAmmo );
	
		item.owner = self;
		
		item thread weapons::watch_pickup();
		
		item thread weapons::delete_pickup_after_aWhile();
	}
	
	function animate_on_trigger( mdl_armory )
	{
		while( true )
		{
			self waittill( "trigger", entity );
			if( !IsDefined( mdl_armory )  )
			{
				break;
			}
			if( IsPlayer( entity ) )
			{
				animate_mobile_armory( mdl_armory );
			}
		}
	}
	
	function animate_mobile_armory( mdl_armory )
	{
		if( mdl_armory.b_is_animating )
		{
			return;	//only allow 1 of these threads to run
		}
		
		mdl_armory.b_is_animating = true;
		
		mdl_armory scene::play( "p7_fxanim_gp_mobile_armory_open_bundle", mdl_armory );
		
		wait 1.0;
		
		//do not close while players are near
		num_players_near = 1;
		
		while( num_players_near > 0 )
		{
			num_players_near = 0;
			foreach( e_player in level.players )
			{
				dist_sq = DistanceSquared( e_player.origin, mdl_armory.origin );
				if( dist_sq <= 14400 + 1000 )
				{
					num_players_near++;
				}
			}
			
			wait 0.5; //do not need to cycle this every frame
		}
		
		mdl_armory scene::play( "p7_fxanim_gp_mobile_armory_close_bundle", mdl_armory );
		
		mdl_armory.b_is_animating = false;
	}
	
} // class cRaidSupplyAmmoCrate

