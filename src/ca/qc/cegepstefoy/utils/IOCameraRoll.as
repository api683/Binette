package ca.qc.cegepstefoy.utils { 
        
	import flash.events.ErrorEvent;
	import flash.display.DisplayObjectContainer;
	import flash.media.CameraRoll;
    import flash.media.MediaPromise;
    
	
	import flash.display.BitmapData;
	import flash.display.Loader;
	import flash.display.LoaderInfo;	
		
	import flash.events.IOErrorEvent;
	import flash.events.Event;
	import flash.events.MediaEvent;	
	
	/**
	 * @author mrouleau
	 * 
	 * Héritage : IOCameraRoll>CameraRoll>EventDispatcher>Object
	 * 
	 * Cette classe encapsule les fonctionnalité relative au CameraRoll du mobile.
	 * Elle sert principalement à simplifier son utilisation, et à émettre des messages de
	 * bon fonctionnement ou d'erreur.
	 */
	public class IOCameraRoll extends CameraRoll{
		
		//Liste des messages émis par la classe
		
		//Message émit lors de la sélection d'une image dans le sélecteur
		public static var SELECTION_IMAGE:String="IOCameraRoll:selection_image";
		//Message émit lors de l'annulation de la sélection d'image par l'utilisateur
		public static var SELECTION_IMAGE_CANCEL:String="IOCameraRoll:selection_image_cancel";
		//Message émit lors d'une erreur dans la sélection d'une image
		public static var SELECTION_IMAGE_ERREUR:String="IOCameraRoll:selection_image_erreur";
		//Message émit lorsque l'appareil ne support pas la sélection d'image
		public static var SUPPORT_SELECTION_IMAGE_ABSENT:String="IOCameraRoll:support_selection_image_absent";
		//Message émit lors du chargement d'image réussi
		public static var CHARGEMENT_IMAGE:String="IOCameraRoll:chargement_image";
		//Message émit lors de l'échec du chargement de l'image
		public static var ECHEC_CHARGEMENT_IMAGE:String="IOCameraRoll:echec_chargement_image";
		//Message émit lorsque l'appareil ne supporte pas la sauvegarde de l'image
		public static var SUPPORT_SAUVEGARDE_IMAGE_ABSENT:String="IOCameraRoll:support_sauvegarde_image_absent";
		//Message émit lors de la sauvegarde de l'image réussie
		public static var SAUVEGARDE_IMAGE:String="IOCameraRoll:sauvegarde_image";
		//Message émit lors de l'échec de la sauvegarde de l'image
		public static var ECHEC_SAUVEGARDE_IMAGE:String="IOCameraRoll:echec_sauvegarde_image";
		
		//Référence au conteneur de l'image chargée/sauvegardée
		private var _conteneur:DisplayObjectContainer;
          		
		public function IOCameraRoll(clip:DisplayObjectContainer) { 
			//mémorise la référence à l'objet d'affichage conteneur  
			this._conteneur=clip;
		}
		
		//**********************************************************************************
		//Fonctions de chargement d'une image depuis les bibliothèques d'image de l'appareil
		public function chercherImage():void{
			//si la recherche d'image et l'
			if(CameraRoll.supportsBrowseForImage)
			{
				trace("Sélection d'image...");
				//Défini les écouteurs d'événement gérant la sélection de l'image
				this.addEventListener(MediaEvent.SELECT, surSelectionImage);
				this.addEventListener(Event.CANCEL, surSelectionImageCancel);
				this.addEventListener(ErrorEvent.ERROR, surErreurSelectionImage);
				//Activation du sélecteur d'image
				this.browseForImage();
			}
			else
			{
				//Message de 
				trace("Navigation de sélection non supportée par l'appareil.");
				dispatchEvent(new Event(SUPPORT_SELECTION_IMAGE_ABSENT));
			}
		}
			
		private function surErreurSelectionImage(evenement:ErrorEvent):void{
			trace("Erreur à la sélection de l'image. " + evenement.text);
			//Retire les écouteurs d'événement devenus caducs
			this.removeEventListener(MediaEvent.SELECT, surSelectionImage);
			this.removeEventListener(Event.CANCEL, surSelectionImageCancel);
			this.removeEventListener(ErrorEvent.ERROR, surErreurSelectionImage);
			//Émets un message signalant l'erreur
			this.dispatchEvent(new Event(SELECTION_IMAGE_ERREUR));
		}
		
		private function surSelectionImageCancel( event:Event ):void
		{
			trace( "Sélection d'image annulée!" );
			//Retire les écouteurs d'événement devenus caducs
			this.removeEventListener( MediaEvent.SELECT, surSelectionImage);
			this.removeEventListener( Event.CANCEL, surSelectionImageCancel);
			this.removeEventListener(ErrorEvent.ERROR, surErreurSelectionImage);
			//Émets un message signalant la cancellation
			this.dispatchEvent(new Event(SELECTION_IMAGE_CANCEL));
		}	
			
		private function surSelectionImage(evenement:MediaEvent):void
		{
			trace( "Image sélectionnée..." ); 
			//Retire les écouteurs d'événement devenus caducs
			this.removeEventListener(MediaEvent.SELECT, surSelectionImage);
			this.removeEventListener(Event.CANCEL, surSelectionImageCancel);
			this.removeEventListener(ErrorEvent.ERROR, surErreurSelectionImage);
			//Initialisation de l'objet de promesse pour récupération	   
			var image_promise:MediaPromise = evenement.data;     
            var obj_chargement:Loader = new Loader();
			if(image_promise.isAsync)
			{
				trace("Promesse d'image asynchrone.");
				obj_chargement.contentLoaderInfo.addEventListener(Event.COMPLETE, surChargementImage);
				obj_chargement.contentLoaderInfo.addEventListener(IOErrorEvent.IO_ERROR, surEchecChargementImage);
				obj_chargement.loadFilePromise(image_promise);
			}
			else
			{
				trace("Promesse d'image synchrone.");
				obj_chargement.loadFilePromise(image_promise);
				this._conteneur.addChild( obj_chargement);
			}
			this.dispatchEvent(new Event(SELECTION_IMAGE));
		}
		
		private function surChargementImage( evenement:Event ):void
		{
        	trace("Image chargée de façon asynchrone.");
			//Retire les écouteurs d'événement devenus caducs
			evenement.currentTarget.removeEventListener(Event.COMPLETE, surChargementImage);
			evenement.currentTarget.removeEventListener(IOErrorEvent.IO_ERROR, surEchecChargementImage);
			//Vérification du type d'objet déclanchant la fonction
			var infos_chargement:LoaderInfo=evenement.currentTarget as LoaderInfo;
			if(infos_chargement!=null){
				//Vérification si une image existe déjà dans le conteneur
				if(this._conteneur.numChildren>0){
					//si oui, retire l'image courante
					this._conteneur.removeChildAt(0);
				}
				//Ajoute la nouvelle image au conteneur
				this._conteneur.addChild(infos_chargement.content);
				//Envoi d'une message de chargement accomplit
				this.dispatchEvent(new Event(CHARGEMENT_IMAGE));
			}
			else
			{
				trace("Fonction de réponse à l'évenement déclanchée par un mauvais type d'objet!");
			}
		}
		
		private function surEchecChargementImage( evenement:Event ):void
		{
			trace( "Chargement de l'image échoué!." );
			//Retire les écouteurs d'événement devenus caducs
			evenement.currentTarget.removeEventListener(Event.COMPLETE, surChargementImage);
			evenement.currentTarget.removeEventListener(IOErrorEvent.IO_ERROR, surEchecChargementImage);
			this.dispatchEvent(new Event(ECHEC_CHARGEMENT_IMAGE));
		}
		//Fin des fonctions de chargement des images********************************************
         
		
		//**************************************************************************************
		//Fonctions de sauvegarde d'image dans la bibliothèque d'image de l'appareil     
		public function sauvegarderImage():void{
			//si le support de sauvegarde est présent sur l'appareil
			if(CameraRoll.supportsAddBitmapData)
			{
				var bd_a_sauver:BitmapData=new BitmapData(this._conteneur.width,this._conteneur.height);
				bd_a_sauver.draw(this._conteneur);
				this.addEventListener(Event.COMPLETE, surSauvegardeImage);
				this.addEventListener(ErrorEvent.ERROR, surErreurSelectionImage);
				this.addBitmapData(bd_a_sauver);	
			}
			else
			{
				trace("Sauvegarde non supportée par l'appareil.");
				//Émets un message signalant le support de sauvegarde absent
				this.dispatchEvent(new Event(SUPPORT_SAUVEGARDE_IMAGE_ABSENT));
			}
		}
		
		private function surSauvegardeImage(evenement:Event):void{
			trace("Image sauvegardée!!!");
			evenement.currentTarget.removeEventListener(Event.COMPLETE, surSauvegardeImage);
			evenement.currentTarget.removeEventListener(ErrorEvent.ERROR, surErreurSauvegardeImage);
			this.dispatchEvent(new Event(SAUVEGARDE_IMAGE));
		}
		
		private function surErreurSauvegardeImage(evenement:ErrorEvent):void{
			trace("Sauvegarde de l'image échouée!" + evenement.text);
			evenement.currentTarget.removeEventListener(Event.COMPLETE, surSauvegardeImage);
			evenement.currentTarget.removeEventListener(ErrorEvent.ERROR, surErreurSauvegardeImage);
			this.dispatchEvent(new Event(ECHEC_SAUVEGARDE_IMAGE));
		}
		//Fin des fonctions de sauvegarde des images********************************************
	}
}
