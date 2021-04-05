// Made with Amplify Shader Editor
// Available at the Unity Asset Store - http://u3d.as/y3X 
Shader "PivotBaking/PB_VFX1"
{
	Properties
	{
		_Spikescale("Spike scale", Range( -1 , 2)) = 0.8098202
		_Color0("Color 0", Color) = (0.5127714,0.5207428,0.6509434,0)
		_Roughness("Roughness", Range( 0 , 1)) = 0.5909025
		_Color1("Color 1", Color) = (0.9433962,0,0,0)
		[HideInInspector] _texcoord4( "", 2D ) = "white" {}
		[HideInInspector] __dirty( "", Int ) = 1
	}

	SubShader
	{
		Tags{ "RenderType" = "Opaque"  "Queue" = "Geometry+0" }
		Cull Back
		CGPROGRAM
		#include "UnityShaderVariables.cginc"
		#pragma target 3.0
		#pragma surface surf Standard keepalpha addshadow fullforwardshadows vertex:vertexDataFunc 
		struct Input
		{
			float2 uv4_texcoord4;
		};

		uniform float _Spikescale;
		uniform float4 _Color0;
		uniform float4 _Color1;
		uniform float _Roughness;

		void vertexDataFunc( inout appdata_full v, out Input o )
		{
			UNITY_INITIALIZE_OUTPUT( Input, o );
			float3 ase_vertex3Pos = v.vertex.xyz;
			float3 appendResult7_g8 = (float3(( v.texcoord2.xy.x * -1.0 ) , v.texcoord3.xy.x , ( v.texcoord2.xy.y * -1.0 )));
			float3 temp_output_16_0_g8 = ( 0.01 * appendResult7_g8 );
			float mulTime15 = _Time.y * 0.25;
			float temp_output_23_0 = ( ( sin( ( ( v.texcoord3.xy.y + mulTime15 ) * ( 2.0 * UNITY_PI ) ) ) + 1.0 ) * 0.5 );
			v.vertex.xyz += ( ( ase_vertex3Pos - temp_output_16_0_g8 ) * ( pow( temp_output_23_0 , 8.0 ) * _Spikescale ) );
			v.vertex.w = 1;
		}

		void surf( Input i , inout SurfaceOutputStandard o )
		{
			float mulTime15 = _Time.y * 0.25;
			float temp_output_23_0 = ( ( sin( ( ( i.uv4_texcoord4.y + mulTime15 ) * ( 2.0 * UNITY_PI ) ) ) + 1.0 ) * 0.5 );
			float4 lerpResult29 = lerp( _Color0 , _Color1 , temp_output_23_0);
			o.Albedo = lerpResult29.rgb;
			o.Smoothness = ( 1.0 - _Roughness );
			o.Alpha = 1;
		}

		ENDCG
	}
	Fallback "Diffuse"
	CustomEditor "ASEMaterialInspector"
}
/*ASEBEGIN
Version=18900
1920;0;1920;1149;354.3162;871.4687;1;True;False
Node;AmplifyShaderEditor.CommentaryNode;40;-1345.989,431.1821;Inherit;False;1276.493;320.9005;Random cycle per sub object. Each object has its own offset in time/phase;8;17;22;23;25;15;18;16;19;;1,1,1,1;0;0
Node;AmplifyShaderEditor.FunctionNode;39;-1616.44,40.71441;Inherit;False;GetPivotInfo;-1;;8;b58e44ad5701a19499f0136a7117d015;0;0;4;FLOAT3;0;FLOAT3;18;FLOAT;1;FLOAT3;2
Node;AmplifyShaderEditor.SimpleTimeNode;15;-1295.989,524.0829;Inherit;False;1;0;FLOAT;0.25;False;1;FLOAT;0
Node;AmplifyShaderEditor.PiNode;18;-1132.191,641.0826;Inherit;False;1;0;FLOAT;2;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleAddOpNode;16;-1028.19,481.1821;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;17;-872.5554,531.0145;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SinOpNode;19;-725.687,532.9482;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleAddOpNode;22;-548.3918,520.5937;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.CommentaryNode;42;-110.918,-16.09307;Inherit;False;971.9692;315;Subtracting 100% of the relative position will move the vertex to the pivot position. We're subtracting between 0 and 100% here;3;7;14;8;;1,1,1,1;0;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;23;-413.3918,520.5937;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0.5;False;1;FLOAT;0
Node;AmplifyShaderEditor.PowerNode;25;-246.4955,520.6803;Inherit;False;False;2;0;FLOAT;0;False;1;FLOAT;8;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;8;41.082,178.2467;Inherit;False;Property;_Spikescale;Spike scale;0;0;Create;True;0;0;0;False;0;False;0.8098202;-1;-1;2;0;1;FLOAT;0
Node;AmplifyShaderEditor.CommentaryNode;41;229.0818,-706.0554;Inherit;False;637.7683;444.1321;Colors blended according to scale;3;1;29;28;;1,1,1,1;0;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;14;393.4527,160.9244;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;5;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;30;544.5188,-195.7128;Inherit;False;Property;_Roughness;Roughness;2;0;Create;True;0;0;0;False;0;False;0.5909025;0.3030942;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.ColorNode;1;279.0818,-656.0554;Inherit;False;Property;_Color0;Color 0;1;0;Create;True;0;0;0;False;0;False;0.5127714,0.5207428,0.6509434,0;0.5127713,0.5207428,0.6509434,0;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.ColorNode;28;290.9818,-473.9238;Inherit;False;Property;_Color1;Color 1;3;0;Create;True;0;0;0;False;0;False;0.9433962,0,0,0;0.9433962,0,0,0;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.LerpOp;29;684.8504,-510.4335;Inherit;False;3;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;2;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;7;587.0513,63.90693;Inherit;False;2;2;0;FLOAT3;0,0,0;False;1;FLOAT;0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.OneMinusNode;32;839.4209,-188.5895;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.StandardSurfaceOutputNode;0;1027.649,-369.7325;Float;False;True;-1;2;ASEMaterialInspector;0;0;Standard;PivotBaking/PB_VFX1;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;Back;0;False;-1;0;False;-1;False;0;False;-1;0;False;-1;False;0;Opaque;0.5;True;True;0;False;Opaque;;Geometry;All;14;all;True;True;True;True;0;False;-1;False;0;False;-1;255;False;-1;255;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;False;2;15;10;25;False;0.5;True;0;0;False;-1;0;False;-1;0;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;0;0,0,0,0;VertexOffset;True;False;Cylindrical;False;Relative;0;;-1;-1;-1;-1;0;False;0;0;False;-1;-1;0;False;-1;0;0;0;False;0.1;False;-1;0;False;-1;False;16;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;2;FLOAT3;0,0,0;False;3;FLOAT;0;False;4;FLOAT;0;False;5;FLOAT;0;False;6;FLOAT3;0,0,0;False;7;FLOAT3;0,0,0;False;8;FLOAT;0;False;9;FLOAT;0;False;10;FLOAT;0;False;13;FLOAT3;0,0,0;False;11;FLOAT3;0,0,0;False;12;FLOAT3;0,0,0;False;14;FLOAT4;0,0,0,0;False;15;FLOAT3;0,0,0;False;0
WireConnection;16;0;39;1
WireConnection;16;1;15;0
WireConnection;17;0;16;0
WireConnection;17;1;18;0
WireConnection;19;0;17;0
WireConnection;22;0;19;0
WireConnection;23;0;22;0
WireConnection;25;0;23;0
WireConnection;14;0;25;0
WireConnection;14;1;8;0
WireConnection;29;0;1;0
WireConnection;29;1;28;0
WireConnection;29;2;23;0
WireConnection;7;0;39;18
WireConnection;7;1;14;0
WireConnection;32;0;30;0
WireConnection;0;0;29;0
WireConnection;0;4;32;0
WireConnection;0;11;7;0
ASEEND*/
//CHKSM=330DCFD8D7A0FC47B78C7931971836DC4DB42C2C