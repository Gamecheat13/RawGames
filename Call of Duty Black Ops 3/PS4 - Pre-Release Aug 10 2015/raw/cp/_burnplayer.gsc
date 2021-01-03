#using scripts\codescripts\struct;

#using scripts\shared\damagefeedback_shared;
#using scripts\shared\util_shared;

    	   	                                                                                                                                         	                                	                                                                                                                                                                                                                                                                                                                                                                    	        	     	             	    	   	               	                                              	                                                           	                               	                     	                                                                                                           	                                                                 	                                                              	                                                                                                              	                            	                                     	                                       	                                                                                                              	   	                  	       	                                                    	                   	                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                        	                                  	                                                                                        	           	                        	                                            	                                             	                                                   	                                                             	                                                         	                                                                    	                                                                                                                                                                                                    	                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                         	                                                              	                                                          	                                   	                                   	                                                    	                                       	                                           	     	                                                                                                                                                                                                                                                      	                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                     

#using scripts\cp\gametypes\_globallogic_player;

#namespace burnplayer;

function initBurnPlayer()
{
//	level._effect["character_fire_death_torso"] 	= "_t6/env/fire/fx_fire_player_torso_mp";
//	level._effect["character_fire_player_sm"] 		= "_t6/env/fire/fx_fire_player_sm_mp";
//	level._effect["character_fire_death_sm"] 		= "_t6/env/fire/fx_fire_player_md_mp";
//	level._effect["fx_fire_player_sm_smk_2sec"] 	= "_t6/env/fire/fx_fire_player_sm_smk_2sec";

	level.flameDamage = 15;
	level.flameBurnTime = 1.5;
}

function hitWithIncendiary(attacker, inflictor, mod)
{
	// no more effects if we are already on fire
	if ( isdefined( self.burning ) )
		return;
	
	self thread waitThenStopTanning( level.flameBurnTime );
	self endon("disconnect");
	attacker endon("disconnect");
	waittillframeend;
	
	self.burning = true;
	self thread burn_blocker();
	
	tagArray = [];
	
	if ( isai( self ) )
	{
		tagArray[tagArray.size] = "J_Wrist_RI"; 
		tagArray[tagArray.size] = "J_Wrist_LE"; 
		tagArray[tagArray.size] = "J_Elbow_LE"; 
		tagArray[tagArray.size] = "J_Elbow_RI"; 
		tagArray[tagArray.size] = "J_Knee_RI"; 
		tagArray[tagArray.size] = "J_Knee_LE"; 
		tagArray[tagArray.size] = "J_Ankle_RI"; 
		tagArray[tagArray.size] = "J_Ankle_LE"; 
	}
	else
	{
		tagArray[tagArray.size] = "J_Wrist_RI"; 
		tagArray[tagArray.size] = "J_Wrist_LE"; 
		tagArray[tagArray.size] = "J_Elbow_LE"; 
		tagArray[tagArray.size] = "J_Elbow_RI"; 
		tagArray[tagArray.size] = "J_Knee_RI"; 
		tagArray[tagArray.size] = "J_Knee_LE"; 
		tagArray[tagArray.size] = "J_Ankle_RI"; 
		tagArray[tagArray.size] = "J_Ankle_LE"; 

		// Need set burn
		
		if ( isplayer( self ) && self.health > 0 )
			self setburn( 3.0 );
	}

	if( isdefined( level._effect["character_fire_death_torso"] ) )
	{
		for (arrayIndex = 0; arrayIndex < tagArray.size;  arrayIndex++)
		{
			PlayFxOnTag( level._effect["character_fire_death_sm"], self, tagArray[arrayIndex] );
			
		}
	}
	
	// Use J_Spine1 for dogs
	if ( isai( self ) )
		PlayFxOnTag( level._effect["character_fire_death_torso"], self, "J_Spine1" );
	else
		PlayFxOnTag( level._effect["character_fire_death_torso"], self, "J_SpineLower" );
	
	if ( !isalive( self ) )
		return;
		
	//// AE 10-20-09: put slap damage back in
	//self thread doIncendiaryDamage(attacker, inflictor, mod);

	if ( isplayer( self ) )
	{
		self thread watchForWater(7);
		self thread watchForDeath();
	}
}


