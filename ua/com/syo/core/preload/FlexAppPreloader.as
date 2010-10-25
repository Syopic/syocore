package ua.com.syo.core.preload {
	import flash.display.DisplayObject;
	import flash.display.Loader;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.IOErrorEvent;
	import flash.events.ProgressEvent;
	import flash.events.SecurityErrorEvent;
	import flash.net.URLLoader;
	import flash.net.URLLoaderDataFormat;
	import flash.net.URLRequest;
	import flash.system.ApplicationDomain;
	import flash.system.LoaderContext;
	import flash.system.Security;
	import flash.system.SecurityDomain;
	
	public class FlexAppPreloader extends Sprite {
		
		public var version:String = "";
		
		public var serverHost:String = "";
		public var appSwfPath:String = "";
		public var mcPreloader:Sprite;
		
		private var configLoader:URLLoader;
		private var appLoader:Loader;
		
		
		/**
		 * Constructor
		 */
		public function FlexAppPreloader() {
			super();
		}
		
		/**
		 * Load config XML
		 */
		public function loadConfig(cfgPath:String):void {
			Security.allowDomain(serverHost);
			
			configLoader = new URLLoader();
			configLoader.dataFormat = URLLoaderDataFormat.TEXT;
			configLoader.addEventListener(Event.COMPLETE, configLoadCompleteHandler);
			configLoader.addEventListener(IOErrorEvent.IO_ERROR, configLoadErrorHandler);
			configLoader.addEventListener(SecurityErrorEvent.SECURITY_ERROR, configLoadErrorHandler);
			
			var noCasheInt:String = Math.abs(new Date().time).toString();
			var configURL:String = serverHost + "/" + cfgPath + "?noCache=" + noCasheInt;
			
			var configReq:URLRequest = new URLRequest(configURL);
			
			configLoader.load(configReq);
		}
		
		/**
		 * configLoadCompleteHandler
		 */
		private function configLoadCompleteHandler(event:Event):void {
			
			var configXML:XML = new XML(configLoader.data);
			
			configLoader.removeEventListener(Event.COMPLETE, configLoadCompleteHandler);
			configLoader.removeEventListener(IOErrorEvent.IO_ERROR, configLoadErrorHandler);
			configLoader.removeEventListener(SecurityErrorEvent.SECURITY_ERROR, configLoadErrorHandler);
			configLoader = null;
			
			appSwfPath = serverHost + configXML.@swfPath;
			loadApp();
		}
		
		/**
		 * Load main application
		 */
		private function loadApp():void {
			Security.allowDomain(serverHost);
			
			appLoader = new Loader();
			appLoader.contentLoaderInfo.addEventListener(Event.COMPLETE, appLoadCompleteHandler);
			appLoader.contentLoaderInfo.addEventListener(ProgressEvent.PROGRESS, progressHandler);
			appLoader.contentLoaderInfo.addEventListener(IOErrorEvent.IO_ERROR, appLoadErrorHandler);
			appLoader.contentLoaderInfo.addEventListener(SecurityErrorEvent.SECURITY_ERROR, appLoadErrorHandler);
			appLoader.load(
				new URLRequest(appSwfPath),
				new LoaderContext(
					true,
					ApplicationDomain.currentDomain,
					Security.sandboxType == Security.REMOTE ? SecurityDomain.currentDomain : null
				)
			);
		}
		
		/**
		 * progressHandler needs to be overrided
		 */
		protected function progressHandler(event:ProgressEvent):void {
		}
		
		/**
		 * Main application loaded
		 */
		private function appLoadCompleteHandler(event:Event):void {
			appLoader.contentLoaderInfo.removeEventListener(Event.COMPLETE, appLoadCompleteHandler);
			appLoader.contentLoaderInfo.removeEventListener(IOErrorEvent.IO_ERROR, appLoadErrorHandler);
			appLoader.contentLoaderInfo.removeEventListener(SecurityErrorEvent.SECURITY_ERROR, appLoadErrorHandler);
			
			
			var flexApp:DisplayObject = appLoader.content as DisplayObject;
			addChild(flexApp);
			flexApp.addEventListener("applicationComplete", initNestedAppsHandler, false, 0, true);
		}
		
		/**
		 * Send FlashVars to Flex App
		 */
		private function initNestedAppsHandler(event:Event):void {
			
			removeChild(mcPreloader);
			mcPreloader = null;
			
			var flashVars:* = loaderInfo.parameters;
			flashVars.v = version;
			event.target.application.setFlashVars(flashVars);
		}
		
		/**
		 * Error handlers
		 */
		private function configLoadErrorHandler(event:Event):void {
			trace(event.toString());
		}
		
		private function appLoadErrorHandler(event:Event):void {
			trace(event.toString());
		}
	}
}
