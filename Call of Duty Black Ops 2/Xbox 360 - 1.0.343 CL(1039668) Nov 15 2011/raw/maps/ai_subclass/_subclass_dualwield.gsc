#include maps\_utility; 
#include common_scripts\utility; 
#include animscripts\combat_utility; 
#include animscripts\utility; 
#include animscripts\ai_subclass\anims_table_dualwield; 

subclass_dualwield()
{
	if ( self.type != "human" )
		return;

	// check allowed weapons for dualwield
	self.a.fakePistolWeaponAnims = true; // this is a hack so that weaponAnims() returns pistol for dualwield AI, even when level is not using pistol animations
	if( WeaponAnims() != "pistol" )
	{
		AssertMsg( self.weapon + " is not supported for dualwielding AI type." );
		return;
	}	
	
	// tweak attributes
	self.maxfaceenemydist = 256; // tactical walk at very very close distances from the enemy
	self.noHeatAnims = true;
	self allowedStances( "stand" );
	self.a.runOnlyReact		  = true;
	self.a.disableLongDeath   = true;
	self.grenadeawareness     = 0;
	self.badplaceawareness    = 0;
	self.ignoreSuppression    = true; 	
	self.suppressionThreshold = 1; 
	self.grenadeAmmo		  = 0;
	self.a.disableReacquire   = true;
	self.dontMelee 			  = true;
	self.a.allow_sideArm 	  = false;
	self.a.dontSwitchToPrimaryBeforeMoving = true;
	self.combatMode = "exposed_nodes_only";
	self.usecombatscriptatcover = 1;
	
	// setup fake dual wield guns
	self.leftGunModel = Spawn("script_model", self.origin);
	self.leftGunModel SetModel( GetWeaponModel( self.weapon ) );
	self.leftGunModel UseWeaponHideTags( self.weapon );
	self.leftGunModel LinkTo( self, "tag_weapon_left", (0,0,0), (0,0,0) );
	/#recordEnt( self.leftGunModel );#/

	self.rightGunModel = Spawn("script_model", self.origin);
	self.rightGunModel SetModel( GetWeaponModel( self.weapon ) );
	self.rightGunModel UseWeaponHideTags( self.weapon );
	self.rightGunModel LinkTo( self, "tag_weapon_right", (0,0,0), (0,0,0) );
	/#recordEnt( self.rightGunModel );#/	
	self.rightGunModel Hide();
	
	self.secondGunHand	= "left";

	self thread dualWeaponDropLogic();
	self thread fakeDualWieldShooting();
	self thread deleteFakeWeaponsOnDeath();	

	setup_dualwield_anim_array();
}

fakeDualWieldShooting()
{
	self endon("death");

	while(1)
	{
		self waittill("shoot");

		if( self.secondGunHand == "left" )
		{
			self animscripts\shared::placeWeaponOn( self.weapon, "left" );

			self.leftGunModel Hide();
			self.rightGunModel Show();

			self.secondGunHand = "right";
		}
		else
		{
			self animscripts\shared::placeWeaponOn( self.weapon, "right" );

			self.leftGunModel Show();
			self.rightGunModel Hide();

			self.secondGunHand = "left";
		}
	}
}

deleteFakeWeaponsOnDeath()
{
	self waittill("death");

	self.leftGunModel Delete();
	self.rightGunModel Delete();
}

dualWeaponDropLogic()
{
	dualWeaponName = "";

	switch( self.weapon )
	{
		case "makarov_sp":
			dualWeaponName = "makarovdw_sp";
			break;

		case "cz75_sp":
			dualWeaponName = "cz75dw_sp";
			break;

		case "cz75_auto_sp":
			dualWeaponName = "cz75dw_auto_sp";
			break;

		case "python_sp":
			dualWeaponName = "pythondw_sp";
			break;

		case "m1911_sp":
			dualWeaponName = "m1911dw_sp";
			break;
	}

	if( IsAssetLoaded("weapon", dualWeaponName) )
	{
		self.script_dropweapon = dualWeaponName;
	}
}

