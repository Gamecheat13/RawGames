/*
_geometry.gsc
Copyright (c) 2008 Certain Affinity, Inc. All rights reserved.
Friday April 18, 2008 10:55am Stefan S.

CoD5 coordinate system:
+X= right                  | +y
+Y= forward                |
+Z= up                     |______ +x
                          /
                      +z /

geometric & math primitives:
----------------------------
point3d= (x,y,z)
vector3d= (i,j,k)
matrix4x4= n[16]

Cylinder: default orientation is radial base in X-Y plane, stands in +Z direction
Cone: default orientation is radial base in X-Y plane, stands in +Z direction
Pill: default orientation is radius in X-Y plane, pill grows in +Z direction; same as cylinder, but with the addition of rounded end caps
Box: default orientation is axis-aligned

point-in-geometry collision test result returned as a vector:
---------------------------------------------------------------
v[0] >0 if the tested point is inside the primitive
v[1] == distance^2 from sphere center, box centroid, cylinder/pill/cone base
v[2] == distance^2 from cylinder/pill/cone axis

For point-in-geometry tests, there are 2 functions for each geometric primitive: one for single-point tests and one for testing a list of points.
They are each optimized for their specific case so use the appropriate one.
*/

/* ---------- includes */

#include common_scripts\utility;
#include maps\mp\_utility;

/* ---------- point3d */

//float
point3d_distance_squared(
	p0,
	p1)
{
/*	result= (p1[0]-p0[0])*(p1[0]-p0[0]) + (p1[1]-p0[1])*(p1[1]-p0[1]) + ((p1[2]-p0[2])*p1[2]-p0[2]);

	return result;*/
	// use native code
	return DistanceSquared(p0, p1);
}

//float
point3d_distance(
	p0,
	p1)
{
	//result= sqrt(point3d_distance_squared(p0, p1));
	// use native code
	result= Distance(p0, p1);

	return result;
}

//point3d
point3d_translate(
	point,
	translation)
{
	result= point+translation;

	return result;
}

/* ---------- vector3d */

//float
vector3d_magnitude_squared(
	vector)
{
	/*magnitude_squared= vector[0]*vector[0]+vector[1]*vector[1]+vector[2]*vector[2];
	
	return magnitude_squared;*/
	// use native code
	return LengthSquared(vector);
}

//float
vector3d_magnitude(
	vector)
{
	/*magnitude_squared= vector3d_magnitude_squared(vector);
	magnitude= sqrt(magnitude_squared);
	
	return magnitude;*/
	// use native code
	return Length(vector);
}

//vector3d
vector3d_normalize(
	vector)
{
/*	magnitude_squared= vector3d_magnitude_squared(vector);
	result= vector;
	
	if (magnitude_squared>0.0001)
	{
		if ((magnitude_squared-1) > 0.0001)
		{
			one_over_magnitude= 1/sqrt(magnitude_squared);
			result= vector*one_over_magnitude;
		}
		//else, already normalized
	}*/
	// use native code
	result= VectorNormalize(vector);
	
	return result;
}

//vector3d
vector3d_scale(
	vector,
	scale)
{
	result= scale*vector;
	
	return result;
}

// vector3d
vector3d_from_points(
	source,
	dest)
{
	result= dest-source;
	
	return result;
}

//float
vector3d_dot_product(
	vector_a,
	vector_b)
{
	//return vector_a[0]*vector_b[0] + vector_a[1]*vector_b[1] + vector_a[2]*vector_b[2];
	// use native code
	return VectorDot(vector_a, vector_b);
}

//vector3d
vector3d_cross_product(
	vector_a,
	vector_b)
{
	i= (vector_a[1]*vector_b[2]) - (vector_a[2]*vector_b[1]);
	j= -1*((vector_a[0]*vector_b[2]) - (vector_a[2]*vector_b[0]));
	k= (vector_a[0]*vector_b[1]) - (vector_a[1]*vector_b[0]);
	
	result= (i, j, k);
	
	return result;
}

//float
vector3d_angle_between(
	vector_a,
	vector_b)
{
	ab= vector3d_magnitude(vector_a)*vector3d_magnitude(vector_b);
	assertex((ab>0.001), "zero-vector");
	result= Acos(vector3d_dot_product(vector_a, vector_b)/ab);
	
	return result;
}

//float
vector3d_component_of_a_along_b(
	vector_a,
	vector_b)
{
	b= vector3d_magnitude(vector_b);
	assertex((b > 0.001), "zero-vector");
	b_over_magnitude_b= vector3d_scale(vector_b, 1/b);
	result= vector3d_dot_product(vector_a, b_over_magnitude_b);

	return result;
}

// bool
vector3d_is_zero(
	vector)
{
	return (vector3d_magnitude_squared(vector) < 0.00001);
}

//bool
vector3d_is_normalized(
	vector)
{
	return (vector3d_magnitude_squared(vector)-1 < 0.001);
}

//bool
vector3d_orthogonal(
	vector_a,
	vector_b)
{
	dot_product= vector3d_dot_product(vector_a, vector_b);
	
	return dot_product < 0.001;
}

//bool
vector3d_parallel(
	vector_a,
	vector_b)
{
	cross_product= vector3d_cross_product(vector_a, vector_b);
	
	return vector3d_is_zero(cross_product);
}

/* ---------- matrix4x4 */

//matrix4x4
matrix4x4_build_identity()
{
	matrix= [];
	matrix[00]= 1; matrix[01]= 0; matrix[02]= 0; matrix[03]= 0;
	matrix[04]= 0; matrix[05]= 1; matrix[06]= 0; matrix[07]= 0;
	matrix[08]= 0; matrix[09]= 0; matrix[10]= 1; matrix[11]= 0;
	matrix[12]= 0; matrix[13]= 0; matrix[14]= 0; matrix[15]= 1;
	
	return matrix;
}

//matrix4x4
matrix4x4_build_translation(
	translation_x,
	translation_y,
	translation_z)
{
	matrix= matrix4x4_build_identity();
	matrix[03]= translation_x;
	matrix[07]= translation_y;
	matrix[11]= translation_z;
	
	return matrix;
}

