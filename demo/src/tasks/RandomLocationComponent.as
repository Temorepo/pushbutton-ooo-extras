package tasks {
import com.pblabs.engine.entity.EntityComponent;
import com.pblabs.engine.entity.PropertyReference;
import com.threerings.flashbang.util.Rand;

import flash.geom.Rectangle;

public class RandomLocationComponent extends EntityComponent
{
    public var xRef :PropertyReference;
    public var yRef :PropertyReference;

    public static const BOUNDS :Rectangle = new Rectangle(50, 60, 300, 200);

    override protected function onReset() : void
    {
        var x :Number = Rand.nextIntInRange(BOUNDS.left, BOUNDS.right);
        var y :Number = Rand.nextIntInRange(BOUNDS.top, BOUNDS.bottom);
        owner.setProperty(xRef, x);
        owner.setProperty(yRef, y);
    }
}
}