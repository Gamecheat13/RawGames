#include maps\_utility;
#include maps\hamburg_code;

main()
{
	describe_start( "hamburg_end_ramp",		maps\hamburg_end_ramp::setup_ramp,		"parking ramp on foot",			maps\hamburg_end_ramp::begin_ramp );
	describe_start( "hamburg_end_street",	maps\hamburg_end_streets::setup_streets,"street combat, on foot",	maps\hamburg_end_streets::begin_streets );
	describe_start( "hamburg_end_streetcorner",	maps\hamburg_end_streets::setup_streetcorner,	"street corner, javelin incoming",	maps\hamburg_end_streets::begin_streetcorner );
	describe_start( "hamburg_end_nest",		maps\hamburg_end_nest::setup_nest,		"crow's nest defend",			maps\hamburg_end_nest::begin_nest );
	describe_start( "hamburg_end_ambush",		maps\hamburg_end_nest::setup_ambush,"HVI Amush Location",			maps\hamburg_end_nest::begin_ambush );
	describe_start( "hamburg_end",			maps\hamburg_end_nest::setup_end,		"end defend",			    maps\hamburg_end_nest::begin_end );
	
}
