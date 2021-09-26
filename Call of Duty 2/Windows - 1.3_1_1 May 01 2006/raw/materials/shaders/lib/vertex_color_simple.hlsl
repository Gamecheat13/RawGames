#include "globals.hlsl"
#define OFFSET_VERTEX_TO_EYE_DISTANCE 10

#ifdef PIXEL_FOG
#define	FOGVAR texCoords.z
typedef float3 tcType;
#else
#define	FOGVAR fog
typedef float2 tcType;
#endif


struct VertexInput
{
	float4 position : POSITION;
	float4 color : COLOR;
	float2 texCoords : TEXCOORD0;
};


struct PixelInput
{
	float4 position : POSITION;
	float4 color : COLOR;
	tcType texCoords : TEXCOORD0;
#if USE_FOG && !defined( PIXEL_FOG )
	float fog : FOG_SEMANTIC;
#endif
};


struct PixelOutput
{
	float4 color : COLOR;
};


#include "transform.hlsl"
#include "fog.hlsl"
#include "shade.hlsl"
#include "texscroll.hlsl"

PixelInput vs_main( const VertexInput vertex )
{
	PixelInput pixel;

	pixel = (PixelInput)0;
	pixel.position = Transform_ObjectToClip( vertex.position );
#ifdef OFFSET_VERTEX_TO_EYE
	pixel.position.z -= OFFSET_VERTEX_TO_EYE_DISTANCE;
	float old_w = pixel.position.w;
	pixel.position.w -= OFFSET_VERTEX_TO_EYE_DISTANCE;
	if (old_w != 0)
	{
		pixel.position.x *= pixel.position.w/old_w;
		pixel.position.y *= pixel.position.w/old_w;
	}
#endif
	pixel.texCoords.xy = TexScroll( vertex.texCoords );
	pixel.color = vertex.color;

	Fog_VertexCalc( vertex, pixel );

	return pixel;
}


PixelOutput ps_main( const PixelInput pixel )
{
	PixelOutput fragment;

	fragment.color = ColoredTexturedDiffuse( pixel.color, pixel.texCoords.xy );

	Fog_PixelCalc( pixel, fragment );

	return fragment;
}
