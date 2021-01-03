#using scripts\codescripts\struct;

#using scripts\shared\util_shared;

    	   	                                                                                                                         	                                                                                                                                                                                                                                                                                                                                                                    	        	     	             	    	   	                           	                               	                                	                                                              	                                                                                                              	                            	                                     	                                       	                                                               	   	                  	       	                                                    	                   	                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                       	                                                                                        	           	                        	                                            	                                             	                                                   	                                                             	                                                         	                                                                    	                                                                                                                                                                                                    	                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                     	                                                              	                                                          	                                   	                                   	                                                    	                                       

#using scripts\zm\_zm_stats;





#precache( "model", "t6_wpn_ballistic_knife_projectile" );



function init()
{
	if (!IsDefined(level.ballistic_knife_autorecover))
		level.ballistic_knife_autorecover=1;

}

function on_spawn( watcher, player )
{
	player endon( "death" );
	player endon( "disconnect" );
	player endon( "zmb_lost_knife" ); // occurs when the player gives up or changes the type of ballistic_knife they are carrying
	level endon( "game_ended" );

	self waittill( "stationary", endpos, normal, angles, attacker, prey, bone );
	
	isFriendly = false;

	if( isdefined(endpos) )
	{
		// once the missile dies, spawn a model there to be retrieved
		retrievable_model = spawn( "script_model", endpos );
		retrievable_model SetModel( "t6_wpn_ballistic_knife_projectile" );
		retrievable_model SetOwner( player );
		retrievable_model.owner = player;
		retrievable_model.angles = angles;
		retrievable_model.weapon = watcher.weapon;

		if( isdefined( prey ) )
		{
			//Don't stick to teammates and friendly dogs
			if( isPlayer(prey) && player.team == prey.team )
				isFriendly = true;
			else if( isAI(prey) && player.team == prey.team)
				isFriendly = true;

			if( !isFriendly )
			{
				retrievable_model LinkTo( prey, bone );
				retrievable_model thread force_drop_knives_to_ground_on_death( player, prey );
			}
			else if( isFriendly )
			{
				//launchVec = normal * -1;
				retrievable_model physicslaunch( normal, (randomint(10),randomint(10),randomint(10)) );

				//Since the impact normal is not what we want anymore, and the knife will fall to the ground, send the world up normal.
				normal = (0,0,1);
			}

		}

		watcher.objectArray[watcher.objectArray.size] = retrievable_model;

		//Wait until the model is stationary again
		if( isFriendly )
		{
			retrievable_model waittill( "stationary");
		}

		retrievable_model thread drop_knives_to_ground( player );

		if ( isFriendly )
		{
			player notify( "ballistic_knife_stationary", retrievable_model, normal );
		}
		else
		{
			player notify( "ballistic_knife_stationary", retrievable_model, normal, prey );
		}

		retrievable_model thread wait_to_show_glowing_model( prey );
	}
}

function wait_to_show_glowing_model( prey ) // self == retrievable_model
{
	level endon( "game_ended" );
	self endon( "death" );

//	glowing_retrievable_model = spawn( "script_model", self.origin );
//	self.glowing_model = glowing_retrievable_model;
//	glowing_retrievable_model.angles = self.angles;
//	glowing_retrievable_model LinkTo( self );

	// we don't want to show the glowing retrievable model until the ragdoll finishes, this will keep the glow out of the kill cam
//	if( isdefined( prey ) )
//	{
		wait( 2 );
//	}

	self SetModel( "t6_wpn_ballistic_knife_projectile" );
}

