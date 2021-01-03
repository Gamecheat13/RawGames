#using scripts\codescripts\struct;

#using scripts\shared\array_shared;
#using scripts\shared\clientfield_shared;
#using scripts\shared\gameobjects_shared;
#using scripts\shared\util_shared;
#using scripts\shared\hud_util_shared;
#using scripts\shared\system_shared;
#using scripts\shared\lui_shared;
#using scripts\shared\flagsys_shared;
#using scripts\shared\flag_shared;
#using scripts\shared\scene_shared;
#using scripts\shared\weapons_shared;
#using scripts\shared\killstreaks_shared;

#using scripts\cp\gametypes\_loadout;
#using scripts\cp\gametypes\_save;
#using scripts\cp\_objectives;
#using scripts\cp\_oed;
#using scripts\cp\_util;

#using scripts\cp\bonuszm\_bonuszm_dev;
#using scripts\cp\bonuszm\_bonuszm_data;
#using scripts\cp\bonuszm\_bonuszm_spawner_shared;
#using scripts\cp\bonuszm\_bonuszm_weapons;

                                                                          	                                         	   	     	    	     	   		   	                                                                       	                                                                                    	        	                                                                          	    	         	           		       	                                                                                                                                                                    	   	                 	   	                                 	          	                          	              	                        	                        	                    	                      	                                                                        	
    	   	                                                                                                                                         	                                	                                                                                                                                                                                                                                                                                                                                                                    	        	     	             	    	   	               	                                              	                                                           	                               	                     	                                                                                                           	                                                                 	                                                              	                                                                                                              	                            	                                     	                                       	                                                                                                              	   	                  	       	                                                    	                   	                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                        	                                  	                                                                                        	           	                        	                                            	                                             	                                                   	                                                             	                                                         	                                                                    	                                                                                                                                                                                                    	                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                         	                                                              	                                                          	                                   	                                   	                                                    	                                       	                                           	     	                                                                                                                                                                                                                                                      	                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                     
                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                            	                           	                           	                                                                                                                                                                                                                                                            	                                                                                                                                                                                                                                                                                                                                                                                       

#namespace bonuszm;






		


	

#precache( "model", "p6_anim_zm_magic_box" );	
#precache( "weapon", "tesla_gun_cp" );	
#precache( "weapon", "ray_gun_cp" );	

#precache( "triggerstring", "COOP_MAGICBOX" );
#precache( "triggerstring", "COOP_MAGICBOX_SWAP_WEAPON" );
#precache( "triggerstring", "COOP_OPEN" );
#precache( "objective", "cp_magic_box" );

function autoexec __init__sytem__() {     system::register("cp_mobile_magicbox",&__init__,&__main__,undefined);    }
	
function __init__()
{
	level.BZM_OnMobileArmoryCleanupCallback = &DeleteMagicBoxesForNonBZMMode;
		
	if( !( SessionModeIsCampaignZombiesGame() ) )
		return;
		
	clientfield::register( "zbarrier", "magicbox_open_glow", 1, 1, "int" );
	clientfield::register( "zbarrier", "magicbox_closed_glow", 1, 1, "int" );
	//clientfield::register( "scriptmover", "magicbox_weapon_fx", VERSION_SHIP, 1, "int" );
}

function __main__()
{
	if( !( SessionModeIsCampaignZombiesGame() ) )
		return;
	
	wait(0.05);
	
	a_mdl_mobile_armory = GetEntArray( "mobile_armory", "script_noteworthy" );

	foreach ( mdl_mobile_armory in a_mdl_mobile_armory )
	{
		mdl_mobile_armory thread InitMagicBox(mdl_mobile_armory);
	}	
}

function InitMagicBox(mdl_mobile_armory)
{	
	mobile_magicbox = new cMobileMagicBox();
	[[ mobile_magicbox ]]->init_mobile_magicbox( mdl_mobile_armory );
}

function DeleteMagicBoxesForNonBZMMode()
{
	magicBoxes = GetEntArray( "bonuszm_magicbox", "script_noteworthy" );
	
	foreach( magicBox in magicBoxes )
	{
		magicBox Delete();
	}
}

class cMobileMagicBox
{
	var mdl_magicbox; 			// the script_model
	var t_armory_use; 		// the use trigger for the game object
	var b_is_magicbox_open;
	var zBarrierMagicBox;
	
	constructor()
	{
		b_is_magicbox_open = false;
	}

	destructor()
	{
	}

