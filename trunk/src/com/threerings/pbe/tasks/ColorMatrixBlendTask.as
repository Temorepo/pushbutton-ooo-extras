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
// $Id: ColorMatrixBlendTask.as 55 2010-01-06 12:32:20Z dionjw $

package com.threerings.pbe.tasks {
import com.pblabs.engine.entity.IEntity;
import com.threerings.display.ColorMatrix;
import com.threerings.display.FilterUtil;

import flash.display.DisplayObject;
import flash.filters.ColorMatrixFilter;

import mx.effects.easing.*;

public class ColorMatrixBlendTask 
	implements IEntityTask
{

    public static function colorize (fromColor :uint, toColor :uint, time :Number,
        disp :DisplayObject, easingFn :Function = null, preserveFilters :Boolean = false,
        removeFilterWhenComplete :Boolean = false) :ColorMatrixBlendTask
    {
        return new ColorMatrixBlendTask(new ColorMatrix().colorize(fromColor, 1),
            new ColorMatrix().colorize(toColor, 1), time, disp, easingFn, preserveFilters);
    }

    public static function fadeFromBlack (time :Number, disp :DisplayObject,
        easingFn :Function = null, preserveFilters :Boolean = false,
        removeFilterWhenComplete :Boolean = true) :ColorMatrixBlendTask
    {
        return new ColorMatrixBlendTask(BLACK, IDENTITY, time, disp, easingFn, preserveFilters,
            removeFilterWhenComplete);
    }

    public static function fadeToBlack (time :Number, disp :DisplayObject,
        easingFn :Function = null, preserveFilters :Boolean = false,
        removeFilterWhenComplete :Boolean = false) :ColorMatrixBlendTask
    {
        return new ColorMatrixBlendTask(IDENTITY, BLACK, time, disp, easingFn, preserveFilters,
            removeFilterWhenComplete);
    }

    public function ColorMatrixBlendTask (cmFrom :ColorMatrix, cmTo :ColorMatrix, time :Number,
        disp :DisplayObject, easingFn :Function = null, preserveFilters :Boolean = false,
        removeFilterWhenComplete :Boolean = false)
    {
        _disp = disp;
        _from = cmFrom;
        _to = cmTo;
        _totalTime = time;
        _easingFn = (easingFn != null ? easingFn : mx.effects.easing.Linear.easeNone);
        _preserveFilters = preserveFilters;
        _removeFilterWhenComplete = removeFilterWhenComplete;
    }

    public function clone () :IEntityTask
    {
        return new ColorMatrixBlendTask(_from, _to, _totalTime, _disp,
            _easingFn, _preserveFilters);
    }

    public function update (dt :Number, obj :IEntity) :Boolean
    {
        _elapsedTime += dt;

        var complete :Boolean = (_elapsedTime >= _totalTime);
        var filter :ColorMatrixFilter;
        if (!complete || !_removeFilterWhenComplete) {
            var amount :Number = _easingFn(Math.min(_elapsedTime, _totalTime), 0, 1, _totalTime);
            filter = _from.clone().blend(_to, amount).createFilter();
        }

        // If _preserveFilters is set, we'll preserve any filters already on the DisplayObject
        // when adding the new filter. This can be an expensive operation, so it's false by default.
        if (_preserveFilters) {
            if (_oldFilter != null) {
                FilterUtil.removeFilter(_disp, _oldFilter);
            }
            if (filter != null) {
                FilterUtil.addFilter(_disp, filter);
                _oldFilter = filter;
            }

        } else {
            _disp.filters = (filter != null ? [ filter ] : []);
        }

        return complete;
    }

    protected var _disp :DisplayObject;
    protected var _easingFn :Function;

    protected var _elapsedTime :Number = 0;
    protected var _from :ColorMatrix;

    protected var _oldFilter :ColorMatrixFilter;
    protected var _preserveFilters :Boolean;
    protected var _removeFilterWhenComplete :Boolean;
    protected var _to :ColorMatrix;
    protected var _totalTime :Number;
    protected static const BLACK :ColorMatrix = new ColorMatrix().tint(0);

    protected static const IDENTITY :ColorMatrix = new ColorMatrix();
}

}
