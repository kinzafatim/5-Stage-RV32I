// for RV32F
package Pipeline
import chisel3._
import chisel3.util._

class F_Reg extends Module {
  val io = IO(new Bundle {
    val F_rs1       = Input(UInt(5.W))
    val F_rs2       = Input(UInt(5.W))
    val F_rs3       = Input(UInt(5.W))
    val F_reg_write = Input(Bool())
    val F_w_reg     = Input(UInt(5.W))
    val F_w_data    = Input(SInt(32.W))
    val F_rdata1    = Output(SInt(32.W))
    val F_rdata2    = Output(SInt(32.W))
    val F_rdata3    = Output(SInt(32.W))
  })
  val F_regfile = RegInit(VecInit(Seq.fill(32)(0.S(32.W))))

  io.F_rdata1 := Mux(io.F_rs1 === 0.U, 0.S, regfile(io.F_rs1))
  io.F_rdata2 := Mux(io.F_rs2 === 0.U, 0.S, regfile(io.F_rs2))
  io.F_rdata3 := Mux(io.F_rs3 === 0.U, 0.S, regfile(io.F_rs3))

  when(io.F_reg_write && io.F_w_reg =/= 0.U) {
    F_regfile(io.F_w_reg) := io.F_w_data
  }
}
