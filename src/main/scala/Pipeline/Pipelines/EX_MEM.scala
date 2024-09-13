package Pipeline

import chisel3._
import chisel3.util._

class EX_MEM extends Module {
  val io = IO(new Bundle {
    val IDEX_MEMRD          =   Input(Bool())
    val IDEX_MEMWR          =   Input(Bool())
    val IDEX_MEMTOREG       =   Input(Bool())
    val IDEX_REG_W          =   Input(Bool())
    val IDEX_rs2            =   Input(SInt(32.W))
    val IDEX_rd             =   Input(UInt(5.W))
    val alu_out             =   Input(SInt(32.W))

    val EXMEM_memRd_out     = Output(Bool())
    val EXMEM_memWr_out     = Output(Bool())
    val EXMEM_memToReg_out  = Output(Bool())
    val EXMEM_reg_w_out     = Output(Bool())
    val EXMEM_rs2_out       = Output(SInt(32.W))
    val EXMEM_rd_out        = Output(UInt(5.W))
    val EXMEM_alu_out       = Output(SInt(32.W))
    })
  
    io.EXMEM_memRd_out      := RegNext(io.IDEX_MEMRD)
    io.EXMEM_memWr_out      := RegNext(io.IDEX_MEMWR)
    io.EXMEM_memToReg_out   := RegNext(io.IDEX_MEMTOREG)
    io.EXMEM_reg_w_out      := RegNext(io.IDEX_REG_W)
    io.EXMEM_rs2_out        := RegNext(io.IDEX_rs2)
    io.EXMEM_rd_out         := RegNext(io.IDEX_rd)
    io.EXMEM_alu_out        := RegNext(io.alu_out)
}
