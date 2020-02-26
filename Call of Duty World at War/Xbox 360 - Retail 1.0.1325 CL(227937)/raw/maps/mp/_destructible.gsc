#include maps\mp\_utility;
#include common_scripts\utility;


init()
{
	if(getdvar("debug_destructibles") == "")
	{
		setdvar("debug_destructibles", "0");
	}
	
	if(getdvar("destructibles_enable_physics") == "")
	{
		setdvar("destructibles_enable_physics", "1");
	}
	
	delete_these = getEntArray("delete_on_load", "targetname");
	for(i = 0; i < delete_these.size; i++)
	{
		delete_these[i] delete();
	}
	
	destructible = false;
	
	destructibles = getEntArray("destructible", "targetname");
	if((isDefined(destructibles)) && (destructibles.size > 0))
	{
		destructible = true;
	}
	
	if(destructible)
	{
		level._effect["dest_car_fire"] 		= loadFX("destructibles/fx_dest_fire_lg");
		level._effect["dest_car_hoodfire"] 	= loadFX("destructibles/fx_dest_fire_car_fade_40");
		
		/*for(i = 0; i < destructibles.size; i++)
		{
			if(!IsSubStr(destructibles[i].destructibledef, "_mp")) 
			{ 
				ASSERTMSG("You have specificied a non-MP version of a destructible at this location: " + destructibles[i].origin); 
				return;
			}
		}*/
		
		array_thread(destructibles, ::setup_destructibles);
	}
	else
	{
		return;
	}	
}

// setup the destructible vehicles
setup_destructibles()
{
	if(isDefined(self.destructibledef))
	{
		if(
				self.destructibledef == "dest_audi_mp"						||
				self.destructibledef == "dest_beetle_mp"    				||
				self.destructibledef == "dest_bmwmotorcycle_mp"    			||
				self.destructibledef == "dest_horch1a_mp"    				||
				self.destructibledef == "dest_mercedesw136_mp"   			||
				self.destructibledef == "dest_opel_blitz_mp"				||
				self.destructibledef == "dest_peleliu_generator_mobile_mp"	||
				self.destructibledef == "dest_ptboat_mp"					||
				self.destructibledef == "dest_type94truck_mp"				||
				self.destructibledef == "dest_type94truckcamo_mp"			||
				self.destructibledef == "dest_type95scoutcar_mp"			)
		{
			self thread destructibles_think();
			//self thread printHealth();
		}
	}
}


destructible_record_initial_values()
{
	// do nothing for now, called from _vehicles::vehicle_record_initial_values()
}


destructible_recycle_spawn()
{
	// do nothing for now, called from _vehicles::vehicle_recycle_spawn()
}


// wait for enough damage, then destroy the destructible vehicle
destructibles_think()
{
	self.exploded = false;
	immediateExplosion = false;
	
	for(;;)
	{
		self waittill("damage", damage, attacker, direction_vec, point, type, modelName, tagName);

		// CODER_MOD - Jay (7/21/08): Knife swipes should not damage the vehicles
		if ( type == "MOD_MELEE" )
		{
			self.health += damage;
		}
		// CODER_MOD - Jay (7/24/08): Projectiles blow up the vehicles immediately
		else if ( type == "MOD_GRENADE_SPLASH" || type == "MOD_GRENADE" || type == "MOD_PROJECTILE" || type == "MOD_PROJECTILE_SPLASH" || type == "MOD_EXPLOSIVE" )
		{
			// REMOVE AFTER SHIP
			// This is to make the vehicles explode from explosives if they are near it 
			self.health = 200;
			immediateExplosion = true;
		}

		if( self.health < 200 )
			self.health = 200;
		
		if(self.health <= 200 && !self.exploded)
		{
			self.exploded = true;
			
			attacker notify ( "destroyed_car" );
			
			if(self.destructibledef != "dest_peleliu_generator_mobile_mp" && self.destructibledef != "dest_ptboat_mp")
			{
				hood_tag = self getTagOrigin("hood_jnt");
			
				if(isDefined(hood_tag))
				{
					playFX (level._effect["dest_car_hoodfire"], hood_tag);
					self playDestructibleBattleChatter();
					
					//Make vehicles explode immediately
					if( !immediateExplosion )
						wait 3;
					
					playFX (level._effect["dest_car_fire"], self.origin + (0, 0, 15));
				}
			}
			
			self.damageOwner = attacker;
			self destructible_vehicle_damage_to_death();
			
			// make the destructible vehicle lurch when it explodes
			if(self.destructibledef != "dest_peleliu_generator_mobile_mp")
			{
				self thread explode_anim();
				//self notify( "vehicle destroyed" );
			}
		}
	}
}

