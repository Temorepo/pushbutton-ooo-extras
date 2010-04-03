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
// $Id: TickedTaskComponent.as 55 2010-01-06 12:32:20Z dionjw $

package com.threerings.pbe.tasks {
import com.pblabs.engine.core.ITickedObject;
import com.pblabs.engine.core.ProcessManager;

public class TickedTaskComponent extends TaskComponent
{
	
	/**
	 * The update priority for this component. Higher numbered priorities have
	 * onInterpolateTick and onTick called before lower priorities.
	 */
	public var updatePriority:Number = 0.0;
	
	private var _registerForUpdates:Boolean = true;
	private var _isRegisteredForUpdates:Boolean = false;
	
	/**
	 * Set to register/unregister for tick updates.
	 */
	public function set registerForTicks(value:Boolean):void
	{
		_registerForUpdates = value;
		
		if(_registerForUpdates && !_isRegisteredForUpdates)
		{
			// Need to register.
			_isRegisteredForUpdates = true;
			ProcessManager.instance.addTickedObject(this, updatePriority);                
		}
		else if(!_registerForUpdates && _isRegisteredForUpdates)
		{
			// Need to unregister.
			_isRegisteredForUpdates = false;
			ProcessManager.instance.removeTickedObject(this);
		}
	}
	
	/**
	 * @private
	 */
	public function get registerForTicks():Boolean
	{
		return _registerForUpdates;
	}
	
	override protected function onAdd():void
	{
		super.onAdd();
		// This causes the component to be registerd if it isn't already.
		registerForTicks = registerForTicks;
	}
	
	override protected function onRemove():void
	{
		super.onRemove();
		// Make sure we are unregistered.
		registerForTicks = false;
	}
}
}