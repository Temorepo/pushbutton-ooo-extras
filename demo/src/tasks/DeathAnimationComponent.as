package tasks {
import aduros.util.F;

import com.pblabs.engine.PBE;
import com.pblabs.engine.core.TemplateManager;
import com.pblabs.engine.entity.IEntity;
import com.threerings.display.ColorMatrix;
import com.threerings.pbe.tasks.AnimateValueTask;
import com.threerings.pbe.tasks.ColorMatrixBlendTask;
import com.threerings.pbe.tasks.FunctionTask;
import com.threerings.pbe.tasks.IEntityTask;
import com.threerings.pbe.tasks.SelfDestructTask;
import com.threerings.pbe.tasks.SerialTask;
import com.threerings.pbe.tasks.WaitOnPredicateTask;
import com.threerings.util.DelayUtil;

import flash.display.DisplayObject;
import flash.events.MouseEvent;

import mx.effects.easing.*;

public class DeathAnimationComponent extends BaseTaskScriptComponent
{
    override protected function createTask () :IEntityTask
    {
        createChangeLabelTask("Click me");

        var disp :DisplayObject = owner.getProperty(displayObjectRef) as DisplayObject;

        disp.addEventListener(MouseEvent.CLICK, F.justOnce(function () :void {
            clicked = true;
        }));

        var clicked :Boolean = false;

        function isClicked () :Boolean {
            return clicked;
        }

        var ownerName :String = owner.name;
        function createClone () :void {
            DelayUtil.delayFrames(2, function () :void {
                var ent :IEntity = PBE.templateManager.instantiateEntity(ownerName);
            });
        }

        var alpha :Number = owner.getProperty(alphaRef) as Number;

        var time :Number = 1;
        var distance :Number = 200;


        var deathAnimation :SerialTask = new SerialTask(
            createChangeLabelTask("Click to begin death animation"),
            new WaitOnPredicateTask(isClicked),
            createChangeLabelTask("Dying"),
            new ColorMatrixBlendTask(new ColorMatrix(),
                new ColorMatrix().colorize(Math.random()*0xFFFFFF), time,
                disp, mx.effects.easing.Cubic.easeIn),
            AnimateValueTask.CreateEaseOut(alphaRef, 0, time),
            new FunctionTask(createClone),
            new SelfDestructTask()
            );

        return deathAnimation;
    }

}
}