package Pipeline
import chisel3._
import chisel3.util._

class PIPELINE extends Module {
    val io = IO(new Bundle {
        val out = Output (SInt(4.W))
    })
    //  Pipes of stages 
    val IF_ID_              =   Module(new IF_ID)
    val ID_EX_              =   Module(new ID_EX)
    val EX_MEM_M            =   Module(new EX_MEM)
    val MEM_WB_M            =   Module(new MEM_WB)

    // PC / PC+4
    val PC                  =   Module(new PC)
    val PC4                 =   Module(new PC4)

    // Memory   
    val InstMemory          =   Module(new InstMem ("/home/kinzaa/Desktop/5-Stage-RV32I/src/main/scala/Pipeline/test.txt"))
    val DataMemory          =   Module(new DataMemory)

    // Helping Units
    val control_module      =   Module(new Control)
    val ImmGen              =   Module(new ImmGenerator)
    val RegFile             =   Module(new RegisterFile)
    val ALU_Control         =   Module(new AluControl)
    dontTouch(ALU_Control.io)
    val ALU                 =   Module(new ALU)
    dontTouch(ALU.io)
    val Branch_M            =   Module(new Branch)
    val JALR                =   Module(new Jalr)
    
    // hazard units
    val Forwarding          =   Module(new Forwarding)
    val HazardDetect        =   Module(new HazardDetection)
    val Branch_Forward      =   Module(new BranchForward)
    val Structural          =   Module(new StructuralHazard)

    val PC_F = MuxLookup (HazardDetect.io.pc_forward, 0.S, Array (
        (0.U) -> PC4.io.out.asSInt,
        (1.U) -> HazardDetect.io.pc_out))
    
    PC.io.in := PC_F                            // PC_in input
    PC4.io.pc := PC.io.out.asUInt               // PC4_in input <- PC_out
    InstMemory.io.addr := PC.io.out.asUInt      // Address to fetch instruction
    
    val PC_for = MuxLookup (HazardDetect.io.inst_forward, 0.S, Array (
        (0.U) -> PC.io.out,
        (1.U) -> HazardDetect.io.current_pc_out))
    
    val Instruction_F = MuxLookup (HazardDetect.io.inst_forward, 0.U, Array (
        (0.U) -> InstMemory.io.data,
        (1.U) -> HazardDetect.io.inst_out))
    // Fetch decode pipe connections
    IF_ID_.io.pc_in         := PC.io.out             // PC  out from pc
    IF_ID_.io.pc4_in        := PC4.io.out            // PC4 out from pc4
    IF_ID_.io.SelectedPC    := PC_for                // Selected PC
    IF_ID_.io.SelectedInstr := Instruction_F         // Selected Instruction

    //ImmGenerator Inputs
    ImmGen.io.instr         := IF_ID_.io.SelectedInstr_out    // Instrcution to generate Immidiate Value 32
    ImmGen.io.pc            := IF_ID_.io.SelectedPC_out.asUInt  // PC to add
    
    // Decode connections (Control unit RegFile)
    control_module.io.opcode := IF_ID_.io.SelectedInstr_out(6, 0)   // OPcode to check Instrcution TYpe
    // Registerfile inputs
    RegFile.io.rs1 := Mux(
    control_module.io.opcode === 51.U ||    // R-type
    control_module.io.opcode === 19.U ||    // I-type
    control_module.io.opcode === 35.U ||    // S-type
    control_module.io.opcode === 3.U ||     // I-type (load instructions)
    control_module.io.opcode === 99.U ||    // SB-type (branch)
    control_module.io.opcode === 103.U,     // JALR instruction
    IF_ID_.io.SelectedInstr_out(19, 15), 0.U )
    
    RegFile.io.rs2 := Mux(
    control_module.io.opcode === 51.U || // R-type
    control_module.io.opcode === 35.U || // S-type
    control_module.io.opcode === 99.U,   // SB-type (branch)
    IF_ID_.io.SelectedInstr_out(24, 20), 0.U)
    RegFile.io.reg_write := control_module.io.reg_write 
    
    val ImmValue = MuxLookup (control_module.io.extend, 0.S, Array (
        (0.U) -> ImmGen.io.I_type,
        (1.U) -> ImmGen.io.S_type,
        (2.U) -> ImmGen.io.U_type))
    // Structural hazard inputs
    Structural.io.rs1               := IF_ID_.io.SelectedInstr_out(19, 15)
    Structural.io.rs2               := IF_ID_.io.SelectedInstr_out(24, 20)
    Structural.io.MEM_WB_regWr      := MEM_WB_M.io.EXMEM_REG_W
    Structural.io.MEM_WB_Rd         := MEM_WB_M.io.MEMWB_rd_out
   
