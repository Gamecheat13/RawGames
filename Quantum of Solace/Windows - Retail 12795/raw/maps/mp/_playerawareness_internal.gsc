
//////////////////////////////////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////////////////////
// Initialization
//////////////////////////////////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////////////////////
awarenessInternalInit()
{
	///////////////////////////////////
	// System tuneables
	///////////////////////////////////
	level.awarenessUpdateTime				= 0.1;


	///////////////////////////////////
	// Material 'None' tuneables
	///////////////////////////////////
	level.awarenessMaterialFxEnabled[level.awarenessMaterialNone] = false;

	level.awarenessMaterialMinPulseTime[level.awarenessMaterialNone]	= 1000;
	level.awarenessMaterialMaxPulseTime[level.awarenessMaterialNone]	= 1001;


	///////////////////////////////////
	// Common material tuneables
	///////////////////////////////////
	for( i=0; i<level.awarenessMaterialMax; i++ )
	{
		level.awarenessMaterialAvgPulseTime[i] = (level.awarenessMaterialMinPulseTime[i] + level.awarenessMaterialMaxPulseTime[i]) * 0.5;
	}

	///////////////////////////////////
	// Glow/Spark FX tuneables
	///////////////////////////////////
	level.awarenessGlowAvgPulseTime = (level.awarenessGlowMinPulseTime + level.awarenessGlowMaxPulseTime) * 0.5;
	
	///////////////////////////////////
	// Shine FX tuneables
	///////////////////////////////////
	level.awarenessShineAvgPulseTime = (level.awarenessShineMinPulseTime + level.awarenessShineMaxPulseTime) * 0.5;
}



//////////////////////////////////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////////////////////
// Internal logic
//////////////////////////////////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////////////////////

//////////////////////////////////////////////////////////////////////////////////
// FX update functions
//////////////////////////////////////////////////////////////////////////////////
updateMaterialFX( enabled )
{
	if( self.materialDelay > level.awarenessMaterialAvgPulseTime[self.awarenessMaterial] )
		self.materialDelay = level.awarenessMaterialAvgPulseTime[self.awarenessMaterial];

	if( self.materialDelay <= 0 )
	{
		self.materialDelay = randomfloatrange( level.awarenessMaterialMinPulseTime[self.awarenessMaterial], level.awarenessMaterialMaxPulseTime[self.awarenessMaterial] );

		if( enabled )
		{
			playfx( level.awarenessMaterialFx[self.awarenessMaterial], self.primaryEntity.origin );
			// play sound as well?
		}
	}
}

updateShineFX( enabled )
{
	if( self.shineDelay > level.awarenessShineAvgPulseTime )
		self.shineDelay = level.awarenessShineAvgPulseTime;

	if( self.shineDelay <= 0 )
	{
		self.shineDelay = randomfloatrange( level.awarenessShineMinPulseTime, level.awarenessShineMaxPulseTime );

		if( enabled )
		{
			// kick off shine
		}
	}
}

updateGlowFX( enabled )
{
	if( self.glowDelay > level.awarenessGlowAvgPulseTime )
		self.glowDelay = level.awarenessGlowAvgPulseTime;

	if( self.glowDelay <= 0 )
	{
		self.glowDelay = randomfloatrange( level.awarenessGlowMinPulseTime, level.awarenessGlowMaxPulseTime );

		if( enabled )
		{
			playfx( level.awarenessGlowFx, self.primaryEntity.origin );
		}
	}
}

	
//////////////////////////////////////////////////////////////////////////////////
// Update
//////////////////////////////////////////////////////////////////////////////////
awarenessUpdate( awareness_object )
{
	self endon( "stopeffect" );
	
	while( 1 )
	{
		if( awareness_object.enabled )
		{
			wait level.awarenessUpdateTime;
			
			awareness_object.glowDelay -= level.awarenessUpdateTime;
			awareness_object.materialDelay -= level.awarenessUpdateTime;
			awareness_object.shineDelay -= level.awarenessUpdateTime;
			
			if( awareness_object.enableFX )
			{
				shine_enabled = awareness_object.awarenessShine;
				if( shine_enabled )
					shine_enabled = level.awarenessShineFxEnabled;
				awareness_object updateShineFX( shine_enabled );
				
				material_enabled = level.awarenessMaterialFxEnabled[awareness_object.awarenessMaterial];
				if( material_enabled && awareness_object.awarenessMaterial == level.awarenessMaterialNone )
					material_enabled = false;
				awareness_object updateMaterialFX( material_enabled );
				
				glow_enabled = awareness_object.awarenessGlow;
				if( glow_enabled )
					glow_enabled = level.awarenessGlowFxEnabled;
				awareness_object updateGlowFX( glow_enabled );
			}
			else
			{
				awareness_object updateMaterialFX( false );
				awareness_object updateShineFX( false );
				awareness_object updateGlowFX( false );
			}
		}
	}
}


