#using scripts\codescripts\struct;

#using scripts\shared\callbacks_shared;
#using scripts\shared\system_shared;
#using scripts\shared\util_shared;
#using scripts\shared\weapons\_weaponobjects;

    	   	                                                                                                                         	                                                                                                                                                                                                                                                                                                                                                                    	        	     	             	    	   	                           	                               	                                	                                                              	                                                                                                              	                            	                                     	                                       	                                                               	   	                  	       	                                                    	                   	                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                       	                                                                                        	           	                        	                                            	                                             	                                                   	                                                             	                                                         	                                                                    	                                                                                                                                                                                                    	                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                     	                                                              	                                                          	                                   	                                   	                                                    	                                       

#using scripts\zm\_zm_buildables;
#using scripts\zm\_zm_buildables_pooled;
#using scripts\zm\_zm_equipment;
#using scripts\zm\_zm_power;
#using scripts\zm\_zm_unitrigger;
#using scripts\zm\_zm_utility;

                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                             	                             






//#define BUILDER_MODEL "p7_door_metal_industrial_grey"	

	
#precache( "fx", "_t6/maps/zombie/fx_zmb_tranzit_wind_turbine_on" );
#precache( "fx", "_t6/maps/zombie/fx_zmb_tranzit_wind_turbine_med" );
#precache( "fx", "_t6/maps/zombie/fx_zmb_tranzit_wind_turbine_low" );
#precache( "fx", "_t6/maps/zombie/fx_zmb_tranzit_wind_turbine_aoe" );
#precache( "fx", "_t6/maps/zombie/fx_zmb_tranzit_turbine_explo" );

#namespace zm_equip_builder;

function autoexec __init__sytem__() {     system::register("zm_equip_builder",&__init__,&__main__,undefined);    }
	
function __init__()
{
	hint=&"ZOMBIE_EQUIP_TURBINE_PICKUP_HINT_STRING";
	howto=&"ZOMBIE_EQUIP_TURBINE_HOWTO";
	level.weaponZMEquipBuilder = GetWeapon( "equip_builder" );
	name = level.weaponZMEquipBuilder.name;

	zm_equipment::register( name, hint, howto, "turbine_zm_icon", "builder", undefined, &transferTurbine, &dropTurbine, &pickupTurbine, &placeTurbine );
	zm_equipment::add_placeable( name, "p_zom_moon_mine_airlock_door03_single", &destroy_placed_turbine );
	zm_equipment::set_ammo_driven( name, 32 );

	callback::on_connecting( &on_player_connecting );
	
	weaponobjects::createRetrievableHint("equip_builder", hint);

	level._effect[ "turbine_on" ] = "_t6/maps/zombie/fx_zmb_tranzit_wind_turbine_on";
	level._effect[ "turbine_med" ] = "_t6/maps/zombie/fx_zmb_tranzit_wind_turbine_med";
	level._effect[ "turbine_low" ] = "_t6/maps/zombie/fx_zmb_tranzit_wind_turbine_low";
	level._effect[ "turbine_aoe" ] = "_t6/maps/zombie/fx_zmb_tranzit_wind_turbine_aoe";
	level._turbine_disappear_fx = "_t6/maps/zombie/fx_zmb_tranzit_turbine_explo";
}

function __main__()
{
	zm_equipment::register_for_level( "equip_builder" );
	zm_equipment::include( "equip_builder" );
}

function on_player_connecting()
{
	self thread setupWatchers();
	callback::on_spawned( &on_player_spawned );
}

function on_player_spawned()
{
	self endon( "disconnect" );

	self thread watchTurbineUse();
}

function setupWatchers()
{
	self waittill("weapon_watchers_created");
	
	watcher = weaponobjects::getWeaponObjectWatcher( level.weaponZMEquipBuilder.name );
	watcher.onSpawnRetrieveTriggers = &zm_equipment::on_spawn_retrievable_weapon_object; 
	//watcher.pickUp = &zm_equipment::retrieve;
}

function watchTurbineUse()
{
	self notify( "watchBuilderUse" );
	self endon( "watchBuilderUse" );
	self endon( "death" );
	self endon( "disconnect" );

	for ( ;; )
	{
		self waittill( "equipment_placed", equipment_instance, equipment );

		if ( equipment == level.weaponZMEquipBuilder )
		{
			//self cleanupOldTurbine();
			//self.buildableTurbine = equipment_instance;

			//self thread startTurbineDeploy( equipment_instance );
			
			level notify( "turbine_deployed" );
		}
	}
}

