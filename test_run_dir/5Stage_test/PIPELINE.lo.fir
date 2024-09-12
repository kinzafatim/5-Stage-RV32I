circuit PIPELINE :
  module PC :
    input clock : Clock
    input reset : UInt<1>
    input io_in : SInt<32>
    output io_out : SInt<32>

    reg PC : SInt<32>, clock with :
      reset => (UInt<1>("h0"), PC) @[PC.scala 11:21]
    io_out <= PC @[PC.scala 12:12]
    PC <= mux(reset, asSInt(UInt<32>("h0")), io_in) @[PC.scala 11:21 PC.scala 11:21 PC.scala 13:8]

  module PC4 :
    input clock : Clock
    input reset : UInt<1>
    input io_pc : UInt<32>
    output io_out : UInt<32>

    node _io_out_T = add(io_pc, UInt<32>("h4")) @[PC4.scala 12:21]
    node _io_out_T_1 = tail(_io_out_T, 1) @[PC4.scala 12:21]
    io_out <= _io_out_T_1 @[PC4.scala 12:12]

  module InstMem :
    input clock : Clock
    input reset : UInt<1>
    input io_addr : UInt<32>
    output io_data : UInt<32>

    mem imem : @[INSTRmem.scala 17:16]
      data-type => UInt<32>
      depth => 1024
      read-latency => 0
      write-latency => 1
      reader => io_data_MPORT
      read-under-write => undefined
    node _io_data_T = bits(io_addr, 9, 0) @[INSTRmem.scala 20:17]
    io_data <= imem.io_data_MPORT.data @[INSTRmem.scala 20:9]
    imem.io_data_MPORT.addr <= _io_data_T @[INSTRmem.scala 20:17]
    imem.io_data_MPORT.en <= UInt<1>("h1") @[INSTRmem.scala 20:17]
    imem.io_data_MPORT.clk <= clock @[INSTRmem.scala 20:17]

  module Control :
    input clock : Clock
    input reset : UInt<1>
    input io_opcode : UInt<7>
    output io_mem_write : UInt<1>
    output io_branch : UInt<1>
    output io_mem_read : UInt<1>
    output io_reg_write : UInt<1>
    output io_men_to_reg : UInt<1>
    output io_alu_operation : UInt<3>
    output io_operand_A : UInt<2>
    output io_operand_B : UInt<1>
    output io_extend : UInt<2>
    output io_next_pc_sel : UInt<2>

    node _T = eq(UInt<6>("h33"), io_opcode) @[Conditional.scala 37:30]
    node _T_1 = eq(UInt<5>("h13"), io_opcode) @[Conditional.scala 37:30]
    node _T_2 = eq(UInt<6>("h23"), io_opcode) @[Conditional.scala 37:30]
    node _T_3 = eq(UInt<2>("h3"), io_opcode) @[Conditional.scala 37:30]
    node _T_4 = eq(UInt<7>("h63"), io_opcode) @[Conditional.scala 37:30]
    node _T_5 = eq(UInt<7>("h6f"), io_opcode) @[Conditional.scala 37:30]
    node _T_6 = eq(UInt<7>("h67"), io_opcode) @[Conditional.scala 37:30]
    node _T_7 = eq(UInt<6>("h37"), io_opcode) @[Conditional.scala 37:30]
    node _T_8 = eq(UInt<5>("h17"), io_opcode) @[Conditional.scala 37:30]
    node _GEN_0 = mux(_T_8, UInt<1>("h0"), UInt<1>("h0")) @[Conditional.scala 39:67 CONTROL.scala 149:20 CONTROL.scala 23:16]
    node _GEN_1 = mux(_T_8, UInt<1>("h1"), UInt<1>("h0")) @[Conditional.scala 39:67 CONTROL.scala 152:20 CONTROL.scala 26:16]
    node _GEN_2 = mux(_T_8, UInt<3>("h7"), UInt<1>("h0")) @[Conditional.scala 39:67 CONTROL.scala 154:24 CONTROL.scala 28:20]
    node _GEN_3 = mux(_T_8, UInt<2>("h2"), UInt<1>("h0")) @[Conditional.scala 39:67 CONTROL.scala 155:20 CONTROL.scala 29:16]
    node _GEN_4 = mux(_T_7, UInt<1>("h0"), _GEN_0) @[Conditional.scala 39:67 CONTROL.scala 135:20]
    node _GEN_5 = mux(_T_7, UInt<1>("h1"), _GEN_1) @[Conditional.scala 39:67 CONTROL.scala 138:20]
    node _GEN_6 = mux(_T_7, UInt<3>("h6"), _GEN_2) @[Conditional.scala 39:67 CONTROL.scala 140:24]
    node _GEN_7 = mux(_T_7, UInt<2>("h3"), _GEN_3) @[Conditional.scala 39:67 CONTROL.scala 141:20]
    node _GEN_8 = mux(_T_7, UInt<2>("h2"), _GEN_3) @[Conditional.scala 39:67 CONTROL.scala 143:17]
    node _GEN_9 = mux(_T_6, UInt<1>("h0"), _GEN_4) @[Conditional.scala 39:67 CONTROL.scala 121:20]
    node _GEN_10 = mux(_T_6, UInt<1>("h1"), _GEN_5) @[Conditional.scala 39:67 CONTROL.scala 124:20]
    node _GEN_11 = mux(_T_6, UInt<2>("h3"), _GEN_6) @[Conditional.scala 39:67 CONTROL.scala 126:24]
    node _GEN_12 = mux(_T_6, UInt<1>("h1"), _GEN_7) @[Conditional.scala 39:67 CONTROL.scala 127:20]
    node _GEN_13 = mux(_T_6, UInt<1>("h0"), _GEN_5) @[Conditional.scala 39:67 CONTROL.scala 128:20]
    node _GEN_14 = mux(_T_6, UInt<1>("h0"), _GEN_8) @[Conditional.scala 39:67 CONTROL.scala 129:17]
    node _GEN_15 = mux(_T_6, UInt<2>("h3"), _GEN_4) @[Conditional.scala 39:67 CONTROL.scala 130:22]
    node _GEN_16 = mux(_T_5, UInt<1>("h0"), _GEN_9) @[Conditional.scala 39:67 CONTROL.scala 107:20]
    node _GEN_17 = mux(_T_5, UInt<1>("h1"), _GEN_10) @[Conditional.scala 39:67 CONTROL.scala 110:20]
    node _GEN_18 = mux(_T_5, UInt<2>("h3"), _GEN_11) @[Conditional.scala 39:67 CONTROL.scala 112:24]
    node _GEN_19 = mux(_T_5, UInt<1>("h1"), _GEN_12) @[Conditional.scala 39:67 CONTROL.scala 113:20]
    node _GEN_20 = mux(_T_5, UInt<1>("h0"), _GEN_13) @[Conditional.scala 39:67 CONTROL.scala 114:20]
    node _GEN_21 = mux(_T_5, UInt<1>("h0"), _GEN_14) @[Conditional.scala 39:67 CONTROL.scala 115:17]
    node _GEN_22 = mux(_T_5, UInt<2>("h2"), _GEN_15) @[Conditional.scala 39:67 CONTROL.scala 116:22]
    node _GEN_23 = mux(_T_4, UInt<1>("h0"), _GEN_16) @[Conditional.scala 39:67 CONTROL.scala 93:20]
    node _GEN_24 = mux(_T_4, UInt<1>("h1"), _GEN_16) @[Conditional.scala 39:67 CONTROL.scala 94:17]
    node _GEN_25 = mux(_T_4, UInt<1>("h0"), _GEN_17) @[Conditional.scala 39:67 CONTROL.scala 96:20]
    node _GEN_26 = mux(_T_4, UInt<2>("h2"), _GEN_18) @[Conditional.scala 39:67 CONTROL.scala 98:24]
    node _GEN_27 = mux(_T_4, UInt<1>("h0"), _GEN_19) @[Conditional.scala 39:67 CONTROL.scala 99:20]
    node _GEN_28 = mux(_T_4, UInt<1>("h0"), _GEN_20) @[Conditional.scala 39:67 CONTROL.scala 100:20]
    node _GEN_29 = mux(_T_4, UInt<1>("h0"), _GEN_21) @[Conditional.scala 39:67 CONTROL.scala 101:17]
    node _GEN_30 = mux(_T_4, UInt<1>("h1"), _GEN_22) @[Conditional.scala 39:67 CONTROL.scala 102:22]
    node _GEN_31 = mux(_T_3, UInt<1>("h0"), _GEN_23) @[Conditional.scala 39:67 CONTROL.scala 79:20]
    node _GEN_32 = mux(_T_3, UInt<1>("h0"), _GEN_24) @[Conditional.scala 39:67 CONTROL.scala 80:17]
    node _GEN_33 = mux(_T_3, UInt<1>("h1"), _GEN_23) @[Conditional.scala 39:67 CONTROL.scala 81:19]
    node _GEN_34 = mux(_T_3, UInt<1>("h1"), _GEN_25) @[Conditional.scala 39:67 CONTROL.scala 82:20]
    node _GEN_35 = mux(_T_3, UInt<3>("h4"), _GEN_26) @[Conditional.scala 39:67 CONTROL.scala 84:24]
    node _GEN_36 = mux(_T_3, UInt<1>("h0"), _GEN_27) @[Conditional.scala 39:67 CONTROL.scala 85:20]
    node _GEN_37 = mux(_T_3, UInt<1>("h1"), _GEN_28) @[Conditional.scala 39:67 CONTROL.scala 86:20]
    node _GEN_38 = mux(_T_3, UInt<1>("h0"), _GEN_29) @[Conditional.scala 39:67 CONTROL.scala 87:17]
    node _GEN_39 = mux(_T_3, UInt<1>("h0"), _GEN_30) @[Conditional.scala 39:67 CONTROL.scala 88:22]
    node _GEN_40 = mux(_T_2, UInt<1>("h1"), _GEN_31) @[Conditional.scala 39:67 CONTROL.scala 65:20]
    node _GEN_41 = mux(_T_2, UInt<1>("h0"), _GEN_32) @[Conditional.scala 39:67 CONTROL.scala 66:17]
    node _GEN_42 = mux(_T_2, UInt<1>("h0"), _GEN_33) @[Conditional.scala 39:67 CONTROL.scala 67:19]
    node _GEN_43 = mux(_T_2, UInt<1>("h0"), _GEN_34) @[Conditional.scala 39:67 CONTROL.scala 68:20]
    node _GEN_44 = mux(_T_2, UInt<3>("h5"), _GEN_35) @[Conditional.scala 39:67 CONTROL.scala 70:24]
    node _GEN_45 = mux(_T_2, UInt<1>("h0"), _GEN_36) @[Conditional.scala 39:67 CONTROL.scala 71:20]
    node _GEN_46 = mux(_T_2, UInt<1>("h1"), _GEN_37) @[Conditional.scala 39:67 CONTROL.scala 72:20]
    node _GEN_47 = mux(_T_2, UInt<1>("h1"), _GEN_38) @[Conditional.scala 39:67 CONTROL.scala 73:17]
    node _GEN_48 = mux(_T_2, UInt<1>("h0"), _GEN_39) @[Conditional.scala 39:67 CONTROL.scala 74:22]
    node _GEN_49 = mux(_T_1, UInt<1>("h0"), _GEN_40) @[Conditional.scala 39:67 CONTROL.scala 51:20]
    node _GEN_50 = mux(_T_1, UInt<1>("h0"), _GEN_41) @[Conditional.scala 39:67 CONTROL.scala 52:17]
    node _GEN_51 = mux(_T_1, UInt<1>("h0"), _GEN_42) @[Conditional.scala 39:67 CONTROL.scala 53:19]
    node _GEN_52 = mux(_T_1, UInt<1>("h1"), _GEN_43) @[Conditional.scala 39:67 CONTROL.scala 54:20]
    node _GEN_53 = mux(_T_1, UInt<1>("h1"), _GEN_44) @[Conditional.scala 39:67 CONTROL.scala 56:24]
    node _GEN_54 = mux(_T_1, UInt<1>("h0"), _GEN_45) @[Conditional.scala 39:67 CONTROL.scala 57:20]
    node _GEN_55 = mux(_T_1, UInt<1>("h1"), _GEN_46) @[Conditional.scala 39:67 CONTROL.scala 58:20]
    node _GEN_56 = mux(_T_1, UInt<1>("h0"), _GEN_47) @[Conditional.scala 39:67 CONTROL.scala 59:17]
    node _GEN_57 = mux(_T_1, UInt<1>("h0"), _GEN_48) @[Conditional.scala 39:67 CONTROL.scala 60:22]
    node _GEN_58 = mux(_T, UInt<1>("h0"), _GEN_49) @[Conditional.scala 40:58 CONTROL.scala 37:20]
    node _GEN_59 = mux(_T, UInt<1>("h0"), _GEN_50) @[Conditional.scala 40:58 CONTROL.scala 38:17]
    node _GEN_60 = mux(_T, UInt<1>("h0"), _GEN_51) @[Conditional.scala 40:58 CONTROL.scala 39:19]
    node _GEN_61 = mux(_T, UInt<1>("h1"), _GEN_52) @[Conditional.scala 40:58 CONTROL.scala 40:20]
    node _GEN_62 = mux(_T, UInt<1>("h0"), _GEN_53) @[Conditional.scala 40:58 CONTROL.scala 42:24]
    node _GEN_63 = mux(_T, UInt<1>("h0"), _GEN_54) @[Conditional.scala 40:58 CONTROL.scala 43:20]
    node _GEN_64 = mux(_T, UInt<1>("h0"), _GEN_55) @[Conditional.scala 40:58 CONTROL.scala 44:20]
    node _GEN_65 = mux(_T, UInt<1>("h0"), _GEN_56) @[Conditional.scala 40:58 CONTROL.scala 45:17]
    node _GEN_66 = mux(_T, UInt<1>("h0"), _GEN_57) @[Conditional.scala 40:58 CONTROL.scala 46:22]
    io_mem_write <= _GEN_58
    io_branch <= _GEN_59
    io_mem_read <= _GEN_60
    io_reg_write <= _GEN_61
    io_men_to_reg <= _GEN_60
    io_alu_operation <= _GEN_62
    io_operand_A <= _GEN_63
    io_operand_B <= _GEN_64
    io_extend <= _GEN_65
    io_next_pc_sel <= _GEN_66

  module ImmGenerator :
    input clock : Clock
    input reset : UInt<1>
    input io_instr : UInt<32>
    input io_pc : UInt<32>
    output io_I_type : SInt<32>
    output io_S_type : SInt<32>
    output io_SB_type : SInt<32>
    output io_U_type : SInt<32>
    output io_UJ_type : SInt<32>

    node _io_I_type_T = bits(io_instr, 31, 31) @[ImmGenerator.scala 18:37]
    node _io_I_type_T_1 = bits(_io_I_type_T, 0, 0) @[Bitwise.scala 72:15]
    node io_I_type_hi = mux(_io_I_type_T_1, UInt<20>("hfffff"), UInt<20>("h0")) @[Bitwise.scala 72:12]
    node io_I_type_lo = bits(io_instr, 31, 20) @[ImmGenerator.scala 18:52]
    node _io_I_type_T_2 = cat(io_I_type_hi, io_I_type_lo) @[Cat.scala 30:58]
    node _io_I_type_T_3 = asSInt(_io_I_type_T_2) @[ImmGenerator.scala 18:62]
    node _io_S_type_T = bits(io_instr, 31, 31) @[ImmGenerator.scala 21:37]
    node _io_S_type_T_1 = bits(_io_S_type_T, 0, 0) @[Bitwise.scala 72:15]
    node io_S_type_hi_hi = mux(_io_S_type_T_1, UInt<20>("hfffff"), UInt<20>("h0")) @[Bitwise.scala 72:12]
    node io_S_type_hi_lo = bits(io_instr, 31, 25) @[ImmGenerator.scala 21:52]
    node io_S_type_lo = bits(io_instr, 11, 7) @[ImmGenerator.scala 21:70]
    node io_S_type_hi = cat(io_S_type_hi_hi, io_S_type_hi_lo) @[Cat.scala 30:58]
    node _io_S_type_T_2 = cat(io_S_type_hi, io_S_type_lo) @[Cat.scala 30:58]
    node _io_S_type_T_3 = asSInt(_io_S_type_T_2) @[ImmGenerator.scala 21:79]
    node _sbImm_T = bits(io_instr, 31, 31) @[ImmGenerator.scala 24:36]
    node _sbImm_T_1 = bits(_sbImm_T, 0, 0) @[Bitwise.scala 72:15]
    node sbImm_hi_hi_hi = mux(_sbImm_T_1, UInt<19>("h7ffff"), UInt<19>("h0")) @[Bitwise.scala 72:12]
    node sbImm_hi_hi_lo = bits(io_instr, 31, 31) @[ImmGenerator.scala 24:51]
    node sbImm_hi_lo = bits(io_instr, 7, 7) @[ImmGenerator.scala 24:65]
    node sbImm_lo_hi_hi = bits(io_instr, 30, 25) @[ImmGenerator.scala 24:78]
    node sbImm_lo_hi_lo = bits(io_instr, 11, 8) @[ImmGenerator.scala 24:96]
    node sbImm_lo_hi = cat(sbImm_lo_hi_hi, sbImm_lo_hi_lo) @[Cat.scala 30:58]
    node sbImm_lo = cat(sbImm_lo_hi, UInt<1>("h0")) @[Cat.scala 30:58]
    node sbImm_hi_hi = cat(sbImm_hi_hi_hi, sbImm_hi_hi_lo) @[Cat.scala 30:58]
    node sbImm_hi = cat(sbImm_hi_hi, sbImm_hi_lo) @[Cat.scala 30:58]
    node _sbImm_T_2 = cat(sbImm_hi, sbImm_lo) @[Cat.scala 30:58]
    node sbImm = asSInt(_sbImm_T_2) @[ImmGenerator.scala 24:115]
    node _io_SB_type_T = asSInt(io_pc) @[ImmGenerator.scala 25:31]
    node _io_SB_type_T_1 = add(sbImm, _io_SB_type_T) @[ImmGenerator.scala 25:23]
    node _io_SB_type_T_2 = tail(_io_SB_type_T_1, 1) @[ImmGenerator.scala 25:23]
    node _io_SB_type_T_3 = asSInt(_io_SB_type_T_2) @[ImmGenerator.scala 25:23]
    node io_U_type_hi = bits(io_instr, 31, 12) @[ImmGenerator.scala 28:28]
    node io_U_type_lo = mux(UInt<1>("h0"), UInt<12>("hfff"), UInt<12>("h0")) @[Bitwise.scala 72:12]
    node _io_U_type_T = cat(io_U_type_hi, io_U_type_lo) @[Cat.scala 30:58]
    node _io_U_type_T_1 = asSInt(_io_U_type_T) @[ImmGenerator.scala 28:53]
    node _ujImm_T = bits(io_instr, 31, 31) @[ImmGenerator.scala 31:36]
    node _ujImm_T_1 = bits(_ujImm_T, 0, 0) @[Bitwise.scala 72:15]
    node ujImm_hi_hi_hi = mux(_ujImm_T_1, UInt<11>("h7ff"), UInt<11>("h0")) @[Bitwise.scala 72:12]
    node ujImm_hi_hi_lo = bits(io_instr, 31, 31) @[ImmGenerator.scala 31:51]
    node ujImm_hi_lo = bits(io_instr, 19, 12) @[ImmGenerator.scala 31:65]
    node ujImm_lo_hi_hi = bits(io_instr, 20, 20) @[ImmGenerator.scala 31:83]
    node ujImm_lo_hi_lo = bits(io_instr, 30, 21) @[ImmGenerator.scala 31:97]
    node ujImm_lo_hi = cat(ujImm_lo_hi_hi, ujImm_lo_hi_lo) @[Cat.scala 30:58]
    node ujImm_lo = cat(ujImm_lo_hi, UInt<1>("h0")) @[Cat.scala 30:58]
    node ujImm_hi_hi = cat(ujImm_hi_hi_hi, ujImm_hi_hi_lo) @[Cat.scala 30:58]
    node ujImm_hi = cat(ujImm_hi_hi, ujImm_hi_lo) @[Cat.scala 30:58]
    node _ujImm_T_2 = cat(ujImm_hi, ujImm_lo) @[Cat.scala 30:58]
    node ujImm = asSInt(_ujImm_T_2) @[ImmGenerator.scala 31:117]
    node _io_UJ_type_T = asSInt(io_pc) @[ImmGenerator.scala 32:31]
    node _io_UJ_type_T_1 = add(ujImm, _io_UJ_type_T) @[ImmGenerator.scala 32:23]
    node _io_UJ_type_T_2 = tail(_io_UJ_type_T_1, 1) @[ImmGenerator.scala 32:23]
    node _io_UJ_type_T_3 = asSInt(_io_UJ_type_T_2) @[ImmGenerator.scala 32:23]
    io_I_type <= _io_I_type_T_3 @[ImmGenerator.scala 18:13]
    io_S_type <= _io_S_type_T_3 @[ImmGenerator.scala 21:13]
    io_SB_type <= _io_SB_type_T_3 @[ImmGenerator.scala 25:14]
    io_U_type <= _io_U_type_T_1 @[ImmGenerator.scala 28:13]
    io_UJ_type <= _io_UJ_type_T_3 @[ImmGenerator.scala 32:14]

  module RegisterFile :
    input clock : Clock
    input reset : UInt<1>
    input io_rs1 : UInt<5>
    input io_rs2 : UInt<5>
    input io_reg_write : UInt<1>
    input io_w_reg : UInt<5>
    input io_w_data : SInt<32>
    output io_rdata1 : SInt<32>
    output io_rdata2 : SInt<32>

    reg regfile_0 : SInt<32>, clock with :
      reset => (UInt<1>("h0"), regfile_0) @[RegisterFile.scala 15:24]
    reg regfile_1 : SInt<32>, clock with :
      reset => (UInt<1>("h0"), regfile_1) @[RegisterFile.scala 15:24]
    reg regfile_2 : SInt<32>, clock with :
      reset => (UInt<1>("h0"), regfile_2) @[RegisterFile.scala 15:24]
    reg regfile_3 : SInt<32>, clock with :
      reset => (UInt<1>("h0"), regfile_3) @[RegisterFile.scala 15:24]
    reg regfile_4 : SInt<32>, clock with :
      reset => (UInt<1>("h0"), regfile_4) @[RegisterFile.scala 15:24]
    reg regfile_5 : SInt<32>, clock with :
      reset => (UInt<1>("h0"), regfile_5) @[RegisterFile.scala 15:24]
    reg regfile_6 : SInt<32>, clock with :
      reset => (UInt<1>("h0"), regfile_6) @[RegisterFile.scala 15:24]
    reg regfile_7 : SInt<32>, clock with :
      reset => (UInt<1>("h0"), regfile_7) @[RegisterFile.scala 15:24]
    reg regfile_8 : SInt<32>, clock with :
      reset => (UInt<1>("h0"), regfile_8) @[RegisterFile.scala 15:24]
    reg regfile_9 : SInt<32>, clock with :
      reset => (UInt<1>("h0"), regfile_9) @[RegisterFile.scala 15:24]
    reg regfile_10 : SInt<32>, clock with :
      reset => (UInt<1>("h0"), regfile_10) @[RegisterFile.scala 15:24]
    reg regfile_11 : SInt<32>, clock with :
      reset => (UInt<1>("h0"), regfile_11) @[RegisterFile.scala 15:24]
    reg regfile_12 : SInt<32>, clock with :
      reset => (UInt<1>("h0"), regfile_12) @[RegisterFile.scala 15:24]
    reg regfile_13 : SInt<32>, clock with :
      reset => (UInt<1>("h0"), regfile_13) @[RegisterFile.scala 15:24]
    reg regfile_14 : SInt<32>, clock with :
      reset => (UInt<1>("h0"), regfile_14) @[RegisterFile.scala 15:24]
    reg regfile_15 : SInt<32>, clock with :
      reset => (UInt<1>("h0"), regfile_15) @[RegisterFile.scala 15:24]
    reg regfile_16 : SInt<32>, clock with :
      reset => (UInt<1>("h0"), regfile_16) @[RegisterFile.scala 15:24]
    reg regfile_17 : SInt<32>, clock with :
      reset => (UInt<1>("h0"), regfile_17) @[RegisterFile.scala 15:24]
    reg regfile_18 : SInt<32>, clock with :
      reset => (UInt<1>("h0"), regfile_18) @[RegisterFile.scala 15:24]
    reg regfile_19 : SInt<32>, clock with :
      reset => (UInt<1>("h0"), regfile_19) @[RegisterFile.scala 15:24]
    reg regfile_20 : SInt<32>, clock with :
      reset => (UInt<1>("h0"), regfile_20) @[RegisterFile.scala 15:24]
    reg regfile_21 : SInt<32>, clock with :
      reset => (UInt<1>("h0"), regfile_21) @[RegisterFile.scala 15:24]
    reg regfile_22 : SInt<32>, clock with :
      reset => (UInt<1>("h0"), regfile_22) @[RegisterFile.scala 15:24]
    reg regfile_23 : SInt<32>, clock with :
      reset => (UInt<1>("h0"), regfile_23) @[RegisterFile.scala 15:24]
    reg regfile_24 : SInt<32>, clock with :
      reset => (UInt<1>("h0"), regfile_24) @[RegisterFile.scala 15:24]
    reg regfile_25 : SInt<32>, clock with :
      reset => (UInt<1>("h0"), regfile_25) @[RegisterFile.scala 15:24]
    reg regfile_26 : SInt<32>, clock with :
      reset => (UInt<1>("h0"), regfile_26) @[RegisterFile.scala 15:24]
    reg regfile_27 : SInt<32>, clock with :
      reset => (UInt<1>("h0"), regfile_27) @[RegisterFile.scala 15:24]
    reg regfile_28 : SInt<32>, clock with :
      reset => (UInt<1>("h0"), regfile_28) @[RegisterFile.scala 15:24]
    reg regfile_29 : SInt<32>, clock with :
      reset => (UInt<1>("h0"), regfile_29) @[RegisterFile.scala 15:24]
    reg regfile_30 : SInt<32>, clock with :
      reset => (UInt<1>("h0"), regfile_30) @[RegisterFile.scala 15:24]
    reg regfile_31 : SInt<32>, clock with :
      reset => (UInt<1>("h0"), regfile_31) @[RegisterFile.scala 15:24]
    node _io_rdata1_T = eq(io_rs1, UInt<1>("h0")) @[RegisterFile.scala 17:27]
    node _GEN_0 = validif(eq(UInt<1>("h0"), io_rs1), regfile_0) @[RegisterFile.scala 17:19 RegisterFile.scala 17:19]
    node _GEN_1 = mux(eq(UInt<1>("h1"), io_rs1), regfile_1, _GEN_0) @[RegisterFile.scala 17:19 RegisterFile.scala 17:19]
    node _GEN_2 = mux(eq(UInt<2>("h2"), io_rs1), regfile_2, _GEN_1) @[RegisterFile.scala 17:19 RegisterFile.scala 17:19]
    node _GEN_3 = mux(eq(UInt<2>("h3"), io_rs1), regfile_3, _GEN_2) @[RegisterFile.scala 17:19 RegisterFile.scala 17:19]
    node _GEN_4 = mux(eq(UInt<3>("h4"), io_rs1), regfile_4, _GEN_3) @[RegisterFile.scala 17:19 RegisterFile.scala 17:19]
    node _GEN_5 = mux(eq(UInt<3>("h5"), io_rs1), regfile_5, _GEN_4) @[RegisterFile.scala 17:19 RegisterFile.scala 17:19]
    node _GEN_6 = mux(eq(UInt<3>("h6"), io_rs1), regfile_6, _GEN_5) @[RegisterFile.scala 17:19 RegisterFile.scala 17:19]
    node _GEN_7 = mux(eq(UInt<3>("h7"), io_rs1), regfile_7, _GEN_6) @[RegisterFile.scala 17:19 RegisterFile.scala 17:19]
    node _GEN_8 = mux(eq(UInt<4>("h8"), io_rs1), regfile_8, _GEN_7) @[RegisterFile.scala 17:19 RegisterFile.scala 17:19]
    node _GEN_9 = mux(eq(UInt<4>("h9"), io_rs1), regfile_9, _GEN_8) @[RegisterFile.scala 17:19 RegisterFile.scala 17:19]
    node _GEN_10 = mux(eq(UInt<4>("ha"), io_rs1), regfile_10, _GEN_9) @[RegisterFile.scala 17:19 RegisterFile.scala 17:19]
    node _GEN_11 = mux(eq(UInt<4>("hb"), io_rs1), regfile_11, _GEN_10) @[RegisterFile.scala 17:19 RegisterFile.scala 17:19]
    node _GEN_12 = mux(eq(UInt<4>("hc"), io_rs1), regfile_12, _GEN_11) @[RegisterFile.scala 17:19 RegisterFile.scala 17:19]
    node _GEN_13 = mux(eq(UInt<4>("hd"), io_rs1), regfile_13, _GEN_12) @[RegisterFile.scala 17:19 RegisterFile.scala 17:19]
    node _GEN_14 = mux(eq(UInt<4>("he"), io_rs1), regfile_14, _GEN_13) @[RegisterFile.scala 17:19 RegisterFile.scala 17:19]
    node _GEN_15 = mux(eq(UInt<4>("hf"), io_rs1), regfile_15, _GEN_14) @[RegisterFile.scala 17:19 RegisterFile.scala 17:19]
    node _GEN_16 = mux(eq(UInt<5>("h10"), io_rs1), regfile_16, _GEN_15) @[RegisterFile.scala 17:19 RegisterFile.scala 17:19]
    node _GEN_17 = mux(eq(UInt<5>("h11"), io_rs1), regfile_17, _GEN_16) @[RegisterFile.scala 17:19 RegisterFile.scala 17:19]
    node _GEN_18 = mux(eq(UInt<5>("h12"), io_rs1), regfile_18, _GEN_17) @[RegisterFile.scala 17:19 RegisterFile.scala 17:19]
    node _GEN_19 = mux(eq(UInt<5>("h13"), io_rs1), regfile_19, _GEN_18) @[RegisterFile.scala 17:19 RegisterFile.scala 17:19]
    node _GEN_20 = mux(eq(UInt<5>("h14"), io_rs1), regfile_20, _GEN_19) @[RegisterFile.scala 17:19 RegisterFile.scala 17:19]
    node _GEN_21 = mux(eq(UInt<5>("h15"), io_rs1), regfile_21, _GEN_20) @[RegisterFile.scala 17:19 RegisterFile.scala 17:19]
    node _GEN_22 = mux(eq(UInt<5>("h16"), io_rs1), regfile_22, _GEN_21) @[RegisterFile.scala 17:19 RegisterFile.scala 17:19]
    node _GEN_23 = mux(eq(UInt<5>("h17"), io_rs1), regfile_23, _GEN_22) @[RegisterFile.scala 17:19 RegisterFile.scala 17:19]
    node _GEN_24 = mux(eq(UInt<5>("h18"), io_rs1), regfile_24, _GEN_23) @[RegisterFile.scala 17:19 RegisterFile.scala 17:19]
    node _GEN_25 = mux(eq(UInt<5>("h19"), io_rs1), regfile_25, _GEN_24) @[RegisterFile.scala 17:19 RegisterFile.scala 17:19]
    node _GEN_26 = mux(eq(UInt<5>("h1a"), io_rs1), regfile_26, _GEN_25) @[RegisterFile.scala 17:19 RegisterFile.scala 17:19]
    node _GEN_27 = mux(eq(UInt<5>("h1b"), io_rs1), regfile_27, _GEN_26) @[RegisterFile.scala 17:19 RegisterFile.scala 17:19]
    node _GEN_28 = mux(eq(UInt<5>("h1c"), io_rs1), regfile_28, _GEN_27) @[RegisterFile.scala 17:19 RegisterFile.scala 17:19]
    node _GEN_29 = mux(eq(UInt<5>("h1d"), io_rs1), regfile_29, _GEN_28) @[RegisterFile.scala 17:19 RegisterFile.scala 17:19]
    node _GEN_30 = mux(eq(UInt<5>("h1e"), io_rs1), regfile_30, _GEN_29) @[RegisterFile.scala 17:19 RegisterFile.scala 17:19]
    node _GEN_31 = mux(eq(UInt<5>("h1f"), io_rs1), regfile_31, _GEN_30) @[RegisterFile.scala 17:19 RegisterFile.scala 17:19]
    node _regfile_io_rs1 = _GEN_31 @[RegisterFile.scala 17:19]
    node _io_rdata1_T_1 = mux(_io_rdata1_T, asSInt(UInt<1>("h0")), _regfile_io_rs1) @[RegisterFile.scala 17:19]
    node _io_rdata2_T = eq(io_rs2, UInt<1>("h0")) @[RegisterFile.scala 18:27]
    node _GEN_32 = validif(eq(UInt<1>("h0"), io_rs2), regfile_0) @[RegisterFile.scala 18:19 RegisterFile.scala 18:19]
    node _GEN_33 = mux(eq(UInt<1>("h1"), io_rs2), regfile_1, _GEN_32) @[RegisterFile.scala 18:19 RegisterFile.scala 18:19]
    node _GEN_34 = mux(eq(UInt<2>("h2"), io_rs2), regfile_2, _GEN_33) @[RegisterFile.scala 18:19 RegisterFile.scala 18:19]
    node _GEN_35 = mux(eq(UInt<2>("h3"), io_rs2), regfile_3, _GEN_34) @[RegisterFile.scala 18:19 RegisterFile.scala 18:19]
    node _GEN_36 = mux(eq(UInt<3>("h4"), io_rs2), regfile_4, _GEN_35) @[RegisterFile.scala 18:19 RegisterFile.scala 18:19]
    node _GEN_37 = mux(eq(UInt<3>("h5"), io_rs2), regfile_5, _GEN_36) @[RegisterFile.scala 18:19 RegisterFile.scala 18:19]
    node _GEN_38 = mux(eq(UInt<3>("h6"), io_rs2), regfile_6, _GEN_37) @[RegisterFile.scala 18:19 RegisterFile.scala 18:19]
    node _GEN_39 = mux(eq(UInt<3>("h7"), io_rs2), regfile_7, _GEN_38) @[RegisterFile.scala 18:19 RegisterFile.scala 18:19]
    node _GEN_40 = mux(eq(UInt<4>("h8"), io_rs2), regfile_8, _GEN_39) @[RegisterFile.scala 18:19 RegisterFile.scala 18:19]
    node _GEN_41 = mux(eq(UInt<4>("h9"), io_rs2), regfile_9, _GEN_40) @[RegisterFile.scala 18:19 RegisterFile.scala 18:19]
    node _GEN_42 = mux(eq(UInt<4>("ha"), io_rs2), regfile_10, _GEN_41) @[RegisterFile.scala 18:19 RegisterFile.scala 18:19]
    node _GEN_43 = mux(eq(UInt<4>("hb"), io_rs2), regfile_11, _GEN_42) @[RegisterFile.scala 18:19 RegisterFile.scala 18:19]
    node _GEN_44 = mux(eq(UInt<4>("hc"), io_rs2), regfile_12, _GEN_43) @[RegisterFile.scala 18:19 RegisterFile.scala 18:19]
    node _GEN_45 = mux(eq(UInt<4>("hd"), io_rs2), regfile_13, _GEN_44) @[RegisterFile.scala 18:19 RegisterFile.scala 18:19]
    node _GEN_46 = mux(eq(UInt<4>("he"), io_rs2), regfile_14, _GEN_45) @[RegisterFile.scala 18:19 RegisterFile.scala 18:19]
    node _GEN_47 = mux(eq(UInt<4>("hf"), io_rs2), regfile_15, _GEN_46) @[RegisterFile.scala 18:19 RegisterFile.scala 18:19]
    node _GEN_48 = mux(eq(UInt<5>("h10"), io_rs2), regfile_16, _GEN_47) @[RegisterFile.scala 18:19 RegisterFile.scala 18:19]
    node _GEN_49 = mux(eq(UInt<5>("h11"), io_rs2), regfile_17, _GEN_48) @[RegisterFile.scala 18:19 RegisterFile.scala 18:19]
    node _GEN_50 = mux(eq(UInt<5>("h12"), io_rs2), regfile_18, _GEN_49) @[RegisterFile.scala 18:19 RegisterFile.scala 18:19]
    node _GEN_51 = mux(eq(UInt<5>("h13"), io_rs2), regfile_19, _GEN_50) @[RegisterFile.scala 18:19 RegisterFile.scala 18:19]
    node _GEN_52 = mux(eq(UInt<5>("h14"), io_rs2), regfile_20, _GEN_51) @[RegisterFile.scala 18:19 RegisterFile.scala 18:19]
    node _GEN_53 = mux(eq(UInt<5>("h15"), io_rs2), regfile_21, _GEN_52) @[RegisterFile.scala 18:19 RegisterFile.scala 18:19]
    node _GEN_54 = mux(eq(UInt<5>("h16"), io_rs2), regfile_22, _GEN_53) @[RegisterFile.scala 18:19 RegisterFile.scala 18:19]
    node _GEN_55 = mux(eq(UInt<5>("h17"), io_rs2), regfile_23, _GEN_54) @[RegisterFile.scala 18:19 RegisterFile.scala 18:19]
    node _GEN_56 = mux(eq(UInt<5>("h18"), io_rs2), regfile_24, _GEN_55) @[RegisterFile.scala 18:19 RegisterFile.scala 18:19]
    node _GEN_57 = mux(eq(UInt<5>("h19"), io_rs2), regfile_25, _GEN_56) @[RegisterFile.scala 18:19 RegisterFile.scala 18:19]
    node _GEN_58 = mux(eq(UInt<5>("h1a"), io_rs2), regfile_26, _GEN_57) @[RegisterFile.scala 18:19 RegisterFile.scala 18:19]
    node _GEN_59 = mux(eq(UInt<5>("h1b"), io_rs2), regfile_27, _GEN_58) @[RegisterFile.scala 18:19 RegisterFile.scala 18:19]
    node _GEN_60 = mux(eq(UInt<5>("h1c"), io_rs2), regfile_28, _GEN_59) @[RegisterFile.scala 18:19 RegisterFile.scala 18:19]
    node _GEN_61 = mux(eq(UInt<5>("h1d"), io_rs2), regfile_29, _GEN_60) @[RegisterFile.scala 18:19 RegisterFile.scala 18:19]
    node _GEN_62 = mux(eq(UInt<5>("h1e"), io_rs2), regfile_30, _GEN_61) @[RegisterFile.scala 18:19 RegisterFile.scala 18:19]
    node _GEN_63 = mux(eq(UInt<5>("h1f"), io_rs2), regfile_31, _GEN_62) @[RegisterFile.scala 18:19 RegisterFile.scala 18:19]
    node _regfile_io_rs2 = _GEN_63 @[RegisterFile.scala 18:19]
    node _io_rdata2_T_1 = mux(_io_rdata2_T, asSInt(UInt<1>("h0")), _regfile_io_rs2) @[RegisterFile.scala 18:19]
    node _T = neq(io_w_reg, UInt<1>("h0")) @[RegisterFile.scala 20:33]
    node _T_1 = and(io_reg_write, _T) @[RegisterFile.scala 20:21]
    node _regfile_io_w_reg = io_w_data @[RegisterFile.scala 21:23 RegisterFile.scala 21:23]
    node _GEN_64 = mux(eq(UInt<1>("h0"), io_w_reg), _regfile_io_w_reg, regfile_0) @[RegisterFile.scala 21:23 RegisterFile.scala 21:23 RegisterFile.scala 15:24]
    node _GEN_65 = mux(eq(UInt<1>("h1"), io_w_reg), _regfile_io_w_reg, regfile_1) @[RegisterFile.scala 21:23 RegisterFile.scala 21:23 RegisterFile.scala 15:24]
    node _GEN_66 = mux(eq(UInt<2>("h2"), io_w_reg), _regfile_io_w_reg, regfile_2) @[RegisterFile.scala 21:23 RegisterFile.scala 21:23 RegisterFile.scala 15:24]
    node _GEN_67 = mux(eq(UInt<2>("h3"), io_w_reg), _regfile_io_w_reg, regfile_3) @[RegisterFile.scala 21:23 RegisterFile.scala 21:23 RegisterFile.scala 15:24]
    node _GEN_68 = mux(eq(UInt<3>("h4"), io_w_reg), _regfile_io_w_reg, regfile_4) @[RegisterFile.scala 21:23 RegisterFile.scala 21:23 RegisterFile.scala 15:24]
    node _GEN_69 = mux(eq(UInt<3>("h5"), io_w_reg), _regfile_io_w_reg, regfile_5) @[RegisterFile.scala 21:23 RegisterFile.scala 21:23 RegisterFile.scala 15:24]
    node _GEN_70 = mux(eq(UInt<3>("h6"), io_w_reg), _regfile_io_w_reg, regfile_6) @[RegisterFile.scala 21:23 RegisterFile.scala 21:23 RegisterFile.scala 15:24]
    node _GEN_71 = mux(eq(UInt<3>("h7"), io_w_reg), _regfile_io_w_reg, regfile_7) @[RegisterFile.scala 21:23 RegisterFile.scala 21:23 RegisterFile.scala 15:24]
    node _GEN_72 = mux(eq(UInt<4>("h8"), io_w_reg), _regfile_io_w_reg, regfile_8) @[RegisterFile.scala 21:23 RegisterFile.scala 21:23 RegisterFile.scala 15:24]
    node _GEN_73 = mux(eq(UInt<4>("h9"), io_w_reg), _regfile_io_w_reg, regfile_9) @[RegisterFile.scala 21:23 RegisterFile.scala 21:23 RegisterFile.scala 15:24]
    node _GEN_74 = mux(eq(UInt<4>("ha"), io_w_reg), _regfile_io_w_reg, regfile_10) @[RegisterFile.scala 21:23 RegisterFile.scala 21:23 RegisterFile.scala 15:24]
    node _GEN_75 = mux(eq(UInt<4>("hb"), io_w_reg), _regfile_io_w_reg, regfile_11) @[RegisterFile.scala 21:23 RegisterFile.scala 21:23 RegisterFile.scala 15:24]
    node _GEN_76 = mux(eq(UInt<4>("hc"), io_w_reg), _regfile_io_w_reg, regfile_12) @[RegisterFile.scala 21:23 RegisterFile.scala 21:23 RegisterFile.scala 15:24]
    node _GEN_77 = mux(eq(UInt<4>("hd"), io_w_reg), _regfile_io_w_reg, regfile_13) @[RegisterFile.scala 21:23 RegisterFile.scala 21:23 RegisterFile.scala 15:24]
    node _GEN_78 = mux(eq(UInt<4>("he"), io_w_reg), _regfile_io_w_reg, regfile_14) @[RegisterFile.scala 21:23 RegisterFile.scala 21:23 RegisterFile.scala 15:24]
    node _GEN_79 = mux(eq(UInt<4>("hf"), io_w_reg), _regfile_io_w_reg, regfile_15) @[RegisterFile.scala 21:23 RegisterFile.scala 21:23 RegisterFile.scala 15:24]
    node _GEN_80 = mux(eq(UInt<5>("h10"), io_w_reg), _regfile_io_w_reg, regfile_16) @[RegisterFile.scala 21:23 RegisterFile.scala 21:23 RegisterFile.scala 15:24]
    node _GEN_81 = mux(eq(UInt<5>("h11"), io_w_reg), _regfile_io_w_reg, regfile_17) @[RegisterFile.scala 21:23 RegisterFile.scala 21:23 RegisterFile.scala 15:24]
    node _GEN_82 = mux(eq(UInt<5>("h12"), io_w_reg), _regfile_io_w_reg, regfile_18) @[RegisterFile.scala 21:23 RegisterFile.scala 21:23 RegisterFile.scala 15:24]
    node _GEN_83 = mux(eq(UInt<5>("h13"), io_w_reg), _regfile_io_w_reg, regfile_19) @[RegisterFile.scala 21:23 RegisterFile.scala 21:23 RegisterFile.scala 15:24]
    node _GEN_84 = mux(eq(UInt<5>("h14"), io_w_reg), _regfile_io_w_reg, regfile_20) @[RegisterFile.scala 21:23 RegisterFile.scala 21:23 RegisterFile.scala 15:24]
    node _GEN_85 = mux(eq(UInt<5>("h15"), io_w_reg), _regfile_io_w_reg, regfile_21) @[RegisterFile.scala 21:23 RegisterFile.scala 21:23 RegisterFile.scala 15:24]
    node _GEN_86 = mux(eq(UInt<5>("h16"), io_w_reg), _regfile_io_w_reg, regfile_22) @[RegisterFile.scala 21:23 RegisterFile.scala 21:23 RegisterFile.scala 15:24]
    node _GEN_87 = mux(eq(UInt<5>("h17"), io_w_reg), _regfile_io_w_reg, regfile_23) @[RegisterFile.scala 21:23 RegisterFile.scala 21:23 RegisterFile.scala 15:24]
    node _GEN_88 = mux(eq(UInt<5>("h18"), io_w_reg), _regfile_io_w_reg, regfile_24) @[RegisterFile.scala 21:23 RegisterFile.scala 21:23 RegisterFile.scala 15:24]
    node _GEN_89 = mux(eq(UInt<5>("h19"), io_w_reg), _regfile_io_w_reg, regfile_25) @[RegisterFile.scala 21:23 RegisterFile.scala 21:23 RegisterFile.scala 15:24]
    node _GEN_90 = mux(eq(UInt<5>("h1a"), io_w_reg), _regfile_io_w_reg, regfile_26) @[RegisterFile.scala 21:23 RegisterFile.scala 21:23 RegisterFile.scala 15:24]
    node _GEN_91 = mux(eq(UInt<5>("h1b"), io_w_reg), _regfile_io_w_reg, regfile_27) @[RegisterFile.scala 21:23 RegisterFile.scala 21:23 RegisterFile.scala 15:24]
    node _GEN_92 = mux(eq(UInt<5>("h1c"), io_w_reg), _regfile_io_w_reg, regfile_28) @[RegisterFile.scala 21:23 RegisterFile.scala 21:23 RegisterFile.scala 15:24]
    node _GEN_93 = mux(eq(UInt<5>("h1d"), io_w_reg), _regfile_io_w_reg, regfile_29) @[RegisterFile.scala 21:23 RegisterFile.scala 21:23 RegisterFile.scala 15:24]
    node _GEN_94 = mux(eq(UInt<5>("h1e"), io_w_reg), _regfile_io_w_reg, regfile_30) @[RegisterFile.scala 21:23 RegisterFile.scala 21:23 RegisterFile.scala 15:24]
    node _GEN_95 = mux(eq(UInt<5>("h1f"), io_w_reg), _regfile_io_w_reg, regfile_31) @[RegisterFile.scala 21:23 RegisterFile.scala 21:23 RegisterFile.scala 15:24]
    node _GEN_96 = mux(_T_1, _GEN_64, regfile_0) @[RegisterFile.scala 20:42 RegisterFile.scala 15:24]
    node _GEN_97 = mux(_T_1, _GEN_65, regfile_1) @[RegisterFile.scala 20:42 RegisterFile.scala 15:24]
    node _GEN_98 = mux(_T_1, _GEN_66, regfile_2) @[RegisterFile.scala 20:42 RegisterFile.scala 15:24]
    node _GEN_99 = mux(_T_1, _GEN_67, regfile_3) @[RegisterFile.scala 20:42 RegisterFile.scala 15:24]
    node _GEN_100 = mux(_T_1, _GEN_68, regfile_4) @[RegisterFile.scala 20:42 RegisterFile.scala 15:24]
    node _GEN_101 = mux(_T_1, _GEN_69, regfile_5) @[RegisterFile.scala 20:42 RegisterFile.scala 15:24]
    node _GEN_102 = mux(_T_1, _GEN_70, regfile_6) @[RegisterFile.scala 20:42 RegisterFile.scala 15:24]
    node _GEN_103 = mux(_T_1, _GEN_71, regfile_7) @[RegisterFile.scala 20:42 RegisterFile.scala 15:24]
    node _GEN_104 = mux(_T_1, _GEN_72, regfile_8) @[RegisterFile.scala 20:42 RegisterFile.scala 15:24]
    node _GEN_105 = mux(_T_1, _GEN_73, regfile_9) @[RegisterFile.scala 20:42 RegisterFile.scala 15:24]
    node _GEN_106 = mux(_T_1, _GEN_74, regfile_10) @[RegisterFile.scala 20:42 RegisterFile.scala 15:24]
    node _GEN_107 = mux(_T_1, _GEN_75, regfile_11) @[RegisterFile.scala 20:42 RegisterFile.scala 15:24]
    node _GEN_108 = mux(_T_1, _GEN_76, regfile_12) @[RegisterFile.scala 20:42 RegisterFile.scala 15:24]
    node _GEN_109 = mux(_T_1, _GEN_77, regfile_13) @[RegisterFile.scala 20:42 RegisterFile.scala 15:24]
    node _GEN_110 = mux(_T_1, _GEN_78, regfile_14) @[RegisterFile.scala 20:42 RegisterFile.scala 15:24]
    node _GEN_111 = mux(_T_1, _GEN_79, regfile_15) @[RegisterFile.scala 20:42 RegisterFile.scala 15:24]
    node _GEN_112 = mux(_T_1, _GEN_80, regfile_16) @[RegisterFile.scala 20:42 RegisterFile.scala 15:24]
    node _GEN_113 = mux(_T_1, _GEN_81, regfile_17) @[RegisterFile.scala 20:42 RegisterFile.scala 15:24]
    node _GEN_114 = mux(_T_1, _GEN_82, regfile_18) @[RegisterFile.scala 20:42 RegisterFile.scala 15:24]
    node _GEN_115 = mux(_T_1, _GEN_83, regfile_19) @[RegisterFile.scala 20:42 RegisterFile.scala 15:24]
    node _GEN_116 = mux(_T_1, _GEN_84, regfile_20) @[RegisterFile.scala 20:42 RegisterFile.scala 15:24]
    node _GEN_117 = mux(_T_1, _GEN_85, regfile_21) @[RegisterFile.scala 20:42 RegisterFile.scala 15:24]
    node _GEN_118 = mux(_T_1, _GEN_86, regfile_22) @[RegisterFile.scala 20:42 RegisterFile.scala 15:24]
    node _GEN_119 = mux(_T_1, _GEN_87, regfile_23) @[RegisterFile.scala 20:42 RegisterFile.scala 15:24]
    node _GEN_120 = mux(_T_1, _GEN_88, regfile_24) @[RegisterFile.scala 20:42 RegisterFile.scala 15:24]
    node _GEN_121 = mux(_T_1, _GEN_89, regfile_25) @[RegisterFile.scala 20:42 RegisterFile.scala 15:24]
    node _GEN_122 = mux(_T_1, _GEN_90, regfile_26) @[RegisterFile.scala 20:42 RegisterFile.scala 15:24]
    node _GEN_123 = mux(_T_1, _GEN_91, regfile_27) @[RegisterFile.scala 20:42 RegisterFile.scala 15:24]
    node _GEN_124 = mux(_T_1, _GEN_92, regfile_28) @[RegisterFile.scala 20:42 RegisterFile.scala 15:24]
    node _GEN_125 = mux(_T_1, _GEN_93, regfile_29) @[RegisterFile.scala 20:42 RegisterFile.scala 15:24]
    node _GEN_126 = mux(_T_1, _GEN_94, regfile_30) @[RegisterFile.scala 20:42 RegisterFile.scala 15:24]
    node _GEN_127 = mux(_T_1, _GEN_95, regfile_31) @[RegisterFile.scala 20:42 RegisterFile.scala 15:24]
    node _regfile_WIRE_0 = asSInt(UInt<32>("h0")) @[RegisterFile.scala 15:32 RegisterFile.scala 15:32]
    node _regfile_WIRE_1 = asSInt(UInt<32>("h0")) @[RegisterFile.scala 15:32 RegisterFile.scala 15:32]
    node _regfile_WIRE_2 = asSInt(UInt<32>("h0")) @[RegisterFile.scala 15:32 RegisterFile.scala 15:32]
    node _regfile_WIRE_3 = asSInt(UInt<32>("h0")) @[RegisterFile.scala 15:32 RegisterFile.scala 15:32]
    node _regfile_WIRE_4 = asSInt(UInt<32>("h0")) @[RegisterFile.scala 15:32 RegisterFile.scala 15:32]
    node _regfile_WIRE_5 = asSInt(UInt<32>("h0")) @[RegisterFile.scala 15:32 RegisterFile.scala 15:32]
    node _regfile_WIRE_6 = asSInt(UInt<32>("h0")) @[RegisterFile.scala 15:32 RegisterFile.scala 15:32]
    node _regfile_WIRE_7 = asSInt(UInt<32>("h0")) @[RegisterFile.scala 15:32 RegisterFile.scala 15:32]
    node _regfile_WIRE_8 = asSInt(UInt<32>("h0")) @[RegisterFile.scala 15:32 RegisterFile.scala 15:32]
    node _regfile_WIRE_9 = asSInt(UInt<32>("h0")) @[RegisterFile.scala 15:32 RegisterFile.scala 15:32]
    node _regfile_WIRE_10 = asSInt(UInt<32>("h0")) @[RegisterFile.scala 15:32 RegisterFile.scala 15:32]
    node _regfile_WIRE_11 = asSInt(UInt<32>("h0")) @[RegisterFile.scala 15:32 RegisterFile.scala 15:32]
    node _regfile_WIRE_12 = asSInt(UInt<32>("h0")) @[RegisterFile.scala 15:32 RegisterFile.scala 15:32]
    node _regfile_WIRE_13 = asSInt(UInt<32>("h0")) @[RegisterFile.scala 15:32 RegisterFile.scala 15:32]
    node _regfile_WIRE_14 = asSInt(UInt<32>("h0")) @[RegisterFile.scala 15:32 RegisterFile.scala 15:32]
    node _regfile_WIRE_15 = asSInt(UInt<32>("h0")) @[RegisterFile.scala 15:32 RegisterFile.scala 15:32]
    node _regfile_WIRE_16 = asSInt(UInt<32>("h0")) @[RegisterFile.scala 15:32 RegisterFile.scala 15:32]
    node _regfile_WIRE_17 = asSInt(UInt<32>("h0")) @[RegisterFile.scala 15:32 RegisterFile.scala 15:32]
    node _regfile_WIRE_18 = asSInt(UInt<32>("h0")) @[RegisterFile.scala 15:32 RegisterFile.scala 15:32]
    node _regfile_WIRE_19 = asSInt(UInt<32>("h0")) @[RegisterFile.scala 15:32 RegisterFile.scala 15:32]
    node _regfile_WIRE_20 = asSInt(UInt<32>("h0")) @[RegisterFile.scala 15:32 RegisterFile.scala 15:32]
    node _regfile_WIRE_21 = asSInt(UInt<32>("h0")) @[RegisterFile.scala 15:32 RegisterFile.scala 15:32]
    node _regfile_WIRE_22 = asSInt(UInt<32>("h0")) @[RegisterFile.scala 15:32 RegisterFile.scala 15:32]
    node _regfile_WIRE_23 = asSInt(UInt<32>("h0")) @[RegisterFile.scala 15:32 RegisterFile.scala 15:32]
    node _regfile_WIRE_24 = asSInt(UInt<32>("h0")) @[RegisterFile.scala 15:32 RegisterFile.scala 15:32]
    node _regfile_WIRE_25 = asSInt(UInt<32>("h0")) @[RegisterFile.scala 15:32 RegisterFile.scala 15:32]
    node _regfile_WIRE_26 = asSInt(UInt<32>("h0")) @[RegisterFile.scala 15:32 RegisterFile.scala 15:32]
    node _regfile_WIRE_27 = asSInt(UInt<32>("h0")) @[RegisterFile.scala 15:32 RegisterFile.scala 15:32]
    node _regfile_WIRE_28 = asSInt(UInt<32>("h0")) @[RegisterFile.scala 15:32 RegisterFile.scala 15:32]
    node _regfile_WIRE_29 = asSInt(UInt<32>("h0")) @[RegisterFile.scala 15:32 RegisterFile.scala 15:32]
    node _regfile_WIRE_30 = asSInt(UInt<32>("h0")) @[RegisterFile.scala 15:32 RegisterFile.scala 15:32]
    node _regfile_WIRE_31 = asSInt(UInt<32>("h0")) @[RegisterFile.scala 15:32 RegisterFile.scala 15:32]
    io_rdata1 <= _io_rdata1_T_1 @[RegisterFile.scala 17:13]
    io_rdata2 <= _io_rdata2_T_1 @[RegisterFile.scala 18:13]
    regfile_0 <= mux(reset, _regfile_WIRE_0, _GEN_96) @[RegisterFile.scala 15:24 RegisterFile.scala 15:24]
    regfile_1 <= mux(reset, _regfile_WIRE_1, _GEN_97) @[RegisterFile.scala 15:24 RegisterFile.scala 15:24]
    regfile_2 <= mux(reset, _regfile_WIRE_2, _GEN_98) @[RegisterFile.scala 15:24 RegisterFile.scala 15:24]
    regfile_3 <= mux(reset, _regfile_WIRE_3, _GEN_99) @[RegisterFile.scala 15:24 RegisterFile.scala 15:24]
    regfile_4 <= mux(reset, _regfile_WIRE_4, _GEN_100) @[RegisterFile.scala 15:24 RegisterFile.scala 15:24]
    regfile_5 <= mux(reset, _regfile_WIRE_5, _GEN_101) @[RegisterFile.scala 15:24 RegisterFile.scala 15:24]
    regfile_6 <= mux(reset, _regfile_WIRE_6, _GEN_102) @[RegisterFile.scala 15:24 RegisterFile.scala 15:24]
    regfile_7 <= mux(reset, _regfile_WIRE_7, _GEN_103) @[RegisterFile.scala 15:24 RegisterFile.scala 15:24]
    regfile_8 <= mux(reset, _regfile_WIRE_8, _GEN_104) @[RegisterFile.scala 15:24 RegisterFile.scala 15:24]
    regfile_9 <= mux(reset, _regfile_WIRE_9, _GEN_105) @[RegisterFile.scala 15:24 RegisterFile.scala 15:24]
    regfile_10 <= mux(reset, _regfile_WIRE_10, _GEN_106) @[RegisterFile.scala 15:24 RegisterFile.scala 15:24]
    regfile_11 <= mux(reset, _regfile_WIRE_11, _GEN_107) @[RegisterFile.scala 15:24 RegisterFile.scala 15:24]
    regfile_12 <= mux(reset, _regfile_WIRE_12, _GEN_108) @[RegisterFile.scala 15:24 RegisterFile.scala 15:24]
    regfile_13 <= mux(reset, _regfile_WIRE_13, _GEN_109) @[RegisterFile.scala 15:24 RegisterFile.scala 15:24]
    regfile_14 <= mux(reset, _regfile_WIRE_14, _GEN_110) @[RegisterFile.scala 15:24 RegisterFile.scala 15:24]
    regfile_15 <= mux(reset, _regfile_WIRE_15, _GEN_111) @[RegisterFile.scala 15:24 RegisterFile.scala 15:24]
    regfile_16 <= mux(reset, _regfile_WIRE_16, _GEN_112) @[RegisterFile.scala 15:24 RegisterFile.scala 15:24]
    regfile_17 <= mux(reset, _regfile_WIRE_17, _GEN_113) @[RegisterFile.scala 15:24 RegisterFile.scala 15:24]
    regfile_18 <= mux(reset, _regfile_WIRE_18, _GEN_114) @[RegisterFile.scala 15:24 RegisterFile.scala 15:24]
    regfile_19 <= mux(reset, _regfile_WIRE_19, _GEN_115) @[RegisterFile.scala 15:24 RegisterFile.scala 15:24]
    regfile_20 <= mux(reset, _regfile_WIRE_20, _GEN_116) @[RegisterFile.scala 15:24 RegisterFile.scala 15:24]
    regfile_21 <= mux(reset, _regfile_WIRE_21, _GEN_117) @[RegisterFile.scala 15:24 RegisterFile.scala 15:24]
    regfile_22 <= mux(reset, _regfile_WIRE_22, _GEN_118) @[RegisterFile.scala 15:24 RegisterFile.scala 15:24]
    regfile_23 <= mux(reset, _regfile_WIRE_23, _GEN_119) @[RegisterFile.scala 15:24 RegisterFile.scala 15:24]
    regfile_24 <= mux(reset, _regfile_WIRE_24, _GEN_120) @[RegisterFile.scala 15:24 RegisterFile.scala 15:24]
    regfile_25 <= mux(reset, _regfile_WIRE_25, _GEN_121) @[RegisterFile.scala 15:24 RegisterFile.scala 15:24]
    regfile_26 <= mux(reset, _regfile_WIRE_26, _GEN_122) @[RegisterFile.scala 15:24 RegisterFile.scala 15:24]
    regfile_27 <= mux(reset, _regfile_WIRE_27, _GEN_123) @[RegisterFile.scala 15:24 RegisterFile.scala 15:24]
    regfile_28 <= mux(reset, _regfile_WIRE_28, _GEN_124) @[RegisterFile.scala 15:24 RegisterFile.scala 15:24]
    regfile_29 <= mux(reset, _regfile_WIRE_29, _GEN_125) @[RegisterFile.scala 15:24 RegisterFile.scala 15:24]
    regfile_30 <= mux(reset, _regfile_WIRE_30, _GEN_126) @[RegisterFile.scala 15:24 RegisterFile.scala 15:24]
    regfile_31 <= mux(reset, _regfile_WIRE_31, _GEN_127) @[RegisterFile.scala 15:24 RegisterFile.scala 15:24]

  module AluControl :
    input clock : Clock
    input reset : UInt<1>
    input io_func3 : UInt<3>
    input io_func7 : UInt<1>
    input io_aluOp : UInt<3>
    output io_out : UInt<5>

    node _T = eq(io_aluOp, UInt<1>("h0")) @[Alu_Control.scala 16:17]
    node io_out_hi = cat(UInt<2>("h0"), io_func7) @[Cat.scala 30:58]
    node _io_out_T = cat(io_out_hi, io_func3) @[Cat.scala 30:58]
    node _T_1 = eq(io_aluOp, UInt<1>("h1")) @[Alu_Control.scala 20:23]
    node _io_out_T_1 = cat(UInt<2>("h0"), io_func3) @[Cat.scala 30:58]
    node _T_2 = eq(io_aluOp, UInt<2>("h2")) @[Alu_Control.scala 24:23]
    node _io_out_T_2 = cat(UInt<3>("h2"), io_func3) @[Cat.scala 30:58]
    node _T_3 = eq(io_aluOp, UInt<2>("h3")) @[Alu_Control.scala 28:23]
    node _T_4 = eq(io_aluOp, UInt<3>("h4")) @[Alu_Control.scala 32:23]
    node _T_5 = eq(io_aluOp, UInt<3>("h5")) @[Alu_Control.scala 32:43]
    node _T_6 = or(_T_4, _T_5) @[Alu_Control.scala 32:31]
    node _T_7 = eq(io_aluOp, UInt<3>("h6")) @[Alu_Control.scala 32:63]
    node _T_8 = or(_T_6, _T_7) @[Alu_Control.scala 32:51]
    node _T_9 = eq(io_aluOp, UInt<3>("h7")) @[Alu_Control.scala 32:83]
    node _T_10 = or(_T_8, _T_9) @[Alu_Control.scala 32:71]
    node _GEN_0 = mux(_T_10, UInt<1>("h0"), UInt<1>("h0")) @[Alu_Control.scala 32:92 Alu_Control.scala 33:12 Alu_Control.scala 36:12]
    node _GEN_1 = mux(_T_3, UInt<5>("h1f"), _GEN_0) @[Alu_Control.scala 28:32 Alu_Control.scala 29:12]
    node _GEN_2 = mux(_T_2, _io_out_T_2, _GEN_1) @[Alu_Control.scala 24:32 Alu_Control.scala 25:12]
    node _GEN_3 = mux(_T_1, _io_out_T_1, _GEN_2) @[Alu_Control.scala 20:32 Alu_Control.scala 21:12]
    node _GEN_4 = mux(_T, _io_out_T, _GEN_3) @[Alu_Control.scala 16:26 Alu_Control.scala 17:12]
    io_out <= bits(_GEN_4, 4, 0)

  module ALU :
    input clock : Clock
    input reset : UInt<1>
    input io_in_A : SInt<32>
    input io_in_B : SInt<32>
    input io_alu_Op : UInt<5>
    output io_out : SInt<32>

    node _T = eq(UInt<5>("h0"), io_alu_Op) @[Conditional.scala 37:30]
    node _T_1 = eq(UInt<5>("h0"), io_alu_Op) @[Conditional.scala 37:30]
    node _T_2 = eq(UInt<5>("h0"), io_alu_Op) @[Conditional.scala 37:30]
    node _T_3 = eq(UInt<5>("h0"), io_alu_Op) @[Conditional.scala 37:30]
    node _T_4 = eq(UInt<5>("h0"), io_alu_Op) @[Conditional.scala 37:30]
    node _T_5 = eq(UInt<5>("h0"), io_alu_Op) @[Conditional.scala 37:30]
    node _T_6 = or(_T, _T_1) @[Conditional.scala 37:55]
    node _T_7 = or(_T_6, _T_2) @[Conditional.scala 37:55]
    node _T_8 = or(_T_7, _T_3) @[Conditional.scala 37:55]
    node _T_9 = or(_T_8, _T_4) @[Conditional.scala 37:55]
    node _T_10 = or(_T_9, _T_5) @[Conditional.scala 37:55]
    node _result_T = add(io_in_A, io_in_B) @[Alu.scala 45:25]
    node _result_T_1 = tail(_result_T, 1) @[Alu.scala 45:25]
    node _result_T_2 = asSInt(_result_T_1) @[Alu.scala 45:25]
    node _T_11 = eq(UInt<5>("h1"), io_alu_Op) @[Conditional.scala 37:30]
    node _T_12 = eq(UInt<5>("h1"), io_alu_Op) @[Conditional.scala 37:30]
    node _T_13 = or(_T_11, _T_12) @[Conditional.scala 37:55]
    node _result_T_3 = asUInt(io_in_A) @[Alu.scala 48:26]
    node _result_T_4 = bits(io_in_B, 4, 0) @[Alu.scala 48:43]
    node _result_T_5 = dshl(_result_T_3, _result_T_4) @[Alu.scala 48:33]
    node _result_T_6 = asSInt(_result_T_5) @[Alu.scala 48:51]
    node _T_14 = eq(UInt<5>("h2"), io_alu_Op) @[Conditional.scala 37:30]
    node _T_15 = eq(UInt<5>("h2"), io_alu_Op) @[Conditional.scala 37:30]
    node _T_16 = or(_T_14, _T_15) @[Conditional.scala 37:55]
    node _result_T_7 = lt(io_in_A, io_in_B) @[Alu.scala 51:29]
    node _result_T_8 = mux(_result_T_7, asSInt(UInt<2>("h1")), asSInt(UInt<1>("h0"))) @[Alu.scala 51:20]
    node _T_17 = eq(UInt<5>("h3"), io_alu_Op) @[Conditional.scala 37:30]
    node _T_18 = eq(UInt<5>("h3"), io_alu_Op) @[Conditional.scala 37:30]
    node _T_19 = or(_T_17, _T_18) @[Conditional.scala 37:55]
    node _result_T_9 = asUInt(io_in_A) @[Alu.scala 54:29]
    node _result_T_10 = asUInt(io_in_B) @[Alu.scala 54:46]
    node _result_T_11 = lt(_result_T_9, _result_T_10) @[Alu.scala 54:36]
    node _result_T_12 = mux(_result_T_11, asSInt(UInt<2>("h1")), asSInt(UInt<1>("h0"))) @[Alu.scala 54:20]
    node _T_20 = eq(UInt<5>("h4"), io_alu_Op) @[Conditional.scala 37:30]
    node _T_21 = eq(UInt<5>("h4"), io_alu_Op) @[Conditional.scala 37:30]
    node _T_22 = or(_T_20, _T_21) @[Conditional.scala 37:55]
    node _result_T_13 = xor(io_in_A, io_in_B) @[Alu.scala 57:25]
    node _result_T_14 = asSInt(_result_T_13) @[Alu.scala 57:25]
    node _T_23 = eq(UInt<5>("h5"), io_alu_Op) @[Conditional.scala 37:30]
    node _T_24 = eq(UInt<5>("h5"), io_alu_Op) @[Conditional.scala 37:30]
    node _T_25 = or(_T_23, _T_24) @[Conditional.scala 37:55]
    node _result_T_15 = asUInt(io_in_A) @[Alu.scala 60:26]
    node _result_T_16 = bits(io_in_B, 4, 0) @[Alu.scala 60:43]
    node _result_T_17 = dshr(_result_T_15, _result_T_16) @[Alu.scala 60:33]
    node _result_T_18 = asSInt(_result_T_17) @[Alu.scala 60:51]
    node _T_26 = eq(UInt<5>("h6"), io_alu_Op) @[Conditional.scala 37:30]
    node _T_27 = eq(UInt<5>("h6"), io_alu_Op) @[Conditional.scala 37:30]
    node _T_28 = or(_T_26, _T_27) @[Conditional.scala 37:55]
    node _result_T_19 = or(io_in_A, io_in_B) @[Alu.scala 63:25]
    node _result_T_20 = asSInt(_result_T_19) @[Alu.scala 63:25]
    node _T_29 = eq(UInt<5>("h7"), io_alu_Op) @[Conditional.scala 37:30]
    node _T_30 = eq(UInt<5>("h7"), io_alu_Op) @[Conditional.scala 37:30]
    node _T_31 = or(_T_29, _T_30) @[Conditional.scala 37:55]
    node _result_T_21 = and(io_in_A, io_in_B) @[Alu.scala 66:25]
    node _result_T_22 = asSInt(_result_T_21) @[Alu.scala 66:25]
    node _T_32 = eq(UInt<5>("h8"), io_alu_Op) @[Conditional.scala 37:30]
    node _result_T_23 = sub(io_in_A, io_in_B) @[Alu.scala 69:25]
    node _result_T_24 = tail(_result_T_23, 1) @[Alu.scala 69:25]
    node _result_T_25 = asSInt(_result_T_24) @[Alu.scala 69:25]
    node _T_33 = eq(UInt<5>("hd"), io_alu_Op) @[Conditional.scala 37:30]
    node _T_34 = eq(UInt<5>("hd"), io_alu_Op) @[Conditional.scala 37:30]
    node _T_35 = or(_T_33, _T_34) @[Conditional.scala 37:55]
    node _result_T_26 = bits(io_in_B, 4, 0) @[Alu.scala 72:36]
    node _result_T_27 = dshr(io_in_A, _result_T_26) @[Alu.scala 72:26]
    node _T_36 = eq(UInt<5>("h1f"), io_alu_Op) @[Conditional.scala 37:30]
    node _T_37 = eq(UInt<5>("h1f"), io_alu_Op) @[Conditional.scala 37:30]
    node _T_38 = or(_T_36, _T_37) @[Conditional.scala 37:55]
    node _GEN_0 = mux(_T_38, io_in_A, asSInt(UInt<32>("h0"))) @[Conditional.scala 39:67 Alu.scala 75:14]
    node _GEN_1 = mux(_T_35, _result_T_27, _GEN_0) @[Conditional.scala 39:67 Alu.scala 72:14]
    node _GEN_2 = mux(_T_32, _result_T_25, _GEN_1) @[Conditional.scala 39:67 Alu.scala 69:14]
    node _GEN_3 = mux(_T_31, _result_T_22, _GEN_2) @[Conditional.scala 39:67 Alu.scala 66:14]
    node _GEN_4 = mux(_T_28, _result_T_20, _GEN_3) @[Conditional.scala 39:67 Alu.scala 63:14]
    node _GEN_5 = mux(_T_25, _result_T_18, _GEN_4) @[Conditional.scala 39:67 Alu.scala 60:14]
    node _GEN_6 = mux(_T_22, _result_T_14, _GEN_5) @[Conditional.scala 39:67 Alu.scala 57:14]
    node _GEN_7 = mux(_T_19, _result_T_12, _GEN_6) @[Conditional.scala 39:67 Alu.scala 54:14]
    node _GEN_8 = mux(_T_16, _result_T_8, _GEN_7) @[Conditional.scala 39:67 Alu.scala 51:14]
    node _GEN_9 = mux(_T_13, _result_T_6, _GEN_8) @[Conditional.scala 39:67 Alu.scala 48:14]
    node _GEN_10 = mux(_T_10, _result_T_2, _GEN_9) @[Conditional.scala 40:58 Alu.scala 45:14]
    node result = asSInt(bits(_GEN_10, 31, 0))
    io_out <= result @[Alu.scala 79:10]

  module Branch :
    input clock : Clock
    input reset : UInt<1>
    input io_fnct3 : UInt<3>
    input io_branch : UInt<1>
    input io_arg_x : SInt<32>
    input io_arg_y : SInt<32>
    output io_br_taken : UInt<1>

    node _T = eq(io_fnct3, UInt<1>("h0")) @[BRANCH.scala 17:19]
    node _io_br_taken_T = eq(io_arg_x, io_arg_y) @[BRANCH.scala 18:31]
    node _T_1 = eq(io_fnct3, UInt<1>("h1")) @[BRANCH.scala 21:24]
    node _io_br_taken_T_1 = neq(io_arg_x, io_arg_y) @[BRANCH.scala 22:31]
    node _T_2 = eq(io_fnct3, UInt<3>("h4")) @[BRANCH.scala 25:24]
    node _io_br_taken_T_2 = lt(io_arg_x, io_arg_y) @[BRANCH.scala 26:31]
    node _T_3 = eq(io_fnct3, UInt<3>("h5")) @[BRANCH.scala 29:24]
    node _io_br_taken_T_3 = geq(io_arg_x, io_arg_y) @[BRANCH.scala 30:31]
    node _T_4 = eq(io_fnct3, UInt<3>("h6")) @[BRANCH.scala 33:24]
    node _io_br_taken_T_4 = asUInt(io_arg_x) @[BRANCH.scala 34:31]
    node _io_br_taken_T_5 = asUInt(io_arg_y) @[BRANCH.scala 34:49]
    node _io_br_taken_T_6 = lt(_io_br_taken_T_4, _io_br_taken_T_5) @[BRANCH.scala 34:38]
    node _T_5 = eq(io_fnct3, UInt<3>("h7")) @[BRANCH.scala 37:24]
    node _io_br_taken_T_7 = asUInt(io_arg_x) @[BRANCH.scala 38:31]
    node _io_br_taken_T_8 = asUInt(io_arg_y) @[BRANCH.scala 38:50]
    node _io_br_taken_T_9 = geq(_io_br_taken_T_7, _io_br_taken_T_8) @[BRANCH.scala 38:38]
    node _GEN_0 = mux(_T_5, _io_br_taken_T_9, UInt<1>("h0")) @[BRANCH.scala 37:33 BRANCH.scala 38:19 BRANCH.scala 13:15]
    node _GEN_1 = mux(_T_4, _io_br_taken_T_6, _GEN_0) @[BRANCH.scala 33:33 BRANCH.scala 34:19]
    node _GEN_2 = mux(_T_3, _io_br_taken_T_3, _GEN_1) @[BRANCH.scala 29:33 BRANCH.scala 30:19]
    node _GEN_3 = mux(_T_2, _io_br_taken_T_2, _GEN_2) @[BRANCH.scala 25:33 BRANCH.scala 26:19]
    node _GEN_4 = mux(_T_1, _io_br_taken_T_1, _GEN_3) @[BRANCH.scala 21:33 BRANCH.scala 22:19]
    node _GEN_5 = mux(_T, _io_br_taken_T, _GEN_4) @[BRANCH.scala 17:28 BRANCH.scala 18:19]
    node _GEN_6 = mux(io_branch, _GEN_5, UInt<1>("h0")) @[BRANCH.scala 15:19 BRANCH.scala 13:15]
    io_br_taken <= _GEN_6

  module DataMem1 :
    input clock : Clock
    input reset : UInt<1>
    input io_addr : UInt<32>
    input io_dataIn : SInt<32>
    input io_mem_read : UInt<1>
    input io_mem_write : UInt<1>
    output io_dataOut : SInt<32>

    mem imem1 : @[DATAmem.scala 13:17]
      data-type => SInt<32>
      depth => 1024
      read-latency => 0
      write-latency => 1
      reader => io_dataOut_MPORT
      writer => MPORT
      read-under-write => undefined
    node _T = eq(io_mem_write, UInt<1>("h1")) @[DATAmem.scala 17:21]
    node _T_1 = bits(io_addr, 9, 0)
    node _GEN_0 = validif(_T, _T_1) @[DATAmem.scala 17:30]
    node _GEN_1 = validif(_T, clock) @[DATAmem.scala 17:30]
    node _GEN_2 = mux(_T, UInt<1>("h1"), UInt<1>("h0")) @[DATAmem.scala 17:30 DATAmem.scala 13:17]
    node _GEN_3 = validif(_T, UInt<1>("h1")) @[DATAmem.scala 17:30]
    node _GEN_4 = validif(_T, io_dataIn) @[DATAmem.scala 17:30]
    node _T_2 = eq(io_mem_read, UInt<1>("h1")) @[DATAmem.scala 21:20]
    node _io_dataOut_T = bits(io_addr, 9, 0) @[DATAmem.scala 22:30]
    node _GEN_5 = validif(_T_2, _io_dataOut_T) @[DATAmem.scala 21:30 DATAmem.scala 22:30]
    node _GEN_6 = validif(_T_2, clock) @[DATAmem.scala 21:30 DATAmem.scala 22:30]
    node _GEN_7 = mux(_T_2, UInt<1>("h1"), UInt<1>("h0")) @[DATAmem.scala 21:30 DATAmem.scala 22:30 DATAmem.scala 13:17]
    node _GEN_8 = mux(_T_2, imem1.io_dataOut_MPORT.data, asSInt(UInt<1>("h0"))) @[DATAmem.scala 21:30 DATAmem.scala 22:16 DATAmem.scala 15:12]
    io_dataOut <= _GEN_8
    imem1.io_dataOut_MPORT.addr <= _GEN_5
    imem1.io_dataOut_MPORT.en <= _GEN_7
    imem1.io_dataOut_MPORT.clk <= _GEN_6
    imem1.MPORT.addr <= _GEN_0
    imem1.MPORT.en <= _GEN_2
    imem1.MPORT.clk <= _GEN_1
    imem1.MPORT.data <= _GEN_4
    imem1.MPORT.mask <= _GEN_3

  module Jalr :
    input clock : Clock
    input reset : UInt<1>
    input io_imme : UInt<32>
    input io_rdata1 : UInt<32>
    output io_out : UInt<32>

    node _computedAddr_T = add(io_imme, io_rdata1) @[JALR.scala 12:30]
    node computedAddr = tail(_computedAddr_T, 1) @[JALR.scala 12:30]
    node _io_out_T = and(computedAddr, UInt<32>("hfffffffe")) @[JALR.scala 15:26]
    io_out <= _io_out_T @[JALR.scala 15:10]

  module IF_ID :
    input clock : Clock
    input reset : UInt<1>
    input io_pc_in : SInt<32>
    input io_pc4_in : UInt<32>
    input io_mux_f_pc_in : SInt<32>
    input io_mux_g_inst_in : UInt<32>
    output io_pc_out : SInt<32>
    output io_pc4_out : UInt<32>
    output io_mux_f_pc_out : SInt<32>
    output io_mux_g_inst_out : UInt<32>

    reg pc_in_reg : SInt<32>, clock with :
      reset => (UInt<1>("h0"), pc_in_reg) @[IFI_D.scala 19:25]
    reg pc4_reg : UInt<32>, clock with :
      reset => (UInt<1>("h0"), pc4_reg) @[IFI_D.scala 20:23]
    reg mux_f_reg : SInt<32>, clock with :
      reset => (UInt<1>("h0"), mux_f_reg) @[IFI_D.scala 21:25]
    reg mux_g_reg : UInt<32>, clock with :
      reset => (UInt<1>("h0"), mux_g_reg) @[IFI_D.scala 22:25]
    io_pc_out <= pc_in_reg @[IFI_D.scala 29:11]
    io_pc4_out <= pc4_reg @[IFI_D.scala 30:12]
    io_mux_f_pc_out <= mux_f_reg @[IFI_D.scala 31:17]
    io_mux_g_inst_out <= mux_g_reg @[IFI_D.scala 32:19]
    pc_in_reg <= mux(reset, asSInt(UInt<32>("h0")), io_pc_in) @[IFI_D.scala 19:25 IFI_D.scala 19:25 IFI_D.scala 24:11]
    pc4_reg <= mux(reset, UInt<32>("h0"), io_pc4_in) @[IFI_D.scala 20:23 IFI_D.scala 20:23 IFI_D.scala 25:9]
    mux_f_reg <= mux(reset, asSInt(UInt<32>("h0")), io_mux_f_pc_in) @[IFI_D.scala 21:25 IFI_D.scala 21:25 IFI_D.scala 26:11]
    mux_g_reg <= mux(reset, UInt<32>("h0"), io_mux_g_inst_in) @[IFI_D.scala 22:25 IFI_D.scala 22:25 IFI_D.scala 27:11]

  module ID_EX :
    input clock : Clock
    input reset : UInt<1>
    input io_rs1_in : UInt<5>
    input io_rs2_in : UInt<5>
    input io_rs1_data_in : SInt<32>
    input io_rs2_data_in : SInt<32>
    input io_imm : SInt<32>
    input io_rd_in : UInt<5>
    input io_func3_in : UInt<3>
    input io_func7_in : UInt<1>
    input io_ctrl_MemWr_in : UInt<1>
    input io_ctrl_Branch_in : UInt<1>
    input io_ctrl_MemRd_in : UInt<1>
    input io_ctrl_Reg_W_in : UInt<1>
    input io_ctrl_MemToReg_in : UInt<1>
    input io_ctrl_AluOp_in : UInt<3>
    input io_ctrl_OpA_in : UInt<2>
    input io_ctrl_OpB_in : UInt<1>
    input io_ctrl_nextpc_in : UInt<2>
    input io_IFID_pc4_in : UInt<32>
    output io_rs1_out : UInt<5>
    output io_rs2_out : UInt<5>
    output io_rs1_data_out : SInt<32>
    output io_rs2_data_out : SInt<32>
    output io_rd_out : UInt<5>
    output io_imm_out : SInt<32>
    output io_func3_out : UInt<3>
    output io_func7_out : UInt<1>
    output io_ctrl_MemWr_out : UInt<1>
    output io_ctrl_Branch_out : UInt<1>
    output io_ctrl_MemRd_out : UInt<1>
    output io_ctrl_Reg_W_out : UInt<1>
    output io_ctrl_MemToReg_out : UInt<1>
    output io_ctrl_AluOp_out : UInt<3>
    output io_ctrl_OpA_out : UInt<2>
    output io_ctrl_OpB_out : UInt<1>
    output io_ctrl_nextpc_out : UInt<2>
    output io_IFID_pc4_out : UInt<32>

    reg io_rs1_out_REG : UInt<5>, clock with :
      reset => (UInt<1>("h0"), io_rs1_out_REG) @[ID_EX.scala 47:24]
    reg io_rs2_out_REG : UInt<5>, clock with :
      reset => (UInt<1>("h0"), io_rs2_out_REG) @[ID_EX.scala 48:24]
    reg io_rs1_data_out_REG : SInt<32>, clock with :
      reset => (UInt<1>("h0"), io_rs1_data_out_REG) @[ID_EX.scala 49:29]
    reg io_rs2_data_out_REG : SInt<32>, clock with :
      reset => (UInt<1>("h0"), io_rs2_data_out_REG) @[ID_EX.scala 50:29]
    reg io_imm_out_REG : SInt<32>, clock with :
      reset => (UInt<1>("h0"), io_imm_out_REG) @[ID_EX.scala 51:24]
    reg io_rd_out_REG : UInt<5>, clock with :
      reset => (UInt<1>("h0"), io_rd_out_REG) @[ID_EX.scala 52:23]
    reg io_func3_out_REG : UInt<3>, clock with :
      reset => (UInt<1>("h0"), io_func3_out_REG) @[ID_EX.scala 53:26]
    reg io_func7_out_REG : UInt<1>, clock with :
      reset => (UInt<1>("h0"), io_func7_out_REG) @[ID_EX.scala 54:26]
    reg io_ctrl_MemWr_out_REG : UInt<1>, clock with :
      reset => (UInt<1>("h0"), io_ctrl_MemWr_out_REG) @[ID_EX.scala 55:31]
    reg io_ctrl_Branch_out_REG : UInt<1>, clock with :
      reset => (UInt<1>("h0"), io_ctrl_Branch_out_REG) @[ID_EX.scala 56:32]
    reg io_ctrl_MemRd_out_REG : UInt<1>, clock with :
      reset => (UInt<1>("h0"), io_ctrl_MemRd_out_REG) @[ID_EX.scala 57:35]
    reg io_ctrl_Reg_W_out_REG : UInt<1>, clock with :
      reset => (UInt<1>("h0"), io_ctrl_Reg_W_out_REG) @[ID_EX.scala 58:35]
    reg io_ctrl_MemToReg_out_REG : UInt<1>, clock with :
      reset => (UInt<1>("h0"), io_ctrl_MemToReg_out_REG) @[ID_EX.scala 59:35]
    reg io_ctrl_AluOp_out_REG : UInt<3>, clock with :
      reset => (UInt<1>("h0"), io_ctrl_AluOp_out_REG) @[ID_EX.scala 60:35]
    reg io_ctrl_OpA_out_REG : UInt<2>, clock with :
      reset => (UInt<1>("h0"), io_ctrl_OpA_out_REG) @[ID_EX.scala 61:35]
    reg io_ctrl_OpB_out_REG : UInt<1>, clock with :
      reset => (UInt<1>("h0"), io_ctrl_OpB_out_REG) @[ID_EX.scala 62:35]
    reg io_ctrl_nextpc_out_REG : UInt<2>, clock with :
      reset => (UInt<1>("h0"), io_ctrl_nextpc_out_REG) @[ID_EX.scala 63:35]
    reg io_IFID_pc4_out_REG : UInt<32>, clock with :
      reset => (UInt<1>("h0"), io_IFID_pc4_out_REG) @[ID_EX.scala 64:35]
    io_rs1_out <= io_rs1_out_REG @[ID_EX.scala 47:14]
    io_rs2_out <= io_rs2_out_REG @[ID_EX.scala 48:14]
    io_rs1_data_out <= io_rs1_data_out_REG @[ID_EX.scala 49:19]
    io_rs2_data_out <= io_rs2_data_out_REG @[ID_EX.scala 50:19]
    io_rd_out <= io_rd_out_REG @[ID_EX.scala 52:13]
    io_imm_out <= io_imm_out_REG @[ID_EX.scala 51:14]
    io_func3_out <= io_func3_out_REG @[ID_EX.scala 53:16]
    io_func7_out <= io_func7_out_REG @[ID_EX.scala 54:16]
    io_ctrl_MemWr_out <= io_ctrl_MemWr_out_REG @[ID_EX.scala 55:21]
    io_ctrl_Branch_out <= io_ctrl_Branch_out_REG @[ID_EX.scala 56:22]
    io_ctrl_MemRd_out <= io_ctrl_MemRd_out_REG @[ID_EX.scala 57:25]
    io_ctrl_Reg_W_out <= io_ctrl_Reg_W_out_REG @[ID_EX.scala 58:25]
    io_ctrl_MemToReg_out <= io_ctrl_MemToReg_out_REG @[ID_EX.scala 59:25]
    io_ctrl_AluOp_out <= io_ctrl_AluOp_out_REG @[ID_EX.scala 60:25]
    io_ctrl_OpA_out <= io_ctrl_OpA_out_REG @[ID_EX.scala 61:25]
    io_ctrl_OpB_out <= io_ctrl_OpB_out_REG @[ID_EX.scala 62:25]
    io_ctrl_nextpc_out <= io_ctrl_nextpc_out_REG @[ID_EX.scala 63:25]
    io_IFID_pc4_out <= io_IFID_pc4_out_REG @[ID_EX.scala 64:25]
    io_rs1_out_REG <= io_rs1_in @[ID_EX.scala 47:24]
    io_rs2_out_REG <= io_rs2_in @[ID_EX.scala 48:24]
    io_rs1_data_out_REG <= io_rs1_data_in @[ID_EX.scala 49:29]
    io_rs2_data_out_REG <= io_rs2_data_in @[ID_EX.scala 50:29]
    io_imm_out_REG <= io_imm @[ID_EX.scala 51:24]
    io_rd_out_REG <= io_rd_in @[ID_EX.scala 52:23]
    io_func3_out_REG <= io_func3_in @[ID_EX.scala 53:26]
    io_func7_out_REG <= io_func7_in @[ID_EX.scala 54:26]
    io_ctrl_MemWr_out_REG <= io_ctrl_MemWr_in @[ID_EX.scala 55:31]
    io_ctrl_Branch_out_REG <= io_ctrl_Branch_in @[ID_EX.scala 56:32]
    io_ctrl_MemRd_out_REG <= io_ctrl_MemRd_in @[ID_EX.scala 57:35]
    io_ctrl_Reg_W_out_REG <= io_ctrl_Reg_W_in @[ID_EX.scala 58:35]
    io_ctrl_MemToReg_out_REG <= io_ctrl_MemToReg_in @[ID_EX.scala 59:35]
    io_ctrl_AluOp_out_REG <= io_ctrl_AluOp_in @[ID_EX.scala 60:35]
    io_ctrl_OpA_out_REG <= io_ctrl_OpA_in @[ID_EX.scala 61:35]
    io_ctrl_OpB_out_REG <= io_ctrl_OpB_in @[ID_EX.scala 62:35]
    io_ctrl_nextpc_out_REG <= io_ctrl_nextpc_in @[ID_EX.scala 63:35]
    io_IFID_pc4_out_REG <= io_IFID_pc4_in @[ID_EX.scala 64:35]

  module EX_MEM :
    input clock : Clock
    input reset : UInt<1>
    input io_IDEX_MEMRD : UInt<1>
    input io_IDEX_MEMWR : UInt<1>
    input io_IDEX_MEMTOREG : UInt<1>
    input io_IDEX_REG_W : UInt<1>
    input io_IDEX_rs2 : SInt<32>
    input io_IDEX_rd : UInt<5>
    input io_alu_out : SInt<32>
    output io_EXMEM_memRd_out : UInt<1>
    output io_EXMEM_memWr_out : UInt<1>
    output io_EXMEM_memToReg_out : UInt<1>
    output io_EXMEM_reg_w_out : UInt<1>
    output io_EXMEM_rs2_out : SInt<32>
    output io_EXMEM_rd_out : UInt<5>
    output io_EXMEM_alu_out : SInt<32>

    reg io_EXMEM_memRd_out_REG : UInt<1>, clock with :
      reset => (UInt<1>("h0"), io_EXMEM_memRd_out_REG) @[EX_MEM.scala 25:32]
    reg io_EXMEM_memWr_out_REG : UInt<1>, clock with :
      reset => (UInt<1>("h0"), io_EXMEM_memWr_out_REG) @[EX_MEM.scala 26:32]
    reg io_EXMEM_memToReg_out_REG : UInt<1>, clock with :
      reset => (UInt<1>("h0"), io_EXMEM_memToReg_out_REG) @[EX_MEM.scala 27:35]
    reg io_EXMEM_reg_w_out_REG : UInt<1>, clock with :
      reset => (UInt<1>("h0"), io_EXMEM_reg_w_out_REG) @[EX_MEM.scala 28:32]
    reg io_EXMEM_rs2_out_REG : SInt<32>, clock with :
      reset => (UInt<1>("h0"), io_EXMEM_rs2_out_REG) @[EX_MEM.scala 29:30]
    reg io_EXMEM_rd_out_REG : UInt<5>, clock with :
      reset => (UInt<1>("h0"), io_EXMEM_rd_out_REG) @[EX_MEM.scala 30:29]
    reg io_EXMEM_alu_out_REG : SInt<32>, clock with :
      reset => (UInt<1>("h0"), io_EXMEM_alu_out_REG) @[EX_MEM.scala 31:30]
    io_EXMEM_memRd_out <= io_EXMEM_memRd_out_REG @[EX_MEM.scala 25:22]
    io_EXMEM_memWr_out <= io_EXMEM_memWr_out_REG @[EX_MEM.scala 26:22]
    io_EXMEM_memToReg_out <= io_EXMEM_memToReg_out_REG @[EX_MEM.scala 27:25]
    io_EXMEM_reg_w_out <= io_EXMEM_reg_w_out_REG @[EX_MEM.scala 28:22]
    io_EXMEM_rs2_out <= io_EXMEM_rs2_out_REG @[EX_MEM.scala 29:20]
    io_EXMEM_rd_out <= io_EXMEM_rd_out_REG @[EX_MEM.scala 30:19]
    io_EXMEM_alu_out <= io_EXMEM_alu_out_REG @[EX_MEM.scala 31:20]
    io_EXMEM_memRd_out_REG <= io_IDEX_MEMRD @[EX_MEM.scala 25:32]
    io_EXMEM_memWr_out_REG <= io_IDEX_MEMWR @[EX_MEM.scala 26:32]
    io_EXMEM_memToReg_out_REG <= io_IDEX_MEMTOREG @[EX_MEM.scala 27:35]
    io_EXMEM_reg_w_out_REG <= io_IDEX_REG_W @[EX_MEM.scala 28:32]
    io_EXMEM_rs2_out_REG <= io_IDEX_rs2 @[EX_MEM.scala 29:30]
    io_EXMEM_rd_out_REG <= io_IDEX_rd @[EX_MEM.scala 30:29]
    io_EXMEM_alu_out_REG <= io_alu_out @[EX_MEM.scala 31:30]

  module MEM_WB :
    input clock : Clock
    input reset : UInt<1>
    input io_EXMEM_MEMTOREG : UInt<1>
    input io_EXMEM_REG_W : UInt<1>
    input io_EXMEM_MEMRD : UInt<1>
    input io_EXMEM_rd : UInt<5>
    input io_in_dataMem_out : SInt<32>
    input io_in_alu_out : SInt<32>
    output io_MEMWB_memToReg_out : UInt<1>
    output io_MEMWB_reg_w_out : UInt<1>
    output io_MEMWB_memRd_out : UInt<1>
    output io_MEMWB_rd_out : UInt<5>
    output io_MEMWB_dataMem_out : SInt<32>
    output io_MEMWB_alu_out : SInt<32>

    reg io_MEMWB_memToReg_out_REG : UInt<1>, clock with :
      reset => (UInt<1>("h0"), io_MEMWB_memToReg_out_REG) @[MEM_WB.scala 24:35]
    reg io_MEMWB_reg_w_out_REG : UInt<1>, clock with :
      reset => (UInt<1>("h0"), io_MEMWB_reg_w_out_REG) @[MEM_WB.scala 25:32]
    reg io_MEMWB_memRd_out_REG : UInt<1>, clock with :
      reset => (UInt<1>("h0"), io_MEMWB_memRd_out_REG) @[MEM_WB.scala 26:32]
    reg io_MEMWB_rd_out_REG : UInt<5>, clock with :
      reset => (UInt<1>("h0"), io_MEMWB_rd_out_REG) @[MEM_WB.scala 27:29]
    reg io_MEMWB_dataMem_out_REG : SInt<32>, clock with :
      reset => (UInt<1>("h0"), io_MEMWB_dataMem_out_REG) @[MEM_WB.scala 28:34]
    reg io_MEMWB_alu_out_REG : SInt<32>, clock with :
      reset => (UInt<1>("h0"), io_MEMWB_alu_out_REG) @[MEM_WB.scala 29:30]
    io_MEMWB_memToReg_out <= io_MEMWB_memToReg_out_REG @[MEM_WB.scala 24:25]
    io_MEMWB_reg_w_out <= io_MEMWB_reg_w_out_REG @[MEM_WB.scala 25:22]
    io_MEMWB_memRd_out <= io_MEMWB_memRd_out_REG @[MEM_WB.scala 26:22]
    io_MEMWB_rd_out <= io_MEMWB_rd_out_REG @[MEM_WB.scala 27:19]
    io_MEMWB_dataMem_out <= io_MEMWB_dataMem_out_REG @[MEM_WB.scala 28:24]
    io_MEMWB_alu_out <= io_MEMWB_alu_out_REG @[MEM_WB.scala 29:20]
    io_MEMWB_memToReg_out_REG <= io_EXMEM_MEMTOREG @[MEM_WB.scala 24:35]
    io_MEMWB_reg_w_out_REG <= io_EXMEM_REG_W @[MEM_WB.scala 25:32]
    io_MEMWB_memRd_out_REG <= io_EXMEM_MEMRD @[MEM_WB.scala 26:32]
    io_MEMWB_rd_out_REG <= io_EXMEM_rd @[MEM_WB.scala 27:29]
    io_MEMWB_dataMem_out_REG <= io_in_dataMem_out @[MEM_WB.scala 28:34]
    io_MEMWB_alu_out_REG <= io_in_alu_out @[MEM_WB.scala 29:30]

  module Forwarding :
    input clock : Clock
    input reset : UInt<1>
    input io_IDEX_rs1 : UInt<5>
    input io_IDEX_rs2 : UInt<5>
    input io_EXMEM_rd : UInt<5>
    input io_EXMEM_regWr : UInt<1>
    input io_MEMWB_rd : UInt<5>
    input io_MEMWB_regWr : UInt<1>
    output io_forward_a : UInt<2>
    output io_forward_b : UInt<2>

    node _T = eq(io_EXMEM_regWr, UInt<1>("h1")) @[FORWARDdata.scala 23:21]
    node _T_1 = neq(io_EXMEM_rd, UInt<1>("h0")) @[FORWARDdata.scala 23:47]
    node _T_2 = and(_T, _T_1) @[FORWARDdata.scala 23:32]
    node _T_3 = eq(io_EXMEM_rd, io_IDEX_rs1) @[FORWARDdata.scala 24:22]
    node _T_4 = and(_T_2, _T_3) @[FORWARDdata.scala 23:62]
    node _T_5 = eq(io_EXMEM_rd, io_IDEX_rs2) @[FORWARDdata.scala 24:62]
    node _T_6 = and(_T_4, _T_5) @[FORWARDdata.scala 24:46]
    node _T_7 = eq(io_EXMEM_regWr, UInt<1>("h1")) @[FORWARDdata.scala 28:27]
    node _T_8 = neq(io_EXMEM_rd, UInt<1>("h0")) @[FORWARDdata.scala 28:53]
    node _T_9 = and(_T_7, _T_8) @[FORWARDdata.scala 28:38]
    node _T_10 = eq(io_EXMEM_rd, io_IDEX_rs2) @[FORWARDdata.scala 29:22]
    node _T_11 = and(_T_9, _T_10) @[FORWARDdata.scala 28:68]
    node _T_12 = eq(io_EXMEM_regWr, UInt<1>("h1")) @[FORWARDdata.scala 32:27]
    node _T_13 = neq(io_EXMEM_rd, UInt<1>("h0")) @[FORWARDdata.scala 32:53]
    node _T_14 = and(_T_12, _T_13) @[FORWARDdata.scala 32:38]
    node _T_15 = eq(io_EXMEM_rd, io_IDEX_rs1) @[FORWARDdata.scala 33:22]
    node _T_16 = and(_T_14, _T_15) @[FORWARDdata.scala 32:68]
    node _GEN_0 = mux(_T_16, UInt<2>("h2"), UInt<1>("h0")) @[FORWARDdata.scala 33:40 FORWARDdata.scala 34:18 FORWARDdata.scala 19:14]
    node _GEN_1 = mux(_T_11, UInt<2>("h2"), UInt<1>("h0")) @[FORWARDdata.scala 29:40 FORWARDdata.scala 30:18 FORWARDdata.scala 20:14]
    node _GEN_2 = mux(_T_11, UInt<1>("h0"), _GEN_0) @[FORWARDdata.scala 29:40 FORWARDdata.scala 19:14]
    node _GEN_3 = mux(_T_6, UInt<2>("h2"), _GEN_2) @[FORWARDdata.scala 24:80 FORWARDdata.scala 25:18]
    node _GEN_4 = mux(_T_6, UInt<2>("h2"), _GEN_1) @[FORWARDdata.scala 24:80 FORWARDdata.scala 26:18]
    node _T_17 = eq(io_MEMWB_regWr, UInt<1>("h1")) @[FORWARDdata.scala 38:22]
    node _T_18 = neq(io_MEMWB_rd, UInt<1>("h0")) @[FORWARDdata.scala 38:50]
    node _T_19 = and(_T_17, _T_18) @[FORWARDdata.scala 38:34]
    node _T_20 = eq(io_MEMWB_rd, io_IDEX_rs1) @[FORWARDdata.scala 38:82]
    node _T_21 = and(_T_19, _T_20) @[FORWARDdata.scala 38:66]
    node _T_22 = eq(io_MEMWB_rd, io_IDEX_rs2) @[FORWARDdata.scala 38:115]
    node _T_23 = and(_T_21, _T_22) @[FORWARDdata.scala 38:99]
    node _T_24 = eq(io_EXMEM_regWr, UInt<1>("h1")) @[FORWARDdata.scala 39:26]
    node _T_25 = neq(io_EXMEM_rd, UInt<1>("h0")) @[FORWARDdata.scala 39:52]
    node _T_26 = and(_T_24, _T_25) @[FORWARDdata.scala 39:37]
    node _T_27 = eq(io_EXMEM_rd, io_IDEX_rs1) @[FORWARDdata.scala 39:83]
    node _T_28 = and(_T_26, _T_27) @[FORWARDdata.scala 39:67]
    node _T_29 = eq(io_EXMEM_rd, io_IDEX_rs2) @[FORWARDdata.scala 39:116]
    node _T_30 = and(_T_28, _T_29) @[FORWARDdata.scala 39:100]
    node _T_31 = not(_T_30) @[FORWARDdata.scala 39:9]
    node _T_32 = and(_T_23, _T_31) @[FORWARDdata.scala 38:132]
    node _T_33 = eq(io_MEMWB_regWr, UInt<1>("h1")) @[FORWARDdata.scala 43:28]
    node _T_34 = neq(io_MEMWB_rd, UInt<1>("h0")) @[FORWARDdata.scala 43:56]
    node _T_35 = and(_T_33, _T_34) @[FORWARDdata.scala 43:40]
    node _T_36 = eq(io_MEMWB_rd, io_IDEX_rs2) @[FORWARDdata.scala 43:88]
    node _T_37 = and(_T_35, _T_36) @[FORWARDdata.scala 43:72]
    node _T_38 = eq(io_EXMEM_regWr, UInt<1>("h1")) @[FORWARDdata.scala 44:26]
    node _T_39 = neq(io_EXMEM_rd, UInt<1>("h0")) @[FORWARDdata.scala 44:52]
    node _T_40 = and(_T_38, _T_39) @[FORWARDdata.scala 44:37]
    node _T_41 = eq(io_EXMEM_rd, io_IDEX_rs2) @[FORWARDdata.scala 44:83]
    node _T_42 = and(_T_40, _T_41) @[FORWARDdata.scala 44:67]
    node _T_43 = not(_T_42) @[FORWARDdata.scala 44:9]
    node _T_44 = and(_T_37, _T_43) @[FORWARDdata.scala 43:105]
    node _T_45 = eq(io_MEMWB_regWr, UInt<1>("h1")) @[FORWARDdata.scala 47:28]
    node _T_46 = neq(io_MEMWB_rd, UInt<1>("h0")) @[FORWARDdata.scala 47:56]
    node _T_47 = and(_T_45, _T_46) @[FORWARDdata.scala 47:40]
    node _T_48 = eq(io_MEMWB_rd, io_IDEX_rs1) @[FORWARDdata.scala 47:88]
    node _T_49 = and(_T_47, _T_48) @[FORWARDdata.scala 47:72]
    node _T_50 = eq(io_EXMEM_regWr, UInt<1>("h1")) @[FORWARDdata.scala 48:26]
    node _T_51 = neq(io_EXMEM_rd, UInt<1>("h0")) @[FORWARDdata.scala 48:52]
    node _T_52 = and(_T_50, _T_51) @[FORWARDdata.scala 48:37]
    node _T_53 = eq(io_EXMEM_rd, io_IDEX_rs1) @[FORWARDdata.scala 48:83]
    node _T_54 = and(_T_52, _T_53) @[FORWARDdata.scala 48:67]
    node _T_55 = not(_T_54) @[FORWARDdata.scala 48:9]
    node _T_56 = and(_T_49, _T_55) @[FORWARDdata.scala 47:105]
    node _GEN_5 = mux(_T_56, UInt<1>("h1"), _GEN_3) @[FORWARDdata.scala 48:101 FORWARDdata.scala 49:18]
    node _GEN_6 = mux(_T_44, UInt<1>("h1"), _GEN_4) @[FORWARDdata.scala 44:101 FORWARDdata.scala 45:18]
    node _GEN_7 = mux(_T_44, _GEN_3, _GEN_5) @[FORWARDdata.scala 44:101]
    node _GEN_8 = mux(_T_32, UInt<1>("h1"), _GEN_7) @[FORWARDdata.scala 39:135 FORWARDdata.scala 40:18]
    node _GEN_9 = mux(_T_32, UInt<1>("h1"), _GEN_6) @[FORWARDdata.scala 39:135 FORWARDdata.scala 41:18]
    io_forward_a <= _GEN_8
    io_forward_b <= _GEN_9

  module HazardDetection :
    input clock : Clock
    input reset : UInt<1>
    input io_IF_ID_inst : UInt<32>
    input io_ID_EX_memRead : UInt<1>
    input io_ID_EX_rd : UInt<5>
    input io_pc_in : SInt<32>
    input io_current_pc : SInt<32>
    output io_inst_forward : UInt<1>
    output io_pc_forward : UInt<1>
    output io_ctrl_forward : UInt<1>
    output io_inst_out : UInt<32>
    output io_pc_out : SInt<32>
    output io_current_pc_out : SInt<32>

    node Rs1 = bits(io_IF_ID_inst, 19, 15) @[HAZARDdetection.scala 21:24]
    node Rs2 = bits(io_IF_ID_inst, 24, 20) @[HAZARDdetection.scala 22:24]
    node _T = eq(io_ID_EX_memRead, UInt<1>("h1")) @[HAZARDdetection.scala 24:23]
    node _T_1 = eq(io_ID_EX_rd, Rs1) @[HAZARDdetection.scala 24:51]
    node _T_2 = eq(io_ID_EX_rd, Rs2) @[HAZARDdetection.scala 24:76]
    node _T_3 = or(_T_1, _T_2) @[HAZARDdetection.scala 24:60]
    node _T_4 = and(_T, _T_3) @[HAZARDdetection.scala 24:34]
    node _GEN_0 = mux(_T_4, UInt<1>("h1"), UInt<1>("h0")) @[HAZARDdetection.scala 24:87 HAZARDdetection.scala 25:21 HAZARDdetection.scala 33:21]
    node _GEN_1 = mux(_T_4, io_IF_ID_inst, io_IF_ID_inst) @[HAZARDdetection.scala 24:87 HAZARDdetection.scala 28:17 HAZARDdetection.scala 36:17]
    node _GEN_2 = mux(_T_4, io_pc_in, io_pc_in) @[HAZARDdetection.scala 24:87 HAZARDdetection.scala 29:15 HAZARDdetection.scala 37:15]
    node _GEN_3 = mux(_T_4, io_current_pc, io_current_pc) @[HAZARDdetection.scala 24:87 HAZARDdetection.scala 30:23 HAZARDdetection.scala 38:23]
    io_inst_forward <= _GEN_0
    io_pc_forward <= _GEN_0
    io_ctrl_forward <= _GEN_0
    io_inst_out <= _GEN_1
    io_pc_out <= _GEN_2
    io_current_pc_out <= _GEN_3

  module BranchForward :
    input clock : Clock
    input reset : UInt<1>
    input io_ID_EX_RD : UInt<5>
    input io_EX_MEM_RD : UInt<5>
    input io_MEM_WB_RD : UInt<5>
    input io_ID_EX_memRd : UInt<1>
    input io_EX_MEM_memRd : UInt<1>
    input io_MEM_WB_memRd : UInt<1>
    input io_rs1 : UInt<5>
    input io_rs2 : UInt<5>
    input io_ctrl_branch : UInt<1>
    output io_forward_rs1 : UInt<4>
    output io_forward_rs2 : UInt<4>

    node _T = eq(io_ctrl_branch, UInt<1>("h1")) @[BRANCHforward.scala 26:21]
    node _T_1 = eq(io_ctrl_branch, UInt<1>("h1")) @[BRANCHforward.scala 28:25]
    node _T_2 = neq(io_ID_EX_RD, UInt<1>("h0")) @[BRANCHforward.scala 28:48]
    node _T_3 = and(_T_1, _T_2) @[BRANCHforward.scala 28:33]
    node _T_4 = neq(io_ID_EX_memRd, UInt<1>("h1")) @[BRANCHforward.scala 28:81]
    node _T_5 = and(_T_3, _T_4) @[BRANCHforward.scala 28:63]
    node _T_6 = eq(io_ID_EX_RD, io_rs1) @[BRANCHforward.scala 28:105]
    node _T_7 = and(_T_5, _T_6) @[BRANCHforward.scala 28:89]
    node _T_8 = eq(io_ID_EX_RD, io_rs2) @[BRANCHforward.scala 28:133]
    node _T_9 = and(_T_7, _T_8) @[BRANCHforward.scala 28:117]
    node _T_10 = eq(io_ctrl_branch, UInt<1>("h1")) @[BRANCHforward.scala 32:31]
    node _T_11 = neq(io_ID_EX_RD, UInt<1>("h0")) @[BRANCHforward.scala 32:54]
    node _T_12 = and(_T_10, _T_11) @[BRANCHforward.scala 32:39]
    node _T_13 = neq(io_ID_EX_memRd, UInt<1>("h1")) @[BRANCHforward.scala 32:87]
    node _T_14 = and(_T_12, _T_13) @[BRANCHforward.scala 32:69]
    node _T_15 = eq(io_ID_EX_RD, io_rs1) @[BRANCHforward.scala 32:111]
    node _T_16 = and(_T_14, _T_15) @[BRANCHforward.scala 32:95]
    node _T_17 = eq(io_ctrl_branch, UInt<1>("h1")) @[BRANCHforward.scala 35:31]
    node _T_18 = neq(io_ID_EX_RD, UInt<1>("h0")) @[BRANCHforward.scala 35:54]
    node _T_19 = and(_T_17, _T_18) @[BRANCHforward.scala 35:39]
    node _T_20 = neq(io_ID_EX_memRd, UInt<1>("h1")) @[BRANCHforward.scala 35:87]
    node _T_21 = and(_T_19, _T_20) @[BRANCHforward.scala 35:69]
    node _T_22 = eq(io_ID_EX_RD, io_rs2) @[BRANCHforward.scala 35:111]
    node _T_23 = and(_T_21, _T_22) @[BRANCHforward.scala 35:95]
    node _GEN_0 = mux(_T_23, UInt<1>("h1"), UInt<1>("h0")) @[BRANCHforward.scala 35:124 BRANCHforward.scala 36:24 BRANCHforward.scala 23:16]
    node _GEN_1 = mux(_T_16, UInt<1>("h1"), UInt<1>("h0")) @[BRANCHforward.scala 32:124 BRANCHforward.scala 33:24 BRANCHforward.scala 22:16]
    node _GEN_2 = mux(_T_16, UInt<1>("h0"), _GEN_0) @[BRANCHforward.scala 32:124 BRANCHforward.scala 23:16]
    node _GEN_3 = mux(_T_9, UInt<1>("h1"), _GEN_1) @[BRANCHforward.scala 28:146 BRANCHforward.scala 29:24]
    node _GEN_4 = mux(_T_9, UInt<1>("h1"), _GEN_2) @[BRANCHforward.scala 28:146 BRANCHforward.scala 30:24]
    node _T_24 = eq(io_ctrl_branch, UInt<1>("h1")) @[BRANCHforward.scala 40:25]
    node _T_25 = neq(io_EX_MEM_RD, UInt<1>("h0")) @[BRANCHforward.scala 40:49]
    node _T_26 = and(_T_24, _T_25) @[BRANCHforward.scala 40:33]
    node _T_27 = neq(io_EX_MEM_memRd, UInt<1>("h1")) @[BRANCHforward.scala 40:83]
    node _T_28 = and(_T_26, _T_27) @[BRANCHforward.scala 40:64]
    node _T_29 = eq(io_EX_MEM_RD, io_rs1) @[BRANCHforward.scala 40:108]
    node _T_30 = and(_T_28, _T_29) @[BRANCHforward.scala 40:91]
    node _T_31 = eq(io_EX_MEM_RD, io_rs2) @[BRANCHforward.scala 40:137]
    node _T_32 = and(_T_30, _T_31) @[BRANCHforward.scala 40:120]
    node _T_33 = eq(io_ctrl_branch, UInt<1>("h1")) @[BRANCHforward.scala 41:31]
    node _T_34 = neq(io_ID_EX_RD, UInt<1>("h0")) @[BRANCHforward.scala 41:59]
    node _T_35 = and(_T_33, _T_34) @[BRANCHforward.scala 41:43]
    node _T_36 = eq(io_ID_EX_RD, io_rs1) @[BRANCHforward.scala 41:91]
    node _T_37 = and(_T_35, _T_36) @[BRANCHforward.scala 41:75]
    node _T_38 = eq(io_ID_EX_RD, io_rs2) @[BRANCHforward.scala 41:119]
    node _T_39 = and(_T_37, _T_38) @[BRANCHforward.scala 41:103]
    node _T_40 = not(_T_39) @[BRANCHforward.scala 41:13]
    node _T_41 = and(_T_32, _T_40) @[BRANCHforward.scala 40:149]
    node _T_42 = eq(io_ctrl_branch, UInt<1>("h1")) @[BRANCHforward.scala 45:31]
    node _T_43 = neq(io_EX_MEM_RD, UInt<1>("h0")) @[BRANCHforward.scala 45:55]
    node _T_44 = and(_T_42, _T_43) @[BRANCHforward.scala 45:39]
    node _T_45 = neq(io_EX_MEM_memRd, UInt<1>("h1")) @[BRANCHforward.scala 45:89]
    node _T_46 = and(_T_44, _T_45) @[BRANCHforward.scala 45:70]
    node _T_47 = eq(io_EX_MEM_RD, io_rs2) @[BRANCHforward.scala 45:114]
    node _T_48 = and(_T_46, _T_47) @[BRANCHforward.scala 45:97]
    node _T_49 = eq(io_ctrl_branch, UInt<1>("h1")) @[BRANCHforward.scala 46:32]
    node _T_50 = neq(io_ID_EX_RD, UInt<1>("h0")) @[BRANCHforward.scala 46:60]
    node _T_51 = and(_T_49, _T_50) @[BRANCHforward.scala 46:44]
    node _T_52 = eq(io_ID_EX_RD, io_rs2) @[BRANCHforward.scala 46:92]
    node _T_53 = and(_T_51, _T_52) @[BRANCHforward.scala 46:76]
    node _T_54 = not(_T_53) @[BRANCHforward.scala 46:14]
    node _T_55 = and(_T_48, _T_54) @[BRANCHforward.scala 45:126]
    node _T_56 = eq(io_ctrl_branch, UInt<1>("h1")) @[BRANCHforward.scala 49:31]
    node _T_57 = neq(io_EX_MEM_RD, UInt<1>("h0")) @[BRANCHforward.scala 49:55]
    node _T_58 = and(_T_56, _T_57) @[BRANCHforward.scala 49:39]
    node _T_59 = neq(io_EX_MEM_memRd, UInt<1>("h1")) @[BRANCHforward.scala 49:89]
    node _T_60 = and(_T_58, _T_59) @[BRANCHforward.scala 49:70]
    node _T_61 = eq(io_EX_MEM_RD, io_rs1) @[BRANCHforward.scala 49:114]
    node _T_62 = and(_T_60, _T_61) @[BRANCHforward.scala 49:97]
    node _T_63 = eq(io_ctrl_branch, UInt<1>("h1")) @[BRANCHforward.scala 50:31]
    node _T_64 = neq(io_ID_EX_RD, UInt<1>("h0")) @[BRANCHforward.scala 50:59]
    node _T_65 = and(_T_63, _T_64) @[BRANCHforward.scala 50:43]
    node _T_66 = eq(io_ID_EX_RD, io_rs1) @[BRANCHforward.scala 50:91]
    node _T_67 = and(_T_65, _T_66) @[BRANCHforward.scala 50:75]
    node _T_68 = not(_T_67) @[BRANCHforward.scala 50:13]
    node _T_69 = and(_T_62, _T_68) @[BRANCHforward.scala 49:126]
    node _T_70 = eq(io_ctrl_branch, UInt<1>("h1")) @[BRANCHforward.scala 53:31]
    node _T_71 = neq(io_EX_MEM_RD, UInt<1>("h0")) @[BRANCHforward.scala 53:55]
    node _T_72 = and(_T_70, _T_71) @[BRANCHforward.scala 53:39]
    node _T_73 = eq(io_EX_MEM_memRd, UInt<1>("h1")) @[BRANCHforward.scala 53:89]
    node _T_74 = and(_T_72, _T_73) @[BRANCHforward.scala 53:70]
    node _T_75 = eq(io_EX_MEM_RD, io_rs1) @[BRANCHforward.scala 53:114]
    node _T_76 = and(_T_74, _T_75) @[BRANCHforward.scala 53:97]
    node _T_77 = eq(io_EX_MEM_RD, io_rs2) @[BRANCHforward.scala 53:143]
    node _T_78 = and(_T_76, _T_77) @[BRANCHforward.scala 53:126]
    node _T_79 = eq(io_ctrl_branch, UInt<1>("h1")) @[BRANCHforward.scala 54:31]
    node _T_80 = neq(io_ID_EX_RD, UInt<1>("h0")) @[BRANCHforward.scala 54:59]
    node _T_81 = and(_T_79, _T_80) @[BRANCHforward.scala 54:43]
    node _T_82 = eq(io_ID_EX_RD, io_rs1) @[BRANCHforward.scala 54:91]
    node _T_83 = and(_T_81, _T_82) @[BRANCHforward.scala 54:75]
    node _T_84 = eq(io_ID_EX_RD, io_rs2) @[BRANCHforward.scala 54:119]
    node _T_85 = and(_T_83, _T_84) @[BRANCHforward.scala 54:103]
    node _T_86 = not(_T_85) @[BRANCHforward.scala 54:13]
    node _T_87 = and(_T_78, _T_86) @[BRANCHforward.scala 53:155]
    node _T_88 = eq(io_ctrl_branch, UInt<1>("h1")) @[BRANCHforward.scala 58:31]
    node _T_89 = neq(io_EX_MEM_RD, UInt<1>("h0")) @[BRANCHforward.scala 58:55]
    node _T_90 = and(_T_88, _T_89) @[BRANCHforward.scala 58:39]
    node _T_91 = eq(io_EX_MEM_memRd, UInt<1>("h1")) @[BRANCHforward.scala 58:89]
    node _T_92 = and(_T_90, _T_91) @[BRANCHforward.scala 58:70]
    node _T_93 = eq(io_EX_MEM_RD, io_rs2) @[BRANCHforward.scala 58:114]
    node _T_94 = and(_T_92, _T_93) @[BRANCHforward.scala 58:97]
    node _T_95 = eq(io_ctrl_branch, UInt<1>("h1")) @[BRANCHforward.scala 59:31]
    node _T_96 = neq(io_ID_EX_RD, UInt<1>("h0")) @[BRANCHforward.scala 59:59]
    node _T_97 = and(_T_95, _T_96) @[BRANCHforward.scala 59:43]
    node _T_98 = eq(io_ID_EX_RD, io_rs2) @[BRANCHforward.scala 59:91]
    node _T_99 = and(_T_97, _T_98) @[BRANCHforward.scala 59:75]
    node _T_100 = not(_T_99) @[BRANCHforward.scala 59:13]
    node _T_101 = and(_T_94, _T_100) @[BRANCHforward.scala 58:126]
    node _T_102 = eq(io_ctrl_branch, UInt<1>("h1")) @[BRANCHforward.scala 62:31]
    node _T_103 = neq(io_EX_MEM_RD, UInt<1>("h0")) @[BRANCHforward.scala 62:55]
    node _T_104 = and(_T_102, _T_103) @[BRANCHforward.scala 62:39]
    node _T_105 = eq(io_EX_MEM_memRd, UInt<1>("h1")) @[BRANCHforward.scala 62:89]
    node _T_106 = and(_T_104, _T_105) @[BRANCHforward.scala 62:70]
    node _T_107 = eq(io_EX_MEM_RD, io_rs1) @[BRANCHforward.scala 62:114]
    node _T_108 = and(_T_106, _T_107) @[BRANCHforward.scala 62:97]
    node _T_109 = eq(io_ctrl_branch, UInt<1>("h1")) @[BRANCHforward.scala 63:31]
    node _T_110 = neq(io_ID_EX_RD, UInt<1>("h0")) @[BRANCHforward.scala 63:59]
    node _T_111 = and(_T_109, _T_110) @[BRANCHforward.scala 63:43]
    node _T_112 = eq(io_ID_EX_RD, io_rs1) @[BRANCHforward.scala 63:91]
    node _T_113 = and(_T_111, _T_112) @[BRANCHforward.scala 63:75]
    node _T_114 = not(_T_113) @[BRANCHforward.scala 63:13]
    node _T_115 = and(_T_108, _T_114) @[BRANCHforward.scala 62:126]
    node _GEN_5 = mux(_T_115, UInt<3>("h4"), _GEN_3) @[BRANCHforward.scala 63:105 BRANCHforward.scala 64:24]
    node _GEN_6 = mux(_T_101, UInt<3>("h4"), _GEN_4) @[BRANCHforward.scala 59:105 BRANCHforward.scala 60:24]
    node _GEN_7 = mux(_T_101, _GEN_3, _GEN_5) @[BRANCHforward.scala 59:105]
    node _GEN_8 = mux(_T_87, UInt<3>("h4"), _GEN_7) @[BRANCHforward.scala 54:133 BRANCHforward.scala 55:24]
    node _GEN_9 = mux(_T_87, UInt<3>("h4"), _GEN_6) @[BRANCHforward.scala 54:133 BRANCHforward.scala 56:24]
    node _GEN_10 = mux(_T_69, UInt<2>("h2"), _GEN_8) @[BRANCHforward.scala 50:105 BRANCHforward.scala 51:24]
    node _GEN_11 = mux(_T_69, _GEN_4, _GEN_9) @[BRANCHforward.scala 50:105]
    node _GEN_12 = mux(_T_55, UInt<2>("h2"), _GEN_11) @[BRANCHforward.scala 46:106 BRANCHforward.scala 47:24]
    node _GEN_13 = mux(_T_55, _GEN_3, _GEN_10) @[BRANCHforward.scala 46:106]
    node _GEN_14 = mux(_T_41, UInt<2>("h2"), _GEN_13) @[BRANCHforward.scala 41:133 BRANCHforward.scala 42:24]
    node _GEN_15 = mux(_T_41, UInt<2>("h2"), _GEN_12) @[BRANCHforward.scala 41:133 BRANCHforward.scala 43:24]
    node _T_116 = eq(io_ctrl_branch, UInt<1>("h1")) @[BRANCHforward.scala 68:25]
    node _T_117 = neq(io_MEM_WB_RD, UInt<1>("h0")) @[BRANCHforward.scala 68:49]
    node _T_118 = and(_T_116, _T_117) @[BRANCHforward.scala 68:33]
    node _T_119 = neq(io_MEM_WB_memRd, UInt<1>("h1")) @[BRANCHforward.scala 68:83]
    node _T_120 = and(_T_118, _T_119) @[BRANCHforward.scala 68:64]
    node _T_121 = eq(io_MEM_WB_RD, io_rs1) @[BRANCHforward.scala 68:108]
    node _T_122 = and(_T_120, _T_121) @[BRANCHforward.scala 68:91]
    node _T_123 = eq(io_MEM_WB_RD, io_rs2) @[BRANCHforward.scala 68:137]
    node _T_124 = and(_T_122, _T_123) @[BRANCHforward.scala 68:120]
    node _T_125 = eq(io_ctrl_branch, UInt<1>("h1")) @[BRANCHforward.scala 69:31]
    node _T_126 = neq(io_ID_EX_RD, UInt<1>("h0")) @[BRANCHforward.scala 69:59]
    node _T_127 = and(_T_125, _T_126) @[BRANCHforward.scala 69:43]
    node _T_128 = eq(io_ID_EX_RD, io_rs1) @[BRANCHforward.scala 69:91]
    node _T_129 = and(_T_127, _T_128) @[BRANCHforward.scala 69:75]
    node _T_130 = eq(io_ID_EX_RD, io_rs2) @[BRANCHforward.scala 69:119]
    node _T_131 = and(_T_129, _T_130) @[BRANCHforward.scala 69:103]
    node _T_132 = not(_T_131) @[BRANCHforward.scala 69:13]
    node _T_133 = and(_T_124, _T_132) @[BRANCHforward.scala 68:149]
    node _T_134 = eq(io_ctrl_branch, UInt<1>("h1")) @[BRANCHforward.scala 70:31]
    node _T_135 = neq(io_EX_MEM_RD, UInt<1>("h0")) @[BRANCHforward.scala 70:60]
    node _T_136 = and(_T_134, _T_135) @[BRANCHforward.scala 70:43]
    node _T_137 = eq(io_EX_MEM_RD, io_rs1) @[BRANCHforward.scala 70:93]
    node _T_138 = and(_T_136, _T_137) @[BRANCHforward.scala 70:76]
    node _T_139 = eq(io_EX_MEM_RD, io_rs2) @[BRANCHforward.scala 70:122]
    node _T_140 = and(_T_138, _T_139) @[BRANCHforward.scala 70:105]
    node _T_141 = not(_T_140) @[BRANCHforward.scala 70:13]
    node _T_142 = and(_T_133, _T_141) @[BRANCHforward.scala 69:132]
    node _T_143 = eq(io_ctrl_branch, UInt<1>("h1")) @[BRANCHforward.scala 74:31]
    node _T_144 = neq(io_MEM_WB_RD, UInt<1>("h0")) @[BRANCHforward.scala 74:55]
    node _T_145 = and(_T_143, _T_144) @[BRANCHforward.scala 74:39]
    node _T_146 = neq(io_MEM_WB_memRd, UInt<1>("h1")) @[BRANCHforward.scala 74:89]
    node _T_147 = and(_T_145, _T_146) @[BRANCHforward.scala 74:70]
    node _T_148 = eq(io_MEM_WB_RD, io_rs2) @[BRANCHforward.scala 74:114]
    node _T_149 = and(_T_147, _T_148) @[BRANCHforward.scala 74:97]
    node _T_150 = eq(io_ctrl_branch, UInt<1>("h1")) @[BRANCHforward.scala 75:31]
    node _T_151 = neq(io_ID_EX_RD, UInt<1>("h0")) @[BRANCHforward.scala 75:59]
    node _T_152 = and(_T_150, _T_151) @[BRANCHforward.scala 75:43]
    node _T_153 = eq(io_ID_EX_RD, io_rs2) @[BRANCHforward.scala 75:91]
    node _T_154 = and(_T_152, _T_153) @[BRANCHforward.scala 75:75]
    node _T_155 = not(_T_154) @[BRANCHforward.scala 75:13]
    node _T_156 = and(_T_149, _T_155) @[BRANCHforward.scala 74:126]
    node _T_157 = eq(io_ctrl_branch, UInt<1>("h1")) @[BRANCHforward.scala 76:31]
    node _T_158 = neq(io_EX_MEM_RD, UInt<1>("h0")) @[BRANCHforward.scala 76:60]
    node _T_159 = and(_T_157, _T_158) @[BRANCHforward.scala 76:43]
    node _T_160 = eq(io_EX_MEM_RD, io_rs2) @[BRANCHforward.scala 76:93]
    node _T_161 = and(_T_159, _T_160) @[BRANCHforward.scala 76:76]
    node _T_162 = not(_T_161) @[BRANCHforward.scala 76:13]
    node _T_163 = and(_T_156, _T_162) @[BRANCHforward.scala 75:104]
    node _T_164 = eq(io_ctrl_branch, UInt<1>("h1")) @[BRANCHforward.scala 79:31]
    node _T_165 = neq(io_MEM_WB_RD, UInt<1>("h0")) @[BRANCHforward.scala 79:55]
    node _T_166 = and(_T_164, _T_165) @[BRANCHforward.scala 79:39]
    node _T_167 = neq(io_MEM_WB_memRd, UInt<1>("h1")) @[BRANCHforward.scala 79:89]
    node _T_168 = and(_T_166, _T_167) @[BRANCHforward.scala 79:70]
    node _T_169 = eq(io_MEM_WB_RD, io_rs1) @[BRANCHforward.scala 79:114]
    node _T_170 = and(_T_168, _T_169) @[BRANCHforward.scala 79:97]
    node _T_171 = eq(io_ctrl_branch, UInt<1>("h1")) @[BRANCHforward.scala 80:31]
    node _T_172 = neq(io_ID_EX_RD, UInt<1>("h0")) @[BRANCHforward.scala 80:59]
    node _T_173 = and(_T_171, _T_172) @[BRANCHforward.scala 80:43]
    node _T_174 = eq(io_ID_EX_RD, io_rs1) @[BRANCHforward.scala 80:91]
    node _T_175 = and(_T_173, _T_174) @[BRANCHforward.scala 80:75]
    node _T_176 = not(_T_175) @[BRANCHforward.scala 80:13]
    node _T_177 = and(_T_170, _T_176) @[BRANCHforward.scala 79:126]
    node _T_178 = eq(io_ctrl_branch, UInt<1>("h1")) @[BRANCHforward.scala 81:31]
    node _T_179 = neq(io_EX_MEM_RD, UInt<1>("h0")) @[BRANCHforward.scala 81:60]
    node _T_180 = and(_T_178, _T_179) @[BRANCHforward.scala 81:43]
    node _T_181 = eq(io_EX_MEM_RD, io_rs1) @[BRANCHforward.scala 81:93]
    node _T_182 = and(_T_180, _T_181) @[BRANCHforward.scala 81:76]
    node _T_183 = not(_T_182) @[BRANCHforward.scala 81:13]
    node _T_184 = and(_T_177, _T_183) @[BRANCHforward.scala 80:104]
    node _T_185 = eq(io_ctrl_branch, UInt<1>("h1")) @[BRANCHforward.scala 84:31]
    node _T_186 = neq(io_MEM_WB_RD, UInt<1>("h0")) @[BRANCHforward.scala 84:55]
    node _T_187 = and(_T_185, _T_186) @[BRANCHforward.scala 84:39]
    node _T_188 = eq(io_MEM_WB_memRd, UInt<1>("h1")) @[BRANCHforward.scala 84:89]
    node _T_189 = and(_T_187, _T_188) @[BRANCHforward.scala 84:70]
    node _T_190 = eq(io_MEM_WB_RD, io_rs1) @[BRANCHforward.scala 84:114]
    node _T_191 = and(_T_189, _T_190) @[BRANCHforward.scala 84:97]
    node _T_192 = eq(io_MEM_WB_RD, io_rs2) @[BRANCHforward.scala 84:143]
    node _T_193 = and(_T_191, _T_192) @[BRANCHforward.scala 84:126]
    node _T_194 = eq(io_ctrl_branch, UInt<1>("h1")) @[BRANCHforward.scala 85:31]
    node _T_195 = neq(io_ID_EX_RD, UInt<1>("h0")) @[BRANCHforward.scala 85:59]
    node _T_196 = and(_T_194, _T_195) @[BRANCHforward.scala 85:43]
    node _T_197 = eq(io_ID_EX_RD, io_rs1) @[BRANCHforward.scala 85:91]
    node _T_198 = and(_T_196, _T_197) @[BRANCHforward.scala 85:75]
    node _T_199 = eq(io_ID_EX_RD, io_rs2) @[BRANCHforward.scala 85:119]
    node _T_200 = and(_T_198, _T_199) @[BRANCHforward.scala 85:103]
    node _T_201 = not(_T_200) @[BRANCHforward.scala 85:13]
    node _T_202 = and(_T_193, _T_201) @[BRANCHforward.scala 84:155]
    node _T_203 = eq(io_ctrl_branch, UInt<1>("h1")) @[BRANCHforward.scala 86:31]
    node _T_204 = neq(io_EX_MEM_RD, UInt<1>("h0")) @[BRANCHforward.scala 86:60]
    node _T_205 = and(_T_203, _T_204) @[BRANCHforward.scala 86:43]
    node _T_206 = eq(io_EX_MEM_RD, io_rs1) @[BRANCHforward.scala 86:93]
    node _T_207 = and(_T_205, _T_206) @[BRANCHforward.scala 86:76]
    node _T_208 = eq(io_EX_MEM_RD, io_rs2) @[BRANCHforward.scala 86:122]
    node _T_209 = and(_T_207, _T_208) @[BRANCHforward.scala 86:105]
    node _T_210 = not(_T_209) @[BRANCHforward.scala 86:13]
    node _T_211 = and(_T_202, _T_210) @[BRANCHforward.scala 85:132]
    node _T_212 = eq(io_ctrl_branch, UInt<1>("h1")) @[BRANCHforward.scala 90:31]
    node _T_213 = neq(io_MEM_WB_RD, UInt<1>("h0")) @[BRANCHforward.scala 90:55]
    node _T_214 = and(_T_212, _T_213) @[BRANCHforward.scala 90:39]
    node _T_215 = eq(io_MEM_WB_memRd, UInt<1>("h1")) @[BRANCHforward.scala 90:89]
    node _T_216 = and(_T_214, _T_215) @[BRANCHforward.scala 90:70]
    node _T_217 = eq(io_MEM_WB_RD, io_rs2) @[BRANCHforward.scala 90:114]
    node _T_218 = and(_T_216, _T_217) @[BRANCHforward.scala 90:97]
    node _T_219 = eq(io_ctrl_branch, UInt<1>("h1")) @[BRANCHforward.scala 91:31]
    node _T_220 = neq(io_ID_EX_RD, UInt<1>("h0")) @[BRANCHforward.scala 91:59]
    node _T_221 = and(_T_219, _T_220) @[BRANCHforward.scala 91:43]
    node _T_222 = eq(io_ID_EX_RD, io_rs2) @[BRANCHforward.scala 91:91]
    node _T_223 = and(_T_221, _T_222) @[BRANCHforward.scala 91:75]
    node _T_224 = not(_T_223) @[BRANCHforward.scala 91:13]
    node _T_225 = and(_T_218, _T_224) @[BRANCHforward.scala 90:126]
    node _T_226 = eq(io_ctrl_branch, UInt<1>("h1")) @[BRANCHforward.scala 92:31]
    node _T_227 = neq(io_EX_MEM_RD, UInt<1>("h0")) @[BRANCHforward.scala 92:60]
    node _T_228 = and(_T_226, _T_227) @[BRANCHforward.scala 92:43]
    node _T_229 = eq(io_EX_MEM_RD, io_rs2) @[BRANCHforward.scala 92:93]
    node _T_230 = and(_T_228, _T_229) @[BRANCHforward.scala 92:76]
    node _T_231 = not(_T_230) @[BRANCHforward.scala 92:13]
    node _T_232 = and(_T_225, _T_231) @[BRANCHforward.scala 91:104]
    node _T_233 = eq(io_ctrl_branch, UInt<1>("h1")) @[BRANCHforward.scala 95:31]
    node _T_234 = neq(io_MEM_WB_RD, UInt<1>("h0")) @[BRANCHforward.scala 95:55]
    node _T_235 = and(_T_233, _T_234) @[BRANCHforward.scala 95:39]
    node _T_236 = eq(io_MEM_WB_memRd, UInt<1>("h1")) @[BRANCHforward.scala 95:89]
    node _T_237 = and(_T_235, _T_236) @[BRANCHforward.scala 95:70]
    node _T_238 = eq(io_MEM_WB_RD, io_rs1) @[BRANCHforward.scala 95:114]
    node _T_239 = and(_T_237, _T_238) @[BRANCHforward.scala 95:97]
    node _T_240 = eq(io_ctrl_branch, UInt<1>("h1")) @[BRANCHforward.scala 96:31]
    node _T_241 = neq(io_ID_EX_RD, UInt<1>("h0")) @[BRANCHforward.scala 96:59]
    node _T_242 = and(_T_240, _T_241) @[BRANCHforward.scala 96:43]
    node _T_243 = eq(io_ID_EX_RD, io_rs1) @[BRANCHforward.scala 96:91]
    node _T_244 = and(_T_242, _T_243) @[BRANCHforward.scala 96:75]
    node _T_245 = not(_T_244) @[BRANCHforward.scala 96:13]
    node _T_246 = and(_T_239, _T_245) @[BRANCHforward.scala 95:126]
    node _T_247 = eq(io_ctrl_branch, UInt<1>("h1")) @[BRANCHforward.scala 97:31]
    node _T_248 = neq(io_EX_MEM_RD, UInt<1>("h0")) @[BRANCHforward.scala 97:60]
    node _T_249 = and(_T_247, _T_248) @[BRANCHforward.scala 97:43]
    node _T_250 = eq(io_EX_MEM_RD, io_rs1) @[BRANCHforward.scala 97:93]
    node _T_251 = and(_T_249, _T_250) @[BRANCHforward.scala 97:76]
    node _T_252 = not(_T_251) @[BRANCHforward.scala 97:13]
    node _T_253 = and(_T_246, _T_252) @[BRANCHforward.scala 96:104]
    node _GEN_16 = mux(_T_253, UInt<3>("h5"), _GEN_14) @[BRANCHforward.scala 97:107 BRANCHforward.scala 98:24]
    node _GEN_17 = mux(_T_232, UInt<3>("h5"), _GEN_15) @[BRANCHforward.scala 92:107 BRANCHforward.scala 93:24]
    node _GEN_18 = mux(_T_232, _GEN_14, _GEN_16) @[BRANCHforward.scala 92:107]
    node _GEN_19 = mux(_T_211, UInt<3>("h5"), _GEN_18) @[BRANCHforward.scala 86:136 BRANCHforward.scala 87:24]
    node _GEN_20 = mux(_T_211, UInt<3>("h5"), _GEN_17) @[BRANCHforward.scala 86:136 BRANCHforward.scala 88:24]
    node _GEN_21 = mux(_T_184, UInt<2>("h3"), _GEN_19) @[BRANCHforward.scala 81:107 BRANCHforward.scala 82:24]
    node _GEN_22 = mux(_T_184, _GEN_15, _GEN_20) @[BRANCHforward.scala 81:107]
    node _GEN_23 = mux(_T_163, UInt<2>("h3"), _GEN_22) @[BRANCHforward.scala 76:107 BRANCHforward.scala 77:24]
    node _GEN_24 = mux(_T_163, _GEN_14, _GEN_21) @[BRANCHforward.scala 76:107]
    node _GEN_25 = mux(_T_142, UInt<2>("h3"), _GEN_24) @[BRANCHforward.scala 70:136 BRANCHforward.scala 71:24]
    node _GEN_26 = mux(_T_142, UInt<2>("h3"), _GEN_23) @[BRANCHforward.scala 70:136 BRANCHforward.scala 72:24]
    node _T_254 = eq(io_ctrl_branch, UInt<1>("h0")) @[BRANCHforward.scala 102:27]
    node _T_255 = neq(io_ID_EX_RD, UInt<1>("h0")) @[BRANCHforward.scala 104:22]
    node _T_256 = neq(io_ID_EX_memRd, UInt<1>("h1")) @[BRANCHforward.scala 104:55]
    node _T_257 = and(_T_255, _T_256) @[BRANCHforward.scala 104:37]
    node _T_258 = eq(io_ID_EX_RD, io_rs1) @[BRANCHforward.scala 104:79]
    node _T_259 = and(_T_257, _T_258) @[BRANCHforward.scala 104:63]
    node _GEN_27 = mux(_T_259, UInt<3>("h6"), UInt<1>("h0")) @[BRANCHforward.scala 104:92 BRANCHforward.scala 105:24 BRANCHforward.scala 22:16]
    node _T_260 = neq(io_EX_MEM_RD, UInt<1>("h0")) @[BRANCHforward.scala 109:23]
    node _T_261 = neq(io_EX_MEM_memRd, UInt<1>("h1")) @[BRANCHforward.scala 109:57]
    node _T_262 = and(_T_260, _T_261) @[BRANCHforward.scala 109:38]
    node _T_263 = eq(io_EX_MEM_RD, io_rs1) @[BRANCHforward.scala 109:82]
    node _T_264 = and(_T_262, _T_263) @[BRANCHforward.scala 109:65]
    node _T_265 = neq(io_ID_EX_RD, UInt<1>("h0")) @[BRANCHforward.scala 110:26]
    node _T_266 = eq(io_ID_EX_RD, io_rs1) @[BRANCHforward.scala 110:58]
    node _T_267 = and(_T_265, _T_266) @[BRANCHforward.scala 110:42]
    node _T_268 = not(_T_267) @[BRANCHforward.scala 110:11]
    node _T_269 = and(_T_264, _T_268) @[BRANCHforward.scala 109:94]
    node _T_270 = neq(io_EX_MEM_RD, UInt<1>("h0")) @[BRANCHforward.scala 113:29]
    node _T_271 = eq(io_EX_MEM_memRd, UInt<1>("h1")) @[BRANCHforward.scala 113:63]
    node _T_272 = and(_T_270, _T_271) @[BRANCHforward.scala 113:44]
    node _T_273 = eq(io_EX_MEM_RD, io_rs1) @[BRANCHforward.scala 113:88]
    node _T_274 = and(_T_272, _T_273) @[BRANCHforward.scala 113:71]
    node _T_275 = neq(io_ID_EX_RD, UInt<1>("h0")) @[BRANCHforward.scala 114:26]
    node _T_276 = eq(io_ID_EX_RD, io_rs1) @[BRANCHforward.scala 114:58]
    node _T_277 = and(_T_275, _T_276) @[BRANCHforward.scala 114:42]
    node _T_278 = not(_T_277) @[BRANCHforward.scala 114:11]
    node _T_279 = and(_T_274, _T_278) @[BRANCHforward.scala 113:100]
    node _GEN_28 = mux(_T_279, UInt<4>("h9"), _GEN_27) @[BRANCHforward.scala 114:72 BRANCHforward.scala 115:24]
    node _GEN_29 = mux(_T_269, UInt<3>("h7"), _GEN_28) @[BRANCHforward.scala 110:72 BRANCHforward.scala 111:24]
    node _T_280 = neq(io_MEM_WB_RD, UInt<1>("h0")) @[BRANCHforward.scala 119:23]
    node _T_281 = neq(io_MEM_WB_memRd, UInt<1>("h1")) @[BRANCHforward.scala 119:57]
    node _T_282 = and(_T_280, _T_281) @[BRANCHforward.scala 119:38]
    node _T_283 = eq(io_MEM_WB_RD, io_rs1) @[BRANCHforward.scala 119:82]
    node _T_284 = and(_T_282, _T_283) @[BRANCHforward.scala 119:65]
    node _T_285 = neq(io_ID_EX_RD, UInt<1>("h0")) @[BRANCHforward.scala 120:26]
    node _T_286 = eq(io_ID_EX_RD, io_rs1) @[BRANCHforward.scala 120:58]
    node _T_287 = and(_T_285, _T_286) @[BRANCHforward.scala 120:42]
    node _T_288 = not(_T_287) @[BRANCHforward.scala 120:11]
    node _T_289 = and(_T_284, _T_288) @[BRANCHforward.scala 119:94]
    node _T_290 = neq(io_EX_MEM_RD, UInt<1>("h0")) @[BRANCHforward.scala 121:27]
    node _T_291 = eq(io_EX_MEM_RD, io_rs1) @[BRANCHforward.scala 121:60]
    node _T_292 = and(_T_290, _T_291) @[BRANCHforward.scala 121:43]
    node _T_293 = not(_T_292) @[BRANCHforward.scala 121:11]
    node _T_294 = and(_T_289, _T_293) @[BRANCHforward.scala 120:71]
    node _T_295 = neq(io_MEM_WB_RD, UInt<1>("h0")) @[BRANCHforward.scala 124:29]
    node _T_296 = eq(io_MEM_WB_memRd, UInt<1>("h1")) @[BRANCHforward.scala 124:63]
    node _T_297 = and(_T_295, _T_296) @[BRANCHforward.scala 124:44]
    node _T_298 = eq(io_MEM_WB_RD, io_rs1) @[BRANCHforward.scala 124:88]
    node _T_299 = and(_T_297, _T_298) @[BRANCHforward.scala 124:71]
    node _T_300 = neq(io_ID_EX_RD, UInt<1>("h0")) @[BRANCHforward.scala 125:26]
    node _T_301 = eq(io_ID_EX_RD, io_rs1) @[BRANCHforward.scala 125:58]
    node _T_302 = and(_T_300, _T_301) @[BRANCHforward.scala 125:42]
    node _T_303 = not(_T_302) @[BRANCHforward.scala 125:11]
    node _T_304 = and(_T_299, _T_303) @[BRANCHforward.scala 124:100]
    node _T_305 = neq(io_EX_MEM_RD, UInt<1>("h0")) @[BRANCHforward.scala 126:27]
    node _T_306 = eq(io_EX_MEM_RD, io_rs1) @[BRANCHforward.scala 126:60]
    node _T_307 = and(_T_305, _T_306) @[BRANCHforward.scala 126:43]
    node _T_308 = not(_T_307) @[BRANCHforward.scala 126:11]
    node _T_309 = and(_T_304, _T_308) @[BRANCHforward.scala 125:71]
    node _GEN_30 = mux(_T_309, UInt<4>("ha"), _GEN_29) @[BRANCHforward.scala 126:74 BRANCHforward.scala 127:24]
    node _GEN_31 = mux(_T_294, UInt<4>("h8"), _GEN_30) @[BRANCHforward.scala 121:74 BRANCHforward.scala 122:24]
    node _GEN_32 = mux(_T_254, _GEN_31, UInt<1>("h0")) @[BRANCHforward.scala 102:36 BRANCHforward.scala 22:16]
    node _GEN_33 = mux(_T, _GEN_25, _GEN_32) @[BRANCHforward.scala 26:30]
    node _GEN_34 = mux(_T, _GEN_26, UInt<1>("h0")) @[BRANCHforward.scala 26:30 BRANCHforward.scala 23:16]
    io_forward_rs1 <= _GEN_33
    io_forward_rs2 <= _GEN_34

  module StructuralHazard :
    input clock : Clock
    input reset : UInt<1>
    input io_rs1 : UInt<5>
    input io_rs2 : UInt<5>
    input io_MEM_WB_regWr : UInt<1>
    input io_MEM_WB_Rd : UInt<5>
    output io_fwd_rs1 : UInt<1>
    output io_fwd_rs2 : UInt<1>

    node _T = eq(io_MEM_WB_regWr, UInt<1>("h1")) @[STRUCTURALhazard.scala 16:22]
    node _T_1 = eq(io_MEM_WB_Rd, io_rs1) @[STRUCTURALhazard.scala 16:47]
    node _T_2 = and(_T, _T_1) @[STRUCTURALhazard.scala 16:30]
    node _GEN_0 = mux(_T_2, UInt<1>("h1"), UInt<1>("h0")) @[STRUCTURALhazard.scala 16:59 STRUCTURALhazard.scala 17:16 STRUCTURALhazard.scala 19:16]
    node _T_3 = eq(io_MEM_WB_regWr, UInt<1>("h1")) @[STRUCTURALhazard.scala 22:22]
    node _T_4 = eq(io_MEM_WB_Rd, io_rs2) @[STRUCTURALhazard.scala 22:46]
    node _T_5 = and(_T_3, _T_4) @[STRUCTURALhazard.scala 22:30]
    node _GEN_1 = mux(_T_5, UInt<1>("h1"), UInt<1>("h0")) @[STRUCTURALhazard.scala 22:58 STRUCTURALhazard.scala 23:16 STRUCTURALhazard.scala 25:16]
    io_fwd_rs1 <= _GEN_0
    io_fwd_rs2 <= _GEN_1

  module PIPELINE :
    input clock : Clock
    input reset : UInt<1>
    output io_out : SInt<4>

    inst PC of PC @[Main.scala 9:20]
    inst PC4 of PC4 @[Main.scala 10:21]
    inst InstMemory of InstMem @[Main.scala 11:29]
    inst control_module of Control @[Main.scala 12:32]
    inst ImmGen of ImmGenerator @[Main.scala 13:25]
    inst RegFile of RegisterFile @[Main.scala 14:25]
    inst ALU_Control of AluControl @[Main.scala 15:29]
    inst ALU of ALU @[Main.scala 17:21]
    inst Branch_M of Branch @[Main.scala 19:26]
    inst DataMemory of DataMem1 @[Main.scala 21:28]
    inst JALR of Jalr @[Main.scala 22:22]
    inst IF_ID_M of IF_ID @[Main.scala 24:25]
    inst ID_EX_M of ID_EX @[Main.scala 25:25]
    inst EX_MEM_M of EX_MEM @[Main.scala 26:26]
    inst MEM_WB_M of MEM_WB @[Main.scala 27:26]
    inst Forwarding of Forwarding @[Main.scala 29:28]
    inst HazardDetect of HazardDetection @[Main.scala 30:30]
    inst Branch_Forward of BranchForward @[Main.scala 31:32]
    inst Structural of StructuralHazard @[Main.scala 32:28]
    node _PC_F_T = asSInt(PC4.io_out) @[Main.scala 36:29]
    node _PC_F_T_1 = eq(UInt<1>("h1"), HazardDetect.io_pc_forward) @[Mux.scala 80:60]
    node PC_F = mux(_PC_F_T_1, HazardDetect.io_pc_out, _PC_F_T) @[Mux.scala 80:57]
    node _PC4_io_pc_T = asUInt(PC.io_out) @[Main.scala 40:28]
    node _InstMemory_io_addr_T = bits(PC.io_out, 21, 2) @[Main.scala 41:36]
    node _PC_for_T = eq(UInt<1>("h1"), HazardDetect.io_inst_forward) @[Mux.scala 80:60]
    node PC_for = mux(_PC_for_T, HazardDetect.io_current_pc_out, PC.io_out) @[Mux.scala 80:57]
    node _Instruction_F_T = eq(UInt<1>("h1"), HazardDetect.io_inst_forward) @[Mux.scala 80:60]
    node Instruction_F = mux(_Instruction_F_T, HazardDetect.io_inst_out, InstMemory.io_data) @[Mux.scala 80:57]
    node _ImmGen_io_pc_T = asUInt(IF_ID_M.io_mux_f_pc_out) @[Main.scala 60:45]
    node _control_module_io_opcode_T = bits(IF_ID_M.io_mux_g_inst_out, 6, 0) @[Main.scala 63:58]
    node _RegFile_io_rs1_T = eq(control_module.io_opcode, UInt<6>("h33")) @[Main.scala 66:30]
    node _RegFile_io_rs1_T_1 = eq(control_module.io_opcode, UInt<5>("h13")) @[Main.scala 67:30]
    node _RegFile_io_rs1_T_2 = or(_RegFile_io_rs1_T, _RegFile_io_rs1_T_1) @[Main.scala 66:39]
    node _RegFile_io_rs1_T_3 = eq(control_module.io_opcode, UInt<6>("h23")) @[Main.scala 68:30]
    node _RegFile_io_rs1_T_4 = or(_RegFile_io_rs1_T_2, _RegFile_io_rs1_T_3) @[Main.scala 67:39]
    node _RegFile_io_rs1_T_5 = eq(control_module.io_opcode, UInt<2>("h3")) @[Main.scala 69:30]
    node _RegFile_io_rs1_T_6 = or(_RegFile_io_rs1_T_4, _RegFile_io_rs1_T_5) @[Main.scala 68:39]
    node _RegFile_io_rs1_T_7 = eq(control_module.io_opcode, UInt<7>("h63")) @[Main.scala 70:30]
    node _RegFile_io_rs1_T_8 = or(_RegFile_io_rs1_T_6, _RegFile_io_rs1_T_7) @[Main.scala 69:38]
    node _RegFile_io_rs1_T_9 = eq(control_module.io_opcode, UInt<7>("h67")) @[Main.scala 71:30]
    node _RegFile_io_rs1_T_10 = or(_RegFile_io_rs1_T_8, _RegFile_io_rs1_T_9) @[Main.scala 70:39]
    node _RegFile_io_rs1_T_11 = bits(IF_ID_M.io_mux_g_inst_out, 19, 15) @[Main.scala 72:30]
    node _RegFile_io_rs1_T_12 = mux(_RegFile_io_rs1_T_10, _RegFile_io_rs1_T_11, UInt<1>("h0")) @[Main.scala 65:26]
    node _RegFile_io_rs2_T = eq(control_module.io_opcode, UInt<6>("h33")) @[Main.scala 75:30]
    node _RegFile_io_rs2_T_1 = eq(control_module.io_opcode, UInt<6>("h23")) @[Main.scala 76:30]
    node _RegFile_io_rs2_T_2 = or(_RegFile_io_rs2_T, _RegFile_io_rs2_T_1) @[Main.scala 75:39]
    node _RegFile_io_rs2_T_3 = eq(control_module.io_opcode, UInt<7>("h63")) @[Main.scala 77:30]
    node _RegFile_io_rs2_T_4 = or(_RegFile_io_rs2_T_2, _RegFile_io_rs2_T_3) @[Main.scala 76:39]
    node _RegFile_io_rs2_T_5 = bits(IF_ID_M.io_mux_g_inst_out, 24, 20) @[Main.scala 78:30]
    node _RegFile_io_rs2_T_6 = mux(_RegFile_io_rs2_T_4, _RegFile_io_rs2_T_5, UInt<1>("h0")) @[Main.scala 74:26]
    node _ImmValue_T = eq(UInt<1>("h0"), control_module.io_extend) @[Mux.scala 80:60]
    node _ImmValue_T_1 = mux(_ImmValue_T, ImmGen.io_I_type, asSInt(UInt<1>("h0"))) @[Mux.scala 80:57]
    node _ImmValue_T_2 = eq(UInt<1>("h1"), control_module.io_extend) @[Mux.scala 80:60]
    node _ImmValue_T_3 = mux(_ImmValue_T_2, ImmGen.io_S_type, _ImmValue_T_1) @[Mux.scala 80:57]
    node _ImmValue_T_4 = eq(UInt<2>("h2"), control_module.io_extend) @[Mux.scala 80:60]
    node ImmValue = mux(_ImmValue_T_4, ImmGen.io_U_type, _ImmValue_T_3) @[Mux.scala 80:57]
    node _Structural_io_rs1_T = bits(IF_ID_M.io_mux_g_inst_out, 19, 15) @[Main.scala 86:51]
    node _Structural_io_rs2_T = bits(IF_ID_M.io_mux_g_inst_out, 24, 20) @[Main.scala 87:51]
    node _T = eq(Structural.io_fwd_rs1, UInt<1>("h0")) @[Main.scala 95:33]
    node _T_1 = eq(Structural.io_fwd_rs1, UInt<1>("h1")) @[Main.scala 97:39]
    node _GEN_0 = mux(_T_1, RegFile.io_w_data, asSInt(UInt<1>("h0"))) @[Main.scala 97:48 Main.scala 98:19 Main.scala 100:19]
    node _GEN_1 = mux(_T, RegFile.io_rdata1, _GEN_0) @[Main.scala 95:42 Main.scala 96:19]
    node _T_2 = eq(Structural.io_fwd_rs2, UInt<1>("h0")) @[Main.scala 104:33]
    node _T_3 = eq(Structural.io_fwd_rs2, UInt<1>("h1")) @[Main.scala 106:39]
    node _GEN_2 = mux(_T_3, RegFile.io_w_data, asSInt(UInt<1>("h0"))) @[Main.scala 106:48 Main.scala 107:19 Main.scala 109:19]
    node _GEN_3 = mux(_T_2, RegFile.io_rdata2, _GEN_2) @[Main.scala 104:42 Main.scala 105:19]
    node _T_4 = eq(HazardDetect.io_ctrl_forward, UInt<1>("h1")) @[Main.scala 115:39]
    node _GEN_4 = mux(_T_4, UInt<1>("h0"), control_module.io_mem_write) @[Main.scala 115:51 Main.scala 116:34 Main.scala 125:34]
    node _GEN_5 = mux(_T_4, UInt<1>("h0"), control_module.io_mem_read) @[Main.scala 115:51 Main.scala 117:34 Main.scala 126:34]
    node _GEN_6 = mux(_T_4, UInt<1>("h0"), control_module.io_men_to_reg) @[Main.scala 115:51 Main.scala 118:37 Main.scala 127:37]
    node _GEN_7 = mux(_T_4, UInt<1>("h0"), control_module.io_reg_write) @[Main.scala 115:51 Main.scala 119:34 Main.scala 128:34]
    node _GEN_8 = mux(_T_4, UInt<1>("h0"), control_module.io_alu_operation) @[Main.scala 115:51 Main.scala 120:34 Main.scala 129:34]
    node _GEN_9 = mux(_T_4, UInt<1>("h0"), control_module.io_operand_B) @[Main.scala 115:51 Main.scala 121:32 Main.scala 130:32]
    node _GEN_10 = mux(_T_4, UInt<1>("h0"), control_module.io_branch) @[Main.scala 115:51 Main.scala 122:35 Main.scala 131:35]
    node _GEN_11 = mux(_T_4, UInt<1>("h0"), control_module.io_next_pc_sel) @[Main.scala 115:51 Main.scala 123:35 Main.scala 132:35]
    node _HazardDetect_io_pc_in_T = asSInt(IF_ID_M.io_pc4_out) @[Main.scala 138:49]
    node _Branch_Forward_io_rs1_T = bits(IF_ID_M.io_mux_g_inst_out, 19, 15) @[Main.scala 149:55]
    node _Branch_Forward_io_rs2_T = bits(IF_ID_M.io_mux_g_inst_out, 24, 20) @[Main.scala 150:55]
    node _Branch_M_io_arg_x_T = eq(UInt<1>("h0"), Branch_Forward.io_forward_rs1) @[Mux.scala 80:60]
    node _Branch_M_io_arg_x_T_1 = mux(_Branch_M_io_arg_x_T, RegFile.io_rdata1, asSInt(UInt<1>("h0"))) @[Mux.scala 80:57]
    node _Branch_M_io_arg_x_T_2 = eq(UInt<1>("h1"), Branch_Forward.io_forward_rs1) @[Mux.scala 80:60]
    node _Branch_M_io_arg_x_T_3 = mux(_Branch_M_io_arg_x_T_2, ALU.io_out, _Branch_M_io_arg_x_T_1) @[Mux.scala 80:57]
    node _Branch_M_io_arg_x_T_4 = eq(UInt<2>("h2"), Branch_Forward.io_forward_rs1) @[Mux.scala 80:60]
    node _Branch_M_io_arg_x_T_5 = mux(_Branch_M_io_arg_x_T_4, EX_MEM_M.io_EXMEM_alu_out, _Branch_M_io_arg_x_T_3) @[Mux.scala 80:57]
    node _Branch_M_io_arg_x_T_6 = eq(UInt<2>("h3"), Branch_Forward.io_forward_rs1) @[Mux.scala 80:60]
    node _Branch_M_io_arg_x_T_7 = mux(_Branch_M_io_arg_x_T_6, RegFile.io_w_data, _Branch_M_io_arg_x_T_5) @[Mux.scala 80:57]
    node _Branch_M_io_arg_x_T_8 = eq(UInt<3>("h4"), Branch_Forward.io_forward_rs1) @[Mux.scala 80:60]
    node _Branch_M_io_arg_x_T_9 = mux(_Branch_M_io_arg_x_T_8, DataMemory.io_dataOut, _Branch_M_io_arg_x_T_7) @[Mux.scala 80:57]
    node _Branch_M_io_arg_x_T_10 = eq(UInt<3>("h5"), Branch_Forward.io_forward_rs1) @[Mux.scala 80:60]
    node _Branch_M_io_arg_x_T_11 = mux(_Branch_M_io_arg_x_T_10, RegFile.io_w_data, _Branch_M_io_arg_x_T_9) @[Mux.scala 80:57]
    node _Branch_M_io_arg_x_T_12 = eq(UInt<3>("h6"), Branch_Forward.io_forward_rs1) @[Mux.scala 80:60]
    node _Branch_M_io_arg_x_T_13 = mux(_Branch_M_io_arg_x_T_12, RegFile.io_rdata1, _Branch_M_io_arg_x_T_11) @[Mux.scala 80:57]
    node _Branch_M_io_arg_x_T_14 = eq(UInt<3>("h7"), Branch_Forward.io_forward_rs1) @[Mux.scala 80:60]
    node _Branch_M_io_arg_x_T_15 = mux(_Branch_M_io_arg_x_T_14, RegFile.io_rdata1, _Branch_M_io_arg_x_T_13) @[Mux.scala 80:57]
    node _Branch_M_io_arg_x_T_16 = eq(UInt<4>("h8"), Branch_Forward.io_forward_rs1) @[Mux.scala 80:60]
    node _Branch_M_io_arg_x_T_17 = mux(_Branch_M_io_arg_x_T_16, RegFile.io_rdata1, _Branch_M_io_arg_x_T_15) @[Mux.scala 80:57]
    node _Branch_M_io_arg_x_T_18 = eq(UInt<4>("h9"), Branch_Forward.io_forward_rs1) @[Mux.scala 80:60]
    node _Branch_M_io_arg_x_T_19 = mux(_Branch_M_io_arg_x_T_18, RegFile.io_rdata1, _Branch_M_io_arg_x_T_17) @[Mux.scala 80:57]
    node _Branch_M_io_arg_x_T_20 = eq(UInt<4>("ha"), Branch_Forward.io_forward_rs1) @[Mux.scala 80:60]
    node _Branch_M_io_arg_x_T_21 = mux(_Branch_M_io_arg_x_T_20, RegFile.io_rdata1, _Branch_M_io_arg_x_T_19) @[Mux.scala 80:57]
    node _JALR_io_rdata1_T = asUInt(RegFile.io_rdata1) @[Main.scala 168:36]
    node _JALR_io_rdata1_T_1 = asUInt(RegFile.io_rdata1) @[Main.scala 169:36]
    node _JALR_io_rdata1_T_2 = asUInt(RegFile.io_rdata1) @[Main.scala 170:36]
    node _JALR_io_rdata1_T_3 = asUInt(RegFile.io_rdata1) @[Main.scala 171:36]
    node _JALR_io_rdata1_T_4 = asUInt(RegFile.io_rdata1) @[Main.scala 172:36]
    node _JALR_io_rdata1_T_5 = asUInt(RegFile.io_rdata1) @[Main.scala 173:36]
    node _JALR_io_rdata1_T_6 = asUInt(ALU.io_out) @[Main.scala 174:29]
    node _JALR_io_rdata1_T_7 = asUInt(EX_MEM_M.io_EXMEM_alu_out) @[Main.scala 175:44]
    node _JALR_io_rdata1_T_8 = asUInt(RegFile.io_w_data) @[Main.scala 176:36]
    node _JALR_io_rdata1_T_9 = asUInt(DataMemory.io_dataOut) @[Main.scala 177:40]
    node _JALR_io_rdata1_T_10 = asUInt(RegFile.io_w_data) @[Main.scala 178:37]
    node _JALR_io_rdata1_T_11 = eq(UInt<1>("h0"), Branch_Forward.io_forward_rs1) @[Mux.scala 80:60]
    node _JALR_io_rdata1_T_12 = mux(_JALR_io_rdata1_T_11, _JALR_io_rdata1_T, UInt<1>("h0")) @[Mux.scala 80:57]
    node _JALR_io_rdata1_T_13 = eq(UInt<1>("h1"), Branch_Forward.io_forward_rs1) @[Mux.scala 80:60]
    node _JALR_io_rdata1_T_14 = mux(_JALR_io_rdata1_T_13, _JALR_io_rdata1_T_1, _JALR_io_rdata1_T_12) @[Mux.scala 80:57]
    node _JALR_io_rdata1_T_15 = eq(UInt<2>("h2"), Branch_Forward.io_forward_rs1) @[Mux.scala 80:60]
    node _JALR_io_rdata1_T_16 = mux(_JALR_io_rdata1_T_15, _JALR_io_rdata1_T_2, _JALR_io_rdata1_T_14) @[Mux.scala 80:57]
    node _JALR_io_rdata1_T_17 = eq(UInt<2>("h3"), Branch_Forward.io_forward_rs1) @[Mux.scala 80:60]
    node _JALR_io_rdata1_T_18 = mux(_JALR_io_rdata1_T_17, _JALR_io_rdata1_T_3, _JALR_io_rdata1_T_16) @[Mux.scala 80:57]
    node _JALR_io_rdata1_T_19 = eq(UInt<3>("h4"), Branch_Forward.io_forward_rs1) @[Mux.scala 80:60]
    node _JALR_io_rdata1_T_20 = mux(_JALR_io_rdata1_T_19, _JALR_io_rdata1_T_4, _JALR_io_rdata1_T_18) @[Mux.scala 80:57]
    node _JALR_io_rdata1_T_21 = eq(UInt<3>("h5"), Branch_Forward.io_forward_rs1) @[Mux.scala 80:60]
    node _JALR_io_rdata1_T_22 = mux(_JALR_io_rdata1_T_21, _JALR_io_rdata1_T_5, _JALR_io_rdata1_T_20) @[Mux.scala 80:57]
    node _JALR_io_rdata1_T_23 = eq(UInt<3>("h6"), Branch_Forward.io_forward_rs1) @[Mux.scala 80:60]
    node _JALR_io_rdata1_T_24 = mux(_JALR_io_rdata1_T_23, _JALR_io_rdata1_T_6, _JALR_io_rdata1_T_22) @[Mux.scala 80:57]
    node _JALR_io_rdata1_T_25 = eq(UInt<3>("h7"), Branch_Forward.io_forward_rs1) @[Mux.scala 80:60]
    node _JALR_io_rdata1_T_26 = mux(_JALR_io_rdata1_T_25, _JALR_io_rdata1_T_7, _JALR_io_rdata1_T_24) @[Mux.scala 80:57]
    node _JALR_io_rdata1_T_27 = eq(UInt<4>("h8"), Branch_Forward.io_forward_rs1) @[Mux.scala 80:60]
    node _JALR_io_rdata1_T_28 = mux(_JALR_io_rdata1_T_27, _JALR_io_rdata1_T_8, _JALR_io_rdata1_T_26) @[Mux.scala 80:57]
    node _JALR_io_rdata1_T_29 = eq(UInt<4>("h9"), Branch_Forward.io_forward_rs1) @[Mux.scala 80:60]
    node _JALR_io_rdata1_T_30 = mux(_JALR_io_rdata1_T_29, _JALR_io_rdata1_T_9, _JALR_io_rdata1_T_28) @[Mux.scala 80:57]
    node _JALR_io_rdata1_T_31 = eq(UInt<4>("ha"), Branch_Forward.io_forward_rs1) @[Mux.scala 80:60]
    node _JALR_io_rdata1_T_32 = mux(_JALR_io_rdata1_T_31, _JALR_io_rdata1_T_10, _JALR_io_rdata1_T_30) @[Mux.scala 80:57]
    node _JALR_io_imme_T = asUInt(ImmValue) @[Main.scala 180:30]
    node _Branch_M_io_arg_y_T = eq(UInt<1>("h0"), Branch_Forward.io_forward_rs2) @[Mux.scala 80:60]
    node _Branch_M_io_arg_y_T_1 = mux(_Branch_M_io_arg_y_T, RegFile.io_rdata2, asSInt(UInt<1>("h0"))) @[Mux.scala 80:57]
    node _Branch_M_io_arg_y_T_2 = eq(UInt<1>("h1"), Branch_Forward.io_forward_rs2) @[Mux.scala 80:60]
    node _Branch_M_io_arg_y_T_3 = mux(_Branch_M_io_arg_y_T_2, ALU.io_out, _Branch_M_io_arg_y_T_1) @[Mux.scala 80:57]
    node _Branch_M_io_arg_y_T_4 = eq(UInt<2>("h2"), Branch_Forward.io_forward_rs2) @[Mux.scala 80:60]
    node _Branch_M_io_arg_y_T_5 = mux(_Branch_M_io_arg_y_T_4, EX_MEM_M.io_EXMEM_alu_out, _Branch_M_io_arg_y_T_3) @[Mux.scala 80:57]
    node _Branch_M_io_arg_y_T_6 = eq(UInt<2>("h3"), Branch_Forward.io_forward_rs2) @[Mux.scala 80:60]
    node _Branch_M_io_arg_y_T_7 = mux(_Branch_M_io_arg_y_T_6, RegFile.io_w_data, _Branch_M_io_arg_y_T_5) @[Mux.scala 80:57]
    node _Branch_M_io_arg_y_T_8 = eq(UInt<3>("h4"), Branch_Forward.io_forward_rs2) @[Mux.scala 80:60]
    node _Branch_M_io_arg_y_T_9 = mux(_Branch_M_io_arg_y_T_8, DataMemory.io_dataOut, _Branch_M_io_arg_y_T_7) @[Mux.scala 80:57]
    node _Branch_M_io_arg_y_T_10 = eq(UInt<3>("h5"), Branch_Forward.io_forward_rs2) @[Mux.scala 80:60]
    node _Branch_M_io_arg_y_T_11 = mux(_Branch_M_io_arg_y_T_10, RegFile.io_w_data, _Branch_M_io_arg_y_T_9) @[Mux.scala 80:57]
    node _Branch_M_io_fnct3_T = bits(IF_ID_M.io_mux_g_inst_out, 14, 12) @[Main.scala 190:51]
    node _T_5 = eq(HazardDetect.io_pc_forward, UInt<1>("h1")) @[Main.scala 193:37]
    node _T_6 = eq(control_module.io_next_pc_sel, UInt<1>("h1")) @[Main.scala 196:44]
    node _T_7 = eq(Branch_M.io_br_taken, UInt<1>("h1")) @[Main.scala 197:39]
    node _T_8 = eq(control_module.io_branch, UInt<1>("h1")) @[Main.scala 197:75]
    node _T_9 = and(_T_7, _T_8) @[Main.scala 197:47]
    node _PC_io_in_T = asSInt(PC4.io_out) @[Main.scala 204:40]
    node _GEN_12 = mux(_T_9, ImmGen.io_SB_type, _PC_io_in_T) @[Main.scala 197:84 Main.scala 198:26 Main.scala 204:26]
    node _GEN_13 = mux(_T_9, asSInt(UInt<1>("h0")), PC.io_out) @[Main.scala 197:84 Main.scala 199:34 Main.scala 53:22]
    node _GEN_14 = mux(_T_9, UInt<1>("h0"), PC4.io_out) @[Main.scala 197:84 Main.scala 200:35 Main.scala 54:23]
    node _GEN_15 = mux(_T_9, asSInt(UInt<1>("h0")), PC_for) @[Main.scala 197:84 Main.scala 201:40 Main.scala 55:28]
    node _GEN_16 = mux(_T_9, UInt<1>("h0"), Instruction_F) @[Main.scala 197:84 Main.scala 202:42 Main.scala 56:30]
    node _T_10 = eq(control_module.io_next_pc_sel, UInt<2>("h2")) @[Main.scala 206:50]
    node _T_11 = eq(control_module.io_next_pc_sel, UInt<2>("h3")) @[Main.scala 212:50]
    node _PC_io_in_T_1 = asSInt(JALR.io_out) @[Main.scala 213:37]
    node _PC_io_in_T_2 = asSInt(PC4.io_out) @[Main.scala 219:36]
    node _GEN_17 = mux(_T_11, _PC_io_in_T_1, _PC_io_in_T_2) @[Main.scala 212:63 Main.scala 213:22 Main.scala 219:22]
    node _GEN_18 = mux(_T_11, asSInt(UInt<1>("h0")), PC.io_out) @[Main.scala 212:63 Main.scala 214:30 Main.scala 53:22]
    node _GEN_19 = mux(_T_11, UInt<1>("h0"), PC4.io_out) @[Main.scala 212:63 Main.scala 215:31 Main.scala 54:23]
    node _GEN_20 = mux(_T_11, asSInt(UInt<1>("h0")), PC_for) @[Main.scala 212:63 Main.scala 216:36 Main.scala 55:28]
    node _GEN_21 = mux(_T_11, UInt<1>("h0"), Instruction_F) @[Main.scala 212:63 Main.scala 217:38 Main.scala 56:30]
    node _GEN_22 = mux(_T_10, ImmGen.io_UJ_type, _GEN_17) @[Main.scala 206:63 Main.scala 207:22]
    node _GEN_23 = mux(_T_10, asSInt(UInt<1>("h0")), _GEN_18) @[Main.scala 206:63 Main.scala 208:30]
    node _GEN_24 = mux(_T_10, UInt<1>("h0"), _GEN_19) @[Main.scala 206:63 Main.scala 209:31]
    node _GEN_25 = mux(_T_10, asSInt(UInt<1>("h0")), _GEN_20) @[Main.scala 206:63 Main.scala 210:36]
    node _GEN_26 = mux(_T_10, UInt<1>("h0"), _GEN_21) @[Main.scala 206:63 Main.scala 211:38]
    node _GEN_27 = mux(_T_6, _GEN_12, _GEN_22) @[Main.scala 196:57]
    node _GEN_28 = mux(_T_6, _GEN_13, _GEN_23) @[Main.scala 196:57]
    node _GEN_29 = mux(_T_6, _GEN_14, _GEN_24) @[Main.scala 196:57]
    node _GEN_30 = mux(_T_6, _GEN_15, _GEN_25) @[Main.scala 196:57]
    node _GEN_31 = mux(_T_6, _GEN_16, _GEN_26) @[Main.scala 196:57]
    node _GEN_32 = mux(_T_5, HazardDetect.io_pc_out, _GEN_27) @[Main.scala 193:46 Main.scala 194:18]
    node _GEN_33 = mux(_T_5, PC.io_out, _GEN_28) @[Main.scala 193:46 Main.scala 53:22]
    node _GEN_34 = mux(_T_5, PC4.io_out, _GEN_29) @[Main.scala 193:46 Main.scala 54:23]
    node _GEN_35 = mux(_T_5, PC_for, _GEN_30) @[Main.scala 193:46 Main.scala 55:28]
    node _GEN_36 = mux(_T_5, Instruction_F, _GEN_31) @[Main.scala 193:46 Main.scala 56:30]
    node _ID_EX_M_io_func3_in_T = bits(IF_ID_M.io_mux_g_inst_out, 14, 12) @[Main.scala 226:53]
    node _ID_EX_M_io_func7_in_T = bits(IF_ID_M.io_mux_g_inst_out, 30, 30) @[Main.scala 227:53]
    node _ID_EX_M_io_rd_in_T = bits(IF_ID_M.io_mux_g_inst_out, 11, 7) @[Main.scala 228:50]
    node _T_12 = eq(ID_EX_M.io_ctrl_OpA_out, UInt<1>("h1")) @[Main.scala 243:35]
    node _ALU_io_in_A_T = asSInt(ID_EX_M.io_IFID_pc4_out) @[Main.scala 244:48]
    node _T_13 = eq(Forwarding.io_forward_a, UInt<1>("h0")) @[Main.scala 247:38]
    node _T_14 = eq(Forwarding.io_forward_a, UInt<1>("h1")) @[Main.scala 249:44]
    node _T_15 = eq(Forwarding.io_forward_a, UInt<2>("h2")) @[Main.scala 251:44]
    node _GEN_37 = mux(_T_15, EX_MEM_M.io_EXMEM_alu_out, ID_EX_M.io_rs1_data_out) @[Main.scala 251:57 Main.scala 252:25 Main.scala 254:25]
    node _T_20 = eq(MEM_WB_M.io_MEMWB_memToReg_out, UInt<1>("h0")) @[Main.scala 315:42]
    node _T_21 = eq(MEM_WB_M.io_MEMWB_memToReg_out, UInt<1>("h1")) @[Main.scala 317:48]
    node _GEN_45 = mux(_T_21, MEM_WB_M.io_MEMWB_dataMem_out, asSInt(UInt<1>("h0"))) @[Main.scala 317:57 Main.scala 318:9 Main.scala 320:9]
    node _GEN_46 = mux(_T_20, MEM_WB_M.io_MEMWB_alu_out, _GEN_45) @[Main.scala 315:51 Main.scala 316:9]
    node d = _GEN_46 @[Main.scala 241:17]
    node _GEN_38 = mux(_T_14, d, _GEN_37) @[Main.scala 249:57 Main.scala 250:25]
    node _GEN_39 = mux(_T_13, ID_EX_M.io_rs1_data_out, _GEN_38) @[Main.scala 247:51 Main.scala 248:25]
    node _GEN_40 = mux(_T_12, _ALU_io_in_A_T, _GEN_39) @[Main.scala 243:48 Main.scala 244:21]
    node _T_16 = eq(Forwarding.io_forward_b, UInt<1>("h0")) @[Main.scala 259:35]
    node _T_17 = eq(Forwarding.io_forward_b, UInt<1>("h1")) @[Main.scala 261:41]
    node _T_18 = eq(Forwarding.io_forward_b, UInt<2>("h2")) @[Main.scala 263:41]
    node _GEN_41 = mux(_T_18, EX_MEM_M.io_EXMEM_alu_out, asSInt(UInt<1>("h0"))) @[Main.scala 263:50 Main.scala 264:17 Main.scala 266:17]
    node _GEN_42 = mux(_T_17, d, _GEN_41) @[Main.scala 261:50 Main.scala 262:17]
    node _GEN_43 = mux(_T_16, ID_EX_M.io_rs2_data_out, _GEN_42) @[Main.scala 259:44 Main.scala 260:17]
    node _T_19 = eq(ID_EX_M.io_ctrl_OpB_out, UInt<1>("h0")) @[Main.scala 268:35]
    node RS2_value = _GEN_43 @[Main.scala 258:25]
    node _GEN_44 = mux(_T_19, RS2_value, ID_EX_M.io_imm_out) @[Main.scala 268:44 Main.scala 269:19 Main.scala 271:19]
    node _DataMemory_io_addr_T = asUInt(EX_MEM_M.io_EXMEM_alu_out) @[Main.scala 297:53]
    node S_rs1DataIn = _GEN_1 @[Main.scala 91:27]
    node S_rs2DataIn = _GEN_3 @[Main.scala 92:27]
    io_out <= asSInt(UInt<1>("h0")) @[Main.scala 326:12]
    PC.clock <= clock
    PC.reset <= reset
    PC.io_in <= _GEN_32
    PC4.clock <= clock
    PC4.reset <= reset
    PC4.io_pc <= _PC4_io_pc_T @[Main.scala 40:15]
    InstMemory.clock <= clock
    InstMemory.reset <= reset
    InstMemory.io_addr <= _InstMemory_io_addr_T @[Main.scala 41:24]
    control_module.clock <= clock
    control_module.reset <= reset
    control_module.io_opcode <= _control_module_io_opcode_T @[Main.scala 63:30]
    ImmGen.clock <= clock
    ImmGen.reset <= reset
    ImmGen.io_instr <= IF_ID_M.io_mux_g_inst_out @[Main.scala 59:21]
    ImmGen.io_pc <= _ImmGen_io_pc_T @[Main.scala 60:18]
    RegFile.clock <= clock
    RegFile.reset <= reset
    RegFile.io_rs1 <= _RegFile_io_rs1_T_12 @[Main.scala 65:20]
    RegFile.io_rs2 <= _RegFile_io_rs2_T_6 @[Main.scala 74:20]
    RegFile.io_reg_write <= MEM_WB_M.io_MEMWB_reg_w_out @[Main.scala 300:26]
    RegFile.io_w_reg <= MEM_WB_M.io_MEMWB_rd_out @[Main.scala 299:22]
    RegFile.io_w_data <= d @[Main.scala 323:23]
    ALU_Control.clock <= clock
    ALU_Control.reset <= reset
    ALU_Control.io_func3 <= ID_EX_M.io_func3_out @[Main.scala 276:26]
    ALU_Control.io_func7 <= ID_EX_M.io_func7_out @[Main.scala 277:26]
    ALU_Control.io_aluOp <= ID_EX_M.io_ctrl_AluOp_out @[Main.scala 274:26]
    ALU.clock <= clock
    ALU.reset <= reset
    ALU.io_in_A <= _GEN_40
    ALU.io_in_B <= _GEN_44
    ALU.io_alu_Op <= ALU_Control.io_out @[Main.scala 279:19]
    Branch_M.clock <= clock
    Branch_M.reset <= reset
    Branch_M.io_fnct3 <= _Branch_M_io_fnct3_T @[Main.scala 190:23]
    Branch_M.io_branch <= control_module.io_branch @[Main.scala 191:24]
    Branch_M.io_arg_x <= _Branch_M_io_arg_x_T_21 @[Main.scala 153:23]
    Branch_M.io_arg_y <= _Branch_M_io_arg_y_T_11 @[Main.scala 182:23]
    DataMemory.clock <= clock
    DataMemory.reset <= reset
    DataMemory.io_addr <= _DataMemory_io_addr_T @[Main.scala 297:24]
    DataMemory.io_dataIn <= EX_MEM_M.io_EXMEM_rs2_out @[Main.scala 295:26]
    DataMemory.io_mem_read <= EX_MEM_M.io_EXMEM_memRd_out @[Main.scala 291:28]
    DataMemory.io_mem_write <= EX_MEM_M.io_EXMEM_memWr_out @[Main.scala 292:29]
    JALR.clock <= clock
    JALR.reset <= reset
    JALR.io_imme <= _JALR_io_imme_T @[Main.scala 180:18]
    JALR.io_rdata1 <= _JALR_io_rdata1_T_32 @[Main.scala 167:20]
    IF_ID_M.clock <= clock
    IF_ID_M.reset <= reset
    IF_ID_M.io_pc_in <= _GEN_33
    IF_ID_M.io_pc4_in <= _GEN_34
    IF_ID_M.io_mux_f_pc_in <= _GEN_35
    IF_ID_M.io_mux_g_inst_in <= _GEN_36
    ID_EX_M.clock <= clock
    ID_EX_M.reset <= reset
    ID_EX_M.io_rs1_in <= RegFile.io_rs1 @[Main.scala 223:23]
    ID_EX_M.io_rs2_in <= RegFile.io_rs2 @[Main.scala 224:23]
    ID_EX_M.io_rs1_data_in <= S_rs1DataIn @[Main.scala 112:28]
    ID_EX_M.io_rs2_data_in <= S_rs2DataIn @[Main.scala 113:28]
    ID_EX_M.io_imm <= ImmValue @[Main.scala 225:20]
    ID_EX_M.io_rd_in <= _ID_EX_M_io_rd_in_T @[Main.scala 228:22]
    ID_EX_M.io_func3_in <= _ID_EX_M_io_func3_in_T @[Main.scala 226:25]
    ID_EX_M.io_func7_in <= _ID_EX_M_io_func7_in_T @[Main.scala 227:25]
    ID_EX_M.io_ctrl_MemWr_in <= _GEN_4
    ID_EX_M.io_ctrl_Branch_in <= _GEN_10
    ID_EX_M.io_ctrl_MemRd_in <= _GEN_5
    ID_EX_M.io_ctrl_Reg_W_in <= _GEN_7
    ID_EX_M.io_ctrl_MemToReg_in <= _GEN_6
    ID_EX_M.io_ctrl_AluOp_in <= _GEN_8
    ID_EX_M.io_ctrl_OpA_in <= control_module.io_operand_A @[Main.scala 239:28]
    ID_EX_M.io_ctrl_OpB_in <= _GEN_9
    ID_EX_M.io_ctrl_nextpc_in <= _GEN_11
    ID_EX_M.io_IFID_pc4_in <= IF_ID_M.io_pc4_out @[Main.scala 240:28]
    EX_MEM_M.clock <= clock
    EX_MEM_M.reset <= reset
    EX_MEM_M.io_IDEX_MEMRD <= ID_EX_M.io_ctrl_MemRd_out @[Main.scala 282:28]
    EX_MEM_M.io_IDEX_MEMWR <= ID_EX_M.io_ctrl_MemWr_out @[Main.scala 283:28]
    EX_MEM_M.io_IDEX_MEMTOREG <= ID_EX_M.io_ctrl_MemToReg_out @[Main.scala 284:31]
    EX_MEM_M.io_IDEX_REG_W <= ID_EX_M.io_ctrl_Reg_W_out @[Main.scala 285:28]
    EX_MEM_M.io_IDEX_rs2 <= RS2_value @[Main.scala 287:26]
    EX_MEM_M.io_IDEX_rd <= ID_EX_M.io_rd_out @[Main.scala 278:25]
    EX_MEM_M.io_alu_out <= ALU.io_out @[Main.scala 288:25]
    MEM_WB_M.clock <= clock
    MEM_WB_M.reset <= reset
    MEM_WB_M.io_EXMEM_MEMTOREG <= EX_MEM_M.io_EXMEM_memToReg_out @[Main.scala 293:32]
    MEM_WB_M.io_EXMEM_REG_W <= EX_MEM_M.io_EXMEM_reg_w_out @[Main.scala 294:29]
    MEM_WB_M.io_EXMEM_MEMRD <= EX_MEM_M.io_EXMEM_memRd_out @[Main.scala 141:29]
    MEM_WB_M.io_EXMEM_rd <= EX_MEM_M.io_EXMEM_rd_out @[Main.scala 296:26]
    MEM_WB_M.io_in_dataMem_out <= DataMemory.io_dataOut @[Main.scala 304:32]
    MEM_WB_M.io_in_alu_out <= EX_MEM_M.io_EXMEM_alu_out @[Main.scala 305:28]
    Forwarding.clock <= clock
    Forwarding.reset <= reset
    Forwarding.io_IDEX_rs1 <= ID_EX_M.io_rs1_out @[Main.scala 232:28]
    Forwarding.io_IDEX_rs2 <= ID_EX_M.io_rs2_out @[Main.scala 233:28]
    Forwarding.io_EXMEM_rd <= EX_MEM_M.io_EXMEM_rd_out @[Main.scala 234:28]
    Forwarding.io_EXMEM_regWr <= EX_MEM_M.io_EXMEM_reg_w_out @[Main.scala 235:31]
    Forwarding.io_MEMWB_rd <= MEM_WB_M.io_MEMWB_rd_out @[Main.scala 236:28]
    Forwarding.io_MEMWB_regWr <= MEM_WB_M.io_MEMWB_reg_w_out @[Main.scala 237:31]
    HazardDetect.clock <= clock
    HazardDetect.reset <= reset
    HazardDetect.io_IF_ID_inst <= IF_ID_M.io_mux_g_inst_out @[Main.scala 135:32]
    HazardDetect.io_ID_EX_memRead <= ID_EX_M.io_ctrl_MemRd_out @[Main.scala 136:35]
    HazardDetect.io_ID_EX_rd <= ID_EX_M.io_rd_out @[Main.scala 137:30]
    HazardDetect.io_pc_in <= _HazardDetect_io_pc_in_T @[Main.scala 138:27]
    HazardDetect.io_current_pc <= IF_ID_M.io_mux_f_pc_out @[Main.scala 139:32]
    Branch_Forward.clock <= clock
    Branch_Forward.reset <= reset
    Branch_Forward.io_ID_EX_RD <= ID_EX_M.io_rd_out @[Main.scala 143:32]
    Branch_Forward.io_EX_MEM_RD <= EX_MEM_M.io_EXMEM_rd_out @[Main.scala 144:33]
    Branch_Forward.io_MEM_WB_RD <= MEM_WB_M.io_MEMWB_rd_out @[Main.scala 145:33]
    Branch_Forward.io_ID_EX_memRd <= ID_EX_M.io_ctrl_MemRd_out @[Main.scala 146:35]
    Branch_Forward.io_EX_MEM_memRd <= EX_MEM_M.io_EXMEM_memRd_out @[Main.scala 147:36]
    Branch_Forward.io_MEM_WB_memRd <= MEM_WB_M.io_MEMWB_memRd_out @[Main.scala 148:36]
    Branch_Forward.io_rs1 <= _Branch_Forward_io_rs1_T @[Main.scala 149:27]
    Branch_Forward.io_rs2 <= _Branch_Forward_io_rs2_T @[Main.scala 150:27]
    Branch_Forward.io_ctrl_branch <= control_module.io_branch @[Main.scala 151:35]
    Structural.clock <= clock
    Structural.reset <= reset
    Structural.io_rs1 <= _Structural_io_rs1_T @[Main.scala 86:23]
    Structural.io_rs2 <= _Structural_io_rs2_T @[Main.scala 87:23]
    Structural.io_MEM_WB_regWr <= MEM_WB_M.io_EXMEM_REG_W @[Main.scala 88:32]
    Structural.io_MEM_WB_Rd <= MEM_WB_M.io_MEMWB_rd_out @[Main.scala 89:29]
