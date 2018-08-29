## @file
## @brief Assembler parser.

import os
import sys

sys.path.insert(1, os.path.join(sys.path[0], '../../external/ply/'))
import ply.yacc as yacc

from Lexer import build_lexer, tokens
import Util

# @brief holds the error log for the past parser run.
# @details While ply recomends globals in this situation, a parser class would look better.
# @TODO Turn lexer and parser into classes
error_log = None

# A separate production for named registers allows delegating register naming to the Assembler.
def p_named_reg(p):
    '''named_reg : DOLLAR_SIGN IDENTIFIER'''
    p[0] = (p[2],)

def p_number_reg(p):
    '''number_reg : DOLLAR_SIGN NUMBER'''
    p[0] = p[2]

def p_reg(p):
    '''reg : named_reg
           | number_reg'''
    p[0] = p[1]

def p_label_id(p):
    '''label_id : IDENTIFIER COLON'''
    p[0] = (p[1],)

def p_label(p):
    '''label : IDENTIFIER'''
    p[0] = p[1]

def p_instr_noop(p):
    '''instr_noop : NOOP'''
    p[0] = p[1]

def p_instr_immediate(p):
    '''instr_immediate : IMMEDIATE reg COMMA NUMBER'''
    p[0] = (p[1], (p[2], p[4]))

def p_instr_single_reg(p):
    '''instr_single_reg : SINGLE_REG reg'''
    p[0] = (p[1], (p[2],))

def p_instr_double_reg(p):
    '''instr_double_reg : DOUBLE_REG reg COMMA reg'''
    p[0] = (p[1], (p[2], p[4]))

def p_instr_jump(p):
    '''instr_jump : JUMP reg
                  | JUMP label'''
    p[0] = (p[1], (p[2],))

def p_instr_branch(p):
    '''instr_branch : BRANCH reg COMMA reg COMMA reg
                    | BRANCH reg COMMA reg COMMA label'''
    p[0] = (p[1], (p[2], p[4], p[6]))

def p_instr_call(p):
    '''instr_call : CALL reg COMMA reg
                  | CALL reg COMMA label'''
    p[0] = (p[1], (p[2], p[4]))

def p_instr_memory(p):
    '''instr_memory : MEMORY reg COMMA reg'''
    p[0] = (p[1], (p[2], p[4]))

def p_instr(p):
    '''instr : instr_noop
             | instr_immediate
             | instr_single_reg
             | instr_double_reg
             | instr_jump
             | instr_branch
             | instr_call
             | instr_memory'''
    p[0] = p[1]

def p_line(p):
    '''line : instr
            | label_id'''
    p[0] = (p.lineno(1), p[1])

def p_program(p):
    '''program : program line
               | empty'''
    if len(p) == 3:
        p.parser.lines.append(p[2])

def p_empty(p):
    '''empty :'''
    pass

def p_error(p):
    global error_log
    # Save error information on the parser's error log.
    error_log.append({
        'lineno': p.lineno,
        'column': Util.find_column(p)
    })
    
def parse(data):
    global error_log

    # Create an error checker lexer.
    # This is not optimal, but allows prettier error logs.
    # A better way might be hiding in ply's huge docs.
    lex_checker = build_lexer()
    lex_checker.input(data)
    while lex_checker.token():
        pass
    log = lex_checker.error_log

    if len(log) > 0:
        title = 'Assembler failed.\nUnexpected token{}:'
        title = title.format('' if len(log) == 1 else 's')

        # List to hold all error messages.
        description = []
        for error in log:
            # Create error message.
            error_pointer = 'line {}> '.format(error['lineno'])
            line = data.split('\n')[error['lineno'] - 1]
            message = Util.format_column_marker(line, error['column'], error_pointer)
            description.append(message)

        sys.stderr.write(Util.format_error(title, '\n'.join(description)))
        exit(-1)

    parser = yacc.yacc(start='program')
    parser.lines = []
    error_log = []
    
    parser.parse(data, lexer=build_lexer(), tracking=True)

    if len(error_log) > 0:
        title = 'Assembler failed.\nSyntax error{}:'
        title = title.format('' if len(error_log) == 1 else 's')

        # List to hold all error messages.
        description = []
        for error in error_log:
            # Create error message.
            error_pointer = 'line {}> '.format(error['lineno'])
            line = data.split('\n')[error['lineno'] - 1]
            message = Util.format_column_marker(line, error['column'], error_pointer)
            description.append(message)

        sys.stderr.write(Util.format_error(title, '\n'.join(description)))
        exit(-1)
        
    return parser.lines
