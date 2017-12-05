//initPara:
//point:Array 坐标点
//direction:Number 朝向（角度制）
//speed:Number 初速度
//auto:Boolean 自机狙
//rotated:Boolean 旋转
//noVanish:Boolean 碰触边界不消失
function createBullet(linkName:String, moveType:Number, initPara:Object) {
	var ran = Math.floor(Math.random()*100000);
	_root.attachMovie(linkName, linkName+ran, _root.getNextHighestDepth());
	_root[linkName+ran]._x = initPara.point[0];
	_root[linkName+ran]._y = initPara.point[1];
	_root[linkName+ran].speed = initPara.speed;
	_root[linkName+ran].direction = initPara.direction;
	_root[linkName+ran].rotated = initPara.rotated;
	_root[linkName+ran].noVanish = initPara.noVanish;
	if(initPara.auto){
		var _px, _py:Number;
		if(_root.player){
			_px = _root.player._x;
			_py = _root.player._y;
		}else{
			_px = 0;
			_py = 0;
		}
		var deltaAngle = 180+180*Math.atan2(initPara.point[1]-_py, initPara.point[0]-_px)/Math.PI;
		_root[linkName+ran].direction += deltaAngle;
	}
	_root[linkName+ran].type = moveType;
	_root[linkName+ran].initial();
}
//initPara:
function createEntity(linkName:String, actionType:Number, initPara:Object){
	if(_root.boss){
		_root.boss.removeMovieClip();
	}
	_root.attachMovie(linkName, "boss", _root.getNextHighestDepth());
	_root.boss.type = actionType;
	_root.boss.lifeMax = initPara.life;
	_root.boss.initial();
}
function createPlayer(){
	if(_root.player){
		_root.player.removeMovieClip();
	}
	_root.attachMovie("player", "player", _root.getNextHighestDepth());
	_root.player._x = 100;
	_root.player._y = Stage.height/2;
	_root.player.initial();
}
//全局时间控制
var tick = 0;
function resetTick() {
	_root.tick = 0;
}
function getTick():Number {
	return _root.tick;
}
function runTick() {
	_root.tick++;
}

