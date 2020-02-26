textures/sfx/stalingradwater
{
	qer_editorimage env/watercolor_dn
	tessSize 512
	q3map_globaltexture
	surfaceparm trans
	surfaceparm nonsolid
	surfaceparm water
	surfaceparm nolightmap
	surfaceparm noshadow
	sort water
	{
		requires GL_MAX_TEXTURE_UNITS_ARB < 4 || ! GL_NV_texture_shader || ! GL_NV_register_combiners || cvar sys_cpuMHz < 980
		requires GL_MAX_TEXTURE_UNITS_ARB < 4 || ! GL_ATI_fragment_shader || cvar sys_cpuMHz < 980

		map textures/sfx/damwater.jpg
		tcMod Scroll .05 0
		tcMod scale 4 4
		rgbGen exactVertex
	nextbundle
		map $lightmap
	}
	{
		requires GL_MAX_TEXTURE_UNITS_ARB < 4 || ! GL_NV_texture_shader || ! GL_NV_register_combiners || cvar sys_cpuMHz < 980
		requires GL_MAX_TEXTURE_UNITS_ARB < 4 || ! GL_ATI_fragment_shader || cvar sys_cpuMHz < 980

		map textures/sfx/damwateroverlay.jpg
		tcMod scroll -0.01 .01
		tcMod scale 2 2
		tcMod turb 1.03 0.2 1.03
		rgbGen exactVertex
		blendFunc add
	nextbundle
		map textures/sfx/damwateroverlay.jpg
		tcMod scroll 0.02 .02
		tcMod scale 4 4
		tcMod turb 0.01 0.2 0.03
	}
	{
		requires GL_MAX_TEXTURE_UNITS_ARB < 4 || ! GL_NV_texture_shader || ! GL_NV_register_combiners
		requires GL_MAX_TEXTURE_UNITS_ARB < 4 || ! GL_ATI_fragment_shader
		requires GL_ARB_texture_cube_map
		requires GL_ARB_texture_env_combine
		requires GL_ARB_texture_env_dot3
		requires cvar sys_cpuMHz >= 980

		// img_width   img_height   world_width   world_height   wind_vel   wind_dir_x   wind_dir_y   wave_amplitude
		waterMap	64 64   37 37    76 1 0   .07
		rgbGen identity
		tcgen vector ( .001953125 0 0 ) ( 0 .001953125 0 )
		tcmod scroll .1 0
		blendfunc GL_SRC_ALPHA GL_ZERO
	nextbundle
		cubemap $renormalize
		tcGen sunHalfAngle
		texEnvCombine
		{
			rgb = DOT3_RGBA_ARB(Cp, Ct)
		}
	}
	{
		requires GL_MAX_TEXTURE_UNITS_ARB < 4 || ! GL_NV_texture_shader || ! GL_NV_register_combiners
		requires GL_MAX_TEXTURE_UNITS_ARB < 4 || ! GL_ATI_fragment_shader
		requires GL_ARB_texture_cube_map
		requires GL_ARB_texture_env_combine
		requires GL_ARB_texture_env_dot3
		requires cvar sys_cpuMHz >= 980

		map $whiteimage
		alphaGen dot
		rgbGen constLighting ( 0 .05 .1 )
		blendfunc GL_ONE GL_SRC_ALPHA
		texEnvCombine
		{
			rgb = REPLACE(Cp)
			alpha = MODULATE(1-Ap,1-Ap)
		}
	nextbundle
		map $whiteimage
		texEnvCombine
		{
			const = ( .15 .2 .25 .2 ) * identityLighting
			rgb = INTERPOLATE_ARB(Cc, Cp, Ap)
			alpha = REPLACE(Ac)
		}
	}
	{
		requires GL_MAX_TEXTURE_UNITS_ARB >= 4
		requires GL_NV_texture_shader
		requires GL_ARB_texture_cube_map
		requires GL_NV_register_combiners
		requires cvar sys_cpuMHz >= 980

		// img_width   img_height   world_width   world_height   wind_vel   wind_dir_x   wind_dir_y   wave_amplitude
		waterMap	64 64   37 37    76 1 0   .06
		rgbGen vertex
		alphaGen vertex
		blendFunc blend
		tcgen vector ( .001953125 0 0 ) ( 0 .001953125 0 )
		tcmod scroll .07 0
	nextbundle
		cubemap $renormalize
		tcgen nv_dot_product_reflect_cube_map_eye_from_qs_1of3
		nvTexShader dot_product_cube_map_and_reflect_cube_map_eye_from_qs_1of3(expand tex0)
	nextbundle
		cubemap env/watercolor
		tcgen nv_dot_product_reflect_cube_map_eye_from_qs_2of3
		nvTexShader dot_product_cube_map_and_reflect_cube_map_eye_from_qs_2of3(expand tex0)
	nextbundle
		cubemap env/stalin128
		tcgen nv_dot_product_reflect_cube_map_eye_from_qs_3of3
		nvTexShader dot_product_cube_map_and_reflect_cube_map_eye_from_qs_3of3(expand tex0)

		nvRegCombiners
		{
			{
				rgb
				{
					discard = tex2 * unsigned_invert(tex3.a);
					discard = tex3 * tex3.a;
					spare0 = sum();
				}
			}
			{
				rgb
				{
					spare0 = spare0 * col0;
				}
			}
			out.rgb = lerp(fog.a, spare0, fog);
			out.a = col0.a;
		}
	}
	{
		requires ! GL_NV_texture_shader || ! GL_NV_register_combiners
		requires GL_MAX_TEXTURE_UNITS_ARB >= 4
		requires GL_ATI_fragment_shader
		requires GL_ARB_texture_cube_map
		requires cvar sys_cpuMHz >= 980

		// img_width   img_height   world_width   world_height   wind_vel   wind_dir_x   wind_dir_y   wave_amplitude
		waterMap	64 64   37 37    76 1 0   .06
		rgbGen vertex
		alphaGen vertex
		blendFunc blend
		tcgen vector ( .001953125 0 0 ) ( 0 .001953125 0 )
		tcmod scroll .07 0
	nextbundle
		cubemap $renormalize
		tcgen vertexToEye
	nextbundle
		cubemap env/watercolor
	nextbundle
		cubemap env/stalin128
/*
// do this only if the shader is not in world coordinates or it has vertex deformation
	nextbundle
		cubemap env/watercolor
		tcgen tbn_x
	nextbundle
		cubemap env/stalin128
		tcgen tbn_y
	nextbundle
		cubemap $renormalize
		tcgen tbn_z
*/

		atiFragmentShader
		{
			//*****************************************************************************
			// phase 0

			//-------------------------------------
			// routing section

			r0 = tex(tc0);	// r0 = bumpmap surface normal
			r1 = tex(tc1);	// r1 = normalized eye-to-point direction vector in world space
/*
// do this only if the shader is not in world coordinates or it has vertex deformation
			r2 = copy(tc2);	// r2 = Tx,Bx,Nx
			r3 = copy(tc3);	// r3 = Ty,By,Ny
			r4 = copy(tc4);	// r4 = Tz,Bz,Nz
*/

			//-------------------------------------
			// operation section
			// need to calculate lookup vectors for the reflection cube map and the diffuse cube map in surface-local space
			// The diffuse cubemap vector is merely the surface normal from the bumpmap (ie, r0) rotated into world space
			// The specular vector is the world space eye vector reflected around the world space normal vector.
			// E + 2 (((E . N) N) / (N . N) - E) = 2 ((E . N) / (N . N)) N - E = (2 (E . N) N - (N . N) E) / N . N

// do this only if the shader is in world coordinates and has no vertex deformation
			// reflect eye vector in world space
			r3 = dot3(r1 * 2 - 1, r0 * 2 - 1);	// r3 = E . N
			r3 = mul(r3, r0 * 2 - 1);			// r3 = (E . N) N
			r3 = sub(r3 * 2, r1 * 2 - 1);		// r3 = 2 (E . N) N - E = reflection vector

/*
// do this only if the shader is not in world coordinates or it has vertex deformation
			// rotate per-pixel normal into world space
			r2.r = dot3(r0 * 2 - 1, r2);
			r2.g = dot3(r0 * 2 - 1, r3);
			r2.b = dot3(r0 * 2 - 1, r4);	// r2 = N

			// reflect eye vector in world space assuming N can be unnormalized
			// N can only be unnormalized if the TBN frame is different for 2 or more vertices of a triangle
			r3 = dot3(r2, r1 * 2 - 1);		// r3 = E . N
			r3 = mul(r3, r2);				// r3 = (E . N) N
			r0 = dot3(r2, r2);				// r0 = N . N
			r0 = mul(r0, r1 * 2 - 1);		// r0 = (N . N) E
			r3 = sub(r3 * 2, r0);			// r3 = 2 (E . N) N - (N . N) E = reflection vector
*/

			//*****************************************************************************
			// phase 1

			//-------------------------------------
			// routing section

			r2 = tex(r2);	// r2 = diffuse color
			r3 = tex(r3);	// r3 = specular color + fresnel alpha

			//-------------------------------------
			// operation section
			// need to store r0.rgba with the color and alpha

			r0 = lerp(r3.a, r3, r2);
			r0 = mul(r0, col0);
			r0.a = mov(col0.a);
		}
	}
}

