package com.threerings.pbe.iso {
import flash.display.DisplayObjectContainer;

import as3isolib.core.IIsoDisplayObject;
import as3isolib.display.IsoSprite;
import as3isolib.display.renderers.DefaultSceneLayoutRenderer;
import as3isolib.display.scene.IsoScene;

import com.pblabs.engine.core.ITickedObject;
import com.pblabs.engine.entity.EntityComponent;
import com.pblabs.engine.entity.IEntity;
import com.pblabs.engine.entity.PropertyReference;

import com.threerings.util.ClassUtil;

public class IsoSceneComponent extends EntityComponent implements ITickedObject
{

    public static const COMPONENT_NAME :String = ClassUtil.tinyClassName(IsoSceneComponent);

    public var displayObjectContainerProperty :PropertyReference;

    public static function getFrom (e :IEntity) :IsoSceneComponent
    {
        return e.lookupComponentByName(COMPONENT_NAME) as IsoSceneComponent;
    }

    public function IsoSceneComponent ()
    {
        super();
        _isoScene = new IsoScene();

        //If we need to adjust for collisions in the isoscene, here's how we do it.
        //var renderer :DefaultSceneLayoutRenderer = new DefaultSceneLayoutRenderer();
        //renderer.collisionDetection = collisionFunction;
        //_isoScene.layoutRenderer = renderer;
    }

    public function get displayContainer () :DisplayObjectContainer
    {
        if (displayObjectContainerProperty != null) {
            return owner.getProperty(displayObjectContainerProperty) as DisplayObjectContainer;
        }
        return _localDisplayContainer;
    }

    public function set displayContainer (val :DisplayObjectContainer) :void
    {
        _localDisplayContainer = val;
        if (_localDisplayContainer != null) {
            _isoScene.hostContainer = _localDisplayContainer;
        }
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
        _isoScene.hostContainer = null;
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
        //log.error("collisionFunction", "objA", objA, "objB", objB);
        return 0;
    }

    protected var _isoScene :IsoScene;
    protected var _localDisplayContainer :DisplayObjectContainer;
}
}