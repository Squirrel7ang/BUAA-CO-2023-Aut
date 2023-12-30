# BUAA Computer Organization 
## —— P1 preperation
### Moore & Mealy Finate State Machine Example
Moore fsm example:
```Verilog
/* P1_L0_expression_state_machine */
module expr (
        input clk,
        input clr,
        input [7:0] in,
        output out
    );

    localparam [1:0] s0 = 2'b00, //  no input
                     s1 = 2'b01, // digit input
                     s2 = 2'b10, // sign input
                     s3 = 2'b11; // wrong input
    reg [1:0] state;
	 
	initial begin
	    state <= 2'b00;
	end
	 
	assign out = (clr == 1) ? 1'b0 : 
				 (state == s1) ? 1'b1 :
				 1'b0;
    always @(posedge clk or posedge clr) begin
		  state <= (clr == 1'b1) ? 2'b00 :
				   (state == s0 && in >= "0" && in <= "9") ? s1 :
				   (state == s1 && in == "+" || in == "*") ? s2 :
			       (state == s2 && in >= "0" && in <= "9") ? s1 :
				   s3;
    end
endmodule
```
Mealy fsm example:
```Verilog
/* P1_L0_expression_state_machine */
module expr (
        input clk,
        input clr,
        input [7:0] in,
        output reg out
    );

    localparam [1:0]s0 = 2'b00, //  no input
                    s1 = 2'b01, // digit input
                    s2 = 2'b10, // sign input
                    s3 = 2'b11; // wrong input
	 reg [1:0] state;
    initial begin
        state   <= 2'b00;
		out     <= 1'b0;
    end

    always @(posedge clk or posedge clr) begin
		state   <=  (clr == 1'b1) ? 2'b00 :
				    (state == s0 && in >= "0" && in <= "9") ? s1 :
				    (state == s1 && in == "+" || in == "*") ? s2 :
			        (state == s2 && in >= "0" && in <= "9") ? s1 :
				    s3;
        out     <=  (clr == 1'b1) ? 1'b0 :
                    ((state == s2 || state == s0) && in >= "0" && in <= "9") ? 1'b1 :
                    1'b0;
    end
endmodule
```
### About State
Use $localparam$ to identify differnt states. 
 
$Parameter$ can also be used to identify states, but pay attention that the parameter one define can pass through different module. In a word, $parameter$ is pubilc, while $localparam$ is private.
```Verilog
/* Declaration of different state */
module moduleName (
        input clk,
        input slr,
        ...
        output reg Output
    );

    localparam [width-1:0]  s0 = ...
                            s1 = ...
                            ...
                            sn = ...
    reg [width-1:0] state;
    initial begin
        state <= s0;
    end
    ...
endmodule
```
### About Reset
Synchronized reset and asynchronous reset are another thing we need to consider about.
 
Synchronized reset is easy to realized. Asynchronous Reset is a little tricky. 
```Verilog
/* Synchronized reset */
always @(posedge clk) begin
    if (rst == 1'b1 || rst_n == 1'b0) begin
        /* reset everything here */
    end
    ...
end

/* Asynchonous reset by high level of clr */
always @(posedge clk or posedge clr) begin
    if (clr == 1'b1 || clr_n == 1'b0) begin
        /* reset everything here */
    end
    ...
end

/* Asynchonous reset by posedge of clr */
always @(posedge clr or negedge clr_n) begin
    /* reset everything here */
end

always @(posedge clk) begin
    ...
end
```
### About State Transition

State transition:
```Verilog
always @(posedge clk/* or posedge clr*/) begin
    if (...) begin
        /* Reset here */
    end
    /* using case clause */
    case(state)
        s0: begin /*using tenary operator */
            state <= (...) ? ... :
                     (...) ? ... :
                     ...
                     (...) ? ... :
                     ...;
        end
        s1: begin   /* using if-clause */
            if (.../* input condition */) begin

            end
        end
        ...
        sn: begin
            ...
        end
        default: begin
            ...
        end
    endcase

    /* using conditional (ternary) operator */
    state <= (state == s0 && Input...) ? ... :
             (state == s1) ? ... :
             ...
             (...) ? ... :
             ...;

    /* using if-clause */
    if (...) begin
        ...
    end
    else if (...) begin
        ...
    end
    ...
    else begin
        ...
    end
end
```
### About Type of Charactor
In C programming language, header <ctype.h> is convenient in judge the type of a certain charactor. In Verilog, there aren't any library as convenient as C. However, though a little complex, it can be realized in a way like this:
```Verilog
module moduleName(
    input [7:0] char;
);
wire isdigit = (char >= "0" && char <= "9") ? 1'b1 : 1'b0;
wire isupper = (char >= "A" && char <= "Z") ? 1'b1 : 1'b0;
wire islower = (char >= "a" && char <= "z") ? 1'b1 : 1'b0;
wire isalpha = islower | isupper;
wire true    = 1'b1;
endmodule
```
Then, we can identify the type of the input charactor using
```Verilog
if (isdigit == true) begin  /* if the input charactor is digit */
    ...
end
```
### About Signed integer Processing
When a signed figure is used in operation with others:
* if one of the operands is unsigned, other operands will be transfered into unsigned compulsively, then used in operation.
* if operands are all signed, the operands will all be signed.
* operation includes using ternary operator.

