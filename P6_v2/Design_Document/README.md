# Design Document


## 指令支持

本次课下P6总共需要实现指令一共28条，其中
* R类算术指令6条： add, and, or, slt, sltu, sub
* I类算术指令4条： addi, andi, lui, ori
* Jr类指令1条： jr
* Jump类指令1条： jal
* branch类指令2条： beq, bne
* 乘除指令4条： mult, multu, div, divu
* HILO指令4条： mfhi, mflo, mthi, mtlo
* load类指令3条： lb, lh, lw
* store类指令3条： sb, sh, sw

指令按照字典序排序为：
`add`,     `addi`,    `and`,     `andi`,
`beq`,     `bne`,     `div`,     `divu`,
`jal`,     `jr`,      `lb`,      `lh`,
`lui`,     `lw`,      `mfhi`,    `mflo`,
`mthi`,    `mtlo`,    `mult`,    `multu`,
`ori`,     `or`,      `sb`,      `sh`,
`slt`,     `sltu`,    `sub`,     `sw`



## 控制器
采用**集中式译码**

可以根据不同级的结果改变控制信号

控制信号有：
|       | MemWrite | RegWrite | Jr | Jump | Branch | ExtOp | ALUASrc | ALUBSrc | RegDst | RegDataSrc | MemType | TUseRs | TUseRt | Tnew | ALUOp | CmpOp |
|:-----:|:--------:|:--------:|:--:|:----:|:------:|:-----:|:-------:|:-------:|:------:|:----------:|:-------:|:------:|:------:|:----:|:-----:|:-----:|
| add   | 0        | 1        | 0  | 0    | 0      | 0     | rd1     | rd2     | rd     | alu        | dft     | 1      | 1      | 3    | add   | dft   |
| addi  | 0        | 1        | 0  | 0    | 0      | 0     | rd1     | imm     | rt     | alu        | dft     | 1      |$\infty$| 3    | add   | dft   |
| and   | 0        | 1        | 0  | 0    | 0      | 0     | rd1     | rd2     | rd     | alu        | dft     | 1      | 1      | 3    | and   | dft   |
| andi  | 0        | 1        | 0  | 0    | 0      | 0     | rd1     | imm     | rt     | alu        | dft     | 1      |$\infty$| 3    | and   | dft   |
| beq   | 0        | 0        | 0  | 0    | 1      | 1     | dft     | dft     | dft    | dft        | dft     | 0      | 0      | 0    | dft   | beq   |
| bne   | 0        | 0        | 0  | 0    | 1      | 1     | dft     | dft     | dft    | dft        | dft     | 0      | 0      | 0    | dft   | bne   |
| div   | 0        | 0        | 0  | 0    | 0      | 0     | rd1     | rd2     | dft    | dft        | dft     | 1      | 1      | 0    | dft   | dft   |
| divu  | 0        | 0        | 0  | 0    | 0      | 0     | rd1     | rd2     | dft    | dft        | dft     | 1      | 1      | 0    | dft   | dft   |
| jal   | 0        | 1        | 0  | 1    | 0      | 0     | dft     | dft     | ra     | pc         | dft     |$\infty$|$\infty$| 3    | dft   | dft   |
| jr    | 0        | 0        | 1  | 0    | 0      | 0     | dft     | dft     | dft    | dft        | dft     | 0      |$\infty$| 0    | dft   | dft   |
| lb    | 0        | 1        | 0  | 0    | 0      | 1     | rd1     | imm     | rt     | mem        | type_b  | 1      | 2      | 4    | dft   | dft   |
| lh    | 0        | 1        | 0  | 0    | 0      | 1     | rd1     | imm     | rt     | mem        | type_h  | 1      | 2      | 4    | dft   | dft   |
| lui   | 0        | 1        | 0  | 0    | 0      | 0     | rd1     | imm     | rt     | alu        | dft     | 1      |$\infty$| 3    | lui   | dft   |
| lw    | 0        | 1        | 0  | 0    | 0      | 1     | rd1     | imm     | rt     | mem        | type_w  | 1      | 2      | 4    | dft   | dft   |
| mfhi  | 0        | 1        | 0  | 0    | 0      | 0     | dft     | dft     | rd     | hi/lo      | dft     |$\infty$|$\infty$| 3    | dft   | dft   |
| mflo  | 0        | 1        | 0  | 0    | 0      | 0     | dft     | dft     | rd     | hi/lo      | dft     |$\infty$|$\infty$| 3    | dft   | dft   |
| mthi  | 0        | 0        | 0  | 0    | 0      | 0     | dft     | dft     | dft    | dft        | dft     | 1      |$\infty$| 0    | dft   | dft   |
| mtlo  | 0        | 0        | 0  | 0    | 0      | 0     | dft     | dft     | dft    | dft        | dft     | 1      |$\infty$| 0    | dft   | dft   |
| mult  | 0        | 0        | 0  | 0    | 0      | 0     | rd1     | rd2     | dft    | dft        | dft     | 1      | 1      | 0    | dft   | dft   |
| multu | 0        | 0        | 0  | 0    | 0      | 0     | rd1     | rd2     | dft    | dft        | dft     | 1      | 1      | 0    | dft   | dft   |
| ori   | 0        | 1        | 0  | 0    | 0      | 0     | rd1     | imm     | rt     | alu        | dft     | 1      |$\infty$| 3    | or    | dft   |
| or    | 0        | 1        | 0  | 0    | 0      | 0     | rd1     | rd2     | rd     | alu        | dft     | 1      | 1      | 3    | or    | dft   |
| sb    | 1        | 0        | 0  | 0    | 0      | 1     | rd1     | imm     | dft    | dft        | type_b  | 1      | 2      | 0    | dft   | dft   |
| sh    | 1        | 0        | 0  | 0    | 0      | 1     | rd1     | imm     | dft    | dft        | type_h  | 1      | 2      | 0    | dft   | dft   |
| slt   | 0        | 1        | 0  | 0    | 0      | 0     | rd1     | rd2     | rd     | alu        | dft     | 1      | 1      | 3    | slt   | dft   |
| sltu  | 0        | 1        | 0  | 0    | 0      | 0     | rd1     | rd2     | rd     | alu        | dft     | 1      | 1      | 3    | sltu  | dft   |
| sub   | 0        | 1        | 0  | 0    | 0      | 0     | rd1     | rd2     | rd     | alu        | dft     | 1      | 1      | 3    | sub   | dft   |
| sw    | 1        | 0        | 0  | 0    | 0      | 1     | rd1     | imm     | dft    | dft        | type_w  | 1      | 2      | 0    | dft   | dft   |