//matrix4x4
matrix4x4_build_scale(
	scale_x,
	scale_y,
	scale_z)
{
	matrix= matrix4x4_build_identity();
	matrix[00]= scale_x;
	matrix[05]= scale_y;
	matrix[10]= scale_z;
	
	return matrix;
}

/* ###stefan $REVIEW this code should be fine but I have not tested it yet, so it's commented out
//matrix4x4
matrix4x4_build_rotation_from_axis_and_angle(
	axis,
	angle)
{
	unit_axis= vector3d_normalize(axis);
	c= Cos(angle);
	s= Sin(angle);
	one_minus_c= 1-c;
	result= [];
	
	result[00]= unit_axis[0]*unit_axis[0]*one_minus_c+c;
	result[01]= unit_axis[0]*unit_axis[1]*one_minus_c+unit_axis[2]*s;
	result[02]= unit_axis[0]*unit_axis[2]*one_minus_c-unit_axis[1]*s;
	result[03]= 0;

	result[04]= unit_axis[0]*unit_axis[1]*one_minus_c-unit_axis[2]*s;
	result[05]= unit_axis[1]*unit_axis[1]*one_minus_c+c;
	result[06]= unit_axis[1]*unit_axis[2]*one_minus_c+unit_axis[0]*s;
	result[07]= 0;

	result[08]= unit_axis[0]*unit_axis[2]*one_minus_c+unit_axis[1]*s;
	result[09]= unit_axis[1]*unit_axis[1]*one_minus_c-unit_axis[0]*s;
	result[10]= unit_axis[2]*unit_axis[2]*one_minus_c+c;
	result[11]= 0;

	result[12]= 0; result[13]= 0; result[14]= 0; result[15]= 1;

	return result;
}*/

//matrix4x4
matrix4x4_build_rotation_from_forward_and_up(
	forward,
	up)
{
	left= vector3d_cross_product(up, forward);
	
	return matrix4x4_build_rotation_from_axes(forward, up, left);
}

//matrix4x4
matrix4x4_build_rotation_from_axes(
	forward,
	up,
	left)
{
	result= [];
	result[00]= forward[0]; result[01]= forward[1]; result[02]= forward[2]; result[03]= 0;
	result[04]= left[0]; result[05]= left[1]; result[06]= left[2]; result[07]= 0;
	result[08]= up[0]; result[09]= up[1]; result[10]= up[2]; result[11]= 0;
	result[12]= 0; result[13]= 0; result[14]= 0; result[15]= 1;
	
	return result;
}

//matrix4x4
matrix4x4_build_from_rotation_and_translation(
	forward,
	up,
	left,
	translation)
{
	result= [];
	result[00]= forward[0]; result[01]= forward[1]; result[02]= forward[2]; result[03]= translation[0];
	result[04]= left[0]; result[05]= left[1]; result[06]= left[2]; result[07]= translation[1];
	result[08]= up[0]; result[09]= up[1]; result[10]= up[2]; result[11]= translation[2];
	result[12]= 0; result[13]= 0; result[14]= 0; result[15]= 1;
	
	return result;
}

//matrix4x4
matrix4x4_multiply(
	matrix_a,
	matrix_b)
{
	result= [];
	result[00]= matrix_a[00]*matrix_b[00] + matrix_a[01]*matrix_b[04] + matrix_a[02]*matrix_b[08] + matrix_a[03]*matrix_b[12];
	result[01]= matrix_a[00]*matrix_b[01] + matrix_a[01]*matrix_b[05] + matrix_a[02]*matrix_b[09] + matrix_a[03]*matrix_b[13];
	result[02]= matrix_a[00]*matrix_b[02] + matrix_a[01]*matrix_b[06] + matrix_a[02]*matrix_b[10] + matrix_a[03]*matrix_b[14];
	result[03]= matrix_a[00]*matrix_b[03] + matrix_a[01]*matrix_b[07] + matrix_a[02]*matrix_b[11] + matrix_a[03]*matrix_b[15];
	result[04]= matrix_a[04]*matrix_b[00] + matrix_a[05]*matrix_b[04] + matrix_a[06]*matrix_b[08] + matrix_a[07]*matrix_b[12];
	result[05]= matrix_a[04]*matrix_b[01] + matrix_a[05]*matrix_b[05] + matrix_a[06]*matrix_b[09] + matrix_a[07]*matrix_b[13];
	result[06]= matrix_a[04]*matrix_b[02] + matrix_a[05]*matrix_b[06] + matrix_a[06]*matrix_b[10] + matrix_a[07]*matrix_b[14];
	result[07]= matrix_a[04]*matrix_b[03] + matrix_a[05]*matrix_b[07] + matrix_a[06]*matrix_b[11] + matrix_a[07]*matrix_b[15];
	result[08]= matrix_a[08]*matrix_b[00] + matrix_a[09]*matrix_b[04] + matrix_a[10]*matrix_b[08] + matrix_a[11]*matrix_b[12];
	result[09]= matrix_a[08]*matrix_b[01] + matrix_a[09]*matrix_b[05] + matrix_a[10]*matrix_b[09] + matrix_a[11]*matrix_b[13];
	result[10]= matrix_a[08]*matrix_b[02] + matrix_a[09]*matrix_b[06] + matrix_a[10]*matrix_b[10] + matrix_a[11]*matrix_b[14];
	result[11]= matrix_a[08]*matrix_b[03] + matrix_a[09]*matrix_b[07] + matrix_a[10]*matrix_b[11] + matrix_a[11]*matrix_b[15];
	result[12]= matrix_a[12]*matrix_b[00] + matrix_a[13]*matrix_b[04] + matrix_a[14]*matrix_b[08] + matrix_a[15]*matrix_b[12];
	result[13]= matrix_a[12]*matrix_b[01] + matrix_a[13]*matrix_b[05] + matrix_a[14]*matrix_b[09] + matrix_a[15]*matrix_b[13];
	result[14]= matrix_a[12]*matrix_b[02] + matrix_a[13]*matrix_b[06] + matrix_a[14]*matrix_b[10] + matrix_a[15]*matrix_b[14];
	result[15]= matrix_a[12]*matrix_b[03] + matrix_a[13]*matrix_b[07] + matrix_a[14]*matrix_b[11] + matrix_a[15]*matrix_b[15];
	
	return result;
}

