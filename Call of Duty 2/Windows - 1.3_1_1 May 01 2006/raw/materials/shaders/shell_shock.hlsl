#include "lib/globals.hlsl"

#define USE_DETAIL 0

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
	float2 texCoords : TEXCOORD0;
};


struct PixelOutput
{
	float4 color : COLOR;
};


#include "lib/transform.hlsl"
#include "lib/shade.hlsl"


PixelInput vs_main( const VertexInput vertex )
{
	PixelInput pixel;

	pixel.position = Transform_ObjectToClip( vertex.position );
	pixel.texCoords = vertex.texCoords;
	pixel.color = vertex.color;

	return pixel;
}


PixelOutput ps_main( const PixelInput pixel )
{
	PixelOutput	fragment;
	half4		diffuseColor;
	half		luminance;

	diffuseColor = ColoredTexturedDiffuse( pixel.color, pixel.texCoords );
	luminance = dot( diffuseColor.rgb, colorIntensityScale );
	fragment.color.rgb = lerp( diffuseColor.rgb, luminance, 0.25 );
	fragment.color.a   = pixel.color.a;

	return fragment;
}
