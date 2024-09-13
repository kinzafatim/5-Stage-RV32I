package Pipeline

import chisel3._
import chisel3.util._

class IF_ID extends Module {
    val io = IO(new Bundle {
        val pc_in               = Input (SInt(32.W))         // PC in
        val pc4_in              = Input (UInt(32.W))         // PC4 in
        val SelectedPC          = Input (SInt(32.W))
        val SelectedInstr       = Input (UInt(32.W))

        val pc_out              = Output (SInt(32.W))        // PC out
        val pc4_out             = Output (UInt(32.W))        // PC + 4 out
        val SelectedPC_out      = Output (SInt(32.W))
        val SelectedInstr_out   = Output (UInt(32.W))
    })

    val Pc_In               = RegInit (0.S (32.W))
    val Pc4_In              = RegInit (0.U (32.W))
    val S_pc                = RegInit (0.S (32.W))
    val S_instr             = RegInit (0.U (32.W))

    Pc_In                   := io.pc_in
    Pc4_In                  := io.pc4_in
    S_pc                    := io.SelectedPC
    S_instr                 := io.SelectedInstr

    io.pc_out               := Pc_In
    io.pc4_out              := Pc4_In
    io.SelectedPC_out       := S_pc
    io.SelectedInstr_out    := S_instr

    // io.pc_out               := RegNext(io.pc_in)
    // io.pc4_out              := RegNext(io.pc4_in)
    // io.SelectedPC_out       := RegNext(io.SelectedPC)
    // io.SelectedInstr_out    := RegNext(io.SelectedInstr)
}

    