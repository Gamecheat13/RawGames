#using scripts\codescripts\struct;

#using scripts\shared\array_shared;
#using scripts\shared\clientfield_shared;

    	   	                                                                                                                         	                                                                                                                                                                                                                                                                                                                                                                    	        	     	             	    	   	                           	                               	                                	                                                              	                                                                                                              	                            	                                     	                                       	                                                               	   	                  	       	                                                    	                   	                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                       	                                                                                        	           	                        	                                            	                                             	                                                   	                                                             	                                                         	                                                                    	                                                                                                                                                                                                    	                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                     	                                                              	                                                          	                                   	                                   	                                                    	                                       
                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                            	                                                                                                                                                                                                                                                                                                                                                                                       

#using scripts\zm\_zm_audio;
#using scripts\zm\_zm_melee_weapon;
#using scripts\zm\_zm_spawner;
#using scripts\zm\_zm_utility;
#using scripts\zm\_zm_weapons;

#precache( "fx", "_t6/maps/zombie/fx_zmb_taser_vomit" );
#precache( "fx", "_t6/weapon/taser/fx_taser_knuckles_anim_zmb" );
#precache( "fx", "_t6/weapon/taser/fx_taser_knuckles_impact_zmb" );

function init()
{
	level.weaponZMTazerKnuckles = GetWeapon( "tazer_knuckles" );
	clientfield::register( "toplayer", "tazer_flourish", 1, 1, "counter" ); 

	zm_utility::register_melee_weapon_for_level( "tazer_knuckles" );

	if( isDefined( level.tazer_cost ) )
	{
		cost = level.tazer_cost;
	}
	else
	{
		cost = 6000;
	}
	level.use_tazer_impact_fx = false;
	
	zm_melee_weapon::init( "tazer_knuckles", 
							"zombie_tazer_flourish",
							"knife_ballistic_no_melee",
							"knife_ballistic_no_melee_upgraded",
	                        cost,
							"tazer_upgrade",
							&"ZOMBIE_WEAPON_TAZER_BUY",
							"tazerknuckles",
							&tazer_flourish_fx);


	zm_weapons::add_retrievable_knife_init_name( "knife_ballistic_no_melee" );
	zm_weapons::add_retrievable_knife_init_name( "knife_ballistic_no_melee_upgraded" );

//	callback::on_connect( &onPlayerConnect);
	zm_spawner::add_cusom_zombie_spawn_logic( &watch_bodily_functions);

	level._effect["fx_zmb_taser_vomit"]				= "_t6/maps/zombie/fx_zmb_taser_vomit";
	level._effect["fx_zmb_taser_flourish"]			= "_t6/weapon/taser/fx_taser_knuckles_anim_zmb";
	
	if(level.script != "zm_transit")
	{
		level._effect["fx_zmb_tazer_impact"] 			= "_t6/weapon/taser/fx_taser_knuckles_impact_zmb";
		level.use_tazer_impact_fx = true;
	}
	
	level.tazer_flourish_delay = 0.5;	
	
}

function watch_bodily_functions()
{
	//self endon("death");
	if( ( isdefined( self.isscreecher ) && self.isscreecher ) || ( isdefined( self.is_avogadro ) && self.is_avogadro ))
		return;
	
	while( IsDefined(self) && IsAlive(self) )
	{
		self waittill( "damage", amount, attacker, direction_vec, point, type ); 

		if( !IsDefined( self ) )
		{
			return;
		}

		if( !IsDefined(attacker) || !IsPlayer(attacker) )
		{
			continue; 
		}

		if( type!="MOD_MELEE" )
		{
			continue; 
		}
		
		if ( !attacker HasWeapon(level.weaponZMTazerKnuckles) || ( isdefined( self.hasRiotShieldEquipped ) && self.hasRiotShieldEquipped ) )
		{
			continue; 
		}
		

		ch = RandomInt(100);
		
		/*
		//if (ch < 1)
		{
			//poop
			PlayFXOnTag( level._effect["fx_zmb_taser_poop"], self, "J_MainRoot" );		
		}
		//else 
		*/
		if (ch < 4)
		{
			//puke
			PlayFXOnTag( level._effect["fx_zmb_taser_vomit"], self, "j_neck" );		
		}
		
		if (level.use_tazer_impact_fx )
		{
			tags = [];
			tags[ 0 ] = "J_Head";
			tags[ 1 ] = "J_Neck";
			PlayFXOnTag( level._effect["fx_zmb_tazer_impact"], self, array::random(tags) );
		}
	}
}
	
function onPlayerConnect()
{
	self thread onPlayerSpawned(); 
}

function onPlayerSpawned()
{
	self endon("disconnect");

	for(;;)
	{
		self waittill("spawned_player");
		self thread watchTazerKnuckleMelee();
	}
}

function watchTazerKnuckleMelee()
{
	self endon("disconnect");
	for ( ;; )
	{
		self waittill( "weapon_melee", weapon ); 
		if ( weapon == level.weaponZMTazerKnuckles )
			self tazerknuckle_melee();
	}
}

function tazerknuckle_melee()
{
}

function tazer_flourish_fx()
{
	self waittill( "weapon_change", newWeapon );	
	if (newWeapon.name == "zombie_tazer_flourish")
	{
		self endon( "weapon_change" );	
		 // need to hook up flourish FX
		wait level.tazer_flourish_delay;
    	self thread zm_audio::playerExert( "hitmed" );
		//PlayFxOnTag( level._effect["fx_zmb_taser_flourish"], self, "tag_weapon" );
		self clientfield::increment_to_player( "tazer_flourish" );
		
	}
}

