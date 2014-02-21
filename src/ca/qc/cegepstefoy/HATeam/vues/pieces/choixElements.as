package ca.qc.cegepstefoy.HATeam.vues.pieces {
	import flash.display.MovieClip;
	import ca.qc.cegepstefoy.HATeam.observateur.GroupeBoutonRadio;
	import flash.geom.ColorTransform;
	import ca.qc.cegepstefoy.HATeam.controleur.Controleur;
	import flash.geom.Point;

	// Classes d'AS3
	import flash.events.MouseEvent;
	import flash.display.DisplayObjectContainer;
	
	/**
	 * @author mrouleau
	 */
	public class choixElements extends Bouton {
	
		//Groupe du bouton
		private var _groupe:GroupeBoutonRadio;
		//Identifiant du bouton dans le groupe
		private var _id:uint;
		private var _superhero:String;
		private var _partie:String;
		private var _controleur:Controleur;
		
		//Conctructeur du bouton radio
		public function choixElements(scn:DisplayObjectContainer, controleur:Controleur, groupe:GroupeBoutonRadio, id:uint, partie:String, superhero:String, clip:MovieClip){
			super(scn, clip);
			this._controleur=controleur;
			//Mémorise le groupe d'appartenance
			this._groupe=groupe;
			//Mémorise l'identifiant dans le groupe des boutons
			this._id=id;
			this._superhero=superhero;
			this._partie=partie;
			this._clip.gotoAndStop(this._superhero);

			//Ajoute le bouton au groupe
			this._groupe.ajouterObjet(this);
			//Dessine le bouton (inactif par défaut)
			this.dessinerEtatInactif();
			//Initialisation de l'écouteur d'événement
			this.addEventListener(MouseEvent.MOUSE_UP, surClic);
		}
		
		//Fonction de sélection par programmation du bouton radio
		public function selectionner():void{
			if(this._partie == "tete") {
				Avatar.getInstance().avatarTete = this._superhero;
				Avatar.getInstance().elementSelectionne[0] = this._id;
			}
			else if(this._partie == "corps") {
				Avatar.getInstance().avatarCorps = this._superhero;
				Avatar.getInstance().elementSelectionne[1] = this._id;
			}
			else if(this._partie == "jambes") {
				Avatar.getInstance().avatarJambes = this._superhero;
				Avatar.getInstance().elementSelectionne[2] = this._id;
			}
			this._clip.transform.colorTransform = new ColorTransform(1, 1, 1, 1, 63, 63, 63, 0);
		}
	
		//Fonction de sélection par événement du bouton radio
		override protected function surClic(evenement:MouseEvent):void{
			//Renseigne le groupe sur la nouvelle sélection
			this._groupe.selectionCourrante=this._id;
			//Dessine le nouvel état du bouton sélectionné
			super.surClic(evenement);
			
			this.dessinerEtatActif();
			this.selectionner();
		}
		
		override protected function arretClic(evenement:MouseEvent):void{
			this.dessinerEtatInactif();
		}
		
		//Fonction de désélection par l'observateur
		public function mettreAjour():void{		
			//Dessine le nouvel état du bouton désélectionné
			this.dessinerEtatInactif();
		}
		
		override public function charger():void{
			this.addEventListener(MouseEvent.CLICK, this.surClic);
			super.charger();
			this.dessiner(new Point(0,0),new Point(this.stage.fullScreenWidth-20,this.stage.fullScreenHeight-40));
		}
		
		override public function decharger():void{
			this.removeEventListener(MouseEvent.CLICK, this.surClic);
			super.decharger();
		}
		
		private function dessiner(loc:Point, dim:Point):void{
			var num_onglet:uint=this.groupe.nbBoutons;
			var largeur:uint = 0;
			var hauteur:uint = 0;
			
			hauteur = 100;
			this.y = 1024-125;
			
			if(this._partie == "tete") {
				largeur = 118;
				this.x = ((largeur+36)*this._id)+17; 
			}
			else if(this._partie == "corps") {
				largeur = 150;
				hauteur = 80;
				this.x = ((largeur+4)*this._id)+3; 
				this.y = 1024-115;
			}
			else if(this._partie == "jambes") {
				largeur = 150;
				hauteur = 90;
				this.x = ((largeur+4)*this._id)+3; 
				this.y = 1024-120;	
			}
			
			//redimensionne le fond de l'onglet
			
			this._clip.width = largeur;
			this._clip.height = hauteur;
			
			//Traite le hilite du bouton sélectionné
			if(this.groupe.selectionCourrante == this.id) {
				
			}
			else {
				
			}
		}

		 //Fonctions de dessin du boutons radio
		 //État actif
		private function dessinerEtatActif():void
		{
			this.dessinerEtatSurvol();
		}
		 //État inactif
		private function dessinerEtatInactif():void
		{
			this.dessinerEtatNormal();
		}
		
		override protected function disposerVuePortrait():void{
			//dessiner la vue portrait!
			this.dessiner(new Point(0,0),new Point(this.stage.fullScreenWidth-20,this.stage.fullScreenHeight-40));
		}
		
		override protected function disposerVuePaysage():void{
			//dessiner la vue paysage!
			this.dessiner(new Point(0,0),new Point(this.stage.fullScreenWidth-20,this.stage.fullScreenHeight-40));
		}
		
		//Accesseurs
		public function get id():int{
			return this._id;
		}
		public function get groupe():GroupeBoutonRadio{
			return this._groupe;
		}
		
		public function get libelle():String{
			return this._groupe.nomGroupe;
		}
	}
}