package Pipeline

import chisel3._
import chisel3.util._

class ImmGenerator extends Module {
  val io = IO(new Bundle {
    val instr = Input(UInt(32.W))
    val pc = Input(UInt(32.W))
    val I_type = Output(SInt(32.W))
    val S_type = Output(SInt(32.W))
    val SB_type = Output(SInt(32.W))
    val U_type = Output(SInt(32.W))
    val UJ_type = Output(SInt(32.W))
  })

  // I-Type Immediate: [31:20] sign-extended to 32 bits
  io.I_type := Cat(Fill(20, io.instr(31)), io.instr(31, 20)).asSInt

  // S-Type Immediate: [31:25][11:7] sign-extended to 32 bits
  io.S_type := Cat(Fill(20, io.instr(31)), io.instr(31, 25), io.instr(11, 7)).asSInt

  // Branch-Type Immediate: [31][7][30:25][11:8] sign-extended to 32 bits
  val sbImm = Cat(Fill(19, io.instr(31)), io.instr(31), io.instr(7), io.instr(30, 25), io.instr(11, 8), 0.U(1.W)).asSInt
  io.SB_type := sbImm + io.pc.asSInt

  // U-Type Immediate: [31:12] shifted left by 12 bits
  io.U_type := Cat(io.instr(31, 12), Fill(12, 0.U)).asSInt

  // UJ-Type Immediate: [31][19:12][20][30:21] sign-extended to 32 bits, shifted left by 1 bit
  val ujImm = Cat(Fill(11, io.instr(31)), io.instr(31), io.instr(19, 12), io.instr(20), io.instr(30, 21), 0.U(1.W)).asSInt
  io.UJ_type := ujImm + io.pc.asSInt
}
