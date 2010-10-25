/**
 * LogPanel.as			log trace visualization 
 * @author				Krivosheya Sergey
 * @link    			http://www.syo.com.ua/
 * @link    			mailto: syopic@gmail.com
 */
package ua.com.syo.core.log.targets {
	import flash.display.Bitmap;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.events.TimerEvent;
	import flash.system.System;
	import flash.text.TextField;
	import flash.text.TextFieldType;
	import flash.text.TextFormat;
	import flash.utils.Timer;
	import flash.utils.getTimer;
	
	public class LogPanel extends Sprite implements ILogTarget {
		
		private var outputTextfield:TextField;
		private var auto:Boolean;
		private var startTick:Number;
		private var numFrames:Number = 0;
		private var fpsLabel:TextField;
		private var memoryLabel:TextField;
		private var format:TextFormat;
		private var logArray:Array = new Array();
		private var logCounter:int = 0;
		private var activeBar:Sprite;

		
		private var barW:int = 150;
		private var barH:int = 18;
		private var outputH:int = 100;
		private var maxLogLength:int = 300;
		
		private var oldStageH:int;
		private var oldStageW:int;
		/**
		 * constructor
		 */
		public function LogPanel(d:Sprite , autoshow:Boolean = true) {
			d.addChild(this);
			create();
			this.auto = autoshow;
			d.addEventListener(Event.RESIZE, adjustSize);
		}

		/**
		 * creates the panel on the sprite
		 */
		private function create():void {
			// active bar
			activeBar = new Sprite();
			activeBar.graphics.beginFill(0xAAAAAA, 0.6);
			activeBar.graphics.drawRect(0, 0, barW, barH);
			
			format = new TextFormat();
			format.font = "Courier New";
			format.size = 11;
			format.color = 0x000000;
			fpsLabel = new TextField();
			fpsLabel.height = barH;
			fpsLabel.mouseEnabled = false;
			memoryLabel = new TextField();
			memoryLabel.height = barH;
			memoryLabel.x = 55;
			memoryLabel.mouseEnabled = false;
			// output text field
			outputTextfield = new TextField();
			outputTextfield.y = barH;
			outputTextfield.type = TextFieldType.INPUT;
			outputTextfield.background = true;
			outputTextfield.backgroundColor = 0xEEEEEE;
			outputTextfield.height = outputH;
			outputTextfield.multiline = true;
			outputTextfield.wordWrap = true;
			outputTextfield.defaultTextFormat = format;
			format.color = 0x222222;
			fpsLabel.defaultTextFormat = format;
			memoryLabel.defaultTextFormat = format;
			activeBar.addEventListener(MouseEvent.CLICK, toggle);
			addEventListener(Event.ENTER_FRAME, onTick);
			
			addChild(activeBar);
			addChild(fpsLabel);
			addChild(memoryLabel);

			outputTextfield.addEventListener(MouseEvent.CLICK, mouseClickHandler);

			initFPS();
		}
		
		private function mouseClickHandler(event:MouseEvent): void {
			//append("Log copied to clipboard"); 
			System.setClipboard(outputTextfield.text);
			if (event.currentTarget.mouseX > (stage.stageWidth - 20) ) {
				clear();
			} 
		}
		
		/**
		 * init FPS counter
		 */
		private function initFPS():void {
			startTick = getTimer();
			var t:Timer = new Timer(1000);
			t.addEventListener(TimerEvent.TIMER, timerHandler);
			t.start();
			adjustSize(new Event(Event.RESIZE));
			
			timerHandler(null);
		}

		private function timerHandler(event:TimerEvent):void {
			fpsLabel.text = "FPS:" + numFrames;
			memoryLabel.text = "MEM:" + (Math.round(((System.totalMemory / 1024) / 1024) * 10)) / 10 + " MB";
			numFrames = 0;
			
			if(stage)
				if (oldStageH != stage.stageHeight || oldStageW != stage.stageWidth) {
					adjustSize(new Event(Event.RESIZE));
				}
		}

		/**
		 * show FPS and Memory usage
		 */
		public function onTick(event:Event):void {
			numFrames++;
		}

		/**
		 * adjusts the size of the panel depending on the stage
		 */
		public function adjustSize(e:Event):void {
			if (stage) {
				outputTextfield.width = stage.stageWidth;
				this.y = stage.stageHeight - this.height;
				
				oldStageH = stage.stageHeight;
				oldStageW = stage.stageWidth;
			}
		}

		/**
		 * toggles the output panel
		 */
		private function toggle(e:Event = null):void {
			if(contains(outputTextfield)) {
				removeChild(outputTextfield);
			}else {
				addChild(outputTextfield);
			}
			adjustSize(new Event(Event.RESIZE));
		}

		/**
		 * add new string
		 */
		public function append(message:String):void {
			if (++logCounter > maxLogLength) {
				clear();
			}

			outputTextfield.defaultTextFormat = format;
			outputTextfield.htmlText += message;

			outputTextfield.scrollV = outputTextfield.maxScrollV;
			if( auto && !contains(outputTextfield) ) toggle();
		}

		/**
		 * clear log
		 */
		public function clear():void {
			outputTextfield.htmlText = "";
			logCounter = 0;
		}
	}
}
