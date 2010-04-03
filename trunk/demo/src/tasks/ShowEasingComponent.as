package tasks {
import com.threerings.pbe.tasks.IEntityTask;
import com.threerings.pbe.tasks.LocationTask;
import com.threerings.pbe.tasks.RepeatingTask;
import com.threerings.pbe.tasks.SerialTask;

public class ShowEasingComponent extends BaseTaskScriptComponent
{
    override protected function createTask () :IEntityTask
    {
        var currentX :Number = owner.getProperty(xRef) as Number;
        var currentY :Number = owner.getProperty(yRef) as Number;
        var time :Number = 3;
        var distance :Number = 200;
        var serialTask :SerialTask = new SerialTask(
            createChangeLabelTask("EaseIn"),
            LocationTask.CreateEaseIn(xRef, yRef, currentX + distance, currentY, time),
            LocationTask.CreateEaseIn(xRef, yRef, currentX, currentY, time),

            createChangeLabelTask("EaseOut"),
            LocationTask.CreateEaseOut(xRef, yRef, currentX + distance, currentY, time),
            LocationTask.CreateEaseOut(xRef, yRef, currentX, currentY, time),

            createChangeLabelTask("Linear"),
            LocationTask.CreateLinear(xRef, yRef, currentX + distance, currentY, time),
            LocationTask.CreateLinear(xRef, yRef, currentX, currentY, time),

            createChangeLabelTask("Smooth"),
            LocationTask.CreateSmooth(xRef, yRef, currentX + distance, currentY, time),
            LocationTask.CreateSmooth(xRef, yRef, currentX, currentY, time)
            );

        return new RepeatingTask(serialTask);
    }
}
}