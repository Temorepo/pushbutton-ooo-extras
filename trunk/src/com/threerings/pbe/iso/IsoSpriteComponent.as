package com.threerings.pbe.iso {
import as3isolib.display.IsoSprite;
import as3isolib.display.primitive.IsoBox;
import as3isolib.display.scene.IsoScene;
import as3isolib.geom.Pt;
import as3isolib.graphics.SolidColorFill;
import as3isolib.graphics.Stroke;

import com.pblabs.engine.entity.EntityComponent;
import com.pblabs.engine.entity.IEntity;
import com.pblabs.engine.entity.PropertyReference;
import com.threerings.flashbang.pushbutton.scene.SceneEntityComponent;
import com.threerings.flashbang.util.Rand;
import com.threerings.util.ClassUtil;
import com.threerings.util.Log;
import com.threerings.util.StringUtil;

import flash.display.DisplayObject;
import flash.display.Sprite;
import flash.geom.Point;

public class IsoSpriteComponent extends SceneEntityComponent
{
    public static const COMPONENT_NAME :String = ClassUtil.tinyClassName(IsoSpriteComponent);

    public var isometricVolumeProperty :PropertyReference;

    public var zProperty :PropertyReference;

    public var offset :Point;

    public static function getFrom (entity :IEntity) :IsoSpriteComponent
    {
        return entity.lookupComponentByType(IsoSpriteComponent) as IsoSpriteComponent;
    }

    public function IsoSpriteComponent (d :DisplayObject = null)
    {
        super(d);
        _isoSprite = new IsoSprite();
    }

    public function get debug () :Boolean
    {
        return _debug;
    }

    public function set debug (val :Boolean) :void
    {
        //TODO: readd the debug view?
        //        if (_debug != val) {
        //            _debug = val;
        //            if (_isoSceneComponent != null) {
        //                var container :IsoSceneComponent = _isoSceneComponent;
        //                removeFromIsoScene();
        //                addToIsoScene(container);
        //            }
        //        }
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
    }

    override public function set x (val :Number) :void
    {
        super.x = val;
        _isoSprite.x = val;
    }

    override public function set y (val :Number) :void
    {
        super.y = val;
        _isoSprite.y = val;
    }

    public function get z () :Number
    {
        return _isoSprite.z;
    }

    public function set z (val :Number) :void
    {
        _isoSprite.z = val;
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

    public function forceImmediateRender () :void
    {
        if (_isoSceneComponent == null) {
            return;
        }

        _isoSceneComponent._isoScene.render();
    }

    override public function updateTransform (updateProps :Boolean = false) :void
    {
        if (_isoSceneComponent != null) {
            updateProperties();
            forceImmediateRender();
        } else {
            super.updateTransform(updateProps);
        }
    }

    override protected function updateProperties () :void
    {
        if (owner == null) {
            return;
        }

        super.updateProperties();

        if (_isoSceneComponent == null) {
            return;
        }

        var vol :Pt = isometricVolume;
        if (vol != null) {
            _isoSprite.setSize(vol.x, vol.y, vol.z);
        }

        if (zProperty != null) {
            z = owner.getProperty(zProperty) as Number;
        }
        _isoSprite.invalidatePosition();
    }

    override protected function onRemove () :void
    {
        super.onRemove();
        _debug = false;
        _isometricVolume = null;
        _isoSceneComponent = null;
        offset = null;
        zProperty = null;
        isometricVolumeProperty = null;
    }

    protected var _debug :Boolean;
    protected var _isometricVolume :Pt;
    protected var _isoSprite :IsoSprite;
    internal var _isoSceneComponent :SceneLayerIsometric;

    protected static const log :Log = Log.getLog(IsoSpriteComponent);
}
}