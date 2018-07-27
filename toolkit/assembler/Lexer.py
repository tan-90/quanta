## @file Assembler lexer.

import os
import sys

sys.path.insert(1, os.path.join(sys.path[0], '../../external/ply/'))
import ply.lex as lex

import Util

## @brief Reserved word types.
## @details Holds every accepted instruction and the corresponding type.
## @TODO Optimize this for easier localization.
reserved = {
    'noop': 'NOOP',

    'li': 'IMMEDIATE',

    'not': 'SINGLE_REG',
    'sl': 'SINGLE_REG',
    'asr': 'SINGLE_REG',
    'sr': 'SINGLE_REG',
    'rl': 'SINGLE_REG',
    'rr': 'SINGLE_REG',

    'move': 'DOUBLE_REG',
    'add': 'DOUBLE_REG',
    'sub': 'DOUBLE_REG',
    'and': 'DOUBLE_REG',
    'or': 'DOUBLE_REG',
    'xor': 'DOUBLE_REG',
    'xnor': 'DOUBLE_REG',

    'j': 'JUMP',

    'je': 'BRANCH',
    'jne': 'BRANCH',
    'jl': 'BRANCH',
    'jg': 'BRANCH',

    'call': 'CALL',

    'load': 'MEMORY',
    'store': 'MEMORY'
}

## @brief Token list.
## @brief The common  tokens and the unique values for the instruction types.
tokens = (
    'COMMA',
    'DOLLAR_SIGN',
    'COLON',

    'IDENTIFIER',
    'NUMBER'
) + tuple(set(reserved.values()))

t_COMMA = r'\,'
t_DOLLAR_SIGN = r'\$'
t_COLON = r'\:'

t_ignore = ' \t'

def t_COMMENT(t):
    r';.*'
    pass

def t_IDENTIFIER(t):
    r'[a-zA-z_][a-zA-Z0-9_]*'
    # Check if match is a reserved word.
    t.type = reserved.get(t.value, 'IDENTIFIER')
    return t

def t_NUMBER(t):
    r'[0-9][0-9]*'
    t.value = int(t.value)
    return t

def t_newline(t):
    r'\n+'
    t.lexer.lineno += len(t.value)

def t_error(t):
    # Save error information on the lexer's error log.
    t.lexer.error_log.append({
        'lineno': t.lineno,
        'column': Util.find_column(t)
    })
    # Discard the char that triggered the error to continue parsing.
    t.lexer.skip(1)

## @brief Builds the lexer.
## @return The constructed lexer.
def build_lexer():
    lexer = lex.lex()
    lexer.error_log = []

    return lexer