textures/sfx/truckridewater
{
	qer_editorimage env/watercolor_dn
	tessSize 512
	q3map_globaltexture
	surfaceparm trans
	surfaceparm nonsolid
	surfaceparm water
	surfaceparm nolightmap
	surfaceparm noshadow
	sort water
	{
		requires GL_MAX_TEXTURE_UNITS_ARB < 4 || ! GL_NV_texture_shader || ! GL_NV_register_combiners
		requires GL_MAX_TEXTURE_UNITS_ARB < 4 || ! GL_ATI_fragment_shader
		requires GL_ARB_texture_cube_map
		requires GL_ARB_texture_env_combine
		requires GL_ARB_texture_env_dot3

		// img_width   img_height   world_width   world_height   wind_vel   wind_dir_x   wind_dir_y   wave_amplitude
		waterMap	64 64   37 37    76 1 0   .07
		rgbGen identity
		tcgen vector ( .001953125 0 0 ) ( 0 .001953125 0 )
		tcmod scroll .1 0
		blendfunc GL_SRC_ALPHA GL_ZERO
	nextbundle
		cubemap $renormalize
		tcGen sunHalfAngle
		texEnvCombine
		{
			rgb = DOT3_RGBA_ARB(Cp, Ct)
		}
	}
	{
		requires GL_MAX_TEXTURE_UNITS_ARB < 4 || ! GL_NV_texture_shader || ! GL_NV_register_combiners
		requires GL_MAX_TEXTURE_UNITS_ARB < 4 || ! GL_ATI_fragment_shader
		requires GL_ARB_texture_cube_map
		requires GL_ARB_texture_env_combine
		requires GL_ARB_texture_env_dot3

		map $whiteimage
		alphaGen dot
		rgbGen constLighting ( 0 .05 .1 )
		blendfunc GL_ONE GL_SRC_ALPHA
		texEnvCombine
		{
			rgb = REPLACE(Cp)
			alpha = MODULATE(1-Ap,1-Ap)
		}
	nextbundle
		map $whiteimage
		texEnvCombine
		{
			const = ( .15 .2 .25 .2 ) * identityLighting
			rgb = INTERPOLATE_ARB(Cc, Cp, Ap)
			alpha = REPLACE(Ac)
		}
	}
	{
		requires GL_MAX_TEXTURE_UNITS_ARB >= 4
		requires GL_NV_texture_shader
		requires GL_ARB_texture_cube_map
		requires GL_NV_register_combiners

		// img_width   img_height   world_width   world_height   wind_vel   wind_dir_x   wind_dir_y   wave_amplitude
		waterMap	64 64   37 37    76 1 0   .06
		rgbGen vertex
		alphaGen vertex
		blendFunc blend
		tcgen vector ( .001953125 0 0 ) ( 0 .001953125 0 )
		tcmod scroll .07 0
	nextbundle
		cubemap $renormalize
		tcgen nv_dot_product_reflect_cube_map_eye_from_qs_1of3
		nvTexShader dot_product_cube_map_and_reflect_cube_map_eye_from_qs_1of3(expand tex0)
	nextbundle
		cubemap env/watercolor
		tcgen nv_dot_product_reflect_cube_map_eye_from_qs_2of3
		nvTexShader dot_product_cube_map_and_reflect_cube_map_eye_from_qs_2of3(expand tex0)
	nextbundle
		cubemap env/truckride
		tcgen nv_dot_product_reflect_cube_map_eye_from_qs_3of3
		nvTexShader dot_product_cube_map_and_reflect_cube_map_eye_from_qs_3of3(expand tex0)

		nvRegCombiners
		{
			{
				rgb
				{
					discard = tex2 * unsigned_invert(tex3.a);
					discard = tex3 * tex3.a;
					spare0 = sum();
				}
			}
			{
				rgb
				{
					spare0 = spare0 * col0;
				}
			}
			out.rgb = lerp(fog.a, spare0, fog);
			out.a = col0.a;
		}
	}
	{
		requires ! GL_NV_texture_shader || ! GL_NV_register_combiners
		requires GL_MAX_TEXTURE_UNITS_ARB >= 4
		requires GL_ATI_fragment_shader
		requires GL_ARB_texture_cube_map

		// img_width   img_height   world_width   world_height   wind_vel   wind_dir_x   wind_dir_y   wave_amplitude
		waterMap	64 64   37 37    76 1 0   .06
		rgbGen vertex
		alphaGen vertex
		blendFunc blend
		tcgen vector ( .001953125 0 0 ) ( 0 .001953125 0 )
		tcmod scroll .07 0
	nextbundle
		cubemap $renormalize
		tcgen vertexToEye
	nextbundle
		cubemap env/watercolor
	nextbundle
		cubemap env/truckride
/*
// do this only if the shader is not in world coordinates or it has vertex deformation
	nextbundle
		cubemap env/watercolor
		tcgen tbn_x
	nextbundle
		cubemap env/truckride
		tcgen tbn_y
	nextbundle
		cubemap $renormalize
		tcgen tbn_z
*/

		atiFragmentShader
		{
			//*****************************************************************************
			// phase 0

			//-------------------------------------
			// routing section

			r0 = tex(tc0);	// r0 = bumpmap surface normal
			r1 = tex(tc1);	// r1 = normalized eye-to-point direction vector in world space
/*
// do this only if the shader is not in world coordinates or it has vertex deformation
			r2 = copy(tc2);	// r2 = Tx,Bx,Nx
			r3 = copy(tc3);	// r3 = Ty,By,Ny
			r4 = copy(tc4);	// r4 = Tz,Bz,Nz
*/

			//-------------------------------------
			// operation section
			// need to calculate lookup vectors for the reflection cube map and the diffuse cube map in surface-local space
			// The diffuse cubemap vector is merely the surface normal from the bumpmap (ie, r0) rotated into world space
			// The specular vector is the world space eye vector reflected around the world space normal vector.
			// E + 2 (((E . N) N) / (N . N) - E) = 2 ((E . N) / (N . N)) N - E = (2 (E . N) N - (N . N) E) / N . N

// do this only if the shader is in world coordinates and has no vertex deformation
			// reflect eye vector in world space
			r3 = dot3(r1 * 2 - 1, r0 * 2 - 1);	// r3 = E . N
			r3 = mul(r3, r0 * 2 - 1);			// r3 = (E . N) N
			r3 = sub(r3 * 2, r1 * 2 - 1);		// r3 = 2 (E . N) N - E = reflection vector

/*
// do this only if the shader is not in world coordinates or it has vertex deformation
			// rotate per-pixel normal into world space
			r2.r = dot3(r0 * 2 - 1, r2);
			r2.g = dot3(r0 * 2 - 1, r3);
			r2.b = dot3(r0 * 2 - 1, r4);	// r2 = N

			// reflect eye vector in world space assuming N can be unnormalized
			// N can only be unnormalized if the TBN frame is different for 2 or more vertices of a triangle
			r3 = dot3(r2, r1 * 2 - 1);		// r3 = E . N
			r3 = mul(r3, r2);				// r3 = (E . N) N
			r0 = dot3(r2, r2);				// r0 = N . N
			r0 = mul(r0, r1 * 2 - 1);		// r0 = (N . N) E
			r3 = sub(r3 * 2, r0);			// r3 = 2 (E . N) N - (N . N) E = reflection vector
*/

			//*****************************************************************************
			// phase 1

			//-------------------------------------
			// routing section

			r2 = tex(r2);	// r2 = diffuse color
			r3 = tex(r3);	// r3 = specular color + fresnel alpha

			//-------------------------------------
			// operation section
			// need to store r0.rgba with the color and alpha

			r0 = lerp(r3.a, r3, r2);
			r0 = mul(r0, col0);
			r0.a = mov(col0.a);
		}
	}
}