    val S_rs1DataIn = Wire(SInt(32.W)) 
    val S_rs2DataIn = Wire(SInt(32.W))

    //  rs1_data
    when (Structural.io.fwd_rs1 === 0.U) {
      S_rs1DataIn := RegFile.io.rdata1
    }.elsewhen (Structural.io.fwd_rs1 === 1.U) {
      S_rs1DataIn := RegFile.io.w_data
    }.otherwise {
      S_rs1DataIn := 0.S 
    }
    // rs2_data
    when (Structural.io.fwd_rs2 === 0.U) {
      S_rs2DataIn := RegFile.io.rdata2
    }.elsewhen (Structural.io.fwd_rs2 === 1.U) {
      S_rs2DataIn := RegFile.io.w_data
    }.otherwise {
      S_rs2DataIn := 0.S
    }
    //ID_EX_ inputs
    ID_EX_.io.rs1_data_in        :=   S_rs1DataIn
    ID_EX_.io.rs2_data_in        :=   S_rs2DataIn

    // Stall when forward
    when(HazardDetect.io.ctrl_forward === "b1".U) {
        ID_EX_.io.ctrl_MemWr_in       := 0.U
        ID_EX_.io.ctrl_MemRd_in       := 0.U
        ID_EX_.io.ctrl_MemToReg_in    := 0.U
        ID_EX_.io.ctrl_Reg_W_in       := 0.U
        ID_EX_.io.ctrl_AluOp_in       := 0.U
        ID_EX_.io.ctrl_OpB_in         := 0.U
        ID_EX_.io.ctrl_Branch_in      := 0.U
        ID_EX_.io.ctrl_nextpc_in      := 0.U
    }.otherwise {
        ID_EX_.io.ctrl_MemWr_in      := control_module.io.mem_write
        ID_EX_.io.ctrl_MemRd_in      := control_module.io.mem_read
        ID_EX_.io.ctrl_MemToReg_in   := control_module.io.men_to_reg
        ID_EX_.io.ctrl_Reg_W_in      := control_module.io.reg_write 
        ID_EX_.io.ctrl_AluOp_in      := control_module.io.alu_operation
        ID_EX_.io.ctrl_OpB_in        := control_module.io.operand_B
        ID_EX_.io.ctrl_Branch_in     := control_module.io.branch
        ID_EX_.io.ctrl_nextpc_in     := control_module.io.next_pc_sel
    }
    // Hazard detection Unit inputs
    HazardDetect.io.IF_ID_inst      := IF_ID_.io.SelectedInstr_out
    HazardDetect.io.ID_EX_memRead   := ID_EX_.io.ctrl_MemRd_out
    HazardDetect.io.ID_EX_rd        := ID_EX_.io.rd_out
    HazardDetect.io.pc_in           := IF_ID_.io.pc4_out.asSInt
    HazardDetect.io.current_pc      := IF_ID_.io.SelectedPC_out
    
    MEM_WB_M.io.EXMEM_MEMRD         := EX_MEM_M.io.EXMEM_memRd_out      // 0/ 1: data read from memory 
    
    // Branch forward Unit inputs
    Branch_Forward.io.ID_EX_RD      := ID_EX_.io.rd_out
    Branch_Forward.io.EX_MEM_RD     := EX_MEM_M.io.EXMEM_rd_out 
    Branch_Forward.io.MEM_WB_RD     := MEM_WB_M.io.MEMWB_rd_out
    Branch_Forward.io.ID_EX_memRd   := ID_EX_.io.ctrl_MemRd_out
    Branch_Forward.io.EX_MEM_memRd  := EX_MEM_M.io.EXMEM_memRd_out
    Branch_Forward.io.MEM_WB_memRd  := MEM_WB_M.io.MEMWB_memRd_out
    Branch_Forward.io.rs1           := IF_ID_.io.SelectedInstr_out(19, 15)
    Branch_Forward.io.rs2           := IF_ID_.io.SelectedInstr_out(24, 20)
    Branch_Forward.io.ctrl_branch   := control_module.io.branch
    // Branch X
    Branch_M.io.arg_x := MuxLookup (Branch_Forward.io.forward_rs1, 0.S, Array (
        (0.U) -> RegFile.io.rdata1,
        (1.U) -> ALU.io.out, 
        (2.U) -> EX_MEM_M.io.EXMEM_alu_out, 
        (3.U) -> RegFile.io.w_data, 
        (4.U) -> DataMemory.io.dataOut, 
        (5.U) -> RegFile.io.w_data,
        (6.U) -> RegFile.io.rdata1,
        (7.U) -> RegFile.io.rdata1,
        (8.U) -> RegFile.io.rdata1,
        (9.U) -> RegFile.io.rdata1,
        (10.U) -> RegFile.io.rdata1))
    
