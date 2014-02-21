package ca.qc.cegepstefoy.HATeam.vues {
	
	import assets.ui.persoJambes;
	import assets.ui.persoCorps;
	import assets.ui.persoTete;
	import assets.ui.iconChoixJambes;
	import assets.ui.iconChoixCorps;
	import assets.ui.iconChoixTete;
	import ca.qc.cegepstefoy.HATeam.observateur.GroupeBoutonRadio;
	import ca.qc.cegepstefoy.HATeam.vues.pieces.choixElements;
	import ca.qc.cegepstefoy.HATeam.vues.pieces.choixCorps;
	import ca.qc.cegepstefoy.HATeam.vues.pieces.Bouton;
	import flash.events.FocusEvent;
	import ca.qc.cegepstefoy.HATeam.polices.FormatsTextes;
	import flash.text.TextFieldAutoSize;
	import flash.text.TextFieldType;
	import assets.ui.iconRandomBig;
	import ca.qc.cegepstefoy.HATeam.vues.pieces.Avatar;
	import assets.ui.persoAvatar;
	import assets.ui.iconRandomSmall;
	import assets.ui.PlaqueNom;
	import flash.events.MouseEvent;
	import assets.ui.PlaqueGalerie;
	import assets.ui.PlaqueSave;
	import assets.ui.DecorFixeCreationAvatar;
	import flash.display.MovieClip;
	import flash.text.TextField;
	import flash.geom.Point;
	import ca.qc.cegepstefoy.HATeam.modele.Modele;
	import ca.qc.cegepstefoy.HATeam.controleur.Controleur;
	import flash.display.DisplayObjectContainer;
	/**
	 * @author etu01
	 */
	public class PageCreationAvatars extends Page {
	
		private var _decorFixeCreationAvatar:MovieClip=new DecorFixeCreationAvatar();
		
		private var _btnRandomCorps:Bouton;
		
		private var _btnSave:Bouton;
		private var _btnGalerie:Bouton;
		
		private var _plaqueNom:MovieClip=new PlaqueNom();
		private var _btnRandomNom:Bouton;
		private var _champNom:TextField=new TextField();
		
		private var _listeChoixCorps:Vector.<choixCorps>=new Vector.<choixCorps>();
		private var _listeChoixElement:Vector.<choixElements>=new Vector.<choixElements>();
		private var _groupe_choix_corps:GroupeBoutonRadio;
		private var _groupe_choix_element:GroupeBoutonRadio;
		
		private var _popup:IUPopUp;
		
		public function PageCreationAvatars(scene:DisplayObjectContainer, controleur:Controleur, modele:Modele, titre:String){
			super(scene, controleur, modele, titre);
			
			this.addChild(this._decorFixeCreationAvatar);
			
			/*this._avatar.x = 225;
			this._avatar.y = 170;
			//this._avatar.charger();
			this.addChild(this._avatar);
			this._avatar.avatarTete.gotoAndStop("vide");
			this._avatar.avatarCorps.gotoAndStop("vide");
			this._avatar.avatarJambes.gotoAndStop("vide");*/
			this.addChild(Avatar.getInstance().avatar);
			
			this._plaqueNom.x = 200;
			this._plaqueNom.y = 21;
			this.addChild(this._plaqueNom);
			
			this._btnGalerie = new Bouton(this._scene, new PlaqueGalerie());
			this._btnGalerie.x = 25;
			this._btnGalerie.y = 21;
			
			this._btnSave = new Bouton(this._scene, new PlaqueSave());
			this._btnSave.x = 105;
			this._btnSave.y = 21;
			
			this.ajouterChamps(this._champNom);
			
			this._btnRandomNom = new Bouton(this._scene, new iconRandomSmall());
			this._btnRandomNom.x = 700;
			this._btnRandomNom.y = 30;
			
			this._btnRandomCorps = new Bouton(this._scene, new iconRandomBig());
			this._btnRandomCorps.x = 20;
			this._btnRandomCorps.y = 150;
			
			this._groupe_choix_corps=new GroupeBoutonRadio("choixCorps");
			this._listeChoixCorps.push(new choixCorps(scene,this._controleur,this._groupe_choix_corps,0,new iconChoixTete()));
			this._listeChoixCorps.push(new choixCorps(scene,this._controleur,this._groupe_choix_corps,1,new iconChoixCorps()));
			this._listeChoixCorps.push(new choixCorps(scene,this._controleur,this._groupe_choix_corps,2,new iconChoixJambes()));
			
			this._groupe_choix_element=new GroupeBoutonRadio("choixElement");
		}
		
		override public function charger():void{
			super.charger();
			
			this._listeChoixCorps[0].charger();
			this._listeChoixCorps[1].charger();
			this._listeChoixCorps[2].charger();
			this._listeChoixCorps[0].addEventListener(MouseEvent.MOUSE_DOWN, changerSection);
			this._listeChoixCorps[1].addEventListener(MouseEvent.MOUSE_DOWN, changerSection);
			this._listeChoixCorps[2].addEventListener(MouseEvent.MOUSE_DOWN, changerSection);
			
			this._listeChoixCorps[Avatar.getInstance().lastSection-1].selectionner();
			
			this.chargerSection(Avatar.getInstance().lastSection);
			
			this._btnGalerie.charger();
			this._btnSave.charger();
			this._btnRandomNom.charger();
			this._btnRandomCorps.charger();
			this._btnGalerie.addEventListener(MouseEvent.MOUSE_DOWN, naviguerGalerie);
			this._btnSave.addEventListener(MouseEvent.MOUSE_DOWN, naviguerSave);
			this._champNom.addEventListener(MouseEvent.CLICK, onFocusChampNom);
			this._champNom.addEventListener(FocusEvent.FOCUS_OUT, onFocusOutChampNom);
			this._btnRandomNom.addEventListener(MouseEvent.MOUSE_DOWN, nomRandom);
			this._btnRandomCorps.addEventListener(MouseEvent.MOUSE_DOWN, corpsRandom);
		}
		
		override public function decharger():void{	
			//if(this._popup != null && this._popup.etatVisible == true) {
			//	this._popup.decharger();
			//}
			
			this._btnGalerie.removeEventListener(MouseEvent.MOUSE_DOWN, naviguerGalerie);
			this._btnSave.removeEventListener(MouseEvent.MOUSE_DOWN, naviguerSave);
			this._champNom.removeEventListener(MouseEvent.MOUSE_DOWN, onFocusChampNom);
			this._champNom.removeEventListener(FocusEvent.FOCUS_OUT, onFocusOutChampNom);
			this._btnRandomNom.removeEventListener(MouseEvent.MOUSE_DOWN, nomRandom);
			this._btnRandomCorps.removeEventListener(MouseEvent.MOUSE_DOWN, corpsRandom);
			this._btnGalerie.decharger();
			this._btnSave.decharger();
			this._btnRandomNom.decharger();
			this._btnRandomCorps.decharger();
			
			this._listeChoixCorps[0].removeEventListener(MouseEvent.MOUSE_DOWN, changerSection);
			this._listeChoixCorps[1].removeEventListener(MouseEvent.MOUSE_DOWN, changerSection);
			this._listeChoixCorps[2].removeEventListener(MouseEvent.MOUSE_DOWN, changerSection);
			this._listeChoixCorps[0].decharger();
			this._listeChoixCorps[1].decharger();
			this._listeChoixCorps[2].decharger();
			
			this._listeChoixElement[0].decharger();
			this._listeChoixElement[1].decharger();
			this._listeChoixElement[2].decharger();
			this._listeChoixElement[3].decharger();
			this._listeChoixElement[4].decharger();
			
			super.decharger();
		}
		
		public function changerSection(e:MouseEvent):void{
			var nouvelleSectionId:uint = 0;
			if(e.currentTarget.clip.currentLabel == "tete") { nouvelleSectionId = 1; }
			else if(e.currentTarget.clip.currentLabel == "corps") { nouvelleSectionId = 2; }
			else if(e.currentTarget.clip.currentLabel == "jambes") { nouvelleSectionId = 3; }
			//Si la nouvelle page est différente de la page courante
			if(nouvelleSectionId!=Avatar.getInstance().section_actuelle){
				for(var i:int = 0; i < 5; i++) {
					this._listeChoixElement[i].decharger();
				}
				//mémorise la nouvelle page
				Avatar.getInstance().section_actuelle = nouvelleSectionId;
				//ouvre le nouveau formulaire
				this.chargerSection(Avatar.getInstance().section_actuelle);
				if(Avatar.getInstance().elementSelectionne[Avatar.getInstance().section_actuelle-1] != -1) {
					this._listeChoixElement[Avatar.getInstance().elementSelectionne[Avatar.getInstance().section_actuelle-1]].selectionner();
				}
			}
		}
		
		private function chargerSection(nouvelleSectionId:int):void{
			this._listeChoixElement = new Vector.<choixElements>();
			Avatar.getInstance().lastSection = nouvelleSectionId;
			if(nouvelleSectionId == 1) { //tete
				this._listeChoixElement.push(new choixElements(this._scene,this._controleur,this._groupe_choix_element,0,"tete","captainamerica",new persoTete()));
				this._listeChoixElement.push(new choixElements(this._scene,this._controleur,this._groupe_choix_element,1,"tete","carnage",new persoTete()));
				this._listeChoixElement.push(new choixElements(this._scene,this._controleur,this._groupe_choix_element,2,"tete","darthvader",new persoTete()));
				this._listeChoixElement.push(new choixElements(this._scene,this._controleur,this._groupe_choix_element,3,"tete","hellboy",new persoTete()));
				this._listeChoixElement.push(new choixElements(this._scene,this._controleur,this._groupe_choix_element,4,"tete","poisonivy",new persoTete()));
			}
			else if(nouvelleSectionId == 2) { //corps
				this._listeChoixElement.push(new choixElements(this._scene,this._controleur,this._groupe_choix_element,0,"corps","wonderwoman",new persoCorps()));
				this._listeChoixElement.push(new choixElements(this._scene,this._controleur,this._groupe_choix_element,1,"corps","spiderman",new persoCorps()));
				this._listeChoixElement.push(new choixElements(this._scene,this._controleur,this._groupe_choix_element,2,"corps","ninjaturtle",new persoCorps()));
				this._listeChoixElement.push(new choixElements(this._scene,this._controleur,this._groupe_choix_element,3,"corps","ironamerica",new persoCorps()));
				this._listeChoixElement.push(new choixElements(this._scene,this._controleur,this._groupe_choix_element,4,"corps","batman",new persoCorps()));
			}
			else if(nouvelleSectionId == 3) { //jambes
				this._listeChoixElement.push(new choixElements(this._scene,this._controleur,this._groupe_choix_element,0,"jambes","thing",new persoJambes()));
				this._listeChoixElement.push(new choixElements(this._scene,this._controleur,this._groupe_choix_element,1,"jambes","tfspy",new persoJambes()));
				this._listeChoixElement.push(new choixElements(this._scene,this._controleur,this._groupe_choix_element,2,"jambes","superman",new persoJambes()));
				this._listeChoixElement.push(new choixElements(this._scene,this._controleur,this._groupe_choix_element,3,"jambes","hulk",new persoJambes()));
				this._listeChoixElement.push(new choixElements(this._scene,this._controleur,this._groupe_choix_element,4,"jambes","harleyquinn",new persoJambes()));
			}
			
			this._listeChoixElement[0].charger();
			this._listeChoixElement[1].charger();
			this._listeChoixElement[2].charger();
			this._listeChoixElement[3].charger();
			this._listeChoixElement[4].charger();
			
			if(Avatar.getInstance().elementSelectionne[Avatar.getInstance().lastSection-1] != -1) {
				this._listeChoixElement[Avatar.getInstance().elementSelectionne[Avatar.getInstance().lastSection-1]].selectionner();
			}
		}
		
		override protected function dessiner(loc:Point, dim:Point):void{
		}
		
		private function naviguerGalerie(evenement:MouseEvent):void {
			this.creerPopup("Aller à la Galerie", "Pour aller à la galerie, vous devez changer l'orientation de votre tablette. Si vous désirez créer un nouvel avatar cliquez sur le bouton ci-dessous.", "OK", "Créer un nouvel avatar", this._btnGalerie);
		}
		
		private function creerPopup(titre:String, message:String, textBouton1:String, textBouton2:String, btnAction:Bouton):void {
			this._popup = new IUPopUp(this._scene, titre, message, textBouton1, textBouton2, btnAction, this._controleur, this._champNom);
			this._popup.charger();
		}
		
		private function naviguerSave(evenement:MouseEvent):void {
			if(this._modele.donnees.personnage.length() > 12) {
				this.creerPopup("Votre Galerie est pleine", "Vous ne pouvez sauvegarder plus de douze(12) avatars. Pour aller à la galerie et supprimer des avatars, vous devez changer l'orientation de votre tablette.", "OK", "", this._btnSave);
			}
			else if(Avatar.getInstance().avatarTete != "vide" && Avatar.getInstance().avatarCorps != "vide" && Avatar.getInstance().avatarJambes != "vide" && Avatar.getInstance().avatarNom != "Entrer un nom de Super-héro" && Avatar.getInstance().avatarNom != "" && Avatar.getInstance().avatarNom != " ") {
				var enregistrement:XML = this._modele.personnage.copy();
				enregistrement.nom=Avatar.getInstance().avatarNom;
				enregistrement.tete=Avatar.getInstance().avatarTete;
				enregistrement.corps=Avatar.getInstance().avatarCorps;
				enregistrement.jambes=Avatar.getInstance().avatarJambes;
				this._controleur.ajouterEnregistrement(enregistrement);
				this.creerPopup("Sauvegarde effectuée", "La sauvegarde de votre avatar s'est effectuée avec succès. Pour aller à la galerie, vous devez changer l'orientation de votre tablette. Si vous désirez créer un nouvel avatar cliquez sur le bouton ci-dessous.", "OK", "Créer un nouvel avatar", this._btnSave);
			}
			else {
				this.creerPopup("Erreur lors de la Sauvegarde", "Pour pouvoir sauvegarder un avatar vous devez choisir une partie du corps différente que celle de base (de couleur blanche) et nommer votre super-héro.", "OK", "", this._btnSave);
			}
		}
		
		private function nomRandom(evenement:MouseEvent):void {
			var superheroNom1:Array = new Array("Captain", "Darth", "Hell", "Poison", "Wonder", "Super", "Spider", "Ninja", "Iron", "Bat", "Harley");
			var superheroNom2:Array = new Array("America", "Man", "Turtle", "Carnage", "Boy", "Ivy", "Woman", "Vader", "Spy", "Thing", "Quinn");
			var nomSuperHero:String = "";
			
			var nbrNom:uint = Math.floor(Math.random()*2)+1;
			if(nbrNom == 2) {
				for(var i:int = 0; i<nbrNom; i++) {
					nomSuperHero = superheroNom1[Math.floor(Math.random()*superheroNom1.length)];
					nomSuperHero = nomSuperHero + " " + superheroNom2[Math.floor(Math.random()*superheroNom2.length)];
				}
			}
			else {
				nomSuperHero = superheroNom1[Math.floor(Math.random()*superheroNom1.length)];
			}
			
			this._champNom.text=nomSuperHero;
			Avatar.getInstance().avatarNom = this._champNom.text;
		}
		
		private function corpsRandom(evenement:MouseEvent):void {
			var superheroTete:Array = new Array("captainamerica", "carnage", "darthvader", "hellboy", "poisonivy");
			var superheroCorps:Array = new Array("wonderwoman", "spiderman", "ninjaturtle", "ironamerica", "batman");
			var superheroJambes:Array = new Array("thing", "tfspy", "superman", "hulk", "harleyquinn");
			
			Avatar.getInstance().avatarTete = superheroTete[Math.floor(Math.random()*superheroTete.length)];
			Avatar.getInstance().avatarCorps = superheroCorps[Math.floor(Math.random()*superheroCorps.length)];
			Avatar.getInstance().avatarJambes = superheroJambes[Math.floor(Math.random()*superheroJambes.length)];
			
			if(Avatar.getInstance().elementSelectionne[Avatar.getInstance().lastSection-1] != -1) {
				this._listeChoixElement[Avatar.getInstance().elementSelectionne[Avatar.getInstance().lastSection-1]].mettreAjour();
			}
			for(var i:int = 0; i < 3; i++) {
				Avatar.getInstance().elementSelectionne[i] = -1;
			}
		}
		
		protected function ajouterChamps(champ:TextField):void {
			champ.width=473;
			champ.height=35;
			champ.x=215;
			champ.y=27;
			champ.type=TextFieldType.INPUT;
			champ.embedFonts=true;
			champ.defaultTextFormat=FormatsTextes.getInstance().formatChamps;
			champ.text=Avatar.getInstance().avatarNom;
			champ.maxChars = 20;
			champ.multiline=false;
			this.addChild(champ);
		}
		
		private function onFocusChampNom(e:MouseEvent):void {
			if(this._champNom.text == "Entrer un nom de Super-héro" || this._champNom.text == " ") {
				this._champNom.text="";
			}
			Avatar.getInstance().avatarNom = this._champNom.text;
		}
		private function onFocusOutChampNom(e:FocusEvent):void {
			if(this._champNom.text == "" || this._champNom.text == " ") {
				this._champNom.text="Entrer un nom de Super-héro";
			}
			Avatar.getInstance().avatarNom = this._champNom.text;
		}
		
		override protected function disposerVuePortrait():void{
			//dessiner la vue portrait!
			//this.dessiner(new Point(0,0),new Point(this.stage.fullScreenWidth,this.stage.fullScreenHeight));
		}
		
		override protected function disposerVuePaysage():void{
			//dessiner la vue paysage!
			if(this._popup != null && this._popup.etatVisible == true) {
				this._popup.decharger();
			}
			this._controleur.naviguer("pageGalerieAvatars");
		}
	}
}
