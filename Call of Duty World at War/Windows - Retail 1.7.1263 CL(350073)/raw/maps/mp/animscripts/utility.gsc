
anim_get_dvar_int( dvar, def )
{
	return int( anim_get_dvar( dvar, def ) );
}

// dvar set/fetch/check
anim_get_dvar( dvar, def )
{
	if ( getdvar( dvar ) != "" )
		return getdvarfloat( dvar );
	else
	{
		setdvar( dvar, def );
		return def;
	}
}

set_orient_mode( mode, val1 )
{
/#
	if ( level.dog_debug_orient == self getentnum() )
	{
		if ( isdefined( val1 ) )
			println( "DOG:  Setting orient mode: " + mode + " " + val1 + " " + getTime() );
		else
			println( "DOG:  Setting orient mode: " + mode + " " + getTime() );
	}
#/
	
	if ( isdefined( val1 ) )
		self OrientMode( mode, val1 );
	else
		self OrientMode( mode );
}

debug_anim_print( text )
{
/#		
	if ( level.dog_debug_anims  )
		println( text+ " " + getTime() );

	if ( level.dog_debug_anims_ent == self getentnum() )
		println( text+ " " + getTime() );
#/
}

debug_turn_print( text, line )
{
/#		
	if ( level.dog_debug_turns == self getentnum() )
	{
		duration = 200;
		currentYawColor = (1,1,1);
		lookaheadYawColor = (1,0,0);
		desiredYawColor = (1,1,0);
	
		currentYaw = AngleClamp180(self.angles[1]);
		desiredYaw = AngleClamp180(self.desiredangle);
		lookaheadDir = self.lookaheaddir;
		lookaheadAngles = vectortoangles(lookaheadDir);
		lookaheadYaw = AngleClamp180(lookaheadAngles[1]);
			println( text+ " " + getTime() + " cur: " + currentYaw + " look: " + lookaheadYaw + " desired: " + desiredYaw );
	}
#/
}

current_yaw_line_debug( duration )
{
/#		
	currentYawColor = [];
	currentYawColor[0] = (0,0,1);
	currentYawColor[1] = (1,0,1);
	current_color_index = 0;
	
	start_time = gettime();
	
	if ( !isdefined( level.lastDebugHeight ) )
	{
		level.lastDebugHeight = 15;
	}
	
	
	while ( gettime() - start_time < 1000 )
	{
		pos1 = (self.origin[0],self.origin[1],self.origin[2] + level.lastDebugHeight);
		pos2 = pos1 + common_scripts\utility::vectorscale( anglestoforward(self.angles), (current_color_index + 1) * 10);
		line(pos1, pos2, currentYawColor[current_color_index], 0.3, 1, duration);
		current_color_index = (current_color_index + 1) % currentYawColor.size;
		wait(0.05);
	}
	
	if ( level.lastDebugHeight == 15 )
	{
		level.lastDebugHeight = 30;
	}
	else
	{
		level.lastDebugHeight = 15;
	}
#/
}

getAnimDirection( damageyaw )
{
	if( ( damageyaw > 135 ) ||( damageyaw <= -135 ) )	// Front quadrant
	{
		return "front";
	}
	else if( ( damageyaw > 45 ) &&( damageyaw <= 135 ) )		// Right quadrant
	{
		return "right";
	}
	else if( ( damageyaw > -45 ) &&( damageyaw <= 45 ) )		// Back quadrant
	{
		return "back";
	}
	else
	{															// Left quadrant
		return "left";
	}
	return "front";
}

setFootstepEffect(name, fx)
{
	assertEx(isdefined(name), "Need to define the footstep surface type.");
	assertEx(isdefined(fx), "Need to define the mud footstep effect.");
	if (!isdefined(anim.optionalStepEffects))
		anim.optionalStepEffects = [];
	anim.optionalStepEffects[anim.optionalStepEffects.size] = name;
	level._effect["step_" + name] = fx;
}
