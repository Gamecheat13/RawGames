#using scripts\codescripts\struct;

#using scripts\shared\callbacks_shared;
#using scripts\shared\clientfield_shared;
#using scripts\shared\flag_shared;
#using scripts\shared\flagsys_shared;
#using scripts\shared\system_shared;
#using scripts\shared\util_shared;
#using scripts\shared\weapons\_weaponobjects;

#using scripts\shared\abilities\_ability_player;
#using scripts\shared\abilities\_ability_power;
#using scripts\shared\abilities\_ability_util;

    	   	                                                                                                                                         	                                	                                                                                                                                                                                                                                                                                                                                                                    	        	     	             	    	   	               	                                              	                                                           	                               	                     	                                                                                                           	                                                                 	                                                              	                                                                                                              	                            	                                     	                                       	                                                                                                              	   	                  	       	                                                    	                   	                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                        	                                  	                                                                                        	           	                        	                                            	                                             	                                                   	                                                             	                                                         	                                                                    	                                                                                                                                                                                                    	                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                         	                                                              	                                                          	                                   	                                   	                                                    	                                       	                                           	     	                                                                                                                                                                                                                                                      	                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                     
                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                            	                           	                           	                                                                                                                                                                                                                                                            	                                                                                                                                                                                                                                                                                                                                                                                       
                                                                                                                                                                                     	   	                                                                      	  	  	







#namespace armor;

function autoexec __init__sytem__() {     system::register("gadget_armor",&__init__,undefined,undefined);    }

function __init__()
{
	ability_player::register_gadget_activation_callbacks( 4, &gadget_armor_on, &gadget_armor_off );
	ability_player::register_gadget_possession_callbacks( 4, &gadget_armor_on_give, &gadget_armor_on_take );
	ability_player::register_gadget_flicker_callbacks( 4, &gadget_armor_on_flicker );
	ability_player::register_gadget_is_inuse_callbacks( 4, &gadget_armor_is_inuse );
	ability_player::register_gadget_is_flickering_callbacks( 4, &gadget_armor_is_flickering );
	
	clientfield::register( "allplayers", "armor_status" , 1, 5, "int" );
	
	callback::on_connect( &gadget_armor_on_connect );
}

function gadget_armor_is_inuse( slot )
{
	// returns true when local script gadget state is on
	return self GadgetIsActive( slot );
}

function gadget_armor_is_flickering( slot )
{
	// returns true when local script gadget state is flickering
	return self GadgetFlickering( slot );
}

function gadget_armor_on_flicker( slot, weapon )
{
	// excuted when the gadget flickers
	self thread gadget_armor_flicker( slot, weapon );	
}

function gadget_armor_on_give( slot, weapon )
{
	// executed when gadget is added to the players inventory

	self clientfield::set( "armor_status", 0 );
	
	self._gadget_armor_slot = slot;
	self._gadget_armor_weapon = weapon;
}

function gadget_armor_on_take( slot, weapon )
{
	// executed when gadget is removed from the players inventory
	
	self gadget_armor_off( slot, weapon );
}

//self is the player
function gadget_armor_on_connect()
{
	// setup up stuff on player connec
}

function gadget_armor_on( slot, weapon )
{
	if ( IsAlive(self) )
	{
		// excecutes when the gadget is turned on
		self flagsys::set( "gadget_armor_on" );	
		
		//armor section
		self.shock_onpain = 0;	
		
		//set the hitpoints
		self.gadgetHitPoints = ( ( IsDefined( weapon.gadget_max_hitpoints ) && weapon.gadget_max_hitpoints > 0 ) ? weapon.gadget_max_hitpoints : undefined );
		
		if ( isdefined( self.overridePlayerDamage ) )
		{
			self.originalOverridePlayerDamage = self.overridePlayerDamage;
		}
		
		self.overridePlayerDamage = &armor_player_damage;
		self thread gadget_armor_status( slot, weapon );
	}
}

