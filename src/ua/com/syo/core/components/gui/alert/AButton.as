package ua.com.syo.core.components.gui.alert {
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	import flash.text.TextField;
	import flash.text.TextFieldAutoSize;
	import flash.text.TextFormat;
	import flash.text.TextFormatAlign;

	public class AButton extends Sprite {

		private var container:MovieClip;
		private var buttonBg:MovieClip;
		
		private var labelText:String;
		
		private var buttonWidth:int = 90;
		private var buttonHeight:int = 29;
		
		public var commandType:String;
		public var command:*;

		public function AButton(label:String, commandT:String, comm:* = null) {
			labelText = label;
			commandType = commandT;
			command = comm;
			init();
		}

		/**
		 * init
		 */
		private function init():void {
			buttonBg = new AlertManager.ButtonBg();
			buttonBg.width = buttonWidth;
			buttonBg.height = buttonHeight;
			buttonBg.stop();
			addChild(buttonBg);
			buildLabel();
			buttonBg.addEventListener(MouseEvent.MOUSE_OVER, mouseOverHandler);
			buttonBg.addEventListener(MouseEvent.MOUSE_OUT, mouseOutHandler);
			buttonBg.addEventListener(MouseEvent.MOUSE_DOWN, mouseDownHandler);
			buttonBg.addEventListener(MouseEvent.MOUSE_UP, mouseUpHandler);
		}

		private function mouseOverHandler(event:MouseEvent):void {
			buttonBg.useHandCursor = true;
			buttonBg.gotoAndStop("over");
		}

		private function mouseOutHandler(event:MouseEvent):void {
			buttonBg.useHandCursor = false;
			buttonBg.gotoAndStop("up");
		}

		private function mouseDownHandler(event:MouseEvent):void {
			buttonBg.gotoAndStop("down");
		}

		private function mouseUpHandler(event:MouseEvent):void {
			buttonBg.gotoAndStop("over");
		}

		/**
		 * build title
		 */
		private function buildLabel():void {
			var format:TextFormat;
			var label:TextField;
			format = new TextFormat();
			format.font = "Verdana";
			format.bold = true;
			format.align = TextFormatAlign.CENTER;
			format.size = 10;
			format.color = 0xcccccc;
			label = new TextField();
			label.autoSize = TextFieldAutoSize.CENTER;
			label.height = 20;
			label.mouseEnabled = false;
			//label.width = buttonWidth;
			label.defaultTextFormat = format;
			label.y = 6;
			label.text = labelText;
			label.x = 0;
			addChild(label);
			resize(label.width);
			label.autoSize = TextFieldAutoSize.NONE;
			label.width = buttonBg.width;
		}
		
		private function resize(w:int):void {
			if (w > buttonWidth) {
				buttonBg.width = w + 32;
			}
		}
	}
}
