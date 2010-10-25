/**
 * ServerMockConnection.as	connection implements for offline mode
 * @author					Krivosheya Sergey
 * @link    				http://www.syo.com.ua/
 * @link    				mailto: syopic@gmail.com
 */
 
package ua.com.syo.core.net.connections {
	import flash.events.EventDispatcher;
	import flash.events.TimerEvent;
	import flash.utils.Timer;
	
	import ua.com.syo.core.config.Config;
	import ua.com.syo.core.log.Logger;
	import ua.com.syo.core.net.ServerProxy;
	import ua.com.syo.core.net.connections.events.CommunicateEvent;
	import ua.com.syo.core.net.test.ServerMock;
	
	public class ServerMockConnection extends Connection {
		
		// for offLine mode
		public var serverMock:ServerMock;

		private var sendCommandStack:Array;
		private var receiveCommandStack:Array;
		
		/**
		 * Constructor
		 */
		public function ServerMockConnection(id:String, ca:ConnectionAttributes) {
			super(id, ca);
			sendCommandStack = new Array();
			receiveCommandStack = new Array();
		}
		
		/**
		 * Connect to mock server
		 */
		override public function init():void {
			//serverMock = new ServerMock();
			
			serverMock.addEventListener(CommunicateEvent.DATA_RECEIVED, dataReceivedHandler);
			
			// run send/receive timers
			var timerS:Timer = new Timer(100);
			timerS.addEventListener(TimerEvent.TIMER, oneTickSendHandler);
			timerS.start();
			
			var timerR:Timer = new Timer(100);
			timerR.addEventListener(TimerEvent.TIMER, oneTickReceiveHandler);
			timerR.start();
			
			dispatchEvent(new CommunicateEvent(CommunicateEvent.CONNECT));
		}
		
		/**
		 * timers handlers
		 */
		private function oneTickSendHandler(event:TimerEvent):void {
			if (sendCommandStack.length > 0) {
				send(sendCommandStack.shift());
			}
		}

		private function oneTickReceiveHandler(event:TimerEvent):void {
			if (receiveCommandStack.length > 0) {
				ServerProxy.instance.dataReceivedHandler(receiveCommandStack.shift(), id);
			}
		}
		
		/**
		 * data received from serverMock
		 */
		private function dataReceivedHandler(event:CommunicateEvent):void {
			//add command in stack
			receiveCommandStack.push(event.command);
		}
		
		/**
		 * send command
		 * @param command command string
		 */
		override public function sendCommand(command:Object):void {
			send(command);
		}
		
		/**
		 * send command
		 * @param command command string
		 */
		public function send(command:Object):void {
			serverMock.getRequest(command.toString());
		}
	}
}