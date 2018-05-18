'use strict';

goog.provide('Blockly.quanta.instruction');

goog.require('Blockly.quanta');

Blockly.quanta['instruction_noop'] = function(block) {
  return 'NOOP\n'
}

Blockly.quanta['instruction_immediate'] = function(block) {
  var instruction = block.getFieldValue('INSTRUCTION');
  var register = Blockly.quanta.valueToCode(block, 'REGISTER_A', Blockly.quanta.ORDER_ATOMIC);
  var immediate = Blockly.quanta.valueToCode(block, 'IMMEDIATE', Blockly.quanta.ORDER_ATOMIC);

  return instruction + ' ' + register + ', ' + immediate + '\n';
};

Blockly.quanta['instruction_single_register'] = function (block) {
  var instruction = block.getFieldValue('INSTRUCTION');
  var register = Blockly.quanta.valueToCode(block, 'REGISTER_A', Blockly.quanta.ORDER_ATOMIC);

  return instruction + ' ' + register + '\n';
};

Blockly.quanta['instruction_double_register'] = function (block) {
  var instruction = block.getFieldValue('INSTRUCTION');
  var registerA = Blockly.quanta.valueToCode(block, 'REGISTER_A', Blockly.quanta.ORDER_ATOMIC);
  var registerB = Blockly.quanta.valueToCode(block, 'REGISTER_B', Blockly.quanta.ORDER_ATOMIC);

  return instruction + ' ' + registerA + ', ' + registerB + '\n';
};

Blockly.quanta['instruction_triple_register'] = function (block) {
  var instruction = block.getFieldValue('INSTRUCTION');
  var registerA = Blockly.quanta.valueToCode(block, 'REGISTER_A', Blockly.quanta.ORDER_ATOMIC);
  var registerB = Blockly.quanta.valueToCode(block, 'REGISTER_B', Blockly.quanta.ORDER_ATOMIC);
  var registerC = Blockly.quanta.valueToCode(block, 'REGISTER_C', Blockly.quanta.ORDER_ATOMIC);

  return instruction + ' ' + registerA + ', ' + registerB + ', ' + registerC + '\n';
};
