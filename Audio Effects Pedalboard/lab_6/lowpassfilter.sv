module lowpassfilter (input ENABLE, LRCLK,
	input [1:0] CUTOFF,
	input  [31:0] DINL, DINR,
	output [31:0] DOUTL, DOUTR);
	
	
logic [23:0] dataL, dataR; 
logic [31:0] outL, outR;
logic [23:0] pastL1, pastR1, storeL, storeR;
logic [23:0] pastL2, pastR2, pastL3, pastR3, pastL4, pastR4, pastL5, pastR5, pastL6, pastR6, pastL7, pastR7, L8, R8, L9, R9, L10, R10, L11, R11, L12, R12, L13, R13, L14, R14, L15, R15;

assign dataL = DINL[30:7];
assign dataR = DINR[30:7];
	
always_comb
begin
	
	//apply lpf
	if (ENABLE)
		unique case (CUTOFF)
		2'b00:
		begin
		outL = {DINL[30], {dataL[23], dataL[23], dataL[22:1]} + {pastL1[23], pastL1[23], pastL1[22:1]}, DINL[6:0]};
		outR = {DINR[30], {dataR[23], dataR[23], dataR[22:1]} + {pastR1[23], pastR1[23], pastR1[22:1]}, DINR[6:0]};
		end
		2'b01:
		begin
		outL = {DINL[30], {dataL[23], dataL[23], dataL[23], dataL[22:2]} + {pastL1[23], pastL1[23], pastL1[23], pastL1[22:2]} + {pastL2[23], pastL2[23], pastL2[23], pastL2[22:2]} + {pastL3[23], pastL3[23], pastL3[23], pastL3[22:2]}, DINL[6:0]};
		outR = {DINR[30], {dataR[23], dataR[23], dataR[23], dataR[22:2]} + {pastR1[23], pastR1[23], pastR1[23], pastR1[22:2]} + {pastR2[23], pastR2[23], pastR2[23], pastR2[22:2]} + {pastR3[23], pastR3[23], pastR3[23], pastR3[22:2]}, DINR[6:0]};
		end
		2'b10:
		begin
		outL = {DINL[30], {dataL[23], dataL[23], dataL[23], dataL[23], dataL[22:3]} + {pastL1[23], pastL1[23], pastL1[23], pastL1[23], pastL1[22:3]} + {pastL2[23], pastL2[23], pastL2[23], pastL2[23], pastL2[22:3]} + {pastL3[23], pastL3[23], pastL3[23], pastL3[23], pastL3[22:3]} + {pastL4[23], pastL4[23], pastL4[23], pastL4[23], pastL4[22:3]} + {pastL5[23], pastL5[23], pastL5[23], pastL5[23], pastL5[22:3]} + {pastL6[23], pastL6[23], pastL6[23], pastL6[23], pastL6[22:3]} + {pastL7[23], pastL7[23], pastL7[23], pastL7[23], pastL7[22:3]}, DINL[6:0]};
		outR = {DINR[30], {dataR[23], dataR[23], dataR[23], dataR[23], dataR[22:3]} + {pastR1[23], pastR1[23], pastR1[23], pastR1[23], pastR1[22:3]} + {pastR2[23], pastR2[23], pastR2[23], pastR2[23], pastR2[22:3]} + {pastR3[23], pastR3[23], pastR3[23], pastR3[23], pastR3[22:3]} + {pastR4[23], pastR4[23], pastR4[23], pastR4[23], pastR4[22:3]} + {pastR5[23], pastR5[23], pastR5[23], pastR5[23], pastR5[22:3]} + {pastR6[23], pastR6[23], pastR6[23], pastR6[23], pastR6[22:3]} + {pastR7[23], pastR7[23], pastR7[23], pastR7[23], pastR7[22:3]}, DINR[6:0]};
		end
		2'b11:
		begin
		outL = {DINL[30], {dataL[23], dataL[23], dataL[23], dataL[23], dataL[23], dataL[22:4]} + {pastL1[23], pastL1[23], pastL1[23], pastL1[23], pastL1[23], pastL1[22:4]} + {pastL2[23], pastL2[23], pastL2[23], pastL2[23], pastL2[23], pastL2[22:4]} + {pastL3[23], pastL3[23], pastL3[23], pastL3[23], pastL3[23], pastL3[22:4]} + {pastL4[23], pastL4[23], pastL4[23], pastL4[23], pastL4[23], pastL4[22:4]} + {pastL5[23], pastL5[23], pastL5[23], pastL5[23], pastL5[23], pastL5[22:4]} + {pastL6[23], pastL6[23], pastL6[23], pastL6[23], pastL6[23], pastL6[22:4]} + {pastL7[23], pastL7[23], pastL7[23], pastL7[23], pastL7[23], pastL7[22:4]} + {L8[23], L8[23], L8[23], L8[23], L8[23], L8[22:4]} + {L9[23], L9[23], L9[23], L9[23], L9[23], L9[22:4]} + {L10[23], L10[23], L10[23], L10[23], L10[23], L10[22:4]} + {L11[23], L11[23], L11[23], L11[23], L11[23], L11[22:4]} + {L12[23], L12[23], L12[23], L12[23], L12[23], L12[22:4]} + {L13[23], L13[23], L13[23], L13[23], L13[23], L13[22:4]} + {L14[23], L14[23], L14[23], L14[23], L14[23], L14[22:4]} + {L15[23], L15[23], L15[23], L15[23], L15[23], L15[22:4]}, DINL[6:0]};
		outR = {DINR[30], {dataR[23], dataR[23], dataR[23], dataR[23], dataR[23], dataR[22:4]} + {pastR1[23], pastR1[23], pastR1[23], pastR1[23], pastR1[23], pastR1[22:4]} + {pastR2[23], pastR2[23], pastR2[23], pastR2[23], pastR2[23], pastR2[22:4]} + {pastR3[23], pastR3[23], pastR3[23], pastR3[23], pastR3[23], pastR3[22:4]} + {pastR4[23], pastR4[23], pastR4[23], pastR4[23], pastR4[23], pastR4[22:4]} + {pastR5[23], pastR5[23], pastR5[23], pastR5[23], pastR5[23], pastR5[22:4]} + {pastR6[23], pastR6[23], pastR6[23], pastR6[23], pastR6[23], pastR6[22:4]} + {pastR7[23], pastR7[23], pastR7[23], pastR7[23], pastR7[23], pastR7[22:4]} + {R8[23], R8[23], R8[23], R8[23], R8[23], R8[22:4]} + {R9[23], R9[23], R9[23], R9[23], R9[23], R9[22:4]} + {R10[23], R10[23], R10[23], R10[23], R10[23], R10[22:4]} + {R11[23], R11[23], R11[23], R11[23], R11[23], R11[22:4]} + {R12[23], R12[23], R12[23], R12[23], R12[23], R12[22:4]} + {R13[23], R13[23], R13[23], R13[23], R13[23], R13[22:4]} + {R14[23], R14[23], R14[23], R14[23], R14[23], R14[22:4]} + {R15[23], R15[23], R15[23], R15[23], R15[23], R15[22:4]}, DINR[6:0]};
		end
		
		endcase
	//bypass
	else
		begin
		outL = DINL;
		outR = DINR;
		end

end

always_ff @(posedge LRCLK) 
begin
	storeL <= dataL;
	pastL1 <= storeL;
	pastL2 <= pastL1;
	pastL3 <= pastL2;
	pastL4 <= pastL3;
	pastL5 <= pastL4;
	pastL6 <= pastL5;
	pastL7 <= pastL6;
	L8 <= pastL7;
	L9 <= L8;
	L10 <= L9;
	L11 <= L10;
	L12 <= L11;
	L13 <= L12;
	L14 <= L13;
	L15 <= L14;
end

always_ff @(negedge LRCLK) 
begin
	storeR <= dataR;
	pastR1 <= storeR;
	pastR2 <= pastR1;
	pastR3 <= pastR2;
	pastR4 <= pastR3;
	pastR5 <= pastR4;
	pastR6 <= pastR5;
	pastR7 <= pastR6;
	R8 <= pastR7;
	R9 <= R8;
	R10 <= R9;
	R11 <= R10;
	R12 <= R11;
	R13 <= R12;
	R14 <= R13;
	R15 <= R14;
end

always_ff @ (posedge LRCLK)
begin
	DOUTL <= outL;
end
always_ff @ (negedge LRCLK)
begin
	DOUTR <= outR;
end

	
endmodule
	