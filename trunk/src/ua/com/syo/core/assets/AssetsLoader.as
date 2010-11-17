/**
 * AssetsLoader.as			load all external assets
 * @author					Krivosheya Sergey
 * @link    				http://www.syo.com.ua/
 * @link    				mailto: syopic@gmail.com
 */
package ua.com.syo.core.assets {
	import flash.events.EventDispatcher;
	
	import ua.com.syo.core.assets.events.AssetEvent;
	import ua.com.syo.core.log.Logger;

	public class AssetsLoader extends EventDispatcher {

		private var assetsArray:Array = new Array();
		private var assetsCounter:Number;
		public var packageLabel:String;

		/**
		 * constructor
		 */
		public function AssetsLoader(pLabel:String = "defaultName") {
			packageLabel = pLabel;
		}

		/**
		 * add new asset in array
		 * @param asset
		 */
		public function pushAsset(asset:Asset):void {
			assetsArray.push(asset);
		}

		/**
		 * start loading
		 */
		public function startLoading():void {
			assetsCounter = assetsArray.length;
			if (assetsCounter == 0) {
				dispatchEvent(new AssetEvent(AssetEvent.ALL_ASSETS_LOADED, true));
			}
			for (var i:Number = 0; i < assetsCounter; i++) {
				(assetsArray[i] as Asset).addEventListener(AssetEvent.ASSET_LOADED, oneAssetLoadedHandler);
				(assetsArray[i] as Asset).load();
			}
		}

		private function oneAssetLoadedHandler(event:AssetEvent):void {
			(event.target as Asset).removeEventListener(AssetEvent.ASSET_LOADED, oneAssetLoadedHandler);
			AssetsStorage.addAsset(event.asset);
			assetsCounter--;
			// if package loaded
			if (assetsCounter <= 0) {
				if (packageLabel != "defaultName") {
					Logger.DEBUG(" ---- Package assets: '" + packageLabel + "' loaded");
				}
				var aEvent:AssetEvent = new AssetEvent(AssetEvent.ALL_ASSETS_LOADED, true);
				aEvent.loaderLabel = packageLabel;
				dispatchEvent(aEvent);
			}
		}
	}
}
