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
// $Id: GoToFrameTask.as 55 2010-01-06 12:32:20Z dionjw $

package com.threerings.pbe.tasks {

import flash.display.MovieClip;

import com.pblabs.engine.entity.IEntity;

public class GoToFrameTask
    implements IEntityTask
{
    public function GoToFrameTask (movie :MovieClip, frame :Object, scene :String = null,
        gotoAndPlay :Boolean = true)
    {
        _frame = frame;
        _scene = scene;
        _gotoAndPlay = gotoAndPlay;
        _movie = movie;
    }

    public function update (dt :Number, obj :IEntity) :Boolean
    {
        if (_gotoAndPlay) {
			_movie.gotoAndPlay(_frame, _scene);
        } else {
			_movie.gotoAndStop(_frame, _scene);
        }

        return true;
    }

    public function clone () :IEntityTask
    {
        return new GoToFrameTask(_movie, _frame, _scene, _gotoAndPlay);
    }

    protected var _frame :Object;
    protected var _scene :String;
    protected var _gotoAndPlay :Boolean;
    protected var _movie :MovieClip;
}

}
