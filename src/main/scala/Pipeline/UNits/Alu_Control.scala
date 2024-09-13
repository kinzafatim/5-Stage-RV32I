package Pipeline
import chisel3._
import chisel3.util._

class AluControl extends Module {
  val io = IO(new Bundle {
    val func3 = Input(UInt(3.W))
    val func7 = Input(Bool())
    val aluOp = Input(UInt(3.W))
    val out = Output(UInt(5.W))
  })
  io.out := 0.U

  // R type
  when(io.aluOp === 0.U) {
    io.out := Cat(0.U(2.W), io.func7, io.func3)

  // I type
  }.elsewhen(io.aluOp === 1.U) {
    io.out := Cat("b00".U(2.W), io.func3)

  // SB type
  }.elsewhen(io.aluOp === 2.U) {
    io.out := Cat("b010".U(3.W), io.func3)

  // Branch type
  }.elsewhen(io.aluOp === 3.U) {
    io.out := "b11111".U

  // Loads, S type, U type (lui), U type (auipc)
  }.elsewhen(io.aluOp === 4.U || io.aluOp === 5.U || io.aluOp === 6.U || io.aluOp === 7.U) {
    io.out := "b00000".U

  } .otherwise {
    io.out := 0.U
  }
}
