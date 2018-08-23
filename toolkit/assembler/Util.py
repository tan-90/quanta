## @file
## @brief Small utilities for the assembler.

## @brief Formats an error string.
## @details Adds padding to the error description.
def format_error(title, description):
    description = '    ' + description.replace('\n', '\n    ')
    return '{}\n{}'.format(title, description)

## @brief Points a column of a give line.
def format_column_marker(line, column, prefix=''):
    padding = ' ' * ((column - 1) + len(prefix))
    return '{}{}\n{}^'.format(prefix, line, padding)

## @brief Finds a token's line column based on a global position.
def find_column(token):
    line_start = token.lexer.lexdata.rfind('\n', 0, token.lexpos) + 1
    return (token.lexpos - line_start) + 1

## @briefc Converts an int to a binary stream of fixed length with trailing zeroes to the left.
def to_fixed_length_bin(num, length):
    return str(bin(num))[2:].zfill(length)
