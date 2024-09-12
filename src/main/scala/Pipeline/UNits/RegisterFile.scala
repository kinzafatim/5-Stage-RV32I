package Pipeline
import chisel3._
import chisel3.util._

class RegisterFile extends Module {
  val io = IO(new Bundle {
    val rs1       = Input(UInt(5.W))
    val rs2       = Input(UInt(5.W))
    val reg_write = Input(Bool())
    val w_reg     = Input(UInt(5.W))
    val w_data    = Input(SInt(32.W))
    val rdata1    = Output(SInt(32.W))
    val rdata2    = Output(SInt(32.W))
  })
  val regfile = RegInit(VecInit(Seq.fill(32)(0.S(32.W))))

  io.rdata1 := Mux(io.rs1 === 0.U, 0.S, regfile(io.rs1))
  io.rdata2 := Mux(io.rs2 === 0.U, 0.S, regfile(io.rs2))

  when(io.reg_write && io.w_reg =/= 0.U) {
    regfile(io.w_reg) := io.w_data
  }
}
