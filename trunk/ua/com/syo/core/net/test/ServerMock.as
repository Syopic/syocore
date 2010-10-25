package ua.com.syo.core.net.test {
	import flash.events.EventDispatcher;
	import flash.events.TimerEvent;
	import flash.utils.Timer;
	
	import ua.com.syo.core.net.connections.events.CommunicateEvent;
	
	public class ServerMock extends EventDispatcher {
		
		private var commandStack:Array;
		private var cEvent:CommunicateEvent;
		
		public function ServerMock() {
			commandStack = new Array();
			var timer:Timer = new Timer(100);
			timer.addEventListener(TimerEvent.TIMER, oneTick);
			timer.start();
			cEvent = new CommunicateEvent(CommunicateEvent.DATA_RECEIVED);
		}
		
		private function oneTick(event:TimerEvent): void {
			if (commandStack.length > 0) {
				sendResponse(commandStack.shift());
			} else if (commandStack.length > 1) {
				sendResponse(commandStack.shift() + commandStack.shift());
			}
		}
		
		public function getRequest(command:String):void {
		}
		
		public function sendResponse(str:String): void {
			cEvent = new CommunicateEvent(CommunicateEvent.DATA_RECEIVED);
			cEvent.command = str;
			dispatchEvent(cEvent as CommunicateEvent);
			cEvent = null;
		}

	}
}