textures/sfx/sewerwater
{
	qer_editorimage env/sewercolor_dn
	tessSize 512
	q3map_globaltexture
	surfaceparm trans
	surfaceparm nonsolid
	surfaceparm water
	sort water
	{
		requires GL_MAX_TEXTURE_UNITS_ARB < 4 || ! GL_NV_texture_shader || ! GL_NV_register_combiners
		requires GL_MAX_TEXTURE_UNITS_ARB < 4 || ! GL_ATI_fragment_shader		
		map textures/sfx/damwater.jpg
		tcMod Scroll .05 0
		tcMod scale 4 4
		rgbGen exactVertex
	nextbundle
		map $lightmap
	}
	{
		requires GL_MAX_TEXTURE_UNITS_ARB < 4 || ! GL_NV_texture_shader || ! GL_NV_register_combiners
		requires GL_MAX_TEXTURE_UNITS_ARB < 4 || ! GL_ATI_fragment_shader
		map textures/sfx/damwateroverlay.jpg
		tcMod scroll -0.01 .01
		tcMod scale 2 2
		tcMod turb 1.03 0.2 1.03
		rgbGen exactVertex
		blendFunc add
	nextbundle
		map textures/sfx/damwateroverlay.jpg
		tcMod scroll 0.02 .02
		tcMod scale 4 4
		tcMod turb 0.01 0.2 0.03
	}
	{
		requires GL_MAX_TEXTURE_UNITS_ARB >= 4
		requires GL_NV_texture_shader
		requires GL_ARB_texture_cube_map
		requires GL_NV_register_combiners

		// img_width   img_height   world_width   world_height   wind_vel   wind_dir_x   wind_dir_y   wave_amplitude
		waterMap	64 64   37 37    76 1 0   .06
		rgbGen identitylighting
		alphaGen vertex
		blendFunc blend
		tcgen vector ( .001953125 0 0 ) ( 0 .001953125 0 )
		tcmod scroll .07 0
	nextbundle
		cubemap $renormalize
		tcgen nv_dot_product_reflect_cube_map_eye_from_qs_1of3
		nvTexShader dot_product_cube_map_and_reflect_cube_map_eye_from_qs_1of3(expand tex0)
	nextbundle
		cubemap env/sewercolor
		tcgen nv_dot_product_reflect_cube_map_eye_from_qs_2of3
		nvTexShader dot_product_cube_map_and_reflect_cube_map_eye_from_qs_2of3(expand tex0)
	nextbundle
		cubemap env/sewerpuddle
		tcgen nv_dot_product_reflect_cube_map_eye_from_qs_3of3
		nvTexShader dot_product_cube_map_and_reflect_cube_map_eye_from_qs_3of3(expand tex0)

		nvRegCombiners
		{
			{
				rgb
				{
					discard = tex2 * unsigned_invert(tex3.a);
					discard = tex3 * tex3.a;
					spare0 = sum();
				}
			}
			{
				rgb
				{
					spare0 = spare0 * col0;
				}
			}
			out.rgb = lerp(fog.a, spare0, fog);
			out.a = col0.a;
		}
	}
	{
		requires ! GL_NV_texture_shader || ! GL_NV_register_combiners
		requires GL_MAX_TEXTURE_UNITS_ARB >= 4
		requires GL_ATI_fragment_shader
		requires GL_ARB_texture_cube_map

		// img_width   img_height   world_width   world_height   wind_vel   wind_dir_x   wind_dir_y   wave_amplitude
		waterMap	64 64   37 37    76 1 0   .06
		rgbGen vertex
		alphaGen vertex
		blendFunc blend
		tcgen vector ( .001953125 0 0 ) ( 0 .001953125 0 )
		tcmod scroll .07 0
	nextbundle
		cubemap $renormalize
		tcgen vertexToEye
	nextbundle
		cubemap env/sewercolor
	nextbundle
		cubemap env/sewerpuddle
/*
// do this only if the shader is not in world coordinates or it has vertex deformation
	nextbundle
		cubemap env/sewercolor
		tcgen tbn_x
	nextbundle
		cubemap env/sewerpuddle
		tcgen tbn_y
	nextbundle
		cubemap $renormalize
		tcgen tbn_z
*/

		atiFragmentShader
		{
			//*****************************************************************************
			// phase 0

			//-------------------------------------
			// routing section

			r0 = tex(tc0);	// r0 = bumpmap surface normal
			r1 = tex(tc1);	// r1 = normalized eye-to-point direction vector in world space
/*
// do this only if the shader is not in world coordinates or it has vertex deformation
			r2 = copy(tc2);	// r2 = Tx,Bx,Nx
			r3 = copy(tc3);	// r3 = Ty,By,Ny
			r4 = copy(tc4);	// r4 = Tz,Bz,Nz
*/

			//-------------------------------------
			// operation section
			// need to calculate lookup vectors for the reflection cube map and the diffuse cube map in surface-local space
			// The diffuse cubemap vector is merely the surface normal from the bumpmap (ie, r0) rotated into world space
			// The specular vector is the world space eye vector reflected around the world space normal vector.
			// E + 2 (((E . N) N) / (N . N) - E) = 2 ((E . N) / (N . N)) N - E = (2 (E . N) N - (N . N) E) / N . N

// do this only if the shader is in world coordinates and has no vertex deformation
			// reflect eye vector in world space
			r3 = dot3(r1 * 2 - 1, r0 * 2 - 1);	// r3 = E . N
			r3 = mul(r3, r0 * 2 - 1);			// r3 = (E . N) N
			r3 = sub(r3 * 2, r1 * 2 - 1);		// r3 = 2 (E . N) N - E = reflection vector

/*
// do this only if the shader is not in world coordinates or it has vertex deformation
			// rotate per-pixel normal into world space
			r2.r = dot3(r0 * 2 - 1, r2);
			r2.g = dot3(r0 * 2 - 1, r3);
			r2.b = dot3(r0 * 2 - 1, r4);	// r2 = N

			// reflect eye vector in world space assuming N can be unnormalized
			// N can only be unnormalized if the TBN frame is different for 2 or more vertices of a triangle
			r3 = dot3(r2, r1 * 2 - 1);		// r3 = E . N
			r3 = mul(r3, r2);				// r3 = (E . N) N
			r0 = dot3(r2, r2);				// r0 = N . N
			r0 = mul(r0, r1 * 2 - 1);		// r0 = (N . N) E
			r3 = sub(r3 * 2, r0);			// r3 = 2 (E . N) N - (N . N) E = reflection vector
*/

			//*****************************************************************************
			// phase 1

			//-------------------------------------
			// routing section

			r2 = tex(r2);	// r2 = diffuse color
			r3 = tex(r3);	// r3 = specular color + fresnel alpha

			//-------------------------------------
			// operation section
			// need to store r0.rgba with the color and alpha

			r0 = lerp(r3.a, r3, r2);
			r0 = mul(r0, col0);
			r0.a = mov(col0.a);
		}
	}
}

textures/sfx/pondwater
{
	qer_editorimage textures/sfx/pondwater
	qer_trans .5
	surfaceparm trans
	surfaceparm nonsolid
	surfaceparm water
	surfaceparm noshadow
	sort water
	{
		map textures/sfx/pondwater.tga
		rgbGen exactVertex
		blendFunc blend
		tcMod scale 1 .5
		tcMod Scroll .01 0
	nextbundle
		map $lightmap
	}
	{
		map textures/sfx/pondwateroverlay.jpg
		rgbGen vertex
		tcMod scale 3 3
		tcMod turb 2.03 0.2 1.03
		tcMod scroll -0.02 .01
		blendFunc add
	nextbundle
		map textures/sfx/pondwateroverlay.jpg
		tcMod scale 2 2
		tcMod turb 0.01 0.2 0.03
		tcMod scroll 0.02 .04
	}	
}

textures/sfx/fastwaterold
{
	qer_editorimage textures/sfx/pondwater
	qer_trans .5
	surfaceparm trans
	surfaceparm nonsolid
	surfaceparm water
	surfaceparm noshadow
	sort water
	{
		map textures/sfx/pondwater.tga
		rgbGen exactVertex
		tcMod transform 1 0 0 1 0 0
		tcMod Scroll 0.60 0.1
		blendFunc blend
	nextbundle
		map $lightmap
	}
	{
		map textures/sfx/pondwateroverlay.jpg
		rgbGen vertex
		tcMod transform 3 0 0 3 0 0
		tcMod turb 2.03 0.2 1.03
		tcMod scroll 0.5 0
		blendFunc add
	nextbundle
		map textures/sfx/pondwateroverlay.jpg
		tcMod transform 2 0 0 2 0 0
		tcMod turb 0.01 0.2 0.03
		tcMod scroll 0.4 0
	}	
}