//vector3d
matrix4x4_transform_vector3d(
	vector,
	matrix)
{
	x= vector[0]*matrix[00] + vector[1]*matrix[04] + vector[2]*matrix[08];
	y= vector[0]*matrix[01] + vector[1]*matrix[05] + vector[2]*matrix[09];
	z= vector[0]*matrix[02] + vector[1]*matrix[06] + vector[2]*matrix[10];
	result= (x, y, z);
	
	return result;
}

//point3d
matrix4x4_transform_point3d(
	point,
	matrix)
{
	//###stefan $REVIEW could use native game script fxn Matrix4x4TransformPoints()
	x= point[0]*matrix[00] + point[1]*matrix[04] + point[2]*matrix[08] + matrix[03];
	y= point[0]*matrix[01] + point[1]*matrix[05] + point[2]*matrix[09] + matrix[07];
	z= point[0]*matrix[02] + point[1]*matrix[06] + point[2]*matrix[10] + matrix[11];
	result= (x, y, z);
	
	return result;
}

//transformation of a points list
matrix4x4_transform_points3d(
	points,
	matrix)
{
/*###stefan $NOTE there is now a native code implementation (~ 30% faster debug rendering for player spawn state viewing
	transformed_points= [];
	
	for (point_index= 0; point_index<points.size; point_index++)
	{
		transformed_points[point_index]= matrix4x4_transform_point3d(points[point_index], matrix);
	}
	
	return transformed_points;*/
	return Matrix4x4TransformPoints(matrix, points);
}

/* ---------- point-in-geometry tests */

//collision
collision_test_point_in_sphere(
	point,
	sphere_origin,
	sphere_radius)
{
	//prof_begin("collision_test_point_in_sphere");
	
	assertex((sphere_radius>0.001), "invalid sphere radius");
	
	collision= (0.0, 0.0, 0.0);
	
	dsquared= point3d_distance_squared(point, sphere_origin);
	rsquared= sphere_radius*sphere_radius;
	if (dsquared<rsquared)
	{
		collision= (1.0, dsquared, 0.0);
	}
	
	//prof_end("collision_test_point_in_sphere");
	
	return collision;
}

//collision
collision_test_points_in_sphere(
	point_list_s,
	sphere_origin,
	sphere_radius)
{
	//prof_begin("collision_test_points_in_sphere");
	
	assertex((sphere_radius>0.001), "invalid sphere radius");
	
	/*###stefan $NOTE we now call into native code
	collision_results_s= spawn_array_struct();
	// pre-computed parameters
	rsquared= sphere_radius*sphere_radius;
	
	// test point list
	for (point_index= 0; point_index<point_list_s.a.size; point_index++)
	{
		collision= (0.0, 0.0, 0.0);
		
		dsquared= point3d_distance_squared(point_list_s.a[point_index], sphere_origin);
		if (dsquared<rsquared)
		{
			collision= (1.0, dsquared, 0.0);
		}
		
		collision_results_s.a[point_index]= collision;
	}*/
	/*###stefan $NOTE we now call into native code*/
	collision_results_s= SpawnStruct();
	collision_results_s.a= CollisionTestPointsInSphere(point_list_s.a, sphere_origin, 0.0+sphere_radius);
	/**/
	//prof_end("collision_test_points_in_sphere");
	
	return collision_results_s;
}

//collision
collision_test_point_in_cylinder(
	point,
	cylinder_base, // base point of cylinder
	cylinder_radius,
	cylinder_height,
	cylinder_height_unit_vector) // direction & height of cylinder from cylinder_base
{
	//prof_begin("collision_test_point_in_cylinder");
	
	assertex((cylinder_radius>0.001) && (cylinder_height>0.001), "invalid cylinder geometry");
	assertex(vector3d_is_normalized(cylinder_height_unit_vector), "cylinder height vector must be unit vector");
	
	collision= (0.0, 0.0, 0.0);
	
	axis_midpoint= cylinder_base+vector3d_scale(cylinder_height_unit_vector, cylinder_height*0.5);
	
	// perform a bounding sphere check first (fast)
	bounding_sphere_radius= cylinder_radius+0.5*cylinder_height;
	bounding_sphere_rsquared= bounding_sphere_radius*bounding_sphere_radius;
	if (point3d_distance_squared(point, axis_midpoint) < bounding_sphere_rsquared)
	{
		// test for point between top & bottom planes
		amp= vector3d_from_points(axis_midpoint, point);
		midpoint_axial_distance= Abs(vector3d_component_of_a_along_b(amp, cylinder_height_unit_vector));
		
		// between top & bottom if: midpoint_axial_distance < height/2
		if (midpoint_axial_distance < cylinder_height*0.5)
		{
			// test for point inside cylinder radius
			dsquared= point3d_distance_squared(point, axis_midpoint);
			rsquared= dsquared-(midpoint_axial_distance*midpoint_axial_distance);
			if (rsquared<(cylinder_radius*cylinder_radius))
			{
				collision= (1.0, point3d_distance_squared(cylinder_base, point), rsquared);
			}
		}
	}
	
	//prof_end("collision_test_point_in_cylinder");
	
	return collision;
}

