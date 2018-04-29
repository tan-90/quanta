'use strict';

goog.provide('Blockly.quanta.instruction');

goog.require('Blockly.quanta');


Blockly.quanta['instruction_immediate'] = function(block) {
  var instruction = block.getFieldValue('INSTRUCTION');
  var register = Blockly.quanta.valueToCode(block, 'REGISTER_A', Blockly.quanta.ORDER_ATOMIC);
  var immediate = Blockly.quanta.valueToCode(block, 'IMMEDIATE', Blockly.quanta.ORDER_ATOMIC);

  return instruction + ' ' + register + ', ' + immediate + '\n';
};