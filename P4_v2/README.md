# Design Document - P4

文档包括三个部分: 
1. CPU设计
2. 思考题及回答
3. 测试方案



## 第一部分：CPU设计草稿及说明
本次课下P3所设计的CPU需要满足以下指令：
|Ins    |31-26  |25-21  |20-16  |15-11      |10-6   |5-0    |
|-------|-------|-------|-------|-----------|-------|-------|
|       |Opcode |       |       |           |       |Func   |
|add    |000000 |rs_5   |rt_5   |rd_5       |00000  |100000 |
|sub    |000000 |rs_5   |rt_5   |rd_5       |00000  |100010 |
|ori    |001101 |rs_5   |rt_5   |imm_16     |       |       |
|lw     |100011 |base_5 |rt_5   |offset_16  |       |       |
|sw     |101011 |base_5 |rt_5   |offset_16  |       |       |
|beq    |000100 |rs_5   |rt_5   |offset_16  |       |       |
|lui    |001111 |00000  |rt_5   |imm_16     |       |       |
|nop    |000000 |00000  |00000  |00000      |00000  |000000 |
|jal    |000011 |imm_26 |       |           |       |       |
|jr     |000000 |rs_5   |00000  |00000      |00000  |001000 |

下面分不同模块对指令进行说明:eyes:

### 1. CTRL:fire:
#### 介绍
产生控制信号，无他。

CTRL的输出在不同的指令下体现如下：
|Output         |add    |sub    |ori    |beq    |sw     |lw     |lui    |jal    |jr     |
| :--:          | :--:  | :--:  | :--:  | :--:  | :--:  | :--:  | :--:  | :--:  | :--:  |
|MemWrite       |0      |0      |0      |0      |1      |0      |0      |0      |0      |
|RegWrite       |1      |1      |1      |0      |0      |1      |1      |1      |0      |
|Jr             |0      |0      |0      |0      |0      |0      |0      |0      |1      |
|Jump           |0      |0      |0      |0      |0      |0      |0      |1      |0      |
|Branch         |0      |0      |0      |1      |0      |0      |0      |0      |0      |
|ExtOp          |0      |0      |0      |1      |1      |1      |0      |0      |0      |
|ALUSrc         |0      |0      |1      |0      |1      |1      |1      |0      |0      |
|ALUOp[3:0]     |add    |sub    |or     |add    |add    |add    |lui    |default|default|
|RegDst[1:0]    |rd     |rd     |rt     |default|rt     |rt     |rt     |ra     |default|
|RegDataSrc[1:0]|alu    |alu    |alu    |default|default|mem    |alu    |pc     |pc     |
|MemType        |word   |word   |word   |word   |word   |word   |word   |word   |word   |

#### 端口定义
|信号名 |方向   |位宽   |描述   |
|:--:|:--:|:--:|:--|
|Op         |I  |6  |指令的高6位    |
|Func       |I  |32 |指令的低6位    |
|MemWrite   |O  |1  |是否有内存写入|
|RegWrite   |O  |1  |是否有需要对寄存器进行写入|
|Jr         |O  |1  |判断是否执行Jr指令|
|Jump       |O  |1  |判断是否需要执行J类型指令|
|Branch     |O  |1  |是否是分支类型的指令|
|ExtOp      |O  |1  |对立即数的扩展是否是符号扩展|
|ALUSrc     |O  |1  |决定ALU的第二位操作数来源于寄存器还是立即数扩展|
|ALUOp      |O  |4  |ALU操作指令，详见ALU|
|RegDst     |O  |2  |写入的寄存器是否是rd|
|RegDateSrc |O  |2  |判断grf的WriteData的来源|
|MemType    |O  |2  |判断写入内存的类型是word, half还是byte|

### 2. ALU:zap:
#### 介绍
`ALUOp[3:0]`是传输给ALU的信号，用以控制ALU的运算。详细的规定如下：
|ALUOp[3:0] |作用               |备注           |
|:----:     |:---               |   :--         |
|`alu_add   |result = A + B     |               |
|`alu_sub   |result = A - B     |               |
|`alu_or    |result = A \| B    |               |
|`alu_lui   |result = B << 16   |               |

