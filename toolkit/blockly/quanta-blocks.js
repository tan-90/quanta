// TODO programatically generate register names

/**
 * Type blocks
 * 
 * Defining assembler block types
 */

/**
 * Register type
 * 
 * Encapsulates the register names
 * Meant to be used in every register instruction
 * Avoids errors that would be caused by manually typing names
 */
var typeRegisterJson = {
    "type": "type_register",
    "message0": "%1",
    "args0": [
        {
            "type": "field_dropdown",
            "name": "NAME",
            "options": [
                [
                    "$0",
                    "REGISTER_0"
                ],
                [
                    "$1",
                    "REGISTER_1"
                ],
                [
                    "$2",
                    "REGISTER_2"
                ],
                [
                    "$3",
                    "REGISTER_3"
                ],
                [
                    "$4",
                    "REGISTER_4"
                ],
                [
                    "$5",
                    "REGISTER_5"
                ],
                [
                    "$6",
                    "REGISTER_6"
                ],
                [
                    "$7",
                    "REGISTER_7"
                ],
                [
                    "$8",
                    "REGISTER_8"
                ],
                [
                    "$9",
                    "REGISTER_9"
                ],
                [
                    "$10",
                    "REGISTER_10"
                ],
                [
                    "$11",
                    "REGISTER_11"
                ],
                [
                    "$12",
                    "REGISTER_12"
                ],
                [
                    "$13",
                    "REGISTER_13"
                ],
                [
                    "$14",
                    "REGISTER_14"
                ],
                [
                    "$15",
                    "REGISTER_15"
                ],
                [
                    "$16",
                    "REGISTER_16"
                ],
                [
                    "$17",
                    "REGISTER_17"
                ],
                [
                    "$18",
                    "REGISTER_18"
                ],
                [
                    "$19",
                    "REGISTER_19"
                ],
                [
                    "$20",
                    "REGISTER_20"
                ],
                [
                    "$21",
                    "REGISTER_21"
                ],
                [
                    "$22",
                    "REGISTER_22"
                ],
                [
                    "$23",
                    "REGISTER_23"
                ],
                [
                    "$24",
                    "REGISTER_24"
                ],
                [
                    "$25",
                    "REGISTER_25"
                ],
                [
                    "$26",
                    "REGISTER_26"
                ],
                [
                    "$27",
                    "REGISTER_27"
                ],
                [
                    "$28",
                    "REGISTER_28"
                ],
                [
                    "$29",
                    "REGISTER_29"
                ],
                [
                    "$30",
                    "REGISTER_30"
                ],
                [
                    "$31",
                    "REGISTER_31"
                ],
            ]
        }
    ],
    "output": "REGISTER",
    "colour": 195,
    "tooltip": "Register identifier",
    "helpUrl": ""
};

Blockly.Blocks['type_register'] = {
    init: function () {
        this.jsonInit(typeRegisterJson);
    }
};

/**
 * Instruction blocks
 * 
 * Every instruction type has a corresponding block
 * Instruction blocks translate to a single assembly instruction
 * Specific instruction is selected on a dropdown in the block of its type
 */

/**
 * Immediate instruction
 * 
 * Takes a single register and an immediate value
 */
var instructionImmediateJson = {
    "type": "instruction_immediate",
    "message0": "%1 %2 %3 A %4 Immediate %5",
    "args0": [
        {
            "type": "field_dropdown",
            "name": "INSTRUCTION",
            "options": [
                [
                    "li",
                    "LOAD_IMMEDIATE"
                ]
            ]
        },
        {
            "type": "input_dummy"
        },
        {
            "type": "input_dummy"
        },
        {
            "type": "input_value",
            "name": "REGISTER_A",
            "check": "REGISTER",
            "align": "RIGHT"
        },
        {
            "type": "input_value",
            "name": "IMMEDIATE",
            "check": "Number",
            "align": "RIGHT"
        }
    ],
    "inputsInline": true,
    "previousStatement": null,
    "nextStatement": null,
    "colour": 230,
    "tooltip": "Single Register Immediate Instruction",
    "helpUrl": ""
}

Blockly.Blocks['instruction_immediate'] = {
    init: function () {
        this.jsonInit(instructionImmediateJson);
    }
};

/**
 * Double register instruction
 * 
 * Takes two registers
 */

var instructionDoubleRegisterJson = {
    "type": "instruction_double_register",
    "message0": "%1 %2 A %3 B %4",
    "args0": [
        {
            "type": "field_dropdown",
            "name": "INSTRUCTION",
            "options": [
                [
                    "add",
                    "ADD"
                ],
                [
                    "sub",
                    "SUBTRACT"
                ],
                [
                    "and",
                    "AND"
                ],
                [
                    "or",
                    "OR"
                ],
                [
                    "xor",
                    "XOR"
                ],
                [
                    "xnor",
                    "XNOR"
                ]
            ]
        },
        {
            "type": "input_dummy"
        },
        {
            "type": "input_value",
            "name": "DESTINATION",
            "check": "REGISTER"
        },
        {
            "type": "input_value",
            "name": "SOURCE",
            "check": "REGISTER"
        }
    ],
    "inputsInline": true,
    "previousStatement": null,
    "nextStatement": null,
    "colour": 230,
    "tooltip": "Double register immediate instruction",
    "helpUrl": ""
};

Blockly.Blocks['instruction_double_register'] = {
    init: function () {
        this.jsonInit(instructionDoubleRegisterJson);
    }
};

/**
 * Single register instruction
 * 
 * Takes one register
 */
var instructionSingleRegisterJson = {
    "type": "instruction_single_register",
    "message0": "%1 %2 A %3",
    "args0": [
        {
            "type": "field_dropdown",
            "name": "INSTRUCTION",
            "options": [
                [
                    "not",
                    "NOT"
                ],
                [
                    "j",
                    "JUMP"
                ]
            ]
        },
        {
            "type": "input_dummy"
        },
        {
            "type": "input_value",
            "name": "NAME",
            "check": "REGISTER"
        }
    ],
    "inputsInline": true,
    "previousStatement": null,
    "nextStatement": null,
    "colour": 230,
    "tooltip": "Single register instruction",
    "helpUrl": ""
};

Blockly.Blocks['instruction_single_register'] = {
    init: function () {
        this.jsonInit(instructionSingleRegisterJson);
    }
};

/**
 * Label group
 * 
 * Groups statements inside a label identified block
 * Labels should be a valid input to a jump instruction
 */
var labelGroupJson = {
    "type": "label_group",
    "message0": "%1 %2 %3",
    "args0": [
        {
            "type": "field_input",
            "name": "LABEL",
            "text": "label"
        },
        {
            "type": "input_dummy"
        },
        {
            "type": "input_statement",
            "name": "NAME"
        }
    ],
    "previousStatement": null,
    "nextStatement": null,
    "colour": 230,
    "tooltip": "Label block",
    "helpUrl": ""
};

Blockly.Blocks['label_group'] = {
    init: function () {
        this.jsonInit(labelGroupJson);
    }
};