//collision
collision_test_points_in_cylinder(
	point_list_s,
	cylinder_base, // base point of cylinder
	cylinder_radius,
	cylinder_height,
	cylinder_height_unit_vector) // direction & height of cylinder from cylinder_base
{
	//prof_begin("collision_test_points_in_cylinder");
	
	assertex((cylinder_radius>0.001) && (cylinder_height>0.001), "invalid cylinder geometry");
	assertex(vector3d_is_normalized(cylinder_height_unit_vector), "cylinder height vector must be unit vector");
	/*###stefan $NOTE we now call into native code
	collision_results_s= spawn_array_struct();
	
	// pre-computed parameters
	axis_midpoint= cylinder_base+vector3d_scale(cylinder_height_unit_vector, cylinder_height*0.5);
	bounding_sphere_radius= cylinder_radius+0.5*cylinder_height;
	bounding_sphere_radius_squared= bounding_sphere_radius*bounding_sphere_radius;
	cylinder_radius_squared= cylinder_radius*cylinder_radius;
	half_cylinder_height= cylinder_height*0.5;
	
	// test point list
	for (point_index= 0; point_index<point_list_s.a.size; point_index++)
	{
		collision= (0.0, 0.0, 0.0);
		
		// perform a bounding sphere check first (fast)
		if (point3d_distance_squared(point_list_s.a[point_index], axis_midpoint)<bounding_sphere_radius_squared)
		{
			// test for point between top & bottom planes
			amp= vector3d_from_points(axis_midpoint, point_list_s.a[point_index]);
			midpoint_axial_distance= Abs(vector3d_component_of_a_along_b(amp, cylinder_height_unit_vector));
			
			// between top & bottom if: midpoint_axial_distance < height/2
			if (midpoint_axial_distance < half_cylinder_height)
			{
				// test for point inside cylinder radius
				dsquared= point3d_distance_squared(point_list_s.a[point_index], axis_midpoint);
				rsquared= dsquared-(midpoint_axial_distance*midpoint_axial_distance);
				if (rsquared<cylinder_radius_squared)
				{
					collision= (1.0, point3d_distance_squared(cylinder_base, point_list_s.a[point_index]), rsquared);
				}
			}
		}
		
		collision_results_s.a[point_index]= collision;
	}*/
	/*###stefan $NOTE we now call into native code*/
	collision_results_s= SpawnStruct();
	collision_results_s.a= CollisionTestPointsInCylinder(
		point_list_s.a,
		cylinder_base,
		0.0+cylinder_radius,
		0.0+cylinder_height,
		cylinder_height_unit_vector);	
	/**/
	//prof_end("collision_test_points_in_cylinder");
	
	return collision_results_s;
}

//collision
collision_test_point_in_pill(
	point,
	cylinder_base, // base point of cylinder
	cylinder_radius,
	cylinder_height,
	cylinder_height_unit_vector, // direction of cylinder from cylinder_base
	cylinder_radial_vector) // for conveniece in calculating collision results
{
	//prof_begin("collision_test_point_in_pill");
	
	collision= collision_test_point_in_sphere(point, cylinder_base, cylinder_radius);
	
	if (collision[0]<1)
	{
		collision= collision_test_point_in_sphere(point, point3d_translate(cylinder_base, vector3d_scale(cylinder_height_unit_vector, cylinder_height)), cylinder_radius);
		
		if (collision[0]<1)
		{
			collision= collision_test_point_in_cylinder(point, cylinder_base, cylinder_radius, cylinder_height, cylinder_height_unit_vector);
		}
		else
		{
			distance_from_axis= vector3d_component_of_a_along_b(vector3d_from_points(cylinder_base, point), cylinder_radial_vector);
			collision= (1.0, point3d_distance_squared(cylinder_base, point), distance_from_axis*distance_from_axis);
		}
	}
	else
	{
		distance_from_axis= vector3d_component_of_a_along_b(vector3d_from_points(cylinder_base, point), cylinder_radial_vector);
		collision= (1.0, point3d_distance_squared(cylinder_base, point), distance_from_axis*distance_from_axis);
	}
	
	//prof_end("collision_test_point_in_pill");
	
	return collision;
}

//collision
collision_test_points_in_pill(
	point_list_s,
	cylinder_base, // base point of cylinder
	cylinder_radius,
	cylinder_height,
	cylinder_height_unit_vector, // direction of cylinder from cylinder_base
	cylinder_radial_vector) // for conveniece in calculating collision results
{
	//prof_begin("collision_test_points_in_pill");
	
	collision_results_s= spawn_array_struct();
	
	// pre-computed parameters
	cylinder_top= point3d_translate(cylinder_base, vector3d_scale(cylinder_height_unit_vector, cylinder_height));
	axis_midpoint= point3d_translate(cylinder_base, vector3d_scale(cylinder_height_unit_vector, cylinder_height*0.5));
	bounding_sphere_radius= cylinder_radius+0.5*cylinder_height;
	bounding_sphere_radius_squared= bounding_sphere_radius*bounding_sphere_radius;
	cylinder_radius_squared= cylinder_radius*cylinder_radius;
	half_cylinder_height= cylinder_height*0.5;
	
	// test point list
	for (point_index= 0; point_index<point_list_s.a.size; point_index++)
	{
		collision= (0.0, 0.0, 0.0);
		
		// perform a bounding sphere check first (fast)
		if (point3d_distance_squared(point_list_s.a[point_index], axis_midpoint)<bounding_sphere_radius_squared)
		{
			// test against base sphere
			if (point3d_distance_squared(point_list_s.a[point_index], cylinder_base)<cylinder_radius_squared)
			{
				collision= (1.0, 0.0, 0.0);
			}
			// test against top sphere
			else if (point3d_distance_squared(point_list_s.a[point_index], cylinder_top)<cylinder_radius_squared)
			{
				collision= (1.0, 0.0, 0.0);
			}
			// test against cylinder
			else
			{
				// test for point between top & bottom planes
				amp= vector3d_from_points(axis_midpoint, point_list_s.a[point_index]);
				midpoint_axial_distance= Abs(vector3d_component_of_a_along_b(amp, cylinder_height_unit_vector));
				
				// between top & bottom if: midpoint_axial_distance < height/2
				if (midpoint_axial_distance < half_cylinder_height)
				{
					// test for point inside cylinder radius
					dsquared= point3d_distance_squared(point_list_s.a[point_index], axis_midpoint);
					rsquared= dsquared-(midpoint_axial_distance*midpoint_axial_distance);
					if (rsquared<cylinder_radius_squared)
					{
						collision= (1.0, 0.0, 0.0);
					}
				}
			}
		}
		
		if (collision[0]>0.0)
		{
			distance_from_axis= vector3d_component_of_a_along_b(vector3d_from_points(cylinder_base, point_list_s.a[point_index]), cylinder_radial_vector);
			collision= (1.0, point3d_distance_squared(cylinder_base, point_list_s.a[point_index]), distance_from_axis*distance_from_axis);
		}
		
		collision_results_s.a[point_index]= collision;
	}
	
	//prof_end("collision_test_points_in_pill");
	
	return collision_results_s;
}

