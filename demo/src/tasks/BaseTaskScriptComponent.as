package tasks {
import com.pblabs.engine.entity.EntityComponent;
import com.pblabs.engine.entity.PropertyReference;
import com.threerings.pbe.tasks.FunctionTask;
import com.threerings.pbe.tasks.IEntityTask;
import com.threerings.pbe.tasks.TaskComponent;
import com.threerings.pbe.tasks.TickedTaskComponent;


/**
 * Ensures that the entity has a TickedTaskComponent
 * @author dion
 */
public class BaseTaskScriptComponent extends EntityComponent
{

    public var xRef :PropertyReference;
    public var yRef :PropertyReference;
    public var rotationRef :PropertyReference;
    public var alphaRef :PropertyReference;
    public var labelRef :PropertyReference;
    public var displayObjectRef :PropertyReference;

    override protected function onReset() : void
    {
        super.onReset();
        //If our owner doesn't have a askComponent, add one.
        if (owner.lookupComponentByType(TickedTaskComponent) == null) {
            owner.deferring = true;
            owner.addComponent(new TickedTaskComponent(), TaskComponent.COMPONENT_NAME);
            owner.deferring = false;
        }

        //If we haven't created our task and added it to the TaskComponent yet, do so.
        if (_mainTask == null) {
            _mainTask = createTask();
            var tasker :TaskComponent = owner.lookupComponentByType(TaskComponent) as TaskComponent;
            tasker.addTask(_mainTask);
        }
    }

    protected function createTask () :IEntityTask
    {
        throw new Error("Override me");
    }

    /**
     * Change some label on the entity.
     */
    protected function createChangeLabelTask (label :String) :IEntityTask
    {
        return new FunctionTask(function () :void {
            owner.setProperty(labelRef, label);
        });
    }

    protected var _mainTask :IEntityTask;
}
}