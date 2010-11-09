/**
 * PopupManager.as		Popup Manager
 * @author				Krivosheya Sergey
 * @link    			http://www.syo.com.ua/
 * @link    			mailto: syopic@gmail.com
 */
package ua.com.syo.core.components.gui.alert {
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.utils.Dictionary;

	public class AlertManager extends Sprite {

		private static var alertDict:Dictionary = new Dictionary(true);
		private static var idIncrement:int = 0;

		public static var AlertBg:Class;
		public static var ButtonBg:Class;
		public static var stageW:int;
		public static var stageH:int;

		public static function init(sW:int, sH:int, alertAsset:Class, buttonAsset:Class):void {
			stageW = sW;
			stageH = sH;
			AlertBg = alertAsset;
			ButtonBg = buttonAsset;
		}

		/**
		 * show alert
		 * @param cont container
		 * @param titleStr title text
		 * @param messageStr message text
		 */
		public static function show(titleStr:String, messageStr:String, isModal:Boolean, cont:Sprite, buttons:Array, addControl:String = null):String {
			var a:Alert = new Alert(titleStr, messageStr, isModal, cont, buttons, addControl);
			idIncrement++;
			alertDict[idIncrement] = a;

			a.addEventListener(Event.CANCEL, cancelHandler);


			return idIncrement.toString();
		}

		public static function remove(id:String):void {
			var a:Alert = alertDict[id] as Alert;
			if (a) {
				a.remove();
				delete alertDict[id];
				a = null;
			}
		}

		public static function centerAlerts():void {
			if (alertDict["1"]) {
				(alertDict["1"] as Alert).centerAlert(stageW, stageH);
			}
		}

		private static function cancelHandler(event:Event):void {
		}
	}
}


