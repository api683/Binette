package ca.qc.cegepstefoy.HATeam.vues {
	import flash.events.Event;
	import flash.display.Bitmap;
	import flash.media.CameraRoll;
	import ca.qc.cegepstefoy.HATeam.polices.FormatsTextes;
	import flash.text.TextField;
	import assets.ui.boutonAchat;
	import assets.ui.boutonPartager;
	import assets.ui.boutonAlbum;
	import assets.ui.boutonEditer;
	import assets.ui.boutonCreation;
	import flash.events.TransformGestureEvent;
	import flash.ui.Multitouch;
	import flash.ui.MultitouchInputMode;
	import assets.ui.ecranNoir;
	import assets.ui.flecheSuivante;
	import assets.ui.boutonSupprimer;
	import assets.ui.flechePrecedente;
	import ca.qc.cegepstefoy.HATeam.vues.pieces.Bouton;
	import assets.ui.fondGalerie;
	import flash.display.Sprite;
	import flash.display.MovieClip;
	import assets.ui.persoAvatar;
	import flash.events.MouseEvent;
	import flash.geom.Point;
	import ca.qc.cegepstefoy.HATeam.modele.Modele;
	import ca.qc.cegepstefoy.HATeam.controleur.Controleur;

	import flash.display.DisplayObjectContainer;

	/**
	 * @author etu01
	 */
	public class PageGalerieAvatars extends Page{
		private var _avatar:MovieClip=new persoAvatar();
		
		private var _decorFixeGalerieAvatars:MovieClip=new fondGalerie();
		
		private var _departListe:int = 0;
		private var _finListe:int = 3;
		private var _listeEcranNoir:Array = new Array();
		private var _listeAvatars:Array = new Array();
		private var _champNomAvatar:TextField = new TextField();
		private var _listeNomAvatar:Array = new Array();
		private var _avatarSelectionner = null;
		
		private var _boutonSuivant:Bouton;
		private var _boutonPrecedent:Bouton;
		private var _boutonCreation:Bouton;
		private var _boutonEditer:Bouton;
		private var _boutonSupprimer:Bouton;
		private var _boutonAlbum:Bouton;
		private var _boutonPartager:Bouton;
		private var _boutonAcheter:Bouton;
		
		
		private var _popup:IUPopUp;
		
		public function PageGalerieAvatars(scene:DisplayObjectContainer, controleur:Controleur, modele:Modele, titre:String){
			super(scene, controleur, modele, titre);
			
			this._boutonPrecedent = new Bouton(this._scene, new flechePrecedente());
			this._boutonPrecedent.x = 0;
			this._boutonPrecedent.y = 768/2 - this._boutonPrecedent.height/2;
			
			this._boutonSuivant = new Bouton(this._scene, new flecheSuivante());
			this._boutonSuivant.y = 768/2 - this._boutonSuivant.height/2;
			this._boutonSuivant.x = 1024 - this._boutonSuivant.width;
			
			this._boutonSupprimer = new Bouton(this._scene, new boutonSupprimer());
			this._boutonSupprimer.x = 160;
			this._boutonSupprimer.y=715;
			
			this._boutonCreation = new Bouton(this._scene, new boutonCreation());
			this._boutonCreation.x = 20;
			this._boutonCreation.y=715;
			
			this._boutonEditer = new Bouton(this._scene, new boutonEditer());
			this._boutonEditer.x = 90;
			this._boutonEditer.y=715;
			
			this._boutonAlbum = new Bouton(this._scene, new boutonAlbum());
			this._boutonAlbum.x = 810;
			this._boutonAlbum.y=715;
			
			this._boutonPartager = new Bouton(this._scene, new boutonPartager());
			this._boutonPartager.x = 880;
			this._boutonPartager.y=715;
			
			this._boutonAcheter = new Bouton(this._scene, new boutonAchat());
			this._boutonAcheter.x = 950;
			this._boutonAcheter.y=715;
			
		}
		
		override public function charger():void{
			super.charger();
			this.addChild(this._decorFixeGalerieAvatars);
			
			if (Multitouch.supportsGestureEvents) {
				Multitouch.inputMode = MultitouchInputMode.GESTURE;
				this.addEventListener(TransformGestureEvent.GESTURE_SWIPE , surGlissement);
			}
			else{
				
			}
			this.afficherAvatars();
			
			this._boutonPrecedent.addEventListener(MouseEvent.MOUSE_DOWN, naviguer);	
			this._boutonSuivant.addEventListener(MouseEvent.MOUSE_DOWN, naviguer);
			
			//BOUTON BAS DE PAGE
			this._boutonCreation.charger();
			this._boutonCreation.addEventListener(MouseEvent.MOUSE_DOWN, naviguerCreation);
			
			this._boutonAlbum.charger();
			this._boutonAlbum.addEventListener(MouseEvent.MOUSE_DOWN, sauvegarderAlbum);
			
			this._boutonSupprimer.charger();
			this._boutonSupprimer.addEventListener(MouseEvent.MOUSE_DOWN, confirmerSupprimer);
			
			this._boutonEditer.charger();
			this._boutonPartager.charger();
			this._boutonAcheter.charger();
			
			this.afficherNavigation();
		}

		override public function decharger():void{
			this.effacerAvatars();
			this.effacerEcranNoir();
			this.removeChild(this._boutonPrecedent);
			this._boutonPrecedent.removeEventListener(MouseEvent.MOUSE_DOWN, naviguer);
			this.removeChild(this._boutonSuivant);
			this._boutonSuivant.removeEventListener(MouseEvent.MOUSE_DOWN, naviguer);
			
			this._boutonCreation.decharger();
			this._boutonCreation.removeEventListener(MouseEvent.MOUSE_DOWN, naviguerCreation);
			this._boutonEditer.decharger();
			this._boutonAlbum.decharger();
			this._boutonAlbum.removeEventListener(MouseEvent.MOUSE_DOWN, sauvegarderAlbum);
			this._boutonPartager.decharger();
			this._boutonAcheter.decharger();
			this._boutonSupprimer.decharger();
			this._boutonSupprimer.removeEventListener(MouseEvent.MOUSE_DOWN, confirmerSupprimer);
			
			if(this._popup != null && this._popup.etatVisible == true) {
				this._popup.decharger();
			}

			super.decharger();
		}
		
		private function surGlissement(e:TransformGestureEvent):void{
			if (e.offsetX == 1) { 
				trace("PRÉCÉDENT");
				this.naviguerGlissement("PRÉCÉDENT");
			}
			if (e.offsetX == -1) { 
				trace("SUIVANT");
				this.naviguerGlissement("SUIVANT");
			}
		}
		
		//A LA SOURIS
		private function naviguer(evenement:MouseEvent):void{
			if(evenement.currentTarget == this._boutonPrecedent){
				if(this._departListe != 0){
					this.effacerAvatars();
					this.effacerEcranNoir();
					this._departListe = this._departListe - 3;
					this._finListe = this._finListe - 3;
					this.afficherAvatars();
					this.afficherNavigation();
				}
			}
			else{
				if(this._finListe < this._modele.donnees.personnage.length()){
					this.effacerAvatars();
					this.effacerEcranNoir();
					this._departListe = this._departListe + 3;
					this._finListe = this._finListe + 3;
					this.afficherAvatars();
					this.afficherNavigation();
				}
			}
		}
		////////////////////////////////////////////////////////////////////////
		//SWIPE
		private function naviguerGlissement(effet:String):void{
			if(effet == "PRÉCÉDENT"){
				if(this._departListe != 0){
					this.effacerAvatars();
					this.effacerEcranNoir();
					this._departListe = this._departListe - 3;
					this._finListe = this._finListe - 3;
					this.afficherAvatars();
					this.afficherNavigation();
				}
			}
			else{
				if(this._finListe < this._modele.donnees.personnage.length()){
					this.effacerAvatars();
					this.effacerEcranNoir();
					this._departListe = this._departListe + 3;
					this._finListe = this._finListe + 3;
					this.afficherAvatars();
					this.afficherNavigation();
				}
			}
		}
		///////////////////////////////////////////////////////
		private function afficherAvatars():void{
				for (var i:int = this._departListe; i < this._finListe; i++) 
				{ 
					if(!this._listeEcranNoir[i]){
							this._listeEcranNoir[i] = new Sprite();
							this._listeEcranNoir[i].graphics.beginFill(0x000000, 0.5);
					}
					
					if(this._modele.donnees.personnage[i]){//POUR LES CASES AVEC AVATAR
						this._avatar = new persoAvatar();
						this._avatar.avatarTete.gotoAndStop(this._modele.donnees.personnage[i].tete);
						this._avatar.avatarCorps.gotoAndStop(this._modele.donnees.personnage[i].corps);
						this._avatar.avatarJambes.gotoAndStop(this._modele.donnees.personnage[i].jambes);
						this._avatar.y = 240;
						this._avatar.width = 325;
						this._avatar.height = 469;
						this._listeAvatars[i] = this._avatar;
						
						this._champNomAvatar = new TextField();
						this._champNomAvatar.embedFonts=true;
						this._champNomAvatar.defaultTextFormat=FormatsTextes.getInstance().formatChamps;
						this._champNomAvatar.maxChars=20;
						this._champNomAvatar.width=300;
						this._champNomAvatar.text = this._modele.donnees.personnage[i].nom;
						this._champNomAvatar.y = 20;
						this._listeNomAvatar[i] = this._champNomAvatar;
						
						if(this._departListe == i){
							this._avatar.x = 30;
							this._listeEcranNoir[i].graphics.drawRect(2, 80, 340.5, 619); // (x spacing, y spacing, width, height)
							this._listeEcranNoir[i].graphics.endFill();
							this._listeNomAvatar[i].x = 30;
						}
						else if(this._departListe+1 == i){
							this._avatar.x = 370;
							this._listeEcranNoir[i].graphics.drawRect(342.5, 80, 340.5, 619); // (x spacing, y spacing, width, height)
							this._listeEcranNoir[i].graphics.endFill();
							this._listeNomAvatar[i].x = 370;
						}
						else{
							this._avatar.x = 710;
							this._listeEcranNoir[i].graphics.drawRect(682.5, 80, 340.5, 619); // (x spacing, y spacing, width, height)
							this._listeEcranNoir[i].graphics.endFill();
							this._listeNomAvatar[i].x = 710;
						}
							
						this.addChild(this._listeAvatars[i]);
						this.addChild(this._listeNomAvatar[i]);
						this._listeEcranNoir[i].addEventListener(MouseEvent.CLICK, selectionnerAvatar);
						this.addChild(this._listeEcranNoir[i]);
						this._listeEcranNoir[i].visible = true;
					}
					else{ //POUR LES CASES VIDES
							if(this._departListe == i){
								this._listeEcranNoir[i].graphics.drawRect(2, 80, 340.5, 619); // (x spacing, y spacing, width, height)
								this._listeEcranNoir[i].graphics.endFill();
							}	
							else if(this._departListe+1 == i){
								this._listeEcranNoir[i].graphics.drawRect(342.5, 80, 340.5, 619); // (x spacing, y spacing, width, height)
								this._listeEcranNoir[i].graphics.endFill();
							}
							else{
								this._listeEcranNoir[i].graphics.drawRect(682.5, 80, 340.5, 619); // (x spacing, y spacing, width, height)
								this._listeEcranNoir[i].graphics.endFill();
							}
							
							this.addChild(this._listeEcranNoir[i]);
							this._listeEcranNoir[i].visible = true;
						
					}
					//Vérifie si un avatar est sélectionner
					if(this._avatarSelectionner!=null){
						if(this._listeEcranNoir[i] == this._listeEcranNoir[this._avatarSelectionner]){
							this._listeEcranNoir[i].visible = false;
						}
					}
					
				}	
		}
		
		private function effacerAvatars():void{
			for(var i:int=this._departListe; i < this._finListe; i++){
				if(this._listeAvatars[i]){
					this._listeAvatars[i].visible = false;
					this._listeNomAvatar[i].visible = false;
				}
			}
		}
		
		private function effacerEcranNoir():void{
			for(var i:int=0; i < this._listeEcranNoir.length; i++){
				if(this._listeEcranNoir[i]){
					this._listeEcranNoir[i].removeEventListener(MouseEvent.CLICK, selectionnerAvatar);
					this.removeChild(this._listeEcranNoir[i]);
					
				}
			}
			this._listeEcranNoir = new Array();
		}
		
		private function selectionnerAvatar(evenement:MouseEvent):void{
			for(var i:int = this._departListe; i < this._finListe; i++){
				if(this._listeEcranNoir[i]){
					this._listeEcranNoir[i].visible = true;
				}
			}
			this._avatarSelectionner = evenement.currentTarget;
			this._avatarSelectionner = this._listeEcranNoir.indexOf(this._avatarSelectionner);
			this._listeEcranNoir[this._avatarSelectionner].visible = false;
			trace(this._avatarSelectionner);
		}
		
		private function confirmerSupprimer(evenement:MouseEvent):void{
			if(this._avatarSelectionner || this._avatarSelectionner==0){
				this.creerPopup("Suppression de cet Avatar", "Êtes-vous sûr de vouloir supprimer cet avatar ?", "Non", "Oui", this._boutonSupprimer, this._controleur);
			}
		}
		
		public function supprimerEnregistrement():void{
			if(this._avatarSelectionner || this._avatarSelectionner==0){
				//this._controleur.supprimerEnregistrement(this._avatarSelectionner);
				this.removeChild(this._listeAvatars[this._avatarSelectionner]);
				this._listeAvatars.splice(this._avatarSelectionner, 1);
				this.removeChild(this._listeNomAvatar[this._avatarSelectionner]);
				this._listeNomAvatar.splice(this._avatarSelectionner, 1);
				this._avatarSelectionner=null;
				this.effacerAvatars();
				this.effacerEcranNoir();
				this.afficherAvatars();
				this.afficherNavigation();
			}	
		}
		
		private function afficherNavigation():void{
			this.addChild(this._boutonPrecedent);
			this.addChild(this._boutonSuivant);
			if(this._departListe==0){
				if(this._modele.donnees.personnage.length()<=3){
					this._boutonPrecedent.visible=false;
					this._boutonSuivant.visible=false;
				}else{
					this._boutonPrecedent.visible=false;
					this._boutonSuivant.visible=true;
				}
			}
			else{
				if(this._finListe>=this._modele.donnees.personnage.length()){
					this._boutonPrecedent.visible=true;
					this._boutonSuivant.visible=false;
				}else{
					this._boutonPrecedent.visible=true;
					this._boutonSuivant.visible=true;
				}
			}
		}
		
		private function naviguerCreation(evenement:MouseEvent):void {
			this.creerPopup("Aller à la Création", "Pour aller à la création, vous devez changer l'orientation de votre tablette.", "OK", "", this._boutonCreation, this._controleur);
		}
		
		private function creerPopup(titre:String, message:String, textBouton1:String, textBouton2:String, btnAction:Bouton, controleur:Controleur):void {
			this._popup = new IUPopUp(this._scene, titre, message, textBouton1, textBouton2, btnAction, controleur, null);
			this._popup.charger();
		}
		
		override protected function disposerVuePortrait():void{
			//dessiner la vue portrait!
			this._controleur.naviguer("pageCreationAvatar");
		}
		
		override protected function disposerVuePaysage():void{
			//dessiner la vue paysage!
			//this._controleur.naviguer("pageGalerieAvatars");
		}
		
		private function sauvegarderAlbum(evenement:MouseEvent):void{
			if(this._avatarSelectionner || this._avatarSelectionner==0){
				trace("album");
				//Ajouter l'image dans un sprite pour permettre son redimensionnement
				var sprite:Sprite = new Sprite();
				var monFond:MovieClip=new fondGalerie();
				monFond.width = 1024;
				monFond.height = 768;
				
				var avatarAlbum:persoAvatar = new persoAvatar();
				avatarAlbum.avatarTete.gotoAndStop(this._modele.donnees.personnage[this._avatarSelectionner].tete);
				avatarAlbum.avatarCorps.gotoAndStop(this._modele.donnees.personnage[this._avatarSelectionner].corps);
				avatarAlbum.avatarJambes.gotoAndStop(this._modele.donnees.personnage[this._avatarSelectionner].jambes);
				avatarAlbum.y = 240;
				avatarAlbum.width = 325;
				avatarAlbum.height = 469;
				avatarAlbum.x = 370;
				
				var nomAvatar:TextField = new TextField();
				nomAvatar.embedFonts=true;
				nomAvatar.defaultTextFormat=FormatsTextes.getInstance().formatChamps;
				nomAvatar.maxChars=20;
				nomAvatar.width=300;
				nomAvatar.text = this._modele.donnees.personnage[this._avatarSelectionner].nom;
				nomAvatar.y = 20;
				nomAvatar.x = 370;
				
				sprite.addChild(monFond);
				sprite.addChild(nomAvatar);
				sprite.addChild(avatarAlbum);
				
				this._controleur.conteneur = sprite;
				this._controleur.sauvegarderImage();
			}
		}
		

		public function get avatarSelectionner():int{
			return this._avatarSelectionner;
		}
	}
}