//////////////////////////////////////////////////////////////////////////////////
// Callback utility functions
//////////////////////////////////////////////////////////////////////////////////
awarenessInternalSetDamageCallback( damage_event_to_call, allow_aim_assist )
{
	if( self.active )
	{
		if( isDefined( damage_event_to_call ) )
		{
			if( !isDefined(allow_aim_assist) || allow_aim_assist)
				self.allowAimAssist = true;
			else
				self.allowAimAssist = false;

			self.damageEventToCall = damage_event_to_call;
		}
		else
		{
			self.allowAimAssist = false;
			
			self.damageEventToCall = undefined;
		}


		if( isDefined( self.triggerEntities ) )
		{
			for( i=0; i<self.triggerEntities.size; i++ )
			{
				if( self.triggerEntities[i] != self.primaryEntity )
				{
					if( self.triggerEntities[i].classname != "script_model" )
					{
						if( self.allowAimAssist && self.enabled )
							self.triggerEntities[i] enableAimAssist();
						else
							self.triggerEntities[i] disableAimAssist();
					}
					
					self.triggerEntities[i] setCanDamage( isDefined( damage_event_to_call ) && self.enabled );
				}
			}
		}
		
		if( self.primaryEntity.classname != "script_model" )
		{
			if( self.allowAimAssist && self.enabled )
				self.primaryEntity enableAimAssist();
			else
				self.primaryEntity disableAimAssist();
		}
		
		self.primaryEntity setCanDamage( isDefined( damage_event_to_call ) && self.enabled );
	}
}

awarenessInternalSetUseCallback( use_event_to_call, hint_string, use_time, use_text, single_use, require_lookat )
{
	if( self.active )
	{
		if( isDefined( use_event_to_call ) )
		{
			if( self.enabled )
			{
				if( !isDefined( self.useObject ) )
				{
					self.useObject = maps\mp\_useableobjects::create_useable_object( self.primaryEntity, undefined, hint_string, use_time, use_text, single_use, require_lookat, true );
				}
				else
				{
					self.useObject maps\mp\_useableobjects::set_on_use_function( undefined );
					self.useObject maps\mp\_useableobjects::set_hint_string( hint_string );
					self.useObject maps\mp\_useableobjects::set_use_time( use_time );
					self.useObject maps\mp\_useableobjects::set_use_text( use_text );
					self.useObject maps\mp\_useableobjects::set_single_use( false );
					self.useObject maps\mp\_useableobjects::set_require_lookat( require_lookat );
					self.useObject maps\mp\_useableobjects::set_active( true );
				}
			}
			else 
			{
				if( isDefined( self.useObject ) )
					self.useObject maps\mp\_useableobjects::set_active( false );
			}

			self.useEventToCall  = use_event_to_call;
		}
		else
		{
			self.useEventToCall = undefined;
			
			if( isDefined( self.useObject ) )
				self.useObject maps\mp\_useableobjects::set_active( false );
		}
	}
}

awarenessDamageCallbackUpdateThread( awareness_object )
{
	awareness_object.primaryEntity endon( "awarenesstriggered" );
	
	while( awareness_object.active )
	{
		self waittill( "damage", damage, attacker, direction_vec, point, type, modelName, tagName );

		if( awareness_object.enabled )
		{
			awareness_object.triggeredDamage = true;
			awareness_object.triggeredUse = false;
			
			awareness_object.damageAmount = damage;
			awareness_object.damageAttacker = attacker;
			awareness_object.damageDirection = direction_vec;
			awareness_object.damagePoint = point;
			awareness_object.damageType = type;
			awareness_object.damageModelName = modelName;
			awareness_object.damageTagName = tagName;
			
			awarenessSuccess = true;
			if( isdefined( awareness_object.filterToCall ) )
				awarenessSuccess = [[ awareness_object.filterToCall ]]( awareness_object );
				
			if( awarenessSuccess )
				awareness_object thread awarenessCallback( awareness_object.damageEventToCall );

//			awareness_object.primaryEntity setBondAwareness( false );
		}
	}
}