textures/sfx/fastwater
{
	qer_editorimage textures/sfx/pondwater
	qer_trans .5
	surfaceparm trans
	surfaceparm nonsolid
	surfaceparm water
	surfaceparm noshadow
	sort water
	{
		map textures/sfx/pondwater.tga
		rgbGen exactVertex
		tcMod transform 1 0 0 1 0 0
		tcMod Scroll -0.60 0.1
		blendFunc blend
	nextbundle
		map $lightmap
	}
	{
		map clampy textures/sfx/pondwaterspray.jpg
		rgbGen constLighting ( .6 .6 .6 )
	//	rgbGen identityLighting
	//	tcMod transform 1 0 0 1 0 -1
		tcMod transform 1 0 0 1 0 -1
	//	tcMod transform 1 0 0 1 0 -3
		tcMod scroll -0.75 0
		tcMod turb 2.03 0.2 1.03
		blendFunc add
	}	
	{
		map clampy textures/sfx/pondwaterspray.jpg
		rgbGen constLighting ( .6 .6 .6 )
	//	rgbGen identityLighting
		tcMod transform 1 0 0 -1 0 0
	//	tcMod transform 1 0 0 -1 0 1
	//	tcMod transform 1 0 0 -1 0 2
		tcMod scroll -0.75 0
		tcMod turb 2.03 0.2 1.03
		blendFunc add
	}	
	{
		map textures/sfx/pondwateroverlay.jpg
		rgbGen vertex
		tcMod transform 3 0 0 3 0 0
		tcMod turb 2.03 0.2 1.03
		tcMod scroll -0.5 0
		blendFunc add
	nextbundle
		map textures/sfx/pondwateroverlay.jpg
		tcMod transform 2 0 0 2 0 0
		tcMod turb 0.01 0.2 0.03
		tcMod scroll -0.4 0
	}
}
textures/sfx/damwater
{
	qer_editorimage env/watercolor_dn
	tessSize 512
	q3map_globaltexture
	surfaceparm trans
	surfaceparm nonsolid
	surfaceparm water
	surfaceparm nolightmap
	surfaceparm noshadow
	sort water
	{
		requires GL_MAX_TEXTURE_UNITS_ARB < 4 || ! GL_NV_texture_shader || ! GL_NV_register_combiners
		requires GL_MAX_TEXTURE_UNITS_ARB < 4 || ! GL_ATI_fragment_shader
		requires GL_ARB_texture_cube_map
		requires GL_ARB_texture_env_combine
		requires GL_ARB_texture_env_dot3

		// img_width   img_height   world_width   world_height   wind_vel   wind_dir_x   wind_dir_y   wave_amplitude
		waterMap	64 64   37 37    76 1 0   .07
		rgbGen identity
		tcgen vector ( .001953125 0 0 ) ( 0 .001953125 0 )
		tcmod scroll .1 0
		blendfunc GL_SRC_ALPHA GL_ZERO
	nextbundle
		cubemap $renormalize
		tcGen sunHalfAngle
		texEnvCombine
		{
			rgb = DOT3_RGBA_ARB(Cp, Ct)
		}
	}
	{
		requires GL_MAX_TEXTURE_UNITS_ARB < 4 || ! GL_NV_texture_shader || ! GL_NV_register_combiners
		requires GL_MAX_TEXTURE_UNITS_ARB < 4 || ! GL_ATI_fragment_shader
		requires GL_ARB_texture_cube_map
		requires GL_ARB_texture_env_combine
		requires GL_ARB_texture_env_dot3

		map $whiteimage
		alphaGen dot
		rgbGen constLighting ( 0 .05 .1 )
		blendfunc GL_ONE GL_SRC_ALPHA
		texEnvCombine
		{
			rgb = REPLACE(Cp)
			alpha = MODULATE(1-Ap,1-Ap)
		}
	nextbundle
		map $whiteimage
		texEnvCombine
		{
			const = ( .15 .2 .25 .2 ) * identityLighting
			rgb = INTERPOLATE_ARB(Cc, Cp, Ap)
			alpha = REPLACE(Ac)
		}
	}
	{
		requires GL_MAX_TEXTURE_UNITS_ARB >= 4
		requires GL_NV_texture_shader
		requires GL_ARB_texture_cube_map
		requires GL_NV_register_combiners

		// img_width   img_height   world_width   world_height   wind_vel   wind_dir_x   wind_dir_y   wave_amplitude
		waterMap	64 64   37 37    76 1 0   .06
		rgbGen identitylighting
		//alphaGen vertex
		//blendFunc blend
		tcgen vector ( .001953125 0 0 ) ( 0 .001953125 0 )
		tcmod scroll .07 0
	nextbundle
		cubemap $renormalize
		tcgen nv_dot_product_reflect_cube_map_eye_from_qs_1of3
		nvTexShader dot_product_cube_map_and_reflect_cube_map_eye_from_qs_1of3(expand tex0)
	nextbundle
		cubemap env/watercolor
		tcgen nv_dot_product_reflect_cube_map_eye_from_qs_2of3
		nvTexShader dot_product_cube_map_and_reflect_cube_map_eye_from_qs_2of3(expand tex0)
	nextbundle
		cubemap env/damwater
		tcgen nv_dot_product_reflect_cube_map_eye_from_qs_3of3
		nvTexShader dot_product_cube_map_and_reflect_cube_map_eye_from_qs_3of3(expand tex0)

		nvRegCombiners
		{
			{
				rgb
				{
					discard = tex2 * unsigned_invert(tex3.a);
					discard = tex3 * tex3.a;
					spare0 = sum();
				}
			}
			{
				rgb
				{
					spare0 = spare0 * col0;
				}
			}
			out.rgb = lerp(fog.a, spare0, fog);
			out.a = col0.a;
		}
	}
	{
		requires ! GL_NV_texture_shader || ! GL_NV_register_combiners
		requires GL_MAX_TEXTURE_UNITS_ARB >= 4
		requires GL_ATI_fragment_shader
		requires GL_ARB_texture_cube_map

		// img_width   img_height   world_width   world_height   wind_vel   wind_dir_x   wind_dir_y   wave_amplitude
		waterMap	64 64   37 37    76 1 0   .06
		rgbGen identitylighting
		//alphaGen vertex
		//blendFunc blend
		tcgen vector ( .001953125 0 0 ) ( 0 .001953125 0 )
		tcmod scroll .07 0
	nextbundle
		cubemap $renormalize
		tcgen vertexToEye
	nextbundle
		cubemap env/watercolor
	nextbundle
		cubemap env/damwater
/*
// do this only if the shader is not in world coordinates or it has vertex deformation
	nextbundle
		cubemap env/watercolor
		tcgen tbn_x
	nextbundle
		cubemap env/damwater
		tcgen tbn_y
	nextbundle
		cubemap $renormalize
		tcgen tbn_z
*/

		atiFragmentShader
		{
			//*****************************************************************************
			// phase 0

			//-------------------------------------
			// routing section

			r0 = tex(tc0);	// r0 = bumpmap surface normal
			r1 = tex(tc1);	// r1 = normalized eye-to-point direction vector in world space
/*
// do this only if the shader is not in world coordinates or it has vertex deformation
			r2 = copy(tc2);	// r2 = Tx,Bx,Nx
			r3 = copy(tc3);	// r3 = Ty,By,Ny
			r4 = copy(tc4);	// r4 = Tz,Bz,Nz
*/

			//-------------------------------------
			// operation section
			// need to calculate lookup vectors for the reflection cube map and the diffuse cube map in surface-local space
			// The diffuse cubemap vector is merely the surface normal from the bumpmap (ie, r0) rotated into world space
			// The specular vector is the world space eye vector reflected around the world space normal vector.
			// E + 2 (((E . N) N) / (N . N) - E) = 2 ((E . N) / (N . N)) N - E = (2 (E . N) N - (N . N) E) / N . N

// do this only if the shader is in world coordinates and has no vertex deformation
			// reflect eye vector in world space
			r3 = dot3(r1 * 2 - 1, r0 * 2 - 1);	// r3 = E . N
			r3 = mul(r3, r0 * 2 - 1);			// r3 = (E . N) N
			r3 = sub(r3 * 2, r1 * 2 - 1);		// r3 = 2 (E . N) N - E = reflection vector

/*
// do this only if the shader is not in world coordinates or it has vertex deformation
			// rotate per-pixel normal into world space
			r2.r = dot3(r0 * 2 - 1, r2);
			r2.g = dot3(r0 * 2 - 1, r3);
			r2.b = dot3(r0 * 2 - 1, r4);	// r2 = N

			// reflect eye vector in world space assuming N can be unnormalized
			// N can only be unnormalized if the TBN frame is different for 2 or more vertices of a triangle
			r3 = dot3(r2, r1 * 2 - 1);		// r3 = E . N
			r3 = mul(r3, r2);				// r3 = (E . N) N
			r0 = dot3(r2, r2);				// r0 = N . N
			r0 = mul(r0, r1 * 2 - 1);		// r0 = (N . N) E
			r3 = sub(r3 * 2, r0);			// r3 = 2 (E . N) N - (N . N) E = reflection vector
*/

			//*****************************************************************************
			// phase 1

			//-------------------------------------
			// routing section

			r2 = tex(r2);	// r2 = diffuse color
			r3 = tex(r3);	// r3 = specular color + fresnel alpha

			//-------------------------------------
			// operation section
			// need to store r0.rgba with the color and alpha

			r0 = lerp(r3.a, r3, r2);
			r0 = mul(r0, col0);
			r0.a = mov(col0.a);
		}
	}
}

textures/sfx/tankcountrywater
{
	qer_editorimage env/watercolor_dn
	tessSize 512
	q3map_globaltexture
	surfaceparm trans
	surfaceparm nonsolid
	surfaceparm water
	surfaceparm nolightmap
	surfaceparm noshadow
	sort water
	{
		requires GL_MAX_TEXTURE_UNITS_ARB < 4 || ! GL_NV_texture_shader || ! GL_NV_register_combiners
		requires GL_MAX_TEXTURE_UNITS_ARB < 4 || ! GL_ATI_fragment_shader
		requires GL_ARB_texture_cube_map
		requires GL_ARB_texture_env_combine
		requires GL_ARB_texture_env_dot3

		// img_width   img_height   world_width   world_height   wind_vel   wind_dir_x   wind_dir_y   wave_amplitude
		waterMap	64 64   37 37    76 1 0   .07
		rgbGen identity
		tcgen vector ( .001953125 0 0 ) ( 0 .001953125 0 )
		tcmod scroll .1 0
		blendfunc GL_SRC_ALPHA GL_ZERO
	nextbundle
		cubemap $renormalize
		tcGen sunHalfAngle
		texEnvCombine
		{
			rgb = DOT3_RGBA_ARB(Cp, Ct)
		}
	}
	{
		requires GL_MAX_TEXTURE_UNITS_ARB < 4 || ! GL_NV_texture_shader || ! GL_NV_register_combiners
		requires GL_MAX_TEXTURE_UNITS_ARB < 4 || ! GL_ATI_fragment_shader
		requires GL_ARB_texture_cube_map
		requires GL_ARB_texture_env_combine
		requires GL_ARB_texture_env_dot3

		map $whiteimage
		alphaGen dot
		rgbGen constLighting ( 0 .05 .1 )
		blendfunc GL_ONE GL_SRC_ALPHA
		texEnvCombine
		{
			rgb = REPLACE(Cp)
			alpha = MODULATE(1-Ap,1-Ap)
		}
	nextbundle
		map $whiteimage
		texEnvCombine
		{
			const = ( .15 .2 .25 .2 ) * identityLighting
			rgb = INTERPOLATE_ARB(Cc, Cp, Ap)
			alpha = REPLACE(Ac)
		}
	}
	{
		requires GL_MAX_TEXTURE_UNITS_ARB >= 4
		requires GL_NV_texture_shader
		requires GL_ARB_texture_cube_map
		requires GL_NV_register_combiners

		// img_width   img_height   world_width   world_height   wind_vel   wind_dir_x   wind_dir_y   wave_amplitude
		waterMap	64 64   37 37    76 1 0   .06
		rgbGen vertex
		alphaGen vertex
		blendFunc blend
		tcgen vector ( .001953125 0 0 ) ( 0 .001953125 0 )
		tcmod scroll .07 0
	nextbundle
		cubemap $renormalize
		tcgen nv_dot_product_reflect_cube_map_eye_from_qs_1of3
		nvTexShader dot_product_cube_map_and_reflect_cube_map_eye_from_qs_1of3(expand tex0)
	nextbundle
		cubemap env/watercolor
		tcgen nv_dot_product_reflect_cube_map_eye_from_qs_2of3
		nvTexShader dot_product_cube_map_and_reflect_cube_map_eye_from_qs_2of3(expand tex0)
	nextbundle
		cubemap env/tankcountrywater
		tcgen nv_dot_product_reflect_cube_map_eye_from_qs_3of3
		nvTexShader dot_product_cube_map_and_reflect_cube_map_eye_from_qs_3of3(expand tex0)

		nvRegCombiners
		{
			{
				rgb
				{
					discard = tex2 * unsigned_invert(tex3.a);
					discard = tex3 * tex3.a;
					spare0 = sum();
				}
			}
			{
				rgb
				{
					spare0 = spare0 * col0;
				}
			}
			out.rgb = lerp(fog.a, spare0, fog);
			out.a = col0.a;
		}
	}
	{
		requires ! GL_NV_texture_shader || ! GL_NV_register_combiners
		requires GL_MAX_TEXTURE_UNITS_ARB >= 4
		requires GL_ATI_fragment_shader
		requires GL_ARB_texture_cube_map

		// img_width   img_height   world_width   world_height   wind_vel   wind_dir_x   wind_dir_y   wave_amplitude
		waterMap	64 64   37 37    76 1 0   .06
		rgbGen vertex
		alphaGen vertex
		blendFunc blend
		tcgen vector ( .001953125 0 0 ) ( 0 .001953125 0 )
		tcmod scroll .07 0
	nextbundle
		cubemap $renormalize
		tcgen vertexToEye
	nextbundle
		cubemap env/watercolor
	nextbundle
		cubemap env/tankcountrywater
/*
// do this only if the shader is not in world coordinates or it has vertex deformation
	nextbundle
		cubemap env/watercolor
		tcgen tbn_x
	nextbundle
		cubemap env/tankcountrywater
		tcgen tbn_y
	nextbundle
		cubemap $renormalize
		tcgen tbn_z
*/

		atiFragmentShader
		{
			//*****************************************************************************
			// phase 0

			//-------------------------------------
			// routing section

			r0 = tex(tc0);	// r0 = bumpmap surface normal
			r1 = tex(tc1);	// r1 = normalized eye-to-point direction vector in world space
/*
// do this only if the shader is not in world coordinates or it has vertex deformation
			r2 = copy(tc2);	// r2 = Tx,Bx,Nx
			r3 = copy(tc3);	// r3 = Ty,By,Ny
			r4 = copy(tc4);	// r4 = Tz,Bz,Nz
*/

			//-------------------------------------
			// operation section
			// need to calculate lookup vectors for the reflection cube map and the diffuse cube map in surface-local space
			// The diffuse cubemap vector is merely the surface normal from the bumpmap (ie, r0) rotated into world space
			// The specular vector is the world space eye vector reflected around the world space normal vector.
			// E + 2 (((E . N) N) / (N . N) - E) = 2 ((E . N) / (N . N)) N - E = (2 (E . N) N - (N . N) E) / N . N

// do this only if the shader is in world coordinates and has no vertex deformation
			// reflect eye vector in world space
			r3 = dot3(r1 * 2 - 1, r0 * 2 - 1);	// r3 = E . N
			r3 = mul(r3, r0 * 2 - 1);			// r3 = (E . N) N
			r3 = sub(r3 * 2, r1 * 2 - 1);		// r3 = 2 (E . N) N - E = reflection vector

/*
// do this only if the shader is not in world coordinates or it has vertex deformation
			// rotate per-pixel normal into world space
			r2.r = dot3(r0 * 2 - 1, r2);
			r2.g = dot3(r0 * 2 - 1, r3);
			r2.b = dot3(r0 * 2 - 1, r4);	// r2 = N

			// reflect eye vector in world space assuming N can be unnormalized
			// N can only be unnormalized if the TBN frame is different for 2 or more vertices of a triangle
			r3 = dot3(r2, r1 * 2 - 1);		// r3 = E . N
			r3 = mul(r3, r2);				// r3 = (E . N) N
			r0 = dot3(r2, r2);				// r0 = N . N
			r0 = mul(r0, r1 * 2 - 1);		// r0 = (N . N) E
			r3 = sub(r3 * 2, r0);			// r3 = 2 (E . N) N - (N . N) E = reflection vector
*/

			//*****************************************************************************
			// phase 1

			//-------------------------------------
			// routing section

			r2 = tex(r2);	// r2 = diffuse color
			r3 = tex(r3);	// r3 = specular color + fresnel alpha

			//-------------------------------------
			// operation section
			// need to store r0.rgba with the color and alpha

			r0 = lerp(r3.a, r3, r2);
			r0 = mul(r0, col0);
			r0.a = mov(col0.a);
		}
	}
}

