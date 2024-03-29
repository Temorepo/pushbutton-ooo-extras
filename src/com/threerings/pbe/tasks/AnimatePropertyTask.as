// Pushbutton tasks - tasks for the Pushbutton Engine framework.
// http://code.google.com/p/pushbutton-tasks/
//
// Adapted from http://code.google.com/p/flashbang/
//
// This library is free software: you can redistribute it and/or modify
// it under the terms of the GNU Lesser General Public License as published by
// the Free Software Foundation, either version 3 of the License, or
// (at your option) any later version.
//
// This library is distributed in the hope that it will be useful,
// but WITHOUT ANY WARRANTY; without even the implied warranty of
// MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
// GNU Lesser General Public License for more details.
//
// You should have received a copy of the GNU Lesser General Public License
// along with this library.  If not, see <http://www.gnu.org/licenses/>.
//
// Copyright 2008 Three Rings Design
//
// $Id: AnimatePropertyTask.as 55 2010-01-06 12:32:20Z dionjw $

package com.threerings.pbe.tasks {

import com.pblabs.engine.entity.IEntity;
import com.pblabs.engine.entity.PropertyReference;

import mx.effects.easing.*;

public class AnimatePropertyTask extends InterpolatingTask
{
    public static function CreateLinear (ref :PropertyReference, targetValue :Number, time :Number)
        :AnimatePropertyTask
    {
        return new AnimatePropertyTask(
            ref,
            targetValue,
            time,
            mx.effects.easing.Linear.easeNone);
    }

    public static function CreateSmooth (ref :PropertyReference, targetValue :Number, time :Number)
        :AnimatePropertyTask
    {
        return new AnimatePropertyTask(
            ref,
            targetValue,
            time,
            mx.effects.easing.Cubic.easeInOut);
    }

    public static function CreateEaseIn (ref :PropertyReference, targetValue :Number, time :Number)
        :AnimatePropertyTask
    {
        return new AnimatePropertyTask(
            ref,
            targetValue,
            time,
            mx.effects.easing.Cubic.easeIn);
    }

    public static function CreateEaseOut (ref :PropertyReference, targetValue :Number, time :Number)
        :AnimatePropertyTask
    {
        return new AnimatePropertyTask(
            ref,
            targetValue,
            time,
            mx.effects.easing.Cubic.easeOut);
    }

    public function AnimatePropertyTask (
        ref :PropertyReference,
        targetValue :Number,
        time :Number = 0,
        easingFn :Function = null)
    {
        super(time, easingFn);

        if (null == ref) {
            throw new Error("ref must be non null, and must contain a 'value' property");
        }

        _to = targetValue;
        _valueRef = ref;
    }

    override public function update (dt :Number, obj :IEntity) :Boolean
    {
        if (0 == _elapsedTime) {
            _from = obj.getProperty(_valueRef) as Number;
            if (isNaN(_from)) {
                throw new Error("_valueRef must be non null, and must be a numerical property.");
            }
        }
        super.update(dt, obj);
        obj.setProperty(_valueRef, interpolate(_from, _to));

        return (_elapsedTime >= _totalTime);
    }

    override public function clone () :IEntityTask
    {
        return new AnimatePropertyTask(_valueRef, _to, _totalTime, _easingFn);
    }

    protected var _to :Number;
    protected var _from :Number;
    protected var _valueRef :PropertyReference;
}

}
