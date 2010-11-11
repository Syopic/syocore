/**
 * Hint.as		        display hint
 * @author				Krivosheya Sergey
 * @link    			http://www.syo.com.ua/
 * @link    			mailto: syopic@gmail.com
 */
package ua.com.syo.core.components.gui {
	import flash.display.DisplayObject;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.filters.DropShadowFilter;
	import flash.text.TextField;
	import flash.text.TextFieldAutoSize;
	import flash.text.TextFormat;
	import flash.text.TextFormatAlign;
	import flash.utils.Dictionary;

	public class Hint extends Sprite {

		public var parentContainer:Sprite;
		public var bg:Sprite;
		public var container:Sprite;
		public var hintTextField:TextField;
		public var hintDict:Dictionary;

		/**
		 * Singleton
		 */
		private static var _instance:Hint;

		public static function get instance():Hint {
			if (_instance == null) {
				_instance = new Hint();
			}

			return _instance;
		}

		public function init():void {
			hintDict = new Dictionary(true);
		}

		public function linkToContainer(cont:Sprite):void {
			parentContainer = cont;
			container = new Sprite();
			parentContainer.addChild(container);

			hintTextField = new TextField();
			hintTextField.height = 22;
			hintTextField.width = 60;
			hintTextField.autoSize = TextFieldAutoSize.LEFT;
			hintTextField.border = true;
			hintTextField.background = true;
			hintTextField.backgroundColor = 0xFFFFCC;

			var format:TextFormat = new TextFormat();
			format.size = 11;
			format.align = "center";
			format.align = TextFormatAlign.LEFT;
			format.font = "Tahoma";
			format.color = "0x000000";
			format.indent = 2;

			hintTextField.defaultTextFormat = format;
			hintTextField.selectable = false;

			var filter:DropShadowFilter = new DropShadowFilter(5, 45, 0x000000, 1, 5, 5, 0.5);
			hintTextField.filters = [filter];

			container.addChild(hintTextField);
			container.visible = false;

		}


		public function addHintedObject(o:DisplayObject, hintStr:String):void {
			if (!hintDict[o]) {
				o.addEventListener(MouseEvent.ROLL_OVER, rollOverHandler);
				o.addEventListener(MouseEvent.ROLL_OUT, rollOutHandler);
				o.addEventListener(MouseEvent.MOUSE_DOWN, rollOutHandler);
				hintDict[o] = hintStr;
			}
		}

		public function removeHintedObject(o:DisplayObject):void {
			if (hintDict[o]) {
				o.removeEventListener(MouseEvent.ROLL_OVER, rollOverHandler);
				o.removeEventListener(MouseEvent.ROLL_OUT, rollOutHandler);
				o.removeEventListener(MouseEvent.MOUSE_DOWN, rollOutHandler);
				delete hintDict[o];
			}
		}

		private function rollOverHandler(event:MouseEvent):void {
			if (hintDict[event.currentTarget]) {
				delay = 5;
				event.currentTarget.addEventListener(Event.ENTER_FRAME, enterFrameHandler);
			}
		}
		private var delay:int;

		private function enterFrameHandler(event:Event):void {
			delay--;
			if (delay <= 0) {
				if (hintDict[event.currentTarget]) {
					
					updateTextField(hintDict[event.currentTarget].toString());
				}
				if (mouseX > container.stage.stageWidth - hintTextField.width) {
					container.x = container.stage.stageWidth - hintTextField.width - 10;
				} else {
					container.x = mouseX;
				}
				if (mouseY > (container.stage.stageHeight - hintTextField.height - 50)) {
					container.y = mouseY - 22;
				} else {
					container.y = mouseY + 22;
				}
				event.currentTarget.removeEventListener(Event.ENTER_FRAME, enterFrameHandler);
				container.visible = true;
			}
		}

		public var lastW:Number;
		public var lastH:Number;

		public function updateTextField(text:String):void {
			hintTextField.text = text;
		}

		private function rollOutHandler(event:MouseEvent):void {
			event.currentTarget.removeEventListener(Event.ENTER_FRAME, enterFrameHandler);
			container.visible = false;
		}
	}
}