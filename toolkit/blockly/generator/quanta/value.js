'use strict';

goog.provide('Blockly.quanta.comment');

goog.require('Blockly.quanta');


Blockly.quanta['comment'] = function (block) {
    var comment = block.getFieldValue('COMMENT');
    return '; ' + comment + '\n';
};
