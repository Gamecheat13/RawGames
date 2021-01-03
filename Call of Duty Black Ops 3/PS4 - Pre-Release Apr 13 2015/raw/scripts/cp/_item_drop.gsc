#using scripts\codescripts\struct;

#using scripts\shared\array_shared;
#using scripts\shared\callbacks_shared;
#using scripts\shared\clientfield_shared;
#using scripts\shared\flag_shared;
#using scripts\shared\util_shared;

    	   	                                                                                                                         	                                                                                                                                                                                                                                                                                                                                                                    	        	     	             	    	   	                           	                               	                                	                                                              	                                                                                                              	                            	                                     	                                       	                                                               	   	                  	       	                                                    	                   	                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                       	                                                                                        	           	                        	                                            	                                             	                                                   	                                                             	                                                         	                                                                    	                                                                                                                                                                                                    	                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                     	                                                              	                                                          	                                   	                                   	                                                    	                                       
                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                            	                                                                                                                                                                                                                                                                                                                                                                                       






#namespace item_drop; 

function autoexec main()
{
	if(!isdefined(level.item_drops))level.item_drops=[];
	level thread watch_level_drops();
	{wait(.05);};
	callback::on_actor_killed( &actor_killed_check_drops );
}


function add_drop( name, model, callback )
{
	if(!isdefined(level.item_drops))level.item_drops=[];
	if (!IsDefined(level.item_drops[name]) )
	{
		level.item_drops[name] = spawnstruct();
	}
	level.item_drops[name].name = name;
	level.item_drops[name].model = model;
	level.item_drops[name].callback = callback;
}

function add_drop_onaikilled( name, dropchance )
{
	if(!isdefined(level.item_drops))level.item_drops=[];
	if (!IsDefined(level.item_drops[name]) )
	{
		level.item_drops[name] = spawnstruct();
	}
	level.item_drops[name].name = name;
	level.item_drops[name].onaikilled = dropchance;
}

function add_drop_spawnpoints( name, spawnpoints )
{
	if(!isdefined(level.item_drops))level.item_drops=[];
	if (!IsDefined(level.item_drops[name]) )
	{
		level.item_drops[name] = spawnstruct();
	}
	level.item_drops[name].name = name;
	level.item_drops[name].spawnpoints = spawnpoints;
}


	
function actor_killed_check_drops()
{
	//keeps the armor drops localized to these maps for the first sprint
	//TODO remove check after first sprint
	if( level.script != "sp_proto_characters" && level.script != "challenge_bloodbath" )
		return;
	
	if ( ( isdefined( self.item_drops_checked ) && self.item_drops_checked ) )
		return;
	self.item_drops_checked=true;

	drop = array::random( level.item_drops );
	/#
		if ( IsDefined(drop.onaikilled) )
		{
			drop.onaikilled = GetDvarFloat("scr_drop_rate_"+drop.name);
		}
	#/
	
	if ( GetDvarInt( "scr_drop_autorecover" ) )
	{
		killer = self.dds_dmg_attacker;
		if (IsDefined(killer))
		{
			if (IsDefined(drop.callback))
			{
				multiplier = self actor_drop_multiplier();
				if ( !killer [[drop.callback]](multiplier) )
					return;
			}
			playsoundatposition( "fly_supply_bag_pick_up", killer.origin );
		}
	}
	else if ( IsDefined(drop.onaikilled) && RandomFloat( 1 ) < drop.onaikilled )
	{
		origin = self.origin + (0,0,30);
		newdrop = spawn_drop( drop, origin );
		newdrop.multiplier = self actor_drop_multiplier();
		level.item_drops_current[level.item_drops_current.size] = newdrop;
		newdrop thread watch_player_pickup();
	}
}

function actor_drop_multiplier()
{
	min_mult = GetDvarFloat( "scr_drop_default_min" );
	if ( IsDefined(self.drop_min_multiplier) )
		min_mult = self.drop_min_multiplier;
	max_mult = GetDvarFloat( "scr_drop_default_max" );
	if ( IsDefined(self.drop_max_multiplier) )
		max_mult = self.drop_max_multiplier;
	if (min_mult < max_mult)
		return RandomFloatRange(min_mult,max_mult);
	return min_mult;
}

function watch_level_drops()
{
	level.item_drops_current = [];
	level flag::wait_till("all_players_spawned" );
	
	while ( 1 ) 
	{
		wait 15; 
		if ( level.item_drops_current.size < 1 && level.item_drops.size > 0 )
		{
			drop = array::random( level.item_drops );
			if (IsDefined(drop.spawnpoints))
			{
				origin = array::random( drop.spawnpoints );
				newdrop = spawn_drop( drop, origin );
				level.item_drops_current[level.item_drops_current.size] = newdrop;
				newdrop thread watch_player_pickup();
			}
		}
	}
}

function spawn_drop( drop, origin )
{
	nd = spawnstruct();
	nd.drop = drop;
	nd.origin = origin;
	nd.model = spawn( "script_model", nd.origin );
	nd.model SetModel( drop. model );
	nd.model thread spin_it();
	
	playsoundatposition("fly_supply_bag_drop", origin);

	return nd;
}



function spin_it()
{
	angle = 0;
	time = 0;
	self endon("death");
	while( IsDefined(self) )
	{
		angle = time * 90;
		self.angles = (0, angle, 0);
		{wait(.05);};
		time += .05;		
	}
}




function watch_player_pickup()
{
	trigger = Spawn( "trigger_radius", self.origin, 0, 60, 60 );
	self.pickUpTrigger = trigger;
	
	while( IsDefined(self) )
	{
		trigger waittill("trigger",player); 
		if ( player thread pickup( self ) )
			break;
	}
	
	trigger delete();
}

function pickup( drop )
{
	if (IsDefined(drop.drop.callback))
	{
		multiplier = 1.0;
		if (Isdefined(drop.multiplier))
			multiplier = drop.multiplier;
		if ( !self [[drop.drop.callback]](multiplier) )
			return false;
	}
	playsoundatposition( "fly_supply_bag_pick_up", self.origin );
	drop.model Delete();
	ArrayRemoveValue( level.item_drops_current, drop );
	return true;
}
