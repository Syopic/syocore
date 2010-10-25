/**
 * Asset.as					visual asset class
 * @author					Krivosheya Sergey
 * @link    				http://www.syo.com.ua/
 * @link    				mailto: syopic@gmail.com
 */
package ua.com.syo.core.assets {
	import flash.display.Loader;
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.events.IOErrorEvent;
	import flash.net.URLLoader;
	import flash.net.URLLoaderDataFormat;
	import flash.net.URLRequest;
	import flash.system.LoaderContext;
	
	import ua.com.syo.core.assets.events.AssetEvent;
	import ua.com.syo.core.log.Logger;
	
	public class Asset extends EventDispatcher {
		public var id:String;
		public var url:String;
		public var className:Class;
		public var container:Loader;
		public var xmlContainer:URLLoader;
		public var type:String;
		public var isLoaded:Boolean = false;

		/**
		 * constructor
		 * @param url 	path to filename
		 * @param type	type on stage
		 * @param id	id in map data
		 */
		public function Asset(id:String, url:String, type:String = "sprite") {
			this.url = url;
			this.id = id;
			this.type = type;
		}

		/**
		 * load graphics/xml into each Asset copy
		 */
		public function load():void {
			if (type == "xml") {
				xmlContainer = new URLLoader();
			    xmlContainer.dataFormat = URLLoaderDataFormat.TEXT;
			    xmlContainer.addEventListener(Event.COMPLETE, assetLoadedHandler);
			    xmlContainer.addEventListener(IOErrorEvent.IO_ERROR, assetLoadedErrorHandler);
			    xmlContainer.load(new URLRequest(url));
			} else {
				var loaderContext:LoaderContext = new LoaderContext();
				loaderContext.checkPolicyFile = true;
				container = new Loader();
				var urlReq:URLRequest = new URLRequest(url);
				container.contentLoaderInfo.addEventListener(Event.COMPLETE, assetLoadedHandler);
			    container.contentLoaderInfo.addEventListener(Event.INIT, assetLoadedInitHandler);
				container.contentLoaderInfo.addEventListener(IOErrorEvent.IO_ERROR, assetLoadedErrorHandler);
				container.load(urlReq, loaderContext);
			}
		}

		private function assetLoadedInitHandler(e:Event):void {
			var ae:AssetEvent = new AssetEvent(AssetEvent.ASSET_INIT);
			ae.asset = this;
			dispatchEvent(ae);
		}
		private function assetLoadedHandler(e:Event):void {
			Logger.DEBUG("Asset "+id+": " + url + " loaded!");
			isLoaded = true;
			if (type == "xml") {
				xmlContainer.removeEventListener(Event.COMPLETE, assetLoadedHandler);
			    xmlContainer.removeEventListener(IOErrorEvent.IO_ERROR, assetLoadedErrorHandler);
			} else {
				container.contentLoaderInfo.removeEventListener(Event.COMPLETE, assetLoadedHandler);
				container.contentLoaderInfo.removeEventListener(IOErrorEvent.IO_ERROR, assetLoadedErrorHandler);
			}
			
			var ae:AssetEvent = new AssetEvent(AssetEvent.ASSET_LOADED);
			ae.asset = this;
			dispatchEvent(ae);
		}

		private function assetLoadedErrorHandler(e:IOErrorEvent):void {
			Logger.ERROR("Asset with url: " + url + " not loaded!");
			
			var ae:AssetEvent = new AssetEvent(AssetEvent.ASSET_LOADED);
			ae.asset = this;
			dispatchEvent(ae);
		}
		
		/**
		 * inload/delete from memory assets
		 */
		public function unload():void {
			if (type == "xml") {
				xmlContainer.data = null;
			} else {
				container.addEventListener(Event.UNLOAD, unLoadHandler);
				container.unload();
			}
		}
		
		private function unLoadHandler(event:Event):void {
            Logger.DEBUG("Asset " + url + " unloaded!");
			container = null;
			isLoaded = false;
        }
	}
}