textures/sfx/oldsewerwater
{
	qer_editorimage textures/sfx/damwater
	qer_trans .5
	surfaceparm trans
	surfaceparm nonsolid
	surfaceparm water
//	tessSize 128
//	deformvertexes wave 224 sin 0 4 0 .2
	sort water
	{
		map textures/sfx/damwater.jpg
		tcMod Scroll .05 0
		tcMod scale 4 4
		rgbGen exactVertex
	nextbundle
		map $lightmap
	}
	{
		map textures/sfx/damwateroverlay.jpg
		tcMod scroll -0.01 .01
		tcMod scale 2 2
		tcMod turb 1.03 0.2 1.03
		rgbGen exactVertex
		blendFunc add
	nextbundle
		map textures/sfx/damwateroverlay.jpg
		tcMod scroll 0.02 .02
		tcMod scale 4 4
		tcMod turb 0.01 0.2 0.03
	}
}

textures/sfx/pathfinder_pond
{
	qer_editorimage env/pathcolor_dn
	tessSize 512
	q3map_globaltexture
	surfaceparm trans
	surfaceparm nonsolid
	surfaceparm noshadow
	surfaceparm water
	sort water
	{
		requires GL_MAX_TEXTURE_UNITS_ARB < 4 || ! GL_NV_texture_shader
		map textures/sfx/damwater.jpg
		tcMod Scroll .05 0
		tcMod scale 4 4
		rgbGen exactVertex
	nextbundle
		map $lightmap
	}
	{
		requires GL_MAX_TEXTURE_UNITS_ARB < 4 || ! GL_NV_texture_shader
		map textures/sfx/damwateroverlay.jpg
		tcMod scroll -0.01 .01
		tcMod scale 2 2
		tcMod turb 1.03 0.2 1.03
		rgbGen exactVertex
		blendFunc add
	nextbundle
		map textures/sfx/damwateroverlay.jpg
		tcMod scroll 0.02 .02
		tcMod scale 4 4
		tcMod turb 0.01 0.2 0.03
	}
	{
		requires GL_MAX_TEXTURE_UNITS_ARB >= 4
		requires GL_NV_texture_shader
		requires GL_ARB_texture_cube_map
		requires GL_NV_register_combiners

		// img_width   img_height   world_width   world_height   wind_vel   wind_dir_x   wind_dir_y   wave_amplitude
		waterMap	64 64   37 37    76 1 0   .06
		rgbGen identitylighting
		tcgen vector ( .001953125 0 0 ) ( 0 .001953125 0 )
		tcmod scroll .07 0
	nextbundle
		cubemap $renormalize
		tcgen nv_dot_product_reflect_cube_map_eye_from_qs_1of3
		nvTexShader dot_product_cube_map_and_reflect_cube_map_eye_from_qs_1of3(expand tex0)
	nextbundle
		cubemap env/pathcolor
		tcgen nv_dot_product_reflect_cube_map_eye_from_qs_2of3
		nvTexShader dot_product_cube_map_and_reflect_cube_map_eye_from_qs_2of3(expand tex0)
	nextbundle
		cubemap env/pathpond
		tcgen nv_dot_product_reflect_cube_map_eye_from_qs_3of3
		nvTexShader dot_product_cube_map_and_reflect_cube_map_eye_from_qs_3of3(expand tex0)

		nvRegCombiners
		{
			{
				rgb
				{
					discard = tex2 * unsigned_invert(tex3.a);
					discard = tex3 * tex3.a;
					spare0 = sum();
				}
			}
			{
				rgb
				{
					spare0 = spare0 * col0;
				}
			}
			out.rgb = lerp(fog.a, spare0, fog);
			out.a = tex3.a;
		}
	}
}
//textures/ocean/ocean
//{
//	tessSize 256
//	deformVertexes wave 1600 sin 32 32 0 .25
//	deformVertexes syncNormal 0.25
//
//	//-------------------------------------------------------------------------
//	// first stage for 4-texture cards (ie, GeForce3+, Radeon 9700+)
//	// sun highlights on ripples are yellowish
//	{
//		requires GL_MAX_TEXTURE_UNITS_ARB >= 4
//		requires GL_ARB_texture_cube_map
//		requires GL_ARB_texture_env_combine
//		requires GL_ARB_texture_env_dot3
//
//		rgbGen identity
//
//		map heightToNormal textures/ocean/heightmap.jpg
//		tcMod scale .03125 .03125
//		tcMod scroll -.1125 .01125
//	nextbundle
//		map heightToNormal textures/ocean/heightmap.jpg
//		tcMod scale -.03125 -.03125
//		tcMod scroll .13625 -.0125
//		texEnvCombine
//		{
//			const = ( 0.5 0.5 0.5 0.5 )
//			rgb = INTERPOLATE_ARB(Cp, Ct, Ac)
//		}
//	nextbundle
//		cubemap $renormalize
//		tcGen sunHalfAngle
//		tcMod bumpmapFrame
//		texEnvCombine
//		{
//			rgb = DOT3_RGB_ARB(Cp, Ct)
//		}
//	nextbundle
//		map $whiteimage
//		texEnvCombine
//		{
//			const = ( .32 .36 .4 ) * identityLighting
//			rgb = MODULATE(Cp, Cc)
//		}
//	}
//
//	//-------------------------------------------------------------------------
//	// first stage for 3-texture cards (ie, Radeon up to 8500)
//	// sun highlights on ripples are white
//	{
//		requires GL_MAX_TEXTURE_UNITS_ARB == 3
//		requires GL_ARB_texture_cube_map
//		requires GL_ARB_texture_env_combine
//		requires GL_ARB_texture_env_dot3
//
//		rgbGen identity
//		alphaGen constLighting .37
//		blendFunc GL_SRC_ALPHA GL_ZERO
//		depthWrite
//
//		map heightToNormal textures/ocean/heightmap.jpg
//		tcMod scale .03125 .03125
//		tcMod scroll -.1125 .01125
//	nextbundle
//		map heightToNormal textures/ocean/heightmap.jpg
//		tcMod scale -.03125 -.03125
//		tcMod scroll .13625 -.0125
//		texEnvCombine
//		{
//			const = ( 0.5 0.5 0.5 0.5 )
//			rgb = INTERPOLATE_ARB(Cp, Ct, Ac)
//		}
//	nextbundle
//		cubemap $renormalize
//		tcGen sunHalfAngle
//		tcMod bumpmapFrame
//		texEnvCombine
//		{
//			rgb = DOT3_RGB_ARB(Cp, Ct)
//			alpha = REPLACE(Af)
//		}
//	}
//
//	//-------------------------------------------------------------------------
//	// last stage for 3-or-more texture cards (ie, GeForce3+, all Radeon)
//	// sun reflection and baseline water color combine to .6, with reflection being half as important
//	{
//		requires GL_MAX_TEXTURE_UNITS_ARB >= 3
//		requires GL_ARB_texture_cube_map
//		requires GL_ARB_texture_env_combine
//		requires GL_ARB_texture_env_dot3
//
//		map textures/ocean/oceancolor.jpg
//		rgbGen identity
//		alphaGen constLighting .3
//		blendFunc GL_SRC_ALPHA GL_ONE
//		tcMod scale .25 .25
//		tcMod scroll -1.0375 .0375
//	nextbundle
//		map textures/ocean/oceancolor.jpg
//		tcMod scale .25 .25
//		tcMod scroll -1 -.051
//	nextbundle
//		cubemap textures/ocean/stormyfogged
//		tcGen reflection
//		texEnvCombine
//		{
//			const = ( 1 1 1 .5 )
//			rgb = INTERPOLATE_ARB(Ct, Cp, Ac)
//			alpha = REPLACE(Af)
//		}
//	}
//
//	//-------------------------------------------------------------------------
//	// two stage fallback effect for 2-texture cards (ie, GeForce1 & 2 and GeForce4 MX)
//	// also used if the other extensions needed are missing
//	{
//		requires GL_MAX_TEXTURE_UNITS_ARB == 2 || ! GL_ARB_texture_env_combine || ! GL_ARB_texture_env_dot3 || ! GL_ARB_texture_cube_map
//
//		map textures/ocean/oceancolor.jpg
//		rgbGen constLighting ( .5 .5 .5 )
//		tcMod scale .25 .25
//		tcMod scroll -1.0375 .0375
//	nextbundle
//		map textures/ocean/oceancolor.jpg
//		tcMod scale .25 .25
//		tcMod scroll -1 -.051
//	}
//	{
//		requires GL_MAX_TEXTURE_UNITS_ARB == 2 || ! GL_ARB_texture_env_combine || ! GL_ARB_texture_env_dot3
//		requires GL_ARB_texture_cube_map
//
//		cubemap textures/ocean/stormyfogged
//		rgbGen constLighting ( .32 .36 .4 )
//		blendFunc add
//		tcGen reflection
//	}
//}

