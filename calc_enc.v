module calc_enc (
    input btnc,
    input btnl,
    input btnr, btnu, btnd, // Control buttons
    output wire [3:0] encout // 4-bit encoder output to match the ALU operation
);

// Logic imported from the diagrams
assign encout[0] = (~btnc & btnr) | (btnr & btnl);
assign encout[1] = (~btnl & btnc) | (btnc & ~btnr);
assign encout[2] = ((btnc & btnr) | ((btnl & ~btnc) & ~btnr));
assign encout[3] = ((btnl & ~btnc) & btnr) | ((btnl & btnc) & ~btnr);

endmodule