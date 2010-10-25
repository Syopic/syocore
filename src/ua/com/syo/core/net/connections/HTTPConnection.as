package ua.com.syo.core.net.connections {
	import flash.events.Event;
	import flash.events.IOErrorEvent;
	import flash.events.TimerEvent;
	import flash.net.URLLoader;
	import flash.net.URLRequest;
	import flash.net.URLRequestMethod;
	import flash.net.URLVariables;
	import flash.utils.ByteArray;
	import flash.utils.Timer;
	
	import ua.com.syo.core.log.Logger;
	import ua.com.syo.core.net.ServerProxy;
	import ua.com.syo.core.net.connections.events.CommunicateEvent;
	
	public class HTTPConnection extends Connection {
		
		private var loader:URLLoader;
		private var apiLoader:URLLoader;
		private var noCashe:int = 0;
		private var request:URLRequest;
		private var apiRequest:URLRequest;
		private var buffer:ByteArray = new ByteArray();
		
		private var isHttpSend:Boolean = false;
		
		private var sendCommandStack:Array;
		
		
		private var requestVars:URLVariables;
		
		
		public function HTTPConnection(id:String, ca:ConnectionAttributes) {
			super(id, ca);
			
			sendCommandStack = new Array();
		}
		
		/**
		 * Connect to server
		 */
		override public function init():void {
			
			requestVars = new URLVariables();
			
			loader = new URLLoader();
			loader.addEventListener(Event.COMPLETE, completeHandler);
			loader.addEventListener(IOErrorEvent.IO_ERROR, ioErrorHandler);
			
			request = new URLRequest();
			
			apiRequest = new URLRequest();
			
			// run send/receive timers
			var timerS:Timer = new Timer(50);
			timerS.addEventListener(TimerEvent.TIMER, oneTickSendHandler);
			timerS.start();
			
			dispatchEvent(new CommunicateEvent(CommunicateEvent.CONNECT));
		}
		
		/**
		 * timers handlers
		 */
		private function oneTickSendHandler(event:TimerEvent):void {
			if (!isHttpSend && sendCommandStack.length > 0) {
				send(sendCommandStack.shift());
			}
		}
		
		override public function sendCommand(command:Object):void {
			if (!isHttpSend && sendCommandStack.length == 0) {
				send(command);
			} else {
				sendCommandStack.push(command);
			}
		}
		
		
		
		/**
		 * send command
		 * @param command command string
		 */
		public function send(command:Object):void {
			   Logger.trace("[Client] srv: " + command['srv']);
			   Logger.trace("[Client] cmd: " + command['cmd']);
			   
			   request = new URLRequest("");
			   
			   requestVars = command['cmd'] as URLVariables;
			   request.data = objectToURLVariables(command['cmd']);
			   request.method = URLRequestMethod.POST;
			   Logger.trace("[Client] cmd: " + request.data);
			   try {
					loader.load(request);
					isHttpSend = true;
			   } catch (error:Error) {
					Logger.ERROR("send() : " + error.message);
			   }
            
  		}
  
  private static function objectToURLVariables(parameters:Object):URLVariables {
            var paramsToSend:URLVariables = new URLVariables();
            for(var i:String in parameters) {
                if(i!=null) {
                    if(parameters[i] is Array) paramsToSend[i] = parameters[i];
                    else paramsToSend[i] = parameters[i].toString();
                }
            }
        return paramsToSend;
  }
		
		
		/**
		 * Came the answer
		 */
		private function completeHandler(event:Event):void {
			parseReceive((loader.data as String).split(attributes.commandEnder));
			isHttpSend = false;
		}
		
		private function parseReceive(commandArray:Array):void {
			var commandNum:int = commandArray.length;
			// cut last element
			if (commandArray.length > 0) {
				for (var i:int = 0; i < commandNum; i++) {
					if (commandArray[i] !="") {
						addReceiveCommand(commandArray[i]);
					}
				}
				buffer = new ByteArray();
				buffer.length = 0;
			}
		}
		
		/**
		 * add command in stack
		 */
		private function addReceiveCommand(command:String):void {
			ServerProxy.instance.dataReceivedHandler(command, id);
		}
		
		
		/**
		 * No any connection
		 */
		private function ioErrorHandler(event:IOErrorEvent):void {
			Logger.ERROR("ioErrorHandler() : " + event.text);
		}
	}
}