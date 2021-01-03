#using scripts\shared\util_shared;

    	   	                                                                                                                                         	                                	                                                                                                                                                                                                                                                                                                                                                                    	        	     	             	    	   	               	                                              	                                                           	                               	                     	                                                                                                           	                                                                 	                                                              	                                                                                                              	                            	                                     	                                       	                                                                                                              	   	                  	       	                                                    	                   	                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                        	                                  	                                                                                        	           	                        	                                            	                                             	                                                   	                                                             	                                                         	                                                                    	                                                                                                                                                                                                    	                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                         	                                                              	                                                          	                                   	                                   	                                                    	                                       	                                           	     	                                                                                                                                                                                                                                                      	                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                     

#namespace sound;
//TODO T7 - investigate "sounddone" notify and if we should get MP to support it
function loop_fx_sound( alias, origin, ender )
{
	org = Spawn( "script_origin", ( 0, 0, 0 ) );
	if( isdefined( ender ) )
	{
		thread loop_delete( ender, org );
		self endon( ender );
	}
	org.origin = origin;
	org PlayLoopSound( alias );
}

function loop_delete( ender, ent )
{
	ent endon( "death" );
	self waittill( ender );
	ent Delete();
}

/@
"Name: play_in_space( <alias> , <origin> )"
"Summary: Stop playing the the loop sound alias on an entity"
"Module: Sound"
"CallOn: Level"
"MandatoryArg: <alias> : Sound alias to play"
"MandatoryArg: <origin> : Origin of the sound"
"Example: sound::play_in_space( "siren", level.speaker.origin );"
@/
function play_in_space( alias, origin, master )
{
	org = Spawn( "script_origin", ( 0, 0, 1 ) );

	if( !isdefined( origin ) )
	{
		origin = self.origin;
	}
	org.origin = origin;
	org PlaySoundWithNotify( alias, "sounddone" );
	org waittill( "sounddone" );

	if( isdefined( org ) )
	{
		org Delete();
	}
}

/@
"Name: loop_on_tag( <alias> , <tag>, bStopSoundOnDeath )"
"Summary: Play the specified looping sound alias on a tag of an entity"
"Module: Sound"
"CallOn: An entity"
"MandatoryArg: <alias> : Sound alias to loop"
"OptionalArg: <tag> : Tag on the entity to play sound on. If no tag is specified the entities origin will be used."
"OptionalArg: <bStopSoundOnDeath> : Defaults to true. If true, will stop the looping sound when self dies"
"Example: vehicle thread loop_on_tag( "engine_belt_run", "tag_engine" );"
"SPMP: singleplayer"
@/
function loop_on_tag( alias, tag, bStopSoundOnDeath )
{
	org = Spawn( "script_origin", ( 0, 0, 0 ) );
	org endon( "death" );
	if ( !isdefined( bStopSoundOnDeath ) )
	{
		bStopSoundOnDeath = true;
	}
	if ( bStopSoundOnDeath )
	{
		thread util::delete_on_death( org );
	}
	if( isdefined( tag ) )
	{
		org LinkTo( self, tag, ( 0, 0, 0 ), ( 0, 0, 0 ) );
	}
	else
	{
		org.origin = self.origin;
		org.angles = self.angles;
		org LinkTo( self );
	}
	//	org endon( "death" );
	org PlayLoopSound( alias );
	//	println( "playing loop sound ", alias, " on entity at origin ", self.origin, " at ORIGIN ", org.origin );
	self waittill( "stop sound" + alias );
	org StopLoopSound( alias );
	org Delete();
}

/@
"Name: play_on_tag( <alias> , <tag>, <ends_on_death> )"
"Summary: Play the specified sound alias on a tag of an entity"
"Module: Sound"
"CallOn: An entity"
"MandatoryArg: <alias> : Sound alias to play"
"OptionalArg: <tag> : Tag on the entity to play sound on. If no tag is specified the entities origin will be used."
"OptionalArg: <ends_on_death> : The sound will be cut short if the entity dies. Defaults to false."
"Example: vehicle thread sound::play_on_tag( "horn_honk", "tag_engine" );"
"SPMP: singleplayer"
@/
	//TODO T7 - change these calls over to use the code function PlaySoundOnTag once available
