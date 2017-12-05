class Entity extends MovieClip {
	public var life:Number;
	public var lifeMax:Number;
	public var speed:Number;//速度
	public var direction:Number;//移动方向
	public var exists:Number;//响应时间戳
	public var type:Number;//动作类型
	public var period:Number;//阶段
	public var condition:Number;//状态
	static var COND_WAIT:Number = 0;//待机状态
	static var COND_COMBAT:Number = 1;
	static var COND_RESTORE:Number = 2;//归位
	static var COND_KNOCKOUT:Number = 3;//击破
	public function Entity() {
		condition = COND_WAIT;
		life = 1;
		period = 0;
		exists = 0;
	}
	public function initial() {
		onEnterFrame = function () {
			switch (condition) {
			case COND_WAIT :
				_x = 470;
				_y = 240;
				if (!_root.player.invincible && hitTest(_root.player._x, _root.player._y, true)) {
					_root.player.removeMovieClip();
					_root.failRecover = 200;
				}
				break;
			case COND_COMBAT :
				exists++;
				if (life<0) {
					if (period == 3) {
						condition = COND_KNOCKOUT;
						exists = 0;
					} else {
						condition = COND_RESTORE;
						exists = 0;
					}
				}
				if (!_root.player.invincible && hitTest(_root.player._x, _root.player._y, true)) {
					_root.player.removeMovieClip();
					_root.failRecover = 200;
					life -= 1;
				}
				actionMode(type+period/10);
				break;
			case COND_RESTORE:
				exists++;
				if (!_root.player.invincible && hitTest(_root.player._x, _root.player._y, true)) {
					_root.player.removeMovieClip();
					_root.failRecover = 200;
				}
				if(exists == 100){
					startBattle();
					exists = 0;
				}
				break;
			case COND_KNOCKOUT:
				exists++;
				//_root.boss.gotoAndStop("fainted");
				if(exists == 100){
					removeMovieClip(this);
				}
				break;
			}
		};
	}
	public function startBattle() {
		period++;
		condition = COND_COMBAT;
		life = lifeMax;
	}
	private function getXY():Array {
		return [_x, _y];
	}
	private function actionMode(nType:Number):Void {
		//移动规律
		switch (nType) {
		case 0 :
			break;
		case 1.1 :
			_x = 470+50*Math.sin(exists/80);
			_y = 240+100*Math.sin(exists/50);
			if (exists == 10) {
				_root.createBullet("E1_creator_1_magicball", 1.11, {point:[_x, _y-65], direction:135, speed:7, auto:false, rotated:true, noVanish:false});
			}
			if (exists == 110) {
				_root.createBullet("E1_creator_1_magicball", 1.11, {point:[_x, _y-65], direction:10, speed:7, auto:true, rotated:true, noVanish:false});
			}
			break;
		case 1.2 :
			_x = 470+50*Math.sin(exists/80);
			_y = 240+100*Math.sin(exists/50);
			if (exists%60 == 10) {
				_root.createBullet("E1_creator_2_fireball", 1.21, {point:[_x, _y-65], direction:0, speed:4, auto:true, rotated:true, noVanish:false});
			}
			break;
		case 1.3 :
			_x = 470+10*Math.sin(exists/80);
			_y = 240+10*Math.sin(exists/50);
			if (exists%800 == 10) {
				_root.createBullet("E1_creator_3_superwindwave", 1.31, {point:[_x, _y], direction:95, speed:0, auto:false, rotated:true, noVanish:false});
			}
			if (exists%800 == 410) {
				_root.createBullet("E1_creator_3_superwindwave", 1.32, {point:[_x, _y], direction:-95, speed:0, auto:false, rotated:true, noVanish:false});
			}
			if (exists%80 == 10) {
				_root.createBullet("E1_creator_3_small", 0, {point:[_x, _y], direction:Math.random()*360, speed:1, auto:false, rotated:true, noVanish:false});
				_root.createBullet("E1_creator_3_small", 0, {point:[_x, _y], direction:Math.random()*360, speed:1, auto:false, rotated:true, noVanish:false});
				_root.createBullet("E1_creator_3_small", 0, {point:[_x, _y], direction:Math.random()*360, speed:1, auto:false, rotated:true, noVanish:false});
			}
			break;
		}
	}
}
