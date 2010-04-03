package
{
import com.pblabs.engine.PBE;
import com.threerings.pbe.iso.tests.BasicTest;

import flash.display.Sprite;

import tasks.TasksDemo;

public class Main extends Sprite
{
    public function Main()
    {
        PBE.startup(this);
//        addChild(new BasicTest());
        addChild(new TasksDemo());
    }
}
}