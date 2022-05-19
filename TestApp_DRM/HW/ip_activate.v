module ip_activate (
    activation_code,
    clk_in,
    RDY_enable,
    enable
    );

    input [127:0] activation_code;
    input clk_in;
    output reg enable,RDY_enable;

    wire [127:0] ref_activation_code; 

    assign ref_activation_code = 128'h 87C0D0FD94C369FA1A4B7E7BC00BD074;
    always @(activation_code or clk_in) begin
        RDY_enable = 1'b1;
        if (activation_code == ref_activation_code) begin
            enable = 1'b1;
        end else begin
            enable = 1'b 0;
        end
    end     
    
endmodule