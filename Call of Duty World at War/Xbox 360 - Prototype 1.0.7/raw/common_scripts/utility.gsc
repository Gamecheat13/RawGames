scriptPrintln(channel, msg)
{
	setprintchannel(channel);
	println(msg);
	setprintchannel ("script");
}

debugPrintln(channel, msg)
{
	setprintchannel("script_debug");
	println(msg);
	setprintchannel ("script");
}

draw_debug_line(start, end, timer)
{
	for (i=0;i<timer*20;i++)
	{
		line (start, end, (1,1,0.5));
		wait (0.05);
	}
}

waittillend(msg)
{
	self waittillmatch (msg, "end");
}

randomvector(num)
{
	return (randomfloat(num) - num*0.5, randomfloat(num) - num*0.5,randomfloat(num) - num*0.5);
}

angle_dif(oldangle, newangle)
{
	// returns the difference between two yaws
	if (oldangle == newangle)
		return 0;
	
	while (newangle > 360)
		newangle -=360;
	
	while (newangle < 0)
		newangle +=360;
	
	while (oldangle > 360)
		oldangle -=360;
	
	while (oldangle < 0)
		oldangle +=360;
	
	olddif = undefined;
	newdif = undefined;
	
	if (newangle > 180)
		newdif = 360 - newangle;
	else
		newdif = newangle;
	
	if (oldangle > 180)
		olddif = 360 - oldangle;
	else
		olddif = oldangle;
	
	outerdif = newdif + olddif;
	innerdif = 0;
	
	if (newangle > oldangle)
		innerdif = newangle - oldangle;
	else
		innerdif = oldangle - newangle;
	
	if (innerdif < outerdif)
		return innerdif;
	else
		return outerdif;
}

vectorScale( vector, scale )
{
	vector = (vector[0] * scale, vector[1] * scale, vector[2] * scale);
	return vector;
}

abs( x )
{
	if ( x >= 0 )
		return x;
	return 0-x;
}

sign( x )
{
	if ( x >= 0 )
		return 1;
	return -1;
}

min( arg1, arg2 )
{
	if ( arg1 > arg2 )
		return arg2;
	else
		return arg1;	
}

max( arg1, arg2 )
{
	if ( arg1 > arg2 )
		return arg1;
	else
		return arg2;	
}

cqb_walk(on_or_off)
{	
	if(on_or_off == "on")
		self.cqbwalking = true;
	else if(on_or_off == "off")
		self.cqbwalking = false; 
}

cqb_aim(the_target)
{

	if(!isdefined(the_target))
	{
		self.cqb_target = undefined;
		self.current_target = undefined;
	}
	else
	{
		self.cqb_target = the_target;	
		
		if(!isdefined(the_target.origin))
			assertmsg("target passed into cqb_aim does not have an origin!");
		track(self.cqb_target);
	}
}

track(spot_to_track)
{
	if(isdefined(self.current_target))
	{
		if(spot_to_track == self.current_target)
			return;	
	}
	self.current_target = spot_to_track;	
}

get_enemy_team( team )
{
	assertEx( team != "neutral", "Team must be allies or axis" );
	
	teams = [];
	teams["axis"] = "allies";
	teams["allies"] = "axis";
		
	return teams[team];
}


clear_exception( type )
{
	assert( isdefined( self.exception[ type ] ) );
	self.exception[ type ] = anim.defaultException;
}

set_exception( type, func )
{
	assert( isdefined( self.exception[ type ] ) );
	self.exception[ type ] = func;
}

set_all_exceptions( exceptionFunc )
{
	keys = getArrayKeys( self.exception );
	for ( i=0; i < keys.size; i++ )
	{
		self.exception[ keys[ i ] ] = exceptionFunc;
	}
}

set_flash_duration(time_in_seconds)
{
	self.flashduration = time_in_seconds * 1000;
} 

cointoss()
{
	return randomint( 100 ) >= 50 ;
}
