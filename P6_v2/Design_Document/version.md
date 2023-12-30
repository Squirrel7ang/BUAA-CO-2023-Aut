### Changes in the second version
1. in `mips.v`, change the source of signal `e_md_stall`.
```Verilog
    assign e_md_stall = (e_md_start || e_busy) && (d_md_type != `mdu_none);
```
2. in `E_MDU.v`, delete `Stall` signal, including the one in `mips.v`

3. in `M_REG.v` delete signal `MDStall`, but no need to delete the port

    > 71 &ensp;&ensp;&ensp;&ensp;if (Reset ~~|| MDStall~~) begin

4. in `E_REG.v` merge Stall block and MDStall block 
5. in `E_MDU`, add `type_reg` in **declaration**, **reset** block, **Start** block and **(state == 1)** block