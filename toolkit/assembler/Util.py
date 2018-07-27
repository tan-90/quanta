def format_error(title, description):
    description = '    ' + description.replace('\n', '\n    ')
    return '{}\n{}'.format(title, description)

def format_column_marker(line, column, prefix=''):
    padding = ' ' * ((column - 1) + len(prefix))
    return '{}{}\n{}^'.format(prefix, line, padding)

## @brief Finds a token's line column based on a global position.
def find_column(token):
    line_start = token.lexer.lexdata.rfind('\n', 0, token.lexpos) + 1
    return (token.lexpos - line_start) + 1
