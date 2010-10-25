/**
 * CommunicateEvent.as			
 * @author					Krivosheya Sergey
 * @link    				http://www.syo.com.ua/
 * @link    				mailto: syopic@gmail.com
 */
package ua.com.syo.core.net.connections.events {
	import flash.events.Event;

	public class CommunicateEvent extends Event {

		public static var CONNECT:String = "connect";
		public static var DATA_RECEIVED:String = "dataReceived";
		public static var CONNECT_FAILED:String = "connectFailed";

		public function CommunicateEvent(type:String , bubbles:Boolean = false , cancelable:Boolean = false) {
			super(type, bubbles, cancelable);
		}

		public var command:String;
		public var connectionId:String;
	}
}
