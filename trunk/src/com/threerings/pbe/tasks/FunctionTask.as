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
// $Id: FunctionTask.as 59 2010-01-28 17:20:19Z dionjw $

package com.threerings.pbe.tasks {
	import com.pblabs.engine.entity.IEntity;
	
	
	public class FunctionTask
		implements IEntityTask
	{
		public function FunctionTask (fn :Function, ...args)
		{
			if (null == fn) {
				throw new ArgumentError("fn must be non-null");
			}
			
			_fn = fn;
			_args = args;
		}
		
		public function update (dt :Number, obj :IEntity) :Boolean
		{
			_fn.apply(null, _args);
			return true;
		}
		
		public function clone () :IEntityTask
		{
			var task :FunctionTask = new FunctionTask(_fn);
			// Work around for the pain associated with passing a normal Array as a varargs Array
			task._args = _args;
			return task;
		}
		
		protected var _fn :Function;
		protected var _args :Array;
	}
	
}
