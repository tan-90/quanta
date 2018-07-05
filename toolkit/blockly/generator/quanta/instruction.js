'use strict';

goog.provide('Blockly.quanta.instruction');

goog.require('Blockly.quanta');
goog.require('Blockly.quanta.aliases.registers');

Blockly.quanta['instruction_aliases'] = {
  "LOAD_IMMEDIATE": 'li',

  "NOT": 'not',
  "SL": 'sl',
  "SR": 'sr',
  "RL": 'rl',
  "RR": 'rr',
  "JUMP": 'j',

  "MOV": 'mov',
  "LOAD": 'load',
  "STORE": 'store',
  "ADD": 'add',
  "SUBTRACT": 'sub',
  "AND": 'and',
  "OR": 'or',
  "XOR": 'xor',
  "XNOR": 'xnor',
  "CALL": 'call',

  "JE": 'je',
  "JNE": 'jne',
  "JL": 'jl',
  "JG": 'jg',
};

Blockly.quanta['instruction_noop'] = function(block) {
  return Blockly.quanta['instruction_aliases']['NOOP'];
}

Blockly.quanta['instruction_immediate'] = function(block) {
  var instruction = block.getFieldValue('INSTRUCTION');
  var register = Blockly.quanta.valueToCode(block, 'REGISTER_A', Blockly.quanta.ORDER_ATOMIC);
  var immediate = Blockly.quanta.valueToCode(block, 'IMMEDIATE', Blockly.quanta.ORDER_ATOMIC);

  return Blockly.quanta['instruction_aliases'][instruction] + ' ' + register + ', ' + immediate + '\n';
};

Blockly.quanta['instruction_single_register'] = function (block) {
  var instruction = block.getFieldValue('INSTRUCTION');
  var register = Blockly.quanta.valueToCode(block, 'REGISTER_A', Blockly.quanta.ORDER_ATOMIC);

  return Blockly.quanta['instruction_aliases'][instruction] + ' ' + register + '\n';
};

Blockly.quanta['instruction_double_register'] = function (block) {
  var instruction = block.getFieldValue('INSTRUCTION');
  var registerA = Blockly.quanta.valueToCode(block, 'REGISTER_A', Blockly.quanta.ORDER_ATOMIC);
  var registerB = Blockly.quanta.valueToCode(block, 'REGISTER_B', Blockly.quanta.ORDER_ATOMIC);

  return Blockly.quanta['instruction_aliases'][instruction] + ' ' + registerA + ', ' + registerB + '\n';
};

Blockly.quanta['instruction_triple_register'] = function (block) {
  var instruction = block.getFieldValue('INSTRUCTION');
  var registerA = Blockly.quanta.valueToCode(block, 'REGISTER_A', Blockly.quanta.ORDER_ATOMIC);
  var registerB = Blockly.quanta.valueToCode(block, 'REGISTER_B', Blockly.quanta.ORDER_ATOMIC);
  var registerC = Blockly.quanta.valueToCode(block, 'REGISTER_C', Blockly.quanta.ORDER_ATOMIC);

  return Blockly.quanta['instruction_aliases'][instruction] + ' ' + registerA + ', ' + registerB + ', ' + registerC + '\n';
};