* Note: 
    1. "TNew" refers to the $T_{New}$ in Level F.
    2. passing ctrl signal by a 31 length vector.
    3. $\infty$ can be relized by value 3 in TUse.
* changes in P6:
    1. RegDataSrc has **no need** to change into 3 bits

## 顶层设计

设计文档有很多地方说不清楚，所以附了一张电路图
![top_design](CIRC.png)

## 思考题
> 1、为什么需要有单独的乘除法部件而不是整合进ALU？为何需要有独立的HI、LO 寄存器？

&ensp;&ensp;&ensp;&ensp;首先，乘除指令的运算与之前我们在 ALU 中实现的运算在运算时间上相差极大。在实际上的流水线 CPU 中，我们在多数时候希望能让每一条指令只占用相应的部件。
&ensp;&ensp;&ensp;&ensp;因此，如果整合进 ALU 里面，带来的问题就是ALU会被长时间占用。在我们设计的 CPU 当中固然没有问题，毕竟我们是使用阻塞来处理乘除法指令的长时间运算问题的。但是在实际的更高级的流水线当中，在乘除法运行时我们可能会用这段时间去运算其他不受乘除法影响的指令，这个时候如果把乘除法模块分离出来，就可以空出 ALU 模块。 HI/LO 寄存器也是同样的道理，他的出现也是为了把乘除法指令分离出来， 单独存储乘除法指令的运算结果，使之不妨碍其他指令的运算。

> 2、真实的流水线 CPU 是如何使用实现乘除法的？请查阅相关资料进行简单说明。

&ensp;&ensp;&ensp;&ensp;查了一波，虽然不是很明白具体是怎么实现的，但是大概就是把乘除法模块内置一个流水线，或者说有限状态机吧。然后每一个状态转移的由外置的时钟信号控制。既然一个时钟信号算不完，乘除模块就把乘除法分成多个阶段，每一个阶段算一点，每个时钟周期跳转到下一个阶段。但是具体怎么算我确实不知道。

&ensp;&ensp;&ensp;&ensp;对于乘法来说，实际上似乎有一个Booth变换，和一个3-2、4-2压缩来加速；除法后面好像开发出了一个SRT除法，但是具体就没有深究了。

> 3、请结合自己的实现分析，你是如何处理 Busy 信号带来的周期阻塞的？

&ensp;&ensp;&ensp;&ensp;附两张电路图。第一张是教程的，第二张是我的。

![Tutorial_mult](image.png)

![My_mult](image-1.png)

&ensp;&ensp;&ensp;&ensp;

&ensp;&ensp;&ensp;&ensp;老实说我认为我的 Busy 信号处理的并不好。因为从图中可以看出，严格来说，我的 Busy 信号是没有起到任何实际作用的，因为我的CPU在Busy信号由有效转变为无效的时钟上升沿就让 CPU 流水起来了，也就是说我的乘除模块在Busy信号的最后一个周期就已经没有向外界输出阻塞信号了。如果课上因为这个原因没有通过测评，那我就会将阻塞信号再延长一个周期——这不是什么难事。

