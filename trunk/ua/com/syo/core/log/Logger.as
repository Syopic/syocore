/**
 * Logger.as			
 * @author				Krivosheya Sergey
 * @link    			http://www.syo.com.ua/
 * @link    			mailto: syopic@gmail.com
 */
package ua.com.syo.core.log {
	import flash.display.Sprite;
	import flash.utils.getTimer;
	
	import ua.com.syo.core.log.targets.ILogTarget;

	public class Logger {

		public static var container:Sprite;
		private static var logTarget:ILogTarget;
		
		/**
		 * trace level
		 * 
		 * 
		 * 1 All messages
		 * 2 INFO
		 * 3 DEBUG
		 * 4 WARNING
		 * 5 ERROR
		 */
		private static var traceLevel:int = 1;

		/**
		 * logger setTarget
		 * @param lPanel visual component for view log
		 */
		public static function setTarget(lTarget:ILogTarget):void {
			logTarget = lTarget;
		}

		/**
		 * set trace level
		 */
		public static function setTraceLevel(level:Number):void {
			traceLevel = level;
		}

		/**
		 * simple tracer
		 */
		public static function trace(str:* = ""):void {
			if (logTarget != null) {
				logTarget.append("[" + getTime() + "]" + str);
			}
		}

		/**
		 * different levels
		 */
		public static function INFO(str:* = ""):void {
			append(str, "INFO", 3, "#0066FF"); 
		}

		public static function DEBUG(str:* = ""):void {
			append(str, "DEBUG", 4, "#006600"); 
		}

		public static function WARNING(str:* = ""):void {
			append(str, "WARNING", 5, "#FF9900"); 
		}

		public static function ERROR(str:* = ""):void {
			append(str, "ERROR", 6, "#FF0000"); 
		}
		
		private static function append(str:*, prefix:String, tLevel:int, color:String):void {
			if (logTarget != null && traceLevel < tLevel) {
				logTarget.append("<font color='" + color + "'>[" + getTime() + "]<b> " + prefix + ": </b> " + str + "</font>");
			}
		}
		
		/**
		 * get time since launch
		 */
		private static function getTime():String {
			return (getTimer() / 1000).toFixed(3);
		}
	}
}