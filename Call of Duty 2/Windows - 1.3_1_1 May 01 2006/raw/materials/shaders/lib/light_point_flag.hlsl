#include "globals.hlsl"

#define FOGVAR fog


struct VertexInput
{
	float4 position : POSITION;
	float4 color : COLOR;
	float2 texCoords : TEXCOORD0;
	float3 tangent : TEXCOORD1;
	float3 binormal : TEXCOORD2;
	float3 normal : NORMAL;
};


struct PixelInput
{
	float4 position : POSITION;
	float4 color : COLOR;
	float2 texCoords : TEXCOORD0;
	float3 tangent : TEXCOORD1;
	float3 binormal : TEXCOORD2;
	float3 normal : TEXCOORD3;
	float3 lightDelta : TEXCOORD4;
	float3 lightDir : TEXCOORD5;
#if USE_SPECULAR
	float3 halfAngle : TEXCOORD6;
#endif
#if USE_FOG
	float fog : FOG_SEMANTIC;
#endif
};


struct PixelOutput
{
	float4 color : COLOR;
};


#include "transform.hlsl"
#include "fog.hlsl"
#include "attenuation.hlsl"
#include "normalmap.hlsl"
#include "shade.hlsl"
#include "phong.hlsl"
#include "flag.hlsl"


PixelInput vs_main( const VertexInput vertex )
{
	VertexInput flappedVertex = vertex;
	flappedVertex = Flap( vertex );

	PixelInput	pixel;

	pixel = (PixelInput)0;
	pixel.position = Transform_ObjectToClip( flappedVertex.position );
	pixel.color = flappedVertex.color;
	pixel.texCoords = flappedVertex.texCoords;
	pixel.lightDelta = (lightPosition0.xyz - Transform_ObjectToWorld( flappedVertex.position ).xyz) / lightPosition0.w;

	Normal_VertexSetup( flappedVertex, worldMatrix, pixel );
	Phong_VertexSetup( flappedVertex, pixel.lightDelta, pixel );
	Fog_VertexCalc( flappedVertex, pixel );

	return pixel;
}


PixelOutput ps_main( const PixelInput pixel )
{
	PixelOutput	fragment;
	half4		diffuseColor;
	half3		worldNormal;
	half3		unattenuatedColor;

	diffuseColor = ColoredTexturedDiffuse( pixel.color, pixel.texCoords );
	worldNormal = Normal_GetWorldSpace( pixel );
	unattenuatedColor = Phong_Lighting( pixel, worldNormal, diffuseColor, normalize( pixel.lightDelta ) );
	fragment.color.rgb = unattenuatedColor * Attenuation( pixel );
#if PRE_ALPHA_BLEND
	fragment.color.rgb *= diffuseColor.a;
	fragment.color.a = diffuseColor.a;
#else
	fragment.color.a = 1;
#endif

	Fog_PixelCalc( pixel, fragment );

	return fragment;
}