playDestructibleBattleChatter()
{
		if (
			self.destructibledef == "dest_audi_mp"			 ||
			self.destructibledef == "dest_beetle_mp"    	 ||
			self.destructibledef == "dest_horch1a_mp"    	 ||
			self.destructibledef == "dest_mercedesw136_mp"   ||
			self.destructibledef == "dest_type95scoutcar_mp" )
		{
			//start the battlechatter thread
			level thread maps\mp\gametypes\_battlechatter_mp::onPlayerNearExplodable( self, "car" );
			return;
		}
		else if (
			self.destructibledef == "dest_opel_blitz_mp"		||
			self.destructibledef == "dest_ptboat_mp"			||
			self.destructibledef == "dest_type94truckcamo_mp"	||
			self.destructibledef == "dest_type94truck_mp" )
		{
			//start the battlechatter thread
			level thread maps\mp\gametypes\_battlechatter_mp::onPlayerNearExplodable( self, "truck" );
			return;
		}
}

destructible_vehicle_play_explosion_sound()
{
	if ( IsDefined( self.destructibleDef ) )
	{
		if (
			self.destructibledef == "dest_bmwmotorcycle_mp"            ||
			self.destructibledef == "dest_peleliu_generator_mobile_mp" )
		{
			self playSound( "car_explo_small" );
			return;
		}
		else if (
			self.destructibledef == "dest_audi_mp"			 ||
			self.destructibledef == "dest_beetle_mp"    	 ||
			self.destructibledef == "dest_horch1a_mp"    	 ||
			self.destructibledef == "dest_mercedesw136_mp"   ||
			self.destructibledef == "dest_type95scoutcar_mp" )
		{
			self playSound( "car_explo_med" );
			return;
		}
		else if (
			self.destructibledef == "dest_opel_blitz_mp"		||
			self.destructibledef == "dest_ptboat_mp"			||
			self.destructibledef == "dest_type94truckcamo_mp"	||
			self.destructibledef == "dest_type94truck_mp" )
		{
			self playSound( "car_explo_large" );
			return;
		}
	}
	
	self maps\mp\_vehicles::vehicle_play_explosion_sound();
}

printHealth()
{
	self endon( "vehicle destroyed" );

	for(;;)
	{
		self waittill("damage");
		print3d(self.origin, self.health, ( 0, 1, 0 ), 1, 1, 1 );
	}
}

destructible_vehicle_damage_to_death()
{
	
	self.destructible_type = "vehicle_mp";
	offset = (0,0,1);
	// damage the vehicle so much that it is immediately destroyed
	if ( self.destructibledef == "dest_bmwmotorcycle_mp"
		|| self.destructibledef == "dest_peleliu_generator_mobile_mp" )
	{
		radiusDamage( self.origin, 128, 400, 25 );
		self dodamage( 20000, self.origin + offset, self.damageOwner );
	}
	else
	{
		self radiusDamage( self.origin, 256, 400, 25, self.damageOwner);
		self dodamage( 20000, self.origin + offset, self.damageOwner );
	}
}


// make the destructible vehicle lurch when it explodes
explode_anim()
{
	self moveZ(16, 0.3, 0, 0.2);
	self rotatePitch(10, 0.3, 0, 0.2);
	
	wait (0.3);
	
	if(self.destructibledef != "dest_bmwmotorcycle_mp")
	{
		self moveZ(-16, 0.3, 0.15, 0);
		self rotatePitch(-10, 0.3, 0.15, 0);
	}
	else
	{
		self moveZ(-20, 0.3, 0.15, 0);
		self rotatePitch(0, 0.3, 0.15, 0);
	}
}

watch_for_players_in_fire()
{
	level endon( "game_ended" );
	while (1)
	{
		players = get_players();
		for (i = 0; i < players.size; i++)
		{	
			if (players[i] istouching(self) && players[i].sessionstate == "playing")
			{
				x = 0;
			}
		}
	}
}

cleanup_triggers()
{
	level waittill( "game_ended" );

	self delete();
}