function hitWithNapalmStrike(attacker, inflictor, mod)
{
	// no more effects if we are already on fire
	if ( isdefined( self.burning ) || self hasperk( "specialty_fireproof" ) )
		return;
	
	self thread waitThenStopTanning( level.flameBurnTime );
	self endon("disconnect");
	attacker endon("disconnect");
	self endon("death");
	if ( isdefined( self.burning ) )
		return;

	self thread burn_blocker();
	waittillframeend;
	
	self.burning = true;
	self thread burn_blocker();
	
	tagArray = [];
	
	if ( isai( self ) )
	{
		tagArray[tagArray.size] = "J_Wrist_RI"; 
		tagArray[tagArray.size] = "J_Wrist_LE"; 
		tagArray[tagArray.size] = "J_Elbow_LE"; 
		tagArray[tagArray.size] = "J_Elbow_RI"; 
		tagArray[tagArray.size] = "J_Knee_RI"; 
		tagArray[tagArray.size] = "J_Knee_LE"; 
		tagArray[tagArray.size] = "J_Ankle_RI"; 
		tagArray[tagArray.size] = "J_Ankle_LE"; 
	}
	else
	{
		tagArray[tagArray.size] = "J_Wrist_RI"; 
		tagArray[tagArray.size] = "J_Wrist_LE"; 
		tagArray[tagArray.size] = "J_Elbow_LE"; 
		tagArray[tagArray.size] = "J_Elbow_RI"; 
		tagArray[tagArray.size] = "J_Knee_RI"; 
		tagArray[tagArray.size] = "J_Knee_LE"; 
		tagArray[tagArray.size] = "J_Ankle_RI"; 
		tagArray[tagArray.size] = "J_Ankle_LE"; 

		// Need set burn
		
		if ( isplayer( self ) )
			self setburn( 3.0 );
	}

	if( isdefined( level._effect["character_fire_death_sm"] ) )
	{
		for (arrayIndex = 0; arrayIndex < tagArray.size;  arrayIndex++)
		{
			PlayFxOnTag( level._effect["character_fire_death_sm"], self, tagArray[arrayIndex] );
		}
	}
	
	if( isdefined( level._effect["character_fire_death_torso"] ) )
	{
		PlayFxOnTag( level._effect["character_fire_death_torso"], self, "J_SpineLower" );
	}

	if ( !isalive( self ) )
		return;

	self thread doNapalmStrikeDamage(attacker, inflictor, mod);
	
	if ( isplayer( self ) )
	{
		self thread watchForWater(7);
		self thread watchForDeath();
	}
}


function walkedThroughFlames( attacker, inflictor, weapon )
{
	// no more effects if we are already on fire
	if ( isdefined( self.burning ) || self hasperk( "specialty_fireproof" ) )
		return;
		
	self thread waitThenStopTanning( level.flameBurnTime );	
	self endon("disconnect");
	waittillframeend;
	
	self.burning = true;
	self thread burn_blocker();
	
	tagArray = [];
	if ( isai( self ) )
	{
		tagArray[tagArray.size] = "J_Wrist_RI"; 
		tagArray[tagArray.size] = "J_Wrist_LE"; 
		tagArray[tagArray.size] = "J_Elbow_LE"; 
		tagArray[tagArray.size] = "J_Elbow_RI"; 
		tagArray[tagArray.size] = "J_Knee_RI"; 
		tagArray[tagArray.size] = "J_Knee_LE"; 
		tagArray[tagArray.size] = "J_Ankle_RI"; 
		tagArray[tagArray.size] = "J_Ankle_LE"; 
	}
	else
	{
		tagArray[tagArray.size] = "J_Knee_RI"; 
		tagArray[tagArray.size] = "J_Knee_LE"; 
		tagArray[tagArray.size] = "J_Ankle_RI"; 
		tagArray[tagArray.size] = "J_Ankle_LE"; 
	}
	
	if( isdefined( level._effect["character_fire_player_sm"] ) )
	{
		for (arrayIndex = 0; arrayIndex < tagArray.size;  arrayIndex++)
		{
			PlayFxOnTag( level._effect["character_fire_player_sm"] , self, tagArray[arrayIndex] );
		}
	}

	if ( !IsAlive( self ) )
		return;

	self thread doFlameDamage( attacker, inflictor, weapon, 1.0 );

	if ( isplayer( self ) )
	{
		self thread watchForWater(7);
		self thread watchForDeath();
	}
}

