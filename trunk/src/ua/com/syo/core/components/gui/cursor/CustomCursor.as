/**
 * StageViewManager.as	
 * @author				Krivosheya Sergey
 * @link    			http://www.syo.com.ua/
 * @link    			mailto: syopic@gmail.com
 */
package ua.com.syo.core.components.gui.cursor {
	import flash.display.DisplayObject;
	import flash.display.Sprite;

	public class CustomCursor extends Sprite {

		private var cursorContainer:DisplayObject;
		
		/**
		 * constructor
		 * @param LibraryClass - embeded img asset class
		 * @param xOffset - dx
		 * @param yOffset - dy
		 */
		public function CustomCursor(LibraryClass:Class, xOffset:Number = 0, yOffset:Number = 0) {
			cursorContainer = new LibraryClass();
			cursorContainer.x += xOffset;
			cursorContainer.y += yOffset;
			addChild(cursorContainer);
		}

	}
}

