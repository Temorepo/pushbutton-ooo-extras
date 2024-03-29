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
// $Id: TaskContainer.as 55 2010-01-06 12:32:20Z dionjw $

package com.threerings.pbe.tasks {
import com.pblabs.engine.entity.IEntity;

import com.threerings.util.ArrayUtil;
import com.threerings.util.Assert;

public class TaskContainer
    implements IEntityTask
{

    public static const TYPE__LIMIT :uint = 3;
    public static const TYPE_PARALLEL :uint = 0;
    public static const TYPE_REPEATING :uint = 2;
    public static const TYPE_SERIAL :uint = 1;

    public function TaskContainer (type :uint, subtasks :Array = null)
    {
        if (type >= TYPE__LIMIT) {
            throw new ArgumentError("invalid 'type' parameter");
        }

        _type = type;

        if (subtasks != null) {
            for each (var task :IEntityTask in subtasks) {
                addTask(task);
            }
        }
    }

    /** Adds a child task to the TaskContainer. */
    public function addTask (task :IEntityTask) :void
    {
        if (null == task) {
            throw new ArgumentError("task must be non-null");
        }

        _tasks.push(task);
        _completedTasks.push(null);
        _activeTaskCount += 1;
    }

    /** Returns a clone of the TaskContainer. */
    public function clone () :IEntityTask
    {
        var clonedSubtasks :Array = cloneSubtasks();

        var theClone :TaskContainer = new TaskContainer(_type);
        theClone._tasks = clonedSubtasks;
        theClone._completedTasks = ArrayUtil.create(clonedSubtasks.length, null);
        theClone._activeTaskCount = clonedSubtasks.length;

        return theClone;
    }

    /** Returns true if the TaskContainer has any child tasks. */
    public function hasTasks () :Boolean
    {
        return (_activeTaskCount > 0);
    }

    /** Removes all tasks from the TaskContainer. */
    public function removeAllTasks () :void
    {
        _invalidated = true;
        _tasks = new Array();
        _completedTasks = new Array();
        _activeTaskCount = 0;
    }

    public function update (dt :Number, obj :IEntity) :Boolean
    {
        _invalidated = false;

        for (var i :int = 0; i < _tasks.length; ++i) {

            var task :IEntityTask = (_tasks[i] as IEntityTask);

            // we can have holes in the array
            if (null == task) {
                continue;
            }

            var complete :Boolean = task.update(dt, obj);

            if (_invalidated) {
                // The TaskContainer was destroyed by its containing
                // IEntity during task iteration. Stop processing immediately.
                return false;
            }

            if (!complete && TYPE_PARALLEL != _type) {
                // Serial and Repeating tasks proceed one task at a time
                break;

            } else if (complete) {
                // the task is complete - move it the completed tasks array
                _completedTasks[i] = _tasks[i];
                _tasks[i] = null;
                _activeTaskCount -= 1;
            }
        }

        // if this is a repeating task and all its tasks have been completed, start over again
        if (_type == TYPE_REPEATING && 0 == _activeTaskCount && _completedTasks.length > 0) {
            var completedTasks :Array = _completedTasks;

            _tasks = new Array();
            _completedTasks = new Array();

            for each (var completedTask :IEntityTask in completedTasks) {
                addTask(completedTask.clone());
            }
        }

        // once we have no more active tasks, we're complete
        return (0 == _activeTaskCount);
    }

    protected function cloneSubtasks () :Array
    {
        Assert.isTrue(_tasks.length == _completedTasks.length);

        var out :Array = new Array(_tasks.length);

        // clone each child task and put it in the cloned container
        var n :int = _tasks.length;
        for (var i :int = 0; i < n; ++i) {
            var task :IEntityTask =
                (null != _tasks[i] ? _tasks[i] as IEntityTask : _completedTasks[i] as IEntityTask);
            Assert.isNotNull(task);
            out[i] = task.clone();
        }

        return out;
    }
    protected var _activeTaskCount :int;
    protected var _completedTasks :Array = new Array();
    protected var _invalidated :Boolean;
    protected var _tasks :Array = new Array();

    protected var _type :int;
}

}
