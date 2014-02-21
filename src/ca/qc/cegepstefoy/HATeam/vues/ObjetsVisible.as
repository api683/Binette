package ca.qc.cegepstefoy.HATeam.vues {
	/**
	*	@author Michel Rouleau
	*	@link mrouleau@cegep-ste-foy.qc.ca
	*	@copy Michel Rouleau, Cégep de Ste-Foy
	*/

	// Classes AS3
	import flash.display.Sprite; 
	import flash.display.DisplayObjectContainer;
	import flash.display.StageOrientation;
	import flash.events.StageOrientationEvent;
	
	/**
	 * Héritage : Sprite>DisplayObjectContainer>InteractiveObject>DisplayObject>EventDispacher>Object
	 * 
	 * Superclasse racine de tous les objets d'affichage à l'écran. Étends la classe Sprite et supervise
	 * le changement d'orientation de la scène pour l'ensemble des objets d'affichage.
	 */
	public class ObjetsVisible extends Sprite {
		
		//Référence de la scène
		protected var _scene:DisplayObjectContainer=null;
		protected var _orientation:String="portrait";
		
		/**
		 * Constructeur de la classe.
		 * 
		 * @param scene Référence de type DisplayObjectContainer contenant l'instance de la scène.
		 */
		public function ObjetsVisible(scene:DisplayObjectContainer) {
			this._scene=scene;
		}
		
		/**
		 * Fonction d'ajout de l'occurence de l'objet d'affichage sur la scène. Appelée par les
		 * sous-classes. 
		 */
		protected function ajouterSurScene():void{
			this._scene.addChild(this);
		}
		
		/**
		 * Fonction de retrait de l'occurence de l'objet d'affichage sur la scène. Appelée par les
		 * sous-classes. 
		 */
		protected function retirerDeScene():void {
			this._scene.removeChild(this);
		}
		
		/**
		 * Fonction de chargement et configuration de l'auto-orientation des objets visibles.
		 * Vérifie si l'objet stage supporte l'auto-orientation. Si oui, définit un écouteur
		 * pour superviser le changement d'orientation et appelle la fonction de gestion du
		 * changement. Sinon, demande un disposition portrait par défaut.
		 */
		public function charger():void{
			if(stage.autoOrients){
				this.stage.addEventListener(StageOrientationEvent.ORIENTATION_CHANGE, this.surChangementOrientation);	
				this.changerOrientation();
			}
			else
			{
				this.disposerVuePortrait();
			}
		}
		
		/**
		 * Fonction de déchargement des objects visibles. Retire l'écouteur de supervision du
		 * changement d'orientation et demande le retrait de l'objet de la scène.
		 */
		public function decharger():void{
			this.stage.removeEventListener(StageOrientationEvent.ORIENTATION_CHANGE, this.surChangementOrientation);
			this.retirerDeScene();
		}
		
		/**
		 * Fonction de réponse à un événement de chargement d'orientation. Fait appel
		 * à la fonction de gestion du changement d'orientation après la réception de l'événement.
		 * 
		 * @param evenement Événement de type StageOrientationEvent.ORIENTATION_CHANGE, reçu
		 * au changement d'orientation de appareil.
		 */
		protected function surChangementOrientation(evenement:StageOrientationEvent):void{
			if(evenement.afterOrientation){
				this.changerOrientation();
			}
		}
		
		/**
		 * Fonction de gestion du changement d'orientation. Selon l'orientation de la 
		 * scène, demande la disposition horizontale ou verticale de l'objet visible.
		 */
		private function changerOrientation():void{
			switch(stage.orientation){
				case StageOrientation.UNKNOWN:
				case StageOrientation.UPSIDE_DOWN:
				case StageOrientation.ROTATED_LEFT:
				case StageOrientation.ROTATED_RIGHT:
				case StageOrientation.DEFAULT:
					if(stage.stageWidth>stage.stageHeight){
						this._orientation="paysage";
						this.disposerVuePaysage();
					}
					else
					{
						this._orientation="portrait";
						this.disposerVuePortrait();
					}
				break;
			}
		}
		
		/**
		 * Fonction de disposition en vue portrait. Est supplantée par les
		 * fonctions des sous-classes. 
		 */
		protected function disposerVuePortrait():void{
		}
		
		/**
		 * Fonction de disposition en vue paysage. Est supplantée par les
		 * fonctions des sous-classes. 
		 */
		protected function disposerVuePaysage():void{
		}
	}
}
