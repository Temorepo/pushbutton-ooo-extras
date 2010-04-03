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
        return entity.lookupComponentByName(TaskComponent.COMPONENT_NAME) as TaskComponent;
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

        var namedTaskContainer :ParallelTask = (_namedTasks.get(name) as ParallelTask);
        if (null == namedTaskContainer) {
            namedTaskContainer = new ParallelTask();
            _namedTasks.put(name, namedTaskContainer);
        } else if (removeExistingTasks) {
            namedTaskContainer.removeAllTasks();
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
            for each (var namedTaskContainer :* in _namedTasks) {
                if ((namedTaskContainer as ParallelTask).hasTasks()) {
                    return true;
                }
            }
        }

        return false;
    }

    /** Returns true if the IEntity has any tasks with the given name. */
    public function hasTasksNamed (name :String) :Boolean
    {
        var namedTaskContainer :ParallelTask = (_namedTasks.get(name) as ParallelTask);
        return (null == namedTaskContainer ? false : namedTaskContainer.hasTasks());
    }

    public function onTick (dt :Number) :void
    {
        update(dt);
    }

    /** Removes all tasks from the IEntity. */
    public function removeAllTasks () :void
    {
        if (_updatingTasks) {
            // if we're updating tasks, invalidate all named task containers so that
            // they stop iterating their children
            for each (var taskContainer :TaskContainer in _namedTasks.values()) {
                taskContainer.removeAllTasks();
            }
        }

        _anonymousTasks.removeAllTasks();
        _namedTasks.clear();
    }

    /** Removes all tasks with the given name from the IEntity. */
    public function removeNamedTasks (name :String) :void
    {
        if (null == name || name.length == 0) {
            throw new ArgumentError("name must be at least 1 character long");
        }

        var taskContainer :TaskContainer = _namedTasks.remove(name);

        // if we're updating tasks, invalidate this task container so that
        // it stops iterating its children
        if (null != taskContainer && _updatingTasks) {
            taskContainer.removeAllTasks();
        }
    }

    public function toString () :String
    {
        return "namedTasks: " + _namedTasks.keys().join(", ");
    }

    public function update (dt :Number) :void
    {
        _updatingTasks = true;
        _anonymousTasks.update(dt, owner);
        if (!_namedTasks.isEmpty()) {
            var thisEntity :IEntity = owner;
            _namedTasks.forEach(updateNamedTaskContainer);
        }
        _updatingTasks = false;

        function updateNamedTaskContainer (name :*, tasks :*) :void {
            // Tasks may be removed from the object during the _namedTasks.forEach() loop.
            // When this happens, we'll get undefined 'tasks' objects.
            if (undefined !== tasks) {
                (tasks as ParallelTask).update(dt, thisEntity);
            }
        }
    }

    override protected function onRemove () :void
    {
        super.onRemove();
        removeAllTasks();
    }

    protected var _anonymousTasks :ParallelTask = new ParallelTask();

    // stores a mapping from String to ParallelTask
    protected var _namedTasks :Map = Maps.newSortedMapOf(String);
    protected var _updatingTasks :Boolean;
}
}