function burnedWithFlameThrower( attacker, inflictor, weapon )
{	
	// no more effects if we are already on fire
	if ( isdefined( self.burning ) )
		return;
	
	self thread waitThenStopTanning( level.flameBurnTime );	
	self endon("disconnect");
	waittillframeend;

	self.burning = true;
	self thread burn_blocker();
	
	tagArray = [];
	if ( isai( self ) )
	{
		tagArray[0] = "J_Spine1";
		tagArray[1] = "J_Elbow_LE";
		tagArray[2] = "J_Elbow_RI";
		tagArray[3] = "J_Head";
		tagArray[4] = "j_knee_ri";
		tagArray[5] = "j_knee_le";
	}
	else
	{
		tagArray[0] = "J_Elbow_RI";
		tagArray[1] = "j_knee_ri";
		tagArray[2] = "j_knee_le";
		//tagArray[3] = "j_spinelower";
		//tagArray[4] = "J_Head";

		// Need set burn
		if ( isplayer( self ) && self.health > 0 )
			self setburn( 3.0 );
	}

	//self thread doFlameDamage( attacker, inflictor, weapon, 2.0 );

	if ( isplayer( self ) &&  IsAlive( self ) )
	{
		self thread watchForWater(7);
		self thread watchForDeath();
	}		

	if( isdefined( level._effect["character_fire_player_sm"] ) )
	{
		for (arrayIndex = 0; arrayIndex < tagArray.size;  arrayIndex++)
		{
			PlayFxOnTag( level._effect["character_fire_player_sm"] , self, tagArray[arrayIndex] );
		}
	}
}

function burnedWithDragonsBreath( attacker, inflictor, weapon )
{	
	// no more effects if we are already on fire
	if ( isdefined( self.burning ) )
		return;

	self thread waitThenStopTanning( level.flameBurnTime );	
	self endon("disconnect");
	waittillframeend;

	self.burning = true;
	self thread burn_blocker();

	tagArray = [];
	if ( isai( self ) )
	{
		tagArray[0] = "J_Spine1";
		tagArray[1] = "J_Elbow_LE";
		tagArray[2] = "J_Elbow_RI";
		tagArray[3] = "J_Head";
		tagArray[4] = "j_knee_ri";
		tagArray[5] = "j_knee_le";
	}
	else
	{
		tagArray[0] = "j_spinelower";
		tagArray[1] = "J_Elbow_RI";
		tagArray[2] = "j_knee_ri";
		tagArray[3] = "j_knee_le";

		// Need set burn
		if ( isplayer( self ) && self.health > 0 )
			self setburn( 3.0 );
	}

	if ( isplayer( self ) &&  IsAlive( self ) )
	{
		self thread watchForWater(7);
		self thread watchForDeath();
		return;
	}
		

	if( isdefined( level._effect["character_fire_player_sm"] ) )
	{
		for (arrayIndex = 0; arrayIndex < tagArray.size;  arrayIndex++)
		{
			PlayFxOnTag( level._effect["character_fire_player_sm"] , self, tagArray[arrayIndex] );
		}
	}
}

function burnedToDeath()
{
	// allow this even if they are already burning
	// really this should only be called on the corpse
		
	self.burning = true;
	self thread burn_blocker();

	self thread doBurningSound ();
	self thread waitThenStopTanning( level.flameBurnTime );	
}

function watchForDeath()
{
	self endon( "disconnect" );
	
	self notify( "watching for death while on fire" );
	self endon( "watching for death while on fire" );
	
	self waittill( "death" );
	
	if( isplayer( self ) )
		self _StopBurning();

	self.burning = undefined;
}

function watchForWater(time)
{
	self endon("disconnect");
	
	self notify ("watching for water");
	self endon("watching for water");
	
	wait (.1);
	
	looptime = .1;
	
	while (time > 0)
	{
		wait (looptime);
		if (self DepthOfPlayerInWater() > 0)
		{
			finish_burn();

			time = 0;
		}
		time -= looptime;
	}
}

