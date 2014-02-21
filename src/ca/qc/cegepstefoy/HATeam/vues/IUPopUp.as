package ca.qc.cegepstefoy.HATeam.vues {
	
	import ca.qc.cegepstefoy.HATeam.controleur.Controleur;
	import assets.ui.iconTabletRotation;
	import flash.events.MouseEvent;
	import ca.qc.cegepstefoy.HATeam.vues.pieces.Avatar;
	import assets.ui.btnPopup;

	import flash.display.MovieClip;
	import ca.qc.cegepstefoy.HATeam.vues.pieces.Bouton;
	import ca.qc.cegepstefoy.HATeam.polices.FormatsTextes;
	import flash.text.TextFieldAutoSize;
	import flash.display.DisplayObjectContainer;
	import flash.text.TextField;
	import flash.geom.Point;
	
	/**
	 * @author mrouleau
	 */
	public class IUPopUp extends Page {
		
		private var _btnAction:Bouton;
		private var _nomAvatar:TextField;
		private var _titre:TextField=new TextField();
		private var _message:TextField=new TextField();
		private var _btn1:MovieClip=new btnPopup();
		private var _btn2:MovieClip=new btnPopup();
		private var _textbtn1:TextField=new TextField();
		private var _textbtn2:TextField=new TextField();
		private var _etatVisible:Boolean = false;
		private var _iconTabletRotate:MovieClip=new iconTabletRotation();
		
		public function IUPopUp(scene:DisplayObjectContainer, titre:String, message:String, textBouton1:String, textBouton2:String, btnAction:Bouton, controleur:Controleur, champNom:TextField) {
			super(scene, controleur, null, null);
			this._btnAction = btnAction;
			this._nomAvatar = champNom;
			
			//Ajoute le champ de la liste
			this._titre.defaultTextFormat=FormatsTextes.getInstance().formatChamps;
			this._titre.text=titre;
			this._titre.multiline=false;
			this._titre.wordWrap=false;
			this._titre.autoSize=TextFieldAutoSize.LEFT;
			this.addChild(this._titre);
			
			if (this._titre.text == "Aller à la Galerie" || this._titre.text == "Aller à la Création") {
				this.addChild(this._iconTabletRotate);
			}
			
			this._message.defaultTextFormat=FormatsTextes.getInstance().formatMessage;
			this._message.text=message;
			this._message.multiline=true;
			this._message.wordWrap=true;
			this._message.autoSize=TextFieldAutoSize.CENTER;
			this.addChild(this._message);
			
			if(textBouton2!=null && textBouton2!="" && textBouton2!=" ")  {
				this._textbtn2.defaultTextFormat=FormatsTextes.getInstance().formatBouton;
				this._textbtn2.text = textBouton2;
				this._textbtn2.multiline=false;
				this._textbtn2.wordWrap=false;
				this._textbtn2.autoSize=TextFieldAutoSize.CENTER;
				this.addChild(this._btn2);
				this.addChild(this._textbtn2);
				this._btn2.addEventListener(MouseEvent.MOUSE_UP, dechargerEventBtn);
				this._textbtn2.addEventListener(MouseEvent.MOUSE_UP, dechargerEventBtn);
				if(this._titre.text == "Sauvegarde effectuée"){
					this._btn2.addEventListener(MouseEvent.MOUSE_UP, creerNouvelAvatar);
					this._textbtn2.addEventListener(MouseEvent.MOUSE_UP, creerNouvelAvatar);
				}
				else if(this._titre.text == "Suppression de cet Avatar"){
					this._btn2.addEventListener(MouseEvent.MOUSE_UP, supprimerEnregistrement);
					this._textbtn2.addEventListener(MouseEvent.MOUSE_UP, supprimerEnregistrement);
				}
					
				
				this._textbtn1.defaultTextFormat=FormatsTextes.getInstance().formatBouton;
				this._textbtn1.text = textBouton1;
				this._textbtn1.multiline=false;
				this._textbtn1.wordWrap=false;
				this._textbtn1.autoSize=TextFieldAutoSize.CENTER;
				this.addChild(this._btn1);
				this.addChild(this._textbtn1);
				this._btn1.addEventListener(MouseEvent.MOUSE_UP, dechargerEventBtn);
				this._textbtn1.addEventListener(MouseEvent.MOUSE_UP, dechargerEventBtn);
			}
			else {
				this._textbtn1.defaultTextFormat=FormatsTextes.getInstance().formatBouton;
				this._textbtn1.text = textBouton1;
				this._textbtn1.multiline=false;
				this._textbtn1.wordWrap=false;
				this._textbtn1.autoSize=TextFieldAutoSize.CENTER;
				this.addChild(this._btn1);
				this.addChild(this._textbtn1);
				this._btn1.addEventListener(MouseEvent.MOUSE_UP, dechargerEventBtn);
				this._textbtn1.addEventListener(MouseEvent.MOUSE_UP, dechargerEventBtn);
			}
		}
		
		override public function charger():void{
			super.charger();
			this.dessiner(new Point(0,0),new Point(this.stage.fullScreenWidth,this.stage.fullScreenHeight));
			this._scene.setChildIndex(this, this._scene.numChildren-1);
			this._etatVisible = true;
		}
		
		override public function decharger():void{
			this._etatVisible = false;
			if(this._btn2.hasEventListener(MouseEvent.MOUSE_UP)) {
				this._btn2.removeEventListener(MouseEvent.MOUSE_UP, decharger);
			}
			if(this._textbtn2.hasEventListener(MouseEvent.MOUSE_UP)) {
				this._textbtn2.removeEventListener(MouseEvent.MOUSE_UP, decharger);
			}
			
			this._btn1.removeEventListener(MouseEvent.MOUSE_UP, decharger);
			this._textbtn1.removeEventListener(MouseEvent.MOUSE_UP, decharger);
			
			this._btnAction.btnEtatNormal();
			super.decharger();
		}

		override protected function dessiner(loc:Point, dim:Point):void{
			this.graphics.clear();
			this.graphics.lineStyle(1, 0x000000, 0.5);
			this.graphics.beginFill(0x000000, 0.5);
			this.graphics.drawRect(loc.x,loc.y,dim.x,dim.y);
			this.graphics.endFill();
			
			this.graphics.beginFill(0xd3d3d3, 1);
			this.graphics.drawRect(loc.x+50,dim.y/3,dim.x-100,341);
			this.graphics.endFill();
			
			this._titre.width=dim.x-150;
			this._titre.x=loc.x+75;
			this._titre.y=dim.y/3+25;
			
			this._message.width=dim.x-150;
			this._message.x=loc.x+75;
			this._message.y=dim.y/3+75;
			
			this._btn1.x=dim.x-(this._btn1.width+75);
			this._btn1.y=((dim.y/3)+341)-(this._btn1.height+25);
			this._textbtn1.x=this._btn1.x+15;
			this._textbtn1.y=this._btn1.y+15;
			this._textbtn1.width=this._btn1.width-25;
			
			this._btn2.x=this._btn1.x-(this._btn1.width+10);
			this._btn2.y=this._btn1.y;
			this._textbtn2.x=this._btn2.x+15;
			this._textbtn2.y=this._btn2.y+15;
			this._textbtn2.width=this._btn2.width-25;
			
			this._iconTabletRotate.x = dim.x/3-50;
			this._iconTabletRotate.y = this._message.y+this._message.height+30;
		}
		
		override protected function disposerVuePortrait():void{
			//dessiner la vue portrait!
			this.dessiner(new Point(0,0),new Point(this.stage.fullScreenWidth,this.stage.fullScreenHeight));
		}
		
		override protected function disposerVuePaysage():void{
			//dessiner la vue paysage!
			this.dessiner(new Point(0,0),new Point(this.stage.fullScreenWidth,this.stage.fullScreenHeight));
		}
		
		private function creerNouvelAvatar(e:MouseEvent):void {
			this._btn2.removeEventListener(MouseEvent.MOUSE_UP, creerNouvelAvatar);
			this._textbtn2.removeEventListener(MouseEvent.MOUSE_UP, creerNouvelAvatar);
			
			Avatar.getInstance().avatarNom = "Entrer un nom de Super-héro";
			Avatar.getInstance().avatarTete = "vide";
			Avatar.getInstance().avatarCorps = "vide";
			Avatar.getInstance().avatarJambes = "vide";
			
			this._nomAvatar.text = Avatar.getInstance().avatarNom;
		}
		
		private function supprimerEnregistrement(e:MouseEvent):void{
			this._btn2.removeEventListener(MouseEvent.MOUSE_UP, supprimerEnregistrement);
			this._textbtn2.removeEventListener(MouseEvent.MOUSE_UP, supprimerEnregistrement);
			this._controleur.supprimerEnregistrement();
		}
		
		private function dechargerEventBtn(e:MouseEvent = null):void {		
			this.decharger();
		}
		
		public function get etatVisible():Boolean {
			return _etatVisible;
		}
	}
}
