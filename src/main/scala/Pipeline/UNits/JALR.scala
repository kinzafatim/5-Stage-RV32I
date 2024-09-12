package Pipeline

import chisel3._
import chisel3.util._

class Jalr extends Module {
  val io = IO(new Bundle {
    val imme = Input(UInt(32.W))
    val rdata1 = Input(UInt(32.W))
    val out = Output(UInt(32.W))
  })
  val computedAddr = io.imme + io.rdata1

  // Align the address by masking the least significant bit (LSB) to 0
  io.out := computedAddr & "hFFFFFFFE".U
}
