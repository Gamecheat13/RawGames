

#namespace killcam;


function get_killcam_entity_start_time(killcamentity)
{
	killcamentitystarttime = 0;

	if ( isdefined( killcamentity ) )
	{
		if ( isdefined( killcamentity.startTime ) )
		{
			killcamentitystarttime = killcamentity.startTime;
		}
		else
		{
			killcamentitystarttime = killcamentity.birthtime;
		}
		if ( !isdefined( killcamentitystarttime ) )
			killcamentitystarttime = 0;
	}

	return killcamentitystarttime;
}

function store_killcam_entity_on_entity( killcam_entity )
{
	assert( isdefined( killcam_entity ) );

	// store the entity and the start time it existed because it may not exist at the time we use it
	self.killcamentitystarttime = get_killcam_entity_start_time( killcam_entity );
	self.killcamentityindex = killcam_entity getEntityNumber(); 
}