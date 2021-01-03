#using scripts\codescripts\struct;

#using scripts\shared\demo_shared;

    	   	                                                                                                                         	                                                                                                                                                                                                                                                                                                                                                                    	        	     	             	    	   	                           	                               	                                	                                                              	                                                                                                              	                            	                                     	                                       	                                                               	   	                  	       	                                                    	                   	                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                       	                                                                                        	           	                        	                                            	                                             	                                                   	                                                             	                                                         	                                                                    	                                                                                                                                                                                                    	                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                     	                                                              	                                                          	                                   	                                   	                                                    	                                       
                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                            	                                                                                                                                                                                                                                                                                                                                                                                       

#using scripts\zm\_zm_buildables;
#using scripts\zm\_zm_unitrigger;
#using scripts\zm\_zm_utility;

                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                             	                             
                                                                                                                               

function add_buildable_to_pool( stub, poolname )
{
	if (!isdefined(level.buildablePools))
		level.buildablePools = [];

	if (!isdefined(level.buildablePools[poolname]))
	{
		level.buildablePools[poolname] = SpawnStruct();
		level.buildablePools[poolname].stubs = [];
	}

	level.buildablePools[poolname].stubs[ level.buildablePools[poolname].stubs.size ] = stub;
	if (!IsDefined(level.buildablePools[poolname].buildable_slot))
	{
		level.buildablePools[poolname].buildable_slot = stub.buildablestruct.buildable_slot;
	}
	else
	{
		/#
			assert(level.buildablePools[poolname].buildable_slot == stub.buildablestruct.buildable_slot);
		#/
	}
	

	stub.buildable_pool = level.buildablePools[poolname];

	stub.original_prompt_and_visibility_func = stub.prompt_and_visibility_func;
	stub.original_trigger_func = stub.trigger_func;

	
	stub.prompt_and_visibility_func = &pooledbuildabletrigger_update_prompt;
	reregister_unitrigger(stub, &pooled_buildable_place_think);
} 


function reregister_unitrigger( unitrigger_stub, new_trigger_func )
{
	static = false;
	if (isdefined(unitrigger_stub.in_zone))
		static = true;

	zm_unitrigger::unregister_unitrigger(unitrigger_stub);
	
	unitrigger_stub.trigger_func = new_trigger_func;
	if ( static )
		zm_unitrigger::register_static_unitrigger(unitrigger_stub, new_trigger_func, false);
	else
		zm_unitrigger::register_unitrigger(unitrigger_stub, new_trigger_func );
}

function randomize_pooled_buildables( poolname )
{
	level waittill( "buildables_setup" );
	
	if (isdefined(level.buildablePools[poolname]))
	{
		count = level.buildablePools[poolname].stubs.size;
		if ( count > 1 )
		{
			targets = []; 
			for ( i=0; i<count; i++ )
			{
				while ( 1 )
				{
					p = RandomInt( count );
					if (!IsDefined(targets[p]))
				    {
						targets[p]=i;
						break;
				    }
				}
			}
			for ( i=0; i<count; i++ )
			{
				if (IsDefined(targets[i]) && targets[i]!=i )
			    {
					swap_buildable_fields( level.buildablePools[poolname].stubs[i], level.buildablePools[poolname].stubs[targets[i]] );
			    }
			}
		}
	}
}

function pooledbuildable_has_piece(  piece )
{
	return IsDefined( self pooledbuildable_stub_for_piece( piece ) );
}

function pooledbuildable_stub_for_piece(  piece )
{
	foreach( stub in self.stubs )
	{
		if ( isdefined( stub.bound_to_buildable ))
			continue;
		if ( stub.buildableZone zm_buildables::buildable_has_piece(piece) )
			return stub;
	}
	return undefined;
}

function pooledbuildabletrigger_update_prompt( player )
{
	can_use = self.stub pooledbuildablestub_update_prompt( player, self );
	self SetHintString( self.stub.hint_string );
	if(isdefined(self.stub.cursor_hint))
	{
		if ( self.stub.cursor_hint == "HINT_WEAPON" && IsDefined(self.stub.cursor_hint_weapon) )
			self SetCursorHint(self.stub.cursor_hint,self.stub.cursor_hint_weapon);	
		else
			self SetCursorHint(self.stub.cursor_hint);	
	}
	return can_use;
}