function cleanupOldTurbine( preserve_state )
{
	if (isdefined(self.localpower))
	{
		zm_power::end_local_power( self.localpower );
		self notify("depower_on_disconnect");
		self.localpower = undefined;
		self.turbine_power_is_on = 0;
	}
	self.turbine_is_powering_on = 0;
	if (isdefined(self.buildableTurbine))
	{
		if (isdefined(self.buildableTurbine.stub))
		{
			thread zm_unitrigger::unregister_unitrigger(self.buildableTurbine.stub);
			self.buildableTurbine.stub=undefined;
		}
		self.buildableTurbine StopLoopSound();
		self.buildableTurbine delete();
		if (!( isdefined( preserve_state ) && preserve_state ))
		{
			self.turbine_health = undefined;
			self.turbine_emped = undefined;
			self.turbine_emp_time = undefined;
		}
	}
}

function watchForCleanup()
{
	self notify("turbine_cleanup");
	self endon("turbine_cleanup");

	notify_strings = zm_equipment::get_notify_strings( level.weaponZMEquipBuilder );
	evt = self util::waittill_any_return( "death_or_disconnect", notify_strings.taken, notify_strings.pickup );
	if (isdefined(self))
		self cleanupOldTurbine( evt=="equip_turbine_zm_pickup" );
}

function depower_on_disconnect( localpower )
{
	self notify("depower_on_disconnect");
	self endon("depower_on_disconnect");
	
	self waittill( "disconnect" );
	if (isdefined(localpower))
		zm_power::end_local_power( localpower );
	
}

function placeTurbine(origin,angles) // self == player
{
	//angles = VectorToAngles( AnglesToRight( angles ) );
	item = self zm_equipment::placed_equipment_think( "p_zom_moon_mine_airlock_door03_single", level.weaponZMEquipBuilder, origin, angles );
	item Solid();
	return item;
}

function dropTurbine() // self == player
{
	return undefined;
	/*
	//item = self zm_equipment::placed_equipment_think( "p6_anim_zm_buildable_turbine", level.weaponZMEquipBuilder, self.origin, self.angles );
	//return item;
	item = thread zm_equipment::dropped_equipment_think( BUILDER_MODEL, level.weaponZMEquipBuilder, self.origin, self.angles );
	if (isdefined(item))
    {
		item.turbine_power_on=self.turbine_power_on;
		item.turbine_power_level=self.turbine_power_level;
		item.turbine_round_start=self.turbine_round_start;
		item.turbine_health=self.turbine_health;
		item.turbine_emped = self.turbine_emped;
		item.turbine_emp_time = self.turbine_emp_time;
    }
	self.turbine_is_powering_on = undefined;
	self.turbine_power_on = undefined;
	self.turbine_power_level = undefined;
	self.turbine_round_start = undefined;
	self.turbine_health = undefined;
	self.turbine_emped = undefined;
	self.turbine_emp_time = undefined;
	return item;
	*/
}

function pickupTurbine(item) // self == player
{
	item.owner = self;
	self.turbine_power_on=item.turbine_power_on;
	item.turbine_power_on = undefined;
	self.turbine_power_level=item.turbine_power_level;
	self.turbine_round_start=item.turbine_round_start;
	self.turbine_health = item.turbine_health;
	item.turbine_health = undefined;
	item.turbine_power_level = undefined;
	item.turbine_round_start = undefined;
	self.turbine_emped = item.turbine_emped;
	self.turbine_emp_time = item.turbine_emp_time;
	item.turbine_emped = undefined;
	item.turbine_emp_time = undefined;
	self.turbine_is_powering_on = undefined;
}

