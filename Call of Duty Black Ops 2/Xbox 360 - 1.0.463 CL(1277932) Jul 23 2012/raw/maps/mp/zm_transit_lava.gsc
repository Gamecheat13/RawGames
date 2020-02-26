#include common_scripts\utility;
#include maps\mp\_utility;
#include maps\mp\zombies\_zm_utility;

//*****************************************************************************
// DCS: Lava Damage setup
// seting up lava barrier damage triggers.
//*****************************************************************************

object_touching_lava()
{
	lava = GetEntArray("lava_damage", "targetname");
	
	if(!IsDefined(lava) || lava.size < 1)
		return false;

	for ( i=0; i<lava.size; i++ )
	{
		if ( self IsTouching(lava[i]) )
			return true; 
		
		if( IsDefined(lava[i].target) )
		{
			volume = GetEnt(lava[i].target, "targetname");
			if( self IsTouching(volume) )
			{
				return true;
			}	
		}
	}

	return false;
}

lava_damage_init()
{
	lava = GetEntArray("lava_damage", "targetname");
	
	if(!IsDefined(lava))
	return;
	
	array_thread(lava, ::lava_damage_think);	
}

lava_damage_think()
{
	self._trap_type = "";
	if ( IsDefined(self.script_noteworthy) )
	{
		self._trap_type = self.script_noteworthy;
	}
		
	while(1)
	{
		self waittill( "trigger", ent );

		if(is_true(ent.ignore_lava_damage))
		{
			continue;
		}
		
		if(IsDefined(ent.is_burning) /*|| IsDefined(ent.IsOnBus) && ent.IsOnBus*/)
		{
			continue;
		}
		
		// volume linked to trigger for odd shaped lava pools.
		if(IsDefined(self.target)&& !ent IsTouching(GetEnt(self.target, "targetname")))
		{
			continue;
		}	
			
		if( isplayer(ent))
		{
			switch ( self._trap_type )
			{
			case "fire":
			default:
				ent thread player_lava_damage();
				break;
			}
		}
		else
		{
			if(!isDefined(ent.marked_for_death))
			{
				switch ( self._trap_type )
				{
				case "fire":
				default:
					ent thread zombie_lava_damage( self );
					break;
				}
			}
		}		
	}	
}

player_lava_damage()
{	
	self endon("death");
	self endon("disconnect");
	
	max_dmg = 15;
	min_dmg = 5;

	if (is_true(self.is_zombie))
		return; 

	if(IsDefined(self.script_float))
	{
		max_dmg = max_dmg * self.script_float;
		min_dmg = min_dmg * self.script_float;
	}
	
	if( !isDefined(self.is_burning) && !self maps\mp\zombies\_zm_laststand::player_is_in_laststand() )
	{
		self.is_burning = 1;		
		self setburn(1.0);
		self thread player_burning_fx();
		
		if(!self hasperk("specialty_armorvest") || self.health - 100 < 1)
		{
			radiusdamage(self.origin,10,max_dmg,min_dmg);
			wait(0.5);
			self.is_burning = undefined;
		}
		else
		{
			self dodamage(10, self.origin);
			wait(0.5);
			self.is_burning = undefined;
		}
	}
}

zombie_burning_fx()
{
	self endon( "death" );

	if (IsDefined(self.is_on_fire) && self.is_on_fire )
	{
		return;
	}
	
	self.is_on_fire = true;
	
	self thread maps\mp\animscripts\zm_death::on_fire_timeout();

	if( IsDefined( level._effect ) && IsDefined( level._effect["lava_burning"] ) )
	{
		if ( !self.isdog )
		{
			PlayFxOnTag( level._effect["lava_burning"], self, "J_SpineLower" ); 
			self thread zombie_burning_audio();
		}
	}

	if( IsDefined( level._effect ) && IsDefined( level._effect["character_fire_death_sm"] ) )
	{
		wait 1;

		tagArray = []; 
		tagArray[0] = "J_Elbow_LE"; 
		tagArray[1] = "J_Elbow_RI"; 
		tagArray[2] = "J_Knee_RI"; 
		tagArray[3] = "J_Knee_LE"; 
		tagArray = randomize_array( tagArray ); 

		PlayFxOnTag( level._effect["character_fire_death_sm"], self, tagArray[0] ); 

		wait 1;

		tagArray[0] = "J_Wrist_RI"; 
		tagArray[1] = "J_Wrist_LE"; 
		if( !IsDefined( self.a.gib_ref ) || self.a.gib_ref != "no_legs" )
		{
			tagArray[2] = "J_Ankle_RI"; 
			tagArray[3] = "J_Ankle_LE"; 
		}
		tagArray = randomize_array( tagArray ); 

		PlayFxOnTag( level._effect["character_fire_death_sm"], self, tagArray[0] ); 
		PlayFxOnTag( level._effect["character_fire_death_sm"], self, tagArray[1] ); 
	}
}