//collision
collision_test_point_in_cone(
	point,
	cone_base, // base point of cone
	cone_base_radius,
	cone_height,
	cone_height_unit_vector, // direction & height of cone from cone_base to the tip
	cone_radial_unit_vector) // a radial vector (any unit vector orthogonal to the height vector - passed in for convenience, since scripting always has available)
{
	//prof_begin("collision_test_point_in_cone");
	
	assertex((cone_base_radius>0.001) && (cone_height>0.001), "invalid cone geometry");
	assertex(vector3d_is_normalized(cone_height_unit_vector), "cone height vector must be unit vector");
	assertex(vector3d_is_normalized(cone_radial_unit_vector), "cone radial vector must be unit vector");
	
	collision= (0.0, 0.0, 0.0);
	
	axis_midpoint= cone_base+vector3d_scale(cone_height_unit_vector, cone_height*0.5);
	
	// perform a bounding sphere check first (fast)
	bounding_sphere_radius= cone_base_radius+0.5*cone_height;
	bounding_sphere_rsquared= bounding_sphere_radius*bounding_sphere_radius;
	if (point3d_distance_squared(point, axis_midpoint) < bounding_sphere_rsquared)
	{
		// test for point between top & bottom planes
		amp= vector3d_from_points(axis_midpoint, point);
		midpoint_axial_distance= Abs(vector3d_component_of_a_along_b(amp, cone_height_unit_vector));
		
		// between top & bottom if: midpoint_axial_distance < height/2
		if (midpoint_axial_distance < cone_height*0.5)
		{
			// test for point inside cylinder radius (using comparison of angles between vectors)
			cone_tip= cone_base+vector3d_scale(cone_height_unit_vector, cone_height);
			radial_edge= cone_base+vector3d_scale(cone_radial_unit_vector, cone_base_radius);
			tp= vector3d_from_points(cone_tip, point);
			te= vector3d_from_points(cone_tip, radial_edge);
			to= vector3d_from_points(cone_tip, cone_base);
			tp_dot_to= vector3d_dot_product(tp, to);
			te_dot_to= vector3d_dot_product(te, to);
			tp_magnitude_squared= Max(0.00001, vector3d_magnitude_squared(tp));
			te_magnitude_squared= Max(0.00001, vector3d_magnitude_squared(te));
			if ((tp_dot_to*tp_dot_to/tp_magnitude_squared) > (te_dot_to*te_dot_to/te_magnitude_squared))
			{
				distance_from_origin= point3d_distance(cone_base, point);
				distance_from_axis= vector3d_component_of_a_along_b(vector3d_from_points(cone_base, point), cone_radial_unit_vector);
				collision= (1.0, distance_from_origin*distance_from_origin, distance_from_axis*distance_from_axis);
			}
		}
	}
	
	//prof_end("collision_test_point_in_cone");
	
	return collision;
}

//collision
collision_test_points_in_cone(
	point_list_s,
	cone_base, // base point of cone
	cone_base_radius,
	cone_height,
	cone_height_unit_vector, // direction & height of cone from cone_base to the tip
	cone_radial_unit_vector) // a radial vector (any unit vector orthogonal to the height vector - passed in for convenience, since scripting always has available)
{
	//prof_begin("collision_test_points_in_cone");
	
	assertex((cone_base_radius>0.001) && (cone_height>0.001), "invalid cone geometry");
	assertex(vector3d_is_normalized(cone_height_unit_vector), "cone height vector must be unit vector");
	assertex(vector3d_is_normalized(cone_radial_unit_vector), "cone radial vector must be unit vector");
	
	collision_results_s= spawn_array_struct();
	
	// pre-computed parameters
	axis_midpoint= cone_base+vector3d_scale(cone_height_unit_vector, cone_height*0.5);
	bounding_sphere_radius= cone_base_radius+0.5*cone_height;
	bounding_sphere_radius_squared= bounding_sphere_radius*bounding_sphere_radius;
	half_cone_height= 0.5*cone_height;
	cone_tip= cone_base+vector3d_scale(cone_height_unit_vector, cone_height);
	radial_edge= cone_base+vector3d_scale(cone_radial_unit_vector, cone_base_radius);
	te= vector3d_from_points(cone_tip, radial_edge);
	to= vector3d_from_points(cone_tip, cone_base);
	te_dot_to= vector3d_dot_product(te, to);
	te_magnitude_squared= Max(0.00001, vector3d_magnitude_squared(te));
	teto2_over_te= te_dot_to*te_dot_to/te_magnitude_squared;
	
	// test point list
	for (point_index= 0; point_index<point_list_s.a.size; point_index++)
	{
		collision= (0.0, 0.0, 0.0);
		
		// perform a bounding sphere check first (fast)
		if (point3d_distance_squared(point_list_s.a[point_index], axis_midpoint)<bounding_sphere_radius_squared)
		{
			// test for point between top & bottom planes
			amp= vector3d_from_points(axis_midpoint, point_list_s.a[point_index]);
			midpoint_axial_distance= Abs(vector3d_component_of_a_along_b(amp, cone_height_unit_vector));
			
			// between top & bottom if: midpoint_axial_distance < height/2
			if (midpoint_axial_distance < half_cone_height)
			{
				// test for point inside cylinder radius (using comparison of angles between vectors)
				tp= vector3d_from_points(cone_tip, point_list_s.a[point_index]);
				tp_dot_to= vector3d_dot_product(tp, to);
				tp_magnitude_squared= Max(0.00001, vector3d_magnitude_squared(tp));
				if ((tp_dot_to*tp_dot_to/tp_magnitude_squared) > teto2_over_te)
				{
					distance_from_origin= point3d_distance(cone_base, point_list_s.a[point_index]);
					distance_from_axis= vector3d_component_of_a_along_b(vector3d_from_points(cone_base, point_list_s.a[point_index]), cone_radial_unit_vector);
					collision= (1.0, distance_from_origin*distance_from_origin, distance_from_axis*distance_from_axis);
				}
			}
		}
		
		collision_results_s.a[point_index]= collision;
	}
	
	//prof_end("collision_test_points_in_cone");
	
	return collision_results_s;
}