function finish_burn()
{
	self notify("stop burn damage");	

	tagArray = [];
	tagArray[0] = "j_spinelower";
	tagArray[1] = "J_Elbow_RI";
	tagArray[2] = "J_Head";
	tagArray[3] = "j_knee_ri";
	tagArray[4] = "j_knee_le";

	if( isdefined( level._effect["fx_fire_player_sm_smk_2sec"] ) )
	{
		for (arrayIndex = 0; arrayIndex < tagArray.size;  arrayIndex++)
		{
			PlayFxOnTag( level._effect["fx_fire_player_sm_smk_2sec"], self, tagArray[arrayIndex] );
		}
	}

	self.burning = undefined;
	self _StopBurning();
	self.inGroundNapalm = false;
}

//doIncendiaryDamage(attacker, inflictor, mod)
//{
//	if ( isai(self) )
//	{
//		doDogIncendiaryDamage(attacker, inflictor, mod);
//		return;
//	}	
//	
//	self endon ( "death" );
//	self endon("disconnect");
//	attacker endon("disconnect");
//	self endon("stop burn damage");
//
//	duration = 0;
//	while ( (isdefined ( level.incendiaryFireDamage) ) && (isdefined (self)) && self DepthOfPlayerInWater() < 1)
//	{
//		self DoDamage( level.incendiaryFireDamage, self.origin, attacker, attacker, "none", mod, 0, GetWeapon( "incendiary_grenade" ) );
//
//		wait(1);
//		duration += 1;
//		if( duration >= level.incendiaryFireDuration )
//		{
//			break;
//		}
//	}
//}

//doIncendiaryGroundDamage(attacker, inflictor, mod)
//{
//	if ( isai(self) )
//	{
//		doDogIncendiaryGroundDamage(attacker, inflictor, mod);
//		return;
//	}	
//
//	if ( isdefined( self.burning ) )
//		return;
//
//	self thread burn_blocker();
//	self endon ( "death" );
//	self endon("disconnect");
//	attacker endon("disconnect");
//	self endon("stop burn damage");
//
//	if (isdefined (level.incendiaryGroundBurnTime))
//	{
//		if (GetDvarString( "incendiary_ground_burn_time") == "")
//		{
//			waittime = level.incendiaryGroundBurnTime;
//		}
//		else
//		{
//			waittime = GetDvarint( "incendiary_ground_burn_time");
//		}
//	}
//	else
//		waittime = 100;
//
//	self walkedThroughFlames();
//
//	self.inGroundIncendiary = true;
//
//	if (isdefined ( level.incendiaryFireDamage) )
//	{
//		if (GetDvarString( "incendiary_fire_damage") == "")
//		{
//			incendiaryFireDamage = level.incendiaryFireDamage;
//		}
//		else
//		{
//			incendiaryFireDamage = GetDvarint( "incendiary_fire_damage");
//		}
//		while ( (isdefined (self)) && ((self DepthOfPlayerInWater()) < 1) && waittime > 0 ) 
//		{
//			self DoDamage( incendiaryFireDamage, self.origin, attacker, inflictor, "none", mod, 0, GetWeapon( "incendiary_grenade" )   );
//			if ( isplayer( self ) )
//				self setburn( 1.1 );
//			wait(1);
//			waittime = waittime - 1;
//		}
//	}
//
//	self.inGroundIncendiary = false;
//}

function doNapalmStrikeDamage(attacker, inflictor, mod)
{
	if ( isai(self) )
	{
		doDogNapalmStrikeDamage(attacker, inflictor, mod);
		return;
	}	
	
	self endon ( "death" );
	self endon("disconnect");
	attacker endon("disconnect");
	self endon("stop burn damage");

	while ( (isdefined ( level.napalmStrikeDamage) ) && (isdefined (self)) && self DepthOfPlayerInWater() < 1)
	{
		self DoDamage( level.napalmStrikeDamage, self.origin, attacker, attacker, "none", mod, 0, GetWeapon( "napalm" )   );

		wait(1);
	}
}

