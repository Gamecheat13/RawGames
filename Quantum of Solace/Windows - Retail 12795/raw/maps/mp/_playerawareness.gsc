#include common_scripts\utility;
#include maps\mp\_playerawareness_internal;

/*////////////////////////////////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////////////////////
// Data documentation
//////////////////////////////////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////////////////////

	//////////////////////////////////////////////////////////////////////////////
	// All variables are read-only, and should not be set manually.
	// (*) - May be undefined, if not used.
	//////////////////////////////////////////////////////////////////////////////
	awarenessObject.primaryEntity	- The entity the awareness is attached to
	awarenessObject.triggerEntities	- (*)Multiple triggers assigned to the object
	awarenessObject.useObject		- (*)The useable object

	awarenessObject.triggeredDamage	- Set to true if triggered by damage
	awarenessObject.damageAmount	- Amount of damage that was applied
	awarenessObject.damageAttacker	- Attacker that applied the damage
	awarenessObject.damageDirection - Direction of the damage
	awarenessObject.damagePoint		- Point the damage hit
	awarenessObject.damageType		- Type of damage
	awarenessObject.damageModelName - Model name
	awarenessObject.damageTagName	- Tag name
	
	awarenessObject.triggeredUse	- Set to true if triggered by useage
	awarenessObject.useEntity		- Entity that used the trigger
	
////////////////////////////////////////////////////////////////////////////////*/

//////////////////////////////////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////////////////////
// Initialization
//////////////////////////////////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////////////////////
init()
{
	///////////////////////////////////
	// Material constants
	///////////////////////////////////
	level.awarenessMaterialNone		= 0; // Do not change!
	
	level.awarenessMaterialWood		= 1;
	level.awarenessMaterialMetal	= 2;
	level.awarenessMaterialElectric = 3;
	level.awarenessMaterialStone	= 4;
	
	level.awarenessMaterialMax		= 5; // Must be updated!
	
	
	///////////////////////////////////
	// Material 'Wood' tuneables
	///////////////////////////////////
	level.awarenessMaterialFxEnabled[level.awarenessMaterialWood] = true;
	
	level.awarenessMaterialFx[level.awarenessMaterialWood] = loadfx( "misc/surface_aware_wood" );
	
	level.awarenessMaterialMinPulseTime[level.awarenessMaterialWood]	= 3.1;
	level.awarenessMaterialMaxPulseTime[level.awarenessMaterialWood]	= 5;


	///////////////////////////////////
	// Material 'Metal' tuneables
	///////////////////////////////////
	level.awarenessMaterialFxEnabled[level.awarenessMaterialMetal] = true;
	
	level.awarenessMaterialFx[level.awarenessMaterialMetal] = loadfx( "misc/surface_aware_metal" );
	
	level.awarenessMaterialMinPulseTime[level.awarenessMaterialMetal]	= 3.1;
	level.awarenessMaterialMaxPulseTime[level.awarenessMaterialMetal]	= 5;


	///////////////////////////////////
	// Material 'Electric' tuneables
	///////////////////////////////////
	level.awarenessMaterialFxEnabled[level.awarenessMaterialElectric] = true;
	
	level.awarenessMaterialFx[level.awarenessMaterialElectric] = loadfx( "misc/surface_aware_metal" );
	
	level.awarenessMaterialMinPulseTime[level.awarenessMaterialElectric]	= 3.1;
	level.awarenessMaterialMaxPulseTime[level.awarenessMaterialElectric]	= 5;


	///////////////////////////////////
	// Material 'Stone' tuneables
	///////////////////////////////////
	level.awarenessMaterialFxEnabled[level.awarenessMaterialStone] = true;
	
	level.awarenessMaterialFx[level.awarenessMaterialStone] = loadfx( "misc/surface_aware_stone" );

	level.awarenessMaterialMinPulseTime[level.awarenessMaterialStone]	= 3.1;
	level.awarenessMaterialMaxPulseTime[level.awarenessMaterialStone]	= 5;


	///////////////////////////////////
	// Glow/Spark FX tuneables
	///////////////////////////////////
	level.awarenessGlowFxEnabled = true;
		
	level.awarenessGlowFx = loadfx( "misc/action_awareness" );

	level.awarenessGlowMinPulseTime	= 3.1;
	level.awarenessGlowMaxPulseTime	= 5;


	///////////////////////////////////
	// Shine FX tuneables
	///////////////////////////////////
	level.awarenessShineFxEnabled = true;

	level.awarenessShineMinPulseTime	= 3.1;
	level.awarenessShineMaxPulseTime	= 5;


	///////////////////////////////////
	// Internal initialization
	///////////////////////////////////
	awarenessInternalInit();

		
	///////////////////////////////////
	// Common Bond awareness objects
	///////////////////////////////////
}