//collision
collision_test_point_in_box(
	point,
	box_origin, // box centroid
	box_width, // x-dimension
	box_height, // y-dimension
	box_depth, // z-dimension
	forward,
	up)
{
	//prof_begin("collision_test_point_in_box");
	
	assertex((box_width>0.001) && (box_height>0.001) && (box_depth>0.001), "invalid box geometry");
	
	collision= (0.0, 0.0, 0.0);
	
	// perform a bounding sphere check first (fast)
	// use radius= sum(largest 2 dimensions)
	bounding_sphere_radius= (box_width+box_height+box_depth) - Min(Min(box_width, box_height), box_depth);
	dsquared= point3d_distance_squared(box_origin, point);
	if (dsquared<(bounding_sphere_radius*bounding_sphere_radius))
	{
		// test if point is inside faces of the box
		transform= matrix4x4_build_rotation_from_forward_and_up(forward, up);
		box_forward= matrix4x4_transform_vector3d((box_width, 0, 0), transform);
		box_left= matrix4x4_transform_vector3d((0, box_height, 0), transform);
		box_up= matrix4x4_transform_vector3d((0, 0, box_depth), transform);
		bp= vector3d_from_points(box_origin, point);
		// front & back faces
		forward_distance= Abs(vector3d_component_of_a_along_b(bp, box_forward));
		if (forward_distance < (0.5*box_width))
		{
			// left & right faces
			left_distance= Abs(vector3d_component_of_a_along_b(bp, box_left));
			if (left_distance < (0.5*box_height))
			{
				// top & bottom faces
				up_distance= Abs(vector3d_component_of_a_along_b(bp, box_up));
				if (up_distance < (0.5*box_depth))
				{
					collision= (1.0, point3d_distance_squared(box_origin, point), 0.0);
				}
			}
		}
	}
	
	//prof_end("collision_test_point_in_box");
	
	return collision;
}

//collision
collision_test_points_in_box(
	point_list_s,
	box_origin, // box centroid
	box_width, // x-dimension
	box_height, // y-dimension
	box_depth, // z-dimension
	forward,
	up)
{
	//prof_begin("collision_test_points_in_box");
	
	assertex((box_width>0.001) && (box_height>0.001) && (box_depth>0.001), "invalid box geometry");
	
	collision_results_s= spawn_array_struct();
	
	// pre-computed parameters
	bounding_sphere_radius= (box_width+box_height+box_depth) - Min(Min(box_width, box_height), box_depth); // use radius= sum(largest 2 dimensions)
	bounding_sphere_radius_squared= bounding_sphere_radius*bounding_sphere_radius;
	transform= matrix4x4_build_rotation_from_forward_and_up(forward, up);
	box_forward= matrix4x4_transform_vector3d((box_width, 0, 0), transform);
	box_left= matrix4x4_transform_vector3d((0, box_height, 0), transform);
	box_up= matrix4x4_transform_vector3d((0, 0, box_depth), transform);
	half_box_width= 0.5*box_width;
	half_box_height= 0.5*box_height;
	half_box_depth= 0.5*box_depth;
	
	// test point list
	for (point_index= 0; point_index<point_list_s.a.size; point_index++)
	{
		collision= (0.0, 0.0, 0.0);
		
		// perform a bounding sphere check first (fast)
		if (point3d_distance_squared(box_origin, point_list_s.a[point_index])<bounding_sphere_radius_squared)
		{
			// test if point is inside faces of the box
			bp= vector3d_from_points(box_origin, point_list_s.a[point_index]);
			// front & back faces
			forward_distance= Abs(vector3d_component_of_a_along_b(bp, box_forward));
			if (forward_distance < half_box_width)
			{
				// left & right faces
				left_distance= Abs(vector3d_component_of_a_along_b(bp, box_left));
				if (left_distance < half_box_height)
				{
					// top & bottom faces
					up_distance= Abs(vector3d_component_of_a_along_b(bp, box_up));
					if (up_distance < half_box_depth)
					{
						collision= (1.0, point3d_distance_squared(box_origin, point_list_s.a[point_index]), 0.0);
					}
				}
			}
		}
		
		collision_results_s.a[point_index]= collision;
	}
	
	//prof_end("collision_test_points_in_box");
	
	return collision_results_s;
}

/* ---------- geometry debug rendering */

draw_line(
	p0,
	p1,
	rgb_color)
{
	k_depth_test= false;
	k_draw_duration_server_frames= 1;
	Line(p0, p1, rgb_color, k_depth_test, k_draw_duration_server_frames);
	
	return;
}

draw_line_segments(
	points,
	rgb_color)
{
	k_depth_test= false;
	k_draw_duration_server_frames= 1;
	for (point_index= 1; point_index<points.size; point_index++)
	{
		Line(points[point_index-1], points[point_index], rgb_color, k_depth_test, k_draw_duration_server_frames);
	}
	
	return;
}

draw_line_list(
	points,
	rgb_color)
{
	k_depth_test= false;
	k_draw_duration_server_frames= 1;
	LineList(points, rgb_color, k_depth_test, k_draw_duration_server_frames);
	
	return;
}

draw_sphere(
	sphere_origin, //point3d
	sphere_radius, //float
	forward, //vector3d
	up, //vector3d
	rgb_color)
{
	points= generate_sphere_points_list(sphere_origin, sphere_radius, forward, up);
	draw_line_list(points, rgb_color);
	/*for (list_index= 0; list_index<points.size; list_index++)
	{
		draw_line_segments(points[list_index], rgb_color);
	}*/
	
	return;
}

draw_cylinder(
	cylinder_base, //point3d
	cylinder_radius, //float
	cylinder_height, //float
	forward, //vector3d
	up, //vector3d
	rgb_color)
{
	points= generate_cylinder_points_list(cylinder_base, cylinder_radius, cylinder_height, forward, up);
	draw_line_list(points, rgb_color);
	/*for (list_index= 0; list_index<points.size; list_index++)
	{
		draw_line_segments(points[list_index], rgb_color);
	}*/
	
	return;
}

draw_box(
	centroid, //point3d
	dimensions, //vector3d
	forward, //vector3d
	up, //vector3d
	rgb_color)
{
	points= generate_box_points_lists(centroid, dimensions, forward, up);
	for (list_index= 0; list_index<points.size; list_index++)
	{
		draw_line_segments(points[list_index], rgb_color);
	}
	
	return;
}