function doNapalmGroundDamage(attacker, inflictor, mod)
{
	if ( self hasperk( "specialty_fireproof" ) )
		return;
	
	if ( level.teambased )
	{
		if( attacker != self && attacker.team == self.team )
			return;
	}

	if ( isai(self) )
	{
		doDogNapalmGroundDamage(attacker, inflictor, mod);
		return;
	}	

	if ( isdefined( self.burning ) )
		return;

	self thread burn_blocker();
	self endon ( "death" );
	self endon("disconnect");
	attacker endon("disconnect");
	self endon("stop burn damage");

	if (isdefined (level.groundBurnTime))
	{
		if (GetDvarString( "scr_groundBurnTime") == "")
		{
			waittime = level.groundBurnTime;
		}
		else
		{
			waittime = GetDvarfloat( "scr_groundBurnTime");
		}
	}
	else
		waittime = 100;
	
	self walkedThroughFlames( attacker, inflictor, GetWeapon( "napalm" ) );

	self.inGroundNapalm = true;
	
	if (isdefined ( level.napalmGroundDamage) )
	{
		if (GetDvarString( "scr_napalmGroundDamage") == "")
		{
			napalmGroundDamage = level.napalmGroundDamage;
		}
		else
		{
			napalmGroundDamage = GetDvarfloat( "scr_napalmGroundDamage");
		}
		while ( isdefined( self ) && isdefined( inflictor ) && ((self DepthOfPlayerInWater()) < 1) && waittime > 0 ) 
		{
			self DoDamage( level.napalmGroundDamage, self.origin, attacker, inflictor, "none", mod, 0, GetWeapon( "napalm" )   );
			if ( isplayer( self ) )
				self setburn( 1.1 );
			wait( 1 );
			waittime = waittime - 1;
		}
	}
	
	self.inGroundNapalm = false;
}


//doDogIncendiaryDamage(attacker, inflictor, mod)
//{
//	attacker endon("disconnect");
//	self endon( "death" );
//	self endon("stop burn damage");
//	 
//	while ( (isdefined ( level.incendiaryFireDamage) ) && (isdefined (self)))
//	{
//		self DoDamage( level.incendiaryFireDamage, self.origin, attacker, attacker, "none", mod, 0, GetWeapon( "incendiary_grenade" ) );
//
//		wait(1);
//	}
//}

//doDogIncendiaryGroundDamage(attacker, inflictor, mod)
//{
//	attacker endon("disconnect");
//	self endon( "death" );
//	self endon("stop burn damage");
//
//	while ( (isdefined ( level.incendiaryFireDamage) ) && (isdefined (self)))
//	{
//		self DoDamage( level.incendiaryFireDamage, self.origin, attacker, attacker, "none", mod, 0, GetWeapon( "incendiary_grenade" )  );
//
//		wait(1);
//	}
//}

function doDogNapalmStrikeDamage(attacker, inflictor, mod)
{
	attacker endon("disconnect");
	self endon( "death" );
	self endon("stop burn damage");
	 
	while ( (isdefined ( level.napalmStrikeDamage) ) && (isdefined (self)))
	{
		self DoDamage( level.napalmStrikeDamage, self.origin, attacker, attacker, "none", mod  );

		wait(1);
	}
}

function doDogNapalmGroundDamage(attacker, inflictor, mod)
{
	attacker endon("disconnect");
	self endon( "death" );
	self endon("stop burn damage");
	 
	while ( (isdefined ( level.napalmGroundDamage) ) && (isdefined (self)))
	{
		self DoDamage( level.napalmGroundDamage, self.origin, attacker, attacker, "none", mod, 0, GetWeapon( "napalm" )  );

		wait(1);
	}
}


function burn_blocker()
{
	self endon("disconnect");
	self endon ( "death" );
	
	wait( 3 );
	
	self.burning = undefined;
}

function doFlameDamage( attacker, inflictor, weapon, time )
{
	if ( IsAI(self) )
	{
		doDogFlameDamage( attacker, inflictor, weapon, time );
		return;
	}	

	if( isdefined( attacker ) )
		attacker endon("disconnect");

	self endon( "death" );
	self endon("disconnect");
	self endon("stop burn damage");

	self thread doBurningSound ();
	self notify ("snd_burn_scream");

	wait_time = 1.0;
	while ( isdefined( level.flameDamage ) && isdefined( self ) && ( self DepthOfPlayerInWater() < 1 ) && time > 0 )
	{
		if( isdefined( attacker ) && isdefined( inflictor ) && isdefined( weapon ) )
		{
			if( damagefeedback::doDamageFeedback( weapon, attacker ) )
				attacker damagefeedback::update();

			self DoDamage( level.flameDamage, self.origin, attacker, inflictor, "none", "MOD_BURNED", 0, weapon );
		}
		else
		{
			self DoDamage( level.flameDamage, self.origin );
		}

		wait( wait_time );
		time -= wait_time;
	}

	self thread finish_burn();
}

