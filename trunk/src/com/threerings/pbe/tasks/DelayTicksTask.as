package com.threerings.pbe.tasks
{
import com.pblabs.engine.entity.IEntity;

public class DelayTicksTask
    implements IEntityTask
{
    public function DelayTicksTask (ticks :int = 1)
    {
        _ticks = ticks;
    }

    public function update (dt :Number, obj :IEntity) :Boolean
    {
        _elapsedTicks++;

        return (_elapsedTicks >= _ticks);
    }

    public function clone () :IEntityTask
    {
        return new DelayTicksTask(_ticks);
    }

    protected var _ticks :int = 1;
    protected var _elapsedTicks :int = 0;
}
}