// Made with Amplify Shader Editor
// Available at the Unity Asset Store - http://u3d.as/y3X 
Shader "PivotBaking/PB_VFX5"
{
	Properties
	{
		_Roughness("Roughness", Range( 0 , 1)) = 0.5909025
		_Innerdistance("Inner distance", Range( 0 , 10)) = 0
		_Outerdistance("Outer distance", Range( 0 , 10)) = 0
		_Disappeardistance("Disappear distance", Range( -25 , 25)) = 0
		_Randomization("Randomization", Range( 0 , 4)) = 1.317647
		_Smoothness("Smoothness", Range( 0.01 , 10)) = 0
		_Floatingintensity("Floating intensity", Range( 0 , 1)) = 0
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
			half filler;
		};

		uniform float3 HeroPosition;
		uniform float _Innerdistance;
		uniform float _Outerdistance;
		uniform float _Randomization;
		uniform float _Floatingintensity;
		uniform float _Smoothness;
		uniform float _Disappeardistance;
		uniform float _Roughness;


		float3 RotateAroundAxis( float3 center, float3 original, float3 u, float angle )
		{
			original -= center;
			float C = cos( angle );
			float S = sin( angle );
			float t = 1 - C;
			float m00 = t * u.x * u.x + C;
			float m01 = t * u.x * u.y - S * u.z;
			float m02 = t * u.x * u.z + S * u.y;
			float m10 = t * u.x * u.y + S * u.z;
			float m11 = t * u.y * u.y + C;
			float m12 = t * u.y * u.z - S * u.x;
			float m20 = t * u.x * u.z - S * u.y;
			float m21 = t * u.y * u.z + S * u.x;
			float m22 = t * u.z * u.z + C;
			float3x3 finalMatrix = float3x3( m00, m01, m02, m10, m11, m12, m20, m21, m22 );
			return mul( finalMatrix, original ) + center;
		}


		void vertexDataFunc( inout appdata_full v, out Input o )
		{
			UNITY_INITIALIZE_OUTPUT( Input, o );
			float3 appendResult7_g7 = (float3(( v.texcoord2.xy.x * -1.0 ) , v.texcoord3.xy.x , ( v.texcoord2.xy.y * -1.0 )));
			float3 temp_output_16_0_g7 = ( 0.01 * appendResult7_g7 );
			float3 PivotAbsPosition89 = temp_output_16_0_g7;
			float3 objToWorld47 = mul( unity_ObjectToWorld, float4( PivotAbsPosition89, 1 ) ).xyz;
			float3 HeroRelativePos98 = ( objToWorld47 - HeroPosition );
			float3 appendResult9_g7 = (float3(( 1.0 - v.color.r ) , v.color.b , v.color.g));
			float3 ForwardDir87 = ( ( appendResult9_g7 - float3(0.5,0.5,0.5) ) * 2.0 );
			float3 normalizeResult77 = normalize( cross( HeroRelativePos98 , ForwardDir87 ) );
			float RandomValue88 = v.texcoord3.xy.y;
			float smoothstepResult50 = smoothstep( _Innerdistance , _Outerdistance , ( ( ( RandomValue88 * -1.0 * _Randomization ) + length( HeroRelativePos98 ) ) + ( _SinTime.y * _Floatingintensity ) ));
			float DissolveEffectIntensity102 = pow( smoothstepResult50 , _Smoothness );
			float temp_output_64_0 = ( DissolveEffectIntensity102 * ( 4.0 * UNITY_PI ) * RandomValue88 );
			float3 ase_vertex3Pos = v.vertex.xyz;
			float3 PivotRelativePosition90 = ( ase_vertex3Pos - temp_output_16_0_g7 );
			float3 temp_output_74_0 = ( PivotRelativePosition90 * ( 1.0 - DissolveEffectIntensity102 ) );
			float3 rotatedValue61 = RotateAroundAxis( float3( 0,0,0 ), temp_output_74_0, normalizeResult77, temp_output_64_0 );
			v.vertex.xyz += ( ( rotatedValue61 - temp_output_74_0 ) + ( PivotRelativePosition90 * float3( -1,-1,-1 ) * DissolveEffectIntensity102 ) + ( ForwardDir87 * DissolveEffectIntensity102 * _Disappeardistance ) );
			v.vertex.w = 1;
			float3 ase_vertexNormal = v.normal.xyz;
			float3 rotatedValue79 = RotateAroundAxis( float3( 0,0,0 ), ase_vertexNormal, normalizeResult77, temp_output_64_0 );
			v.normal = rotatedValue79;
		}

		void surf( Input i , inout SurfaceOutputStandard o )
		{
			float4 color1 = IsGammaSpace() ? float4(0.5127714,0.5207428,0.6509434,0) : float4(0.2260532,0.2337451,0.3812781,0);
			o.Albedo = color1.rgb;
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
1920;0;1920;1149;2470.411;1248.691;2.307887;True;False
Node;AmplifyShaderEditor.FunctionNode;46;-1809.857,-391.6364;Inherit;False;GetPivotInfo;-1;;7;b58e44ad5701a19499f0136a7117d015;0;0;4;FLOAT3;0;FLOAT3;18;FLOAT;1;FLOAT3;2
Node;AmplifyShaderEditor.CommentaryNode;101;-2307.684,357.2797;Inherit;False;948.0907;405.9178;Hero relative position;5;91;48;47;76;98;;1,1,1,1;0;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;89;-1502.833,-468.6243;Inherit;False;PivotAbsPosition;-1;True;1;0;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.GetLocalVarNode;91;-2257.684,442.1677;Inherit;False;89;PivotAbsPosition;1;0;OBJECT;;False;1;FLOAT3;0
Node;AmplifyShaderEditor.Vector3Node;48;-1995.545,575.1974;Inherit;False;Global;HeroPosition;HeroPosition;1;0;Create;True;0;0;0;False;0;False;0,0,0;13.69,0.49,-0.2;0;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.TransformPositionNode;47;-2018.963,407.2797;Inherit;False;Object;World;False;Fast;True;1;0;FLOAT3;0,0,0;False;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.SimpleSubtractOpNode;76;-1774.038,469.6209;Inherit;False;2;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.CommentaryNode;107;-1282.736,85.00397;Inherit;False;1650.743;867.0295;Compute effect intensity according to radius/randomization and more.;15;60;97;59;86;82;58;85;83;52;53;50;80;102;81;100;;1,1,1,1;0;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;88;-1501.833,-299.6243;Inherit;False;RandomValue;-1;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;60;-1176.429,334.3768;Inherit;False;Property;_Randomization;Randomization;4;0;Create;True;0;0;0;False;0;False;1.317647;0.76;0;4;0;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;97;-1099.4,236.004;Inherit;False;88;RandomValue;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;98;-1592.594,474.7042;Inherit;False;HeroRelativePos;-1;True;1;0;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;59;-869.4296,251.3768;Inherit;False;3;3;0;FLOAT;0;False;1;FLOAT;-1;False;2;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.LengthOpNode;100;-1232.736,479.6321;Inherit;False;1;0;FLOAT3;0,0,0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SinTimeNode;82;-860.2148,516.3515;Inherit;False;0;5;FLOAT4;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RangedFloatNode;86;-959.7421,665.308;Inherit;False;Property;_Floatingintensity;Floating intensity;6;0;Create;True;0;0;0;False;0;False;0;0.418;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleAddOpNode;58;-659.4296,324.3769;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;85;-631.8651,571.6366;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleAddOpNode;83;-452.1287,538.8239;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;53;-947.2606,836.0334;Inherit;False;Property;_Outerdistance;Outer distance;2;0;Create;True;0;0;0;False;0;False;0;1.57;0;10;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;52;-954.2605,750.0334;Inherit;False;Property;_Innerdistance;Inner distance;1;0;Create;True;0;0;0;False;0;False;0;0.82;0;10;0;1;FLOAT;0
Node;AmplifyShaderEditor.SmoothstepOpNode;50;-277.6554,681.6362;Inherit;False;3;0;FLOAT;0;False;1;FLOAT;5;False;2;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;81;-389.3701,832.6931;Inherit;False;Property;_Smoothness;Smoothness;5;0;Create;True;0;0;0;False;0;False;0;5.12;0.01;10;0;1;FLOAT;0
Node;AmplifyShaderEditor.PowerNode;80;-76.30545,680.5298;Inherit;False;False;2;0;FLOAT;0;False;1;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;102;99.00633,676.8861;Inherit;False;DissolveEffectIntensity;-1;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.CommentaryNode;114;-695.8286,-978.0924;Inherit;False;939.8625;248.8615;Compute rotation axis;4;62;93;99;77;;1,1,1,1;0;0
Node;AmplifyShaderEditor.CommentaryNode;112;-32.67322,-301.4745;Inherit;False;491.2822;167.0995;Take scaling into account;2;105;75;;1,1,1,1;0;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;87;-1498.833,-215.6243;Inherit;False;ForwardDir;-1;True;1;0;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;90;-1503.833,-384.6243;Inherit;False;PivotRelativePosition;-1;True;1;0;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.CommentaryNode;113;-94.67322,-680.4745;Inherit;False;550.3433;352.8503;Rotation angle;4;106;96;65;64;;1,1,1,1;0;0
Node;AmplifyShaderEditor.CommentaryNode;109;493.5771,-643.2043;Inherit;False;975.0529;392.6194;Rotate position;4;74;94;73;61;;1,1,1,1;0;0
Node;AmplifyShaderEditor.GetLocalVarNode;105;17.32678,-251.4745;Inherit;False;102;DissolveEffectIntensity;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;93;-427.7688,-832.2309;Inherit;False;87;ForwardDir;1;0;OBJECT;;False;1;FLOAT3;0
Node;AmplifyShaderEditor.GetLocalVarNode;99;-698.8286,-910.6818;Inherit;False;98;HeroRelativePos;1;0;OBJECT;;False;1;FLOAT3;0
Node;AmplifyShaderEditor.GetLocalVarNode;94;509.167,-418.6243;Inherit;False;90;PivotRelativePosition;1;0;OBJECT;;False;1;FLOAT3;0
Node;AmplifyShaderEditor.OneMinusNode;75;279.609,-245.375;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.PiNode;65;-6.934753,-532.3173;Inherit;False;1;0;FLOAT;4;False;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;96;-4.833008,-443.6243;Inherit;False;88;RandomValue;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;106;-44.67322,-630.4745;Inherit;False;102;DissolveEffectIntensity;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.CrossProductOpNode;62;-195.966,-904.0924;Inherit;False;2;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.CommentaryNode;110;723.3268,-173.6243;Inherit;False;489.8212;259.1497;Sub object scaling;3;104;95;57;;1,1,1,1;0;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;74;748.5771,-370.5849;Inherit;False;2;2;0;FLOAT3;0,0,0;False;1;FLOAT;0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;64;293.67,-600.895;Inherit;False;3;3;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.CommentaryNode;111;643.5739,109.3757;Inherit;False;563.1841;336.2316;Sub object translation;4;92;103;7;55;;1,1,1,1;0;0
Node;AmplifyShaderEditor.NormalizeNode;77;6.456711,-901.5487;Inherit;False;False;1;0;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.RangedFloatNode;55;693.5739,329.6073;Inherit;False;Property;_Disappeardistance;Disappear distance;3;0;Create;True;0;0;0;False;0;False;0;9.2;-25;25;0;1;FLOAT;0
Node;AmplifyShaderEditor.RotateAboutAxisNode;61;936.7601,-532.2043;Inherit;False;False;4;0;FLOAT3;0,0,0;False;1;FLOAT;0;False;2;FLOAT3;0,0,0;False;3;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.GetLocalVarNode;103;726.3268,238.5255;Inherit;False;102;DissolveEffectIntensity;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;92;840.167,159.3757;Inherit;False;87;ForwardDir;1;0;OBJECT;;False;1;FLOAT3;0
Node;AmplifyShaderEditor.GetLocalVarNode;95;775.167,-123.6243;Inherit;False;90;PivotRelativePosition;1;0;OBJECT;;False;1;FLOAT3;0
Node;AmplifyShaderEditor.GetLocalVarNode;104;773.3268,-30.47455;Inherit;False;102;DissolveEffectIntensity;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.CommentaryNode;108;593.712,-1152.736;Inherit;False;708.4201;442.8729;Rotate normal;2;78;79;;1,1,1,1;0;0
Node;AmplifyShaderEditor.RangedFloatNode;30;1632.304,-646.4939;Inherit;False;Property;_Roughness;Roughness;0;0;Create;True;0;0;0;False;0;False;0.5909025;0.247;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;7;1044.758,177.5816;Inherit;False;3;3;0;FLOAT3;0,0,0;False;1;FLOAT;0;False;2;FLOAT;0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;57;1051.148,-110.2952;Inherit;False;3;3;0;FLOAT3;0,0,0;False;1;FLOAT3;-1,-1,-1;False;2;FLOAT;0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.NormalVertexDataNode;78;643.712,-1102.736;Inherit;False;0;5;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleSubtractOpNode;73;1285.63,-406.7921;Inherit;False;2;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.ColorNode;1;1852.015,-843.3627;Inherit;False;Constant;_Color0;Color 0;0;0;Create;True;0;0;0;False;0;False;0.5127714,0.5207428,0.6509434,0;0,0,0,0;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RotateAboutAxisNode;79;982.1321,-892.8627;Inherit;False;False;4;0;FLOAT3;0,0,0;False;1;FLOAT;0;False;2;FLOAT3;0,0,0;False;3;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.OneMinusNode;32;1933.859,-641.5878;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleAddOpNode;56;1439.816,-157.0357;Inherit;False;3;3;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;2;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.StandardSurfaceOutputNode;0;2168.919,-652.8735;Float;False;True;-1;2;ASEMaterialInspector;0;0;Standard;PivotBaking/PB_VFX5;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;Back;0;False;-1;0;False;-1;False;0;False;-1;0;False;-1;False;0;Opaque;0.5;True;True;0;False;Opaque;;Geometry;All;14;all;True;True;True;True;0;False;-1;False;0;False;-1;255;False;-1;255;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;False;2;15;10;25;False;0.5;True;0;0;False;-1;0;False;-1;0;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;0;0,0,0,0;VertexOffset;True;False;Cylindrical;False;Relative;0;;-1;-1;-1;-1;0;False;0;0;False;-1;-1;0;False;-1;0;0;0;False;0.1;False;-1;0;False;-1;False;16;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;2;FLOAT3;0,0,0;False;3;FLOAT;0;False;4;FLOAT;0;False;5;FLOAT;0;False;6;FLOAT3;0,0,0;False;7;FLOAT3;0,0,0;False;8;FLOAT;0;False;9;FLOAT;0;False;10;FLOAT;0;False;13;FLOAT3;0,0,0;False;11;FLOAT3;0,0,0;False;12;FLOAT3;0,0,0;False;14;FLOAT4;0,0,0,0;False;15;FLOAT3;0,0,0;False;0
WireConnection;89;0;46;0
WireConnection;47;0;91;0
WireConnection;76;0;47;0
WireConnection;76;1;48;0
WireConnection;88;0;46;1
WireConnection;98;0;76;0
WireConnection;59;0;97;0
WireConnection;59;2;60;0
WireConnection;100;0;98;0
WireConnection;58;0;59;0
WireConnection;58;1;100;0
WireConnection;85;0;82;2
WireConnection;85;1;86;0
WireConnection;83;0;58;0
WireConnection;83;1;85;0
WireConnection;50;0;83;0
WireConnection;50;1;52;0
WireConnection;50;2;53;0
WireConnection;80;0;50;0
WireConnection;80;1;81;0
WireConnection;102;0;80;0
WireConnection;87;0;46;2
WireConnection;90;0;46;18
WireConnection;75;0;105;0
WireConnection;62;0;99;0
WireConnection;62;1;93;0
WireConnection;74;0;94;0
WireConnection;74;1;75;0
WireConnection;64;0;106;0
WireConnection;64;1;65;0
WireConnection;64;2;96;0
WireConnection;77;0;62;0
WireConnection;61;0;77;0
WireConnection;61;1;64;0
WireConnection;61;3;74;0
WireConnection;7;0;92;0
WireConnection;7;1;103;0
WireConnection;7;2;55;0
WireConnection;57;0;95;0
WireConnection;57;2;104;0
WireConnection;73;0;61;0
WireConnection;73;1;74;0
WireConnection;79;0;77;0
WireConnection;79;1;64;0
WireConnection;79;3;78;0
WireConnection;32;0;30;0
WireConnection;56;0;73;0
WireConnection;56;1;57;0
WireConnection;56;2;7;0
WireConnection;0;0;1;0
WireConnection;0;4;32;0
WireConnection;0;11;56;0
WireConnection;0;12;79;0
ASEEND*/
//CHKSM=91F0CAF18DD3329A5ED66AB861C97BD9B5A03368