> 4、请问采用字节使能信号的方式处理写指令有什么好处？（提示：从清晰性、统一性等角度考虑）

&ensp;&ensp;&ensp;&ensp;最大的好处就在于清晰明了吧：程序员可以直观地看到哪个字节需要写入，哪个不需要。而且独热码也省去了译码的麻烦，而代价只不过是多了两条线。

> 5、请思考，我们在按字节读和按字节写时，实际从 DM 获得的数据和向 DM 写入的数据是否是一字节？在什么情况下我们按字节读和按字节写的效率会高于按字读和按字写呢？

&ensp;&ensp;&ensp;&ensp;没有太读懂题目... :sweat_smile:获得的数据是4字节，而写入的数据也是4字节。只不过按照官方给出的tb的意思，当写入的地址没有字对齐的时候，需要将写入的数据做一个移位再传入m_data_wdata，因此有效的数据和指令与地址有关。不知道题目是不是这个意思:cold_sweat:

&ensp;&ensp;&ensp;&ensp;效率低的原因在于写入的数据是由先读出的数据与写入的数据共同决定的，先读出数据这一点花费了不少时间。想要效率高只需要让 DM 作一个位扩展的反操作——以8位作1字——就可以免去预先读出数据所花费的时间了。

> 6、为了对抗复杂性你采取了哪些抽象和规范手段？这些手段在译码和处理数据冲突的时候有什么样的特点与帮助？

* 在译码器方面，采用集中式译码的同时，这些译码出来的控制信号其实也完成了指令的初步分类。

* 采用了大量宏定义

* 增加了 MDU, M_DM_BYTEEN, M_DM_EXT 三个模块，对新增的模块构造了 tb 保证正确后将其封装。

> 7、在本实验中你遇到了哪些不同指令类型组合产生的冲突？你又是如何解决的？相应的测试样例是什么样的？

个人感觉基本没有新增加的冲突。

* `lui`和`bne`指令的冲突让我吃亏了，而事实证明这个在P5就需要考虑的冲突因为P6重写控制信号但是漏掉了lui的TNew而害我de了两天的bug。
* `mfhi`、`mflo`、`mthi`和`mtlo`带来的数据冲突可能需要单独考虑一下，毕竟之前没遇到过这一类指令，但是在充分考虑过后我认为他和一般的算术类指令没有区别:joy:
* `mult`、`multu`、`div`和`divu`带来的数据冒险可能是相较P5最大的难点。主要差别在于：之前的 Stall 信号是让 D 级指令保持在 D 级，而这次是要让E级的指令保持在E级。而且最重要的是， GRF 就在 D 级， D 级如果接收转发但是不保存的话也没问题，毕竟可以随时读取出来。但是 E 级没有 GRF ，也就是说E级如果接受了转发但是不保存下来的话会出大问题（错了一遍才明白为什么教程这么写:joy:）;&ensp;&ensp;&ensp;&ensp;此外就是暂定的时候不能让 E 流水寄存器和 D 级暂定的时候一样输出 nop 指令，而且 M 级寄存器也要判断一下。此外应该就没差别了。

> 8、如果你是手动构造的样例，请说明构造策略，说明你的测试程序如何保证覆盖了所有需要测试的情况；如果你是完全随机生成的测试样例，请思考完全随机的测试程序有何不足之处；如果你在生成测试样例时采用了特殊的策略，比如构造连续数据冒险序列，请你描述一下你使用的策略如何结合了随机性达到强测的效果。

&ensp;&ensp;&ensp;&ensp;我确实是手动构造的样例，但是也不能说特别强吧。
* 首先，我验证了一下每一个单条条指令对不对。
* 其次，保证算术指令的正确性，并充分考虑算术指令之间的数据冲突。
* 然后，我构造了乘除指令，并验证了乘除指令与算术指令之间的数据冲突。
* 最后，我构造了存储、读取指令，并将 TNew 比较大的读取指令与跳转指令和乘除指令做了数据冲突构造。
* 我深知我构造的数据覆盖性没有那么强，但是没想到我的 lui 和 bne 指令居然能出问题。花了两天 debug 我发现 lui 的 TNew 完全写错了，导致转发没有任何问题但是阻塞出了问题，因此转发也出了问题。:black_joker:
* 之后我还是自己搓一点强一点的数据点测一下吧，要不就老老实实检查好控制信号再写代码

> [P5、P6 选做] 请评估我们给出的覆盖率分析模型的合理性，如有更好的方案，可一并提出。

&ensp;&ensp;&ensp;&ensp;srds我是靠测评点活过这一周的:sob::sob::sob: