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
// $Id: TaskComponent.as 62 2010-03-26 13:44:01Z dionjw $

package com.threerings.pbe.tasks {
import com.pblabs.engine.core.ITickedObject;
import com.pblabs.engine.entity.EntityComponent;
import com.pblabs.engine.entity.IEntity;

import com.threerings.util.Map;
import com.threerings.util.Maps;

/**
 * If you're using the Pushbutton engine as your main framework, don't use this class.
 * This is for the flashbang version.
 */
public class TaskComponent extends EntityComponent implements ITickedObject
{
    public static const COMPONENT_NAME :String = "tasks";

    public static function getFrom (entity :IEntity) :TaskComponent
    {
        return entity.lookupComponentByName(COMPONENT_NAME) as TaskComponent;
    }

    /** Adds a named task to this IEntity. */
    public function addNamedTask (name :String, task :IEntityTask, removeExistingTasks :Boolean =
        false) :void
    {
        if (null == task) {
            throw new ArgumentError("task must be non-null");
        }

        if (null == name || name.length == 0) {
            throw new ArgumentError("name must be at least 1 character long");
        }

        var idx :int = _taskNames.indexOf(name);
        var namedTaskContainer :TaskContainer;
        if (idx == -1) {
            namedTaskContainer = new ParallelTask();
            _taskNames.push(name);
            _namedTasks.push(namedTaskContainer);
        } else {
            namedTaskContainer = _namedTasks[idx];
            if (removeExistingTasks) {
                namedTaskContainer.removeAllTasks();
            }
        }

        namedTaskContainer.addTask(task);
    }

    /** Adds an unnamed task to this IEntity. */
    public function addTask (task :IEntityTask) :void
    {
        if (null == task) {
            throw new ArgumentError("task must be non-null");
        }

        _anonymousTasks.addTask(task);
    }

    /** Returns true if the IEntity has any tasks. */
    public function hasTasks () :Boolean
    {
        if (_anonymousTasks.hasTasks()) {
            return true;
        } else {
            return _namedTasks.some(function (container :ParallelTask, ..._) :Boolean {
                return container != null && container.hasTasks();
            });
        }

        return false;
    }

    /** Returns true if the IEntity has any tasks with the given name. */
    public function hasTasksNamed (name :String) :Boolean
    {
        var idx :int = _taskNames.indexOf(name);
        return idx != -1 && ParallelTask(_namedTasks[idx]).hasTasks();
    }

    public function onTick (dt :Number) :void
    {
        _updatingTasks = true;
        var entity :IEntity = owner;
        _anonymousTasks.update(dt, entity);
        for each (var namedTask :ParallelTask in _namedTasks) {
            if (namedTask != null) {// Can be nulled out by being removed during the update
                namedTask.update(dt, entity);
            }
        }
        if (_collapseRemovedTasks) {
            // Only iterate over the _namedTasks array if there are removed tasks in there
            _collapseRemovedTasks = false;
            for (var ii :int = 0; ii < _namedTasks.length; ii++) {
                if (_namedTasks[ii] === null) {
                    _namedTasks.splice(ii, 1);
                    _taskNames.splice(ii--, 1);
                }
            }
        }
        _updatingTasks = false;
    }

    /** Removes all tasks from the IEntity. */
    public function removeAllTasks () :void
    {
        if (_updatingTasks) {
            // if we're updating tasks, invalidate all named task containers so that
            // they stop iterating their children
            for each (var taskContainer :TaskContainer in _namedTasks) {
                if (taskContainer != null) {
                    taskContainer.removeAllTasks();
                }
            }
        }

        _anonymousTasks.removeAllTasks();
        _namedTasks = [];
        _taskNames = [];
    }

    /** Removes all tasks with the given name from the IEntity. */
    public function removeNamedTasks (name :String) :void
    {
        if (null == name || name.length == 0) {
            throw new ArgumentError("name must be at least 1 character long");
        }

        var idx :int = _taskNames.indexOf(name);
        if (idx != -1) {
            // if we're updating tasks, invalidate this task container so that
            // it stops iterating its children
            if (_updatingTasks) {
                _namedTasks[idx].removeAllTasks();
                _namedTasks[idx] = null;
                _taskNames[idx] = null;
                _collapseRemovedTasks = true;
            } else {
                _taskNames.splice(idx, 1);
                _namedTasks.splice(idx, 1);
            }
        }
    }

    public function toString () :String
    {
        return "namedTasks: " + _taskNames.join(", ");
    }


    override protected function onRemove () :void
    {
        super.onRemove();
        removeAllTasks();
    }

    protected var _anonymousTasks :ParallelTask = new ParallelTask();

    // The names of the tasks in _namedTasks in the same order as _namedTasks.  These arrays
    // function as a Map, but they're maintained as parallel arrays to speed up iterating over
    // the tasks in updateInternal while maintaining a deterministic task iteration order.
    protected var _taskNames :Array = [];//<String>
    protected var _namedTasks :Array = [];//<ParallelTask>
    protected var _updatingTasks :Boolean;
    // True if tasks were removed while an update was in progress
    protected var _collapseRemovedTasks :Boolean;

    // The tick value and owner during an update.  Only valid while _updatintTasks is true.
    protected var _delta :Number;
    protected var _thisEntity :IEntity;

}
}