    // for JALR
    JALR.io.rdata1 := MuxLookup (Branch_Forward.io.forward_rs1, 0.U, Array (
        (0.U) -> RegFile.io.rdata1.asUInt,
        (1.U) -> RegFile.io.rdata1.asUInt, 
        (2.U) -> RegFile.io.rdata1.asUInt, 
        (3.U) -> RegFile.io.rdata1.asUInt, 
        (4.U) -> RegFile.io.rdata1.asUInt, 
        (5.U) -> RegFile.io.rdata1.asUInt,
        (6.U) -> ALU.io.out.asUInt,
        (7.U) -> EX_MEM_M.io.EXMEM_alu_out.asUInt,
        (8.U) -> RegFile.io.w_data.asUInt,
        (9.U) -> DataMemory.io.dataOut.asUInt,
        (10.U) -> RegFile.io.w_data.asUInt))
    
    JALR.io.imme := ImmValue.asUInt
    // Branch Y
    Branch_M.io.arg_y := MuxLookup (Branch_Forward.io.forward_rs2, 0.S, Array (
        (0.U) -> RegFile.io.rdata2,
        (1.U) -> ALU.io.out, 
        (2.U) -> EX_MEM_M.io.EXMEM_alu_out, 
        (3.U) -> RegFile.io.w_data, 
        (4.U) -> DataMemory.io.dataOut, 
        (5.U) -> RegFile.io.w_data))
    
    Branch_M.io.fnct3 := IF_ID_.io.SelectedInstr_out(14, 12)      // Fun3 for(beq,bne....)
    Branch_M.io.branch := control_module.io.branch              // Branch instr yes
    
    when(HazardDetect.io.pc_forward === 1.B) {
        PC.io.in := HazardDetect.io.pc_out
    }.otherwise {
        when(control_module.io.next_pc_sel === "b01".U) {
            when(Branch_M.io.br_taken === 1.B && control_module.io.branch === 1.B) {
                PC.io.in := ImmGen.io.SB_type
                IF_ID_.io.pc_in := 0.S
                IF_ID_.io.pc4_in := 0.U
                IF_ID_.io.SelectedPC:= 0.S
                IF_ID_.io.SelectedInstr := 0.U
            }.otherwise {
                PC.io.in := PC4.io.out.asSInt
            }
        }.elsewhen(control_module.io.next_pc_sel === "b10".U) {
            PC.io.in := ImmGen.io.UJ_type
            IF_ID_.io.pc_in := 0.S
            IF_ID_.io.pc4_in := 0.U
            IF_ID_.io.SelectedPC:= 0.S
            IF_ID_.io.SelectedInstr := 0.U
        }.elsewhen(control_module.io.next_pc_sel === "b11".U) {
            PC.io.in := JALR.io.out.asSInt
            IF_ID_.io.pc_in := 0.S
            IF_ID_.io.pc4_in := 0.U
            IF_ID_.io.SelectedPC:= 0.S
            IF_ID_.io.SelectedInstr := 0.U
        }.otherwise {
            PC.io.in := PC4.io.out.asSInt
        }
    }
    // ID_EX PIPELINE
    ID_EX_.io.rs1_in            := RegFile.io.rs1
    ID_EX_.io.rs2_in            := RegFile.io.rs2
    ID_EX_.io.imm               := ImmValue 
    ID_EX_.io.func3_in          := IF_ID_.io.SelectedInstr_out(14, 12)
    ID_EX_.io.func7_in          := IF_ID_.io.SelectedInstr_out(30)
    ID_EX_.io.rd_in             := IF_ID_.io.SelectedInstr_out(11, 7)

    ALU_Control.io.aluOp            := ID_EX_.io.ctrl_AluOp_out     // Alu op code
    ALU.io.alu_Op                   := ALU_Control.io.out           // Alu op code
    ALU_Control.io.func3            := ID_EX_.io.func3_out          // function 3
    ALU_Control.io.func7            := ID_EX_.io.func7_out          // function 7
    EX_MEM_M.io.IDEX_rd             := ID_EX_.io.rd_out
    