draw_pill(
	pill_base, //point3d
	pill_radius, //float
	pill_height, //float
	forward, //vector3d
	up, //vector3d
	rgb_color)
{
	points= generate_pill_points_lists(pill_base, pill_radius, pill_height, forward, up);
	for (list_index= 0; list_index<points.size; list_index++)
	{
		draw_line_segments(points[list_index], rgb_color);
	}
	
	return;
}

draw_cone(
	cone_base, //point3d
	cone_radius, //float
	cone_height, //float
	forward, //vector3d
	up, //vector3d
	rgb_color)
{
	points= generate_cone_points_lists(cone_base, cone_radius, cone_height, forward, up);
	for (list_index= 0; list_index<points.size; list_index++)
	{
		draw_line_segments(points[list_index], rgb_color);
	}
	
	return;
}

/* ---------- private code */

//int
get_debug_geometry_circular_segment_count()
{
	return 16;
}

//points[][]
generate_sphere_points_list(
	sphere_origin, //point3d
	radius, //float
	forward, //vector3d
	up) //vector3d
{
	points= [];
	
	if (radius>0.0)
	{
		k_segment_count= get_debug_geometry_circular_segment_count();
		k_rotation_delta= 360/k_segment_count;
		
		// generate 3 circles
		c0= [];
		c1= [];
		c2= [];
		
		// rotate points about origin & apply translation
		left= vector3d_cross_product(up, forward);
		transform= matrix4x4_build_from_rotation_and_translation(forward, up, left, sphere_origin);
		
		for (index= 0; index<=k_segment_count; index++)
		{
			theta= index*k_rotation_delta;
			rcos_theta= radius*Cos(theta);
			rsin_theta= radius*Sin(theta);
			
			c0[index]= (rcos_theta, rsin_theta, 0.0);
			c1[index]= (0.0, rcos_theta, rsin_theta);
			c2[index]= (rsin_theta, 0.0, rcos_theta);
		}
		
		c0= matrix4x4_transform_points3d(c0, transform);
		c1= matrix4x4_transform_points3d(c1, transform);
		c2= matrix4x4_transform_points3d(c2, transform);
		
		// return transformed points list
		for (point_index= 0; point_index<c0.size; point_index++)
		{
			points[points.size]= c0[point_index];
			if (point_index==(c0.size-1))
			{
				points[points.size]= c0[0];
			}
			else
			{
				points[points.size]= c0[point_index+1];
			}
		}
		for (point_index= 0; point_index<c1.size; point_index++)
		{
			points[points.size]= c1[point_index];
			if (point_index==(c1.size-1))
			{
				points[points.size]= c1[0];
			}
			else
			{
				points[points.size]= c1[point_index+1];
			}
		}
		for (point_index= 0; point_index<c2.size; point_index++)
		{
			points[points.size]= c2[point_index];
			if (point_index==(c2.size-1))
			{
				points[points.size]= c2[0];
			}
			else
			{
				points[points.size]= c2[point_index+1];
			}
		}
		/*
		list_index= 0;
		points[list_index]= c0; list_index++;
		points[list_index]= c1; list_index++;
		points[list_index]= c2;
		*/
	}
	
	return points;
}

// points[][]
generate_cylinder_points_list(
	cylinder_base, //point3d
	cylinder_radius, //float
	cylinder_height, //float
	forward, //vector3d
	up) //vector3d
{
	points= [];
	
	if (cylinder_radius>0.0 && cylinder_height>0.0)
	{
		k_segment_count= get_debug_geometry_circular_segment_count();
		k_rotation_delta= 360/k_segment_count;
		
		// top & bottom faces
		bottom= [];
		top= [];
		
		// rotate points about origin & apply translation
		left= vector3d_cross_product(up, forward);
		transform= matrix4x4_build_from_rotation_and_translation(forward, up, left, cylinder_base);
		
		for (index= 0; index<=k_segment_count; index++)
		{
			theta= index*k_rotation_delta;
			rcos_theta= cylinder_radius*Cos(theta);
			rsin_theta= cylinder_radius*Sin(theta);
			
			bottom[index]= (rcos_theta, rsin_theta, 0.0);
			top[index]= (rcos_theta, rsin_theta, cylinder_height);
		}
		
		bottom= matrix4x4_transform_points3d(bottom, transform);
		top= matrix4x4_transform_points3d(top, transform);
		
		// return transformed points list
		for (point_index= 0; point_index<bottom.size; point_index++)
		{
			// bottom circle
			points[points.size]= bottom[point_index];
			if (point_index==(bottom.size-1))
			{
				points[points.size]= bottom[0];
			}
			else
			{
				points[points.size]= bottom[point_index+1];
			}
			// top circle
			points[points.size]= top[point_index];
			if (point_index==(top.size-1))
			{
				points[points.size]= top[0];
			}
			else
			{
				points[points.size]= top[point_index+1];
			}
			// bottom->top
			points[points.size]= bottom[point_index];
			points[points.size]= top[point_index];
		}
		/*list_index= 0;
		points[list_index]= bottom; list_index++;
		points[list_index]= top; list_index++;
		for (index= 0; index<bottom.size; index++)
		{
			theta= index*k_rotation_delta;
			//if (theta==0 || theta==90 || theta==180 || theta==270)
			{
				line_segment= [];
				line_segment[0]= bottom[index];
				line_segment[1]= top[index];
				points[list_index]= line_segment; list_index++;
			}
		}*/
	}
	
	return points;
}

