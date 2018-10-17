# quanta

## About

quanta is an educational soft processor bundled with a toolkit for textual assembly development or on a [Blockly](https://developers.google.com/blockly/) workspace. It's focus is on being a dynamic tool to teach processor architecure using real hardware (FPGA's) and giving access to the circuit model. It implements a simplified MIPS based architecture, making it Turing complete.

quanta was designed primarily for the Altera DE2-115 development board, but written in a way that should ensure compatibility with almost any board requiring only a few tweaks on the IO system. It also uses VHDL 2002 as most of the available tools don't seem to support VHDL 2008 very well.

The entire circuit is documented with [Doxygen](https://github.com/doxygen/doxygen) (I link the git repo as their website seems to be down for a long time) and the docs are also meant to be used as an educational tool.

The quanta toolkit initially consisted of an assembler for text files, but was expanded to include a Blockly editor implementing the assembly language, later further expanded to a web [development environment](http://ec2-18-228-117-206.sa-east-1.compute.amazonaws.com/quanta) that integrates the blockly editor and the assembler running on a [REST API](http://ec2-18-228-117-206.sa-east-1.compute.amazonaws.com/assembler).

A late addition to the toolkit was the VHDL test generator tgen that automatically generates a a testbench for a given VHDL source. The testbench is generated for testing the VHDL entity using the stimulus provided on a CSV file, checking the output against the expected values and generating a log file with the test results indicating what individual tests failed, if any. The use of tgen turned out to be unpractical for large enities, as writing the CSV file took a long time. This lead to the idea of adding a waveform editor that exports CSV files to the toolkit, but that's not yet finished. Despite the test tools not being complete, the circuit has been tested using various assembly programs and as far as I am aware, no bugs are present.

## Notes
quanta is my final course assignment, so despite being a HUGE project I can't accept pull requests. YET. I have a lot of ideas to make quanta a much better tool for teaching processor architecture, increasing even more the size of the project. After my course is finished, I might keep working on it and then there will be no problem on accepting help.

This is my first big VHDL project and it involved a lot of tool development that took a lot of time. As a graduating computer scientist, I have a lot to learn about circuit design, so much can be improved.

Documenting the usage of a project like this is also really hard and time consuming, so the manuals might be lacking. However, if you have any trouble trying out quanta send me an [email](mailto:tan-90@outlook.com) and I'll gladly assist you.

The Blockly code generator works as intended, but I'm aware that it should be completely redone. It just wasn't a priority.

## Running
When you clone the repository, you have everything you need to get quanta up and running, but if you plan to develop using Blockly I strongly encourage the use of the [development environment](http://ec2-18-228-117-206.sa-east-1.compute.amazonaws.com/quanta), as the standalone Blockly editor does not feature an integrated assembler.

The circuit model is in the `hardware/vhdl` folder and you will have to synthesize it for your FPGA. I'm afraid I'm not very familiar with FPGAs other than Altera, since it's what was used on development, but again if you have any trouble, [email](mailto:tan-90@outlook.com) me and I can try to help.

Since the scope of my assignment did not include serial communication, the only way to program the processor is by updating the memory initialization file located on `hardware/data/data.mif`. When your program is ready to go, replace the `data.mif` file with the assembler result, update the memory in your FPGA development tool and program it.
