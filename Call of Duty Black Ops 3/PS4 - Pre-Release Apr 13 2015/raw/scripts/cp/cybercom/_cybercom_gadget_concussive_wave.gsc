#using scripts\codescripts\struct;

#using scripts\shared\callbacks_shared;
#using scripts\shared\clientfield_shared;
#using scripts\shared\flagsys_shared;
#using scripts\shared\spawner_shared;
#using scripts\shared\util_shared;

                                                                                                                                                     
#using scripts\shared\abilities\_ability_player;
#using scripts\shared\abilities\_ability_util;
    	   	                                                                                                                         	                                                                                                                                                                                                                                                                                                                                                                    	        	     	             	    	   	                           	                               	                                	                                                              	                                                                                                              	                            	                                     	                                       	                                                               	   	                  	       	                                                    	                   	                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                       	                                                                                        	           	                        	                                            	                                             	                                                   	                                                             	                                                         	                                                                    	                                                                                                                                                                                                    	                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                     	                                                              	                                                          	                                   	                                   	                                                    	                                       
                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                            	                                                                                                                                                                                                                                                                                                                                                                                       
#using scripts\shared\system_shared;
#using scripts\shared\ai_shared;
#using scripts\shared\ai\systems\gib;

                                                                                                      	                       	     	                                                                     
#using scripts\cp\cybercom\_cybercom;
#using scripts\cp\cybercom\_cybercom_util;
#using scripts\cp\cybercom\_cybercom_gadget;








#namespace cybercom_gadget_concussive_wave;

#precache( "fx", "weapon/fx_ability_concussive_wave_impact");


function init()
{
}

function main()
{
	cybercom_gadget::registerAbility(1, (1<<2));

	level._effect["concussive_wave"]			= "weapon/fx_ability_concussive_wave_impact";

	level.cybercom.concussive_wave = spawnstruct();
	level.cybercom.concussive_wave._is_flickering 	= &_is_flickering;
	level.cybercom.concussive_wave._on_flicker 		= &_on_flicker;
	level.cybercom.concussive_wave._on_give 		= &_on_give;
	level.cybercom.concussive_wave._on_take 		= &_on_take;
	level.cybercom.concussive_wave._on_connect 		= &_on_connect;
	level.cybercom.concussive_wave._on 				= &_on;
	level.cybercom.concussive_wave._off		 		= &_off;
	level.cybercom.concussive_wave._is_primed 		= &_is_primed;
}

function _is_flickering( slot )
{
	// returns true when the gadget is flickering
}

function _on_flicker( slot, weapon )
{
	// excuted when the gadget flickers
}

function _on_give( slot, weapon )
{
	self.cybercom.weapon 						= weapon;
	// executed when gadget is added to the players inventory
	self.cybercom.concussive_wave_radius 		= GetDvarInt( "scr_concussive_wave_radius", 190 );
	self.cybercom.concussive_wave_damage		= GetDvarInt( "scr_concussive_wave_dmg_radius", 25 );

	if(self hasCyberComAbility("cybercom_concussive")  == 2)
	{
		self.cybercom.concussive_wave_radius 		= GetDvarInt( "scr_concussive_wave_upg_radius", 190 );
		self.cybercom.concussive_wave_damage		= GetDvarInt( "scr_concussive_wave_upg_dmg_radius", 300 );
	
		self.cybercom.spikeWeapon	 = GetWeapon("hero_gravityspikes_cybercom");
	}
	
	// Enemies within this range will take damage from the blast.
	self.cybercom.concussive_wave_dmg_radius 	= GetDvarInt( "scr_concussive_wave_dmg_radius",  105);
	
	// Damage taken just from being knocked down
	self.cybercom.concussive_wave_knockdown_damage	= 5;
	
}



function _on_take( slot, weapon )
{
	// executed when gadget is removed from the players inventory
	self.cybercom.weapon		= undefined;
	self.cybercom.spikeWeapon	= undefined;
}
	
//self is the player
function _on_connect()
{
	// setup up stuff on player connect	
}

function _on( slot, weapon )
{
	// excecutes when the gadget is turned on
	self playrumbleonentity( "grenade_rumble" );
	earthquake( 0.6, .5, self.origin, 256 );
	self notify(weapon.name+"_fired");
	level notify(weapon.name+"_fired");
	self thread create_concussion_wave(self.cybercom.concussive_wave_damage);
}

function _off( slot, weapon )
{
	// excecutes when the gadget is turned off`
}