function doDogFlameDamage( attacker, inflictor, weapon, time )
{
	if( !isdefined( attacker ) || !isdefined( inflictor ) || !isdefined( weapon ) )
		return;

	attacker endon("disconnect");
	self endon( "death" );
	self endon("stop burn damage");

	self thread doBurningSound ();

	wait_time = 1.0;
	while ( isdefined( level.flameDamage ) && isdefined( self ) && time > 0 )
	{
		self DoDamage( level.flameDamage, self.origin, attacker, inflictor, "none", "MOD_BURNED", 0, weapon );

		wait( wait_time );
		time -= wait_time;
	}
}

function waitThenStopTanning( time )
{
	self endon("disconnect");
	self endon("death");
	
	wait( time );	
	self _stopBurning();
}
function doBurningSound ()
{
	self endon("disconnect");
	self endon("death");
	
	//self playsound ("mpl_player_burn");
	
	fire_sound_ent = spawn( "script_origin", self.origin );
	fire_sound_ent linkto( self, "tag_origin", (0,0,0), (0,0,0) );
	fire_sound_ent playloopsound ("mpl_player_burn_loop");
	
	self thread fireSoundDeath(fire_sound_ent);
	
	self waittill ("StopBurnSound");
	
	if ( isdefined (fire_sound_ent))
		fire_sound_ent StopLoopSound( 0.5 );
		wait .5;
	if ( isdefined (fire_sound_ent))
		fire_sound_ent delete();
	/#	println ("sound stop burning");	#/
	
	//self playloopsound ("mpl_player_burn_loop");
	//self waittill ("StopBurnSound");
	//self StopLoopSound( 0.5 );
	
}
function _stopBurning()
{
	self endon("disconnect");
	
	self notify ("StopBurnSound");
}	
function fireSoundDeath(ent)
{
		ent endon("death");
		
		self util::waittill_any( "death", "disconnect" );
		
		//ent unlink();
		//ent StopLoopSound( 0.5 );
		//wait .5;
		
		ent delete();
	/#	println ("sound delete burning");	#/
}	
	

// AE 10-20-09: added this so that players who walk through the fire will burn
// TODO: finish this, i stole it from napalm
//watchIncendiaryBurn( owner, eInflictor, pos, burnEffectRadius )
//{	
//	groundBurnArea = spawn("trigger_radius", pos, 0, burnEffectRadius, burnEffectRadius*2);
//	loopWaitTime = 0.25;
//
//
//	burnDuration =  GetDvarInt( "scr_burnIncendiaryDuration", level.burnIncendiaryDuration);
//
//	burnDist2 = burnEffectRadius * burnEffectRadius;
//
//	while ( burnDuration > 0 )
//	{
//		players = GetPlayers();
//		for (i = 0; i < players.size; i++)
//		{	
//			if (!isdefined(players[i].item))
//			{
//				players[i].item = 0;
//			}	
//
//			if ( ( !isdefined ( players[i].inGroundIncendiary ) )  || ( players[i].inGroundIncendiary == false ) )
//			{
//				if (players[i].sessionstate == "playing" )
//				{
//					///#
//					//	if ( GetDvarString( "scr_napalmdebug") == "1" )
//					//		debugstar(pos, 1000);
//					//#/
//
//					dist2 = DistanceSquared( players[i].origin, pos );
//					if ( dist2 < burnDist2 )
//					{
//						//if (players[i] damageConeTrace( pos, players[i], eInflictor) > 0)
//						//{
//						players[i].incendiarylastburntby = owner;
//						players[i] thread burnplayer::doIncendiaryGroundDamage(owner, eInflictor, "MOD_BURNED" );
//						//}
//					}
//				}	
//			}
//
//		}
//		wait (loopWaitTime);
//		burnDuration -= loopWaitTime;
//	}
//
//	groundBurnArea delete();	
//}

