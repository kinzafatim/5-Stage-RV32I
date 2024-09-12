package Pipeline
import chisel3._
import chisel3.util._

class HazardDetection extends Module {
  val io = IO(new Bundle {
    val IF_ID_inst = Input(UInt(32.W))
    val ID_EX_memRead = Input(Bool())
    val ID_EX_rd = Input(UInt(5.W))
    val pc_in = Input(SInt(32.W))
    val current_pc = Input(SInt(32.W))

    val inst_forward = Output(Bool())
    val pc_forward = Output(Bool())
    val ctrl_forward = Output(Bool())
    val inst_out = Output(UInt(32.W))
    val pc_out = Output(SInt(32.W))
    val current_pc_out = Output(SInt(32.W))
  })

  val Rs1 = io.IF_ID_inst(19, 15)
  val Rs2 = io.IF_ID_inst(24, 20)

  when(io.ID_EX_memRead === 1.B && ((io.ID_EX_rd === Rs1) || (io.ID_EX_rd === Rs2))) {
    io.inst_forward := true.B
    io.pc_forward := true.B
    io.ctrl_forward := true.B
  }.otherwise {
    io.inst_forward := false.B
    io.pc_forward := false.B
    io.ctrl_forward := false.B
  }
  io.inst_out := io.IF_ID_inst
  io.pc_out := io.pc_in
  io.current_pc_out := io.current_pc
}