#### 端口定义
|信号名 |方向   |位宽   |描述   |
|:--:|:--:|:--:|:--:|
|ALUOp  |I  |4  |操作指令       |
|A      |I  |32 |第一位操作数   |
|B      |I  |32 |第一位操作数   |
|ZF     |O  |1  |Zero Flag      |
|Result |O  |32 |结果           |

* 注：
1. 采用Macro对ALUOp的操作进行进行说明，增强可读性。只需要保证所有ALUOp的Macro不同即可。
2. `ALUOp`采用了4位的位宽实现，是基于课上对指令进行拓展测试时超出2位位宽的潜在可能

### 3. DM:ocean:
#### 介绍
`DM`和`IFU`都涉及到*Memory access*的问题。这次本次P3最大的特点在于采用32位RAM和ROM而非8位的，因此在访问的过程中无须考虑以`byte` `half-word`的单位的访存操作。在之后的设计中应该要考虑将8位的RAM和ROM进行位扩展再进行存储。

DM中RAM拥有12位地址线和32位数据线。
#### 端口定义
|信号名 |方向   |位宽   |描述   |
|:--:|:--:|:--:|:--:|
|Clk        |I  |1  |时钟信号   |
|WE         |I  |1  |写使能信号 |
|Reset      |I  |1  |异步复位信号   |
|Addr       |I  |32 |所选数据的地址   |
|Data       |I  |32 |写入的数据   |
|PC         |I  |32 |用于输出     |
|Out        |O  |32 |读取的数据   |

#### 功能说明
|功能名称|功能描述  |
|:---:|:---:|
|写入数据   |当WE信号为高电平时，在Clk上升沿将WriteData写入<br>DataAddr对应RAM内存中|
|读取数据   |当RE信号为高电平时，将RAM在DataAddr处的数据读取<br>至Out中|
|重置       |Reset信号为高电平时，将RAM中的数据全部置零|

### 4. IFU:deciduous_tree:
#### 介绍
IFU模块用于存储指令，将当前指令输出至输出端并根据输入信号计算出下一条指令的位置和内容

#### 端口定义
|信号名 |方向   |位宽   |描述   |
|:--:|:--:|:--:|:--:|
|Clk        |I  |1  |时钟信号|
|Reset      |I  |1  |异步复位信号|
|ZF         |I  |1  |用于判断`beq`指令|
|Branch     |I  |1  |分支信号|
|Jump       |I  |1  |j类型指令|
|Jr         |I  |1  |jr指令|
|OffSet16   |I  |16 |16位偏移量，用于`Branch`类型指令|
|Offset26   |I  |26 |26位偏移量，用于J类型指令|
|Ra         |I  |32 |跳转寄存器的值，用于`jr`指令|
|Op         |O  |6  |OpCode，ins[31:26]|
|Rs         |O  |6  |ins[25:21]|
|Rt         |O  |6  |ins[20:16]|
|Rd         |O  |6  |ins[15:11]|
|Shamt      |O  |6  |ins[10:6]|
|Func       |O  |6  |Func，ins[5:0]|
|Imm16      |O  |16 |ins[15:0]
|Imm26      |O  |26 |ins[25:0]
|PC         |O  |32 |程序计数器值|

