/**
 * ...
 * @author Gary Paluk - http://www.plugin.io
 */
///<reference path="../_definitions.ts"/>

package away.sort
{
	import away.traverse.EntityCollector;
	public interface IEntitySorter
	{
		function sort(collector:EntityCollector):void;
	}
}