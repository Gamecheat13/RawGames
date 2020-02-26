#include common_scripts\utility;
#include maps\_utility;
#include maps\_scene;
#include maps\_music;

#insert raw\common_scripts\utility.gsh;
#insert raw\maps\_utility.gsh;
#insert raw\maps\_so_rts.gsh;


#define	MIX_VOX_ID					0
#define	MAX_VOX_ID					4

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////	

/////////////////////////////////////////////////////////////////////////////////////////////////////////////////
// rts.csv table column defines 
#define TABLE_EV_INDEX_START 		500 // First index for EVENT Table
#define TABLE_EV_INDEX_END 			800	// Last index for EVENT Table

#define TABLE_IDX					0
#define TABLE_EV_REF 				1	// event ref
#define TABLE_EV_TYPE 				2	// event type
#define TABLE_EV_PARAM1				3	// param1
#define TABLE_EV_PARAM2				4	// param2
#define TABLE_EV_PARAM3				5	// param3
#define TABLE_EV_COOLDOWN			6	// cooldown in msec
#define TABLE_EV_LATENCY			7	// how long can this thing exist before becoming irrelevant
#define TABLE_EV_TRIGGERNOTIFY		8	// event fires off on this level notify
#define TABLE_EV_MAXPLAYS			9	// max number of times to play
#define TABLE_EV_PRIORITY			10	// priority, blank = 0; higher the more priorty
#define TABLE_EV_DAISY				11	// daisy; This is an optional label which will get triggered when current event is triggered (daisy chained)

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////	
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////	
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////	

init()
{
	level.rts.events = [];
	level.rts.event_queue = [];
	level.rts.events_dialogChannelLock 		= false;

	level.rts.events_dlgEnt	= Spawn( "script_model",(0,0,0));
	level.rts.events_dlgEnt	SetModel( "tag_origin" );

	level.rts.voxIDs			= [];
	level.rts.voxIDs["allies"]	= [];
	flag_init( "rts_event_ready" );


	types = [];
	types[EVENT_TYPE_DIALOG] 	= "dialog" ;
	types[EVENT_TYPE_SFX] 		= "sfx";
	types[EVENT_TYPE_MUSIC] 	= "music";
	types[EVENT_TYPE_FX] 		= "fx";
	types[EVENT_TYPE_CALLBACK] 	= "callback";
	types[EVENT_TYPE_MULTI] 	= "multi";
	level.rts.event_types 		= types;

	event_populate("sp/so_rts/rts.csv");
	event_populate(level.rts_def_table);
	level thread event_process();
}

/////////////////////////////////////////////////////////////////////////////////////////////////////
//"Name: TableLookup( <filename>, <search column num>, <search value>, <return value column num> )"
//"Summary: look up a row in a table and pull out a particular column from that row"
//"Module: Precache"
//"MandatoryArg: <filename> The table to look up"
//"MandatoryArg: <search column num> The column number of the stats table to search through"
//"MandatoryArg: <search value> The value to use when searching the <search column num>"
//"MandatoryArg: <return value column num> The column number value to return after we find the correct row"
//"Example: TableLookup( "mp/statstable.csv", 0, "INDEX_KILLS", 1 );"
lookup_value( ref, idx, column_index, table )
{
	assert( IsDefined(idx) );
	return tablelookup( table, TABLE_IDX, idx, column_index );
}
get_event_ref_by_index( idx, table )
{
	return tablelookup( table, TABLE_IDX, idx, TABLE_EV_REF );
}