function pooledbuildablestub_update_prompt( player, trigger )
{
	if (!self zm_buildables::anystub_update_prompt( player ))
		return false;
	can_use = true;
	
	if ( IsDefined( self.custom_buildablestub_update_prompt ) && ! self [[ self.custom_buildablestub_update_prompt ]]( player ) )
	{
		return false;
	}
	
	self.cursor_hint = "HINT_NOICON";
	self.cursor_hint_weapon = undefined;
	if (!( isdefined( self.built ) && self.built ))
	{	
		slot = self.buildablestruct.buildable_slot;
		if (!isdefined(player zm_buildables::player_get_buildable_piece(slot)))
		{
			if (isdefined(level.zombie_buildables[ self.buildable_name ].hint_more))
				self.hint_string = level.zombie_buildables[ self.buildable_name ].hint_more;
			else
				self.hint_string = &"ZOMBIE_BUILD_PIECE_MORE";
			
			if( IsDefined( level.custom_buildable_need_part_VO ) )
			{
				player thread [[ level.custom_buildable_need_part_VO ]]();
			}
			
			return false;
		}
		else if ( isdefined( self.bound_to_buildable ) && !self.bound_to_buildable.buildableZone zm_buildables::buildable_has_piece(player zm_buildables::player_get_buildable_piece(slot)))
		{
			if (isdefined(level.zombie_buildables[ self.bound_to_buildable.buildable_name ].hint_wrong))
				self.hint_string = level.zombie_buildables[ self.bound_to_buildable.buildable_name ].hint_wrong;
			else
				self.hint_string = &"ZOMBIE_BUILD_PIECE_WRONG";
			
			if( IsDefined( level.custom_buildable_wrong_part_VO ) )
			{
				player thread [[ level.custom_buildable_wrong_part_VO ]]();
			}
			
			return false;
		}
		else if (!isdefined( self.bound_to_buildable ) && !self.buildable_pool pooledbuildable_has_piece(player zm_buildables::player_get_buildable_piece(slot)))
		{
			if (isdefined(level.zombie_buildables[ self.buildable_name ].hint_wrong))
				self.hint_string = level.zombie_buildables[ self.buildable_name ].hint_wrong;
			else
				self.hint_string = &"ZOMBIE_BUILD_PIECE_WRONG";
			return false;
		}
		else if ( isdefined( self.bound_to_buildable ) )
		{
			assert (isdefined(level.zombie_buildables[ self.buildable_name ].hint), "Missing buildable hint" );
			if (isdefined(level.zombie_buildables[ self.buildable_name ].hint))
				self.hint_string = level.zombie_buildables[ self.buildable_name ].hint;
			else
				self.hint_string = "Missing buildable hint";
		}
		else
		{
			assert (isdefined(level.zombie_buildables[ self.buildable_name ].hint), "Missing buildable hint" );
			if (isdefined(level.zombie_buildables[ self.buildable_name ].hint))
				self.hint_string = level.zombie_buildables[ self.buildable_name ].hint;
			else
				self.hint_string = "Missing buildable hint";
		}
	}
	else 
	{
		return trigger [[self.original_prompt_and_visibility_func]]( player );
	}

	return true;
}


function find_bench( bench_name )
{
	return GetEnt( bench_name, "targetname" );
}



function swap_buildable_fields( stub1, stub2 )
{
	tbz = stub2.buildableZone;
	stub2.buildableZone = stub1.buildableZone;
	stub2.buildableZone.stub = stub2;
	stub1.buildableZone = tbz;
	stub1.buildableZone.stub = stub1;
	
	tbs = stub2.buildableStruct;
	stub2.buildableStruct = stub1.buildableStruct;
	stub1.buildableStruct = tbs;

	te = stub2.buildable_name;
	stub2.buildable_name = stub1.buildable_name;
	stub1.buildable_name = te;
	
	th = stub2.hint_string;
	stub2.hint_string = stub1.hint_string;
	stub1.hint_string = th;
	
	ths = stub2.trigger_hintstring;
	stub2.trigger_hintstring = stub1.trigger_hintstring;
	stub1.trigger_hintstring = ths;
	
	tp = stub2.persistent;
	stub2.persistent = stub1.persistent;
	stub1.persistent = tp;

	tobu = stub2.onbeginuse;
	stub2.onbeginuse = stub1.onbeginuse;
	stub1.onbeginuse = tobu;
	
	tocu = stub2.oncantuse;
	stub2.oncantuse = stub1.oncantuse;
	stub1.oncantuse = tocu;
	
	toeu = stub2.onenduse;
	stub2.onenduse = stub1.onenduse;
	stub1.onenduse = toeu;
	
	tt = stub2.target;
	stub2.target = stub1.target;
	stub1.target = tt;
	
	ttn = stub2.targetname;
	stub2.targetname = stub1.targetname;
	stub1.targetname = ttn;
	
	tw = stub2.equipment;
	stub2.equipment = stub1.equipment;
	stub1.equipment = tw;

	pav = stub2.original_prompt_and_visibility_func;
	stub2.original_prompt_and_visibility_func = stub1.original_prompt_and_visibility_func;
	stub1.original_prompt_and_visibility_func = pav;
	
	if (IsDefined(stub1.model) && IsDefined(stub2.model))
	{
		bench1 = undefined;
		bench2 = undefined;
		transfer_pos_as_is = true;
		if (IsDefined(stub1.model.target) && IsDefined(stub2.model.target))
		{
			bench1 = find_bench( stub1.model.target );
			bench2 = find_bench( stub2.model.target );
			if (Isdefined(bench1) && IsDefined(bench2))
			{
				transfer_pos_as_is = false;
				w2lo1 = bench1 WorldToLocalCoords( stub1.model.origin );
				w2la1 = stub1.model.angles - bench1.angles;
				w2lo2 = bench2 WorldToLocalCoords( stub2.model.origin );
				w2la2 = stub2.model.angles - bench2.angles;
				stub1.model.origin = bench2 LocalToWorldCoords( w2lo1 ); 
				stub1.model.angles = bench2.angles + w2la1;
				stub2.model.origin = bench1 LocalToWorldCoords( w2lo2 ); 
				stub2.model.angles = bench1.angles + w2la2;
			}
			tmt = stub2.model.target;
			stub2.model.target = stub1.model.target;
			stub1.model.target = tmt;
		}
	
		tm = stub2.model;
		stub2.model = stub1.model;
		stub1.model = tm;
	
		if ( transfer_pos_as_is )
		{
			tmo = stub2.model.origin; 
			tma = stub2.model.angles; 
			stub2.model.origin = stub1.model.origin;
			stub2.model.angles = stub1.model.angles;
			stub1.model.origin = tmo;
			stub1.model.angles = tma;
		}
	}
}