function transferTurbine( fromplayer, toplayer )
{
	notify_strings = zm_equipment::get_notify_strings( level.weaponZMEquipBuilder );

	while (( isdefined( toplayer.turbine_is_powering_on ) && toplayer.turbine_is_powering_on ) || ( isdefined( fromplayer.turbine_is_powering_on ) && fromplayer.turbine_is_powering_on ))
	{
		{wait(.05);};
	}
	if ( isdefined(fromplayer.buildableTurbine) && ( isdefined( fromPlayer.buildableTurbine.dying ) && fromPlayer.buildableTurbine.dying ) )
	{
		fromPlayer cleanupOldTurbine( false );
	}
	if ( isdefined(toplayer.buildableTurbine) && ( isdefined( toPlayer.buildableTurbine.dying ) && toPlayer.buildableTurbine.dying ) )
	{
		toPlayer cleanupOldTurbine( false );
	}

	buildableTurbine = toplayer.buildableTurbine;
	localpower = toplayer.localpower;
	turbine_power_on = toplayer.turbine_power_on;
	turbine_power_is_on = toplayer.turbine_power_is_on;
	turbine_power_level = toplayer.turbine_power_level;
	turbine_round_start = toplayer.turbine_round_start;
	turbine_health = toplayer.turbine_health;
	turbine_emped = toplayer.turbine_emped;
	turbine_emp_time = toplayer.turbine_emp_time;
	
	//assert(!isdefined(toplayer.buildableTurbine));
	toplayer.buildableTurbine = fromplayer.buildableTurbine;
	fromplayer.buildableTurbine = buildableTurbine;
	//assert(!isdefined(toplayer.localpower));
	toplayer.localpower = fromplayer.localpower;
	fromplayer.localpower = localpower;
	toplayer.turbine_power_on=fromplayer.turbine_power_on;
	fromplayer.turbine_power_on = turbine_power_on;
	toplayer.turbine_power_is_on=fromplayer.turbine_power_is_on;
	fromplayer.turbine_power_is_on = turbine_power_is_on;
	toplayer.turbine_power_level=fromplayer.turbine_power_level;
	toplayer.turbine_round_start=fromplayer.turbine_round_start;
	fromplayer.turbine_power_level = turbine_power_level;
	fromplayer.turbine_round_start = turbine_round_start;
	toplayer.turbine_health = fromplayer.turbine_health;
	fromplayer.turbine_health = turbine_health;

	toplayer.turbine_emped = fromplayer.turbine_emped;
	fromplayer.turbine_emped = turbine_emped;
	toplayer.turbine_emp_time = fromplayer.turbine_emp_time;
	fromplayer.turbine_emp_time = turbine_emp_time;
	toplayer.turbine_is_powering_on = undefined;
	fromplayer.turbine_is_powering_on = undefined;
	
	toplayer notify( notify_strings.taken );
	toplayer.buildableTurbine.original_owner = toplayer;
	toplayer thread startTurbineDeploy( toplayer.buildableTurbine );
	fromplayer notify( notify_strings.taken );
	if (isdefined( fromplayer.buildableTurbine ))
	{
		fromplayer thread startTurbineDeploy( fromplayer.buildableTurbine );
		fromplayer.buildableTurbine.original_owner = fromplayer;
		fromplayer.buildableTurbine.owner = fromplayer;
	}
	else
		fromplayer zm_equipment::release(level.weaponZMEquipBuilder);
}


function startTurbineDeploy( equipment_instance )
{
	notify_strings = zm_equipment::get_notify_strings( level.weaponZMEquipBuilder );

	self endon( "death" );
	self endon( "disconnect" );
	self endon( notify_strings.taken );

	//self thread watchForCleanup();

	origin = equipment_instance.origin;

	powerRadius = 335;

	if ( !IsDefined( self.turbine_health ) )
	{
		self.turbine_health = 1200;
		self.turbine_power_level = 4;
		self.turbine_power_on = true;
		self.turbine_is_powering_on = undefined;
	}
	if ( !IsDefined( self.turbine_round_start ) )
	{
		self.turbine_round_start = level.round_number;
		self.turbine_power_on = true;
	}

	self thread turbineDecay();
	self thread turbinePowerDiminish( origin, powerRadius );

	if ( IsDefined( equipment_instance ) )
	{
		/#
		self thread debugTurbine( powerRadius );
		#/

		self thread turbineAudio();
		self thread turbineAnim();
		self thread turbinePowerThink( equipment_instance, powerRadius );
		if ( ( isdefined( equipment_instance.equipment_can_move ) && equipment_instance.equipment_can_move ))
		{
			self thread turbinePowerMove(equipment_instance);
		}

		self thread zm_buildables::delete_on_disconnect( equipment_instance );

		// Wait For Turbine To Be Removed
		//-------------------------------
		equipment_instance waittill( "death" );

		self thread turbinePowerOff( origin, powerRadius );

		self notify("turbine_cleanup");
	}
}