function play_on_tag( alias, tag, ends_on_death )
{
	/*if ( ai::is_dead_sentient() )
	{
		return;
	}*///TODO T7 - will we add this check back?

	org = Spawn( "script_origin", ( 0, 0, 0 ) );
	org endon( "death" );

	thread delete_on_death_wait( org, "sounddone" );
	if ( isdefined( tag ) )
	{
		org.origin = self GetTagOrigin( tag );
		org LinkTo( self, tag, ( 0, 0, 0 ), ( 0, 0, 0 ) );
	}
	else
	{		
		org.origin = self.origin;
		org.angles = self.angles;
		org LinkTo( self );
	}

	org PlaySoundWithNotify( alias, "sounddone" );

	if ( isdefined( ends_on_death ) )
	{
		assert( ends_on_death, "ends_on_death must be true or undefined" );
		wait_for_sounddone_or_death( org );
		/*if( ai::is_dead_sentient() )
		{
			org StopSounds();
		}*///TODO T7 - will we add this check back?
		{wait(.05);}; // stopsounds doesnt work if the org is deleted same frame
	}
	else
	{
		org waittill( "sounddone" );
	}
	org Delete();
}

/@
"Name: play_on_entity( <alias> )"
"Summary: Play the specified sound alias on an entity at it's origin"
"Module: Sound"
"CallOn: An entity"
"MandatoryArg: <alias> : Sound alias to play"
"Example: guy sound::play_on_entity( "breathing_better" );"
"SPMP: singleplayer"
@/
function play_on_entity( alias )
{
	play_on_tag( alias );
}

function wait_for_sounddone_or_death( org )
{
	self endon( "death" );
	org waittill( "sounddone" );
}

/@
"Name: stop_loop_on_entity( <alias> )"
"Summary: Stop playing the the loop sound alias on an entity"
"Module: Sound"
"CallOn: An entity"
"MandatoryArg: <alias> : Sound alias to stop looping"
"Example: vehicle thread sound::stop_loop_on_entity( "engine_belt_run" );"
"SPMP: singleplayer"
@/
function stop_loop_on_entity( alias )
{
	self notify( "stop sound" + alias );
}

/@
"Name: loop_on_entity( <alias> , <offset> )"
"Summary: Play loop sound alias on an entity"
"Module: Sound"
"CallOn: An entity"
"MandatoryArg: <alias> : Sound alias to loop"
"OptionalArg: <offset> : Offset for sound origin relative to the world from the models origin."
"Example: vehicle thread sound::loop_on_entity( "engine_belt_run" );"
"SPMP: singleplayer"
@/
function loop_on_entity( alias, offset )
{
	org = Spawn( "script_origin", ( 0, 0, 0 ) );
	org endon( "death" );
	thread util::delete_on_death( org );
	if( isdefined( offset ) )
	{
		org.origin = self.origin + offset;
		org.angles = self.angles;
		org LinkTo( self );
	}
	else
	{
		org.origin = self.origin;
		org.angles = self.angles;
		org LinkTo( self );
	}
	//	org endon( "death" );
	org PlayLoopSound( alias );
	//	println( "playing loop sound ", alias, " on entity at origin ", self.origin, " at ORIGIN ", org.origin );
	self waittill( "stop sound" + alias );
	org StopLoopSound( 0.1 );
	org Delete();
}

function loop_in_space(alias, origin, ender)
{
	org = Spawn("script_origin",(0,0,1));
	
	if(!isdefined(origin))
	{
		origin = self.origin;
	}
	
	org.origin = origin;
	org PlayLoopSound(alias);
	
	level waittill(ender);
	
	org StopLoopSound();
	wait 0.1;
	org Delete();
}

function delete_on_death_wait( ent, sounddone )
{
	ent endon( "death" );
	self waittill( "death" );
	if( isdefined( ent ) )
	{
		/*if ( ent IsWaitingOnSound() )//TODO T7 - need this added to MP, not necessary if we don't add "sounddone" support
		{
			ent waittill( sounddone );
		}*/

		ent Delete();
	}
}

function play_on_players( sound, team )
{
	assert( isdefined( level.players ) );
	
	if ( level.splitscreen )
	{	
		if ( isdefined( level.players[0] ) )
			level.players[0] PlayLocalSound(sound);
	}
	else
	{
		if ( isdefined( team ) )
		{
			for ( i = 0; i < level.players.size; i++ )
			{
				player = level.players[i];
				if ( isdefined( player.pers["team"] ) && (player.pers["team"] == team))
					player PlayLocalSound(sound);
			}
		}
		else
		{
			for ( i = 0; i < level.players.size; i++ )
				level.players[i] PlayLocalSound(sound);
		}
	}
}
