#include common_scripts\utility;
#include maps\_utility;
#include maps\_so_rts_support;
#insert raw\maps\_utility.gsh;
#insert raw\maps\_so_rts.gsh;


friendly_player()
{
	level endon( "rts_terminated" );
		
	flag_wait( "start_rts" );
	
	wait( 1 );

	level thread friendly_squad_spawner();
	
	
	while(1)
	{
		//what pkgs are available....
		packages_avail = maps\_so_rts_catalog::package_generateAvailable( "allies" );
		
		//what pkgs need to be reordered
		for(i=0;i<packages_avail.size;i++)
		{
			ref 	= packages_avail[i].ref;
			total 	= get_number_in_queue(ref);
			squad	= maps\_so_rts_squad::getSquadByPkg( ref, "allies" );
			if(isDefined(squad))
				total+= squad.members.size;
			
			total += (maps\_so_rts_catalog::getNumberOfPkgsBeingTransported("allies",ref) * packages_avail[i].numUnits);
	
			if(isDefined(level.rts.player.ally) && level.rts.player.ally.pkg_ref.ref == ref)
				total += 1;

			if ( total >= packages_avail[i].max_friendly )
				continue;
				
			if ( total <= packages_avail[i].min_friendly )//reorder
			{
				level.rts.friendly_squad_queue[level.rts.friendly_squad_queue.size] = ref;
				/#
				println("@@@@@@@@ ALLIES ("+GetTIme()+") ORDERING:"+ref+" CURRENT:" + total + " MAX:" + packages_avail[i].max_friendly  +" MIN:" + packages_avail[i].min_friendly);
				#/
			}
		}
		wait 1;
	}	
}

friendly_squad_spawner()
{
	level endon( "rts_terminated" );
	
	level.rts.friendly_squad_queue = [];
	
	while( 1 )
	{
		time = 2;
		for( i=0; i < level.rts.friendly_squad_queue.size; i++ )
		{
			squadRef 	= level.rts.friendly_squad_queue[i];			
			squadID 	= maps\_so_rts_catalog::spawn_package( squadRef, "allies", false, ::order_new_squad );
			
			if( isDefined(squadID) )
			{
				level notify("friendly_unit_spawned_"+squadRef);
				// remove from array
				ArrayRemoveIndex( level.rts.friendly_squad_queue, i );
				time = 0.1;
				break;
			}
		}
				
		wait(time);
	}
}

order_new_squad( squadID )
{
}

get_number_in_queue(ref)
{
	pkg_ref = package_GetPackageByType(ref);
	if (!isDefined(pkg_ref))
		return 0;
		
	count = 0;
	for (i=0;i<level.rts.friendly_squad_queue.size;i++)
	{
		if (level.rts.friendly_squad_queue[i] == ref )
		{
			count+= pkg_ref.numUnits;
		}
	}
	return count;
}