function turbine_watch_for_emp(equipment_instance, powerRadius)
{
	notify_strings = zm_equipment::get_notify_strings( level.weaponZMEquipBuilder );

	self endon("death");
	self endon( "disconnect" );
	self endon( notify_strings.taken );
	self.buildableTurbine endon( "death" );
	if (!zm_utility::should_watch_for_emp())
		return;
	while (1)
	{
		level waittill("emp_detonate",origin,radius);
		if ( DistanceSquared( origin, self.buildableTurbine.origin) < radius * radius )
		{
			break;
		}
	}
	
	self.turbine_emped = 1;
	self.turbine_emp_time = GetTime();
	self notify( "turbine_power_change" );
}


function turbinePowerThink( equipment_instance, powerRadius )
{
	notify_strings = zm_equipment::get_notify_strings( level.weaponZMEquipBuilder );

	self endon( "death" );
	self endon( "disconnect" );
	self endon( notify_strings.taken );
	self.buildableTurbine endon( "death" );
	origin = equipment_instance.origin;

	self thread turbine_watch_for_emp(equipment_instance, powerRadius);
	
	if ( ( isdefined( self.turbine_power_on ) && self.turbine_power_on ) || ( isdefined( self.turbine_emped ) && self.turbine_emped ) )
	{
		self thread turbinePowerOn( origin, powerRadius );
	}

	while ( IsDefined( self.buildableTurbine ) )
	{
		self waittill( "turbine_power_change" );

		if ( ( isdefined( self.turbine_emped ) && self.turbine_emped ) )
		{
			self thread turbinePowerOff( origin, powerRadius );
			if (isdefined(equipment_instance))
				origin = equipment_instance.origin;
			self thread turbinePowerOn( origin, powerRadius );
		}
		else if ( !( isdefined( self.turbine_power_is_on ) && self.turbine_power_is_on ) )
		{
			self thread turbinePowerOff( origin, powerRadius );
		}
		else
		{
			if (isdefined(equipment_instance))
				origin = equipment_instance.origin;
			self thread turbinePowerOn( origin, powerRadius );
		}
	}
}

function turbinePowerMove( equipment_instance )
{
	notify_strings = zm_equipment::get_notify_strings( level.weaponZMEquipBuilder );

	self endon( "death" );
	self endon( "disconnect" );
	self endon( notify_strings.taken );
	self.buildableTurbine endon( "death" );
	origin = equipment_instance.origin;
	while( 1 )
	{
		if ( origin != equipment_instance.origin )
		{
			if (isdefined(self.localpower))
				self.localpower = zm_power::move_local_power( self.localpower, origin );
			origin = equipment_instance.origin;
		}
		wait 0.5;
	}
}


function turbineWarmup()
{
	if ( ( isdefined( self.turbine_emped ) && self.turbine_emped ) )
	{
		emp_time = level.zombie_vars["emp_perk_off_time"];
		now = GetTime();
		emp_time_left = emp_time - (( now - self.turbine_emp_time ) / 1000);
		if ( emp_time_left > 0 )
		{
			wait emp_time_left; 
		}
		self.turbine_emped = undefined;
		self.turbine_emp_time = undefined;
	}
	//PlayFXOnTag( level._effect[ "turbine_low" ]  , self.buildableTurbine, "tag_animate");
	self.buildableTurbine zm_equipment::signal_activated(3);
	wait .5; 
	//PlayFXOnTag( level._effect[ "turbine_med" ]  , self.buildableTurbine, "tag_animate");
	self.buildableTurbine zm_equipment::signal_activated(2);
	wait .5; 
	//PlayFXOnTag( level._effect[ "turbine_on" ]  , self.buildableTurbine, "tag_animate");
	self.buildableTurbine zm_equipment::signal_activated(1);
	wait .5; 
}

