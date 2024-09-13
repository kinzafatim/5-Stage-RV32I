package Pipeline
import chisel3._
import chisel3.util._

class DataMemory extends Module {
  val io = IO(new Bundle {
    val addr        = Input(UInt(32.W))         // Address input
    val dataIn      = Input(SInt(32.W))         // Data to be written
    val mem_read    = Input(Bool())             // Memory read enable
    val mem_write   = Input(Bool())             // Memory write enable
    val dataOut     = Output(SInt(32.W))        // Data output
  })
  val Dmemory = Mem(1024, SInt(32.W))
  io.dataOut := 0.S

  when(io.mem_write) {
    Dmemory.write(io.addr, io.dataIn)
  }
  when(io.mem_read) {
    io.dataOut := Dmemory.read(io.addr)
  }
}
