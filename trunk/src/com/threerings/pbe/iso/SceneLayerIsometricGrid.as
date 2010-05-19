package com.threerings.pbe.iso
{
import com.threerings.util.Preconditions;

import com.threerings.flashbang.pushbutton.scene.SceneEntityComponent;

import com.threerings.downtown.scene.tiles.TileComponent;
import com.threerings.downtown.scene.tiles.TileGrid;
import com.threerings.downtown.scene.tiles.TileGridComponent;

public class SceneLayerIsometricGrid extends SceneLayerIsometric
{
    public function SceneLayerIsometricGrid(width :int, length :int, tileSize :Number)
    {
        _tileGrid = new TileGridComponent(width, length, tileSize);
    }

    public function get gridComp () :TileGridComponent
    {
        return _tileGrid;
    }

    override protected function objectAdded (obj :SceneEntityComponent) :void
    {
        Preconditions.checkNotNull(TileComponent.getFrom(obj.owner));
        super.objectAdded(obj);
        _tileGrid.addTileComponent(TileComponent.getFrom(obj.owner));
    }

    override protected function objectRemoved (obj :SceneEntityComponent) :void
    {
        super.objectRemoved(obj);
        _tileGrid.removeTileComponent(TileComponent.getFrom(obj.owner));
    }

    protected var _tileGrid :TileGridComponent;
}
}