event_populate(table)
{
	types = [];
	types["dialog"] 	= EVENT_TYPE_DIALOG;
	types["sfx"] 		= EVENT_TYPE_SFX;
	types["music"] 		= EVENT_TYPE_MUSIC;
	types["fx"] 		= EVENT_TYPE_FX;
	types["multi"]		= EVENT_TYPE_MULTI;
	

	for( i = TABLE_EV_INDEX_START; i <= TABLE_EV_INDEX_END; i++ )
	{		
		ref = get_event_ref_by_index( i, table );
		if ( !isdefined( ref ) || ref == "" )
			continue;
		
		type				= lookup_value( ref, i, TABLE_EV_TYPE, table );
		param1				= lookup_value( ref, i, TABLE_EV_PARAM1, table );
		param2				= lookup_value( ref, i, TABLE_EV_PARAM2, table );
		param3				= lookup_value( ref, i, TABLE_EV_PARAM3, table );
		cooldown			= float(lookup_value( ref, i, TABLE_EV_COOLDOWN, table ));
		latency				= float(lookup_value( ref, i, TABLE_EV_LATENCY, table ));
		triggernotify		= lookup_value( ref, i, TABLE_EV_TRIGGERNOTIFY, table );
		maxPlays			= int(lookup_value( ref, i, TABLE_EV_MAXPLAYS, table ));
		priority			= int(lookup_value( ref, i, TABLE_EV_PRIORITY, table ));
		daisy				= lookup_value( ref, i, TABLE_EV_DAISY, table );


		assert(isDefined(types[type]),"Illegal type parsed in event table:" + type);
		type = types[type];
		
		if (param1 == "" )
			param1 = undefined;
		if (param2 == "" )
			param2 = undefined;
		if (param3 == "" )
			param3 = undefined;
			
		if (cooldown == 0)
			cooldown = undefined;
		if (latency == 0)
			latency = undefined;
		if (triggernotify == "")
			triggernotify = undefined;
		if (maxPlays == 0)
			maxPlays = undefined;

		if ( daisy == "" )
			daisy = undefined;
			
		if ( type == EVENT_TYPE_MULTI )
		{
			assert(isDefined(param1),"param1 must contain the list of event refs to trigger seperated by a space");
		}
		register_event(ref,	make_event_param(type,param1,param2,param3),cooldown,latency,triggernotify,maxPlays,priority,daisy);
	}
}

