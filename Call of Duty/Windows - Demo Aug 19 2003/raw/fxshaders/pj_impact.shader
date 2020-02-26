gfx/impact/flesh_hit1
{
	entityMergable
    {
        map gfx/impact/flesh_hit1
        blendfunc blend
        rgbGen vertex 
    }
}

gfx/impact/flesh_hit2
{
	entityMergable
    {
        map gfx/impact/flesh_hit2
        blendfunc blend
        rgbGen vertex
    }
}

gfx/impact/flesh_hitgib
{
	entityMergable
    {
       map gfx/impact/flesh_hitgib
        blendfunc blend
        rgbGen vertex
    }
}

gfx/impact/sparkflash
{
	entityMergable
	sort	additive
    {
        map gfx/impact/sparkflash  
        blendFunc GL_ONE GL_ONE
        rgbGen vertex
    }
}

gfx/impact/metal_spark1
{
	entityMergable
	sort	additive
    {
        map gfx/impact/metal_spark1  
        blendFunc GL_ONE GL_ONE
        rgbGen vertex
    }
}

gfx/impact/sparktrail
{
	entityMergable
	sort	additive
    {
        map gfx/impact/sparktrail  
        blendFunc GL_ONE GL_ONE
        rgbGen vertex
    }
}

gfx/impact/stone_piece1
{
	entityMergable
    {
        map gfx/impact/stone_piece1
        blendfunc blend
        rgbGen vertex
    }
}

gfx/impact/dusty
{
	entityMergable
    {
        map gfx/impact/dusty
        //blendfunc blend
	alphaFunc GE128
        rgbGen vertex
    }
}

gfx/impact/dusty_puff
{
	entityMergable
    {
        map gfx/impact/dusty_puff
        blendfunc blend
        rgbGen vertex
    }
}

gfx/impact/stone_piece2
{
	entityMergable
    {
        map gfx/impact/stone_piece2
        blendfunc blend
        rgbGen vertex
    }
}

gfx/impact/dustlayer1
{
	entityMergable
    {
        map gfx/impact/dustlayer1
        blendfunc blend
        rgbGen vertex
    }
}

gfx/impact/gravelpuff
{
	entityMergable
    {
        map gfx/impact/gravelpuff
        blendfunc blend
        rgbGen vertex
    }
}

gfx/impact/snowpuff
{
	entityMergable
    {
        map gfx/impact/snowpuff
        blendfunc blend
        rgbGen vertex
    }
}

gfx/impact/snow1
{
	entityMergable
    {
        map gfx/impact/snow1
        blendfunc blend
        rgbGen vertex
    }
}

/////////////////////////////////////////
//                                     //
//    IMPACT DECALS                    //
/////////////////////////////////////////

gfx/impact/bullethole1
{
	entityMergable
	surfaceparm nonsolid
	surfaceparm trans
	polygonOffset2
    {
        map gfx/impact/bullethole1
        blendfunc blend
        rgbGen vertex
    nextbundle
		map $lightmap
    }
    {
		perlight
        map gfx/impact/bullethole1
        blendfunc GL_SRC_ALPHA GL_ONE
        rgbGen vertex
    nextbundle
		map $dlight
    }
}

gfx/impact/bullethole2
{
	entityMergable
	surfaceparm nonsolid
	surfaceparm trans
	polygonOffset2
    {
        map gfx/impact/bullethole2
        blendfunc blend
        rgbGen vertex
    nextbundle
		map $lightmap
    }
    {
		perlight
        map gfx/impact/bullethole2
        blendfunc GL_SRC_ALPHA GL_ONE
        rgbGen vertex
    nextbundle
		map $dlight
    }
}

gfx/impact/bullethit_wood1
{
	entityMergable
	surfaceparm nonsolid
	surfaceparm trans
	polygonOffset2
    {
        map gfx/impact/bullethit_wood1
        blendfunc blend
        rgbGen vertex
    nextbundle
		map $lightmap
    }
    {
		perlight
        map gfx/impact/bullethit_wood1
        blendfunc GL_SRC_ALPHA GL_ONE
        rgbGen vertex
    nextbundle
		map $dlight
    }
}

