package com.threerings.pbe.tasks
{

import com.pblabs.engine.entity.IEntity;

import mx.effects.easing.*;

public class AnimateValueTask extends InterpolatingTask
{
    public static function CreateLinear (obj :*, fieldName :String, targetValue :Number, time :Number)
        :AnimateValueTask
    {
        return new AnimateValueTask(
            obj,
            fieldName,
            targetValue,
            time,
            mx.effects.easing.Linear.easeNone);
    }

    public static function CreateSmooth (obj :*, fieldName :String, targetValue :Number, time :Number)
        :AnimateValueTask
    {
        return new AnimateValueTask(
            obj,
            fieldName,
            targetValue,
            time,
            mx.effects.easing.Cubic.easeInOut);
    }

    public static function CreateEaseIn (obj :*, fieldName :String, targetValue :Number, time :Number)
        :AnimateValueTask
    {
        return new AnimateValueTask(
            obj,
            fieldName,
            targetValue,
            time,
            mx.effects.easing.Cubic.easeIn);
    }

    public static function CreateEaseOut (obj :*, fieldName :String, targetValue :Number, time :Number)
        :AnimateValueTask
    {
        return new AnimateValueTask(
            obj,
            fieldName,
            targetValue,
            time,
            mx.effects.easing.Cubic.easeOut);
    }

    public function AnimateValueTask (
        obj :*,
        fieldName :String,
        targetValue :Number,
        time :Number = 0,
        easingFn :Function = null)
    {
        super(time, easingFn);

        if (null == obj) {
            throw new Error("obj must be non null, and must contain a 'value' property");
        }

        _to = targetValue;
        _obj = obj;
        _fieldName = fieldName;
    }

    override public function update (dt :Number, obj :IEntity) :Boolean
    {
        if (0 == _elapsedTime) {
            _from = _obj[_fieldName] as Number;
            if (isNaN(_from)) {
                throw new Error("_valueRef must be non null, and must be a numerical property.");
            }
        }

        super.update(dt, obj);

        _obj[_fieldName] = interpolate(_from, _to);

        return (_elapsedTime >= _totalTime);
    }

    override public function clone () :IEntityTask
    {
        return new AnimateValueTask(_obj, _fieldName, _to, _totalTime, _easingFn);
    }

    protected var _to :Number;
    protected var _from :Number;
    protected var _obj :*;
    protected var _fieldName :String;
}

}