function _is_primed( slot, weapon )
{
	//self thread gadget_flashback_start( slot, weapon );
}
///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
#using_animtree( "generic" );
function ai_activateConcussiveWave(damage)
{
	if(self.a.pose =="stand")
		type = "stn";
	else
		type = "crc";

	self OrientMode( "face default" );
	self AnimScripted( "ai_cybercom_anim", self.origin, self.angles, "ai_base_rifle_"+type+"_exposed_cybercom_activate" );		
	self waittillmatch( "ai_cybercom_anim", "fire" );

	self create_concussion_wave(damage);
}
///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
function private _is_good_target(target)
{

    if( IsActor( target ) && target IsInScriptedState() )
		return false;
	
	if( target cybercom::cybercom_AICheckOptOut("cybercom_concussive"))
		return false;

	if ( ( isdefined( target.usingvehicle ) && target.usingvehicle ))
		return false;
		
	return true;
}

///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
function is_jumping()
{
	// checking PMF_JUMPING in code would give more accurate results
	ground_ent = self GetGroundEnt();
	return (!isdefined(ground_ent));
}
///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
	
function create_damage_wave(damage)
{
	
	enemies = ArrayCombine(GetAISpeciesArray( "axis", "all" ),GetAISpeciesArray( "team3", "all" ),false,false);
	//closeTargets = cybercom::getArrayItemsWithin(self.origin,enemies,SQR(self.cybercom.concussive_wave_radius));
	weapon = GetWeapon("gadget_concussive_wave");
	
	if(!isDefined(damage))
		damage = GetDvarInt( "scr_concussive_wave_dmg_radius", 25 );
	
	// Play FX regardless of if targets are affected.
	PlayFx(level._effect["concussive_wave"]	,self.origin);

	// Determine which enemies are close enough to knock down.
	// Also determine which enemies are close enough to do damage to.
	if (isDefineD(enemies) && enemies.size )
	{
		foreach (enemy in enemies)
		{
			if (!isDefined(enemy) || !isDefined(enemy.origin) )
			{
				continue;
			}
			
			// Ensure target validity.
			if ( !cybercom::targetIsValid(enemy) || !_is_good_target(enemy) )
				continue;
			
			
			distsq = distanceSquared( enemy.origin, self.origin );
			
			// Is this enemy close enough to damage?
			if ( distsq < ( (self.cybercom.concussive_wave_dmg_radius) * (self.cybercom.concussive_wave_dmg_radius) ))
			{
				// Apply damage to a close enemy.
				enemy DoDamage(damage, self.origin, undefined, undefined, "none", "MOD_RIFLE_BULLET", 0, weapon,-1,true);
			}
			else
			{
				// Not close enough to damage, are we at least close enough to knock over?	
				if ( distsq < ( (self.cybercom.concussive_wave_radius) * (self.cybercom.concussive_wave_radius) ))
				{
					// Knock over humans. Take the legs off robots.
					if(enemy.archetype=="human")
						enemy DoDamage(self.cybercom.concussive_wave_knockdown_damage, self.origin, undefined, undefined, "none", "MOD_RIFLE_BULLET", 0, weapon,-1, true);
					else
					if (enemy.archetype =="robot")
					{
						playfxontag(level._effect["servo_shortout_legs"],enemy, "J_SpineLower");
						enemy ai::set_behavior_attribute( "force_crawler", "gib_legs" );
					}
					else
					if(enemy.archetype == "zombie")
					{//gib something? kill it? 
						enemy DoDamage(int(enemy.maxhealth*.75), enemy.origin, undefined, undefined, (RandomInt(100)>50?"right_leg_lower":"left_leg_lower"), "MOD_EXPLOSIVE", 0, GetWeapon( "frag_grenade" ),-1, true);
						
						/*						
                        if( !util::is_mature() || util::is_german_build()  )
                            continue; 
                                    
                        enemy.has_legs = false;
                        enemy.missingLegs = true;
                        enemy AllowedStances( "crouch" ); 
                        enemy setPhysParams( 15, 0, 24 );// reduce collbox so player can jump over
                        enemy AllowPitchAngle( 1 );
                        enemy setPitchOrient();
                        GibServerUtils::GibLegs( enemy );
						*/						
					}
				}
			}
		}
	}	
}
function create_concussion_wave(damage)
{
	self notify("create_concussion_wave");
	self endon("create_concussion_wave");
	
	if(self hasCyberComAbility("cybercom_concussive")  == 2)
	{
		self GiveWeapon(self.cybercom.spikeWeapon);
		self SetWeaponAmmoClip( self.cybercom.spikeWeapon, 1 );
		while(self is_jumping()==false)
			{wait(.05);};
		util::wait_network_frame();
		self TakeWeapon(self.cybercom.spikeWeapon);
		while(self is_jumping()==true)
			{wait(.05);};
	}
	
	self thread create_damage_wave(damage);
}	

/*
	weapons = self GetWeaponsList();
 
		self.cybercom.clipAmmo 		 = self GetWeaponAmmoClip( self.cybercom.restoreWeapon );
		self TakeWeapon(self.cybercom.restoreWeapon);
		
	weapons = self GetWeaponsList();
		self GiveWeapon(self.cybercom.restoreWeapon);
		self SetWeaponAmmoClip( self.cybercom.restoreWeapon,self.cybercom.clipAmmo  );
		
*/