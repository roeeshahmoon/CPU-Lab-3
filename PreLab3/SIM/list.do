onerror {resume}
add list -width 9 /tb/rst
add list /tb/ena
add list /tb/clk
add list /tb/done
add list /tb/ProgMemTBDataIn
add list /tb/DataMemTBDataIn
add list /tb/DataMemDataOut
add list /tb/ProgMemTBWren
add list /tb/DataMemTBWren
add list /tb/ProgMemTbWAddr
add list /tb/DataMemTbRAddr
add list /tb/DataMemTbWAddr
add list /tb/TBactive
add list /tb/doneProgMem
add list /tb/doneDataMem
add list /tb/doneDataMemRead
configure list -usestrobe 0
configure list -strobestart {0 ps} -strobeperiod {0 ps}
configure list -usesignaltrigger 1
configure list -delta collapse
configure list -signalnamewidth 0
configure list -datasetprefix 0
configure list -namelimit 5