	function init_mobile_magicbox( mdl_mobile_armory )
	{
		e_trigger = Spawn( "trigger_radius_use", mdl_mobile_armory.origin + ( 0, 0, 3 ), 0, 94, 64 );
		e_trigger TriggerIgnoreTeam();
		e_trigger SetVisibleToAll();
		e_trigger UseTriggerRequireLookAt();
		e_trigger SetTeamForTrigger( "none" );
		e_trigger SetCursorHint( "HINT_INTERACTIVE_PROMPT" );
		e_trigger SetHintString( &"COOP_MAGICBOX" );
				
		// Get closest zbarrier magic box and assign it
		zBarrierArray = GetEntArray( "bonuszm_magicbox", "script_noteworthy" );
		zBarrierMagicbox = ArrayGetClosest( e_trigger.origin, zBarrierArray );
		zBarrierMagicbox.origin = mdl_mobile_armory.origin;	
		zBarrierMagicbox.angles = mdl_mobile_armory.angles;
		zBarrierMagicbox HideZBarrierPiece(1);
		
		if( IsDefined( mdl_mobile_armory.script_linkto ) )
		{
			moving_platform = GetEnt( mdl_mobile_armory.script_linkto, "targetname" );
			mdl_mobile_armory LinkTo( moving_platform );
			zBarrierMagicbox LinkTo( moving_platform );
			e_trigger EnableLinkTo();
			e_trigger LinkTo( moving_platform );
		}	
		
		//s_mobile_armory_object = gameobjects::create_use_object( "any", e_trigger, Array( mdl_mobile_armory ), ( 0, 0, 32 ), &"cp_magic_box" );			
		
		s_mobile_armory_object = util::init_interactive_gameobject( e_trigger, &"cp_magic_box", &"COOP_OPEN", &onUse );
		s_mobile_armory_object.classObj = self;
		
		if( !IsDefined( mdl_mobile_armory.script_linkto ) )
		{
			s_mobile_armory_object EnableLinkTo();
			s_mobile_armory_object LinkTo( e_trigger );
		}		
		
		mdl_mobile_armory.gameobject = s_mobile_armory_object;		
		
		//save off class vars
		mdl_magicbox = mdl_mobile_armory;
		t_armory_use = e_trigger;	
				
		zBarrierMagicbox HideZBarrierPiece(0);
		
		zBarrierMagicbox clientfield::set( "magicbox_closed_glow", true );
		zBarrierMagicbox clientfield::set( "magicbox_open_glow", false );
		
		zBarrierMagicbox PlayLoopSound( "zmb_box_zcamp_loop" );
		
		// Hide the original armory box
		mdl_magicbox Ghost();		
	}
	
	function onUse( e_player )
	{
		if( !b_is_magicbox_open )
		{
			self thread open_mobile_magicbox(e_player);
		}
		else
		{
			e_player thread magic_box_process_weapon_take( zBarrierMagicbox.weapon_take_trigger, zBarrierMagicbox.weaponInfo, e_player );
		}
	}
	
	function onBeginUse( e_player )
	{
		
	}

	function open_mobile_magicbox(e_player)
	{
		if( b_is_magicbox_open )
		{
			return;	//only allow 1 of these threads to run
		}
		
		// Hide the Magicbox icon
		mdl_magicbox.gameobject gameobjects::disable_object( true );
		
		b_is_magicbox_open = true;
		
		zBarrierMagicbox clientfield::set( "magicbox_closed_glow", false );
		zBarrierMagicbox clientfield::set( "magicbox_open_glow", true );
						
		weaponInfo = magic_box_weapon_spawn(e_player);
		
		weapon_take_trigger = Spawn( "trigger_radius_use", mdl_magicbox.origin + ( 0, 0, 3 ), 0, 94, 64 );
		weapon_take_trigger TriggerIgnoreTeam();
		weapon_take_trigger SetVisibleToAll();
		weapon_take_trigger UseTriggerRequireLookAt();
		weapon_take_trigger SetTeamForTrigger( "none" );
		weapon_take_trigger SetCursorHint( "HINT_INTERACTIVE_PROMPT" );
		weapon_take_trigger SetHintString( &"COOP_MAGICBOX_SWAP_WEAPON" );
		
		zBarrierMagicbox.weapon_take_trigger = weapon_take_trigger;
		
		s_mobile_weapon_object = util::init_interactive_gameobject( weapon_take_trigger, &"cp_magic_box", &"COOP_MAGICBOX_SWAP_WEAPON", &onUse );
		s_mobile_weapon_object.classObj = self;
		s_mobile_weapon_object EnableLinkTo();
		s_mobile_weapon_object LinkTo( weapon_take_trigger );
				
		weapon_take_trigger util::waittill_any_timeout( 6, "player_took_weapon" );

		s_mobile_weapon_object gameobjects::destroy_object( false, true );
		
		weapon_take_trigger notify("close_magic_box");
		weapon_take_trigger Delete();
			
		self thread MagicBoxClose();
				
		zBarrierMagicbox waittill("closed");	
		
		zBarrierMagicbox clientfield::set( "magicbox_closed_glow", true );
		zBarrierMagicbox clientfield::set( "magicbox_open_glow", false );
		
		// Show the Magicbox icon again
		mdl_magicbox.gameobject gameobjects::enable_object( true );
				
		b_is_magicbox_open = false;
	}

