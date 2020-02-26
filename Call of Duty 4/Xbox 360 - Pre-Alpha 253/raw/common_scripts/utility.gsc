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

sign( x )
{
	if ( x >= 0 )
		return 1;
	return -1;
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


waittill_string( msg, ent )
{
	if ( msg != "death" )
		self endon ("death");
		
	ent endon ( "die" );
	self waittill ( msg );
	ent notify ( "returned", msg );
}

waittill_multiple( string1, string2, string3, string4, string5 )
{
	self endon ("death");
	ent = spawnstruct();
	ent.threads = 0;

	if (isdefined (string1))
	{
		self thread waittill_string (string1, ent);
		ent.threads++;
	}
	if (isdefined (string2))
	{
		self thread waittill_string (string2, ent);
		ent.threads++;
	}
	if (isdefined (string3))
	{
		self thread waittill_string (string3, ent);
		ent.threads++;
	}
	if (isdefined (string4))
	{
		self thread waittill_string (string4, ent);
		ent.threads++;
	}
	if (isdefined (string5))
	{
		self thread waittill_string (string5, ent);
		ent.threads++;
	}

	while (ent.threads)
	{
		ent waittill ("returned");
		ent.threads--;
	}

	ent notify ("die");
}

waittill_multiple_ents( ent1, string1, ent2, string2 )
{
	self endon ("death");
	ent = spawnstruct();
	ent.threads = 0;

	if ( isdefined( ent1 ) )
	{
		assert( isdefined( string1 ) );
		ent1 thread waittill_string( string1, ent );
		ent.threads++;
	}
	if ( isdefined( ent2 ) )
	{
		assert( isdefined( string2 ) );
		ent2 thread waittill_string ( string2, ent );
		ent.threads++;
	}

	while (ent.threads)
	{
		ent waittill ("returned");
		ent.threads--;
	}

	ent notify ("die");
}

waittill_any_return( string1, string2, string3, string4, string5 )
{
	if ((!isdefined (string1) || string1 != "death") &&
	    (!isdefined (string2) || string2 != "death") &&
	    (!isdefined (string3) || string3 != "death") &&
	    (!isdefined (string4) || string4 != "death") &&
	    (!isdefined (string5) || string5 != "death"))
		self endon ("death");
		
	ent = spawnstruct();

	if (isdefined (string1))
		self thread waittill_string (string1, ent);

	if (isdefined (string2))
		self thread waittill_string (string2, ent);

	if (isdefined (string3))
		self thread waittill_string (string3, ent);

	if (isdefined (string4))
		self thread waittill_string (string4, ent);

	if (isdefined (string5))
		self thread waittill_string (string5, ent);

	ent waittill ("returned", msg);
	ent notify ("die");
	return msg;
}

waittill_any( string1, string2, string3, string4, string5 )
{
	assert( isdefined( string1 ) );
	
	if ( isdefined( string2 ) )
		self endon( string2 );

	if ( isdefined( string3 ) )
		self endon( string3 );

	if ( isdefined( string4 ) )
		self endon( string4 );

	if ( isdefined( string5 ) )
		self endon( string5 );
	
	self waittill( string1 );
}

// works on player and AI
isFlashed()
{
	if ( !isdefined( self.flashEndTime ) )
		return false;
	
	return gettime() < self.flashEndTime;
}
