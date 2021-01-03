#using scripts\codescripts\struct;

#using scripts\shared\callbacks_shared;
#using scripts\shared\challenges_shared;
#using scripts\shared\clientfield_shared;
#using scripts\shared\system_shared;
#using scripts\shared\weapons\_weaponobjects;

    	   	                                                                                                                         	                                                                                                                                                                                                                                                                                                                                                                    	        	     	             	    	   	                           	                               	                                	                                                              	                                                                                                              	                            	                                     	                                       	                                                               	   	                  	       	                                                    	                   	                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                        	                                                                                        	           	                        	                                            	                                             	                                                   	                                                             	                                                         	                                                                    	                                                                                                                                                                                                    	                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                      	                                                              	                                                          	                                   	                                   	                                                    	                                       



	
#namespace ballistic_knife;

function init_shared()
{
	callback::add_weapon_watcher( &createBallisticKnifeWatcher );
}

function onSpawn( watcher, player )
{
	player endon( "death" );
	player endon( "disconnect" );
	level endon( "game_ended" );

	self waittill( "stationary", endpos, normal, angles, attacker, prey, bone );

	isFriendly = false;

	if( isdefined(endpos) )
	{
		// once the missile dies, spawn a model there to be retrieved
		retrievable_model = spawn( "script_model", endpos );
		retrievable_model SetModel( "t6_wpn_ballistic_knife_projectile" );
		retrievable_model SetTeam( player.team );
		retrievable_model SetOwner( player );
		retrievable_model.owner = player;
		retrievable_model.angles = angles;
		retrievable_model.name = watcher.weapon;
		retrievable_model.targetname = "sticky_weapon";

		if( isdefined( prey ) )
		{
			//Don't stick to teammates and friendly dogs
			if( level.teamBased && player.team == prey.team )
				isFriendly = true;
			
			if( !isFriendly )
			{
				if( IsAlive( prey ) )
				{
					retrievable_model dropToGround( retrievable_model.origin, 80 );
				}
				else
				{
					retrievable_model LinkTo( prey, bone );
				}
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
			retrievable_model waittill( "stationary");

		retrievable_model thread dropKnivesToGround();

		if ( isFriendly )
			player notify( "ballistic_knife_stationary", retrievable_model, normal );
		else
			player notify( "ballistic_knife_stationary", retrievable_model, normal, prey );
	}
}

function watch_shutdown() // self == retrievable_model
{
	pickUpTrigger = self.pickUpTrigger;

	self waittill( "death" );

	if( isdefined( pickUpTrigger ) )
		pickUpTrigger delete();
}

function onSpawnRetrieveTrigger( watcher, player )
{
	player endon( "death" );
	player endon( "disconnect" );
	level endon( "game_ended" );

	player waittill( "ballistic_knife_stationary", retrievable_model, normal, prey );

	if( !isdefined( retrievable_model ) )
		return;

	vec_scale = 10;
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

	// center the retrieve trigger so that triggers above the players head are reachable
	// trigger_radius spawn types set the base at the origin and extend to the height param
	trigger_pos[2] -= 100 / 2;

	retrievable_model clientfield::set( "retrievable", 1 );
	
	pickup_trigger = spawn( "trigger_radius", (trigger_pos[0], trigger_pos[1], trigger_pos[2]), 0, 50, 100 );
	pickup_trigger.owner = player;

	retrievable_model.pickUpTrigger = pickup_trigger;

	// link the model and trigger, then link them to the ragdoll if needed
	pickup_trigger EnableLinkTo();

	if ( isdefined( prey ) )
		pickup_trigger LinkTo( prey );
	else
		pickup_trigger LinkTo( retrievable_model );

	retrievable_model thread watch_use_trigger( pickup_trigger, retrievable_model,&pick_up, watcher.pickUpSoundPlayer, watcher.pickUpSound );
	retrievable_model thread watch_shutdown();
}

function watch_use_trigger( trigger, model, callback, playerSoundOnUse, npcSoundOnUse ) // self == retrievable_model
{
	self endon( "death" );
	self endon( "delete" );
	level endon ( "game_ended" );

	// need to add 1 to max ammo because the ballistic knife has a max ammo of 1 but can hold 1 in the clip and 1 in the stock
	//	there's something janky in the code so if we do 2 max ammo then players could pick up 3 and we only want them to have 2
	max_ammo = level.weaponBallisticKnife.maxAmmo + 1;

	while ( true )
	{
		trigger waittill( "trigger", player );

		if ( !IsAlive( player ) )
			continue;

		if ( !player IsOnGround() )
			continue;

		if ( isdefined( trigger.triggerTeam ) && ( player.team != trigger.triggerTeam ) )
			continue;

		if ( isdefined( trigger.claimedBy ) && ( player != trigger.claimedBy ) )
			continue;

		if ( !player HasWeapon( level.weaponBallisticKnife ) )
			continue;

		ammo_stock = player GetWeaponAmmoStock( level.weaponBallisticKnife );
		ammo_clip = player GetWeaponAmmoClip( level.weaponBallisticKnife );
		current_weapon = player GetCurrentWeapon();
		total_ammo = ammo_stock + ammo_clip;
		
		// see if this player hasn't reloaded yet, we make this check so you can't pick it up before your stock ammo has updated
		//	if your stock ammo hasn't updated then you'll take it but you won't get it in your reserves, it just goes away
		hasReloaded = true;
		if( total_ammo > 0 && ammo_stock == total_ammo && current_weapon == level.weaponBallisticKnife )
		{
			hasReloaded = false;
		}

		if( total_ammo >= max_ammo || !hasReloaded )
			continue;

		if ( isdefined( playerSoundOnUse ) )
			player playLocalSound( playerSoundOnUse );
		if ( isdefined( npcSoundOnUse ) )
			player playSound( npcSoundOnUse );

		self thread [[callback]]( player );
		break;
	}
}

function pick_up( player ) // self == retrievable_model
{
	self destroy_ent();

	// if we're not currently on the ballistic knife and the clip is empty then put the ammo in the clip
	current_weapon = player GetCurrentWeapon();
	player challenges::pickedUpBallisticKnife();
	if( current_weapon != level.weaponBallisticKnife )
	{
		// if the clip is empty, fill it
		clip_ammo = player GetWeaponAmmoClip( level.weaponBallisticKnife );
		if( !clip_ammo )
		{
			player SetWeaponAmmoClip( level.weaponBallisticKnife, 1 );
		}
		else
		{
			new_ammo_stock = player GetWeaponAmmoStock( level.weaponBallisticKnife ) + 1;
			player SetWeaponAmmoStock( level.weaponBallisticKnife, new_ammo_stock );		
		}
	}
	else
	{
		new_ammo_stock = player GetWeaponAmmoStock( level.weaponBallisticKnife ) + 1;
		player SetWeaponAmmoStock( level.weaponBallisticKnife, new_ammo_stock );		
	}
}

function destroy_ent()
{
	if( isdefined(self) )
	{
		pickUpTrigger = self.pickUpTrigger;

		if( isdefined( pickUpTrigger ) )
			pickUpTrigger delete();

		self delete();
	}
}

function dropKnivesToGround()
{
	self endon("death");

	for( ;; )
	{
		level waittill( "drop_objects_to_ground", origin, radius );
		self dropToGround( origin, radius );
	}
}

function dropToGround( origin, radius )
{
	if( DistanceSquared( origin, self.origin )< radius * radius )
	{
		self physicslaunch( (0,0,1), (5,5,5));
		self thread updateRetrieveTrigger();
	}
}

function updateRetrieveTrigger()
{
	self endon("death");

	self waittill( "stationary");

	trigger = self.pickUpTrigger;

	trigger.origin = ( self.origin[0], self.origin[1], self.origin[2] + 10 );
	trigger LinkTo( self );
}

function createBallisticKnifeWatcher() // self == player
{
	watcher = self weaponobjects::createUseWeaponObjectWatcher( "knife_ballistic", self.team );
	watcher.onSpawn = &onSpawn;
	watcher.onDetonateCallback =&weaponobjects::deleteEnt;
	watcher.onSpawnRetrieveTriggers = &onSpawnRetrieveTrigger;
	watcher.storeDifferentObject = true;
}