### About how to write a finate-state-machine in Verilog
> The following content is quoted from BUAA CO course website "cscore.buaa.edu.cn"

There are 3 ways in total to write a finate state machine: 1-proceedure, 2-proceedure and 3-proceedure version.
 
Just as their names implies, these methods use 1, 2 and 3 always proceedural block(s) in total respectively.
 
consider an examples like:
>clk 上升沿时，读入一个字符 in ，这时若1010是已读入的字符串的后缀，则 out 输出1，否则输出0。
 
#### 1-proceedure fsm 
a 1-proceedure moore fsm would be like:
```Verilog
integer state = 0;
always @(posedge clk) begin
    case (state)
    0: begin
        state <= in == 1 ? 1 : 0;
        out <= 0;
    end
    1: begin
        state <= in == 1 ? 1 : 2;
        out <= 0;
    end
    2: begin
        state <= in == 1 ? 3 : 0;
        out <= 0;
    end
    3: begin
        state <= in == 1 ? 1 : 4;
        out <= (in == 0);
    end
    4: begin
        state <= in == 1 ? 3 : 0;
        out <= 0;
    end
    default: begin
        state <= state;
        out <= out;
    end
    endcase
end
```
#### 2-proceedure moore fsm 
a 2-proceedure moore fsm contains two parts: transition of states using combinational logic, and storage of states using sequential logic. Here's another example:
```Verilog
reg [2:0] state = 0;
reg [2:0] next_state;

always @(posedge clk) begin
    /* Reset function can be realized here */
    state <= next_state; 
end
always @(state, in) begin
    case (state)
        0: begin
            next_state = in == 1 ? 1 : 0;
            out = 0;
        end
        1: begin
            next_state = in == 1 ? 1 : 2;
            out = 0;
        end
        2: begin
            next_state = in == 1 ? 3 : 0;
            out = 0;
        end
        3: begin
            next_state = in == 1 ? 1 : 4;
            out = 0;
        end
        4: begin
            next_state = in == 1 ? 3 : 0;
            out = 1;
        end
        default:  begin
            next_state = 3;
            out = 0;
        end
    endcase
end
```
#### 3-proceedure moore fsm 
A 3-proceedure fsm includes transition, storage and output.
```Verilog
reg [2:0] state = 0;
reg [2:0] next_state;

always @(posedge clk) begin
    state <= next_state;
end

always @(state, in) begin
    case (state)
        0:          next_state = in == 1 ? 1 : 0;
        1:          next_state = in == 1 ? 1 : 2;
        2:          next_state = in == 1 ? 3 : 0;
        3:          next_state = in == 1 ? 1 : 4;
        4:          next_state = in == 1 ? 3 : 0;
        default:    next_state = 3;
    endcase
end

always @(state) begin
    out = (state == 4) ? 1 : 0;
end
```
Same as what we did in Logisim.

### About Input Processing
> **Notice: the method below is guaranteed no ability to be synthesized**

Sometimes, we don't want our input to be input -- we want to process it first before it is used in state transition or output.
 
That case, we need to do a little trick. Consider a similar example as follow:
>clk 上升沿时，读入一个字符 in ，这时若'1010'或'ABCD'或'AAAA'是已读入的字符串的后缀，则 out 输出1，否则输出0。
 
Surely we can write a similar fsm as above, but this time it would take more than 4 states, probably 12 states, to accomplish our goal.

However, if we think like this: the input is always the last 4 letters. Then it would be a lot more easier. let's call it 'subinput'.
```Verilog
module example(
    input [7:0] in;
    output reg out
);
reg [7:0] r1, r2, r3, r4;
//  3 subinputs:
wire is1010 = (r1 == "1" && r2 == "0" && r3 == "1" && r4 == "0");
wire isABCD = (r1 == "A" && r2 == "B" && r3 == "C" && r4 == "D");
wire isAAAA = (r1 == "A" && r2 == "A" && r3 == "A" && r4 == "A");

always @(posedge clk) begin
    r1 = r2;
    r2 = r3;
    r3 = r4;
    r4 = in;
end

always @(is1010, isABCD, isAAAA) begin
    /*     If the input signal triggers the subinput to change.
     *     Do Not use "posedge clk" here, because we want the 
     * block above to be processed FIRST. */
    out <= is1010 || isABCD || isAAAA;
end
```
Notice that now our input for state transition or output has now shifted into our subinput, which is apparantly better.

### About "Many-but-finate State Machine"
We merely discuss a thought on this matter.
 
Sometimes, the states we define is too many to be enumerated —— for example, $2^{32}$ states. However, this state machine is not as complex as the machine we build before. Let's say, if vertices refers to states and edges refers to transition of states, our graph is merely a sparse graph.
 
for example:
> Input 1 or 0 each time. Identify whether the number of 1 inputed and the number of 0 are equal to each other. Output 1 if equal. The scale of input is less than $2^{32}$
 
It's easy to think of using a register to store the number of the minus of "number of 1" and "number of 0". So when the number we store equals to 0, we output 1.
 
We can also see this example as a finate machine —— counter is our state. 

Here is an example:
