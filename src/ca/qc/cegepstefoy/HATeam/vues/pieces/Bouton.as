package ca.qc.cegepstefoy.HATeam.vues.pieces {
	
	import flash.geom.ColorTransform;
	import ca.qc.cegepstefoy.HATeam.vues.ObjetsVisible;
	import flash.display.DisplayObjectContainer;
	import flash.display.MovieClip;
	import flash.events.MouseEvent;
	
	/**
	 * @author mrouleau
	 */
	public class Bouton extends ObjetsVisible {
		
		protected var _clip:MovieClip;
	
		public function Bouton(scn:DisplayObjectContainer, clip:MovieClip){
			super(scn);
			this._clip=clip;
			this.addChild(this._clip);
		}
		
		override public function charger():void{
			this.ajouterSurScene();
			//super.charger(); /* PARTICULIER AU PROJET BINETTE */
			this.addEventListener(MouseEvent.MOUSE_DOWN, surClic);
			this.addEventListener(MouseEvent.MOUSE_UP, arretClic);
		}
		
		override public function decharger():void{
			this.removeEventListener(MouseEvent.MOUSE_DOWN, surClic);
			this.removeEventListener(MouseEvent.MOUSE_UP, arretClic);
			//super.decharger();
			this.retirerDeScene();
		}
		
		protected function surClic(evenement:MouseEvent):void{
			this.dessinerEtatSurvol();
		}
		
		protected function arretClic(evenement:MouseEvent):void{
			this.dessinerEtatNormal();
		}
		
		protected function dessinerEtatSurvol():void{
			//this._clip.gotoAndStop("survol");
			this._clip.transform.colorTransform = new ColorTransform(1, 1, 1, 1, 63, 63, 63, 0);
		}
		
		protected function dessinerEtatNormal():void{
			//this._clip.gotoAndStop("normal");
			this._clip.transform.colorTransform = new ColorTransform();
		}
		
		/**
		 * Fonction de disposition en vue portrait. Est supplantée par les
		 * fonctions des sous-classes. 
		 */
		override protected function disposerVuePortrait():void{
			super.disposerVuePortrait();
		}
		
		/**
		 * Fonction de disposition en vue paysage. Est supplantée par les
		 * fonctions des sous-classes. 
		 */
		override protected function disposerVuePaysage():void{
			super.disposerVuePaysage();
		}
		
		//Setters du libelle de la classe Boutons
		public function set libelle(t:String):void {
			this._clip.libelle_txt.text=t;	
		}
		
		public function btnEtatNormal():void {
			this.dessinerEtatNormal();
		}
	}
}