//////////////////////////////////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////////////////////
// Creation functions
//////////////////////////////////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////////////////////

//////////////////////////////////////////////////////////////////////////////////
// Single entity linked to an event/callback.
//////////////////////////////////////////////////////////////////////////////////
setupSingle(	awareness_entity_name, 
				damage_event_to_call, 
				allow_aim_assist, 
				use_event_to_call, 
				hint_string, 
				use_time, 
				use_text, 
				single_use, 
				require_lookat, 
				filter_to_call, 
				awareness_material, 
				awareness_glow, 
				awareness_shine, 
				wait_until_finished )
{
	return setupEntSingle(	getent( awareness_entity_name, "targetname" ), damage_event_to_call, allow_aim_assist, use_event_to_call, hint_string, use_time, use_text, single_use, require_lookat, filter_to_call, awareness_material, awareness_glow, awareness_shine, wait_until_finished );
}



setupSingleDamageOnly(	awareness_entity_name, 
						damage_event_to_call, 
						allow_aim_assist, 
						filter_to_call, 
						awareness_material, 
						awareness_glow, 
						awareness_shine, 
						wait_until_finished )
{
	return setupEntSingle(	getent( awareness_entity_name, "targetname" ), damage_event_to_call, allow_aim_assist, undefined, undefined, undefined, undefined, undefined, undefined, filter_to_call, awareness_material, awareness_glow, awareness_shine, wait_until_finished );
}



setupSingleUseOnly( awareness_entity_name, 
					use_event_to_call, 
					hint_string, 
					use_time, 
					use_text, 
					single_use, 
					require_lookat, 
					filter_to_call, 
					awareness_material, 
					awareness_glow, 
					awareness_shine, 
					wait_until_finished )
{
	return setupEntSingle( getent( awareness_entity_name, "targetname" ), undefined, undefined, use_event_to_call, hint_string, use_time, use_text, single_use, require_lookat, filter_to_call, awareness_material, awareness_glow, awareness_shine, wait_until_finished );
}



setupSingleNoWait(	awareness_entity_name, 
					damage_event_to_call, 
					allow_aim_assist, 
					use_event_to_call, 
					hint_string, 
					use_time, 
					use_text, 
					single_use, 
					require_lookat, 
					filter_to_call, 
					awareness_material, 
					awareness_glow, 
					awareness_shine )
{
	return setupEntSingle(	getent( awareness_entity_name, "targetname" ), damage_event_to_call, allow_aim_assist, use_event_to_call, hint_string, use_time, use_text, single_use, require_lookat, filter_to_call, awareness_material, awareness_glow, awareness_shine, false );
}



setupSingleDamageOnlyNoWait(	awareness_entity_name, 
								damage_event_to_call, 
								allow_aim_assist, 
								filter_to_call, 
								awareness_material, 
								awareness_glow, 
								awareness_shine )
{
	return setupEntSingle(	getent( awareness_entity_name, "targetname" ), damage_event_to_call, allow_aim_assist, undefined, undefined, undefined, undefined, undefined, undefined, filter_to_call, awareness_material, awareness_glow, awareness_shine, false );
}



setupSingleUseOnlyNoWait(	awareness_entity_name, 
							use_event_to_call, 
							hint_string, 
							use_time, 
							use_text, 
							single_use, 
							require_lookat, 
							filter_to_call, 
							awareness_material, 
							awareness_glow, 
							awareness_shine )
{
	return setupEntSingle(	getent( awareness_entity_name, "targetname" ), undefined, undefined, use_event_to_call, hint_string, use_time, use_text, single_use, require_lookat, filter_to_call, awareness_material, awareness_glow, awareness_shine, false );
}



setupEntSingle( awareness_entity, 
				damage_event_to_call, 
				allow_aim_assist, 
				use_event_to_call, 
				hint_string, 
				use_time, 
				use_text, 
				single_use, 
				require_lookat, 
				filter_to_call, 
				awareness_material, 
				awareness_glow, 
				awareness_shine, 
				wait_until_finished )
{
	awareness_object = createAwarenessObject( awareness_entity, undefined, damage_event_to_call, allow_aim_assist, use_event_to_call, hint_string, use_time, use_text, single_use, require_lookat, filter_to_call, awareness_material, awareness_glow, awareness_shine );
	
	if( isDefined( wait_until_finished ) && wait_until_finished )
		awareness_object waitForAwarenessCompletion();
		
	return awareness_object;
}