textures/sfx/pegasusnight_canal
{
	qer_editorimage env/watercolor_dn
	tessSize 512
	q3map_globaltexture
	surfaceparm trans
	surfaceparm nonsolid
	surfaceparm water
	surfaceparm nolightmap
	sort water
	{
		requires GL_MAX_TEXTURE_UNITS_ARB < 4 || ! GL_NV_texture_shader
		requires GL_ARB_texture_cube_map
		requires GL_ARB_texture_env_combine
		requires GL_ARB_texture_env_dot3

		// img_width   img_height   world_width   world_height   wind_vel   wind_dir_x   wind_dir_y   wave_amplitude
		waterMap	64 64   37 37    76 1 0   .07
		rgbGen identity
		tcgen vector ( .001953125 0 0 ) ( 0 .001953125 0 )
		tcmod scroll .1 0
		blendfunc GL_SRC_ALPHA GL_ZERO
	nextbundle
		cubemap $renormalize
		tcGen sunHalfAngle
		texEnvCombine
		{
			rgb = DOT3_RGBA_ARB(Cp, Ct)
		}
	}
	{
		requires GL_MAX_TEXTURE_UNITS_ARB < 4 || ! GL_NV_texture_shader
		requires GL_ARB_texture_cube_map
		requires GL_ARB_texture_env_combine
		requires GL_ARB_texture_env_dot3

		map $whiteimage
		alphaGen dot
		rgbGen constLighting ( 0 .05 .1 )
		blendfunc GL_ONE GL_SRC_ALPHA
		texEnvCombine
		{
			rgb = REPLACE(Cp)
			alpha = MODULATE(1-Ap,1-Ap)
		}
	nextbundle
		map $whiteimage
		texEnvCombine
		{
			const = ( .15 .2 .25 .2 ) * identityLighting
			rgb = INTERPOLATE_ARB(Cc, Cp, Ap)
			alpha = REPLACE(Ac)
		}
	}
	{
		requires GL_MAX_TEXTURE_UNITS_ARB >= 4
		requires GL_NV_texture_shader
		requires GL_ARB_texture_cube_map
		requires GL_NV_register_combiners

		// img_width   img_height   world_width   world_height   wind_vel   wind_dir_x   wind_dir_y   wave_amplitude
		waterMap	64 64   37 37    76 1 0   .06
		rgbGen vertex
		tcgen vector ( .001953125 0 0 ) ( 0 .001953125 0 )
		tcmod scroll .07 0
	nextbundle
		cubemap $renormalize
		tcgen nv_dot_product_reflect_cube_map_eye_from_qs_1of3
		nvTexShader dot_product_cube_map_and_reflect_cube_map_eye_from_qs_1of3(expand tex0)
	nextbundle
		cubemap env/watercolor
		tcgen nv_dot_product_reflect_cube_map_eye_from_qs_2of3
		nvTexShader dot_product_cube_map_and_reflect_cube_map_eye_from_qs_2of3(expand tex0)
	nextbundle
		cubemap env/pegasusnight128
		tcgen nv_dot_product_reflect_cube_map_eye_from_qs_3of3
		nvTexShader dot_product_cube_map_and_reflect_cube_map_eye_from_qs_3of3(expand tex0)

		nvRegCombiners
		{
			{
				rgb
				{
					discard = tex2 * unsigned_invert(tex3.a);
					discard = tex3 * tex3.a;
					spare0 = sum();
				}
			}
			{
				rgb
				{
					spare0 = spare0 * col0;
				}
			}
			out.rgb = lerp(fog.a, spare0, fog);
			out.a = tex3.a;
		}
	}
}

textures/sfx/pegasusday_canal
{
	qer_editorimage env/pegasusdaywatercolor_dn
	tessSize 512
	q3map_globaltexture
	surfaceparm trans
	surfaceparm nonsolid
	surfaceparm water
	surfaceparm nolightmap
	sort water
	{
		requires GL_MAX_TEXTURE_UNITS_ARB < 4 || ! GL_NV_texture_shader
		requires GL_ARB_texture_cube_map
		requires GL_ARB_texture_env_combine
		requires GL_ARB_texture_env_dot3

		// img_width   img_height   world_width   world_height   wind_vel   wind_dir_x   wind_dir_y   wave_amplitude
		//waterMap	64 64   37 37    76 1 0   .07
		waterMap	64 64   37 37    76 1 0   .01
		rgbGen identity
		tcgen vector ( .001953125 0 0 ) ( 0 .001953125 0 )
		tcmod scroll .1 0
		blendfunc GL_SRC_ALPHA GL_ZERO
	nextbundle
		cubemap $renormalize
		tcGen sunHalfAngle
		texEnvCombine
		{
			rgb = DOT3_RGBA_ARB(Cp, Ct)
		}
	}
	{
		requires GL_MAX_TEXTURE_UNITS_ARB < 4 || ! GL_NV_texture_shader
		requires GL_ARB_texture_cube_map
		requires GL_ARB_texture_env_combine
		requires GL_ARB_texture_env_dot3

		map $whiteimage
		alphaGen dot
		rgbGen constLighting ( 0 .05 .1 )
		blendfunc GL_ONE GL_SRC_ALPHA
		texEnvCombine
		{
			rgb = REPLACE(Cp)
			alpha = MODULATE(1-Ap,1-Ap)
		}
	nextbundle
		map $whiteimage
		texEnvCombine
		{
			const = ( .15 .2 .25 .2 ) * identityLighting
			rgb = INTERPOLATE_ARB(Cc, Cp, Ap)
			alpha = REPLACE(Ac)
		}
	}
	{
		requires GL_MAX_TEXTURE_UNITS_ARB >= 4
		requires GL_NV_texture_shader
		requires GL_ARB_texture_cube_map
		requires GL_NV_register_combiners

		// img_width   img_height   world_width   world_height   wind_vel   wind_dir_x   wind_dir_y   wave_amplitude
		waterMap	64 64   37 37    76 1 0   .06
		rgbGen vertex
		tcgen vector ( .001953125 0 0 ) ( 0 .001953125 0 )
		tcmod scroll .07 0
	nextbundle
		cubemap $renormalize
		tcgen nv_dot_product_reflect_cube_map_eye_from_qs_1of3
		nvTexShader dot_product_cube_map_and_reflect_cube_map_eye_from_qs_1of3(expand tex0)
	nextbundle
		cubemap env/pegasusdaywatercolor
		tcgen nv_dot_product_reflect_cube_map_eye_from_qs_2of3
		nvTexShader dot_product_cube_map_and_reflect_cube_map_eye_from_qs_2of3(expand tex0)
	nextbundle
		cubemap env/pegasusday128
		tcgen nv_dot_product_reflect_cube_map_eye_from_qs_3of3
		nvTexShader dot_product_cube_map_and_reflect_cube_map_eye_from_qs_3of3(expand tex0)

		nvRegCombiners
		{
			{
				rgb
				{
					discard = tex2 * unsigned_invert(tex3.a);
					discard = tex3 * tex3.a;
					spare0 = sum();
				}
			}
			{
				rgb
				{
					spare0 = spare0 * col0;
				}
			}
			out.rgb = lerp(fog.a, spare0, fog);
			out.a = tex3.a;
		}
	}
}

