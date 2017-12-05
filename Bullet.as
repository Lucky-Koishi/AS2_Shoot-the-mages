class Bullet extends MovieClip {
	public var speed:Number;		//移动速度
	public var direction:Number;	//移动方向（并不是朝向）
	public var exists:Number;		//从出现时开始计算的时间（子弹内部时间戳）
	public var type:Number;			//类型（对应行动规律）
	public var ken:MovieClip; 		//判定核心（该区域与自机重合才会导致MISS）
	public var rotated:Boolean;		//若为是，子弹改变方向时朝向会随之变化
	public var noVanish:Boolean;	//若为是，则不会因碰触边界消失
	//常数
	static var RIGHTSIDE = 1;
	static var BOTTOMSIDE = 2;
	static var LEFTSIDE = 4;
	static var TOPSIDE = 8;
	static var LR_SIDE = RIGHTSIDE|LEFTSIDE;
	static var TB_SIDE = BOTTOMSIDE|TOPSIDE;
	static var ALL_SIDE = LR_SIDE|TB_SIDE;
	public function Bullet() {
		rotated = true;
		noVanish = false;
		type = 0;
		exists = 0;
	}
	public function initial() {
		if(rotated)
			_rotation = direction;
		onEnterFrame = function () {
			exists++;
			if (!noVanish && (this._x<-80 || this._y<-80 || this._x>Stage.width+80 || this._y>Stage.height+80 )){
				removeMovieClip(this);
			}
			if(_root.boss.condition != Entity.COND_COMBAT){
				removeMovieClip(this);
			}
			if (_root.player && !_root.player.invincible && ken.hitTest(_root.player._x, _root.player._y, true)) {
				_root.player.removeMovieClip();
				_root.failRecover = 200;
			}
			moveMode(type);
		};
	}
	private function normalMove():Void {
		//直线运动
		var cos = Math.cos(direction/180*Math.PI);
		var sin = Math.sin(direction/180*Math.PI);
		if(rotated)
			_rotation = direction;
		_x += speed*cos;
		_y += speed*sin;
	}
	private function gravityMove(para:Number):Void {
		//重力运动（抛物线）para越大重力影响越小，para为负时为反重力
		var cos = Math.cos(direction/180*Math.PI);
		var sin = Math.sin(direction/180*Math.PI);
		if(rotated)
			_rotation = direction;
		_x += speed*cos;
		_y += speed*sin+exists/para;
	}
	private function accelerateMove(para:Number):Void{
		//加速运动 para越大加速度越大，para为负时为减速运动直至反向加速
		speed += para;
		normalMove();
	}
	private function directReflect(para:Number, dist:Number):Void{
		//界面反射判定，para方向参数，dist距离界面边界距离
		if((para&RIGHTSIDE) == RIGHTSIDE && _x>=Stage.width-dist && Math.floor((direction+90)/180)%2 == 0)
			direction = 180-direction;
		if((para&BOTTOMSIDE) == BOTTOMSIDE && _y>=Stage.height-dist && Math.floor((direction)/180)%2 == 0)
			direction = -direction;
		if((para&LEFTSIDE) == LEFTSIDE && _x<=dist && Math.floor((direction+90)/180)%2 != 0)
			direction = 180-direction;
		if((para&TOPSIDE) == TOPSIDE && _y<=dist && Math.floor(direction/180)%2 != 0)
			direction = -direction;
	}
	private function trackMove():Void {
		//追踪移动
		direction = 180+180*Math.atan2(_y-_root.player._y, _x-_root.player._x)/Math.PI;
		normalMove();
	}
	private function rotate(para:Number):Void{
		//自身旋转 para为旋转角度，整数为顺时针，适用于激光型或长条形弹幕
		direction += para;
		_rotation = direction;
	}
	private function getXY():Array{
		//子弹当前坐标
		return [_x,_y];
	}
	private function moveMode(bulletType:Number):Void {
		//详细的移动模式
		switch (bulletType) {
		case 0 :
			normalMove();
			break;
		case 1.11:
			if(exists<30){
				_x = _root.boss._x;
				_y = _root.boss._y-65-exists/3;
			}else{
				normalMove();
			}
			directReflect(ALL_SIDE,30);
			break;
		case 1.12:
			normalMove();
			if(exists>200)
				removeMovieClip(this);
			break;
		case 1.21:
			if(exists<30){
				_x = _root.boss._x;
				_y = _root.boss._y-65-exists/3;
			}else{
				accelerateMove(0.2);
			}
			directReflect(TB_SIDE,30);
			break;
		case 1.31:
			_x = _root.boss._x;
			_y = _root.boss._y;
			if(exists>=50 && exists<=220){
				rotate(1);
			}
			if(exists>=250){
				removeMovieClip(this);
			}
			break;
		case 1.32:
			_x = _root.boss._x;
			_y = _root.boss._y;
			if(exists>=50 && exists<=220){
				rotate(-1);
			}
			if(exists>=250){
				removeMovieClip(this);
			}
			break;
		}
	}
}
