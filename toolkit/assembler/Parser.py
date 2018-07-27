import ply.yacc as yacc

from Lexer import tokens

lines = None
def save_line(line):
    global lines
    lines.append(line)

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

def p_lines(p):
    '''lines : lines line
             | empty'''
    if len(p) == 3:
        save_line(p[2])

def p_empty(p):
    '''empty :'''
    pass

def p_error(p):
    print("Syntax error in input!")
    print('    {}'.format(str(p)))
    
def parse(data):
    global lines
    lines = []

    parser = yacc.yacc(start='lines')
    parser.parse(data, tracking=True)
    
    return lines