textures/sfx/pegasusnight_pond
{
	qer_editorimage env/watercolor_dn
	tessSize 512
	q3map_globaltexture
	surfaceparm trans
	surfaceparm nonsolid
	surfaceparm water
	surfaceparm nolightmap
	sort water
	{
		requires GL_MAX_TEXTURE_UNITS_ARB < 4 || ! GL_NV_texture_shader
		requires GL_ARB_texture_cube_map
		requires GL_ARB_texture_env_combine
		requires GL_ARB_texture_env_dot3

		// img_width   img_height   world_width   world_height   wind_vel   wind_dir_x   wind_dir_y   wave_amplitude
		waterMap	64 64   37 37    76 1 0   .07
		rgbGen identity
		tcgen vector ( .001953125 0 0 ) ( 0 .001953125 0 )
		tcmod scroll .1 0
		blendfunc GL_SRC_ALPHA GL_ZERO
	nextbundle
		cubemap $renormalize
		tcGen sunHalfAngle
		texEnvCombine
		{
			rgb = DOT3_RGBA_ARB(Cp, Ct)
		}
	}
	{
		requires GL_MAX_TEXTURE_UNITS_ARB < 4 || ! GL_NV_texture_shader
		requires GL_ARB_texture_cube_map
		requires GL_ARB_texture_env_combine
		requires GL_ARB_texture_env_dot3

		map $whiteimage
		alphaGen dot
		rgbGen constLighting ( 0 .05 .1 )
		blendfunc GL_ONE GL_SRC_ALPHA
		texEnvCombine
		{
			rgb = REPLACE(Cp)
			alpha = MODULATE(1-Ap,1-Ap)
		}
	nextbundle
		map $whiteimage
		texEnvCombine
		{
			const = ( .15 .2 .25 .2 ) * identityLighting
			rgb = INTERPOLATE_ARB(Cc, Cp, Ap)
			alpha = REPLACE(Ac)
		}
	}
	{
		requires GL_MAX_TEXTURE_UNITS_ARB >= 4
		requires GL_NV_texture_shader
		requires GL_ARB_texture_cube_map
		requires GL_NV_register_combiners

		// img_width   img_height   world_width   world_height   wind_vel   wind_dir_x   wind_dir_y   wave_amplitude
		waterMap	64 64   37 37    76 1 0   .06
		rgbGen vertex
		tcgen vector ( .001953125 0 0 ) ( 0 .001953125 0 )
		tcmod scroll .07 0
	nextbundle
		cubemap $renormalize
		tcgen nv_dot_product_reflect_cube_map_eye_from_qs_1of3
		nvTexShader dot_product_cube_map_and_reflect_cube_map_eye_from_qs_1of3(expand tex0)
	nextbundle
		cubemap env/watercolor
		tcgen nv_dot_product_reflect_cube_map_eye_from_qs_2of3
		nvTexShader dot_product_cube_map_and_reflect_cube_map_eye_from_qs_2of3(expand tex0)
	nextbundle
		cubemap env/pegasusnight128
		tcgen nv_dot_product_reflect_cube_map_eye_from_qs_3of3
		nvTexShader dot_product_cube_map_and_reflect_cube_map_eye_from_qs_3of3(expand tex0)

		nvRegCombiners
		{
			{
				rgb
				{
					discard = tex2 * unsigned_invert(tex3.a);
					discard = tex3 * tex3.a;
					spare0 = sum();
				}
			}
			{
				rgb
				{
					spare0 = spare0 * col0;
				}
			}
			out.rgb = lerp(fog.a, spare0, fog);
			out.a = tex3.a;
		}
	}
}

textures/sfx/pegasusday_pond
{
	qer_editorimage env/pegasusdaywatercolor_dn
	tessSize 512
	q3map_globaltexture
	surfaceparm trans
	surfaceparm nonsolid
	surfaceparm water
	surfaceparm nolightmap
	sort water
	{
		requires GL_MAX_TEXTURE_UNITS_ARB < 4 || ! GL_NV_texture_shader
		requires GL_ARB_texture_cube_map
		requires GL_ARB_texture_env_combine
		requires GL_ARB_texture_env_dot3

		// img_width   img_height   world_width   world_height   wind_vel   wind_dir_x   wind_dir_y   wave_amplitude
		waterMap	64 64   37 37    76 1 0   .07
		rgbGen identity
		tcgen vector ( .001953125 0 0 ) ( 0 .001953125 0 )
		tcmod scroll .1 0
		blendfunc GL_SRC_ALPHA GL_ZERO
	nextbundle
		cubemap $renormalize
		tcGen sunHalfAngle
		texEnvCombine
		{
			rgb = DOT3_RGBA_ARB(Cp, Ct)
		}
	}
	{
		requires GL_MAX_TEXTURE_UNITS_ARB < 4 || ! GL_NV_texture_shader
		requires GL_ARB_texture_cube_map
		requires GL_ARB_texture_env_combine
		requires GL_ARB_texture_env_dot3

		map $whiteimage
		alphaGen dot
		rgbGen constLighting ( 0 .05 .1 )
		blendfunc GL_ONE GL_SRC_ALPHA
		texEnvCombine
		{
			rgb = REPLACE(Cp)
			alpha = MODULATE(1-Ap,1-Ap)
		}
	nextbundle
		map $whiteimage
		texEnvCombine
		{
			const = ( .15 .2 .25 .2 ) * identityLighting
			rgb = INTERPOLATE_ARB(Cc, Cp, Ap)
			alpha = REPLACE(Ac)
		}
	}
	{
		requires GL_MAX_TEXTURE_UNITS_ARB >= 4
		requires GL_NV_texture_shader
		requires GL_ARB_texture_cube_map
		requires GL_NV_register_combiners

		// img_width   img_height   world_width   world_height   wind_vel   wind_dir_x   wind_dir_y   wave_amplitude
		waterMap	64 64   37 37    76 1 0   .06
		rgbGen vertex
		tcgen vector ( .001953125 0 0 ) ( 0 .001953125 0 )
		tcmod scroll .07 0
	nextbundle
		cubemap $renormalize
		tcgen nv_dot_product_reflect_cube_map_eye_from_qs_1of3
		nvTexShader dot_product_cube_map_and_reflect_cube_map_eye_from_qs_1of3(expand tex0)
	nextbundle
		cubemap env/pegasusdaywatercolor
		tcgen nv_dot_product_reflect_cube_map_eye_from_qs_2of3
		nvTexShader dot_product_cube_map_and_reflect_cube_map_eye_from_qs_2of3(expand tex0)
	nextbundle
		cubemap env/pegasusday128
		tcgen nv_dot_product_reflect_cube_map_eye_from_qs_3of3
		nvTexShader dot_product_cube_map_and_reflect_cube_map_eye_from_qs_3of3(expand tex0)

		nvRegCombiners
		{
			{
				rgb
				{
					discard = tex2 * unsigned_invert(tex3.a);
					discard = tex3 * tex3.a;
					spare0 = sum();
				}
			}
			{
				rgb
				{
					spare0 = spare0 * col0;
				}
			}
			out.rgb = lerp(fog.a, spare0, fog);
			out.a = tex3.a;
		}
	}
}

textures/sfx/ship_ocean
{
	qer_editorimage env/shipwatercolor_dn
	tessSize 512
	deformVertexes wave 1600 sin 16 16 0 .25
	q3map_globaltexture
	surfaceparm trans
	surfaceparm nonsolid
	surfaceparm water
	surfaceparm nolightmap
	sort ocean
	{
		requires GL_MAX_TEXTURE_UNITS_ARB < 4 || ! GL_NV_texture_shader
		requires GL_ARB_texture_cube_map
		requires GL_ARB_texture_env_combine
		requires GL_ARB_texture_env_dot3

		// img_width   img_height   world_width   world_height   wind_vel   wind_dir_x   wind_dir_y   wave_amplitude
		waterMap	64 64   37 37    76 1 0   .07
		rgbGen identity
		tcgen vector ( .001953125 0 0 ) ( 0 .001953125 0 )
		tcmod scroll .1 0
		blendfunc GL_SRC_ALPHA GL_ZERO
	nextbundle
		cubemap $renormalize
		tcGen sunHalfAngle
		texEnvCombine
		{
			rgb = DOT3_RGBA_ARB(Cp, Ct)
		}
	}
	{
		requires GL_MAX_TEXTURE_UNITS_ARB < 4 || ! GL_NV_texture_shader
		requires GL_ARB_texture_cube_map
		requires GL_ARB_texture_env_combine
		requires GL_ARB_texture_env_dot3

		map $whiteimage
		alphaGen dot
		rgbGen constLighting ( 0 .05 .1 )
		blendfunc GL_ONE GL_SRC_ALPHA
		texEnvCombine
		{
			rgb = REPLACE(Cp)
			alpha = MODULATE(1-Ap,1-Ap)
		}
	nextbundle
		map $whiteimage
		texEnvCombine
		{
			const = ( .15 .2 .25 .2 ) * identityLighting
			rgb = INTERPOLATE_ARB(Cc, Cp, Ap)
			alpha = REPLACE(Ac)
		}
	}
	{
		requires GL_MAX_TEXTURE_UNITS_ARB >= 4
		requires GL_NV_texture_shader
		requires GL_ARB_texture_cube_map
		requires GL_NV_register_combiners

		// img_width   img_height   world_width   world_height   wind_vel   wind_dir_x   wind_dir_y   wave_amplitude
		//waterMap	64 64   37 37    76 1 0   .06
		waterMap	64 64   37 37    76 1 0   .06
		rgbGen vertex
		tcgen vector ( .001953125 0 0 ) ( 0 .001953125 0 )
		tcmod scroll .07 0
	nextbundle
		cubemap $renormalize
		tcgen nv_dot_product_reflect_cube_map_eye_from_qs_1of3
		nvTexShader dot_product_cube_map_and_reflect_cube_map_eye_from_qs_1of3(expand tex0)
	nextbundle
		cubemap env/shipwatercolor
		tcgen nv_dot_product_reflect_cube_map_eye_from_qs_2of3
		nvTexShader dot_product_cube_map_and_reflect_cube_map_eye_from_qs_2of3(expand tex0)
	nextbundle
		cubemap env/ship128
		tcgen nv_dot_product_reflect_cube_map_eye_from_qs_3of3
		nvTexShader dot_product_cube_map_and_reflect_cube_map_eye_from_qs_3of3(expand tex0)

		nvRegCombiners
		{
			{
				rgb
				{
					discard = tex2 * unsigned_invert(tex3.a);
					discard = tex3 * tex3.a;
					spare0 = sum();
				}
			}
			{
				rgb
				{
					spare0 = spare0 * col0;
				}
			}
			out.rgb = lerp(fog.a, spare0, fog);
			//out.rgb = lerp(fog.a, tex3, fog);	//show reflection only
			//out.rgb = lerp(fog.a, tex2, fog);	//show water color only
			out.a = tex3.a;
		}
	}
}



