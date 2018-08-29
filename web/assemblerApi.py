# @brief Path to the assembler script.
ASSEMBLER_PATH = '../toolkit/assembler/Assembler.py'

from flask import Flask, request, Response, json
from flask_cors import CORS, cross_origin

from subprocess import Popen, PIPE

import os
import io
import sys

app = Flask(__name__)
CORS(app)

## @brief Assembler API.
## @details Receives a program in json format {"program": <code>}.
## @details Response in json format {"error": <error_flag>, "output": <assembler_output>, "assembly": <assembler_result>}.
@app.route('/assembler', methods=['POST'])
def assembler_api():
    # Save the request program to file.
    program = request.get_json()['program']
    with open('.program.qtf', 'wb') as file:
        file.write(program.encode('utf-8'))

    # Start the assembler as a subprocess and redirect output.
    assembler_process = Popen(['python', './{}'.format(ASSEMBLER_PATH), '.program.qtf', '.out.mif'], stdin=PIPE, stdout=PIPE, stderr=PIPE)
    output, err = assembler_process.communicate()
    assembler_process.wait()

    error = assembler_process.returncode != 0

    result = ''
    # Read the result from file if the assembler was successful.
    if not error:
        with open('.out.mif', 'r') as file:
            result = file.read()

    # Assemble response.
    resp = Response(json.dumps({
        "error": error,
        "output": err.decode('utf-8') if error else output.decode('utf-8'),
        "assembly": result
        }), status=200, mimetype='application/json')
    
    return resp
