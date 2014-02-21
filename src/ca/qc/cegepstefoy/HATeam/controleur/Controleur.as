package ca.qc.cegepstefoy.HATeam.controleur {
	import flash.display.Sprite;
	import flash.display.StageOrientation;
	import flash.events.Event;
	import flash.display.DisplayObjectContainer;
				
	import ca.qc.cegepstefoy.utils.IOFichierTexte;
	import ca.qc.cegepstefoy.utils.ChargementXML;			
	
	import ca.qc.cegepstefoy.HATeam.modele.Modele;
	import ca.qc.cegepstefoy.HATeam.vues.PageCreationAvatars;
	import ca.qc.cegepstefoy.HATeam.vues.PageGalerieAvatars;
	import ca.qc.cegepstefoy.utils.IOCameraRoll;
	
	/*import ca.qc.cegepstefoy.sauvegardetexte.observateur.GroupeOnglets;
	import ca.qc.cegepstefoy.sauvegardetexte.vues.Onglets;
	import ca.qc.cegepstefoy.sauvegardetexte.utils.ChargementXML;*/
	
	/**
	 * @author mrouleau
	 */
	public class Controleur {
		
		//Contient le modèle de données de l'application
		private var _modeleApplication:Modele;
		
		//Référence à l'objet d'écran d'attente
				
		//Contient la liste des vues de l'application
		private var _listeVues:Object=new Object();
		private var _page_actuelle:String;
		private var _scene:DisplayObjectContainer;
		
		//Nom du fichier de sauvegarde
		private const _FICHIER_SAUVEGARDE:String = "sauvegarde.xml";
		private const _FICHIER_CONFIGURATION:String = "config.xml";
		
		private var _cameraroll:IOCameraRoll;
		private var _conteneur_image:Sprite = new Sprite();
		
		public function Controleur(scene:DisplayObjectContainer) {
			this._scene = scene;
			//Création du modèle de données
			this._modeleApplication=new Modele();

			//Création des vues de l'application
			//Vue Connexion
			this._listeVues.pageCreationAvatar=new PageCreationAvatars(scene, this, this._modeleApplication, "Accueil");
			//Vue liste d'adresses
			this._listeVues.pageGalerieAvatars=new PageGalerieAvatars(scene, this, this._modeleApplication, "Galerie");
			
			//instanciation de l'objet de chargement XML
			var chargementXML:ChargementXML = new ChargementXML();
			//déclaration de l'écouteur de chargement
			chargementXML.addEventListener(ChargementXML.XML_RECU, surConfigurationRecu);
			//chargement du fichier de configuration
			chargementXML.chargerFichierXML(_FICHIER_CONFIGURATION);
		}
				
		public function naviguer(nouvellePage:String):void{
			//Si la nouvelle page est différente de la page courante
			if(nouvellePage!=this._page_actuelle){
				if(this._page_actuelle!=""){
					//ferme la page actuelle
					this._listeVues[this._page_actuelle].decharger();
				}
				//mémorise la nouvelle page
				this._page_actuelle = nouvellePage;
				if(this._page_actuelle=="pageCreationAvatar") {
					this._scene.stage.setAspectRatio("portrait");
				}
				else if(this._page_actuelle=="pageGalerieAvatars") {
					this._scene.stage.setAspectRatio("landscape");
				}
				//ouvre le nouveau formulaire
				this._listeVues[nouvellePage].charger();
			}
		}
		
		private function surConfigurationRecu(evenement:Event):void{
			//retrait de l'écouteur d'événement du chargement XML
			evenement.currentTarget.removeEventListener(ChargementXML.XML_RECU, surConfigurationRecu);
			var chargeur:ChargementXML = evenement.currentTarget as ChargementXML;
			if(chargeur!=null){
				
				//Transfert de la configuration XML dans le modèle de données
				this._modeleApplication.personnage=new XML(chargeur.reception_xml);
				
				this._scene.stage.setAspectRatio("portrait");
				
				this._page_actuelle="pageCreationAvatar";
				this._listeVues[this._page_actuelle].charger();
				
				this.lectureFichier();
			}
		}
		
		private function lectureFichier():void{
			var ioTexte:IOFichierTexte = new IOFichierTexte();
			ioTexte.addEventListener(IOFichierTexte.CREATION_FICHIER, surCreationFichier);
			ioTexte.addEventListener(IOFichierTexte.LECTURE_FICHIER, surLectureFichier);
			ioTexte.addEventListener(IOFichierTexte.ERREUR_FICHIER, surErreurLectureFichier);
			ioTexte.chargerFichier(this._FICHIER_SAUVEGARDE, true);
		}
		
		private function surErreurLectureFichier(evenement:Event):void{
			evenement.currentTarget.removeEventListener(IOFichierTexte.CREATION_FICHIER, surCreationFichier);
			evenement.currentTarget.removeEventListener(IOFichierTexte.LECTURE_FICHIER, surLectureFichier);
			evenement.currentTarget.removeEventListener(IOFichierTexte.ERREUR_FICHIER, surErreurLectureFichier);
		}
		
		private function surCreationFichier(evenement:Event):void{
			evenement.currentTarget.removeEventListener(IOFichierTexte.CREATION_FICHIER, surCreationFichier);
			evenement.currentTarget.removeEventListener(IOFichierTexte.LECTURE_FICHIER, surLectureFichier);
			evenement.currentTarget.removeEventListener(IOFichierTexte.ERREUR_FICHIER, surErreurLectureFichier);
			this.ecritureFichier(this._modeleApplication.donnees);
			this._modeleApplication.personnageCourant=-1;
		}
		
		private function ecritureFichier(donnees_xml:XML):void{
			var ioTexte:IOFichierTexte=new IOFichierTexte();
			ioTexte.addEventListener(IOFichierTexte.SAUVEGARDE_FICHIER, surSauvegardeFichier);
			ioTexte.addEventListener(IOFichierTexte.ERREUR_FICHIER, surErreurSauvegardeFichier);
			ioTexte.sauvegarder(this._FICHIER_SAUVEGARDE, donnees_xml);
		}
		
		private function surErreurSauvegardeFichier(evenement:Event):void{
			evenement.currentTarget.removeEventListener(IOFichierTexte.SAUVEGARDE_FICHIER, surSauvegardeFichier);
			evenement.currentTarget.removeEventListener(IOFichierTexte.ERREUR_FICHIER, surErreurSauvegardeFichier);
			trace("Une erreur est survenue lors de la sauvegarde du fichier des informations!");
		}
		
		private function surSauvegardeFichier(evenement:Event):void{
			evenement.currentTarget.removeEventListener(IOFichierTexte.SAUVEGARDE_FICHIER, surSauvegardeFichier);
			evenement.currentTarget.removeEventListener(IOFichierTexte.ERREUR_FICHIER, surErreurSauvegardeFichier);
			trace("Sauvegarde effectuée avec succès!");
		}
		
		private function surLectureFichier(evenement:Event):void{
			evenement.currentTarget.removeEventListener(IOFichierTexte.CREATION_FICHIER, surCreationFichier);
			evenement.currentTarget.removeEventListener(IOFichierTexte.LECTURE_FICHIER, surLectureFichier);
			evenement.currentTarget.removeEventListener(IOFichierTexte.ERREUR_FICHIER, surErreurLectureFichier);
			var xml_fichier:XML=new XML(evenement.currentTarget.contenu_fichier);
			this._modeleApplication.donnees=xml_fichier;
			if(this._modeleApplication.donnees.personnage.length()>0){
				this._modeleApplication.personnageCourant=0;
			}
			else{
				this._modeleApplication.personnageCourant=-1;
			}
		}
		
		public function ajouterEnregistrement(xml:XML):void {
			this._modeleApplication.ajouterEnregistrement(xml);
			this.ecritureFichier(this._modeleApplication.donnees);
		}
		public function supprimerEnregistrement():void {
			var index:int = this._listeVues.pageGalerieAvatars.avatarSelectionner;
			this._modeleApplication.supprimerEnregistrement(index);
			this.ecritureFichier(this._modeleApplication.donnees);
			this._listeVues.pageGalerieAvatars.supprimerEnregistrement();
		}
		
		//Pour faire la sauvegarde sur Android, ne pas oublier d'activer la permission Write External Storage
		//Fonctions de sauvegarde de l'image*******************************************************************
		public function sauvegarderImage():void
		{
			this._cameraroll.addEventListener(IOCameraRoll.SAUVEGARDE_IMAGE, surSauvegardeImage);
			this._cameraroll.addEventListener(IOCameraRoll.SUPPORT_SAUVEGARDE_IMAGE_ABSENT, supportSauvegardeImage);
			this._cameraroll.addEventListener(IOCameraRoll.ECHEC_SAUVEGARDE_IMAGE, echecSauvegardeImage);
			this._conteneur_image.scaleX=1;
			this._conteneur_image.scaleY=1;
			this._cameraroll.sauvegarderImage();
			var fx:Number = this._scene.stage.stageWidth / this._conteneur_image.width;
			this._conteneur_image.scaleX = fx;
			this._conteneur_image.scaleY = fx;
		}
		private function surSauvegardeImage(evemenement:Event):void
		{
			this.retirerEcouteurSauvegarde();
		}
		private function echecSauvegardeImage(evemenement:Event):void
		{
			this.retirerEcouteurSauvegarde();
		}
		private function supportSauvegardeImage(evemenement:Event):void
		{
			this.retirerEcouteurSauvegarde();
		}
		private function retirerEcouteurSauvegarde():void{
			this._cameraroll.addEventListener(IOCameraRoll.SAUVEGARDE_IMAGE, surSauvegardeImage);
			this._cameraroll.addEventListener(IOCameraRoll.SUPPORT_SAUVEGARDE_IMAGE_ABSENT, supportSauvegardeImage);
			this._cameraroll.addEventListener(IOCameraRoll.ECHEC_SAUVEGARDE_IMAGE, echecSauvegardeImage);
		}
		//Fin des fonctions de sauvegarde de l'image*******************************************************************
		
		public function set conteneur(sprite:Sprite):void{
			this._conteneur_image = sprite;
			this._cameraroll=new IOCameraRoll(this._conteneur_image);
		}
	}
}
