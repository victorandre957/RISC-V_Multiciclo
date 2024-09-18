# RISC-V Multicycle Processor in VHDL

## Overview

This project implements a RISC-V multicycle processor in VHDL, designed to handle a subset of the RISC-V instruction set. 
The processor operates through several stages (Fetch, Decode, Execute, Memory and WriteBack), ensuring efficient use of resources in all cycles.

## Features

- Supports important RISC-V instructions, including load/store, arithmetic, arithmetic with immediates, logic, logic with immediates, branch and jump operations.
- The processor was implemented in VHDL, has a testbench to test its operation. The executed instructions need to be loaded into the data.txt file, which will be loaded into memory for execution, up to line 2047 are instructions and up to 4095 data.

## How to run multi-cycle Risc-V

The main folder is Risc-V, the others are individual modules with their respective testbenches. To run the complete processor, load the code contained in this folder and follow these recommendations:

- Use VHDL 1076-2008
- In the compilation order, set Risc-V.vhdl and its testbench to the end
- Run the testbench for 128 ns so that all tests are executed