zombie_burning_audio()
{
	self PlayLoopSound( "zmb_fire_loop" );
	
	self waittill_either( "stop_flame_damage", "death" );
	
	if ( IsDefined( self ) && IsAlive( self ) )
	{
		self StopLoopSound( 0.25 );
	}
}

player_burning_fx()
{
	self endon( "death" );

	if (IsDefined(self.is_on_fire) && self.is_on_fire )
	{
		return;
	}
	
	self thread player_burning_audio();
		
	self.is_on_fire = true;
	
	self thread maps\mp\animscripts\zm_death::on_fire_timeout();

	
	if( IsDefined( level._effect ) && IsDefined( level._effect["character_fire_death_sm"] ) )
	{
		PlayFxOnTag( level._effect["character_fire_death_sm"], self, "J_SpineLower" ); 
	}
}


// Function to play burning loop on player. Commenting out for now, for scripter to evaluate - JM

player_burning_audio()
{
	fire_ent = spawn( "script_origin", self.origin );
	fire_ent linkto( self, "tag_origin", (0,0,0), (0,0,0) );
	fire_ent playloopsound ("evt_plr_fire_loop");	
	fire_ent thread burning_audio_cleanup (self);
	//fire_ent PlayLoopSound( "evt_plr_fire_loop", .5 );
	
	//iprintlnbold ("FIRE TIME");
	
	self waittill_either( "stop_flame_damage", "death" );
	
	if ( IsDefined( self ) && IsAlive( self ) )
	{
		//iprintlnbold( "FIRE TIME STOP" );
		fire_ent StopLoopSound(0.25 );
	}
}

burning_audio_cleanup(player)
{
	player waittill_either ("stop_flame_damage", "death");
	wait (1);
	self delete();
}

	




zombie_lava_damage( trap )
{
	self endon("death");
	
	zombie_dmg = 1;

	if(IsDefined(self.script_float))
	{
		zombie_dmg = zombie_dmg * self.script_float;
	}

	
	switch (trap._trap_type)
	{
		case "fire":
		default:

		if ( IsDefined( self.animname ) && self.animname != "zombie_dog" && (!IsDefined(self.is_on_fire) || !self.is_on_fire ) )
		{
			if(level.burning_zombies.size < 6 && zombie_dmg >= 1)
			{
				level.burning_zombies[level.burning_zombies.size] = self;
				self playsound("ignite");
				self thread zombie_burning_fx();
				self thread zombie_burning_watch();
				self thread zombie_burning_dmg();
				self thread zombie_exploding_death(zombie_dmg, trap);
				wait( randomfloat(1.25) );
			}
		}

		if(self.health <= zombie_dmg && (!IsDefined(self.is_on_fire) || !self.is_on_fire))
		{
			self.marked_for_death = true;			
			self dodamage(self.health + 100, self.origin, trap);
			
			// Check to see if ever damaged by a player, if not put back into array.
			if(!is_true(self.damagetaken))
			{
				level.zombie_total++;
			}	
		}
		else if(self.health > zombie_dmg)
		{
			self dodamage(zombie_dmg, self.origin, trap);
			wait(1.0);
		}

		break;
	}
}

zombie_burning_watch()
{
	self waittill_any("stop_flame_damage", "death");

	ArrayRemoveValue(level.burning_zombies,self);
}

zombie_exploding_death(zombie_dmg, trap)
{
	self endon("stop_flame_damage");

	while ( IsDefined( self ) && self.health >= zombie_dmg && IsDefined(self.is_on_fire) && self.is_on_fire )
	{
		wait(0.5);
	}
	
	if(!IsDefined(self))
		return;
	
	//BOOM!!!
	if( IsDefined( level._effect["zomb_gib"] ) )
	{
		PlayFxOnTag( level._effect["zomb_gib"], self, "J_SpineLower" );
	}
	self RadiusDamage(self.origin,128,30,15, undefined, "MOD_EXPLOSIVE");
	self dodamage(self.health + 100, self.origin, trap);
	wait(1);
	if(IsDefined(self))
	{
		self Hide();
	}	
}
	
zombie_burning_dmg()
{
	self endon("death");

	damageRadius = 25;
	damage = 2;	

	while(IsDefined(self.is_on_fire) && self.is_on_fire )
	{
		eyeOrigin = self GetEye();
	
		players = GET_PLAYERS();
		for( i = 0; i < players.size; i++ )
	 	{
	 		if ( is_player_valid( players[i] ) )
	 		{
		 		playerEye = players[i] GetEye();

				if( distanceSquared( eyeOrigin, playerEye ) < damageRadius * damageRadius )
		 		{
					players[i] DoDamage( damage, self.origin, self );
		 		}
			}
		}
		wait(1.0);
	}			
}

//*****************************************************************************
//*****************************************************************************
