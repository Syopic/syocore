/**
 * Asset.as					loaded asset in stream and show preloader
 * @author					Anton Bodrichenko
 * @link    				http://www.bodrichenko.com.ua/
 * @link    				mailto: abodrichenko@gmail.com
 */
 
 package ua.com.syo.core.assets
{
	import flash.display.DisplayObject;
	
	import ua.com.syo.core.assets.events.AssetEvent;
	
	public class PreloadedStreamAsset extends StreamAsset
	{
		private static var _preloaderAsset:Class;
		private static var preloaderMovieHalfWidth:int;
		private static var preloaderMovieHalfHeight:int;
		private static var preloaderMovie:DisplayObject;

	
		 
		public function PreloadedStreamAsset(url:String){
			super(url) 
			streamAsset.addEventListener(AssetEvent.ASSET_INIT, 	assetInitHandler);
		}
		/**
		 * 	add and center preloader movie
		 */
		private function assetInitHandler(event:AssetEvent):void {
			const asset:DisplayObject = streamAsset.container.content;
			if(_preloaderAsset){
				preloaderMovie = new _preloaderAsset()
				addChild(preloaderMovie);
				/// centering preloader
				preloaderMovie.x = int(asset.width *0.5 - preloaderMovieHalfWidth);
				preloaderMovie.y = int(asset.height*0.5 - preloaderMovieHalfHeight);
			}
		}
		/**
		 * 	addMovie and remove preloader
		 */
		override protected function assetLoadedHandler(event:AssetEvent):void {
			if(preloaderMovie){
				removeChild(preloaderMovie);
				preloaderMovie = null;
			}
			super.assetLoadedHandler(event);
		}
		/**
		 * 	set preloader class and get preloader dimensions
		 */
		public static function set preloaderAsset(preloaderClass:Class):void{
			_preloaderAsset = preloaderClass;
			/// get width and height of preloader
			const mc:DisplayObject = new _preloaderAsset();
			preloaderMovieHalfWidth = mc.width * 0.5;
			preloaderMovieHalfHeight = mc.height * 0.5;
		}
	}
}