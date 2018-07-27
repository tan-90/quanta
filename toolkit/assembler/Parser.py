import ply.yacc as yacc

from Lexer import tokens

def p_reg(p):
    '''reg : DOLLAR_SIGN NUMBER
                  | DOLLAR_SIGN IDENTIFIER'''
    p[0] = p[2]

def p_label_id(p):
    '''label_id : IDENTIFIER COLON'''
    p[0] = p[1]

def p_label(p):
    '''label : IDENTIFIER'''
    p[0] = p[1]

def p_instr_noop(p):
    '''instr_noop : NOOP'''
    p[0] = (p[1],)

def p_instr_immediate(p):
    '''instr_immediate : IMMEDIATE reg COMMA NUMBER'''
    p[0] = (p[1], (p[2], p[3]))

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
    p[0] = p[1]

def p_lines(p):
    '''lines : line lines
             | line'''
    p[0] = p[1:]

def p_error(p):
    print("Syntax error in input!")
    print(p)


parser = yacc.yacc(start='lines')

data = ''
with open('program.qtf', 'r') as file:
    data = file.read()

parser.parse(data)