setupEntSingleDamageOnly(	awareness_entity, 
							damage_event_to_call, 
							allow_aim_assist, 
							filter_to_call, 
							awareness_material, 
							awareness_glow, 
							awareness_shine, 
							wait_until_finished )
{
	return setupEntSingle( awareness_entity, damage_event_to_call, allow_aim_assist, undefined, undefined, undefined, undefined, undefined, undefined, filter_to_call, awareness_material, awareness_glow, awareness_shine, wait_until_finished );
}



setupEntSingleUseOnly(	awareness_entity, 
						use_event_to_call, 
						hint_string, 
						use_time, 
						use_text, 
						single_use, 
						require_lookat, 
						filter_to_call, 
						awareness_material, 
						awareness_glow, 
						awareness_shine, 
						wait_until_finished )
{
	return setupEntSingle( awareness_entity, undefined, undefined, use_event_to_call, hint_string, use_time, use_text, single_use, require_lookat, filter_to_call, awareness_material, awareness_glow, awareness_shine, wait_until_finished );
}



setupEntSingleNoWait(	awareness_entity, 
						damage_event_to_call, 
						allow_aim_assist, 
						use_event_to_call, 
						hint_string, 
						use_time, 
						use_text, 
						single_use, 
						require_lookat, 
						filter_to_call, 
						awareness_material, 
						awareness_glow, 
						awareness_shine )
{
	return setupEntSingle( awareness_entity, damage_event_to_call, allow_aim_assist, use_event_to_call, hint_string, use_time, use_text, single_use, require_lookat, filter_to_call, awareness_material, awareness_glow, awareness_shine, false );
}



setupEntSingleDamageOnlyNoWait( awareness_entity, 
								damage_event_to_call, 
								allow_aim_assist, 
								filter_to_call, 
								awareness_material, 
								awareness_glow, 
								awareness_shine )
{
	return setupEntSingle( awareness_entity, damage_event_to_call, allow_aim_assist, undefined, undefined, undefined, undefined, undefined, undefined, filter_to_call, awareness_material, awareness_glow, awareness_shine, false );
}



setupEntSingleUseOnlyNoWait(	awareness_entity, 
								use_event_to_call, 
								hint_string, 
								use_time, 
								use_text, 
								single_use, 
								require_lookat, 
								filter_to_call, 
								awareness_material, 
								awareness_glow, 
								awareness_shine )
{
	return setupEntSingle( awareness_entity, undefined, undefined, use_event_to_call, hint_string, use_time, use_text, single_use, require_lookat, filter_to_call, awareness_material, awareness_glow, awareness_shine, false );
}



//////////////////////////////////////////////////////////////////////////////////
// Array of individual entities, each linked to it's own event/callback.
//////////////////////////////////////////////////////////////////////////////////
setupArray( awareness_entity_name, 
			damage_event_to_call, 
			allow_aim_assist, 
			use_event_to_call, 
			hint_string, 
			use_time, 
			use_text, 
			single_use, 
			require_lookat, 
			filter_to_call, 
			awareness_material, 
			awareness_glow, 
			awareness_shine )
{
	setupEntArray( getentarray( awareness_entity_name, "targetname" ), damage_event_to_call, allow_aim_assist, use_event_to_call, hint_string, use_time, use_text, single_use, require_lookat, filter_to_call, awareness_material, awareness_glow, awareness_shine );
}



setupArrayDamageOnly(	awareness_entity_name, 
						damage_event_to_call, 
						allow_aim_assist, 
						filter_to_call, 
						awareness_material, 
						awareness_glow, 
						awareness_shine )
{
	setupEntArray( getentarray( awareness_entity_name, "targetname" ), damage_event_to_call, allow_aim_assist, undefined, undefined, undefined, undefined, undefined, undefined, filter_to_call, awareness_material, awareness_glow, awareness_shine );
}



