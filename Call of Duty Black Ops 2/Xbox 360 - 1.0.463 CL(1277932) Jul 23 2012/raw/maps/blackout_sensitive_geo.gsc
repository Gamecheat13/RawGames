/*
 * Created by ScriptDevelop.
 * User: mslone
 * Date: 3/13/2012
 * Time: 1:50 PM
 * 
 * To change this template use Tools | Options | Coding | Edit Standard Headers.
 */
 
#include common_scripts\utility;
#include maps\_dialog;
#include maps\_utility;

#include maps\blackout_util;

// Mah macroze.
#insert raw\maps\blackout.gsh;
 
run_sensitive_geo()
{
	// set up the script models for the sensitive room.
	level.sensitive_geo = GetEntArray( "sensitive_room_target", "targetname" );
	Assert( level.sensitive_geo.size > 0 );
	
	level.max_pipe_fx = 8;
	
	
	// HACK - these are temp models, so we're faking the scale for them.
	for ( i = 0; i < level.sensitive_geo.size; i++ )
	{
		model = level.sensitive_geo[i];
		if ( IsDefined( model.model) && model.model == "ny_harbor_sub_int_pipes_under" )
		{
			model SetScale( 3.0 );
		}
	}
	
	level thread sensitive_room_pipes();
	level thread snd_pipe_shake(1,(1341, 2308, -324));
	level thread snd_pipe_shake(2,(1433, 2117, -333));
	                           
	}
//Lee audio pipe shake setup
snd_pipe_shake(num,origin)
{
	level waittill ("fxanim_pipes_break_loop_0" + num + "_start");
	ent = Spawn ("script_origin", origin);
	ent PlayLoopSound ("evt_pipe_rattle_" + num);
	level waittill ("fxanim_pipes_break_burst_0" + num + "_start");
	ent delete();
}

get_nearest_seam( origin )
{
	seams = GetStructArray( "steam_break_pos", "targetname" );
	nearest = undefined;
	nearest_dist_sq = 64 * 64;
	foreach ( seam in seams )
	{
		dist_sq = Distance2DSquared( seam.origin, origin );
		if ( dist_sq < nearest_dist_sq )
		{
			nearest = seam;
			nearest_dist_sq = dist_sq;
		}
	}
	
	return nearest;
}

sensitive_geo_watch()
{
	self SetCanDamage( true );
	max_dist_sq = ( 16 * 16 );
	big_damage = 90;	
	self.pipe_fx = [];
	
	// every time we do this much damage, burst another seam.
	const burst_amount = 400;
	
	while ( true )
	{
		self waittill( "damage", damage, attacker, direction, point, type, tagName, modelName, partname, weaponName );
		if ( IsPlayer( attacker ) && type != "MOD_MELEE" )
		{
			// only do it if it's at least a certain distance (16 units) from the last one.
			skipme = false;
			if ( self.pipe_fx.size > 0 )
			{
				dist_sq = Distance2DSquared( point, self.pipe_fx[self.pipe_fx.size].origin);
				skipme = dist_sq < max_dist_sq;
			}
			
			seam = get_nearest_seam( point );
			if ( isdefined( seam ) )
			{
				if ( is_true( seam.disable_fx ) )
				{
					continue;
				}
			}
			
			if ( !skipme )
			{
				if ( self.pipe_fx.size > level.max_pipe_fx )
				{
					// stop the effect, then remove it from the array.
					self.pipe_fx[0] Delete();
					ArrayRemoveIndex( self.pipe_fx, 0 );
				}
				
				// play an effect where the hit happened.
				direction = flat_angle( direction );
				self.pipe_fx[self.pipe_fx.size] = PlayFX( level._effect["steam_burst_1"], point, anglestoforward( direction ) * -1, anglestoup( direction ) );
				playsoundatposition( "evt_pipe_damage_" + level.pipe_fog_level, point );
			}
			
			// see if we've broken a seam.
			if ( !isdefined( seam ) )
			{
				continue;
			}
			
			if ( !IsDefined( seam.damage ) )
			{
				seam.damage = 0;
			}
			seam.damage = seam.damage + damage;
			
			// if the pipe is broken enough, add another spraying position.
			if (seam.damage > burst_amount)
			{
				// only add a spraying position if we haven't already done that here.
				if ( !IsDefined(seam.fx) )
				{
					pipes_dropped = seam do_pipe_fxanims();
					
					level.pipes_burst = level.pipes_burst + 1;
					
					// every other pipe, we go up a level
					if ( level.pipes_burst % 2 == 1 )
					{
						level.pipe_fog_level = min_val( level.pipe_fog_level + 1, 4 );
						level clientnotify( "fog_level_increase" );
					}
					
					// stop playing fx after the fxanim plays.
					if ( pipes_dropped )
					{
						disable_seam_set( seam.script_noteworthy );
					}
				}
			}
		}
	}
}

disable_seam_set( str_seam_list_name )
{
	seam_list = GetStructArray( str_seam_list_name, "script_noteworthy" );
	foreach ( seam in seam_list )
	{
		seam.disable_fx = true;
	}
}

do_pipe_fxanims()
{
	pipes_dropped = false;
	
	// if the pipes haven't dropped yet, drop them.
	if ( isdefined( self.script_noteworthy ) )
	{		
		if ( !isdefined( level.m_pipe_stages ) )
		{
			level.m_pipe_stages = array( 0, 0, 0 );
		}
		
		// Left set.
		if ( self.script_noteworthy == "pipe_set_01" )
		{
			level.m_pipe_stages[0]++;
			if ( level.m_pipe_stages[0] == 2 )
			{
				level notify( "fxanim_pipes_break_loop_01_start" );
				
				level waittill ("fxanim_pipes_break_loop_01_start" );
		
				PlaySoundAtPosition ("evt_pipe_rattle_1", (1341, 2308, -324));
			}
			else if ( level.m_pipe_stages[0] == 4 )
			{
				level notify( "fxanim_pipes_break_burst_01_start" );
				pipes_dropped = true;
			}
		}
		
		// Middle set.
		else if ( self.script_noteworthy == "pipe_set_02" )
		{
			level.m_pipe_stages[1]++;
			if ( level.m_pipe_stages[1] == 2 )
			{
				level notify( "fxanim_pipes_break_loop_02_start" );
			}
			else if ( level.m_pipe_stages[1] == 4 )
			{
				level notify( "fxanim_pipes_break_burst_02_start" );
				pipes_dropped = true;
			}
		}
		
		// Right set.
		else if ( self.script_noteworthy == "drop_pipes" )
		{
			level.m_pipe_stages[2]++;
			if ( level.m_pipe_stages[2] == 3 )
			{
				level notify( "sensitive_pipes_drop" );
				pipes_dropped = true;
			}
		}
	}
	
	return pipes_dropped;
}

sensitive_geo_set_warning_guy( warning_guy )
{
	level.sensitive_geo_warning_guy = warning_guy;
}

sensitive_geo_clear_warning_guy( )
{
	level.sensitive_geo_warning_guy = undefined;
}

sensitive_room_pipes()
{
	level.pipes_burst = 0;
	level.pipe_fog_level = 1;
	array_thread( level.sensitive_geo, ::sensitive_geo_watch );
}