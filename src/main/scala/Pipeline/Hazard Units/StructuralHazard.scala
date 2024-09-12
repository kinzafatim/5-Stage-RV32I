package Pipeline

import chisel3._
import chisel3.util._

class StructuralHazard extends Module {
  val io = IO(new Bundle {
    val rs1 = Input(UInt(5.W))
    val rs2 = Input(UInt(5.W))
    val MEM_WB_regWr = Input(Bool())
    val MEM_WB_Rd = Input(UInt(5.W))
    val fwd_rs1 = Output(Bool())
    val fwd_rs2 = Output(Bool())
  })

  // Determine if forwarding is needed for rs1
  when(io.MEM_WB_regWr && io.MEM_WB_Rd === io.rs1) {
    io.fwd_rs1 := true.B
  }.otherwise {
    io.fwd_rs1 := false.B
  }

  // Determine if forwarding is needed for rs2
  when(io.MEM_WB_regWr && io.MEM_WB_Rd === io.rs2) {
    io.fwd_rs2 := true.B
  }.otherwise {
    io.fwd_rs2 := false.B
  }
}
