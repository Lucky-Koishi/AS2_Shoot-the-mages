class Bullet2 extends MovieClip {
	var speed:Number;
	var direction:Number;
	var exists:Number;	//从出现时的时间
	var type:Number;
	//种类
	function Bullet2() {
		exists = 0;
	}
	function initial() {
		_rotation = direction;
		onEnterFrame = function () {
			exists++;
			if (this._x<-80 || this._y<-80 || this._x>Stage.width+80 || this._y>Stage.height+80) {
				removeMovieClip(this);
			}
			if (!_root.boss.invincible && hitTest(_root.boss._x, _root.boss._y, true)) {
				_root.boss.life --;
				_root.charge += 1;
				removeMovieClip(this);
				//trace("MISS!");
			}
			moveMode(type);
		};
	}
	function normalMove():Void {
		//直线运动
		var cos = Math.cos(direction/180*Math.PI);
		var sin = Math.sin(direction/180*Math.PI);
		_rotation = direction;
		_x += speed*cos;
		_y += speed*sin;
	}
	function gravityMove(para:Number):Void {
		//重力运动（抛物线）para越大重力影响越小，para为负时为反重力
		var cos = Math.cos(direction/180*Math.PI);
		var sin = Math.sin(direction/180*Math.PI);
		_rotation = direction;
		_x += speed*cos;
		_y += speed*sin+exists/para;
	}
	function directChange(para:Number):Void{
		//更改角度：1为水平翻转，2为垂直翻转，3为旋转180
		switch(para){
			case 1:
				direction = -direction;
			break;
			case 2:
				direction = 180-direction;
			break;
			case 3:
				direction = direction-180;
			break;
		}
	}
	private function getXY():Array{
		return [_x,_y];
	}
	function moveMode(bulletType:Number):Void {
		switch (bulletType) {
		case 0 :
			normalMove();
			break;
		}
	}
}
