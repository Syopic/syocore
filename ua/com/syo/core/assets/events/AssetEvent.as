/**
 * AssetEvent.as			
 * @author					Krivosheya Sergey
 * @link    				http://www.syo.com.ua/
 * @link    				mailto: syopic@gmail.com
 */
package ua.com.syo.core.assets.events {
	import flash.events.Event;
	
	import ua.com.syo.core.assets.Asset;


	public class AssetEvent extends Event {
		
		public static var ASSET_INIT:String = "assetInit";
		public static var ASSET_LOADED:String = "assetLoaded";
		public static var ASSET_LOADED_ERROR:String = "assetLoadedError";
		public static var ALL_ASSETS_LOADED:String = "allAssetLoaded";

		public function AssetEvent(type:String , bubbles:Boolean = false , cancelable:Boolean = false) {
			super(type, bubbles, cancelable);
		}

		public var asset:Asset;
	}
}
