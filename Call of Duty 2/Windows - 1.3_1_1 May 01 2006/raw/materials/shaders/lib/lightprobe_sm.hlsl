#ifndef CACHED_SMODEL
#error "CACHED_SMODEL not defined"
#endif

#include "globals.hlsl"

#define FOGVAR fog


static const float3x3 lightgridLookupMatrix =
{
	{ 0.81649658f, -0.40824829f, -0.40824829f },
	{ 0, 0.70710678f, -0.70710678f },
	{ 0.57735027f, 0.57735027f, 0.57735027f },
};


struct VertexInput
{
	float4 position : POSITION;
	float3 normal : NORMAL;
	float4 color : COLOR;
	float2 texCoords : TEXCOORD0;
	float3 tangent : TEXCOORD1;
	float3 binormal : TEXCOORD2;
#if CACHED_SMODEL
	float3 lightingCoords : TEXCOORD3;
#endif // #if CACHED_SMODEL
};


struct PixelInput
{
	float4 position : POSITION;
	float4 color : COLOR;
	float2 texCoords : TEXCOORD0;
	float3 tangent : TEXCOORD1;
	float3 binormal : TEXCOORD2;
	float3 normal : TEXCOORD3;
	float3 baseLightingCoords : TEXCOORD4;
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
#include "normalmap.hlsl"
#include "shade.hlsl"
#include "phong.hlsl"


PixelInput vs_main( const VertexInput vertex )
{
	PixelInput pixel;

	pixel = (PixelInput)0;
	pixel.position = Transform_ObjectToClip( vertex.position );
	pixel.color = vertex.color;
	pixel.texCoords = vertex.texCoords;
#if CACHED_SMODEL
	pixel.baseLightingCoords = vertex.lightingCoords * (1.0f / 32768) + float3( 0, 0, 0.5f );
#else
	pixel.baseLightingCoords = baseLightingCoords;
#endif

	Normal_VertexSetup( vertex, worldMatrix, pixel );
	Phong_VertexSetup( vertex, lightPosition0, pixel );
	Fog_VertexCalc( vertex, pixel );

	return pixel;
}


half4 ProbeLighting( const PixelInput pixel, const half3 worldNormal )
{
	half3 rotatedNormal;
	half3 absNormal;
	half longestSide;
	half3 lightingCoords;

	rotatedNormal = mul( worldNormal, lightgridLookupMatrix );
	absNormal = abs( rotatedNormal );
	longestSide = max( absNormal.x, max( absNormal.y, absNormal.z ) );
	lightingCoords = rotatedNormal * lightingLookupScale.xyz / longestSide + pixel.baseLightingCoords;
	return tex3D( smodelLightingSampler, lightingCoords );
}


PixelOutput ps_main( const PixelInput pixel )
{
	PixelOutput	fragment;

	half4		diffuseColor;
	half4		lightprobeDiffuse;
	half3		sunlightVisibility;
	half3		sunlightVisibilitySpec;
	half3		sunlightDiffuse;
	half3		sunlightSpecular;
	half3		worldNormal;

	diffuseColor = ColoredTexturedDiffuse( pixel.color, pixel.texCoords );

	worldNormal = Normal_GetWorldSpace( pixel );
	lightprobeDiffuse = ProbeLighting( pixel, worldNormal );

	sunlightVisibility = lightprobeDiffuse.a;
	sunlightVisibilitySpec = Phong_SpecularVisibility( sunlightVisibility );
	sunlightDiffuse = sunlightVisibility * Phong_DiffuseLighting( pixel, worldNormal, lightPosition0 );
	sunlightSpecular = sunlightVisibilitySpec * Phong_SpecularLighting( pixel, worldNormal );

	fragment.color.rgb = diffuseColor.rgb * (lightprobeDiffuse.rgb + sunlightDiffuse) + sunlightSpecular;
#if USE_ALPHA
	fragment.color.a = diffuseColor.a;
#else
	fragment.color.a = 1.0f;
#endif

	Fog_PixelCalc( pixel, fragment );

	return fragment;
}
