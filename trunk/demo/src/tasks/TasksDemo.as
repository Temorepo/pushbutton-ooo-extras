package tasks {
import com.pblabs.engine.PBE;
import com.pblabs.rendering2D.SimpleSpatialComponent;
import com.threerings.flashbang.debug.FlashbangAppRunner;
import com.threerings.pbe.tasks.ColorMatrixBlendTask;
import com.threerings.pbe.tasks.CuePointTask;

import flash.display.Sprite;

import net.amago.pbe.debug.PBEAppmode;
import net.amago.pbe.debug.SpriteBlobComponent;


[SWF(width="500", height="300", frameRate="30")]
public class TasksDemo extends Sprite
{

    public function TasksDemo ()
    {
//        SimpleSpatialComponent
//        SpriteBlobComponent
//        PBEAppmode
//        ShowEasingComponent
//        ColorMatrixBlendTask
//        DeathAnimationComponent
//        RandomLocationComponent
//        CuePointTask
//
        if (PBE.mainClass == null) {
            PBE.startup(this);
        }
        var appRunner :FlashbangAppRunner = new FlashbangAppRunner();
        addChild(appRunner);

        var data :Array = [ DEMO01, DEMO02 ];

        for (var ii :int = 0; ii < data.length; ++ii) {
            var clazz :Class = data[ii] as Class;
            appRunner.queueAppMode(new PBEAppmode({templates :TEMPLATES, level :clazz}));
        }
    }

    [Embed(source="../rsrc/templates.xml", mimeType='application/octet-stream')]
    protected static const TEMPLATES :Class;

    [Embed(source="../rsrc/demo01.pbelevel", mimeType='application/octet-stream')]
    protected static const DEMO01 :Class;

    [Embed(source="../rsrc/demo02.pbelevel", mimeType='application/octet-stream')]
    protected static const DEMO02 :Class;
}
}