function on_spawn_retrieve_trigger( watcher, player )
{
	player endon( "death" );
	player endon( "disconnect" );
	player endon( "zmb_lost_knife" ); // occurs when the player gives up or changes the type of ballistic_knife they are carrying
	level endon( "game_ended" );

	player waittill( "ballistic_knife_stationary", retrievable_model, normal, prey );

	if( !isdefined( retrievable_model ) )
		return;

	const vec_scale = 10;
	trigger_pos = [];
	if ( isdefined( prey ) && ( isPlayer( prey ) || isAI( prey ) ) )
	{
		trigger_pos[0] = prey.origin[0];
		trigger_pos[1] = prey.origin[1];
		trigger_pos[2] = prey.origin[2] + vec_scale;
	}
	else
	{
		trigger_pos[0] = retrievable_model.origin[0] + (vec_scale * normal[0]);
		trigger_pos[1] = retrievable_model.origin[1] + (vec_scale * normal[1]);
		trigger_pos[2] = retrievable_model.origin[2] + (vec_scale * normal[2]);
	}
	if (( isdefined( level.ballistic_knife_autorecover ) && level.ballistic_knife_autorecover ))
	{
		trigger_pos[2] -= 100 / 2;
		pickup_trigger = Spawn( "trigger_radius", (trigger_pos[0], trigger_pos[1], trigger_pos[2]), 0, 50, 100 );
	}
	else
	{
		pickup_trigger = Spawn( "trigger_radius_use", (trigger_pos[0], trigger_pos[1], trigger_pos[2]) );
		pickup_trigger SetCursorHint( "HINT_NOICON" );
	}
	pickup_trigger.owner = player;
	retrievable_model.retrievableTrigger = pickup_trigger;


	//retrievable_model thread debug_print( endpos );

	hint_string = &"WEAPON_BALLISTIC_KNIFE_PICKUP";
	if( isdefined( hint_string ) )
	{
		pickup_trigger SetHintString( hint_string );
	}
	else
	{
		pickup_trigger SetHintString( &"GENERIC_PICKUP" );
	}


	pickup_trigger SetTeamForTrigger( player.team );
	
	player ClientClaimTrigger( pickup_trigger );

	// link the model and trigger, then link them to the ragdoll if needed
	pickup_trigger EnableLinkTo();
	if ( isdefined( prey ) )
	{
		pickup_trigger LinkTo( prey );
	}
	else
	{
		pickup_trigger LinkTo( retrievable_model );
	}

	if (isdefined(level.knife_planted))
		[[level.knife_planted]]( retrievable_model, pickup_trigger, prey );
	
	retrievable_model thread watch_use_trigger( pickup_trigger, retrievable_model,&pick_up, watcher.weapon, watcher.pickUpSoundPlayer, watcher.pickUpSound );
	player thread watch_shutdown( pickup_trigger, retrievable_model );
}

function debug_print( endpos )
{
	/#
	self endon( "death" );
	while( true )
	{
		Print3d( endpos, "pickup_trigger" );
		{wait(.05);};
	}
	#/
}

function watch_use_trigger( trigger, model, callback, weapon, playerSoundOnUse, npcSoundOnUse ) // self == retrievable_model
{
	self endon( "death" );
	self endon( "delete" );
	level endon ( "game_ended" );

	max_ammo = weapon.maxAmmo + 1;
	
	autorecover = ( isdefined( level.ballistic_knife_autorecover ) && level.ballistic_knife_autorecover );
	while ( true )
	{
		trigger waittill( "trigger", player );

		if ( !IsAlive( player ) )
			continue;

		if ( !player IsOnGround() && !( isdefined( trigger.force_pickup ) && trigger.force_pickup ) )
			continue;

		if ( isdefined( trigger.triggerTeam ) && ( player.team != trigger.triggerTeam ) )
			continue;

		if ( isdefined( trigger.claimedBy ) && ( player != trigger.claimedBy ) )
			continue;

		ammo_stock = player GetWeaponAmmoStock( weapon );
		ammo_clip = player GetWeaponAmmoClip( weapon );
		current_weapon = player GetCurrentWeapon();
		total_ammo = ammo_stock + ammo_clip;
		
		// see if this player hasn't reloaded yet, we make this check so you can't pick it up before your stock ammo has updated
		//	if your stock ammo hasn't updated then you'll take it but you won't get it in your reserves, it just goes away
		hasReloaded = true;
		if( total_ammo > 0 && ammo_stock == total_ammo && current_weapon == weapon )
		{
			hasReloaded = false;
		}

		if( total_ammo >= max_ammo || !hasReloaded )
			continue;
		
		if ( autorecover || ( player UseButtonPressed() && !player.throwingGrenade && !player meleeButtonPressed() ) || ( isdefined( trigger.force_pickup ) && trigger.force_pickup ) )
		{
			if ( isdefined( playerSoundOnUse ) )
				player playLocalSound( playerSoundOnUse );
			if ( isdefined( npcSoundOnUse ) )
				player playSound( npcSoundOnUse );
			player thread [[callback]]( weapon, model, trigger );
			break;
		}
	}
}