function turbinePowerOn( origin, powerRadius )
{
	notify_strings = zm_equipment::get_notify_strings( level.weaponZMEquipBuilder );

	self endon( "death" );
	self endon( "disconnect" );
	self endon( notify_strings.taken );
	self.buildableTurbine endon( "death" );
	if (!( isdefined( self.turbine_power_is_on ) && self.turbine_power_is_on ) && !( isdefined( self.turbine_is_powering_on ) && self.turbine_is_powering_on )&& !( isdefined( self.buildableTurbine.dying ) && self.buildableTurbine.dying ))
	{
		self.turbine_is_powering_on = 1;
		
		self.buildableTurbine PlayLoopSound( "zmb_turbine_loop", 2 );

		self turbineWarmup();
		
		if (isdefined(self.localpower))
			zm_power::end_local_power( self.localpower );
		self.localpower = undefined;
		self.turbine_power_is_on = 0;
		
		if ( !( isdefined( self.turbine_emped ) && self.turbine_emped ) )
		{
			self.localpower = zm_power::add_local_power( origin, powerRadius );
			self thread depower_on_disconnect( self.localpower );
			self.turbine_power_is_on=1;
			self thread turbineAudio();
		}
		self.turbine_is_powering_on = 0;
		self thread turbineFX();
		self thread turbineDecay();
	}
}

function turbinePowerOff( origin, powerRadius )
{
	if (( isdefined( self.turbine_power_is_on ) && self.turbine_power_is_on ))
	{
		if (isdefined(self.localpower))
			zm_power::end_local_power( self.localpower );
		self notify("depower_on_disconnect");
		self.localpower = undefined;
		self.turbine_power_is_on=0;
		self thread turbineAudio();
		if ( !( isdefined( self.buildableTurbine.dying ) && self.buildableTurbine.dying ) )
			self thread turbineAnim();
	}
}

function turbine_disappear_fx( origin, waittime )
{
	if (isdefined(waittime) && waittime > 0)
		wait waittime; 
	PlayFX( level._turbine_disappear_fx, origin); 
	if (isdefined(self.buildableTurbine))
		PlaySoundAtPosition( "zmb_turbine_explo", self.buildableTurbine.origin );
}

function turbineFXOnce( withAOE )
{
	if (isdefined(self) && isdefined(self.buildableTurbine) && ( isdefined( self.turbine_power_is_on ) && self.turbine_power_is_on ))
	{
		value = 0;
		
		switch ( self.turbine_power_level )
		{
			case 4: // Full Power
			case 3:
			{
				//PlayFXOnTag( level._effect[ "turbine_on" ]  , self.buildableTurbine, "tag_animate");
				
				value = 1;
				
			} break;
			case 2:
			{
				// PlayFXOnTag( level._effect[ "turbine_med" ]  , self.buildableTurbine, "tag_animate");
				
				value = 2;
			} break;
			case 1:
			{
				// PlayFXOnTag( level._effect[ "turbine_low" ]  , self.buildableTurbine, "tag_animate");
				
				value = 3;
			} break;
		}
		if (withAOE)
		{
			if ( ( isdefined( self.buildableTurbine.equipment_can_move ) && self.buildableTurbine.equipment_can_move ) && ( isdefined( self.buildableTurbine.move_parent.isMoving ) && self.buildableTurbine.move_parent.isMoving ) )
			{
				value |= 4;
			//	PlayFXOnTag( level._effect[ "turbine_aoe" ]  , self.buildableTurbine, "tag_animate");
			}
			else
			{
				value |= 8;
			//	PlayFX( level._effect[ "turbine_aoe" ], self.buildableTurbine.origin ); //+ (0,0,5)); //,( 0, RandomFloat( 360 ), 0 ) );
			}
			
			//self.buildableTurbine playsound( "zmb_turbine_pulse" );
		}
		
		if(value && isdefined(self.buildableTurbine) && ( isdefined( self.turbine_power_is_on ) && self.turbine_power_is_on ))
		{
			self.buildableTurbine thread zm_equipment::signal_activated(value);
		}
	}
}


function turbineFX()
{
	notify_strings = zm_equipment::get_notify_strings( level.weaponZMEquipBuilder );

	self endon( "disconnect" );
	self endon( notify_strings.taken );
	
	while (isdefined(self) && isdefined(self.buildableTurbine) && ( isdefined( self.turbine_power_is_on ) && self.turbine_power_is_on ))
	{
		self turbineFXOnce( true );
		wait 0.5;
		self turbineFXOnce( false );
		wait 0.5;
	}
}
	
