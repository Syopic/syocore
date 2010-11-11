/**
 * Alert.as				alert
 * @author				Krivosheya Sergey
 * @link    			http://www.syo.com.ua/
 * @link    			mailto: syopic@gmail.com
 */
package ua.com.syo.core.components.gui.alert {
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.filters.DropShadowFilter;
	import flash.net.URLRequest;
	import flash.net.navigateToURL;
	import flash.text.TextField;
	import flash.text.TextFieldAutoSize;
	import flash.text.TextFieldType;
	import flash.text.TextFormat;
	import flash.text.TextFormatAlign;

	public class Alert extends Sprite {

		private var titleText:String;
		private var messageText:String;
		private var container:Sprite;
		private var buttonsArray:Array;
		private var control:String;

		private var alertBg:Sprite;
		private var alertMc:Sprite;
		private var modalMc:MovieClip;

		private var titleLabel:TextField;
		private var messageLabel:TextField;
		private var inputTF:TextField;

		private var callParam:*;


		/**
		 * constructor
		 */
		public function Alert(titleStr:String, messageStr:String, isModal:Boolean, cont:Sprite, buttons:Array, addControl:String = null) {
			container = cont;
			titleText = titleStr;
			messageText = messageStr;
			buttonsArray = buttons;
			control = addControl;

			alertBg = new AlertManager.AlertBg();
			alertMc = new MovieClip();
			alertBg.width = 300;
			alertBg.height = 100;

			if (isModal) {
				container.addChild(getModalMc());
			}

			alertMc.addChild(alertBg);
			container.addChild(alertMc);

			var filter:DropShadowFilter = new DropShadowFilter(3, 45, 0x000000, 1, 6, 6, 0.5);
			alertBg.filters = [filter];

			titleLabel = new TextField();
			messageLabel = new TextField();

			if (control == "textField") {
				inputTF = new TextField();
				buildInput();
			}

			buildButtons();
			buildTitle();
			buildMessage();

			resize(alertBg.width, alertBg.height);


			for (var i:int = 0; i < buttonsArray.length; i++) {
				var ab:AButton = buttonsArray[i];
				ab.y = alertBg.height - 45;
			}
			centerAlert(AlertManager.stageW, AlertManager.stageH);
		}


		/**
		 * build title
		 */
		private function buildTitle():void {
			var format:TextFormat;
			format = new TextFormat();
			format.font = "Verdana";
			format.align = TextFormatAlign.CENTER;
			format.bold = true;
			format.size = 16;
			format.color = 0xdddddd;

			titleLabel.height = 40;
			titleLabel.width = alertBg.width - 20;
			titleLabel.mouseEnabled = false;
			titleLabel.defaultTextFormat = format;
			titleLabel.x = 10;
			titleLabel.y = 10;
			titleLabel.text = titleText;
			alertMc.addChild(titleLabel);
		}

		/**
		 * build message
		 */
		private function buildMessage():void {
			var format:TextFormat;
			format = new TextFormat();
			format.font = "Verdana";
			format.size = 12;
			format.color = 0x000000;
			format.bold = true;
			format.align = TextFormatAlign.CENTER;

			messageLabel.multiline = true;
			messageLabel.autoSize = TextFieldAutoSize.CENTER;
			messageLabel.wordWrap = true;
			messageLabel.width = alertBg.width - 20;
			//messageLabel.mouseEnabled = false;
			messageLabel.defaultTextFormat = format;
			messageLabel.x = 10;
			messageLabel.y = 55;
			messageLabel.text = messageText;

			alertBg.height = messageLabel.height + 60
			if (control == "textField") {
				alertBg.height += 100;
			}

			if (buttonsArray.length) {
				alertBg.height += 55;
			}
			alertMc.addChild(messageLabel);
		}

		/**
		 * buildInput
		 */
		private function buildInput():void {
			var format:TextFormat;
			format = new TextFormat();
			format.font = "Verdana";
			format.size = 10;
			format.color = 0x000000;
			format.bold = true;

			inputTF.type = TextFieldType.INPUT;
			inputTF.border = true;
			inputTF.multiline = true;
			inputTF.wordWrap = true;
			inputTF.background = true;
			inputTF.backgroundColor = 0xDEC998;
			inputTF.height = 50;
			inputTF.defaultTextFormat = format;

			alertMc.addChild(inputTF);
		}

		private function buildButtons():void {
			var buttonsBlockW:int = 0;

			for (var w:int = 0; w < buttonsArray.length; w++) {
				buttonsBlockW += ((buttonsArray[w] as AButton).width + 14);
			}
			buttonsBlockW -= 10;

			//resize(buttonsBlockW + 30, alertBg.height);

			var dx:int = 0;

			for (var i:int = 0; i < buttonsArray.length; i++) {
				var ab:AButton = buttonsArray[i];
				ab.y = alertBg.height - 45;
				ab.x = dx + alertBg.width / 2 - buttonsBlockW / 2;
				dx += ab.width + 10;
				ab.addEventListener(MouseEvent.MOUSE_DOWN, pressButtonHandler);
				alertMc.addChild(ab);
			}
		}

		private function pressButtonHandler(event:MouseEvent):void {

			var ab:AButton = (event.currentTarget as AButton);

			if (ab.commandType == "cancel") {
				remove();
				dispatchEvent(new Event(Event.CANCEL));
			}

			if (ab.commandType == "call" && ab.command is Function) {
				if (inputTF) {
					(ab.command as Function).call(null, inputTF.text);
				} else {
					(ab.command as Function).call();
				}
				remove();
			}

			if (ab.commandType == "url") {
				navigateToURL(new URLRequest(ab.command), "blank");
				remove();
			}
		}

		public function centerAlert(w:int, h:int):void {
			alertMc.x = Math.round(w / 2 - alertBg.width / 2);
			alertMc.y = Math.round(h / 2 - alertBg.height / 2);
			modalMc.width = AlertManager.stageW;
			modalMc.height = AlertManager.stageH;
		}

		private function getModalMc():MovieClip {

			if (!modalMc) {
				modalMc = new MovieClip();
				modalMc.graphics.beginFill(0x000000, 0.3);
				modalMc.graphics.drawRect(0, 0, AlertManager.stageW, AlertManager.stageH);
			}

			modalMc.visible = true;

			return modalMc;
		}

		public function remove():void {

			if (container.contains(alertMc)) {
				container.removeChild(alertMc);
			}
			if (modalMc && container.contains(modalMc)) {
				container.removeChild(modalMc);
			}
		}

		public function resize(w:int, h:int):void {
			if (w < 250) {
				w = 250;
			}
			alertBg.width = w;
			alertBg.height = h;
			messageLabel.x = 10;
			messageLabel.width = messageLabel.width;

			if (inputTF) {
				inputTF.width = alertBg.width - 30;
				inputTF.y = messageLabel.y + messageLabel.height + 5;
				inputTF.x = 15;
			}

			titleLabel.x = 10;
			titleLabel.width = titleLabel.width;
		}
	}
}