function pick_up( weapon, model, trigger ) // self == player
{
	if ( self HasWeapon(weapon) )
	{
		// if we're not currently on the ballistic knife and the clip is empty then put the ammo in the clip
		current_weapon = self GetCurrentWeapon();
		if( current_weapon != weapon )
		{
			// if the clip is empty, fill it
			clip_ammo = self GetWeaponAmmoClip( weapon );
			if( !clip_ammo )
			{
				self SetWeaponAmmoClip( weapon , 1 );
			}
			else
			{
				new_ammo_stock = self GetWeaponAmmoStock( weapon ) + 1;
				self SetWeaponAmmoStock( weapon , new_ammo_stock );		
			}
		}
		else
		{
			new_ammo_stock = self GetWeaponAmmoStock( weapon ) + 1;
			self SetWeaponAmmoStock( weapon, new_ammo_stock );		
		}
	}
	
	//stat tracking
	self zm_stats::increment_client_stat( "ballistic_knives_pickedup" );
	self zm_stats::increment_player_stat( "ballistic_knives_pickedup" );

	model destroy_ent();
	trigger destroy_ent();
}

function destroy_ent()
{
	if( isdefined(self) )
	{
		if( isdefined( self.glowing_model  ) )
		{
			self.glowing_model delete();
		}

		self delete();
	}
}

function watch_shutdown( trigger, model ) // self == player
{
	self util::waittill_any( "death", "disconnect", "zmb_lost_knife" );  // "zmb_lost_knife", occurs when the player gives up or changes the type of ballistic_knife they are carrying

	trigger destroy_ent();
	model destroy_ent();
}

function drop_knives_to_ground( player )
{
	player endon("death");
	player endon( "zmb_lost_knife" ); // occurs when the player gives up or changes the type of ballistic_knife they are carrying

	for( ;; )
	{
		level waittill( "drop_objects_to_ground", origin, radius );
		if( DistanceSquared( origin, self.origin )< radius * radius )
		{
			self physicslaunch( (0,0,1), (5,5,5));
			self thread update_retrieve_trigger( player );
		}
	}
}

function force_drop_knives_to_ground_on_death( player, prey )
{
	self endon("death");
	player endon( "zmb_lost_knife" ); // occurs when the player gives up or changes the type of ballistic_knife they are carrying

	prey waittill( "death" );
	self Unlink();
	self physicslaunch( (0,0,1), (5,5,5));
	self thread update_retrieve_trigger( player );
}

function update_retrieve_trigger( player )
{
	self endon("death");
	player endon( "zmb_lost_knife" ); 
	
	// occurs when the player gives up or changes the type of ballistic_knife they are carrying
	if( isdefined( level.custom_update_retrieve_trigger ) )
	{
		self [[level.custom_update_retrieve_trigger]]( player );
		return;
	}

	self waittill( "stationary");

	trigger = self.retrievableTrigger;

	trigger.origin = ( self.origin[0], self.origin[1], self.origin[2] + 10 );
	trigger LinkTo( self );
}