function gadget_armor_off( slot, weapon )
{
	self notify( "gadget_armor_off" );
	
	// excecutes when the gadget is turned off
	self flagsys::clear( "gadget_armor_on" );
	
	//armor section
	self.shock_onpain = 1; 
	self clientfield::set( "armor_status", 0 );
	if ( isdefined( self.originalOverridePlayerDamage ) )
	{
		self.overridePlayerDamage = self.originalOverridePlayerDamage;
		self.originalOverridePlayerDamage = undefined;
	}
}

function gadget_armor_flicker( slot, weapon )
{
	self endon( "disconnect" );	

	if ( !self gadget_armor_is_inuse( slot ) )
	{
		return;
	}

	eventTime = self._gadgets_player[slot].gadget_flickertime;

	self set_gadget_status( "Flickering", eventTime );

	while( 1 )
	{		
		if ( !self GadgetFlickering( slot ) )
		{
			self set_gadget_status( "Normal" );
			return;
		}

		wait( 0.5 );
	}
}

function set_gadget_status( status, time )
{
	timeStr = "";

	if ( IsDefined( time ) )
	{
		timeStr = "^3" + ", time: " + time;
	}
	
	if ( GetDvarInt( "scr_cpower_debug_prints" ) > 0 )
		self IPrintlnBold( "Gadget Armor: " + status + timeStr );
}

function armor_damage_type_multiplier( sMeansOfDeath )
{
    switch(sMeansOfDeath)
    {
        case "MOD_CRUSH":
        case "MOD_TELEFRAG":
        case "MOD_SUICIDE":
        case "MOD_DROWN":
        case "MOD_HIT_BY_OBJECT":
        case "MOD_FALLING":
            return 0; // no protection - damage will fall through to player
            
            
        case "MOD_PROJECTILE":
            return GetDvarFloat( "scr_armor_mod_proj_mult", 1 );
            
        case "MOD_MELEE":
        case "MOD_MELEE_WEAPON_BUTT":
            return GetDvarFloat( "scr_armor_mod_melee_mult", 2 );
            break;
            
        case "MOD_EXPLOSIVE":
        case "MOD_PROJECTILE_SPLASH":
        case "MOD_GRENADE": 
        case "MOD_GRENADE_SPLASH":
            return GetDvarFloat( "scr_armor_mod_expl_mult", 1 );
            break;
        
        case "MOD_PISTOL_BULLET":
        case "MOD_RIFLE_BULLET":
            return GetDvarFloat( "scr_armor_mod_bullet_mult", .9 );
            break;
            

        case "MOD_BURNED":
        case "MOD_UNKNOWN":
        case "MOD_TRIGGER_HURT":
        default:
            return GetDvarFloat( "scr_armor_mod_misc_mult", 1 );
    }
}

function armor_damage_mod_allowed( sMeansOfDeath )
{
    switch(sMeansOfDeath)
    {
        case "MOD_CRUSH":
        case "MOD_TELEFRAG":
        case "MOD_SUICIDE":
        case "MOD_DROWN":
        case "MOD_HIT_BY_OBJECT":
        case "MOD_FALLING":
        case "MOD_PROJECTILE":
        case "MOD_MELEE":
        case "MOD_MELEE_WEAPON_BUTT":
        case "MOD_EXPLOSIVE":
        case "MOD_PROJECTILE_SPLASH":
        case "MOD_GRENADE": 
        case "MOD_GRENADE_SPLASH":
        case "MOD_BURNED":
        case "MOD_UNKNOWN":
        case "MOD_TRIGGER_HURT":
        	return false;
            
        case "MOD_PISTOL_BULLET":
        case "MOD_RIFLE_BULLET":
            return true;
            
		default:
            return false;
   
    }
    
    return false;
}

