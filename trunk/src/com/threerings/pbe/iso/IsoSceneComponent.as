package com.threerings.pbe.iso {
import com.pblabs.engine.core.ITickedObject;
import com.pblabs.engine.entity.EntityComponent;
import com.pblabs.engine.entity.PropertyReference;
import flash.display.DisplayObjectContainer;
import com.threerings.util.ClassUtil;
import com.threerings.util.Log;
import as3isolib.core.IIsoDisplayObject;
import as3isolib.data.INode;
import as3isolib.display.IsoSprite;
import as3isolib.display.renderers.DefaultSceneLayoutRenderer;
import as3isolib.display.scene.IsoScene;
public class IsoSceneComponent extends EntityComponent implements ITickedObject
{
    public static const COMPONENT_NAME :String = ClassUtil.tinyClassName(IsoSceneComponent);

    public var displayObjectContainerProperty :PropertyReference;

    public function IsoSceneComponent ()
    {
        super();
        _isoScene = new IsoScene();

        //If we need to adjust for collisions in the isoscene, here's how we do it.
        //var renderer :DefaultSceneLayoutRenderer = new DefaultSceneLayoutRenderer();
        //renderer.collisionDetection = collisionFunction;
        //_isoScene.layoutRenderer = renderer;
    }

    public function get isoScene () :IsoScene
    {
        return _isoScene;
    }

    public function addIsoComponent (comp :IsoSpriteComponent) :void
    {
        _isoScene.addChild(comp.isoSprite);
        _isoScene.render();
    }

    public function onTick (deltaTime :Number) :void
    {
        _isoScene.render();
    }

    public function removeIsoComponent (comp :IsoSpriteComponent) :void
    {
        _isoScene.removeChild(comp.isoSprite);
    }

    override protected function onRemove () :void
    {
        super.onRemove();
        _isoScene.removeAllChildren();
    }

    override protected function onReset () :void
    {
        super.onReset();

        if (displayContainer != null) {
            _isoScene.hostContainer = displayContainer;
        }
    }

    protected function collisionFunction (objA :Object, objB :Object) :int
    {
        var isoSpriteA :IIsoDisplayObject = objA as IIsoDisplayObject;
        var isoSpriteB :IIsoDisplayObject = objB as IIsoDisplayObject;

        //If they collide, the highest object goes on top
        if (isoSpriteA != null && isoSpriteB != null) {
            return isoSpriteA.z + isoSpriteA.height > isoSpriteB.z + isoSpriteB.height ? -1 : 1;
        }
        log.error("collisionFunction", "objA", objA, "objB", objB);
        return 0;
    }

    protected function get displayContainer () :DisplayObjectContainer
    {
        return owner.getProperty(displayObjectContainerProperty) as DisplayObjectContainer;
    }

    protected var _isoScene :IsoScene;

    protected static const log :Log = Log.getLog(IsoSceneComponent);
}
}