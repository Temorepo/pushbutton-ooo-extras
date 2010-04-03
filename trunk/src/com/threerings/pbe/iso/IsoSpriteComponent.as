package com.threerings.pbe.iso {
import as3isolib.core.IsoContainer;
import as3isolib.display.IsoSprite;
import as3isolib.display.primitive.IsoBox;
import as3isolib.display.scene.IsoScene;
import as3isolib.geom.Pt;
import as3isolib.graphics.SolidColorFill;
import as3isolib.graphics.Stroke;

import com.pblabs.engine.entity.IEntity;
import com.pblabs.engine.entity.PropertyReference;
import com.threerings.downtown.data.ItemType;
import com.threerings.downtown.scene.components.ItemComponent;
import com.threerings.flashbang.util.Rand;
import com.threerings.util.ClassUtil;
import com.threerings.util.DebugUtil;
import com.threerings.util.Log;
import com.threerings.util.StringUtil;

import flash.display.Sprite;

import net.amago.pbe.base.EntityComponentListener;

public class IsoSpriteComponent extends EntityComponentListener
{
    public static const COMPONENT_NAME :String = ClassUtil.tinyClassName(IsoSpriteComponent);

    public var autoAddToScene :Boolean = false;

    public var dirtyEvents :Array;

    public var isometricVolumeProperty :PropertyReference;
    public var isoSceneProperty :PropertyReference;
    public var spriteLayerProperty :PropertyReference;

    public var xProperty :PropertyReference;
    public var yProperty :PropertyReference;
    public var zProperty :PropertyReference;

    public static function getFrom (entity :IEntity) :IsoSpriteComponent
    {
        return entity.lookupComponentByName(IsoSpriteComponent.COMPONENT_NAME) as IsoSpriteComponent;
    }

    public function get debug () :Boolean
    {
        return _debug;
    }

    public function set debug (val :Boolean) :void
    {
        if (_debug != val) {
            _debug = val;
            if (_isoSceneComponent != null) {
                var container :IsoSceneComponent = _isoSceneComponent;
                removeFromIsoScene();
                addToIsoScene(container);
            }
        }
    }

    public function get isIsoScene () :Boolean
    {
        return _isoSceneComponent != null;
    }

    public function get isoSprite () :IsoSprite
    {
        return _isoSprite;
    }

    public function get isometricVolume () :Pt
    {
        if (isometricVolumeProperty != null) {
            return owner.getProperty(isometricVolumeProperty) as Pt;
        }
        return _isometricVolume;
    }

    public function set isometricVolume (vol :Pt) :void
    {
        if (isometricVolumeProperty != null) {
            owner.setProperty(isometricVolumeProperty, vol.clone());
        } else {
            _isometricVolume = vol.clone() as Pt;
        }
        _isoSprite.setSize(vol.x, vol.y, vol.z);
        _debugIsoBox.setSize(vol.x, vol.y, vol.z);
    }

    public function get x () :Number
    {
        return _isoSprite.x;
    }

    public function set x (val :Number) :void
    {
        _isoSprite.x = val;
        _debugIsoBox.x = val;
    }

    public function get y () :Number
    {
        return _isoSprite.y;
    }

    public function set y (val :Number) :void
    {
        _isoSprite.y = val;
        _debugIsoBox.y = val;
    }

    public function get z () :Number
    {
        return _isoSprite.z;
    }

    public function set z (val :Number) :void
    {
        _isoSprite.z = val;
        _debugIsoBox.z = val;
    }

    public function addToIsoScene (scene :IsoSceneComponent) :void
    {
        if (scene == null) {
            log.error("addToIsoScene", "scene", scene);
            throw new Error("addToIsoScene" + ", scene=" + scene);
            return;
        }

        removeFromIsoScene();

        var adjustedLayer :Sprite = new Sprite();
        var sceneComp :Sprite = owner.getProperty(spriteLayerProperty) as Sprite;
        if (sceneComp == null) {
            log.error("onReset", "sceneComp", sceneComp, "spriteLayerProperty", spriteLayerProperty);
            return;
        }

        adjustedLayer.addChild(sceneComp);
        _isoSprite.sprites = [ adjustedLayer ];

        update();

        //Add to the isometric scene
        _isoSceneComponent = scene;

        if (_isoSceneComponent != null) {

            _isoSceneComponent.addIsoComponent(this);
            if (debug) {
                var vol :Pt = isometricVolume;
                _debugIsoBox.setSize(vol.x, vol.y, vol.z);
                _debugIsoBox.x = 0;
                _debugIsoBox.y = 0;
                _debugIsoBox.fill = new SolidColorFill(Rand.nextNumber() * 0xffffff, 1); //0.0);
                _debugIsoBox.stroke = new Stroke(1, 0, 1);
                _isoSceneComponent.isoScene.addChild(_debugIsoBox);
            }
        }
        update();
    }

    public function addToIsoSceneComponent () :void
    {
        var scene :IsoSceneComponent = owner.getProperty(isoSceneProperty) as IsoSceneComponent;
        if (scene != null) {
            addToIsoScene(scene);
        } else {
            log.warning("addToIsoSceneComponent", "scene", scene);
            throw new Error();
        }
    }

    public function removeFromIsoScene () :void
    {
        if (_isoSceneComponent != null) {
            _isoSceneComponent.removeIsoComponent(this);
            if (debug) {
                _isoSceneComponent.isoScene.removeChild(_debugIsoBox);
            }
            _isoSceneComponent = null;
        }
    }

    public function setLoc (pt :Pt) :void
    {
        x = pt.x;
        y = pt.y;
        z = pt.z;
    }

    public function toString () :String
    {
        return StringUtil.simpleToString(this, [ "isIsoScene", "x", "y", "z", "isometricVolume" ]);
    }

    override protected function onAdd () :void
    {
        super.onAdd();

        for each (var eventType :String in dirtyEvents) {
            registerListener(owner.eventDispatcher, eventType, update);
        }
    }

    override protected function onRemove () :void
    {
        super.onRemove();
        removeFromIsoScene();
    }

    override protected function onReset () :void
    {
        if (autoAddToScene && _isoSceneComponent == null) {
            addToIsoSceneComponent();
        }
    }

    protected function update (... _) :void
    {
        if (owner == null) {
            return;
        }

        var vol :Pt = isometricVolume;
        if (vol != null) {
            _isoSprite.setSize(vol.x, vol.y, vol.z);
            _debugIsoBox.setSize(vol.x, vol.y, vol.z);
        }

        if (xProperty != null) {
            x = owner.getProperty(xProperty) as Number;
        }

        if (yProperty != null) {
            y = owner.getProperty(yProperty) as Number;
        }

        if (zProperty != null) {
            z = owner.getProperty(zProperty) as Number;
        }
        _isoSprite.invalidatePosition();
    }

    protected function get spriteLayer () :Sprite
    {
        return owner.getProperty(spriteLayerProperty) as Sprite;
    }

    protected var _debug :Boolean;

    protected var _debugIsoBox :IsoBox = new IsoBox();
    protected var _isometricVolume :Pt;
    protected var _isoSceneComponent :IsoSceneComponent;
    protected var _isoSprite :IsoSprite = new IsoSprite();

    protected static const log :Log = Log.getLog(IsoSpriteComponent);
}
}