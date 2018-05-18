var onBlockCreate = function(event)
{
    var workspace = Blockly.Workspace.getById(event.workspaceId);
    var block = workspace.getBlockById(event.blockId);

    if(block.type == 'label_group')
    {
        Blockly.quanta.handleNewLabel(block);
    }
}

var onBlockDelete = function(event)
{
    var workspace = Blockly.Workspace.getById(event.workspaceId);
    var block = workspace.getBlockById(event.blockId);

    /*
     * Check if any of the deleted blocks was of type label
     */
}

var onBlockChange = function (event)
{

}

var listener = function(event)
{
    if (event.type == Blockly.Events.BLOCK_CREATE)
    {
        onBlockCreate(event);
    }
    else if (event.type == Blockly.Events.BLOCK_DELETE)
    {
        onBlockDelete(event);
    }
    else if (event.type == Blockly.Events.BLOCK_CHANGE)
    {
        onBlockChange(event);
    }
}