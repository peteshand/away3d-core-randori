///<reference path="../_definitions.ts"/>

package away.animators
{
	import away.animators.nodes.AnimationNodeBase;
	import away.materials.passes.MaterialPassBase;
	import away.managers.Stage3DProxy;

	/**
	public interface IAnimationSet
	{
		/**
		function hasAnimation(name:String):Boolean;
		
		/**
		function getAnimation(name:String):AnimationNodeBase;
		
		/**
		function get usesCPU():Boolean; // GET
		/**
		function resetGPUCompatibility():void;
		
		/**
		function cancelGPUCompatibility():void;
		
		/**
		function getAGALVertexCode(pass:MaterialPassBase, sourceRegisters:Vector.<String>, targetRegisters:Vector.<String>, profile:String):String;
		
		/**
		function getAGALFragmentCode(pass:MaterialPassBase, shadedTarget:String, profile:String):String;
		
		/**
		function getAGALUVCode(pass:MaterialPassBase, UVSource:String, UVTarget:String):String;
		
		/**
		function doneAGALCode(pass:MaterialPassBase):void;
		
		/**
		function activate(stage3DProxy:Stage3DProxy, pass:MaterialPassBase):void;
		
		/**
		function deactivate(tage3DProxy:Stage3DProxy, pass:MaterialPassBase):void;
	}
}