setupArrayUseOnly(	awareness_entity_name, 
					use_event_to_call, 
					hint_string, 
					use_time, 
					use_text, 
					single_use, 
					require_lookat, 
					filter_to_call, 
					awareness_material, 
					awareness_glow, 
					awareness_shine )
{
	setupEntArray( getentarray( awareness_entity_name, "targetname" ), undefined, undefined, use_event_to_call, hint_string, use_time, use_text, single_use, require_lookat, filter_to_call, awareness_material, awareness_glow, awareness_shine );
}



setupEntArray(	awareness_entities, 
				damage_event_to_call, 
				allow_aim_assist, 
				use_event_to_call, 
				hint_string, 
				use_time, 
				use_text, 
				single_use, 
				require_lookat, 
				filter_to_call, 
				awareness_material, 
				awareness_glow, 
				awareness_shine )
{
	for( i=0; i<awareness_entities.size; i++ )
	{
		setupEntSingle( awareness_entities[i], damage_event_to_call, allow_aim_assist, use_event_to_call, hint_string, use_time, use_text, single_use, require_lookat, filter_to_call, awareness_material, awareness_glow, awareness_shine, false );
	}
}



setupEntArrayDamageOnly(	awareness_entities, 
							damage_event_to_call, 
							allow_aim_assist, 
							filter_to_call, 
							awareness_material, 
							awareness_glow, 
							awareness_shine )
{
	setupEntArray( awareness_entities, damage_event_to_call, allow_aim_assist, undefined, undefined, undefined, undefined, undefined, undefined, filter_to_call, awareness_material, awareness_glow, awareness_shine, false );
}



setupEntArrayUseOnly(	awareness_entities, 
						use_event_to_call, 
						hint_string, 
						use_time, 
						use_text, 
						single_use, 
						require_lookat, 
						filter_to_call, 
						awareness_material, 
						awareness_glow, 
						awareness_shine )
{
	setupEntArray( awareness_entities, undefined, undefined, use_event_to_call, hint_string, use_time, use_text, single_use, require_lookat, filter_to_call, awareness_material, awareness_glow, awareness_shine, false );
}



//////////////////////////////////////////////////////////////////////////////////
// Multiple damage triggers linked to a single event/callback.
//////////////////////////////////////////////////////////////////////////////////
setupMulti( awareness_entity_name, 
			damage_event_to_call, 
			allow_aim_assist, 
			use_event_to_call, 
			hint_string, 
			use_time, 
			use_text, 
			single_use, 
			require_lookat, 
			filter_to_call, 
			awareness_material, 
			awareness_glow, 
			awareness_shine, 
			wait_until_finished )
{
	return setupEntMulti( getentarray( awareness_entity_name, "targetname" ), damage_event_to_call, allow_aim_assist, use_event_to_call, hint_string, use_time, use_text, single_use, require_lookat, filter_to_call, awareness_material, awareness_glow, awareness_shine, wait_until_finished );
}



setupMultiDamageOnly(	awareness_entity_name, 
						damage_event_to_call, 
						allow_aim_assist, 
						filter_to_call, 
						awareness_material, 
						awareness_glow, 
						awareness_shine, 
						wait_until_finished )
{
	return setupEntMulti( getentarray( awareness_entity_name, "targetname" ), damage_event_to_call, allow_aim_assist, undefined, undefined, undefined, undefined, undefined, undefined, filter_to_call, awareness_material, awareness_glow, awareness_shine, wait_until_finished );
}



setupMultiUseOnly(	awareness_entity_name, 
					use_event_to_call, 
					hint_string, 
					use_time, 
					use_text, 
					single_use, 
					require_lookat, 
					filter_to_call, 
					awareness_material, 
					awareness_glow, 
					awareness_shine, 
					wait_until_finished )
{
	return setupEntMulti( getentarray( awareness_entity_name, "targetname" ), undefined, undefined, use_event_to_call, hint_string, use_time, use_text, single_use, require_lookat, filter_to_call, awareness_material, awareness_glow, awareness_shine, wait_until_finished );
}



setupMultiNoWait(	awareness_entity_name, 
					damage_event_to_call, 
					allow_aim_assist, 
					use_event_to_call, 
					hint_string, 
					use_time, 
					use_text, 
					single_use, 
					require_lookat, 
					filter_to_call, 
					awareness_material, 
					awareness_glow, 
					awareness_shine )
{
	return setupEntMulti( getentarray( awareness_entity_name, "targetname" ), damage_event_to_call, allow_aim_assist, use_event_to_call, hint_string, use_time, use_text, single_use, require_lookat, filter_to_call, awareness_material, awareness_glow, awareness_shine, false );
}