// points[][]
generate_pill_points_lists(
	pill_base, //point3d
	pill_radius, //float
	pill_height, //float
	forward, //vector3d
	up) //vector3d
{
	points= [];
	
	if (pill_radius>0.0 && pill_height>0.0)
	{
		k_segment_count= get_debug_geometry_circular_segment_count();
		k_rotation_delta= 360/k_segment_count;
		
		// top & bottom faces, top & bottom end-cap arcs
		bottom= [];
		top= [];
		t0= [];
		t1= [];
		t2= [];
		b0= [];
		b1= [];
		b2= [];
		
		// rotate points about origin & apply translation
		left= vector3d_cross_product(up, forward);
		transform= matrix4x4_build_from_rotation_and_translation(forward, up, left, pill_base);
		
		cap0_index= 0;
		cap1_index= 0;
		cap2_index= 0;
		for (index= 0; index<=k_segment_count; index++)
		{
			theta= index*k_rotation_delta;
			rcos_theta= pill_radius*Cos(theta);
			rsin_theta= pill_radius*Sin(theta);
			
			bottom[index]= (rcos_theta, rsin_theta, 0.0);
			top[index]= (rcos_theta, rsin_theta, pill_height);
			if (0<=theta && theta<=180)
			{
				b0[cap0_index]= (0.0, rcos_theta, -1.0*rsin_theta);
				t0[cap0_index]= (0.0, rcos_theta, rsin_theta+pill_height);
				cap0_index++;
			}
			if (0<=theta && theta<=90)
			{
				b1[cap1_index]= (rsin_theta, 0.0, -1.0*rcos_theta);
				t1[cap1_index]= (rsin_theta, 0.0, rcos_theta+pill_height);
				cap1_index++;
			}
			if (270<=theta && theta<=360)
			{
				b2[cap2_index]= (rsin_theta, 0.0, -1.0*rcos_theta);
				t2[cap2_index]= (rsin_theta, 0.0, rcos_theta+pill_height);
				cap2_index++;
			}
		}
		
		bottom= matrix4x4_transform_points3d(bottom, transform);
		top= matrix4x4_transform_points3d(top, transform);
		t0= matrix4x4_transform_points3d(t0, transform);
		t1= matrix4x4_transform_points3d(t1, transform);
		t2= matrix4x4_transform_points3d(t2, transform);
		b0= matrix4x4_transform_points3d(b0, transform);
		b1= matrix4x4_transform_points3d(b1, transform);
		b2= matrix4x4_transform_points3d(b2, transform);
		
		// return transformed points lists
		list_index= 0;
		points[list_index]= bottom; list_index++;
		points[list_index]= top; list_index++;
		points[list_index]= b0; list_index++;
		points[list_index]= b1; list_index++;
		points[list_index]= b2; list_index++;
		points[list_index]= t0; list_index++;
		points[list_index]= t1; list_index++;
		points[list_index]= t2; list_index++;
		for (index= 0; index<bottom.size; index++)
		{
			theta= index*k_rotation_delta;
			//if (theta==0 || theta==90 || theta==180 || theta==270)
			{
				line_segment= [];
				line_segment[0]= bottom[index];
				line_segment[1]= top[index];
				points[list_index]= line_segment; list_index++;
			}
		}
	}
	
	return points;
}

// points[][]
generate_cone_points_lists(
	cone_base, //point3d
	cone_radius, //float
	cone_height, //float
	forward, //vector3d
	up) //vector3d
{
	points= [];
	
	if (cone_radius>0 && cone_height>0)
	{
		k_segment_count= get_debug_geometry_circular_segment_count();
		k_rotation_delta= 360/k_segment_count;
		
		// bottom face
		bottom= [];
		
		// rotate points about origin & apply translation
		left= vector3d_cross_product(up, forward);
		transform= matrix4x4_build_from_rotation_and_translation(forward, up, left, cone_base);
		
		for (index= 0; index<=k_segment_count; index++)
		{
			theta= index*k_rotation_delta;
			rcos_theta= cone_radius*Cos(theta);
			rsin_theta= cone_radius*Sin(theta);
			
			bottom[index]= (rcos_theta, rsin_theta, 0.0);
		}
		
		matrix4x4_transform_points3d(bottom, transform);
		
		// top point
		top= matrix4x4_transform_point3d((0, 0, cone_height), transform);
		
		// return transformed points lists
		list_index= 0;
		points[list_index]= bottom; list_index++;
		for (index= 0; index<bottom.size; index++)
		{
			line_segment= [];
			line_segment[0]= bottom[index];
			line_segment[1]= top;
			points[list_index+index]= line_segment;
		}
	}
	
	return points;
}

// points[][]
generate_box_points_lists(
	centroid, //point3d
	dimensions, //vector3d
	forward, //vector3d
	up) //vector3d
{
	points= [];
	
	if (dimensions[0]>0 && dimensions[1]>0 && dimensions[2]>0)
	{
		// rotate points about origin & apply translation
		left= vector3d_cross_product(up, forward);
		transform= matrix4x4_build_from_rotation_and_translation(forward, up, left, centroid);
		
		// apply transform to unit cube
		half_x= dimensions[0]*0.5;
		half_y= dimensions[1]*0.5;
		half_z= dimensions[2]*0.5;
		ftl= matrix4x4_transform_point3d((half_x, half_y, half_z), transform); // front-top-left
		ftr= matrix4x4_transform_point3d((half_x, -1.0*half_y, half_z), transform); // front-top-right
		fbl= matrix4x4_transform_point3d((half_x, half_y, -1*half_z), transform); // front-bottom-left
		fbr= matrix4x4_transform_point3d((half_x, -1.0*half_y, -1.0*half_z), transform); // front-bottom-right
		btl= matrix4x4_transform_point3d((-1*half_x, half_y, half_z), transform); // back-top-left
		btr= matrix4x4_transform_point3d((-1*half_x, -1.0*half_y, half_z), transform); // back-top-right
		bbl= matrix4x4_transform_point3d((-1*half_x, half_y, -1.0*half_z), transform); // back-bottom-left
		bbr= matrix4x4_transform_point3d((-1*half_x, -1.0*half_y, -1*half_z), transform); // back-bottom-right
		
		front_face= [];
		back_face= [];
		tl= [];
		tr= [];
		br= [];
		bl= [];
		front_face[0]= ftl; front_face[1]= ftr; front_face[2]= fbr; front_face[3]= fbl; front_face[4]= ftl;
		back_face[0]= btl; back_face[1]= btr; back_face[2]= bbr; back_face[3]= bbl; back_face[4]= btl;
		tl[0]= ftl; tl[1]= btl;
		tr[0]= ftr; tr[1]= btr;
		br[0]= fbr; br[1]= bbr;
		bl[0]= fbl; bl[1]= bbl;
		
		// return transformed points lists
		list_index= 0;
		points[list_index]= front_face; list_index++;
		points[list_index]= back_face; list_index++;
		points[list_index]= tl; list_index++;
		points[list_index]= tr; list_index++;
		points[list_index]= br; list_index++;
		points[list_index]= bl;
	}
	
	return points;
}
