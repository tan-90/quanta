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
    "message0": "$ %1",
    "args0": [
        {
            "type": "field_dropdown",
            "name": "NAME",
            "options": [
                [
                    "zero",
                    "$zero"
                ],
                [
                    "1",
                    "$1"
                ],
                [
                    "2",
                    "$2"
                ],
                [
                    "3",
                    "$3"
                ],
                [
                    "4",
                    "$4"
                ],
                [
                    "5",
                    "$5"
                ],
                [
                    "6",
                    "$6"
                ],
                [
                    "7",
                    "$7"
                ],
                [
                    "8",
                    "$8"
                ],
                [
                    "9",
                    "$9"
                ],
                [
                    "10",
                    "$10"
                ],
                [
                    "11",
                    "$11"
                ],
                [
                    "12",
                    "$12"
                ],
                [
                    "13",
                    "$13"
                ],
                [
                    "14",
                    "$14"
                ],
                [
                    "15",
                    "$15"
                ],
                [
                    "leds",
                    "$leds"
                ],
                [
                    "hex0",
                    "$hex0"
                ],
                [
                    "hex1",
                    "$hex1"
                ],
                [
                    "hex2",
                    "$hex2"
                ],
                [
                    "20",
                    "$20"
                ],
                [
                    "21",
                    "$21"
                ],
                [
                    "22",
                    "$22"
                ],
                [
                    "23",
                    "$23"
                ],
                [
                    "24",
                    "$24"
                ],
                [
                    "25",
                    "$25"
                ],
                [
                    "26",
                    "$26"
                ],
                [
                    "27",
                    "$27"
                ],
                [
                    "28",
                    "$28"
                ],
                [
                    "29",
                    "$29"
                ],
                [
                    "ra",
                    "$ra"
                ],
                [
                    "a",
                    "$a"
                ],
            ]
        }
    ],
    "inputsInline": true,
    "output": "REGISTER",
    "colour": 180,
    "tooltip": "Register identifier",
    "helpUrl": ""
};

Blockly.Blocks['type_register'] = {
    init: function () {
        this.jsonInit(typeRegisterJson);
    }
};

var typeLabelJson = {
    "type": "type_label",
    "message0": "%1",
    "args0": [
        {
            "type": "field_input",
            "name": "NAME",
            "text": "label"
        }
    ],
    "inputsInline": true,
    "output": "LABEL",
    "colour": 285,
    "tooltip": "",
    "helpUrl": ""
}

Blockly.Blocks['type_label'] = {
    init: function () {
        this.jsonInit(typeLabelJson);
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
 * NOOP instruction
 * 
 * No arguments, no function
 */

var instructionNoopJson = {
    "type": "instruction_noop",
    "message0": "NOOP",
    "previousStatement": null,
    "nextStatement": null,
    "colour": 0,
    "tooltip": "",
    "helpUrl": ""
};

Blockly.Blocks['instruction_noop'] = {
    init: function () {
        this.jsonInit(instructionNoopJson);
    }
};

/**
 * Immediate instruction
 * 
 * Takes a single register and an immediate value
 */
var instructionImmediateJson = {
    "type": "instruction_immediate",
    "message0": "%1 %2 A %3 Immediate %4",
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
            "type": "input_value",
            "name": "REGISTER_A",
            "check": "REGISTER"
        },
        {
            "type": "input_value",
            "name": "IMMEDIATE",
            "check": "Number"
        }
    ],
    "inputsInline": true,
    "previousStatement": null,
    "nextStatement": null,
    "colour": 230,
    "tooltip": "Single Register Immediate Instruction",
    "helpUrl": ""
};

Blockly.Blocks['instruction_immediate'] = {
    init: function () {
        this.jsonInit(instructionImmediateJson);
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
                    "sl",
                    "SL"
                ],
                [
                    "sr",
                    "SR"
                ],
                [
                    "rl",
                    "RL"
                ],
                [
                    "rr",
                    "RR"
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
            "name": "REGISTER_A",
            "check": [
                "REGISTER",
                "LABEL"
            ]
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
                    "mov",
                    "MOV"
                ],
                [
                    "load",
                    "LOAD"
                ],
                [
                    "store",
                    "STORE"
                ],
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
                ],
                [
                    "call",
                    "CALL"
                ]
            ]
        },
        {
            "type": "input_dummy"
        },
        {
            "type": "input_value",
            "name": "REGISTER_A",
            "check": "REGISTER"
        },
        {
            "type": "input_value",
            "name": "REGISTER_B",
            "check": [
                "REGISTER",
                "LABEL"
            ]
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
 * Triple register instruction
 * 
 * Takes two registers
 */

var instructionTripleRegisterJson = {
    "type": "instruction_triple_register",
    "message0": "%1 %2 A %3 B %4 C %5",
    "args0": [
        {
            "type": "field_dropdown",
            "name": "INSTRUCTION",
            "options": [
                [
                    "je",
                    "JE"
                ],
                [
                    "jne",
                    "JNE"
                ],
                [
                    "jl",
                    "JL"
                ],
                [
                    "jg",
                    "JG"
                ]
            ]
        },
        {
            "type": "input_dummy"
        },
        {
            "type": "input_value",
            "name": "REGISTER_A",
            "check": "REGISTER"
        },
        {
            "type": "input_value",
            "name": "REGISTER_B",
            "check": "REGISTER"
        },
        {
            "type": "input_value",
            "name": "REGISTER_C",
            "check": [
                "REGISTER",
                "LABEL"
            ]
        }
    ],
    "inputsInline": true,
    "previousStatement": null,
    "nextStatement": null,
    "colour": 230,
    "tooltip": "",
    "helpUrl": ""
};

Blockly.Blocks['instruction_triple_register'] = {
    init: function () {
        this.jsonInit(instructionTripleRegisterJson);
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
            "name": "STATEMENTS"
        }
    ],
    "previousStatement": null,
    "nextStatement": null,
    "colour": 75,
    "tooltip": "Label block",
    "helpUrl": ""
};

Blockly.Blocks['label_group'] = {
    init: function () {
        this.jsonInit(labelGroupJson);
    }
};

var commentJson = {
    "type": "comment",
    "message0": ";  %1 %2",
    "args0": [
        {
            "type": "input_dummy"
        },
        {
            "type": "field_input",
            "name": "COMMENT",
            "text": "default"
        }
    ],
    "inputsInline": true,
    "previousStatement": null,
    "nextStatement": null,
    "colour": 30,
    "tooltip": "Comment",
    "helpUrl": ""
};

Blockly.Blocks['comment'] = {
    init: function () {
        this.jsonInit(commentJson);
    }
};