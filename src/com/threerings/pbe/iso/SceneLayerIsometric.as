package com.threerings.pbe.iso {
import flash.display.Sprite;

import as3isolib.core.IIsoDisplayObject;
import as3isolib.display.scene.IsoScene;

import com.threerings.util.Preconditions;

import com.threerings.flashbang.pushbutton.scene.SceneEntityComponent;
import com.threerings.flashbang.pushbutton.scene.SceneLayer;

public class SceneLayerIsometric extends SceneLayer
{
    public function SceneLayerIsometric ()
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

    /**
     * Order the child components according to their y values.
     */
    override public function render (... ignored) :void
    {
        _isoScene.render();
    }

    override protected function attached () :void
    {
        _isoScene.hostContainer = this;
    }

    override protected function detached () :void
    {
        _isoScene.hostContainer = null;
    }

    override protected function objectRemoved (obj :SceneEntityComponent) :void
    {
        var iso :IsoSpriteComponent = obj as IsoSpriteComponent;
        Preconditions.checkNotNull(iso);
        _isoScene.removeChild(iso.isoSprite);
        iso._isoSceneComponent = null;
    }

    //Subclasses override
    override protected function objectAdded (obj :SceneEntityComponent) :void
    {
        var iso :IsoSpriteComponent = obj as IsoSpriteComponent;
        Preconditions.checkNotNull(iso);

        if (iso.offset != null) {
            iso.displayObject.x = iso.offset.x;
            iso.displayObject.y = iso.offset.y;
        } else {
            iso.displayObject.x = 0;
            iso.displayObject.y = 0;
        }

        iso.isoSprite.sprites = [ iso.displayObject ];

        _isoScene.addChild(iso.isoSprite);
        iso._isoSceneComponent = this;
        _isoScene.render();
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

    internal var _isoScene :IsoScene;
}
}