    // Forwarding Inputs
    Forwarding.io.IDEX_rs1        := ID_EX_.io.rs1_out
    Forwarding.io.IDEX_rs2        := ID_EX_.io.rs2_out
    Forwarding.io.EXMEM_rd        := EX_MEM_M.io.EXMEM_rd_out
    Forwarding.io.EXMEM_regWr     := EX_MEM_M.io.EXMEM_reg_w_out
    Forwarding.io.MEMWB_rd        := MEM_WB_M.io.MEMWB_rd_out
    Forwarding.io.MEMWB_regWr     := MEM_WB_M.io.MEMWB_reg_w_out
    
    ID_EX_.io.ctrl_OpA_in := control_module.io.operand_A    // Operand A selection
    ID_EX_.io.IFID_pc4_in := IF_ID_.io.pc4_out      // pc+4 from Decode to execute
    
    val d = Wire(SInt(32.W))

    when (ID_EX_.io.ctrl_OpA_out === "b01".U) {
        ALU.io.in_A := ID_EX_.io.IFID_pc4_out.asSInt
    }.otherwise {
        // forwarding A
        when(Forwarding.io.forward_a === "b00".U) {
            ALU.io.in_A := ID_EX_.io.rs1_data_out
        }.elsewhen(Forwarding.io.forward_a === "b01".U) {
            ALU.io.in_A := d
        }.elsewhen(Forwarding.io.forward_a === "b10".U) {
            ALU.io.in_A := EX_MEM_M.io.EXMEM_alu_out
        }.otherwise {
            ALU.io.in_A := ID_EX_.io.rs1_data_out
        }
      }
        // forwarding B
    val RS2_value = Wire(SInt(32.W)) 
    when (Forwarding.io.forward_b === 0.U) {
      RS2_value := ID_EX_.io.rs2_data_out
    }.elsewhen (Forwarding.io.forward_b === 1.U) {
      RS2_value := d
    }.elsewhen (Forwarding.io.forward_b === 2.U) {
      RS2_value := EX_MEM_M.io.EXMEM_alu_out
    }.otherwise {
      RS2_value := 0.S
    }
    when (ID_EX_.io.ctrl_OpB_out === 0.U) {
      ALU.io.in_B   := RS2_value
    }.otherwise {
      ALU.io.in_B   := ID_EX_.io.imm_out
    }
  

    // Execute
    EX_MEM_M.io.IDEX_MEMRD          := ID_EX_.io.ctrl_MemRd_out 
    EX_MEM_M.io.IDEX_MEMWR          := ID_EX_.io.ctrl_MemWr_out
    EX_MEM_M.io.IDEX_MEMTOREG       := ID_EX_.io.ctrl_MemToReg_out
    EX_MEM_M.io.IDEX_REG_W          := ID_EX_.io.ctrl_Reg_W_out
    EX_MEM_M.io.IDEX_rs2            := RS2_value
    EX_MEM_M.io.alu_out             := ALU.io.out
  
    // Data memory inputs
    DataMemory.io.mem_read          := EX_MEM_M.io.EXMEM_memRd_out 
    DataMemory.io.mem_write         := EX_MEM_M.io.EXMEM_memWr_out
    DataMemory.io.dataIn            := EX_MEM_M.io.EXMEM_rs2_out
    DataMemory.io.addr              := EX_MEM_M.io.EXMEM_alu_out.asUInt

    MEM_WB_M.io.EXMEM_MEMTOREG      := EX_MEM_M.io.EXMEM_memToReg_out
    MEM_WB_M.io.EXMEM_REG_W         := EX_MEM_M.io.EXMEM_reg_w_out
    MEM_WB_M.io.EXMEM_rd            := EX_MEM_M.io.EXMEM_rd_out
    MEM_WB_M.io.in_dataMem_out      := DataMemory.io.dataOut        // data from Data Memory
    MEM_WB_M.io.in_alu_out          := EX_MEM_M.io.EXMEM_alu_out    // data from Alu Result
    
    // Register file connections
    RegFile.io.w_reg                := MEM_WB_M.io.MEMWB_rd_out
    RegFile.io.reg_write            := MEM_WB_M.io.MEMWB_reg_w_out
    
    // Write back data to registerfile writedata
    when (MEM_WB_M.io.MEMWB_memToReg_out === 0.U) {
      d := MEM_WB_M.io.MEMWB_alu_out        // data from Alu Result
    }.elsewhen (MEM_WB_M.io.MEMWB_memToReg_out === 1.U) {
      d := MEM_WB_M.io.MEMWB_dataMem_out    // data from Data Memory
    }.otherwise {
      d := 0.S
    }
    RegFile.io.w_data := d  // Write back data
  
    io.out := 0.S

}


