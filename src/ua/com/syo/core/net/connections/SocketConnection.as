/**
 * SocketConnection.as		Socket Connection implementation
 * @author					Krivosheya Sergey
 * @link    				http://www.syo.com.ua/
 * @link    				mailto: syopic@gmail.com
 */
package ua.com.syo.core.net.connections {
	import flash.errors.IOError;
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.events.IOErrorEvent;
	import flash.events.ProgressEvent;
	import flash.events.SecurityErrorEvent;
	import flash.events.TimerEvent;
	import flash.net.Socket;
	import flash.utils.ByteArray;
	import flash.utils.Timer;
	
	import ua.com.syo.core.config.Config;
	import ua.com.syo.core.log.Logger;
	import ua.com.syo.core.net.ServerProxy;
	import ua.com.syo.core.net.connections.events.CommunicateEvent;
	
	public class SocketConnection extends Connection {
		
		private var socket:Socket;
		private var sendCommandStack:Array;
		private var receiveCommandStack:Array;
		private var buffer:ByteArray = new ByteArray();
		
		public function SocketConnection(id:String, ca:ConnectionAttributes) {
			super(id, ca);
			
			sendCommandStack = new Array();
			receiveCommandStack = new Array();
		}
		
		/**
		 * Connect to server
		 */
		override public function init():void {
			checkPolicy();
			
			socket = new Socket();
			
			socket.addEventListener(Event.CONNECT, connectSuccesfulHandler);
			socket.addEventListener(ProgressEvent.SOCKET_DATA, dataReceivedHandler);
			
			socket.addEventListener(IOErrorEvent.IO_ERROR, socketIoErrorHandler);
			socket.addEventListener(SecurityErrorEvent.SECURITY_ERROR, onSecurityFailedHandler);
			socket.addEventListener(Event.CLOSE, socketCloseHandler);
			
			socket.addEventListener(Event.ACTIVATE, socketActivateHandler);
			socket.addEventListener(Event.DEACTIVATE, socketDeactivateHandler);
			
			try {
				socket.connect(attributes.serverAdress, attributes.serverPort);
			} catch (e:IOError) {
				Logger.ERROR("connect() : " + e.message);
				dispatchEvent(new CommunicateEvent(CommunicateEvent.CONNECT_FAILED));
			}
		}
		
		/**
		 * Connect to server
		 */
		public function disconnect():void {
			socket.close();
		}
		
		/**
		 * addToSend
		 */
		override public function sendCommand(command:Object):void {
			if (sendCommandStack.length == 0) {
				send(command.toString());
			} else {
				sendCommandStack.push(command);
			}
		}
		
		/** Event handlers ****************************************************/
		
		/**
		 * Connected!!!
		 */
		private function connectSuccesfulHandler(event:Event):void {
			
			// run send/receive timers
			var timerS:Timer = new Timer(Config.tickSendDelay);
			timerS.addEventListener(TimerEvent.TIMER, oneTickSendHandler);
			timerS.start();
			
			var timerR:Timer = new Timer(Config.tickReceiveDelay);
			timerR.addEventListener(TimerEvent.TIMER, oneTickReceiveHandler);
			timerR.start();
			
			dispatchEvent(new CommunicateEvent(CommunicateEvent.CONNECT));
		}
		
		/**
		 * Data received
		 */
		private function dataReceivedHandler(event:ProgressEvent):void {
			//Logger.INFO("Response from server");
			socket.readBytes(buffer, buffer.length, socket.bytesAvailable);
			buffer.position = 0;
			receiveCommandStack.push(buffer);
		}
		
		/**
		 * socketIoErrorHandler
		 */
		private function socketIoErrorHandler(event:IOErrorEvent):void {
			Logger.ERROR("socketIoErrorHandler() : " + event.text);
			dispatchEvent(new CommunicateEvent(CommunicateEvent.CONNECT_FAILED));
			
		}
		
		/**
		 * socketIoErrorHandler
		 */
		private function onSecurityFailedHandler(event:SecurityErrorEvent):void {
			Logger.ERROR("onSecurityFailedHandler() : " + event.text);
			dispatchEvent(new CommunicateEvent(CommunicateEvent.CONNECT_FAILED));
		}
		
		/**
		 * socketCloseHandler
		 */
		private function socketCloseHandler(event:Event):void {
			Logger.DEBUG("socketCloseHandler() : " + "Socket close");
		}
		
		/**
		 * socketActivateHandler
		 */
		private function socketActivateHandler(event:Event):void {
			//Logger.DEBUG("++ socketActivateGandler()");
		}
		
		/**
		 * socketDeactivateHandler
		 */
		private function socketDeactivateHandler(event:Event):void {
			//Logger.DEBUG("-- socketDeactivateHandler()");
		}
		
		
		/******************************************************/
		
		
		
		private function parseReceive(commandArray:Array):void {
			var commandNum:int = commandArray.length;
			// cut last element
			if (commandArray[commandNum - 1] == "") {
				for (var i:int = 0;i < commandNum - 1; i++) {
					receiveCommandStack.push(commandArray[i]);
				}
				buffer = new ByteArray();
				buffer.length = 0;
			}
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
		 * send command
		 * @param command command string
		 */
		private function send(command:String):void {
			try {
				socket.writeUTFBytes((command + attributes.commandEnder));
				socket.flush();
				Logger.trace("[Client]: " + command);
			} catch(e:Error) {
				Logger.ERROR(e.message);
			}
		}
		
		/**
		 * checkPolicy methods
		 */
		private function checkPolicy():void {
			Logger.INFO("Check policy...(xmlsocket)");
			//var secureSocket:XMLSocket = new XMLSocket();
			//Security.loadPolicyFile("xmlsocket://" + Globals.secureServerAddres + ":" + Globals.secureServerPort);
			//secureSocket.addEventListener(SecurityErrorEvent.SECURITY_ERROR, checkPolicyErrorHandler);
		}
		
		private function checkPolicyErrorHandler(event:SecurityErrorEvent):void {
			Logger.ERROR("checkPolicyErrorHandler() : " + event.text);
			dispatchEvent(new CommunicateEvent(CommunicateEvent.CONNECT_FAILED));
		}
		
		override public function destroy():void {
			socket.removeEventListener(Event.CONNECT, connectSuccesfulHandler);
			socket.removeEventListener(ProgressEvent.SOCKET_DATA, dataReceivedHandler);
			
			socket.removeEventListener(IOErrorEvent.IO_ERROR, socketIoErrorHandler);
			socket.removeEventListener(SecurityErrorEvent.SECURITY_ERROR, onSecurityFailedHandler);
			socket.removeEventListener(Event.CLOSE, socketCloseHandler);
			//if (socket.connected) {
				socket.close();
			//}
			socket = null;
		}
	}
}