'use strict';

goog.provide('Blockly.quanta.math');

goog.require('Blockly.quanta');


Blockly.quanta['math_number'] = function(block) {
  var code = block.getFieldValue('NUM');
  return [code, Blockly.quanta.ORDER_ATOMIC];
};
