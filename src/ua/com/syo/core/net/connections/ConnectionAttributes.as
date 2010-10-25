package ua.com.syo.core.net.connections {
	import ua.com.syo.core.net.cmd.ICommandParser;

	public class ConnectionAttributes {
		
		public var serverAdress:String;
		public var serverPort:int;
		
		public var policyURLS:Array;
		
		public var commandEnder:String;
		
		public var parser:ICommandParser;
		
		public function ConnectionAttributes(adress:String = "", port:int = 0) {
			serverAdress = adress;
			serverPort = port;
		}
		
		public function setParser(p:ICommandParser):void {
			parser = p;
		}
	}
}