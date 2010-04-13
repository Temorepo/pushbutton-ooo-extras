package com.threerings.pbe.tasks
{

import com.pblabs.engine.entity.IEntity;
import com.threerings.pbe.tasks.IEntityTask;
import com.threerings.pbe.tasks.InterpolatingTask;

import flash.display.DisplayObject;

import mx.effects.easing.*;

public class AlphaTask extends InterpolatingTask
{
    public static function CreateLinear (disp :DisplayObject, alpha :Number, time :Number)
        :AlphaTask
    {
        return new AlphaTask(disp, alpha, time, mx.effects.easing.Linear.easeNone);
    }

    public static function CreateSmooth (disp :DisplayObject, alpha :Number, time :Number)
        :AlphaTask
    {
        return new AlphaTask(disp, alpha, time, mx.effects.easing.Cubic.easeInOut);
    }

    public static function CreateEaseIn (disp :DisplayObject, alpha :Number, time :Number)
        :AlphaTask
    {
        return new AlphaTask(disp, alpha, time, mx.effects.easing.Cubic.easeIn);
    }

    public static function CreateEaseOut (disp :DisplayObject, alpha :Number, time :Number)
        :AlphaTask
    {
        return new AlphaTask(disp, alpha, time, mx.effects.easing.Cubic.easeOut);
    }

    public function AlphaTask (disp :DisplayObject, alpha :Number, time :Number = 0,
                               easingFn :Function = null)
    {
        super(time, easingFn);
        _to = alpha;
        _disp = disp;
    }

    override public function update (dt :Number, obj :IEntity) :Boolean
    {
        if (0 == _elapsedTime) {
            _from = _disp.alpha;
        }

        _elapsedTime += dt;

        _disp.alpha = interpolate(_from, _to);

        return (_elapsedTime >= _totalTime);
    }

    override public function clone () :IEntityTask
    {
        return new AlphaTask(_disp, _to, _totalTime, _easingFn);
    }

    protected var _to :Number;
    protected var _from :Number;
    protected var _disp :DisplayObject;
}
}