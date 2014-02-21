package ca.qc.cegepstefoy.HATeam.vues {
	
	import ca.qc.cegepstefoy.HATeam.controleur.Controleur;
	import ca.qc.cegepstefoy.HATeam.modele.Modele;
	import flash.display.DisplayObjectContainer;
	import flash.events.MouseEvent;
	import flash.geom.Point;
		
	/**
	 * @author mrouleau
	 */
	public class Page extends ObjetsVisible {
		
		private var _titre:String="Accueil";
		protected var _modele:Modele;
		protected var _controleur:Controleur;
		private var _listeVues:Object;
		
		public function Page(scene : DisplayObjectContainer, controleur:Controleur, modele : Modele, titre:String) {
			super(scene);
			this._modele=modele;
			this._controleur=controleur;
			this._titre=titre;
			//this.ajouterSurScene();
		}
		
		override public function charger():void{
			//Ajout de la vue sur la scène
			this.ajouterSurScene();
			this._scene.setChildIndex(this, 0);
			//Appel à la fonction chargement des fonctionnalité de la superclasse
			super.charger();
		}
		
		override public function decharger():void{
			//Appel à la fonction déchargement des fonctionnalité de la superclasse
			super.decharger();
		}

		protected function dessiner(loc:Point, dim:Point):void{
			//redessin de la vue
			this.graphics.clear();
			this.graphics.lineStyle(1,0xFF0000,1);
			this.graphics.beginFill(0xFF0000,1);
			this.graphics.drawRect(loc.x,loc.y,dim.x,dim.y);
			this.graphics.endFill();
		}

		override protected function disposerVuePortrait():void{
			//dessiner la vue portrait!
			//this.dessiner(new Point(0,0),new Point(this.stage.fullScreenWidth,this.stage.fullScreenHeight));
			//this._controleur.naviguer("pageCreationAvatar");
		}
		
		override protected function disposerVuePaysage():void{
			//dessiner la vue paysage!
			//this.dessiner(new Point(0,0),new Point(this.stage.fullScreenWidth,this.stage.fullScreenHeight));
			//this._controleur.naviguer("pageGalerieAvatars");
		}
	}
}
