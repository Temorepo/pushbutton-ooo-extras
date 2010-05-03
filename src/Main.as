package
{
import flash.display.Sprite;

import as3isolib.display.scene.IsoGrid;
import as3isolib.geom.Pt;

import com.pblabs.engine.PBE;
import com.pblabs.engine.entity.IEntity;
import com.pblabs.engine.entity.PropertyReference;
import com.pblabs.engine.entity.allocateEntity;
import com.pblabs.rendering2D.DisplayObjectRenderer;

import tasks.TasksDemo;

import com.threerings.pbe.iso.IsoSceneComponent;
import com.threerings.pbe.iso.IsoSpriteComponent;
import com.threerings.pbe.iso.tests.BasicTest;
import com.threerings.pbe.tasks.AnimateValueTask;
import com.threerings.pbe.tasks.FunctionTask;
import com.threerings.pbe.tasks.IEntityTask;
import com.threerings.pbe.tasks.RepeatingTask;
import com.threerings.pbe.tasks.TickedTaskComponent;

public class Main extends Sprite
{
    public function Main()
    {
        AnimateValueTask
        PBE.startup(this);
//        addChild(new BasicTest());
//        //addChild(new TasksDemo());
//
//
//        //An entity for the isometric scene component
//        var e1 :IEntity = allocateEntity();
//        var isoscene :IsoSceneComponent = new IsoSceneComponent();
//        //For debugging purposes add a visible grid
//        var isogrid :IsoGrid = new IsoGrid();
//        isoscene.isoScene.addChild(isogrid);
//        e1.addComponent(isoscene, IsoSceneComponent.COMPONENT_NAME);
//        PBE.processManager.addTickedObject(isoscene);
//        isoscene.displayContainer = this;
//        e1.initialize("isoScene");
//
//        //An entity for the an isometric object
//        var e2 :IEntity = allocateEntity();
//        //This component just stores the x,y coords
//        var renderer :DisplayObjectRenderer = new DisplayObjectRenderer();
//        var isolayer :Sprite = new Sprite();
//        renderer.displayObject = isolayer;
//        renderer.x = 200;
//        e2.addComponent(renderer, "renderer");
//
//        var isoSprite :IsoSpriteComponent = new IsoSpriteComponent();
//        isoSprite.isometricVolume = new Pt(30, 30, 60);
//        isoSprite.debug = true;
//        isoSprite.autoAddToScene = true;
//        isoSprite.isoSceneProperty = new PropertyReference("#isoScene." + IsoSceneComponent.COMPONENT_NAME);
//        e2.addComponent(isoSprite, IsoSpriteComponent.COMPONENT_NAME);
//        isoSprite.spriteLayerProperty = new PropertyReference("@renderer.displayObject");
//        isoSprite.xProperty = new PropertyReference("@renderer.x");
//        isoSprite.yProperty = new PropertyReference("@renderer.y");
//        e2.initialize("isoSprite");
//
//        //Add a simple task for moving the iso component
//        var task :TickedTaskComponent = new TickedTaskComponent();
//        e2.addComponent(task, "tasks");
//        //Animate the y value
//        var moveY :IEntityTask = new AnimateValueTask(new PropertyReference("@renderer.y"), 400, 3);
//        task.addTask(moveY);
//        //Force the isosprite to update
//        var forceUpdate :IEntityTask = new RepeatingTask(new FunctionTask(isoSprite.update));
//        task.addTask(forceUpdate);
    }
}
}