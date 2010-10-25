/**
 * ServerProxy.as			server mediator
 * @author					Krivosheya Sergey
 * @link    				http://www.syo.com.ua/
 * @link    				mailto: syopic@gmail.com
 */
 
package ua.com.syo.core.net {
	import flash.events.EventDispatcher;
	import flash.utils.Dictionary;
	
	import ua.com.syo.core.log.Logger;
	import ua.com.syo.core.net.connections.Connection;
	import ua.com.syo.core.net.connections.events.CommunicateEvent;

	public class ServerProxy extends EventDispatcher {
		
		/**
		 * Singleton
		 */
		private static var _instance:ServerProxy;
		
		public static function get instance():ServerProxy {
			
			if (_instance == null) {
				_instance = new ServerProxy();
			}
			
			return _instance;
		}
		
		private var connectionsDict:Dictionary = new Dictionary(true);

		/**
		 * create new connection
		 */
		public function addConnection(connection:Connection):void {
			connectionsDict[connection.id] = connection;
			
			connection.addEventListener(CommunicateEvent.CONNECT, connectSuccesfulHandler);
			connection.addEventListener(CommunicateEvent.CONNECT_FAILED, connectFailedHandler);
			connection.addEventListener(CommunicateEvent.DATA_RECEIVED, dataReceivedHandler);
			
			connection.init();
		}
		
		/**
		 * destroy connection
		 */
		public function destroyConnection(id:String):void {
			(connectionsDict[id] as Connection).destroy();
			connectionsDict[id] = null;
		}
		
		/**
		 * Add command for sending
		 */
		public function sendCommand(command:Object, id:String):void {
			(connectionsDict[id] as Connection).sendCommand(command);
		}
		
		/**
		 * Server received data handler
		 */
		public function dataReceivedHandler(command:*, id:String):void {
			// if parser available
			if ((connectionsDict[id] as Connection).attributes.parser) {
				(connectionsDict[id] as Connection).attributes.parser.parse(command);
			} else {
				// else - dispatch event
				var event:CommunicateEvent = new CommunicateEvent(CommunicateEvent.DATA_RECEIVED);
				event.command = command;
				event.connectionId = id;
				dispatchEvent(event);
			}
		}
		
		/**
		 * Connected!
		 */
		private function connectSuccesfulHandler(event:CommunicateEvent):void {
			dispatchEvent(new CommunicateEvent(CommunicateEvent.CONNECT));
		}
		
		/**
		 * Connect failed handler
		 */
		private function connectFailedHandler(event:CommunicateEvent):void {
			dispatchEvent(new CommunicateEvent(CommunicateEvent.CONNECT_FAILED));
			Logger.ERROR("Connect failed!");
		}
		
		
	}
}

