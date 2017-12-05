class Player extends MovieClip{
	public var life:Number;
	public var speedx, speedy:Number;
	public var direction:Number;	//MC角度不会因朝向改变
	public var exists:Number; //响应时间戳
	public var invincible:Boolean;
	public function Player(){
		exists = 0;
		speedx = 0;
		speedy = 0;
		invincible = true;
		gotoAndStop(3);
		onEnterFrame = function(){
			exists ++;
			var i = 5;
			if(exists == 120){
				//前2秒是无敌的
				invincible = false;
				gotoAndStop(1);
			}
			if(Key.isDown(Key.SHIFT)){
				i = 2;
			}
			if(Key.isDown(65) || Key.isDown(97)){
				if(this._x>=10){
					this._x -= i;
				}
			}
			if(Key.isDown(68) || Key.isDown(100)){
				if(this._x<= Stage.width - 10){
					this._x += i;
				}
			}
			if(Key.isDown(87) || Key.isDown(119)){
				if(this._y>= 10){
					this._y -= i;
				}
			}
			if(Key.isDown(83) || Key.isDown(115)){
				if(this._y<= Stage.height - 10){
					this._y += i;
				}
			}
			if(Key.isDown(75) || Key.isDown(107)){
				if(exists % 8 ==0){
					_root.createBullet("P1_normal", 0, {point:[_x,_y],direction:0,speed:12,auto:false});
				}
			}
		}
	}
}