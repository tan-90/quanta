'use strict';

goog.provide('Blockly.quanta');

goog.require('Blockly.Generator');

Blockly.quanta = new Blockly.Generator('quanta');

Blockly.quanta.addReservedWords(
  'Blockly,'
);

/**
 * Order of operation ENUMs.
 * Every operation is atomic in quanta assembly
 */
Blockly.quanta.ORDER_ATOMIC = 0;

/*
 * Copied from Blockly Javascript generator
 * 
 * Needs tweaking
 */

/**
 * List of outer-inner pairings that do NOT require parentheses.
 * @type {!Array.<!Array.<number>>}
 */
Blockly.quanta.ORDER_OVERRIDES = [
  // (foo()).bar -> foo().bar
  // (foo())[0] -> foo()[0]
  [Blockly.quanta.ORDER_FUNCTION_CALL, Blockly.quanta.ORDER_MEMBER],
  // (foo())() -> foo()()
  [Blockly.quanta.ORDER_FUNCTION_CALL, Blockly.quanta.ORDER_FUNCTION_CALL],
  // (foo.bar).baz -> foo.bar.baz
  // (foo.bar)[0] -> foo.bar[0]
  // (foo[0]).bar -> foo[0].bar
  // (foo[0])[1] -> foo[0][1]
  [Blockly.quanta.ORDER_MEMBER, Blockly.quanta.ORDER_MEMBER],
  // (foo.bar)() -> foo.bar()
  // (foo[0])() -> foo[0]()
  [Blockly.quanta.ORDER_MEMBER, Blockly.quanta.ORDER_FUNCTION_CALL],

  // !(!foo) -> !!foo
  [Blockly.quanta.ORDER_LOGICAL_NOT, Blockly.quanta.ORDER_LOGICAL_NOT],
  // a * (b * c) -> a * b * c
  [Blockly.quanta.ORDER_MULTIPLICATION, Blockly.quanta.ORDER_MULTIPLICATION],
  // a + (b + c) -> a + b + c
  [Blockly.quanta.ORDER_ADDITION, Blockly.quanta.ORDER_ADDITION],
  // a && (b && c) -> a && b && c
  [Blockly.quanta.ORDER_LOGICAL_AND, Blockly.quanta.ORDER_LOGICAL_AND],
  // a || (b || c) -> a || b || c
  [Blockly.quanta.ORDER_LOGICAL_OR, Blockly.quanta.ORDER_LOGICAL_OR]
];

/**
 * Initialise the database of variable names.
 * @param {!Blockly.Workspace} workspace Workspace to generate code from.
 */
Blockly.quanta.init = function (workspace) {
  // Create a dictionary of definitions to be printed before the code.
  Blockly.quanta.definitions_ = Object.create(null);
  // Create a dictionary mapping desired function names in definitions_
  // to actual function names (to avoid collisions with user functions).
  Blockly.quanta.functionNames_ = Object.create(null);

  if (!Blockly.quanta.variableDB_) {
    Blockly.quanta.variableDB_ =
      new Blockly.Names(Blockly.quanta.RESERVED_WORDS_);
  } else {
    Blockly.quanta.variableDB_.reset();
  }

  Blockly.quanta.variableDB_.setVariableMap(workspace.getVariableMap());

  var defvars = [];
  // Add developer variables (not created or named by the user).
  var devVarList = Blockly.Variables.allDeveloperVariables(workspace);
  for (var i = 0; i < devVarList.length; i++) {
    defvars.push(Blockly.quanta.variableDB_.getName(devVarList[i],
      Blockly.Names.DEVELOPER_VARIABLE_TYPE));
  }

  // Add user variables, but only ones that are being used.
  var variables = Blockly.Variables.allUsedVarModels(workspace);
  for (var i = 0; i < variables.length; i++) {
    defvars.push(Blockly.quanta.variableDB_.getName(variables[i].getId(),
      Blockly.Variables.NAME_TYPE));
  }

  // Declare all of the variables.
  if (defvars.length) {
    Blockly.quanta.definitions_['variables'] =
      'var ' + defvars.join(', ') + ';';
  }
};

/**
 * Prepend the generated code with the variable definitions.
 * @param {string} code Generated code.
 * @return {string} Completed code.
 */
Blockly.quanta.finish = function (code) {
  // Convert the definitions dictionary into a list.
  var definitions = [];
  for (var name in Blockly.quanta.definitions_) {
    definitions.push(Blockly.quanta.definitions_[name]);
  }
  // Clean up temporary data.
  delete Blockly.quanta.definitions_;
  delete Blockly.quanta.functionNames_;
  Blockly.quanta.variableDB_.reset();
  return definitions.join('\n\n') + '\n\n\n' + code;
};

