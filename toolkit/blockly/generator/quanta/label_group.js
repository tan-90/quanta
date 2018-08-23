'use strict';

goog.provide('Blockly.quanta.label_group');

goog.require('Blockly.quanta');

Blockly.quanta['label_group'] = function (block) {
    var label = block.getFieldValue('LABEL');
    var statements = Blockly.quanta.statementToCode(block, 'STATEMENTS').split('\n');

    var code = label + ':\n';

    for(var i = 0; i < statements.length; i++)
    {
        code += '    ' + statements[i] + '\n';
    }
    return code;
};