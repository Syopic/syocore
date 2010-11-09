/**
 * CursorManager.as	
 * @author			Krivosheya Sergey
 * @link    		http://www.syo.com.ua/
 * @link    		mailto: syopic@gmail.com
 */
package ua.com.syo.core.components.gui.cursor {
	import flash.display.DisplayObject;
	import flash.display.Sprite;
	import flash.display.Stage;
	import flash.events.Event;
	import flash.utils.Dictionary;
	
	public class CursorManager {
		
		private static var stageContainer:Stage;
		private static var cursorDict:Dictionary;
		private static var behaviorFunctionDict:Dictionary;
		private static var containerDict:Dictionary;
		
		/**
		 * initialization
		 * @param sContainer - link to stage object
		 */
		public static function init(sContainer:Stage):void {
			stageContainer = sContainer;
			/// init dicts
			cursorDict = new Dictionary(true);
			behaviorFunctionDict = new Dictionary(true);
			containerDict = new Dictionary(true);
			
			stageContainer.addEventListener(Event.ENTER_FRAME, enterFrameHandler);
		}
		
		/**
		 * mouseMoveHandler
		 */
		private static function enterFrameHandler(event:Event):void {
			for (var idKey:Object in cursorDict){
				if (cursorDict[idKey] && containerDict[idKey]) {
					var cCursor:DisplayObject = cursorDict[idKey] as DisplayObject;
					if (behaviorFunctionDict[idKey]) {
						// call callback function
						(behaviorFunctionDict[idKey] as Function).call(CursorManager, cCursor, stageContainer.mouseX, stageContainer.mouseY);
					} else {
						// move cursor traditionaly
						cCursor.x = stageContainer.mouseX;
						cCursor.y = stageContainer.mouseY;
					}
				}
			}
		}
		
		/**
		 * add cursor
		 * @param cCursor - display object for cursor img
		 * @param container - addChild container
		 * @param id - id 
		 * @param behaviorFunction - callback function for specific begavior description ( callback function have 3 parameters: cursor displayObject, currentX, currentY)
		 */
		public static function setCursor(id:String, cCursor:Sprite, container:Sprite, behaviorFunction:Function = null):void {
			var tSprite:Sprite = new Sprite();
			cCursor.name = "inCur";
			tSprite.addChild(cCursor);
			container.addChild(tSprite);
			cursorDict[id] = tSprite;
			containerDict[id] = container;
			if (behaviorFunction != null) {
				behaviorFunctionDict[id] = behaviorFunction;
			}
		} 
		
		/**
		 * move cursor icon into container
		 * @param id - id 
		 * @param xOffset - dx
		 * @param yOffset - dy
		 */
		public static function changeOffsets(id:String, xOffset:Number = 0, yOffset:Number = 0):void {
			if (cursorDict[id]) {
				var cDO:DisplayObject = (cursorDict[id] as Sprite).getChildByName("inCur");
				cDO.x = xOffset;
				cDO.y = yOffset;
			}
		}
		
		/**
		 * remove cursor icon from container
		 * @param id - id 
		 */
		public static function removeCursor(id:String):void {
			if (cursorDict[id] && containerDict[id]) {
				(containerDict[id] as Sprite).removeChild((cursorDict[id] as Sprite));
				delete containerDict[id];
				delete cursorDict[id];
				delete behaviorFunctionDict[id];
			}
		}
		
		/**
		 * remove all cursor icons from containers
		 */
		public static function removeAllCursors():void {
			for (var idKey:Object in cursorDict){
				removeCursor(idKey.toString());
			}
		}
		
		/**
		 * show cursor
		 * @param id - id 
		 */
		public static function showCursor(id:String):void {
			if (cursorDict[id] && containerDict[id]) {
				(cursorDict[id] as Sprite).visible = true;
			}
		}
		
		/**
		 * hide cursor
		 * @param id - id 
		 */
		public static function hideCursor(id:String):void {
			if (cursorDict[id] && containerDict[id]) {
				(cursorDict[id] as Sprite).visible = false;
			}
		}
		
		/**
		 * show all cursors
		 */
		public static function showAllCursors():void {
			for (var idKey:Object in cursorDict){
				showCursor(idKey.toString());
			}
		}
		
		/**
		 * hide all cursors
		 */
		public static function hideAllCursors():void {
			for (var idKey:Object in cursorDict){
				hideCursor(idKey.toString());
			}
		}
		

	}
}



