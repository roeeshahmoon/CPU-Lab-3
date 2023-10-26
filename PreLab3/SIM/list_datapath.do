onerror {resume}
add list -width 18 /tb_datapath/clk
add list /tb_datapath/rst
add list /tb_datapath/ena
add list /tb_datapath/mov
add list /tb_datapath/st
add list /tb_datapath/ld
add list /tb_datapath/jnc
add list /tb_datapath/jc
add list /tb_datapath/jmp
add list /tb_datapath/sub
add list /tb_datapath/add
add list /tb_datapath/nop
add list /tb_datapath/Nflag
add list /tb_datapath/Zflag
add list /tb_datapath/Cflag
add list /tb_datapath/Cout
add list /tb_datapath/Cin
add list /tb_datapath/Ain
add list /tb_datapath/RFin
add list /tb_datapath/RFout
add list /tb_datapath/IRin
add list /tb_datapath/PCin
add list /tb_datapath/Imm1_in
add list /tb_datapath/Imm2_in
add list /tb_datapath/done_in
add list /tb_datapath/DoneProgram
add list /tb_datapath/Mem_wr
add list /tb_datapath/Mem_out
add list /tb_datapath/Mem_in
add list /tb_datapath/OPC
add list /tb_datapath/RFadder
add list /tb_datapath/PCsel
add list /tb_datapath/DataMemTBDataIn
add list /tb_datapath/ProgMemTBDataIn
add list /tb_datapath/DataMemDataOut
add list /tb_datapath/ProgMemTBWren
add list /tb_datapath/DataMemTBWren
add list /tb_datapath/ProgMemTbWAddr
add list /tb_datapath/DataMemTbWAddr
add list /tb_datapath/DataMemTbRAddr
add list /tb_datapath/TBactive
configure list -usestrobe 0
configure list -strobestart {0 ps} -strobeperiod {0 ps}
configure list -usesignaltrigger 1
configure list -delta collapse
configure list -signalnamewidth 0
configure list -datasetprefix 0
configure list -namelimit 5