function turbineAudio()
{
	if ( !IsDefined( self.buildableTurbine ) )
	{
		return;
	}
	
	if (!( isdefined( self.turbine_power_is_on ) && self.turbine_power_is_on ) || ( isdefined( self.turbine_emped ) && self.turbine_emped ) )
	{
		self.buildableTurbine stoploopsound();
		return;
	}
	
	self.buildableTurbine PlayLoopSound( "zmb_turbine_loop", 2 );
}

#using_animtree ( "zombie_turbine" );

function turbineAnim( wait_for_end )
{
	if ( !IsDefined( self.buildableTurbine ) )
	{
		return;
	}
	
	animLength = 0;
	
	self.buildableTurbine UseAnimTree( #animtree );
	if ( ( isdefined( self.buildableTurbine.dying ) && self.buildableTurbine.dying ) )
	{
		animLength = getAnimLength( %o_zombie_buildable_turbine_death );
		self.buildableTurbine SetAnim( %o_zombie_buildable_turbine_death );
	}
	else if ( /*!IS_TRUE(self.turbine_power_is_on) ||*/ ( isdefined( self.turbine_emped ) && self.turbine_emped ) )
	{
		self.buildableTurbine ClearAnim( %o_zombie_buildable_turbine_fullpower, 0 );
		return;
	}
	else
	{
		switch ( self.turbine_power_level )
		{
			case 4: // Full Power
			case 3:
			{
				animLength = getAnimLength( %o_zombie_buildable_turbine_fullpower );
				self.buildableTurbine SetAnim( %o_zombie_buildable_turbine_fullpower );
			} break;
			case 2:
			{
				animLength = getAnimLength( %o_zombie_buildable_turbine_halfpower );
				self.buildableTurbine SetAnim( %o_zombie_buildable_turbine_halfpower );
			} break;
			case 1:
			{
				animLength = getAnimLength( %o_zombie_buildable_turbine_neardeath );
				self.buildableTurbine SetAnim( %o_zombie_buildable_turbine_neardeath );
			} break;
		}
	}
	if (( isdefined( wait_for_end ) && wait_for_end ))
		wait animLength;
}

function turbineDecay()
{
	notify_strings = zm_equipment::get_notify_strings( level.weaponZMEquipBuilder );

	self notify( "turbineDecay" );
	self endon( "turbineDecay" );
	self endon( "death" );
	self endon( "disconnect" );
	self endon( notify_strings.taken );
	self.buildableTurbine endon( "death" );

	roundLives = 4;

	if (!isdefined(self.turbine_power_level))
		self.turbine_power_level = roundLives;

	while ( self.turbine_health > 0 ) 
	{
		old_power_level = self.turbine_power_level;
		
		if ( ( isdefined( self.turbine_emped ) && self.turbine_emped ) && !!( isdefined( self.turbine_is_powering_on ) && self.turbine_is_powering_on ))
		{
			emp_time = level.zombie_vars["emp_perk_off_time"];
			now = GetTime();
			emp_time_left = emp_time - (( now - self.turbine_emp_time ) / 1000);
			if ( emp_time_left <= 0 )
			{
				self.turbine_emped = undefined;
				self.turbine_emp_time = undefined;
				self.turbine_power_is_on = false;
				old_power_level = -1;
			}
		}
	
		if ( ( isdefined( self.turbine_emped ) && self.turbine_emped ) )
		{
			self.turbine_power_level = 0;
		}
		else if ( ( isdefined( self.turbine_power_is_on ) && self.turbine_power_is_on )  )
		{
			cost = 1;
			if (isdefined(self.localpower))
				cost += zm_power::get_local_power_cost( self.localpower );

			self.turbine_health -= cost;
			
			if ( self.turbine_health < 200 )
				self.turbine_power_level = 1;
			else if ( self.turbine_health < 600 )
				self.turbine_power_level = 2;
			else
				self.turbine_power_level = 4;
	
		}
		if ( old_power_level != self.turbine_power_level )
		{
			self notify( "turbine_power_change" );
			self thread turbineAudio();
			if ( !( isdefined( self.buildableTurbine.dying ) && self.buildableTurbine.dying ) )
				self thread turbineAnim();
		}

		wait 1;
	}

	self destroy_placed_turbine();
	
	if (isdefined(self.buildableTurbine))
	{
		turbine_disappear_fx( self.buildableTurbine.origin );
	}

	self thread wait_and_take_equipment();
	self.turbine_health = undefined;
	self.turbine_power_level = undefined;
	self.turbine_round_start = undefined;
	self.turbine_power_on = undefined;
	self.turbine_emped = undefined;
	self.turbine_emp_time = undefined;
	self cleanupOldTurbine();
	/*
	if ( IsDefined( self.buildableTurbine ) )
	{
		self.buildableTurbine StopLoopSound();
		self.buildableTurbine Delete();
	}
	*/
}

function destroy_placed_turbine()
{
	if (isdefined(self.buildableTurbine) )
	{
		if ( ( isdefined( self.buildableTurbine.dying ) && self.buildableTurbine.dying ) )
		{
			while (isdefined(self.buildableTurbine))
				{wait(.05);};
			return;
		}
		
		if (isdefined(self.buildableTurbine.stub))
			thread zm_unitrigger::unregister_unitrigger(self.buildableTurbine.stub);
		
		thread turbine_disappear_fx( self.buildableTurbine.origin, 0.75 );
		self.buildableTurbine.dying = 1;
		self turbineAnim( true );
	}
}

function wait_and_take_equipment()
{
	{wait(.05);};
	self thread zm_equipment::release(level.weaponZMEquipBuilder);
}

function turbinePowerDiminish( origin, powerRadius )
{
	notify_strings = zm_equipment::get_notify_strings( level.weaponZMEquipBuilder );

	self endon( "death" );
	self endon( "disconnect" );
	self endon( notify_strings.taken );
	self.buildableTurbine endon( "death" );

	while ( !( isdefined( self.buildableTurbine.dying ) && self.buildableTurbine.dying ) )
	{
		if ( IsDefined( self.turbine_power_level ) && IsDefined( self.buildableTurbine ) )
		{
			switch ( self.turbine_power_level )
			{
				case 4: // Full Power
				{
				} break;
				case 3:
				{
				} break;
				case 2:
				{
					self.turbine_power_on = true;

					wait ( RandomIntRange( 12, 20 ) );
					self turbinePowerOff( origin, powerRadius );

					self.turbine_power_on = false;

					wait ( RandomIntRange( 3, 8 ) );
					self turbinePowerOn( origin, powerRadius );
				} break;
				case 1:
				{
					self.turbine_power_on = true;

					wait ( RandomIntRange( 3, 7 ) );
					self turbinePowerOff( origin, powerRadius );

					self.turbine_power_on = false;

					wait ( RandomIntRange( 6, 12 ) );
					self turbinePowerOn( origin, powerRadius );
				} break;
			}
		}

		{wait(.05);};
	}
}

function debugTurbine( radius )
{
	notify_strings = zm_equipment::get_notify_strings( level.weaponZMEquipBuilder );

	/#
	self endon( "death" );
	self endon( "disconnect" );
	self endon( notify_strings.taken );
	self.buildableTurbine endon( "death" );

	while ( IsDefined( self.buildableTurbine ) )
	{
		if ( GetDvarInt( "zombie_equipment_health") )
		{
			color = (0,1,0);
			text = "";
			if (isdefined( self.turbine_health ))
				text = "" + self.turbine_health + "";
			if ( ( isdefined( self.buildableTurbine.dying ) && self.buildableTurbine.dying ) )
			{
				text = "dying";
				color = ( 0, 0, 0 );
			}
			else if (( isdefined( self.turbine_emped ) && self.turbine_emped ))
			{
				color = (0,0,1);
				emp_time = level.zombie_vars["emp_perk_off_time"];
				now = GetTime();
				emp_time_left = int( emp_time - (( now - self.turbine_emp_time ) / 1000) );
				text = text + " emp("+emp_time_left+")";
			}
			else if (( isdefined( self.turbine_is_powering_on ) && self.turbine_is_powering_on ))
			{
				text = text + " warmup";
			}
			else if (( isdefined( self.turbine_power_is_on ) && self.turbine_power_is_on ))
			{
				if ( self.turbine_health < 200 )
					color = (1,0,0);
				else if ( self.turbine_health < 600 )
					color = (1, 0.7, 0);
				else
					color = ( 1, 1, 0 );
			}
			//Circle( self.buildableTurbine.origin, radius, color, false, true, 1 );
			print3d(self.buildableTurbine.origin + (0,0,60), text, color, 1, 0.5, 1);
		}

		{wait(.05);};
	}
	#/
}
