'use strict';

goog.provide('Blockly.quanta.type');

goog.require('Blockly.quanta');


Blockly.quanta['type_register'] = function(block) {
  var register = block.getFieldValue('NAME');

  return [register, Blockly.quanta.ORDER_ATOMIC];
};

Blockly.quanta['type_label'] = function (block) {
  var label = block.getFieldValue('NAME');

  return ['.' + label, Blockly.quanta.ORDER_ATOMIC];
};