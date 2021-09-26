#include "globals.hlsl"

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


PixelOutput ps_main( const PixelInput pixel )
{
	PixelOutput fragment;

	fragment.color = ColoredTexturedDiffuse( pixel.color, pixel.texCoords );
	fragment.color.rgb = lerp( fragment.color.rgb, materialColor.rgb, materialColor.a );

	Fog_PixelCalc( pixel, fragment );

	return fragment;
}
