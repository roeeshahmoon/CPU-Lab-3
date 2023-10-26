onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate /tb/rst
add wave -noupdate /tb/ena
add wave -noupdate /tb/clk
add wave -noupdate /tb/done
add wave -noupdate /tb/ProgMemTBDataIn
add wave -noupdate /tb/DataMemTBDataIn
add wave -noupdate /tb/DataMemDataOut
add wave -noupdate /tb/ProgMemTBWren
add wave -noupdate /tb/DataMemTBWren
add wave -noupdate /tb/ProgMemTbWAddr
add wave -noupdate /tb/DataMemTbRAddr
add wave -noupdate /tb/DataMemTbWAddr
add wave -noupdate /tb/TBactive
add wave -noupdate /tb/doneProgMem
add wave -noupdate /tb/doneDataMem
add wave -noupdate /tb/doneDataMemRead
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {4287885 ps} 0}
quietly wave cursor active 1
configure wave -namecolwidth 274
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
WaveRestoreZoom {0 ps} {14742912 ps}
