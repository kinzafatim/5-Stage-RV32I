package Pipeline
import chisel3._
import chisel3.util._
import AluOpCode._

object AluOpCode {
  val ALU_ADD     =   0.U(5.W)
  val ALU_ADDI    =   0.U(5.W)
  val ALU_SW      =   0.U(5.W)
  val ALU_LW      =   0.U(5.W)
  val ALU_LUI     =   0.U(5.W)
  val ALU_AUIPC   =   0.U(5.W)
  val ALU_SLL     =   1.U(5.W)
  val ALU_SLLI    =   1.U(5.W)
  val ALU_SLT     =   2.U(5.W)
  val ALU_SLTI    =   2.U(5.W)
  val ALU_SLTU    =   3.U(5.W)
  val ALU_SLTUI   =   3.U(5.W)
  val ALU_XOR     =   4.U(5.W)
  val ALU_XORI    =   4.U(5.W)
  val ALU_SRL     =   5.U(5.W)
  val ALU_SRLI    =   5.U(5.W)
  val ALU_OR      =   6.U(5.W)
  val ALU_ORI     =   6.U(5.W)
  val ALU_AND     =   7.U(5.W)
  val ALU_ANDI    =   7.U(5.W)
  val ALU_SUB     =   8.U(5.W)
  val ALU_SRA     =   13.U(5.W)
  val ALU_SRAI    =   13.U(5.W)
  val ALU_JAL     =   31.U(5.W)
  val ALU_JALR    =   31.U(5.W)
}

class ALU extends Module {
  val io = IO(new Bundle {
    val in_A = Input(SInt(32.W))
    val in_B = Input(SInt(32.W))
    val alu_Op = Input(UInt(5.W))
    val out = Output(SInt(32.W))
  })

  val result = WireDefault(0.S(32.W))
  switch(io.alu_Op) {
    is(ALU_ADD, ALU_ADDI, ALU_SW, ALU_LW, ALU_LUI, ALU_AUIPC) {
      result := io.in_A + io.in_B
    }
    is(ALU_SLL, ALU_SLLI) {
      result := (io.in_A.asUInt << io.in_B(4, 0)).asSInt
    }
    is(ALU_SLT, ALU_SLTI) {
      result := Mux(io.in_A < io.in_B, 1.S, 0.S)
    }
    is(ALU_SLTU, ALU_SLTUI) {
      result := Mux(io.in_A.asUInt < io.in_B.asUInt, 1.S, 0.S)
    }
    is(ALU_XOR, ALU_XORI) {
      result := io.in_A ^ io.in_B
    }
    is(ALU_SRL, ALU_SRLI) {
      result := (io.in_A.asUInt >> io.in_B(4, 0)).asSInt
    }
    is(ALU_OR, ALU_ORI) {
      result := io.in_A | io.in_B
    }
    is(ALU_AND, ALU_ANDI) {
      result := io.in_A & io.in_B
    }
    is(ALU_SUB) {
      result := io.in_A - io.in_B
    }
    is(ALU_SRA, ALU_SRAI) {
      result := (io.in_A >> io.in_B(4, 0)).asSInt
    }
    is(ALU_JAL, ALU_JALR) {
      result := io.in_A
    }
  }

  io.out := result
}
