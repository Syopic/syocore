/**
 * AssetsStorage.as			storage original assets and duplicate their
 * @author					Krivosheya Sergey
 * @link    				http://www.syo.com.ua/
 * @link    				mailto: syopic@gmail.com
 */
 package ua.com.syo.core.assets {
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.DisplayObject;
	import flash.display.MovieClip;
	import flash.utils.Dictionary;
	import flash.utils.getQualifiedClassName;
	
	import ua.com.syo.core.log.Logger;

	public class AssetsStorage {

		// original assets
		private static var assetDict:Dictionary = new Dictionary();
		// assets in progress
		public static var loadingAssetsDict:Dictionary = new Dictionary();

		/**
		 * add original asset
		 * @param asset
		 */
		public static function addAsset(asset:Asset):void {
			assetDict[asset.id] = asset as Asset;
		}

		/**
		 * get original asset
		 * @return asset
		 */
		public static function getAsset(id:String):Asset {
			return assetDict[id]as Asset;
		}

		/**
		 * unload original asset
		 * @return asset
		 */
		public static function unloadAsset(id:String):void {
			Asset(assetDict[id]).unload();
			delete assetDict[id];
		}
		
		
		/**
		 * get duplicate of asset
		 * @param id
		 * @return duplicateObject
		 */
		public static function getDisplayObject(id:String):DisplayObject {
			if (assetDict[id] == null) {
				Logger.WARNING("getSprite: asset with id = " + id + " not found");
				return null;
			}
			return duplicateObject((assetDict[id]as Asset).container.content);
		}
		
		/**
		 * assetIsPresent
		 * @return Boolean
		 */
		public static function assetIsPresent(id:String):Boolean {
			if (assetDict[id]) {
				return true;
			} else {
				return false;
			}
		}
		
		/**
		 * get duplicate of asset
		 * @param id
		 * @return duplicateObject
		 */
		public static function getAssetClass(id:String):Class {
			var obj:DisplayObject = (assetDict[id]as Asset).container.content;
			var tClass:Class;
			// if bitmap
			if (obj is Bitmap) {
				tClass = Object(obj).constructor as Class;
				(tClass as Bitmap).bitmapData = (obj as Bitmap).bitmapData;
			}
			// if  movie clip
			if (obj is MovieClip) {
				tClass = getObjectClass(obj);
			}
			
			return tClass;
				
		}

		/**
		 * get duplicate of bitmapdata
		 * @param id
		 * @return clone of bitmapdata
		 */
		public static function getBitmapData(id:String):BitmapData {
			if (!assetDict[id] || !Asset(assetDict[id]).container.content) {
				Logger.WARNING("getBitmapData: asset with id = " + id + " not found");
				return null;
			}

			return Bitmap(Asset(assetDict[id]).container.content).bitmapData.clone();
		}

		/**
		 * get xml data
		 * @param id
		 * @return link to xml object
		 */
		public static function getXMLData(id:String):XML {
			if (assetDict[id] == null) {
				Logger.WARNING("getXMLData: asset with id = " + id + " not found");
				return null;
			}
			return XML(Asset(assetDict[id]).xmlContainer.data);
		}


		// duplicating
		private static function duplicateObject(object:DisplayObject):DisplayObject {
			var duplicate:Object = new Object();
			// if bitmap
			if (object is Bitmap) {
				var targetClass:Class = Object(object).constructor as Class;
				duplicate = new targetClass()as Bitmap;
				(duplicate as Bitmap).bitmapData = (object as Bitmap).bitmapData;
			}
			// if  movie clip
			if (object is MovieClip) {
				var t:Class = getObjectClass(object);
				if (t) {
					duplicate = new(getObjectClass(object))();
				}
				else {
					Logger.ERROR("Cannot duplicate asset");
					// if not asset - insert mock asset from graphic library
					return new DisplayObject();
				}
			}
			return duplicate as DisplayObject;
		}

		// get class definition
		private static function getObjectClass(object:DisplayObject):Class {
			// get class of asset
			if (object) {
				var result:Class = object.loaderInfo.applicationDomain.getDefinition(getQualifiedClassName(object))as Class;
			}
			return result;
		}
	}
}

