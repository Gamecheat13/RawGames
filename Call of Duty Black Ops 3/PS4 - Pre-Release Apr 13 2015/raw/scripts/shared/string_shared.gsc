#using scripts\shared\array_shared;
#using scripts\shared\flag_shared;

    	   	                                                                                                                         	                                                                                                                                                                                                                                                                                                                                                                    	        	     	             	    	   	                           	                               	                                	                                                              	                                                                                                              	                            	                                     	                                       	                                                               	   	                  	       	                                                    	                   	                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                        	                                                                                        	           	                        	                                            	                                             	                                                   	                                                             	                                                         	                                                                    	                                                                                                                                                                                                    	                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                      	                                                              	                                                          	                                   	                                   	                                                    	                                       

#namespace system;

/*///////////////////////////////////////////////////////////////////////////////////////////////////////////

Usage:

REGISTER_SYSTEM( <system_name>, <preload_function>, <postload_function>, <pre-reqs> )
	
	system_name:		Name of the system.  To avoid confusion, this typically should match the namespace
						that the system is in.
	
	preload_function:	This function will automatically run during the pre initializion of a level load - this 
						will be during the first frame, during the level load phase (before _load::main)
						for all code executes during the first frame is:  autoexecs, level load, gametype, finalization
	
	postload_function:	This function will automatically run during the post initializion of a level load - this 
						will be during the first frame, during the finalization phase
						for all code executes during the first frame is:  autoexecs, level load, gametype, finalization

	pre-reqs:			Specifies a system or an array of systems that this system requires.  This system will
						wait until the precahce and main functions return from the required systems before
						running this system's main function.  Typically, this can be 'undefined'
	
Example:

	namespace coolsystem;
	
	REGISTER_SYSTEM( "coolsystem", &__init__, undefined )
		
	function __init__()
	{
		// Runs durring first frame, before any waits.  
	}
	
	

///////////////////////////////////////////////////////////////////////////////////////////////////////////*/

function register( str_system, func_preinit, func_postinit, reqs = [] )
{
	if ( IsDefined( level.system_funcs) && IsDefined( level.system_funcs[str_system] ) )
	{
		return;
	}
	
	//append to the func_init array, we'll sort based on reqs before we run everything
	if(!isdefined(level.system_funcs))level.system_funcs=[];
	
	level.system_funcs[str_system] = SpawnStruct();
	level.system_funcs[str_system].prefunc = func_preinit;
	level.system_funcs[str_system].postfunc = func_postinit;
	level.system_funcs[str_system].reqs = reqs;
	level.system_funcs[str_system].predone = !IsDefined(func_preinit);
	level.system_funcs[str_system].postdone = !IsDefined(func_postinit);
	level.system_funcs[str_system].ignore = false;
}

function exec_post_system(req)
{
	/#
	if (!IsDefined(level.system_funcs[req]))
	{
		AssertMsg( "system '" + req + "' is not defined." );
	}
	#/
	if (level.system_funcs[req].ignore)
	{
		return ;
	}
	if (!level.system_funcs[req].postdone)
	{
		[[level.system_funcs[req].postfunc]]();
		level.system_funcs[req].postdone=true;
	}
}

function run_post_systems()
{
	//sort the func_init list based on reqs
	foreach(key,func in level.system_funcs)
	{
		assert(func.predone || func.ignore,"failed to complete pre-initialization before post-initializtion call.  Avoid waits in pre-initialization");
		if (IsArray(func.reqs))
		{
			foreach(req in func.reqs)
			{
				thread exec_post_system(req);
			}
		}
		else
		{
			thread exec_post_system(func.reqs);
		}

		thread exec_post_system(key);
	}
	if (!level flag::exists("system_init_complete"))
	{
		level flag::init("system_init_complete",false);
	}
	level flag::set("system_init_complete");
}

function exec_pre_system(req)
{
	/#
	if (!IsDefined(level.system_funcs[req]))
	{
		AssertMsg( "system '" + req + "' is not defined." );
	}
	#/
	if (level.system_funcs[req].ignore)
	{
		return ;
	}
	if (!level.system_funcs[req].predone)
	{
		[[level.system_funcs[req].prefunc]]();
		level.system_funcs[req].predone=true;
	}
}

function run_pre_systems()
{
	//sort the func_init list based on reqs
	foreach(key,func in level.system_funcs)
	{
		if (IsArray(func.reqs))
		{
			foreach(req in func.reqs)
			{
				thread exec_pre_system(req);
			}
		}
		else
		{
			thread exec_pre_system(func.reqs);
		}

		thread exec_pre_system(key);
	}
}

function wait_till( required_systems )
{
	if (!level flag::exists("system_init_complete"))
	{
		level flag::init("system_init_complete",false);
	}
	level flag::wait_till("system_init_complete");
}

/@
"Name: ignore( str_system )"
"Summary: Call in the gametype main function to turn off systems even if they are included in _load or anywhere else."
"MandatoryArg: <str_system> name of the system to turn off (defined in REGISTER_SYSTEM call)."
"Example: level system::ignore( "scene" );"
@/
function ignore( str_system )
{
	Assert( !isdefined( level.gametype ), "Ignored systems must be set before level.gametype is set." );

	if ( !isdefined( level.system_funcs) || !isdefined( level.system_funcs[str_system] ) )
	{
		register(str_system,undefined,undefined,undefined); //make sure it exists so it'll get ignored if it tries to add itself after this
	}
		
	level.system_funcs[str_system].ignore = true;
}

function is_system_running( str_system )
{
	if ( !isdefined( level.system_funcs) || !isdefined( level.system_funcs[str_system] ) )
		return false;
	
	return level.system_funcs[str_system].postdone;
}