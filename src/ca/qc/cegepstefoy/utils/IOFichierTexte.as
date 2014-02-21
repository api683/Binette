package ca.qc.cegepstefoy.utils {
	
	//Classes AS3
	import flash.errors.IOError;
	import flash.events.Event;
	import flash.events.IOErrorEvent;
	import flash.filesystem.File;
	import flash.filesystem.FileMode;
	import flash.filesystem.FileStream;
	
	/**
	 * @author mrouleau
	 * @link mrouleau@cegep-ste-foy.qc.ca
	 * 
	 * Héritage : FileStream>EventDispatcher>Object
	 * 
	 * Cette classe effectue la lecture et la sauvegarde d'un fichier de texte
	 * dans le répertoire des applications locales du mobile.
	 */
	public class IOFichierTexte extends FileStream {

		//Liste des messages générés
		//Message émit à la lecture, avec succès, du fichier de texte local.
		public static var LECTURE_FICHIER:String = "IOFichierLocal:lecture_fichier";
		//Message émit à la création, avec succès, du fichier de texte local.
		public static var CREATION_FICHIER:String = "IOFichierLocal:creation_fichier";
		//Message émit à la sauvegarde, avec succès, du fichier de texte local.
		public static var SAUVEGARDE_FICHIER:String = "IOFichierLocal:sauvegarde_fichier";
		//Message émit à la l'échec, d'ouverture lecture et sauvegarde du fichier de texte local.
		public static var ERREUR_FICHIER:String = "IOFichierLocal:erreur_fichier";
		
		//Propriété contenant l'objet de fichier à manipuler en ouverture/fermeture.
		private var _fichier:File;
		//Booléenne d'autocréation du fichier, si inexistant.
		private var _autoCreation:Boolean;
		//Propriété contenant le fichier après lecture.
		private var _contenu_fichier:String;
		
		/**
		 * Contruction de la classe.
		 */
		public function IOFichierTexte() 
		{
		}
		
		/**
		 * Fonction de chargement du fichier de texte.
		 * 
		 * @param chemin : chaîne de caractère contenant le nom du fichier à charger.
		 * @param autoCreation : booléenne indiquant si le fichier doit être créer
		 * si celui-ci n'existe pas déjà.
		 */
		public function chargerFichier(chemin:String, autoCreation:Boolean):void {

			//Détermine le dossier de l'application sur mobile
			var dossierFichierApp:File = File.applicationStorageDirectory;	
			//Résout le nom du fichier et son chemin			
			this._fichier= dossierFichierApp.resolvePath(chemin);
			
			//Mémorisation de la booléenne de création automatique.
			this._autoCreation = autoCreation;
			//Définition des écouteurs d'événement de la lecture du fichier.
			this.addEventListener(Event.COMPLETE, surChargementComplet); 
			this.addEventListener(IOErrorEvent.IO_ERROR, surGestionErreur);  
			//Tentative d'ouveture et de lecture du fichier.
			this.openAsync(this._fichier, FileMode.READ);
		}
		
		/**
		 * Fonction de réponse à une erreur générée à l'ouverture du fichier.
		 * Détruit les écouteurs d'événement caduques, et vérifie le numéro de
		 * l'erreur reçu. Si 3003, le fichier est donc inextistant. Si marqué pour
		 * autocréation, crée un nouveau fichier vide, et génère un message de 
		 * création de fichier. Sinon, génère un message d'erreur.
		 * 
		 * @param evenement : evenement de type IOErrorEvent émit par l'écouteur
		 * d'événement défini dans la fonction chargerFichier.
		 */
		private function surGestionErreur(evenement:IOErrorEvent) :void {
			//Retrait des écouteurs caduques
			this.removeEventListener(Event.COMPLETE, surChargementComplet); 
			this.removeEventListener(IOErrorEvent.IO_ERROR, surGestionErreur);  
			if (evenement.errorID == 3003) {
				//détection de l'erreur 3003 (fichier inexistant)
				if (this._autoCreation) 
				{
					//trace("IOFichierLocal:surGestionErreur:autocreation");
					this.open(this._fichier, FileMode.WRITE);
					//fermeture du fichier
					this.close();
					//Envoi du message de création du fichier
					dispatchEvent(new Event(CREATION_FICHIER));
				}
				else
				{
					//trace("Erreur: " + evenement.text + "Fonctionalité d'autocreation désactivée. Le fichier ne sera pas créé!");
					dispatchEvent(new Event(ERREUR_FICHIER));
				}
			}
			else
			{
				//trace("Erreur: " + evenement.text);
				dispatchEvent(new Event(ERREUR_FICHIER));
			}
		}
		
		/**
		 * Fonction de réponse à la réception du contenu du fichier ouvert en lecture.
		 * 
		 * @param evenement : evenement de type Event.COMPLETE généré par l'écouteur
		 * d'événement défini dans la fonction chargerFichier.
		 */
		private function surChargementComplet(evenement:Event):void {  
			this._contenu_fichier = this.readUTFBytes(this.bytesAvailable);
			this.close();
			dispatchEvent(new Event(LECTURE_FICHIER));
		}
		
		/**
		 * Fonction de sauvegarde de texte dans le fichier. Appelé par le controleur.
		 * Crée un objet de manipulation de fichier, et tente l'ouverture de celui-ci en 
		 * y sauvegardant les données reçues en argument. Émet un message de sauvegarde de 
		 * fichier si ouverture et écriture réussie, sinon émet un message d'erreur.
		 * 
		 * @param chemin : nom de fichier à ouvrir en écriture.
		 * @param chaine : texte à sauvegarder dans le fichier.
		 */
		public function sauvegarder(chemin:String, chaine:String):void
		{
			//Détermine le dossier de l'application sur mobile
			var dossierFichierApp:File = File.applicationStorageDirectory;
			//Résout le nom du fichier et son chemin			
			this._fichier= dossierFichierApp.resolvePath(chemin);
			
			try{	
				//Définir un écouteur pour message d'erreur d'écriture		
				this.addEventListener(IOErrorEvent.IO_ERROR, writeIOErrorHandler);
				//Ouvrir le ficheir en écriture seulement
				this.open(this._fichier, FileMode.WRITE);
				//Écrire les données au format UTF-8
				this.writeUTFBytes(chaine);
				//Fermer le fichier
				this.close();
				//Émettre un message de réussite de sauvegarde
				dispatchEvent(new Event(SAUVEGARDE_FICHIER));
			}
			catch (erreur:IOError)
			{
				//Si une erreur est survenur lors de l'ouverture du fichier
				//trace("Erreur d'ouverture dans le fichier. " + erreur.message);
				//Retrirer de l'écouteur d'événement d'erreur
				this.removeEventListener(IOErrorEvent.IO_ERROR, writeIOErrorHandler);
				//Émettre un message d'erreur l'ouverture du fichier
				dispatchEvent(new Event(ERREUR_FICHIER));
			}
		}
			
		/**
		 * Fonction de réponse à un message d'erreur à l'écriture du fichier.
		 * Détruit l'écouteur d'événement caduque, et émet un message d'erreur.
		 * 
		 * @param evenement : evenement de type IOErrorEvent émis par l'écouteur
		 * d'événement défini dans la fonction sauvegarde.
		 */
		private function writeIOErrorHandler(evenement:IOErrorEvent):void
		{
			//Si un erreur est survenue lors de l'écriture
			this.removeEventListener(IOErrorEvent.IO_ERROR, writeIOErrorHandler);
			//Émettre un message d'erreur d'écriture du fichier
			dispatchEvent(new Event(ERREUR_FICHIER));
		}
		
		//Accesseurs et mutateurs
		//Accesseur de la propriété _contenu_ficheir, contenant le résultat de la lecture du fichier.
		public function get contenu_fichier():String
		{
			return this._contenu_fichier;
		}
	}
}