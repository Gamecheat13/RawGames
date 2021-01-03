#using scripts\codescripts\struct;

#using scripts\shared\array_shared;
#using scripts\shared\clientfield_shared;
#using scripts\shared\flag_shared;
#using scripts\shared\system_shared;
#using scripts\shared\trigger_shared;
#using scripts\shared\util_shared;
#using scripts\shared\weapons\_weaponobjects;

    	   	                                                                                                                         	                                                                                                                                                                                                                                                                                                                                                                    	        	     	             	    	   	                           	                               	                                	                                                              	                                                                                                              	                            	                                     	                                       	                                                               	   	                  	       	                                                    	                   	                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                       	                                                                                        	           	                        	                                            	                                             	                                                   	                                                             	                                                         	                                                                    	                                                                                                                                                                                                    	                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                     	                                                              	                                                          	                                   	                                   	                                                    	                                       

#using scripts\zm\_zm_audio;
#using scripts\zm\_zm_equipment;
#using scripts\zm\_zm_placeable_mine;
#using scripts\zm\_zm_score;
#using scripts\zm\_zm_stats;
#using scripts\zm\_zm_utility;
#using scripts\zm\_zm_weapons;

#precache( "fx", "_t6/weapon/claymore/fx_claymore_laser" );

function autoexec __init__sytem__() {     system::register("claymore",&__init__,undefined,undefined);    }

function __init__()
{
	level._effect[ "claymore_laser" ] = "_t6/weapon/claymore/fx_claymore_laser";
	
	zm_placeable_mine::add_mine_type( "claymore", &"ZOMBIE_CLAYMORE_PICKUP" );
	zm_placeable_mine::add_planted_callback( &play_claymore_effects, "claymore" );
	zm_placeable_mine::add_planted_callback( &claymore_detonation, "claymore" );
}

function play_claymore_effects( e_planter )
{
	self endon("death");
	self zm_utility::waittill_not_moving();
	PlayFXOnTag( level._effect[ "claymore_laser" ], self, "tag_fx" );
}

function claymore_detonation( e_planter )
{
	self endon("death");
	
	// wait until we settle
	self zm_utility::waittill_not_moving();
	
	detonateRadius = 96;
	
	damagearea = spawn( "trigger_radius", self.origin, 1 + 8, detonateRadius, detonateRadius * 2 );
	damagearea SetExcludeTeamForTrigger( self.owner.team );
	damagearea enablelinkto();
	damagearea linkto( self );
	
	if ( ( isdefined( self.isOnBus ) && self.isOnBus ) )
		damagearea SetMovingPlatformEnabled(true);
	self.damagearea = damagearea;

	self thread delete_mines_on_death( self.owner, damagearea );

	if ( !isdefined( self.owner.placeable_mines ) ) self.owner.placeable_mines = []; else if ( !IsArray( self.owner.placeable_mines ) ) self.owner.placeable_mines = array( self.owner.placeable_mines ); self.owner.placeable_mines[self.owner.placeable_mines.size]=self;;

	while ( 1 )
	{
		damagearea waittill( "trigger", ent );
		
		if ( isdefined( self.owner ) && ent == self.owner )
			continue;

		if( isDefined( ent.pers ) && isDefined( ent.pers["team"] ) && ent.pers["team"] == self.team )
			continue;
		
		if( ( isdefined( ent.ignore_placeable_mine ) && ent.ignore_placeable_mine ) )
		{
			continue;
		}
		
		if ( !ent should_trigger_claymore( self ) )
			continue;

		if ( ent damageConeTrace(self.origin, self) > 0 )
		{
			self playsound ("wpn_claymore_alert");
			wait 0.4;
			if ( isdefined( self.owner ) )
				self detonate( self.owner );
			else
			self detonate( undefined );
				
			return;
		}
	}
}

function private should_trigger_claymore( e_mine )  // self == victim
{
	const min_dist = 20;
	const n_detonation_angle = 70;
	
	n_detonation_dot = cos( n_detonation_angle );
	
	pos = self.origin + (0,0,32);
	
	dirToPos = pos - e_mine.origin;
	objectForward = anglesToForward( e_mine.angles );
	
	dist = vectorDot( dirToPos, objectForward );
	if ( dist < min_dist )
		return false;
	
	dirToPos = vectornormalize( dirToPos );
	
	dot = vectorDot( dirToPos, objectForward );
	return ( dot > n_detonation_dot );
}

function private delete_mines_on_death( player, ent )
{
	self waittill("death");

	if ( IsDefined( player ) )
	{
		ArrayRemoveValue( player.placeable_mines, self );
	}

	wait .05;

	if ( isdefined( ent ) )
		ent delete();
}
