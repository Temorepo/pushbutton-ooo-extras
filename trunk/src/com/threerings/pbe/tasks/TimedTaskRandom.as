package com.threerings.pbe.tasks
{
import com.threerings.flashbang.util.Rand;
import com.threerings.util.Preconditions;

public class TimedTaskRandom extends TimedTask
{
    public function TimedTaskRandom(min :Number, max :Number)
    {
        Preconditions.checkArgument(min < max, "min must be smaller than max");
        super(Rand.nextNumberInRange(min, max));
    }
}
}