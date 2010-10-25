package ua.com.syo.core.net.connections {
	import flash.events.EventDispatcher;
	
	public class Connection extends EventDispatcher {
		
		public var attributes:ConnectionAttributes;
		public var id:String;
		
		public function Connection(id:String, ca:ConnectionAttributes):void {
			this.id = id;
			attributes = ca;
		}
		
		public function init():void {
			
		}
		public function sendCommand(command:Object):void {
			
		}
		public function destroy():void {
			
		}
	}
}