	function magic_box_process_weapon_take(weapon_take_trigger, weaponInfo, e_player)
	{ 
		assert( IsDefined( weaponInfo ) );
					
		e_player bonuszmdrops::BZM_GivePlayerWeapon( weaponInfo );
				
		weapon_take_trigger notify("player_took_weapon");
	}

	function magic_box_weapon_spawn(e_player)
	{
		const FLOAT_HEIGHT = 40;
		weapon = level.weaponNone;
		modelname = undefined; 
		rand = undefined; 
		number_cycles = 40;
		
		self thread MagicBoxDoWeaponRise();
		
		for( i = 0; i < number_cycles; i++ )
		{
		
			if( i < 20 )
			{
				{wait(.05);}; 
			}
			else if( i < 30 )
			{
				wait( 0.1 ); 
			}
			else if( i < 35 )
			{
				wait( 0.2 ); 
			}
			else if( i < 38 )
			{
				wait( 0.3 ); 
			}
		}
		
		wait 1;
		
		zBarrierMagicbox.weaponInfo = MagicBoxChooseRandomWeapon();
					
		v_float = AnglesToUp( zBarrierMagicbox.angles ) * FLOAT_HEIGHT;  // draw vector straight up with reference to the mystery box angles
		zBarrierMagicbox.weapon_model = spawn( "script_model", zBarrierMagicbox.origin + v_float, 0 );
		zBarrierMagicbox.weapon_model.angles = (-zBarrierMagicbox.angles[0], zBarrierMagicbox.angles[1] + 180, -zBarrierMagicbox.angles[2]);
		zBarrierMagicbox.weapon_model useweaponmodel( zBarrierMagicbox.weaponInfo[0], zBarrierMagicbox.weaponInfo[0].worldModel );
		
		zBarrierMagicbox.weapon_model SetWeaponRenderOptions( zBarrierMagicbox.weaponInfo[2], 0, 0, 0, 0 );
		
		zBarrierMagicbox notify( "randomization_done" );
	}
	
	function MagicBoxChooseRandomWeapon()
	{
		weaponInfo = bonuszmdrops::BZM_GetRandomWeaponFromTable( true );
		return weaponInfo;
	}
	
	function MagicBoxDoWeaponRise()
	{
		zBarrierMagicbox SetZBarrierPieceState(2, "opening");
		while(zBarrierMagicbox GetZBarrierPieceState(2) != "open")
		{
			wait (0.1);
		}
		
		zBarrierMagicbox SetZBarrierPieceState(3, "closed");
		zBarrierMagicbox SetZBarrierPieceState(4, "closed");
		
		util::wait_network_frame();
		
		zBarrierMagicbox ZBarrierPieceUseBoxRiseLogic(3);
		zBarrierMagicbox ZBarrierPieceUseBoxRiseLogic(4);
		
		zBarrierMagicbox ShowZBarrierPiece(3);
		zBarrierMagicbox ShowZBarrierPiece(4);
		zBarrierMagicbox SetZBarrierPieceState(3, "opening");
		zBarrierMagicbox SetZBarrierPieceState(4, "opening");
		
		while(zBarrierMagicbox GetZBarrierPieceState(3) != "open")
		{
			wait(0.5);
		}
		
		zBarrierMagicbox HideZBarrierPiece(3);
		zBarrierMagicbox HideZBarrierPiece(4);
	}
	
	function MagicBoxClose()
	{
		zBarrierMagicbox.weapon_model Delete();		
		
		wait 1;
		
		zBarrierMagicbox SetZBarrierPieceState(2, "closing");
		while(zBarrierMagicbox GetZBarrierPieceState(2) == "closing")
		{
			wait (0.1);
		}
		zBarrierMagicbox notify("closed");		
	}
} 