setupMultiDamageOnlyNoWait( awareness_entity_name, 
							damage_event_to_call, 
							allow_aim_assist, 
							filter_to_call, 
							awareness_material, 
							awareness_glow, 
							awareness_shine )
{
	return setupEntMulti( getentarray( awareness_entity_name, "targetname" ), damage_event_to_call, allow_aim_assist, undefined, undefined, undefined, undefined, undefined, undefined, filter_to_call, awareness_material, awareness_glow, awareness_shine, false );
}



setupMultiUseOnlyNoWait(	awareness_entity_name, 
							use_event_to_call, 
							hint_string, 
							use_time, 
							use_text, 
							single_use, 
							require_lookat, 
							filter_to_call, 
							awareness_material, 
							awareness_glow, 
							awareness_shine )
{
	return setupEntMulti( getentarray( awareness_entity_name, "targetname" ), undefined, undefined, use_event_to_call, hint_string, use_time, use_text, single_use, require_lookat, filter_to_call, awareness_material, awareness_glow, awareness_shine, false );
}



setupEntMulti(	awareness_entities, 
				damage_event_to_call, 
				allow_aim_assist, 
				use_event_to_call, 
				hint_string, 
				use_time, 
				use_text, 
				single_use, 
				require_lookat, 
				filter_to_call, 
				awareness_material, 
				awareness_glow, 
				awareness_shine, 
				wait_until_finished )
{
	awareness_object = createAwarenessObject( awareness_entities[0], awareness_entities, damage_event_to_call, allow_aim_assist, use_event_to_call, hint_string, use_time, use_text, single_use, require_lookat, filter_to_call, awareness_material, awareness_glow, awareness_shine );
	
	if( isDefined( wait_until_finished ) && wait_until_finished )
		awareness_object waitForAwarenessCompletion();
		
	return awareness_object;
}



setupEntMultiDamageOnly(	awareness_entities, 
							damage_event_to_call, 
							allow_aim_assist, 
							filter_to_call, 
							awareness_material, 
							awareness_glow, 
							awareness_shine, 
							wait_until_finished )
{
	return setupEntMulti( awareness_entities, damage_event_to_call, allow_aim_assist, undefined, undefined, undefined, undefined, undefined, undefined, filter_to_call, awareness_material, awareness_glow, awareness_shine, wait_until_finished );
}



setupEntMultiUseOnly(	awareness_entities, 
						use_event_to_call, 
						hint_string, 
						use_time, 
						use_text, 
						single_use, 
						require_lookat, 
						filter_to_call, 
						awareness_material, 
						awareness_glow, 
						awareness_shine, 
						wait_until_finished )
{
	return setupEntMulti( awareness_entities, undefined, undefined, use_event_to_call, hint_string, use_time, use_text, single_use, require_lookat, filter_to_call, awareness_material, awareness_glow, awareness_shine, wait_until_finished );
}



setupEntMultiNoWait(	awareness_entities, 
						damage_event_to_call, 
						allow_aim_assist, 
						use_event_to_call, 
						hint_string, 
						use_time, 
						use_text, 
						single_use, 
						require_lookat, 
						filter_to_call, 
						awareness_material, 
						awareness_glow, 
						awareness_shine )
{
	return setupEntMulti( awareness_entities, damage_event_to_call, allow_aim_assist, use_event_to_call, hint_string, use_time, use_text, single_use, require_lookat, filter_to_call, awareness_material, awareness_glow, awareness_shine, false );
}



setupEntMultiDamageOnlyNoWait(	awareness_entities, 
								damage_event_to_call, 
								allow_aim_assist, 
								filter_to_call, 
								awareness_material, 
								awareness_glow, 
								awareness_shine )
{
	return setupEntMulti( awareness_entities, damage_event_to_call, allow_aim_assist, undefined, undefined, undefined, undefined, undefined, undefined, filter_to_call, awareness_material, awareness_glow, awareness_shine, false );
}



setupEntMultiUseOnlyNoWait( awareness_entities, 
							use_event_to_call, 
							hint_string, 
							use_time, 
							use_text, 
							single_use, 
							require_lookat, 
							filter_to_call, 
							awareness_material, 
							awareness_glow, 
							awareness_shine )
{
	return setupEntMulti( awareness_entities, undefined, undefined, use_event_to_call, hint_string, use_time, use_text, single_use, require_lookat, filter_to_call, awareness_material, awareness_glow, awareness_shine, false );
}



