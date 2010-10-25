/**
 * CommandBuilder.as		string command builder
 * @author					Krivosheya Sergey
 * @link    				http://www.syo.com.ua/
 * @link    				mailto: syopic@gmail.com
 */
package ua.com.syo.core.net.cmd {

	import flash.net.URLVariables;
	

	public class CommandBuilder {

		/**
		 * merge all params
		 */
		public static function build(...statements):Object {

			var result:URLVariables = new URLVariables();
			/*(statements as Array).push("sk=" + Globals.authKey);
			(statements as Array).push("uid=" + Globals.viewerId);
			for(var i:int = 0; i < statements.length; i++) {

				if (statements[i]) {
					result[statements[i].split(Globals.SERVER_COMMAND_SEPARATOR)[0]] = statements[i].split(Globals.SERVER_COMMAND_SEPARATOR)[1];
				}
			}*/
			return result;
		}
		
		/**
		 * merge all params for API
		 */
		public static function buildAPI(sep:String, ...statements):Object {

			var result:URLVariables = new URLVariables();
			for(var i:int = 0; i < statements.length; i++) {

				if (statements[i]) {
					result[statements[i].split(sep)[0]] = statements[i].split(sep)[1];
				}
			}
			return result;
		}
	}
}
