# 5-Stage Pipeline Processor in Chisel

This repository contains a 5-stage pipeline processor implemented using the Chisel hardware description language. The processor follows the classic RISC-V 5-stage pipeline design, which includes the following stages:

- **Instruction Fetch (IF)**
- **Instruction Decode (ID)**
- **Execute (EX)**
- **Memory Access (MA)**
- **Write Back (WB)**

## Project Structure

- **Top.scala**: The top module that integrates all the stages of the pipeline.
- **IF.scala**: The Instruction Fetch (IF) stage that fetches instructions from memory.
- **ID.scala**: The Instruction Decode (ID) stage that decodes the fetched instructions and prepares operands for execution.
- **EX.scala**: The Execute (EX) stage where arithmetic and logical operations are performed.
- **MA.scala**: The Memory Access (MA) stage that handles data memory read and write operations.
- **WB.scala**: The Write Back (WB) stage that writes results back to the register file.

## Pipeline Registers

Pipeline registers are used between stages to store intermediate data and control signals. This ensures that each stage of the pipeline operates independently and in parallel with the others.

- **IF/ID Pipeline Registers**: These registers hold the instruction and program counter values between the IF and ID stages.
- **ID/EX Pipeline Registers**: These registers pass decoded instruction signals and operands from the ID stage to the EX stage.
- **EX/MEM Pipeline Registers**: These registers carry the results of the EX stage to the MA stage.
- **MEM/WB Pipeline Registers**: These registers transfer the data from the MA stage to the WB stage for final write-back to the register file.

## Top Module Overview

The Top module connects all the stages of the pipeline and handles the flow of data through the pipeline registers. Below is a brief overview of its components:

- **Input/Output**:
  - `in`: Input signal to the processor.
  - `out`: Output signal from the processor.

- **Pipeline Stages**:
  - `fetch`: Instruction Fetch stage.
  - `decoder`: Instruction Decode stage.
  - `execute`: Execute stage.
  - `memory`: Memory Access stage.
  - `writeBack`: Write Back stage.

- **Pipeline Registers**:
  - Registers between each stage are used to pass data and control signals.

- **Control Logic**:
  - Various Mux and control signals ensure correct data flow and pipeline operation.


## Test Cases

### Program 1
```assembly
addi x5 x0 0
addi x6 x0 5
add x8 x6 x5
LOOP:
addi x5 x5 1
sw x5 100(x0)
beq x5 x6 ANS
jal LOOP
ANS: lw x7 100(x0)
```

### Program 2
```assembly
addi x5 x0 3
LOOP:
addi x5 x5 1
addi x6 x0 7
sw x6 100(x5)
lw x7 100(x5)
bne x5 x7 LOOP
```

### Program 3
```assembly
addi x5 x0 0
addi x7 x0 1
addi x6 x0 10
addi x28 x0 0
LOOP: beq x28 x6 END
add x29 x5 x7
add x5 x0 x7
add x7 x0 x29
jal LOOP
END:
Fibonacci Series:
addi x1,x0,0
addi x2,x0,1
addi x10,x0,4
addi x6,x0,40
addi x3,x0,0
addi x4,x3,4
sw x1,0x100(x3)
sw x2,0x100(x4)
addi x14,x0,8
addi x5,x0,8
addi x13,x0,8
addi x15,x0,4
addi x9,x0,4
add x8,x1,x2
up:
beq x5,x6,end
add x12,x0,x8
sw x12,0x100(x5)
lw x11,0x100(x9)
add x8,x11,x8
addi x5,x5,4
addi x9,x9,4
jal x7,up
end:
beq x3,x6,break
lw x16,0x100(x3)
addi x3,x3,4
jal x7,end
break:
```

## Getting Started

To run the processor simulation, clone the repository and use the following commands:

```sh
git clone https://github.com/kinzafatim/5-stage-RV32I.git
cd 5-stage-RV32I
sbt test
```

## Future Work

- Implement hazard detection and forwarding logic.
- Add support for more RISC-V instructions.
- Optimize performance with advanced pipelining techniques.
