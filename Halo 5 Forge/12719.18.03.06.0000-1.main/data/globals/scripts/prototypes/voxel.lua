-- object voxel

hstructure voxel
	meta : table
	instance : luserdata
end

--## SERVER

global voxels = {
	size = "small",
	floor = -40,
	sys_sizes = {
		small = {
			model = 'environments\temp\thfrench\voxel_crate\voxel_crate_solid.crate',
			grid = 0.1000000000000000000000000,
			group_size = 9,
		},
		large = {
			model = 'environments\temp\thfrench\voxel_large\voxel_large_solid.crate',
			grid = 0.2000000000000000000000000,
			group_size = 9,
		}
	},
	max = 300,
	sys_mode = {
		val = "add",
		types = {
			"add",
			"remove",
			"replace",
		}
	},
	spread = {
		x = true,
		y = true,
		z = true,
	},
	multi_place = {
		v = vector( 0, 0, 0 ),
		solid = true,
	},
	list = {
	},
	matrix_list = {
	},
	--placing = nil,
	physical = false,
	delay = nil,
	sys_timer = nil,
	variant = "default",
	sys_place_thread = nil,
	places = {
	},
	sys_placing_index = 0,
	sys_types = {
		"default",

		"blue",
		"camo",
		"gray",
		"green",
		"olive",
		"red",
		"white",
		"yellow",
		"yellow_clear",

		"shield",

		"grass",
		"veg",

		"asteroid",
		"desert",
		"moss",
		"sand",

		"mega",
	}
};

function voxels.mode( val:string )
	
	if ( (val ~= voxels.sys_mode.val) and (val ~= nil) ) then
		voxels.sys_mode.val = val;
		print( "voxel mode: " .. val );
	end
	return voxels.sys_mode.val;

end
function voxels.mode_add()
	voxels.mode( "add" );
end
function voxels.mode_remove()
	voxels.mode( "remove" );
end
function voxels.mode_replace()
	voxels.mode( "replace" );
end

function voxels.insert( o, vec, size, variant )

	table.insert( voxels.list, voxels.matrix_set(vec, { obj = o, time = game_tick_get(), v = vec, size = size, variant = variant }) );

end

function voxels.remove( i:number )

	local t = voxels.list[i];

	if ( t.obj ~= nil ) then
		object_destroy( t.obj );
	end

	-- remove from matrix
	voxels.matrix_set( t.v, nil );

	-- remove from indexed list
	table.remove( voxels.list, i );

end


function voxels.undo( cnt:number )

	cnt = cnt or 1;
	while ( (#voxels.list > 0) and (cnt > 0) ) do
		voxels.remove( #voxels.list );
		cnt = cnt - 1;
	end

end

function voxels.cleanup( max:number )

	max = max or voxels.max;

	while ( (#voxels.list > 0) and ((#voxels.list > max) or (voxels.list[1].obj == nil)) ) do

		voxels.remove( 1 );

	end

end

function voxels.clear()
	voxels.cleanup( 0 );
end

function voxels.next()
	voxels.inc( 1 );
end
function voxels.prev()
	voxels.inc( -1 );
end

function voxels.small()
	voxels.size = "small";
	print( "voxels.small" );
end
function voxels.large()
	voxels.size = "large";
	print( "voxels.large" );
end

function voxels.inc( val:number )

	voxels.set_index( (voxels.type_index(voxels.variant) or 1) + (val or 0) );

end

function voxels.matrix_get( v ):table
	v = tostring( v.x ) .. "|" .. tostring( v.y ) .. "|" .. tostring( v.z );
	return voxels.matrix_list[ v ];
end

function voxels.matrix_set( v, data:table ):table
	v = tostring( v.x ) .. "|" .. tostring( v.y ) .. "|" .. tostring( v.z );
	voxels.matrix_list[ v ] = data;
	return data;
end

function voxels.set_index( val:number )

	val = val or 1;

	while (val < 1) do
		val = #voxels.sys_types + val;
	end
	while (val > #voxels.sys_types) do
		val = val - #voxels.sys_types;
	end

	voxels.variant = voxels.sys_types[ val ];
	print( "VOXEL TYPE: " .. voxels.variant .. "[" .. tostring(val) .. "]" );

end

function voxels.type_index( val:string ):number
	
	for i, type in ipairs( voxels.sys_types ) do 
		if ( val == type ) then
			return i;
		end
	end
	return nil;

end

function voxels.place( v:vector, size, variant )

	size = size or voxels.size;
	variant = variant or voxels.variant;

	voxels.sys_placing_index = voxels.sys_placing_index + 1,

	-- insert into the place location table
	table.insert( voxels.places, { v = vector(v.x,v.y,v.z), size = size, variant = variant, index = voxels.sys_placing_index } );

	if ( (voxels.sys_place_thread == nil) or (not IsThreadValid(voxels.sys_place_thread)) ) then
		voxels.sys_place_thread = CreateThread( voxels.sys_place );		
	end
	
end

function voxels.sys_place()

	local i = 0;
	local timer = 0;

	while ( #voxels.places > 0 ) do

		i = voxels.places[1].index;
		timer = game_tick_get() + 30;

		_G.drop_variant( voxels.sys_sizes[voxels.places[1].size].model, voxels.places[1].variant );

		SleepUntil( [| (#voxels.places <= 0) or (voxels.places[1].index ~= i) or timer_expired(timer) ], 1 );

	end

end

function voxels.vector_to_grid_matrix( v:vector, size ):vector

	function get_matrix_val( val:number, size ):number
		return math.floor( (val / voxels.sys_sizes[size].grid) );
	end

	size = size or voxels.size;
	return vector( get_matrix_val(v.x,size), get_matrix_val(v.y,size), get_matrix_val(v.z,size) );

end

function voxels.grid_matrix_to_vector( v:vector, size ):vector

	size = size or voxels.size;
	return vector( v.x * voxels.sys_sizes[size].grid, v.y * voxels.sys_sizes[size].grid, v.z * voxels.sys_sizes[size].grid );

end

function voxels.vector_matrix_to_vector( v:vector, size )
	return voxels.grid_matrix_to_vector( voxels.vector_to_grid_matrix(v, size), size );
end

function voxels.list_scrub()

	for i, data in ipairs( voxels.list ) do
		if ( (data.obj == nil) or (object_get_health(data.obj) <= 0) ) then
			voxels.remove( i );
		end
	end

end

function voxels.invulnerable( val:boolean )
	if ( val == nil ) then
		val = false;
	end

	for i, data in ipairs( voxels.list ) do
		if ( (data.obj == nil) or (object_get_health(data.obj) <= 0) ) then
			voxels.remove( i );
		elseif ( val ) then
			object_cannot_take_damage( data.obj );
		else
			object_can_take_damage( data.obj );
		end
	end

end

function voxels.damage( damage:number )

	for i, data in ipairs( voxels.list ) do
		if ( (data.obj == nil) or (object_get_health(data.obj) <= 0) ) then
			voxels.remove( i );
		else
			damage_object( data.obj, "default", damage );
		end
	end

end

