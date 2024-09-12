package Pipeline

import chisel3._
import chisel3.util._

class IF_ID extends Module {
    val io = IO(new Bundle {
        val pc_in = Input (SInt(32.W))
        val pc4_in = Input (UInt(32.W))
        val mux_f_pc_in = Input (SInt(32.W))
        val mux_g_inst_in = Input (UInt(32.W))

        val pc_out = Output (SInt(32.W))
        val pc4_out = Output (UInt(32.W))
        val mux_f_pc_out = Output (SInt(32.W))
        val mux_g_inst_out = Output (UInt(32.W))
})

val pc_in_reg = RegInit (0.S (32.W))
val pc4_reg = RegInit (0.U (32.W))
val mux_f_reg = RegInit (0.S (32.W))
val mux_g_reg = RegInit (0.U (32.W))

pc_in_reg := io.pc_in
pc4_reg := io.pc4_in
mux_f_reg := io.mux_f_pc_in
mux_g_reg := io.mux_g_inst_in

io.pc_out := pc_in_reg
io.pc4_out := pc4_reg
io.mux_f_pc_out := mux_f_reg
io.mux_g_inst_out := mux_g_reg
}