event_clearAll(type)
{
	if (!isDefined(type))
	{
		level.rts.event_queue = [];
	}
	else
	{
		unprocessed = [];
		for (i=0;i<level.rts.event_queue.size ;i++)
		{
			event = level.rts.event_queue[i];
			if ( event.data.type != type )
			{
				unprocessed[unprocessed.size] = event;
			}
		}
		level.rts.event_queue = unprocessed;
	}
}

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////	
event_process()
{
	while(1)
	{
		processed 	= [];
		unprocessed  = [];
		if (level.rts.event_queue.size > 0 )
		{
			time = GetTime();
			for (i=0;i<level.rts.event_queue.size ;i++)
			{
				event = level.rts.event_queue[i];
				if (isDefined(event.def.latency))
				{
					if ( time > event.timestamp+event.def.latency) //too old, toss it
					{
						event.executedAt = time;
						event.expired	 = true;
						processed[processed.size] = event;
						continue;
					}
				}
				if (isDefined(event.def.lastExecutedAt) && isDefined(event.def.cooldown) )//too early to retrigger this
				{
					if ( time < event.def.lastExecutedAt+event.def.cooldown)
					{
						continue;
					}
				}
				
				
				
				result = event_trigger(event);
				assert(isDefined(result),"event callbacks need to return result");
				if (result)
				{
					event.executedAt = time;
					processed[processed.size] = event;
					continue;
				}
			}
			
			for(i=0;i<level.rts.event_queue.size;i++)
			{
				if ( !isDefined(level.rts.event_queue[i].executedAt ) )
				{
					unprocessed[unprocessed.size] = level.rts.event_queue[i];
				}
			}
			
			level.rts.event_queue = unprocessed;
			
			for(i =0;i<processed.size;i++)
			{
				event = processed[i];
				assert(isDefined(event.executedAt));
				level notify("rts_event_"+event.def.ref);
				/#
				println("[Events in queue: " + level.rts.event_queue.size +"]\t("+event.def.priority+")Event ("+event.def.ref+") "+(IS_TRUE(event.expired)?"EXPIRED":"processed")+" at "+event.executedAt+" of type: "+level.rts.event_types[event.data.type] + (isDefined(event.dynamic_alias)?" Dynamic alias triggered:"+event.dynamic_alias:"") );
				#/
				event.def.lastExecutedAt = event.executedAt;
			}
		}
	
		wait 0.05;
	}
}
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////	
make_event_param(type, param1, param2, param3)
{
	dataParam 			= spawnstruct();
	dataParam.type 		= type;
	dataParam.param1 	= param1;
	dataParam.param2 	= param2;
	dataParam.param3 	= param3;
	
	return dataParam;
}
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////	
register_event(ref,dataParam,cooldown,latency,trigNotify,oneTimeOnly,priority=0,daisy)
{
	assert(!isDefined(level.rts.events[ref]),"Event with this ref name already exists");
	event = spawnstruct();
	event.ref 			= ref;
	event.cooldown 		= cooldown;
	event.latency 		= latency;
	event.data			= dataParam;
	event.onNotify 		= trigNotify;
	event.oneTimeOnly 	= oneTimeOnly;
	event.priority		= priority;
	event.count			= 0;
	event.daisy			= daisy;
	if (isDefined(event.onNotify))
	{
		level thread event_listener(event);
	}
	if (isDefined(event.latency) && event.latency <= 0)
	{
		event.latency = 100; //give it a fighting chance.. zero latency not possible.. min 50;
	}
	level.rts.events[ref] = event;
}
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////	
event_listener(event)
{
	level endon( "rts_event_"+event.ref);
	level waittill(event.onNotify);
	add_event_to_trigger(event);
	if (IS_TRUE(event.oneTimeOnly))
		return;
	else
		level thread event_listener(event);
}
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////	
priorityEventCompFunc( e1, e2, param )
{
	return e1.def.priority >= e2.def.priority;
}
add_event_to_trigger(event_ref,param)
{
	timestamp = GetTime();
	if (isDefined(event_ref.lastExecutedAt) && isDefined(event_ref.cooldown) )
	{
		if ( timestamp < event_ref.lastExecutedAt+event_ref.cooldown)
			return false;
	}
	if (IS_TRUE(event_ref.oneTimeOnly) && event_ref.count>0 )
	{
		return false;
	}

	if(event_ref.data.type == EVENT_TYPE_MULTI)
	{
		refs = strtok(event_ref.data.param1," ");
		for(i=0;i<refs.size;i++)
		{
			trigger_event(refs[i],param);
		}
		return true;
	}
	
	event 				= spawnstruct();
	event.def			= event_ref;
	event.data			= event_ref.data;
	event.timestamp		= timestamp;
	event.dparam		= param;			//optional 'dynamic' parameter
	event_ref.count++;
	
	level.rts.event_queue[level.rts.event_queue.size] = event;
	if ( level.rts.event_queue.size > 1 )
	{
		level.rts.event_queue = maps\_utility_code::mergesort( level.rts.event_queue, ::priorityEventCompFunc );
	}
	if (isDefined(event_ref.daisy))
	{
		trigger_event(event_ref.daisy,param);
	}
	return true;
}
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////	
trigger_event(ref,param)
{
	if (!flag("rts_event_ready"))
		return false;
		
	if ( isDefined(level.rts.events[ref]))
	{
		return add_event_to_trigger(level.rts.events[ref],param);
	}
	else
	{
	/#
		println("@@@@@ ("+GetTime()+") WARNING: Event triggered but no reference was found ("+ref+")");
	#/
	}
	return false;
}
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////	
event_PlaySound(alias,note,origin)
{
	if(isDefined(origin))
		level.rts.events_dlgEnt.origin = origin;
	
	level.rts.events_dialogChannelLock = true;
	/#
//		println("[Event \t\t\t\t\t\tplaySound("+alias+","+note+")]");
	#/
	level.rts.events_dlgEnt playSound( alias, note );
	level.rts.events_dlgEnt waittill(note);
	level.rts.events_dialogChannelLock = false;
	level notify(note+"_done");
}
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////	
event_trigger(event)
{
	time = GetTime();
	switch(event.data.type)
	{
		case EVENT_TYPE_DIALOG:
			if (IS_TRUE(level.rts.events_dialogChannelLock) )
				return false;
			
			alias = event.data.param1;
			assert(isDefined(alias),"Unexpected data passed to event_trigger");

			if(isDefined(event.data.param2))
			{
				if ( event.data.param2 == "player" )
					target = level.rts.player;
				else			
					target = GetEnt(event.data.param2,"targetname");
			}
				
			if( isdefined(target) && (target == level.rts.player || isDefined(target.rts_unloaded)) )
			{
				thread event_PlaySound(alias,event.def.ref,target.origin);
			}
			else
			{
				target= event.data.param3;
				assert(target=="allies" || target=="axis","Unexpected data passed to event trigger");
					
				guys = getValidVoxList(target);
				if ( guys.size == 0 )
					return false;
					
				guy  = guys[RandomInt(guys.size)];
				if(!isDefined(guy))
					return false;
					
				if(issubstr(alias,"#%#"))
				{
					tokens = strtok(alias,"#%#");
					alias  = tokens[0] + guy.voxID + tokens[1];
				}
				event.dynamic_alias = alias;
				thread event_PlaySound(alias,event.def.ref,guy.origin);
			}
			return true;
	
		case EVENT_TYPE_SFX:
			alias = event.data.param1;
			assert(isDefined(alias),"Unexpected data passed to event_trigger");
			
			if (isDefined(event.data.param2) )
			{
				if ( event.data.param2 == "player" )
				{
					position = level.rts.player.origin;
				}
				else	
				{
					target = GetEnt(event.data.param2,"targetname");
					assert(isDefined(target),"entity not found");
					if (isDefined(target))
						position = target.origin;
				}
			}
			if (isDefined(event.dparam))
			{
				entity = event.dparam;
			}
			if (isDefined(entity))
			{
				entity PlaySound(alias);
			}			
			else
			{
				if (isDefined(position) )
				{
					PlaySoundAtPosition( alias, position );
				}
				else
				{
					level.rts.player playLocalSound( alias );
				}
			}
			return true;
			
		case EVENT_TYPE_MUSIC:
			alias = event.data.param1;
			assert(isDefined(alias),"Unexpected data passed to event_trigger");
			setmusicstate(alias);
			return true;
		case EVENT_TYPE_FX:
			alias = event.data.param1;
			assert(isDefined(alias),"Unexpected data passed to event_trigger");
			tag = event.data.param3;
			if (isDefined(tag))
			{
				if (isDefined(event.dparam))
				{
					entity = event.dparam;
				}
				else
				if(isDefined(event.data.param2))
				{
					entity = GetEnt(event.data.param2,"targetname");
				}
				assert(isDefined(entity),"Unexpected data passed to event_trigger");
				PlayFXOnTag( level._effect[ alias ], entity, tag );
			}
			else
			{
				if (isDefined(event.dparam))
				{
					position = event.dparam;
				}
				else
				{
					if ( isDefined(event.data.param2) )
					{
						if ( event.data.param2 == "player" )
							position = level.rts.player.origin;
						else			
						{
							entity 	 = GetEnt(event.data.param2,"targetname");
							assert(isDefined(entity),"entity not found");
							position = entity.origin;
						}
					}
				}
				assert(isDefined(position),"Unexpected data passed to event_trigger");
				PlayFX( level._effect[ alias], position );
			}
			return true;
		case EVENT_TYPE_CALLBACK:
			assert(isDefined(event.data.param1),"Unexpected data passed to event_trigger");
			return [[event.data.param1]](event.dparam, event.data.param2, event.data.param3);
			
	};
	assert(0,"Unhandled event type");
	return true;
}
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////	
allocVOXID()//self is entity
{
	if ( !isDefined(level.rts.voxIDs[self.team]) )
	{
		return;
	}

	for (i=MIX_VOX_ID;i<=MAX_VOX_ID;i++)
	{
		voxID = "so"+i;
		if ( !isDefined(level.rts.voxIDs["allies"][voxID]) )
		{
			level.rts.voxIDs["allies"][voxID]	= self;
			self.voxID = voxID;
			self thread voxDeallocateWatch();
			return;
		}
	}
}
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////	
voxDeallocateWatch()//self is entity
{
	team 	= self.team;
	voxID 	= self.voxID;
	self waittill("death");
	level.rts.voxIDs[team][voxID] = undefined;
}
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////	
getValidVoxList(team)
{
	guys = [];
	for (i=MIX_VOX_ID;i<=MAX_VOX_ID;i++)
	{
		voxID = "so"+i;
		if ( isDefined(level.rts.voxIDs["allies"][voxID]) )
		{
			guys[guys.size] = level.rts.voxIDs["allies"][voxID];
		}
	}
	return guys;
}
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////	
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////	




