import os
from subprocess import Popen, PIPE, STDOUT

from tkinter import *
from tkinter import ttk
from tkinter.filedialog import askopenfilename

app = Tk()
app.title('Assembler GUI')
app.resizable(0, 0)
selected_input  = StringVar(app, '')
selected_output = StringVar(app, '')

def select_input_file():
    global selected_input
    selected_input.set(askopenfilename(
                            filetypes=(("Quanta assembly file", "*.qtf"),),
                            title="Choose an input file."
                        )
                    )

def select_output_file():
    global selected_output
    selected_output.set(askopenfilename(
                            filetypes=(("Memory initialization file", "*.mif"),),
                            title="Choose the output file."
                        )
                    )

assembler_output_txt = None
def assemble():
    global assembler_output_txt
    command = "powershell.exe python Assembler.py '{}' '{}'".format(selected_input.get(), selected_output.get())
    process = Popen(command, shell=True, stdin=PIPE, stdout=PIPE, stderr=STDOUT)
    result = process.stdout.read()
    
    assembler_output_txt.configure(state=NORMAL)
    assembler_output_txt.delete(1.0, END)
    assembler_output_txt.insert(END, result)
    assembler_output_txt.configure(state=DISABLED)
    
input_file_lbl = Label(app, textvariable=selected_input)
input_file_lbl.grid(row=0, column=0)
input_file_btn = Button(app, text='Choose input file', command=select_input_file)
input_file_btn.configure(width=15)
input_file_btn.grid(row=0, column=1)

output_file_lbl = Label(app, textvariable=selected_output)
output_file_lbl.grid(row=1, column=0)
output_file_btn = Button(app, text='Choose output file', command=select_output_file)
output_file_btn.configure(width=15)
output_file_btn.grid(row=1, column=1)

assembler_output_txt = Text(app)
assembler_output_txt.configure(state=DISABLED)
assembler_output_txt.grid(row=2, columnspan=2)

assemble_btn = Button(app, text='Assemble', command=assemble)
assemble_btn.grid(row=3, columnspan=2)

app.mainloop()