function pooled_buildable_place_think()
{
	self notify( "pooled_buildable_place_think" );
	self endon( "pooled_buildable_place_think" );
	self endon("kill_trigger");

	if (( isdefined( self.stub.built ) && self.stub.built ))
	{
		return zm_buildables::buildable_place_think();
	}

	player_built = undefined;
	while(!( isdefined( self.stub.built ) && self.stub.built ))
	{	
		self waittill( "trigger", player );
	
		if (player != self.parent_player)
			continue; 
		
		if( !zm_utility::is_player_valid( player ) )
		{
			player thread zm_utility::ignore_triggers( 0.5 );
			continue;
		}

		bind_to = self.stub;
		slot = bind_to.buildablestruct.buildable_slot;
		if (!IsDefined(self.stub.bound_to_buildable))
			bind_to = self.stub.buildable_pool pooledbuildable_stub_for_piece( player zm_buildables::player_get_buildable_piece(slot) );
		if ( !IsDefined(bind_to) ||
		     ( IsDefined(self.stub.bound_to_buildable) && (self.stub.bound_to_buildable != bind_to) ) ||
		     ( IsDefined(bind_to.bound_to_buildable) && (self.stub != bind_to.bound_to_buildable) ) )
		{
			self.stub.hint_string = "";
			self SetHintString( self.stub.hint_string );
			if ( IsDefined( self.stub.onCantUse ) )
			{
				self.stub [[ self.stub.onCantUse ]]( player );
			}
			continue;
		}
			
		status = player zm_buildables::player_can_build( bind_to.buildableZone );
		if ( !status )
		{
			self.stub.hint_string = "";
			self SetHintString( self.stub.hint_string );
			if ( IsDefined( bind_to.onCantUse ) )
			{
				bind_to [[ bind_to.onCantUse ]]( player );
			}
		}
		else
		{
			if ( IsDefined( bind_to.onBeginUse ) )
				self.stub [[ bind_to.onBeginUse ]]( player );

			result = self zm_buildables::buildable_use_hold_think( player, bind_to );
			team = player.pers["team"];
			if ( result )
			{
				if (IsDefined(self.stub.bound_to_buildable) &&  (self.stub.bound_to_buildable != bind_to))
					result = false;
				if (IsDefined(bind_to.bound_to_buildable) &&  (self.stub != bind_to.bound_to_buildable))
					result = false;
			}

			if ( IsDefined( bind_to.onEndUse ) )
				self.stub [[ bind_to.onEndUse ]]( team, player, result );

			if ( !result )
				continue;
			
			if (!IsDefined(self.stub.bound_to_buildable) && IsDefined(bind_to))
			{
				if ( bind_to != self.stub )
					swap_buildable_fields( self.stub, bind_to );
				self.stub.bound_to_buildable = self.stub;
			}

			if ( IsDefined( self.stub.onUse ) )
			{
				self.stub [[ self.stub.onUse ]]( player );
			}

			if (IsDefined(player zm_buildables::player_get_buildable_piece(slot)))
			{
				prompt = player zm_buildables::player_build( self.stub.buildableZone );
				player_built = player;
				self.stub.hint_string = prompt;
				self SetHintString( self.stub.hint_string );
			}
		}
	}

	switch ( self.stub.persistent )
	{
		case 1:
			self zm_buildables::bptrigger_think_persistent( player_built ); break;
		case 0:
			self zm_buildables::bptrigger_think_one_time( player_built ); break;
		case 3:
			self zm_buildables::bptrigger_think_unbuild( player_built ); break;
		case 2:
			self zm_buildables::bptrigger_think_one_use_and_fly( player_built ); break;
		case 4:
			self [[self.stub.custom_completion_callback]]( player_built ); break;
	}

}

