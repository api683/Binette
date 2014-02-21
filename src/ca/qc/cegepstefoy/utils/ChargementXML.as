package ca.qc.cegepstefoy.utils{
	
	//Classes AS3
	import flash.events.EventDispatcher;
	import flash.events.Event;
	import flash.net.URLRequest;
	import flash.net.URLLoader;
	import flash.events.IOErrorEvent;
	
	/**
	 * @author Michel Rouleau
	 * @link mrouleau@cegep-ste-foy.qc.ca
	 * 
	 * Héritage : EventDispatcher>Object
	 * 
	 * Cette classe effectue le chargement d'un fichier XML et stocke les
	 * données chargées pour usage ultérieur.
	 */
	public class ChargementXML extends EventDispatcher{
		
		//définition du message à envoyer lors de la réception des données
		public static var XML_RECU:String="ChargementXML_xml_recu";
		//variable contenant le XML chargé	
		private var _reception_xml:XML = new XML(); 
		
		/**
		* Constructeur de la classe de chargement de fichier XML.
		*/ 
		public function ChargementXML():void {
		}
		
		/**
		 * Fonction de chargement du fichier XML. Défini la requête, contruit l'objet
		 * de chargement et déclare les écouteurs d'événement. Tente ensuite le chargement
		 * du fichier passé en argument.
		 * 
		 * @param	url : chaine de caractère de l'url complet du fichier à charger
		 */
		public function chargerFichierXML(url:String):void {
			//initialisation de l'objet de requête
			var requete_urq:URLRequest=new URLRequest(url);
			//initialisation de l'objet de chargement
			var chargement_ldr:URLLoader=new URLLoader();
			//création de l'écouteur COMPLETE de l'objet de chargement
			chargement_ldr.addEventListener(Event.COMPLETE, surChargementXMLCompleter);
			//création de l'écouteur IO_ERROR de l'objet de chargement
			chargement_ldr.addEventListener(IOErrorEvent.IO_ERROR,surErreurChargement);
			//début du chargement
			chargement_ldr.load(requete_urq);
		}
		
		/**
		 * Fonction de réponse à la réception du fichier XML chargé. Appelée par
		 * l'écouteur d'événement COMPLETE, défini dans la fonction chargerFichierXML.
		 * Détruit les écouteurs d'événement caduques. Transfert les données dans la à
		 * variable de réception, et émets un message de réception.
		 * 
		 * @param	evenement : événement de chargement complété de l'objet de chargement.
		 */
		private function surChargementXMLCompleter(evenement:Event):void {
			//destruction des l'écouteurs d'événement de l'objet de chargement
			evenement.currentTarget.removeEventListener(Event.COMPLETE, surChargementXMLCompleter);
			evenement.currentTarget.removeEventListener(IOErrorEvent.IO_ERROR,surErreurChargement);
			//récupération du flux de données et vérification de l'objet déclencheur
			var donneesRecues_ldr:URLLoader = evenement.currentTarget as URLLoader;
			//si l'objet déclencheur est bien de type URLLoader
			if (donneesRecues_ldr!=null) {
				//stocker les données reçues dans la propriété privée XML
				this._reception_xml=new XML(donneesRecues_ldr.data);
				//émission du message de reception du xml
				dispatchEvent(new Event(ChargementXML.XML_RECU));
			}else{
				trace("Une erreur est survenue au chargement des données XML");
			}
		}
		
		/**
		 * Fonction de réponse à un message d'erreur au chargement. Appelée
		 * par l'écouteur d'événement IOErrorEvent défini dans la fonction
		 * chargerFichierXML. Détruit les écouteurs d'événement caduques et 
		 * affiche un message dans la console.
		 * 
		 * @param	evenement : événement d'erreur de chargement.
		 */
		private function surErreurChargement(evenement:IOErrorEvent):void {
			//destruction des l'écouteurs d'événement de l'objet de chargement
			evenement.currentTarget.removeEventListener(Event.COMPLETE, surChargementXMLCompleter);
			evenement.currentTarget.removeEventListener(IOErrorEvent.IO_ERROR,surErreurChargement);
			trace("Erreur: "+evenement);
		}
		
		//Accesseurs & mutateurs
		//Accesseur de la propriété _reception_xml
		public function get reception_xml():XML{
			return this._reception_xml;
		}
	}
}