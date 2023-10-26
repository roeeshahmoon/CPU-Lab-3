onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate /tb_datapath/clk
add wave -noupdate /tb_datapath/rst
add wave -noupdate /tb_datapath/ena
add wave -noupdate /tb_datapath/mov
add wave -noupdate /tb_datapath/st
add wave -noupdate /tb_datapath/ld
add wave -noupdate /tb_datapath/jnc
add wave -noupdate /tb_datapath/jc
add wave -noupdate /tb_datapath/jmp
add wave -noupdate /tb_datapath/sub
add wave -noupdate /tb_datapath/add
add wave -noupdate /tb_datapath/nop
add wave -noupdate /tb_datapath/Nflag
add wave -noupdate /tb_datapath/Zflag
add wave -noupdate /tb_datapath/Cflag
add wave -noupdate /tb_datapath/Cout
add wave -noupdate /tb_datapath/Cin
add wave -noupdate /tb_datapath/Ain
add wave -noupdate /tb_datapath/RFin
add wave -noupdate /tb_datapath/RFout
add wave -noupdate /tb_datapath/IRin
add wave -noupdate /tb_datapath/PCin
add wave -noupdate /tb_datapath/Imm1_in
add wave -noupdate /tb_datapath/Imm2_in
add wave -noupdate /tb_datapath/done_in
add wave -noupdate /tb_datapath/DoneProgram
add wave -noupdate /tb_datapath/Mem_wr
add wave -noupdate /tb_datapath/Mem_out
add wave -noupdate /tb_datapath/Mem_in
add wave -noupdate /tb_datapath/OPC
add wave -noupdate /tb_datapath/RFadder
add wave -noupdate /tb_datapath/PCsel
add wave -noupdate /tb_datapath/DataMemTBDataIn
add wave -noupdate /tb_datapath/ProgMemTBDataIn
add wave -noupdate /tb_datapath/DataMemDataOut
add wave -noupdate /tb_datapath/ProgMemTBWren
add wave -noupdate /tb_datapath/DataMemTBWren
add wave -noupdate /tb_datapath/ProgMemTbWAddr
add wave -noupdate /tb_datapath/DataMemTbWAddr
add wave -noupdate /tb_datapath/DataMemTbRAddr
add wave -noupdate /tb_datapath/TBactive
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {2902294 ps} 0}
quietly wave cursor active 1
configure wave -namecolwidth 227
configure wave -valuecolwidth 100
configure wave -justifyvalue left
configure wave -signalnamewidth 0
configure wave -snapdistance 10
configure wave -datasetprefix 0
configure wave -rowmargin 4
configure wave -childrowmargin 2
configure wave -gridoffset 40
configure wave -gridperiod 40
configure wave -griddelta 80
configure wave -timeline 0
configure wave -timelineunits ps
update
WaveRestoreZoom {1464757 ps} {3385333 ps}