textures/sfx/mp_ship_ocean
{
	qer_editorimage env/watercolor_dn
	tessSize 512
	deformVertexes wave 1600 sin 16 16 0 .25
	q3map_globaltexture
	surfaceparm trans
	surfaceparm nonsolid
	surfaceparm water
	surfaceparm nolightmap
	sort water
	{
		requires GL_MAX_TEXTURE_UNITS_ARB < 4 || ! GL_NV_texture_shader
		requires GL_ARB_texture_cube_map
		requires GL_ARB_texture_env_combine
		requires GL_ARB_texture_env_dot3

		// img_width   img_height   world_width   world_height   wind_vel   wind_dir_x   wind_dir_y   wave_amplitude
		waterMap	64 64   37 37    76 1 0   .07
		rgbGen identity
		tcgen vector ( .001953125 0 0 ) ( 0 .001953125 0 )
		tcmod scroll .1 0
		blendfunc GL_SRC_ALPHA GL_ZERO
	nextbundle
		cubemap $renormalize
		tcGen sunHalfAngle
		texEnvCombine
		{
			rgb = DOT3_RGBA_ARB(Cp, Ct)
		}
	}
	{
		requires GL_MAX_TEXTURE_UNITS_ARB < 4 || ! GL_NV_texture_shader
		requires GL_ARB_texture_cube_map
		requires GL_ARB_texture_env_combine
		requires GL_ARB_texture_env_dot3

		map $whiteimage
		alphaGen dot
		rgbGen constLighting ( 0 .05 .1 )
		blendfunc GL_ONE GL_SRC_ALPHA
		texEnvCombine
		{
			rgb = REPLACE(Cp)
			alpha = MODULATE(1-Ap,1-Ap)
		}
	nextbundle
		map $whiteimage
		texEnvCombine
		{
			const = ( .15 .2 .25 .2 ) * identityLighting
			rgb = INTERPOLATE_ARB(Cc, Cp, Ap)
			alpha = REPLACE(Ac)
		}
	}
	{
		requires GL_MAX_TEXTURE_UNITS_ARB >= 4
		requires GL_NV_texture_shader
		requires GL_ARB_texture_cube_map
		requires GL_NV_register_combiners

		// img_width   img_height   world_width   world_height   wind_vel   wind_dir_x   wind_dir_y   wave_amplitude
		//waterMap	64 64   37 37    76 1 0   .06
		waterMap	64 64   37 37    76 1 0   .06
		rgbGen vertex
		tcgen vector ( .001953125 0 0 ) ( 0 .001953125 0 )
		tcmod scroll .07 0
	nextbundle
		cubemap $renormalize
		tcgen nv_dot_product_reflect_cube_map_eye_from_qs_1of3
		nvTexShader dot_product_cube_map_and_reflect_cube_map_eye_from_qs_1of3(expand tex0)
	nextbundle
		cubemap env/watercolor
		tcgen nv_dot_product_reflect_cube_map_eye_from_qs_2of3
		nvTexShader dot_product_cube_map_and_reflect_cube_map_eye_from_qs_2of3(expand tex0)
	nextbundle
		cubemap env/mp_ship128
		tcgen nv_dot_product_reflect_cube_map_eye_from_qs_3of3
		nvTexShader dot_product_cube_map_and_reflect_cube_map_eye_from_qs_3of3(expand tex0)

		nvRegCombiners
		{
			{
				rgb
				{
					discard = tex2 * unsigned_invert(tex3.a);
					discard = tex3 * tex3.a;
					spare0 = sum();
				}
			}
			{
				rgb
				{
					spare0 = spare0 * col0;
				}
			}
			out.rgb = lerp(fog.a, spare0, fog);
			//out.rgb = lerp(fog.a, tex3, fog);	//show reflection only
			//out.rgb = lerp(fog.a, tex2, fog);	//show water color only
			out.a = tex3.a;
		}
	}
}

textures/sfx/powcamp_pond
{
	qer_editorimage env/powcampcolor_dn
	tessSize 512
	q3map_globaltexture
	surfaceparm trans
	surfaceparm nonsolid
	surfaceparm water
	sort water
	{
		requires GL_MAX_TEXTURE_UNITS_ARB < 4 || ! GL_NV_texture_shader || ! GL_NV_register_combiners
		requires GL_MAX_TEXTURE_UNITS_ARB < 4 || ! GL_ATI_fragment_shader		
		map textures/sfx/damwater.jpg
		tcMod Scroll .05 0
		tcMod scale 4 4
		rgbGen exactVertex
	nextbundle
		map $lightmap
	}
	{
		requires GL_MAX_TEXTURE_UNITS_ARB < 4 || ! GL_NV_texture_shader || ! GL_NV_register_combiners
		requires GL_MAX_TEXTURE_UNITS_ARB < 4 || ! GL_ATI_fragment_shader
		map textures/sfx/damwateroverlay.jpg
		tcMod scroll -0.01 .01
		tcMod scale 2 2
		tcMod turb 1.03 0.2 1.03
		rgbGen exactVertex
		blendFunc add
	nextbundle
		map textures/sfx/damwateroverlay.jpg
		tcMod scroll 0.02 .02
		tcMod scale 4 4
		tcMod turb 0.01 0.2 0.03
	}
	{
		requires GL_MAX_TEXTURE_UNITS_ARB >= 4
		requires GL_NV_texture_shader
		requires GL_ARB_texture_cube_map
		requires GL_NV_register_combiners

		// img_width   img_height   world_width   world_height   wind_vel   wind_dir_x   wind_dir_y   wave_amplitude
		waterMap	64 64   37 37    76 1 0   .02
		rgbGen identitylighting
		alphaGen vertex
		blendFunc blend
		tcgen vector ( .001953125 0 0 ) ( 0 .001953125 0 )
		tcmod scroll .07 0
	nextbundle
		cubemap $renormalize
		tcgen nv_dot_product_reflect_cube_map_eye_from_qs_1of3
		nvTexShader dot_product_cube_map_and_reflect_cube_map_eye_from_qs_1of3(expand tex0)
	nextbundle
		cubemap env/powcampcolor
		tcgen nv_dot_product_reflect_cube_map_eye_from_qs_2of3
		nvTexShader dot_product_cube_map_and_reflect_cube_map_eye_from_qs_2of3(expand tex0)
	nextbundle
		cubemap env/powcamppond
		tcgen nv_dot_product_reflect_cube_map_eye_from_qs_3of3
		nvTexShader dot_product_cube_map_and_reflect_cube_map_eye_from_qs_3of3(expand tex0)

		nvRegCombiners
		{
			{
				rgb
				{
					discard = tex2 * unsigned_invert(tex3.a);
					discard = tex3 * tex3.a;
					spare0 = sum();
				}
			}
			{
				rgb
				{
					spare0 = spare0 * col0;
				}
			}
			out.rgb = lerp(fog.a, spare0, fog);
			out.a = col0.a;
		}
	}
	{
		requires ! GL_NV_texture_shader || ! GL_NV_register_combiners
		requires GL_MAX_TEXTURE_UNITS_ARB >= 4
		requires GL_ATI_fragment_shader
		requires GL_ARB_texture_cube_map

		// img_width   img_height   world_width   world_height   wind_vel   wind_dir_x   wind_dir_y   wave_amplitude
		waterMap	64 64   37 37    76 1 0   .02
		rgbGen vertex
		alphaGen vertex
		blendFunc blend
		tcgen vector ( .001953125 0 0 ) ( 0 .001953125 0 )
		tcmod scroll .07 0
	nextbundle
		cubemap $renormalize
		tcgen vertexToEye
	nextbundle
		cubemap env/powcampcolor
	nextbundle
		cubemap env/powcamppond
/*
// do this only if the shader is not in world coordinates or it has vertex deformation
	nextbundle
		cubemap env/sewercolor
		tcgen tbn_x
	nextbundle
		cubemap env/sewerpuddle
		tcgen tbn_y
	nextbundle
		cubemap $renormalize
		tcgen tbn_z
*/

		atiFragmentShader
		{
			//*****************************************************************************
			// phase 0

			//-------------------------------------
			// routing section

			r0 = tex(tc0);	// r0 = bumpmap surface normal
			r1 = tex(tc1);	// r1 = normalized eye-to-point direction vector in world space
/*
// do this only if the shader is not in world coordinates or it has vertex deformation
			r2 = copy(tc2);	// r2 = Tx,Bx,Nx
			r3 = copy(tc3);	// r3 = Ty,By,Ny
			r4 = copy(tc4);	// r4 = Tz,Bz,Nz
*/

			//-------------------------------------
			// operation section
			// need to calculate lookup vectors for the reflection cube map and the diffuse cube map in surface-local space
			// The diffuse cubemap vector is merely the surface normal from the bumpmap (ie, r0) rotated into world space
			// The specular vector is the world space eye vector reflected around the world space normal vector.
			// E + 2 (((E . N) N) / (N . N) - E) = 2 ((E . N) / (N . N)) N - E = (2 (E . N) N - (N . N) E) / N . N

// do this only if the shader is in world coordinates and has no vertex deformation
			// reflect eye vector in world space
			r3 = dot3(r1 * 2 - 1, r0 * 2 - 1);	// r3 = E . N
			r3 = mul(r3, r0 * 2 - 1);			// r3 = (E . N) N
			r3 = sub(r3 * 2, r1 * 2 - 1);		// r3 = 2 (E . N) N - E = reflection vector

/*
// do this only if the shader is not in world coordinates or it has vertex deformation
			// rotate per-pixel normal into world space
			r2.r = dot3(r0 * 2 - 1, r2);
			r2.g = dot3(r0 * 2 - 1, r3);
			r2.b = dot3(r0 * 2 - 1, r4);	// r2 = N

			// reflect eye vector in world space assuming N can be unnormalized
			// N can only be unnormalized if the TBN frame is different for 2 or more vertices of a triangle
			r3 = dot3(r2, r1 * 2 - 1);		// r3 = E . N
			r3 = mul(r3, r2);				// r3 = (E . N) N
			r0 = dot3(r2, r2);				// r0 = N . N
			r0 = mul(r0, r1 * 2 - 1);		// r0 = (N . N) E
			r3 = sub(r3 * 2, r0);			// r3 = 2 (E . N) N - (N . N) E = reflection vector
*/

			//*****************************************************************************
			// phase 1

			//-------------------------------------
			// routing section

			r2 = tex(r2);	// r2 = diffuse color
			r3 = tex(r3);	// r3 = specular color + fresnel alpha

			//-------------------------------------
			// operation section
			// need to store r0.rgba with the color and alpha

			r0 = lerp(r3.a, r3, r2);
			r0 = mul(r0, col0);
			r0.a = mov(col0.a);
		}
	}
}