function armor_should_take_damage( eInflictor, eAttacker, sMeansOfDeath, weapon, sHitLoc )
{
	if ( isdefined( eAttacker ) && !weaponobjects::friendlyFireCheck( self, eAttacker ) )
	{
		return false;
	}
	
	if ( !armor_damage_mod_allowed( sMeansOfDeath ) )
	{
		return false;
	}
	
	if( sHitLoc == "head" || sHitLoc == "helmet" )
	{
		return false;
	}
	
	return true;
}

function armor_player_damage( eInflictor, eAttacker, iDamage, iDFlags, sMeansOfDeath, weapon, vPoint, vDir, sHitLoc, modelIndex, psOffsetTime )
{
	damage = iDamage;
	
	if ( ( self armor_should_take_damage( eInflictor, eAttacker, sMeansOfDeath, weapon, sHitLoc ) ) && isdefined( self._gadget_armor_slot ) )
	{
		if ( self gadget_armor_is_inuse( self._gadget_armor_slot ) )
		{			
			armor_damage = damage * armor_damage_type_multiplier( sMeansOfDeath );			
			
			damage = 0;
			
			if ( armor_damage > 0 )
			{
				if( IsDefined( self.gadgetHitPoints ) )
				{
					hitPointsLeft = self.gadgetHitPoints;
				}
				else
				{
					hitPointsLeft = self GadgetPowerChange( self._gadget_armor_slot, 0.0 );
				}
				
				if ( weapon == level.weaponLightningGun || weapon == level.weaponLightningGunArc )
				{
					// lightning gun will take all armor but do no damage
					armor_damage = hitPointsLeft;
				}
				else if ( sMeansOfDeath == "MOD_MELEE"  )
				{	
					// melee will disable armor and do all damage back to player					
					damage = iDamage;
					armor_damage = hitPointsLeft;
				}
				else
				{
					if ( hitPointsLeft < armor_damage )
					{
						// will apply rest of damage back to player
						damage = armor_damage - hitPointsLeft;
					}
					else if ( sMeansOfDeath == "MOD_MELEE_WEAPON_BUTT" )
					{
						// melee butt will always disable armor
						armor_damage = hitPointsLeft;
					}
				}				
				if( IsDefined( self.gadgetHitPoints ) )
				{
					self hitpoints_loss_event( armor_damage );
				}
				else
				{
					self ability_power::power_loss_event( self._gadget_armor_slot, eAttacker, armor_damage, "armor damage" );
				}
				self AddToDamageIndicator( int( armor_damage ), vDir);
			}			
		}
	}
	
	return damage;
}

function hitpoints_loss_event( val )
{
	if ( val > 0 )
	{
		self.gadgetHitPoints -= val;
	}
}

function gadget_armor_status( slot, weapon )
{
	self endon( "disconnect" );
	
	maxHitPoints = ( ( IsDefined( weapon.gadget_max_hitpoints ) && weapon.gadget_max_hitpoints > 0 ) ? weapon.gadget_max_hitpoints : 100 );
	
	while ( self flagsys::get( "gadget_armor_on" ) )
	{
		if( IsDefined( self.gadgetHitPoints ) && self.gadgetHitPoints <= 0 )
		{
			self playsoundtoplayer( "wpn_power_armor_destroyed_plr", self );
			self playsoundtoallbutplayer( "wpn_power_armor_destroyed_npc", self );
			
			self GadgetDeactivate( slot, weapon );
			self GadgetPowerSet( slot, 0.0 );
			break;
		}
		if( IsDefined( self.gadgetHitPoints ) )
		{
			hitPointsRatio = self.gadgetHitPoints / maxHitPoints;
		}
		else
		{
			hitPointsRatio = self GadgetPowerChange( self._gadget_armor_slot, 0.0 ) / maxHitPoints;
		}
		stage = 1 + int( hitPointsRatio * 5 );
		
		if ( stage > 5 )
		{
			stage = 5;
		}
		
		self clientfield::set( "armor_status", stage );
		
		{wait(.05);};
	}
	
	self clientfield::set( "armor_status", 0 );
}