awarenessUseCallbackUpdateThread( awareness_object )
{
	awareness_object.primaryEntity endon( "awarenesstriggered" );
	
	while( awareness_object.active )
	{
		awareness_object.primaryEntity waittill ( "useable_activated", player );

		if( awareness_object.enabled )
		{
			awareness_object.triggeredDamage = false;
			awareness_object.triggeredUse = true;
			
			awareness_object.useEntity = player;
			
			awarenessSuccess = true;
			if( isdefined( awareness_object.filterToCall ) )
				awarenessSuccess = [[ awareness_object.filterToCall ]]( awareness_object );
				
			if( awarenessSuccess )
				awareness_object thread awarenessCallback( awareness_object.useEventToCall );

//			awareness_object.primaryEntity setBondAwareness( false );
		}
	}
}

awarenessCallback( event_to_call )
{
	if( isDefined( event_to_call ) && self.active )
	{
		self.active = false;
		
		if( isdefined( self.useObject ) )
			self.useObject maps\mp\_useableobjects::set_active( false );
		
		self.primaryEntity notify( "awarenesstriggered" );
		self.primaryEntity notify( "stopeffect" );
		
		if( isDefined( self.triggerEntities ) )
		{
			for( i=0; i<self.triggerEntities.size; i++ )
			{
				if( self.triggerEntities[i] != self.primaryEntity )
				{
					if( self.triggerEntities[i].classname != "script_model" )
						self.triggerEntities[i] disableAimAssist();
				}
			}
		}
		
		if( self.primaryEntity.classname != "script_model" )
			self.primaryEntity disableAimAssist();
		
		
		self updateMaterialFX( false );
		self updateShineFX( false );
		self updateGlowFX( false );

		//Now trigger the passed in script function if it is valid
		if( isdefined( event_to_call ) )
			[[ event_to_call ]]( self );

		self.primaryEntity notify( "awarenessfinished" );

//		self.primaryEntity setBondAwareness( false );
	}
}

awarenessSetupCallbacks( trigger_entities, damage_event_to_call, allow_aim_assist, use_event_to_call, hint_string, use_time, use_text, single_use, require_lookat, filter_to_call )
{
	self.damageEventToCall = undefined;
	self.useEventToCall = undefined;
	self.triggerEntities = trigger_entities;
	
	//Setup filter
	self maps\mp\_playerawareness::setFilterCallback( filter_to_call );
	
	//Setup for damage
	self maps\mp\_playerawareness::setDamageCallback( damage_event_to_call, allow_aim_assist );
	self.primaryEntity thread awarenessDamageCallbackUpdateThread( self );
	if( isDefined( self.triggerEntities ) )
	{
		for( i=0; i<self.triggerEntities.size; i++ )
		{
			if( self.triggerEntities[i] != self.primaryEntity )
				self.triggerEntities[i] thread awarenessDamageCallbackUpdateThread( self );
		}
	}

	//Setup for use
	self maps\mp\_playerawareness::setUseCallback( use_event_to_call, hint_string, use_time, use_text, single_use, require_lookat );
	self.primaryEntity thread awarenessUseCallbackUpdateThread( self );
}


//////////////////////////////////////////////////////////////////////////////////
// Creation function
//////////////////////////////////////////////////////////////////////////////////
createAwarenessObject( primary_entity, trigger_entities, damage_event_to_call, allow_aim_assist, use_event_to_call, hint_string, use_time, use_text, single_use, require_lookat, filter_to_call, awareness_material, awareness_glow, awareness_shine )
{
	awareness_object = spawnStruct();
	
	awareness_object.active = true;
	awareness_object.enabled = true;
	awareness_object.primaryEntity = primary_entity;

	awareness_object.enableFX = true;
	
	awareness_object maps\mp\_playerawareness::setAwarenessMaterial( awareness_material );
	awareness_object maps\mp\_playerawareness::setAwarenessGlowEnabled( awareness_glow );
	awareness_object maps\mp\_playerawareness::setAwarenessShineEnabled( awareness_shine );
		
	awareness_object.glowDelay = level.awarenessGlowMaxPulseTime;
	awareness_object.materialDelay = level.awarenessMaterialMaxPulseTime[awareness_object.awarenessMaterial];
	awareness_object.shineDelay = level.awarenessShineMaxPulseTime;
	
	awareness_object awarenessSetupCallbacks( trigger_entities, damage_event_to_call, allow_aim_assist, use_event_to_call, hint_string, use_time, use_text, single_use, require_lookat, filter_to_call );
	
	awareness_object.primaryEntity thread awarenessUpdate( awareness_object );

//	awareness_object.primaryEntity setBondAwareness( true );
	
	return awareness_object;
}
