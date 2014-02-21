package ca.qc.cegepstefoy.HATeam.polices {
	import flash.system.Capabilities;
	import flash.text.TextFormat;
	/**
	 * @author etu01
	 */
	dynamic public class FormatsTextes {
		
		[Embed(source='TimesNewRoman.ttf', embedAsCFF="false", fontName="TimesNewRoman", mimeType="application/x-font")]
		protected var TimesNewRoman:Class;
		
		static private var instance:FormatsTextes;
		static public const INIT:String = "init";
		
		static private var _formatChamps:TextFormat = new TextFormat();
		static private var _formatMessage:TextFormat = new TextFormat();
		static private var _formatBouton:TextFormat = new TextFormat();
		
		public function FormatsTextes(renfort:FormatsTextesRenfort) {
			var policeSysteme:String = "TimesNewRoman";
			
			_formatChamps.font = policeSysteme;
			_formatChamps.size = 30;
			_formatChamps.color = 0x444444;
			
			_formatMessage.font = policeSysteme;
			_formatMessage.size = 15;
			_formatMessage.color = 0x000000;
			
			_formatBouton.font = policeSysteme;
			_formatBouton.size = 20;
			_formatBouton.color = 0x444444;
		}
		
		public static function getInstance():FormatsTextes {
			if(FormatsTextes.instance == null) {
				FormatsTextes.instance = new FormatsTextes(new FormatsTextesRenfort());
			}
			return FormatsTextes.instance;
		}
		
		public function get formatChamps():TextFormat {
			return _formatChamps;
		}
		public function set formatChamps(tf:TextFormat):void {
			_formatChamps=tf;
		}
		
		public function get formatMessage():TextFormat {
			return _formatMessage;
		}
		public function set formatPopup(tf:TextFormat):void {
			_formatMessage=tf;
		}
		
		public function get formatBouton():TextFormat {
			return _formatBouton;
		}
		public function set formatBouton(tf:TextFormat):void {
			_formatBouton=tf;
		}
	}
}

class FormatsTextesRenfort {}