/**
 * Naked values are top-level blocks with outputs that aren't plugged into
 * anything.  A trailing semicolon is needed to make this legal.
 * @param {string} line Line of generated code.
 * @return {string} Legal line of code.
 */
Blockly.quanta.scrubNakedValue = function (line) {
  return line + ';\n';
};

/**
 * Encode a string as a properly escaped quanta string, complete with
 * quotes.
 * @param {string} string Text to encode.
 * @return {string} quanta string.
 * @private
 */
Blockly.quanta.quote_ = function (string) {
  // Can't use goog.string.quote since Google's style guide recommends
  // JS string literals use single quotes.
  string = string.replace(/\\/g, '\\\\')
    .replace(/\n/g, '\\\n')
    .replace(/'/g, '\\\'');
  return '\'' + string + '\'';
};

/**
 * Common tasks for generating quanta from blocks.
 * Handles comments for the specified block and any connected value blocks.
 * Calls any statements following this block.
 * @param {!Blockly.Block} block The current block.
 * @param {string} code The quanta code created for this block.
 * @return {string} quanta code with comments and subsequent blocks added.
 * @private
 */
Blockly.quanta.scrub_ = function (block, code) {
  var commentCode = '';
  // Only collect comments for blocks that aren't inline.
  if (!block.outputConnection || !block.outputConnection.targetConnection) {
    // Collect comment for this block.
    var comment = block.getCommentText();
    comment = Blockly.utils.wrap(comment, Blockly.quanta.COMMENT_WRAP - 3);
    if (comment) {
      if (block.getProcedureDef) {
        // Use a comment block for function comments.
        commentCode += '/**\n' +
          Blockly.quanta.prefixLines(comment + '\n', ' * ') +
          ' */\n';
      } else {
        commentCode += Blockly.quanta.prefixLines(comment + '\n', '// ');
      }
    }
    // Collect comments for all value arguments.
    // Don't collect comments for nested statements.
    for (var i = 0; i < block.inputList.length; i++) {
      if (block.inputList[i].type == Blockly.INPUT_VALUE) {
        var childBlock = block.inputList[i].connection.targetBlock();
        if (childBlock) {
          var comment = Blockly.quanta.allNestedComments(childBlock);
          if (comment) {
            commentCode += Blockly.quanta.prefixLines(comment, '// ');
          }
        }
      }
    }
  }
  var nextBlock = block.nextConnection && block.nextConnection.targetBlock();
  var nextCode = Blockly.quanta.blockToCode(nextBlock);
  return commentCode + code + nextCode;
};

/**
 * Gets a property and adjusts the value while taking into account indexing.
 * @param {!Blockly.Block} block The block.
 * @param {string} atId The property ID of the element to get.
 * @param {number=} opt_delta Value to add.
 * @param {boolean=} opt_negate Whether to negate the value.
 * @param {number=} opt_order The highest order acting on this value.
 * @return {string|number}
 */
Blockly.quanta.getAdjusted = function (block, atId, opt_delta, opt_negate,
  opt_order) {
  var delta = opt_delta || 0;
  var order = opt_order || Blockly.quanta.ORDER_NONE;
  if (block.workspace.options.oneBasedIndex) {
    delta--;
  }
  var defaultAtIndex = block.workspace.options.oneBasedIndex ? '1' : '0';
  if (delta > 0) {
    var at = Blockly.quanta.valueToCode(block, atId,
      Blockly.quanta.ORDER_ADDITION) || defaultAtIndex;
  } else if (delta < 0) {
    var at = Blockly.quanta.valueToCode(block, atId,
      Blockly.quanta.ORDER_SUBTRACTION) || defaultAtIndex;
  } else if (opt_negate) {
    var at = Blockly.quanta.valueToCode(block, atId,
      Blockly.quanta.ORDER_UNARY_NEGATION) || defaultAtIndex;
  } else {
    var at = Blockly.quanta.valueToCode(block, atId, order) ||
      defaultAtIndex;
  }

  if (Blockly.isNumber(at)) {
    // If the index is a naked number, adjust it right now.
    at = parseFloat(at) + delta;
    if (opt_negate) {
      at = -at;
    }
  } else {
    // If the index is dynamic, adjust it in code.
    if (delta > 0) {
      at = at + ' + ' + delta;
      var innerOrder = Blockly.quanta.ORDER_ADDITION;
    } else if (delta < 0) {
      at = at + ' - ' + -delta;
      var innerOrder = Blockly.quanta.ORDER_SUBTRACTION;
    }
    if (opt_negate) {
      if (delta) {
        at = '-(' + at + ')';
      } else {
        at = '-' + at;
      }
      var innerOrder = Blockly.quanta.ORDER_UNARY_NEGATION;
    }
    innerOrder = Math.floor(innerOrder);
    order = Math.floor(order);
    if (innerOrder && order >= innerOrder) {
      at = '(' + at + ')';
    }
  }
  return at;
};
