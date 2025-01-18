// for RV32F

package Pipeline
import chisel3._
import chisel3.util._
import FPUOpCode._

object FPUOpCode {
  val FPU_FADD_S = 0.U(5.W)
  val FPU_FSUB_S = 1.U(5.W)
  val FPU_FMUL_S = 2.U(5.W)
  val FPU_FDIV_S = 3.U(5.W)
  val FPU_FSGNJ_S = 4.U(5.W)
  val FPU_FSGNJN_S = 5.U(5.W)
  val FPU_FSGNJX_S = 6.U(5.W)
  val FPU_FMIN_S = 7.U(5.W)
  val FPU_FMAX_S = 8.U(5.W)
  val FPU_FEQ_S = 9.U(5.W)
  val FPU_FLT_S = 10.U(5.W)
  val FPU_FLE_S = 11.U(5.W)
  val FPU_FCVT_W_S = 12.U(5.W)
  val FPU_FCVT_WU_S = 13.U(5.W)
  val FPU_FMV_X_W = 14.U(5.W)
  val FPU_FCLASS_S = 15.U(5.W)
  val FPU_FCVT_S_W = 16.U(5.W)
  val FPU_FCVT_S_WU = 17.U(5.W)
  val FPU_FMV_W_X = 18.U(5.W)
}

class FPU extends Module{
  val io = IO(new Bundle{
      val A_data_in = Input(UInt(32.W))
      val B_data_in = Input(UInt(32.W))
      val COMP = Input(Bool())
      val fpu_Op = Input(UInt(5.W))
      val out = Output(UInt(32.W))
  })

  //reg type or wire type?
  val result = 0.U(32.W)
  val result_sign = 0.U(1.W)
  val result_exp = 0.U(8.W)
  val result_frac = 0.U(23.W)
  val carry = 0.U(1.W)
  val exp_diff = 0.U(8.W)

  val A_Mantissa = 0.U(24.W)
  val B_Mantissa = 0.U(24.W)
  val Temp_Mantissa = 0.U(24.W)
  val B_shift_mantissa = 0.U(24.W)

  //comparator
  FP_COMP.io.rs1 := io.A_data_in
  FP_COMP.io.rs2 := io.B_data_in
  COMP := FP_COMP.io.COMP_RESULT  

  val A_swap = COMP ? io.A_data_in : io.B_data_in
  val B_swap = COMP ? io.B_data_in : io.A_data_in

  switch(io.fpu_Op) {
    is(FPU_FADD_S) {
      A_Mantissa := Cat(1.U(1.W), A_swap(22, 0))
      B_Mantissa := Cat(1.U(1.W), B_swap(22, 0))
      // shift mantissa
      exp_diff := A_swap(30, 23) - B_swap(30, 23)
      // add the two mantissa numbers and store the carry
      B_shift_mantissa := B_Mantissa >> exp_diff
      Temp_Mantissa := (A_swap(31) ^ B_swap(31)) ? A_Mantissa - B_shift_mantissa : A_Mantissa + B_shift_mantissa
      carry := Temp_Mantissa(24)
      // normalize the result
      //rd??
      when(carry) {
        Temp_Mantissa := Temp_Mantissa >> 1
        when(result_exp < 255.U) {
          result_exp := result_exp + 1.U
        } .otherwise {
          result_exp := 255.U
        }
      } .elsewhen(Temp_Mantissa =/= 1.U) {
        Temp_Mantissa := 0.U
      } .otherwise {
        for(i <- 0 until 24) {
          when(Temp_Mantissa(23) =/= 1.U && result_exp > 0.U) {
            Temp_Mantissa := Temp_Mantissa << 1
            result_exp := result_exp - 1.U
          }
        }
      }
      result_sign := A_swap(31)
      result_frac := Temp_Mantissa(22, 0)
      result := Cat(result_sign, result_exp, result_frac)
      //result_exp := A_swap(30, 23) + carry - 127.U
      //result := io.in_A + io.in_B
    }
    is(FPU_FSUB_S) {
      //result := io.in_A - io.in_B
    }
    is(FPU_FMUL_S) {
      // multiply the signs
      val result_sign = rs1_sign ^ rs2_sign
      // multiply the fractions
      val result_frac = rs1_frac * rs2_frac
      val exp_update = Mux(result_frac(47), 1.U, 0.U)
      // add the exponents
      val result_exp = rs1_exp + rs2_exp + exp_update - 127.U
    }
    is(FPU_FDIV_S) {
      //result := io.in_A / io.in_B
    }
    is(FPU_FSGNJ_S) {
      //result := Cat(io.in_A(31), io.in_B(30, 0))
    }
    is(FPU_FSGNJN_S) {
      //result := Cat(~io.in_A(31), io.in_B(30, 0))
    }
    is(FPU_FSGNJX_S) {
      //result := Cat(io.in_A(31) ^ io.in_B(31), io.in_B(30, 0))
    }
    is(FPU_FMIN_S) {
      //result := Mux(io.in_A < io.in_B, io.in_A, io.in_B)
    }
    is(FPU_FMAX_S) {
      //result := Mux(io.in_A > io.in_B, io.in_A, io.in_B)
    }
    is(FPU_FEQ_S) {
      //result := Mux(io.in_A === io.in_B, 1.U, 0.U)
    }
    is(FPU_FLT_S) {
      //result := Mux(io.in_A < io.in_B, 1.U, 0.U)
    }
    is(FPU_FLE_S) {
      //result := Mux(io.in_A <= io.in_B, 1.U, 0.U)
    }
    is(FPU_FCVT_W_S) {
      //result := io.in_A.asSInt
    }
    is(FPU_FCVT_WU_S, FPU_FMV_X_W, FPU_FCVT_S_WU, FPU_FMV_W_X) {
      //result := io.in_A
    }
    is(FPU_FCLASS_S) {
      //result := 0.U
    }
    is(FPU_FCVT_S_W) {
      //result := io.in_A.asUInt
    }
  }
}

/*
fp:
  [31] sign
  [30:23] exp
  [22:0] frac

fp_add: 
  swap exp and frac
  extend exp to 24 bits
  shift frac to the right by 1
  add the two numbers
  normalize the result

fp_mul:
  add the exponents
  multiply the fractions
  normalize the result

  
***NOTICE*** : rounding mode should be considered
 */