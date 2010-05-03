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
// $Id: VisibleTask.as 55 2010-01-06 12:32:20Z dionjw $

package com.threerings.pbe.tasks {

import flash.display.DisplayObject;

import com.pblabs.engine.entity.IEntity;

public class VisibleTask
    implements IEntityTask
{
    public function VisibleTask (visible :Boolean, disp :DisplayObject)
    {
        _visible = visible;
        _disp = disp;
    }

    public function update (dt :Number, obj :IEntity) :Boolean
    {
        _disp.visible = _visible;
        return true;
    }

    public function clone () :IEntityTask
    {
        return new VisibleTask(_visible, _disp);
    }

    protected var _visible :Boolean;
    protected var _disp :DisplayObject;
}

}
