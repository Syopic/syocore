package ua.com.syo.core.assets {
	import flash.display.Sprite;
	import flash.display.DisplayObject;
	
	import ua.com.syo.core.assets.events.AssetEvent;
	
	public class StreamAsset extends Sprite {
		
		protected var streamAsset:Asset; 
		
		public function StreamAsset(url:String) {
			streamAsset = new Asset("--", url);
			streamAsset.addEventListener(AssetEvent.ASSET_LOADED, assetLoadedHandler);
			streamAsset.load();

		}
		
		protected function assetLoadedHandler(event:AssetEvent):void {
			addChild(streamAsset.container.content);
		}

	}
}

