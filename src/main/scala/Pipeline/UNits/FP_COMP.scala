//RV32F

package Pipeline
import chisel3._
import chisel3.util._

class FP_COMP extends Module {
  val io = IO(new Bundle {
    val rs1       = Input(SInt(32.W))
    val rs2       = Input(SInt(32.W))
    val COMP_RESULT = Output(Bool())
  })

  if(io.rs1(31) =/= io.rs2(31)){
    COMP_RESULT := ~io.rs1(31)
  }
  else{
    if(io.rs1(30,23) =/= io.rs2(30,23)){
      COMP_RESULT := (io.rs1 > io.rs2)? 1 : 0
      if(io.rs1(31))
        COMP_RESULT := ~COMP_RESULT
    }
    else{
      if(io.rs1(22,0) > io.rs2(22,0)){
        COMP_RESULT := ~io.rs1(31)
      }
      else{
        COMP_RESULT := io.rs1(31)
      }
    }
  }
}