gfx/impact/bullethit_wood2
{
	entityMergable
	surfaceparm nonsolid
	surfaceparm trans
	polygonOffset2
    {
        map gfx/impact/bullethit_wood2
        blendfunc blend
        rgbGen vertex
    nextbundle
		map $lightmap
    }
    {
		perlight
        map gfx/impact/bullethit_wood2
        blendfunc GL_SRC_ALPHA GL_ONE
        rgbGen vertex
    nextbundle
		map $dlight
    }
}

gfx/impact/bullethit_plaster2
{
	entityMergable
	surfaceparm nonsolid
	surfaceparm trans
	polygonOffset2
    {
        map gfx/impact/bullethit_plaster2
        blendfunc blend
        rgbGen vertex
    nextbundle
		map $lightmap
    }
    {
		perlight
        map gfx/impact/bullethit_plaster2
        blendfunc GL_SRC_ALPHA GL_ONE
        rgbGen vertex
    nextbundle
		map $dlight
    }
}

gfx/impact/bullethit_plaster
{
	entityMergable
	surfaceparm nonsolid
	surfaceparm trans
	polygonOffset2
    {
        map gfx/impact/bullethit_plaster
        blendfunc blend
        rgbGen vertex
    nextbundle
		map $lightmap
    }
    {
		perlight
        map gfx/impact/bullethit_plaster
        blendfunc GL_SRC_ALPHA GL_ONE
        rgbGen vertex
    nextbundle
		map $dlight
    }
}

gfx/impact/bullethit_sand
{
	entityMergable
	surfaceparm nonsolid
	surfaceparm trans
	polygonOffset2
    {
        map gfx/impact/bullethit_sand
        blendfunc blend
        rgbGen vertex
    nextbundle
		map $lightmap
    }
    {
		perlight
        map gfx/impact/bullethit_sand
        blendfunc GL_SRC_ALPHA GL_ONE
        rgbGen vertex
    nextbundle
		map $dlight
    }
}

gfx/impact/bullethit_snow
{
	entityMergable
	surfaceparm nonsolid
	surfaceparm trans
	polygonOffset2
    {
        map gfx/impact/bullethit_snow
        blendfunc blend
        rgbGen vertex
    nextbundle
		map $lightmap
    }
    {
		perlight
        map gfx/impact/bullethit_snow
        blendfunc GL_SRC_ALPHA GL_ONE
        rgbGen vertex
    nextbundle
		map $dlight
    }
}

gfx/impact/bullethit_glass
{
	entityMergable
	surfaceparm nonsolid
	surfaceparm trans
	polygonOffset2
    {
        map gfx/impact/bullethit_glass
        blendfunc blend
        rgbGen vertex
    nextbundle
		map $lightmap
    }
    {
		perlight
        map gfx/impact/bullethit_glass
        blendfunc GL_SRC_ALPHA GL_ONE
        rgbGen vertex
    nextbundle
		map $dlight
    }
}

gfx/impact/bullethit_glass2
{
	entityMergable
	surfaceparm nonsolid
	surfaceparm trans
	polygonOffset2
    {
        map gfx/impact/bullethit_glass2
        blendfunc blend
        rgbGen vertex
    nextbundle
		map $lightmap
    }
    {
		perlight
        map gfx/impact/bullethit_glass2
        blendfunc GL_SRC_ALPHA GL_ONE
        rgbGen vertex
    nextbundle
		map $dlight
    }
}

gfx/impact/wood_splinter1
{
	entityMergable
    {
        map gfx/impact/wood_splinter1
        blendfunc blend
        rgbGen vertex
    }
}

gfx/impact/wood_splinter2
{
	entityMergable
    {
        map gfx/impact/wood_splinter2
        blendfunc blend
        rgbGen vertex
    }
}

gfx/impact/woodpuff
{
	entityMergable
    {
        map gfx/impact/woodpuff
        blendfunc blend
        rgbGen vertex
    }
}