//////////////////////////////////////////////////////////////////////////////////
// Used for backwards compatibility only.
//////////////////////////////////////////////////////////////////////////////////
setup(	awareness_entity_name, 
		damage_event_to_call, 
		allow_aim_assist, 
		use_event_to_call, 
		hint_string, 
		use_time, 
		use_text, 
		single_use, 
		require_lookat, 
		filter_to_call, 
		awareness_material, 
		awareness_glow, 
		awareness_shine, 
		wait_until_finished )
{
	return setupMulti( awareness_entity_name, damage_event_to_call, allow_aim_assist, use_event_to_call, hint_string, use_time, use_text, single_use, require_lookat, filter_to_call, awareness_material, awareness_glow, awareness_shine, wait_until_finished );
}

setupNoWait(	awareness_entity_name, 
				damage_event_to_call, 
				allow_aim_assist, 
				use_event_to_call, 
				hint_string, 
				use_time, 
				use_text, 
				single_use, 
				require_lookat, 
				filter_to_call, 
				awareness_material, 
				awareness_glow, 
				awareness_shine )
{
	return setupMulti( awareness_entity_name, damage_event_to_call, allow_aim_assist, use_event_to_call, hint_string, use_time, use_text, single_use, require_lookat, filter_to_call, awareness_material, awareness_glow, awareness_shine, false );
}



//////////////////////////////////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////////////////////
// Post creation alteration functions
//////////////////////////////////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////////////////////
setDamageCallback( damage_event_to_call, allow_aim_assist )
{
	self awarenessInternalSetDamageCallback( damage_event_to_call, allow_aim_assist );
}



clearDamageCallback()
{
	self setDamageCallback( undefined );
}



setUseCallback( use_event_to_call, hint_string, use_time, use_text, single_use, require_lookat )
{
	self awarenessInternalSetUseCallback( use_event_to_call, hint_string, use_time, use_text, single_use, require_lookat );
}



clearUseCallback()
{
	self setUseCallback( undefined );
}



setFilterCallback( filter_to_call )
{
	if( self.active )
	{
		if( isDefined( filter_to_call ) )
			self.filterToCall = filter_to_call;
		else
			self.filterToCall = undefined;
	}
}



clearFilterCallback()
{
	self setFilterCallback( undefined );
}



setAwarenessEnabled( enabled )
{
	if( isDefined( enabled ) )
		self.enabled = enabled;
	else
		self.enabled = true;

	setDamageCallback( self.damageEventToCall, self.allowAimAssist );
	
	if( isDefined( self.useObject ) )
		setUseCallback( self.useEventToCall, self.useObject.hint_string, self.useObject.use_time, self.useObject.use_text, self.useObject.single_use, self.useObject.require_lookat );
	else	
		setUseCallback( self.useEventToCall );
}



setAwarenessFXEnabled( fx_enabled )
{
	if( isDefined( fx_enabled ) )
		self.enableFX = fx_enabled;
	else
		self.enableFX = true;
}



setAwarenessMaterial( awareness_material )
{
	if( isDefined( awareness_material ) && awareness_material >= level.awarenessMaterialNone && awareness_material < level.awarenessMaterialMax )
		self.awarenessMaterial = awareness_material;
	else
		self.awarenessMaterial = level.awarenessMaterialNone;
}



setAwarenessGlowEnabled( awareness_glow )
{
	if( isDefined( awareness_glow ) )
		self.awarenessGlow = awareness_glow;
	else
		self.awarenessGlow = true;
}
	
	
	
setAwarenessShineEnabled( awareness_shine )
{
	if( isDefined( awareness_shine ) )
		self.awarenessShine = awareness_shine;
	else
		self.awarenessShine = true;
}
	
	
	
waitForAwarenessCompletion()
{
	self.primaryEntity waittill( "awarenessfinished" );
}



//////////////////////////////////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////////////////////
// Common Filter callbacks
//////////////////////////////////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////////////////////
awarenessFilter_NoMeleeDamage( awareness_object )
{
	retval = true;
	
	if( awareness_object.triggeredDamage )
	{
		if( IsSubStr( ToLower( awareness_object.damageType ), "melee" ) )
			retval = false;
	}
	
	return retval;
}



awarenessFilter_PlayerOnlyDamage( awareness_object )
{
	retval = true;
	
	if( awareness_object.triggeredDamage )
	{
		if( awareness_object.damageAttacker != level.player )
			retval = false;
	}
	
	return retval;
}
