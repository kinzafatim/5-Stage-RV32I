// for RV32F

package Pipeline
import chisel3._
import chisel3.util._

class FPU_Control extends Module {
  val io = IO(new Bundle {
    val fpu_op = Input(UInt(5.W))
    val fpu_funct3 = Input(UInt(3.W))
    val fpu_funct7 = Input(UInt(4.W)) //27~31 ?
    val fpu_out = Output(UInt(5.W))
    val fpu_enable = Input(Bool())
    //?
    val fpu_busy = Output(Bool())
  })

  io.fpu_out := 0.U
  when(io.fpu_enable) {
    //R type 
    when(io.fpu_op === 0.U) {
      io.fpu_out := Cat(0.U(2.W), io.fpu_funct7, io.fpu_funct3)

    //R4 type
    //fmadd.s
    }.elsewhen(io.fpu_op === 1.U) {
      io.fpu_out := Cat("b00".U(2.W), io.fpu_funct3)
    
    //I type
    }.elsewhen(io.fpu_op === 2.U) {
      io.fpu_out := Cat("b010".U(3.W), io.fpu_funct3)
    
    //S type
    }.elsewhen(io.fpu_op === 3.U) {
      io.fpu_out := "b11111".U
    }.otherwise {
      io.fpu_out := 0.U
    }
  }
  

  
  
  

  //?
  val fpu_busy = RegInit(false.B)
  when(io.fpu_enable) {
    when(io.fpu_op =/= 0.U) {
      fpu_busy := true.B
    }.otherwise {
      fpu_busy := false.B
    }
  }
  io.fpu_busy := fpu_busy
}