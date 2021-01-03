    	   	                                                                                                                         	                                                                                                                                                                                                                                                                                                                                                                    	        	     	             	    	   	                           	                               	                                	                                                              	                                                                                                              	                            	                                     	                                       	                                                               	   	                  	       	                                                    	                   	                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                        	                                                                                        	           	                        	                                            	                                             	                                                   	                                                             	                                                         	                                                                    	                                                                                                                                                                                                    	                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                      	                                                              	                                                          	                                   	                                   	                                                    	                                       

class VehicleSurfaceFxList
{
	var fx_list;
	
	constructor()
	{
		fx_list = [];
	}
	
	destructor()
	{		
	}
	
	function load_surface_fx( fx_surface_names, fx_names )
	{
		for ( i = 0; i < fx_surface_names.size; i++ )
		{
			if( isdefined( fx_names[ fx_surface_names[i] ] ) && fx_names[ fx_surface_names[i] ] != "" )
			{
				fx_list[ fx_surface_names[i] ] = fx_names[ fx_surface_names[i] ];
			}
		}		
	}

	function get_surface_fx( fx_surface_name )
	{
		return ( isdefined( fx_list[ fx_surface_name ] ) ? fx_list[ fx_surface_name ] : "" );
	}
}

function loadtreadfx( vehicle )
{
	// list of surface types
	fx_surface_names = array("asphalt","bark","brick","carpet","ceramic","cloth","concrete","cushion","none","dirt","flesh","foliage","fruit","glass","grass","gravel","ice","metal","mud","paintedmetal","plaster","rock","rubber","sand","snow","water","wood");
	
	surfacefxdeftype = vehicle.surfacefxdeftype;

	if ( surfacefxdeftype == "nitrous" )
	{
		vehicle.treadfx = new VehicleSurfaceFxList();
		[[vehicle.treadfx]]->load_surface_fx( fx_surface_names, vehicle.treadfxnamearray );
		
		vehicle.peelfx = new VehicleSurfaceFxList();
		[[vehicle.peelfx]]->load_surface_fx( fx_surface_names, vehicle.peelfxnamearray );		
		
		vehicle.skidfx = new VehicleSurfaceFxList();
		[[vehicle.skidfx]]->load_surface_fx( fx_surface_names, vehicle.skidfxnamearray );
	}
	
	if( isdefined( level._custom_treadfx_CB_Func ) )
	{
		self thread [[level._custom_treadfx_CB_Func]]();
	}
}