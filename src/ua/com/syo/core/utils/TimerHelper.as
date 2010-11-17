package ua.com.syo.core.utils {
	import flash.events.TimerEvent
	import flash.utils.Timer

	public class TimerHelper {

		public static function once(milliseconds:int, action:Function):void {
			var timer:Timer = new Timer(milliseconds, 1)
			timer.addEventListener(TimerEvent.TIMER, function(event:TimerEvent):void {
				action();
			})
			timer.start();
		}
	}
}
