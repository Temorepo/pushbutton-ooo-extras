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
// $Id: InterpolatingTask.as 55 2010-01-06 12:32:20Z dionjw $

package com.threerings.pbe.tasks {

import com.pblabs.engine.entity.IEntity;
import com.threerings.util.MathUtil;

import mx.effects.easing.Linear;

public class InterpolatingTask
    implements IEntityTask
{
    public function InterpolatingTask (time :Number = 0, easingFn :Function = null)
    {
        _totalTime = Math.max(time, 0);
        // default to linear interpolation
        _easingFn = (easingFn != null ? easingFn : mx.effects.easing.Linear.easeNone);
    }

    public function update (dt :Number, obj :IEntity) :Boolean
    {
        _elapsedTime += dt;
        return (_elapsedTime >= _totalTime);
    }

    public function clone () :IEntityTask
    {
        return new InterpolatingTask(_totalTime, _easingFn);
    }

    protected static function interpolate (a :Number, b :Number, t :Number, duration :Number,
        easingFn :Function) :Number
    {
        // we need to rejuggle arguments to fit the signature of the mx easing functions:
        // ease(t, b, c, d)
        // t - specifies time
        // b - specifies the initial position of a component
        // c - specifies the total change in position of the component
        // d - specifies the duration of the effect, in milliseconds

        if (duration <= 0) {
            return b;
        }
        t = MathUtil.clamp(t, 0, duration);
        return easingFn(t * 1000, a, (b - a), duration * 1000);
    }

    protected var _totalTime :Number = 0;
    protected var _elapsedTime :Number = 0;

    protected var _easingFn :Function;
}

}
