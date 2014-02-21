package ca.qc.cegepstefoy.HATeam {
	// classes AS3.
	import ca.qc.cegepstefoy.HATeam.controleur.Controleur;
	import flash.display.Sprite;
	import flash.display.StageAlign;
	import flash.display.StageScaleMode;
	import flash.events.Event;
	
	/**
	 * @author Michel Rouleau
	 * @link mrouleau@cegep-ste-foy.qc.ca
	 * 
	 * Classe principale de l'application. S'occupe de la mise en place
	 * de l'application.
	 * 
	 */
	public class Main extends Sprite {
		
		//Vitesse d'animation lorsque l'application est active.		
		private const _FRAMERATE_STAGE_ACTIF:uint = 60; 
		//Vitesse d'animation lorsque l'application est inactive.
		private const _FRAMERATE_STAGE_INACTIF:uint = 0;
				
		public function Main() {
			if(stage){
				init();
			}else{
				this.addEventListener(Event.ADDED_TO_STAGE, init);
			}	
		}
		
		private function init():void{
			this.removeEventListener(Event.ADDED_TO_STAGE, init);
			stage.color=0x1D1D1C;
			
			//Ces deux lignes sont importante lors de la réorientation de l'application
			stage.align=StageAlign.TOP_LEFT;
			stage.scaleMode=StageScaleMode.NO_SCALE;
			
			//Défini la vitesse de rafaîchissement de l'écran.
			stage.frameRate = this._FRAMERATE_STAGE_ACTIF;
			
			//Écouteurs d'activation/désactivation de l'application. 
			//Pour économie de la batterie lorsqu'inactive.
			stage.addEventListener ( Event.ACTIVATE, surActivation );
			stage.addEventListener ( Event.DEACTIVATE, surDesactivation );
			
			//Point d'entrée de l'application.
			//Création du contrôleur de l'application
			var controleur:Controleur=new Controleur(this);
			//Initialisation du contrôleur
			//controleur.init();
		}
		
		/**
		 * Fonction d'activation de l'application. Appelée par un événement
		 * générer par l'utilisateur lors de la fermeture de l'application
		 * vers le dock.
		 * 
		 * @param evenement : evenement de type Event.ACTIVATE.
		 */
		private function surActivation ( evenement:Event ):void
		{
			//Restaure le débit de rafraîchissement sur activation de l'application.
			stage.frameRate = this._FRAMERATE_STAGE_ACTIF;
		}
		/**
		 * Fonction de désactivation de l'application. Appelée par un événement
		 * générer par l'utilisateur lors de l'ouveture de l'application 
		 * depuis le dock.
		 * 
		 * @param evenement : evenement de type Event.DEACTIVATE.
		 */
		private function surDesactivation ( evenement:Event ):void
		{
			//Ajuste le débit de raffraîchissement à 0 sur désactivation.
			//(économie de batterie)
			stage.frameRate = this._FRAMERATE_STAGE_INACTIF;
		}
	}
}