#### 功能说明
|功能名称   |功能描述   |
|:---:|:---:|
|分支指令|当IfBranch信号为高电平时，将PC置为`PC + 4 + Offset`|
|J类指令|当Jump信号为高电平时，将PC置位${\{PC[31:28], \{Offset26\}, 2'b00\}}$|
|Jr指令 |当Jr信号为高电平时，将PC置位`Ra`|
|指令递增|将PC置为`PC + 4`|

* **注**：当前IFU未实现J类指令，因此没有将J类指令的低26位接入IFU的考虑。


### 5. GRF:maple_leaf:
#### 介绍
GRF采用P0所设计的GRF，除了适当调整模块外观以外没有其他变化。

下述端口定义和功能实现主要参考P0中对于GRF的说明
#### 端口定义
|信号名 |方向   |位宽   |描述   |
|:--:|:--:|:--:|:--:|
|Clk    |I  |1  |时钟信号   |
|Reset  |I  |1  |异步复位信号   |
|WE     |I  |1  |写使能信号   |
|A1     |I  |5  |5位地址输入信号，指定32个寄存器中的一个，<br>将其中存储的数据读出到`RD1`   |
|A2     |I  |5  |5位地址输入信号，指定32个寄存器中的一个，<br>将其中存储的数据读出到`RD2`|
|A3     |I  |5  |5位地址输入信号，指定32个寄存器中的一个<br>`RD1`将其中储存的数据读出到`RD2`|
|WD     |I  |32 |32位数据输入   |
|PC     |I  |32 |用于输出       |
|RD1    |O  |32 |`A1`对应的寄存器数据   |
|RD2    |O  |32 |`A2`对应的寄存器数据   |


#### 功能说明
|功能名称   |功能描述   |
|:---:|:---:|
|复位   |`reset`信号有效时将所有寄存器异步复位|
|读数据 |将`A1`，`A2`寄存器中的数据读出到`RD1`，`RD2`|
|写数据 |`WE`高电平时在时钟上升沿将`WD`写入`A3`对应寄存器|

### 6. Ext:rocket:
#### 介绍
Ext模块用于将16位的输入输入信号根据ExtOp选择性地进行零扩展或符号扩展到32位

#### 端口定义
|信号名 |方向   |位宽   |描述   |
|:--:|:--:|:--:|:--:|
|In |I  |16 |输入信号|
|ExtOp  |I  |1  |扩展操作数<br>`0`表示零扩展<br>`1`表示符号扩展|
|ExtOut |O  |32 |扩展后的32位数|

#### 功能说明
|功能名称   |功能描述   |
|:---:|:---:|
|零扩展|将16位输入信号的高位补0扩展到32位并输出|
|符号扩展|将16位输入信号的高位补符号位扩展到32位并输出|




:fire::fire::fire::fire::fire::fire::fire::fire::fire::fire::fire::fire::fire::fire::fire::fire::fire::fire::fire::fire::fire::fire::fire::fire::fire::fire::fire::fire::fire::fire::fire:

## 第二部分：思考题 - P3

#### Q1:阅读下面给出的 DM 的输入示例中（示例 DM 容量为 4KB，即 32bit × 1024字），根据你的理解回答，这个 addr 信号又是从哪里来的？地址信号 addr 位数为什么是 [11:2] 而不是 [9:0] ？
![Question1](image.png)
> ### A1
> MIPS指令中内存地址的计算都是来自${base(Offset)}$，因此一定来源于ALU的加法计算结果。[11:2]是因为输入的地址是以字为单位寻址的，地址是4的整数倍，而存储的时候用的是32位存储，需要除以4，即右移2位进行寻址，即选中$[x:2]$位进行寻址。

#### Q2:思考上述两种控制器设计的译码方式，给出代码示例，并尝试对比各方式的优劣。
>至于表格的具体设计，则因人而异，可以记录下**指令对应的控制信号**如何取值，也可以记录下**控制信号每种取值所对应的指令**，在后面的 Project 中，这两种不同的译码方式将展现出各自的优劣，届时我们会再次对其进行详细分析。

> ### A2
> 首先，采用指令对应的控制信号取何值时，好处是在于能够清晰地看到每一条指令都产生了哪些控制信号，而坏处就在于当指令信号多了的时候会使得代码难以阅读；
>
> 相较而言，采用控制信号对应哪些指令的话，可读性固然增强了，但是当需要判断一条指令都产生了哪些控制信号的时候，可读性相对又减弱了。
>
> 代码如下：
```Verilog
module CTRL(
    input [5:0] Op,
    input [5:0] Func,

    output MemWrite,
    output RegWrite,
    output Jr,
    output Jump,
	output Branch,
    output ExtOp,
    output ALUSrc,
    output [3:0] ALUOp,
    output [1:0] RegDst,
    output [1:0] RegDataSrc,
    output [1:0] MemType
);
    wire add    =  (Op  ==  `op_spc && Func ==  `func_add);
    wire sub    =  (Op  ==  `op_spc && Func ==  `func_sub);
    wire jr     =  (Op  ==  `op_spc && Func ==  `func_jr );
    wire ori    =  (Op  ==  `op_ori);
    wire beq    =  (Op  ==  `op_beq);
    wire sw     =  (Op  ==  `op_sw );
    wire lw     =  (Op  ==  `op_lw );
    wire lui    =  (Op  ==  `op_lui);
    wire jal    =  (Op  ==  `op_jal);
//  指令对应的控制信号
always @(*) begin
    if (add) begin
        MemWrite    =   0           ;
        RegWrite    =   1           ;
        Jr          =   0           ;
        Jump        =   0           ;
        Branch      =   0           ;
        ExtOp       =   0           ;
        ALUSrc      =   0           ;
        ALUOp       =   `alu_add    ;
        RegDst      =   `a3_rd      ;
        RegDataType =   `wd_alu     ;
        MemType     =   `type_word  ;
    end
    else if (sub) begin
        MemWrite    =   0           ;
        RegWrite    =   1           ;
        Jr          =   0           ;
        Jump        =   0           ;
        Branch      =   0           ;
        ExtOp       =   0           ;
        ALUSrc      =   0           ;
        ALUOp       =   `alu_sub    ;
        RegDst      =   `a3_rd      ;
        RegDataType =   `wd_alu     ;
        MemType     =   `type_word  ;
    end
    else if (ori) begin
        MemWrite    =   0           ;
        RegWrite    =   1           ;
        Jr          =   0           ;
        Jump        =   0           ;
        Branch      =   0           ;
        ExtOp       =   0           ;
        ALUSrc      =   1           ;
        ALUOp       =   `alu_or     ;
        RegDst      =   `a3_rt      ;
        RegDataType =   `wd_alu     ;
        MemType     =   `type_word  ;
    end
    else if (jr) begin
        MemWrite    =   0           ;
        RegWrite    =   0           ;
        Jr          =   1           ;
        Jump        =   0           ;
        Branch      =   0           ;
        ExtOp       =   0           ;
        ALUSrc      =   0           ;
        ALUOp       =   `alu_add    ;
        RegDst      =   `a3_rd      ;
        RegDataType =   `wd_pc      ;
        MemType     =   `type_word  ;
    end
    else if (beq) begin
        MemWrite    =   0           ;
        RegWrite    =   0           ;
        Jr          =   0           ;
        Jump        =   0           ;
        Branch      =   1           ;
        ExtOp       =   1           ;
        ALUSrc      =   0           ;
        ALUOp       =   `alu_sub    ;
        RegDst      =   `a3_rt      ;
        RegDataType =   `wd_alu     ;
        MemType     =   `type_word  ;
    end
    else if (sw) begin
        MemWrite    =   1           ;
        RegWrite    =   0           ;
        Jr          =   0           ;
        Jump        =   0           ;
        Branch      =   0           ;
        ExtOp       =   1           ;
        ALUSrc      =   1           ;
        ALUOp       =   `alu_add    ;
        RegDst      =   `a3_rt      ;
        RegDataType =   `wd_alu     ;
        MemType     =   `type_word  ;
    end
    else if (lw) begin
        MemWrite    =   0           ;
        RegWrite    =   1           ;
        Jr          =   0           ;
        Jump        =   0           ;
        Branch      =   0           ;
        ExtOp       =   1           ;
        ALUSrc      =   1           ;
        ALUOp       =   `alu_add    ;
        RegDst      =   `a3_rt      ;
        RegDataType =   `wd_mem     ;
        MemType     =   `type_word  ;
    end
    else if (lui) begin
        MemWrite    =   0           ;
        RegWrite    =   1           ;
        Jr          =   0           ;
        Jump        =   0           ;
        Branch      =   0           ;
        ExtOp       =   0           ;
        ALUSrc      =   1           ;
        ALUOp       =   `alu_lui    ;
        RegDst      =   `a3_rt      ;
        RegDataType =   `wd_alu     ;
        MemType     =   `type_word  ;
    end
    else if (jal) begin
        MemWrite    =   0           ;
        RegWrite    =   1           ;
        Jr          =   0           ;
        Jump        =   0           ;
        Branch      =   0           ;
        ExtOp       =   0           ;
        ALUSrc      =   0           ;
        ALUOp       =   `alu_add    ;
        RegDst      =   `a3_ra      ;
        RegDataType =   `wd_pc      ;
        MemType     =   `type_word  ;
    end
    else begin // nop
        MemWrite    =   0           ;
        RegWrite    =   0           ;
        Jr          =   0           ;
        Jump        =   0           ;
        Branch      =   0           ;
        ExtOp       =   0           ;
        ALUSrc      =   0           ;
        ALUOp       =   `alu_add    ;
        RegDst      =   `a3_rd      ;
        RegDataType =   `wd_alu     ;
        MemType     =   `type_word  ;
    end
end

//  控制信号每种取值所对应的指令
    wire add    =  (Op  ==  `op_spc && Func ==  `func_add);
    wire sub    =  (Op  ==  `op_spc && Func ==  `func_sub);
    wire jr     =  (Op  ==  `op_spc && Func ==  `func_jr );
    wire ori    =  (Op  ==  `op_ori);
    wire beq    =  (Op  ==  `op_beq);
    wire sw     =  (Op  ==  `op_sw );
    wire lw     =  (Op  ==  `op_lw );
    wire lui    =  (Op  ==  `op_lui);
    wire jal    =  (Op  ==  `op_jal);
    assign MemWrite =   sw                  ? 1         : 0;
    assign RegWrite =   lw  || lui || jal 
                     || ori || add || sub   ? 1         : 0;

    assign Jr       =   jr                  ? 1         : 0;
    assign Jump     =   jal                 ? 1         : 0;
	assign Branch   =   beq                 ? 1         : 0;
    assign ExtOp    =   beq || sw  || lw    ? 1         : 0;
    assign ALUSrc   =   sw  || lw  || ori
                     || lui              	? 1         : 0;
    assign ALUOp    =   add || sw  || lw    ? `alu_add  :
                        sub || beq          ? `alu_sub  :
                        ori                 ? `alu_or   :
                        lui                 ? `alu_lui  :
                                              `alu_add;
    assign RegDst   =   add || sub          ? `a3_rd    :
                        jal                 ? `a3_ra    :
                        ori || sw  || lw
                     || lui                 ? `a3_rt    :
                                              `a3_rd;
    assign RegDataSrc = add || sub || ori 
                     || lui                 ? `wd_alu   :
                        lw                  ? `wd_mem   :
                        jal                 ? `wd_pc    :
                                              `wd_alu;
    assign MemType  =   sw  || lw           ? `type_w  :
                                              `type_w;



```

#### Q3:在相应的部件中，复位信号的设计都是<u>同步复位</u>，这与 P3 中的设计要求不同。请对比<u>同步复位</u>与<u>异步复位</u>这两种方式的 reset 信号与 clk 信号优先级的关系。
> ### A3
> **同步复位**的中reset的优先级明显**低于**clk信号，毕竟有了clk上升沿才能reset，没有clk上升沿就不能reset。
> 
> **异步复位**中则不同，个人认为reset信号优先级**高于**clk信号，毕竟当reset信号有效时，clk信号不论如何变化都不能起到任何作用。

#### Q4:C 语言是一种弱类型程序设计语言。C 语言中不对计算结果溢出进行处理，这意味着 C 语言要求程序员必须很清楚计算结果是否会导致溢出。因此，如果仅仅支持 C 语言，MIPS 指令的所有计算指令均可以忽略溢出。 请说明为什么在忽略溢出的前提下，addi 与 addiu 是等价的，add 与 addu 是等价的。提示：阅读《MIPS32® Architecture For Programmers Volume II: The MIPS32® Instruction Set》中相关指令的 Operation 部分。
> ### A4
> 这个问题从加法器的设计和补码数制中就能得到答案。不论是add还是addu，两者用的同一种加法器，addu和add的区别仅在于是将数视为有符号数还是无符号数，但是补码的好处就在于其加法规则与无符号数的加法规则是相同的，得到的结果仅取决于两个操作数的32位分别是0还是1。所以在不考虑溢出的情况下，即只考虑加法所得结果的情况下，两者得到的结果都是32位数。

---
:fire::fire::fire::fire::fire::fire::fire::fire::fire::fire::fire::fire::fire::fire::fire::fire::fire::fire::fire::fire::fire::fire::fire::fire::fire::fire::fire::fire::fire::fire::fire:

## 第三部分：测试方案

**先叙述个人对于评价测试样例强不强的判断指标。**

当前测试样例仅聚焦于测试CPU的正确性，因此样例的全面性（覆盖率）应当成为衡量测试样例的主要标准。个人认为全面性有几个方面的表现：
1. 指令种类的全面性。
2. 某一指令下是否涵盖尽量全面的情况。
3. 指令运行时CPU环境的多样性，比如初始条件下将寄存器先赋初值。这主要是为了发现bug。
4. 目标Register是否都有涵盖。这主要包含$0和$1-$31的寄存器测试.
5. 目标DM中的RAM的访存是否尽量有涵盖。这主要包括对地址边界的测试和边界内部的随机地址的测试。尽管在没有异常处理的P3中对边界条件的测试并不是那么重要。
6. 指令排布方式的全面性。当CPU设计存在缺陷时，指令之间可能会相互影响。

因此我认为MIPS_Pre的测试样例有以下几个问题：
1. `sw`和`lw`没有涉及到充分大的地址区域，也没有考虑`0x00002fff`处边界附近的lw和sw操作。
2. `sw`和`lw`为`Offset`作符号扩展，但却没有考虑到`Offset`为负数的情况。
3. `lui`、`ori`对于符号为负的情况只考虑了`-1`，即`0xffff`的情况，这对以负数不具有一般性，应该多写几个。

测试方案参考*第二部分-Q5*所提出的标准完成。需要注明的有以下几点：
1. 该方案只对\$2-\$25号寄存器进行读写，即$\$v_x$、$\$a_x$、$\$s_x$和$\$t_x$四类寄存器。
2. 考虑到检验的方便性，只对地址区间0x0000-0x0040的数据区域进行了读写
3. 由于时间原因无法完成计划的全部，未设置对边界条件的测试。
4. 测试聚焦于测试数据的随机性和符号性。

测试指令前半部分由C代码生成，附在课后题**P3_student_judge**的上传文件中。利用生成的测试样例在logisim中运行的结果与在MARS中运行的`Register`和`.Data`区域进行比对来验证是否正确。
具体来说，本人采用了以下样例进行测试：:point_down:
- 注：实际测试的指令过长，而且内容类似，故省略部分内容。

### 判断0号寄存器无法写入
```assembly
# $0 Test
lui $0, 0x861b
lui $0, 0x3cd8
lui $0, 0xe2
lui $0, 0x4ef4
```

### 为寄存器赋随机初始值
```assembly
# initialize reg
lui $2, 0xf65
ori $2, $0, 0x56
lui $3, 0x315a
ori $3, $0, 0x21b7
lui $4, 0x5991
ori $4, $0, 0x1da6
...
...
lui $23, 0x4bd3
ori $23, $0, 0x233f
lui $24, 0x4ea4
ori $24, $0, 0xbe5
lui $25, 0x5880
ori $25, $0, 0x5d87
```

### ori测试
```assembly
# oriTest
ori $2, $0, 0x7d5d
ori $3, $0, 0x32b4
ori $4, $0, 0x71ac
...
...
ori $23, $0, 0x7185
ori $24, $0, 0x47f2
ori $25, $0, 0x1805
```

### lui测试
```assembly
lui $2, 0x5eec
lui $3, 0x1146
lui $4, 0x1fb9
...
...
lui $23, 0x48ae
lui $24, 0xb3d
lui $25, 0x1146
```

### add测试
```assembly
# unsigned + unsigned
ori $2, $0, 0x513e
ori $3, $0, 0x2993
add $2, $2, $3
ori $2, $0, 0x6c8c
ori $3, $0, 0x41a8
add $3, $2, $3
ori $2, $0, 0x2269
ori $3, $0, 0x7157
add $4, $2, $3
...
...
ori $2, $0, 0x729d
ori $3, $0, 0x53b2
add $23, $2, $3
ori $2, $0, 0x141b
ori $3, $0, 0x6754
add $24, $2, $3
ori $2, $0, 0x31fc
ori $3, $0, 0x3ffd
add $25, $2, $3

# signed + unsigned
ori $2, $0, 0x1bbb
ori $3, $0, 0x4c2c
add $2, $2, $3
ori $2, $0, 0xfffffa8b
ori $3, $0, 0x544c
add $3, $2, $3
ori $2, $0, 0xffffe89f
ori $3, $0, 0x1a52
add $4, $2, $3
...
...
ori $2, $0, 0x6524
ori $3, $0, 0xffffc35a
add $23, $2, $3
ori $2, $0, 0x5063
ori $3, $0, 0xfffffbb7
add $24, $2, $3
ori $2, $0, 0x6a1f
ori $3, $0, 0xffffd2ad
add $25, $2, $3

# signed + signed
ori $2, $0, 0xfffff367
ori $3, $0, 0xffffe0fc
add $2, $2, $3
ori $2, $0, 0x199f
ori $3, $0, 0xffffd97d
add $3, $2, $3
ori $2, $0, 0xffffd2bd
ori $3, $0, 0x19e5
add $4, $2, $3
...
...
ori $2, $0, 0xffffe266
ori $3, $0, 0xffffff4d
add $23, $2, $3
ori $2, $0, 0x1564
ori $3, $0, 0x182c
add $24, $2, $3
ori $2, $0, 0xffffde61
ori $3, $0, 0x70a
add $25, $2, $3
```

### sub测试
```assembly
# unsigned - unsigned
ori $2, $0, 0x65e3
ori $3, $0, 0x5a49
sub $2, $2, $3
ori $2, $0, 0x6a73
ori $3, $0, 0x3d1
sub $3, $2, $3
ori $2, $0, 0x6452
ori $3, $0, 0x5e74
sub $4, $2, $3
...
...
ori $2, $0, 0x5c0f
ori $3, $0, 0x4718
sub $23, $2, $3
ori $2, $0, 0x66ab
ori $3, $0, 0x355b
sub $24, $2, $3
ori $2, $0, 0x12c2
ori $3, $0, 0x691a
sub $25, $2, $3

# signed - unsigned
ori $2, $0, 0x3a18
ori $3, $0, 0x2ffd
sub $2, $2, $3
ori $2, $0, 0xffffee62
ori $3, $0, 0x6e6
sub $3, $2, $3
ori $2, $0, 0xffffe274
ori $3, $0, 0x43ea
sub $4, $2, $3
...
...
ori $2, $0, 0xffffcb40
ori $3, $0, 0x725f
sub $23, $2, $3
ori $2, $0, 0xe51
ori $3, $0, 0x1800
sub $24, $2, $3
ori $2, $0, 0xffffea11
ori $3, $0, 0x5370
sub $25, $2, $3

# unsigned - signed
ori $2, $0, 0x6d4c
ori $3, $0, 0xffffc044
sub $2, $2, $3
ori $2, $0, 0x74e9
ori $3, $0, 0x2a3f
sub $3, $2, $3
ori $2, $0, 0x409b
ori $3, $0, 0x5e3
sub $4, $2, $3
...
...
ori $2, $0, 0x2756
ori $3, $0, 0xffffd103
sub $23, $2, $3
ori $2, $0, 0x66ab
ori $3, $0, 0xffffc716
sub $24, $2, $3
ori $2, $0, 0x795e
ori $3, $0, 0xfffffcde
sub $25, $2, $3

# signed - signed
ori $2, $0, 0xffffe906
ori $3, $0, 0x2f87
sub $2, $2, $3
ori $2, $0, 0xfffffbca
ori $3, $0, 0x359e
sub $3, $2, $3
ori $2, $0, 0xfffff27e
ori $3, $0, 0xffffea39
sub $4, $2, $3
...
...
ori $2, $0, 0xffffddf1
ori $3, $0, 0xffffdb29
sub $23, $2, $3
ori $2, $0, 0xffffd252
ori $3, $0, 0x3bd8
sub $24, $2, $3
ori $2, $0, 0xfffffff7
ori $3, $0, 0x2878
sub $25, $2, $3
```

### sw测试
```assembly

lui $2, 0x6b0d
ori $2, $0, 0x1a73
ori $3, $0, 0x0
sw $2, 0x4($3)

lui $3, 0x5413
ori $3, $0, 0x7308
ori $4, $0, 0x10
sw $3, 0x10($4)

lui $4, 0x1895
ori $4, $0, 0x35ce
ori $5, $0, 0x14
sw $4, 0x8($5)
...
...
lui $23, 0x2a0d
ori $23, $0, 0x2e43
ori $24, $0, 0x18
sw $23, 0xfffffffc($24)

lui $24, 0x344a
ori $24, $0, 0x51ae
ori $25, $0, 0x30
sw $24, 0xffffffd4($25)

lui $25, 0x569f
ori $25, $0, 0x408c
ori $2, $0, 0x8
sw $25, 0x30($2)
```
### lw测试
```assembly
lui $2, 0x5e5f
ori $2, $0, 0xcaf
ori $3, $0, 0x30
lw $2, 0xffffffd0($3)

lui $3, 0x5f70
ori $3, $0, 0x53a
ori $4, $0, 0x18
lw $3, 0x20($4)

lui $4, 0x155a
ori $4, $0, 0x6364
ori $5, $0, 0x28
lw $4, 0xfffffff4($5)
...
...
lui $23, 0x5414
ori $23, $0, 0x5d5c
ori $24, $0, 0xc
lw $23, 0xfffffff4($24)

lui $24, 0x65f1
ori $24, $0, 0x1f7d
ori $25, $0, 0x38
lw $24, 0xffffffd0($25)

lui $25, 0x15f0
ori $25, $0, 0x5a74
ori $2, $0, 0x3c
lw $25, 0xffffffd0($2)
```

### jal && jr 测试
```assembly
.text
  beq $0, $0, L1
  L2:
    ori $t3, $0, 0x8000
    ori $t1, $0, 0x1000
    add $t2, $t2, $t1
    beq $t2, $t3, L3
    add $t2, $t2, $t1
    beq $t2, $t3, L3
    add $t2, $t2, $t1
    beq $t2, $t3, L3
    add $t2, $t2, $t1
    beq $t2, $t3, L3
    add $t2, $t2, $t1
    beq $t2, $t3, L3
    add $t2, $t2, $t1
    beq $t2, $t3, L3
    add $t2, $t2, $t1
    beq $t2, $t3, L3
    add $t2, $t2, $t1
    beq $t2, $t3, L3
  L3:
    jr $ra
  
  
  L1:
  lui $t0, 0xffff
  ori $t0, $t0, 0xffff
  jal L2
  ori $t0, $0, 0
  ori $t1, $0, 0x8
  ori $t2, $0, 0x1
  L4:
    beq $t0, $t1, L5
    add $t0, $t0, $t2
    beq $t0, $t1, L4
    add $t0, $t0, $t2
    beq $t0, $t1, L4
    add $t0, $t0, $t2
    beq $t0, $t1, L4
    add $t0, $t0, $t2
    beq $t0, $t1, L4
    add $t0, $t0, $t2
    beq $t0, $t1, L4
    add $t0, $t0, $t2
    beq $t0, $t1, L4
    add $t0, $t0, $t2
    beq $t0, $t1, L4
    add $t0, $t0, $t2
    beq $t0, $t1, L4
    add $t0, $t0, $t2
    beq $t0, $t1, L4
  L5:
  nop
  jal L6
  nop
  nop
  ... # 700 * nop
  nop
  nop

  L6:
  ori $t1, $t1, 0x1234
  nop
```