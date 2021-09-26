#define HALF_TAP_COUNT 8

#include "lib/globals.hlsl"

sampler skySampler;

struct VertexInput
{
	float4 position : POSITION;
	float2 texCoords : TEXCOORD0;
};


struct PixelInput
{
	float4 position : POSITION;
	float2 texCoords : TEXCOORD0;
	float3 skyCoords : TEXCOORD1;
};


struct PixelOutput
{
	float4 color : COLOR;
};


#include "lib/transform.hlsl"


PixelInput vs_main( const VertexInput vertex )
{
	PixelInput pixel;

	pixel.position = Transform_ObjectToClip( vertex.position );
	pixel.texCoords = vertex.texCoords;
	pixel.skyCoords = nearPlaneOrg + (vertex.texCoords.x - 0.5) * nearPlaneDx + (vertex.texCoords.y - 0.5) * nearPlaneDy;

	return pixel;
}


PixelOutput ps_main( const PixelInput pixel )
{
	PixelOutput fragment;
	half4 skyPixel;
	half4 blurredPixel;
	half bleedFactor;

	blurredPixel = tex2D( colorMapSampler, pixel.texCoords );
	skyPixel = texCUBE( skySampler, pixel.skyCoords );

	bleedFactor = saturate( blurredPixel.a * 2 );
	fragment.color.a = bleedFactor * glowApply[GLOW_APPLY_SKY_BLEED_INTENSITY];
	fragment.color.rgb = skyPixel.rgb * fragment.color.a + blurredPixel.rgb * glowApply[GLOW_APPLY_BLOOM_INTENSITY];

	return fragment;
}
