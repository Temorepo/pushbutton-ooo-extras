package com.threerings.pbe.tasks
{
import com.threerings.util.Preconditions;

import com.threerings.flashbang.util.Rand;

public class TimedTaskRandom extends TimedTask
{
    public function TimedTaskRandom(min :Number, max :Number)
    {
        Preconditions.checkArgument(min < max, "min must be smaller than max");
        super(Rand.nextNumberInRange(min, max));
    }
}
}