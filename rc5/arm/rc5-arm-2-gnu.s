	.global	_rc5_unit_func_arm_2

pqtable:
	.word	0xB7E15163
	.word	0x5618CB1C
	.word	0xF45044D5
	.word	0x9287BE8E
	.word	0x30BF3847
	.word	0xCEF6B200
	.word	0x6D2E2BB9
	.word	0x0B65A572
	.word	0xA99D1F2B
	.word	0x47D498E4
	.word	0xE60C129D
	.word	0x84438C56
	.word	0x227B060F
	.word	0xC0B27FC8
	.word	0x5EE9F981
	.word	0xFD21733A
	.word	0x9B58ECF3
	.word	0x399066AC
	.word	0xD7C7E065
	.word	0x75FF5A1E
	.word	0x1436D3D7
	.word	0xB26E4D90
	.word	0x50A5C749
	.word	0xEEDD4102
	.word	0x8D14BABB
	.word	0x2B4C3474

_rc5_unit_func_arm_2:
	MOV	R12,R13
	STMDB	R13!,{R4-R12,R14,PC}
	SUB	R11,R12,#4
	MOV	R14,R1
	STMDB	R13!,{R11}
	LDMIA	R0!,{R4-R7}
	LDMIA	R0,{R2,R3}
	TST	R2,#0x01000000
	BNE	odd
	MOV	R12,R14,LSL #1
	STR	R12,[R13,#-240]!
	STR	R0,[R13,#4]
	ADD	R12,R13,#0x20
	STMDB	R13!,{R4-R7}

timingloop:
	STR	R3,[R13,#28]
	ADR	R1,pqtable
	LDMIA	R1!,{R8,R10}
	ADD	R3,R3,R8,ROR #29
	MOV	R3,R3,ROR #3
	ADD	R0,R10,R8,ROR #29
	ADD	R10,R0,R3
	ADD	R0,R3,R10,ROR #29
	LDR	R9,[R1],#4
	RSB	R0,R0,#0
	ADD	R9,R9,R10,ROR #29
	STR	R10,[R12,#-16]
	STMDB	R12,{R0,R3,R9}
	B	skippy

timingloop2:
	ADR	R1,pqtable+12
	LDMDB	R12,{R0,R3,R9}

skippy:
	STR	R2,[R13,#24]
	ORR	R4,R2,#0x01000000
	ADD	R12,R12,#0x10
	SUB	R2,R2,R0
	SUB	R4,R4,R0
	MOV	R2,R2,ROR R0
	MOV	R4,R4,ROR R0
	ADD	R7,R9,R2
	ADD	R9,R9,R4
	STMIA	R12!,{R7,R9}
	ADD	R0,R4,R9,ROR #29
	RSB	R0,R0,#0
	SUB	R5,R3,R0
	MOV	R5,R5,ROR R0
	ADD	R0,R2,R7,ROR #29
	RSB	R0,R0,#0
	SUB	R3,R3,R0
	LDMIA	R1!,{R8,R11}
	MOV	R3,R3,ROR R0
	ADD	R0,R8,R7,ROR #29
	ADD	R7,R0,R3
	ADD	R0,R8,R9,ROR #29
	ADD	R8,R0,R5
	ADD	R0,R5,R8,ROR #29
	RSB	R0,R0,#0
	SUB	R4,R4,R0
	MOV	R4,R4,ROR R0
	ADD	R0,R3,R7,ROR #29
	RSB	R0,R0,#0
	SUB	R2,R2,R0
	MOV	R2,R2,ROR R0
	ADD	R9,R11,R7,ROR #29
	ADD	R11,R11,R8,ROR #29
	ADD	R9,R9,R2
	ADD	R11,R11,R4
	STMIA	R12!,{R7-R9,R11}
	ADD	R0,R4,R11,ROR #29
	RSB	R0,R0,#0
	SUB	R5,R5,R0
	MOV	R5,R5,ROR R0
	ADD	R0,R2,R9,ROR #29
	RSB	R0,R0,#0
	SUB	R3,R3,R0
	LDMIA	R1!,{R8,R10}
	MOV	R3,R3,ROR R0
	ADD	R0,R8,R9,ROR #29
	ADD	R7,R0,R3
	ADD	R0,R8,R11,ROR #29
	ADD	R8,R0,R5
	ADD	R0,R5,R8,ROR #29
	RSB	R0,R0,#0
	SUB	R4,R4,R0
	MOV	R4,R4,ROR R0
	ADD	R0,R3,R7,ROR #29
	RSB	R0,R0,#0
	SUB	R2,R2,R0
	MOV	R2,R2,ROR R0
	ADD	R9,R10,R7,ROR #29
	ADD	R10,R10,R8,ROR #29
	ADD	R9,R9,R2
	ADD	R10,R10,R4
	STMIA	R12!,{R7-R10}
	ADD	R0,R4,R10,ROR #29
	RSB	R0,R0,#0
	SUB	R5,R5,R0
	MOV	R5,R5,ROR R0
	ADD	R0,R2,R9,ROR #29
	RSB	R0,R0,#0
	SUB	R3,R3,R0
	LDMIA	R1!,{R8,R11}
	MOV	R3,R3,ROR R0
	ADD	R0,R8,R9,ROR #29
	ADD	R7,R0,R3
	ADD	R0,R8,R10,ROR #29
	ADD	R8,R0,R5
	ADD	R0,R5,R8,ROR #29
	RSB	R0,R0,#0
	SUB	R4,R4,R0
	MOV	R4,R4,ROR R0
	ADD	R0,R3,R7,ROR #29
	RSB	R0,R0,#0
	SUB	R2,R2,R0
	MOV	R2,R2,ROR R0
	ADD	R9,R11,R7,ROR #29
	ADD	R11,R11,R8,ROR #29
	ADD	R9,R9,R2
	ADD	R11,R11,R4
	STMIA	R12!,{R7-R9,R11}
	ADD	R0,R4,R11,ROR #29
	RSB	R0,R0,#0
	SUB	R5,R5,R0
	MOV	R5,R5,ROR R0
	ADD	R0,R2,R9,ROR #29
	RSB	R0,R0,#0
	SUB	R3,R3,R0
	LDMIA	R1!,{R8,R10}
	MOV	R3,R3,ROR R0
	ADD	R0,R8,R9,ROR #29
	ADD	R7,R0,R3
	ADD	R0,R8,R11,ROR #29
	ADD	R8,R0,R5
	ADD	R0,R5,R8,ROR #29
	RSB	R0,R0,#0
	SUB	R4,R4,R0
	MOV	R4,R4,ROR R0
	ADD	R0,R3,R7,ROR #29
	RSB	R0,R0,#0
	SUB	R2,R2,R0
	MOV	R2,R2,ROR R0
	ADD	R9,R10,R7,ROR #29
	ADD	R10,R10,R8,ROR #29
	ADD	R9,R9,R2
	ADD	R10,R10,R4
	STMIA	R12!,{R7-R10}
	ADD	R0,R4,R10,ROR #29
	RSB	R0,R0,#0
	SUB	R5,R5,R0
	MOV	R5,R5,ROR R0
	ADD	R0,R2,R9,ROR #29
	RSB	R0,R0,#0
	SUB	R3,R3,R0
	LDMIA	R1!,{R8,R11}
	MOV	R3,R3,ROR R0
	ADD	R0,R8,R9,ROR #29
	ADD	R7,R0,R3
	ADD	R0,R8,R10,ROR #29
	ADD	R8,R0,R5
	ADD	R0,R5,R8,ROR #29
	RSB	R0,R0,#0
	SUB	R4,R4,R0
	MOV	R4,R4,ROR R0
	ADD	R0,R3,R7,ROR #29
	RSB	R0,R0,#0
	SUB	R2,R2,R0
	MOV	R2,R2,ROR R0
	ADD	R9,R11,R7,ROR #29
	ADD	R11,R11,R8,ROR #29
	ADD	R9,R9,R2
	ADD	R11,R11,R4
	STMIA	R12!,{R7-R9,R11}
	ADD	R0,R4,R11,ROR #29
	RSB	R0,R0,#0
	SUB	R5,R5,R0
	MOV	R5,R5,ROR R0
	ADD	R0,R2,R9,ROR #29
	RSB	R0,R0,#0
	SUB	R3,R3,R0
	LDMIA	R1!,{R8,R10}
	MOV	R3,R3,ROR R0
	ADD	R0,R8,R9,ROR #29
	ADD	R7,R0,R3
	ADD	R0,R8,R11,ROR #29
	ADD	R8,R0,R5
	ADD	R0,R5,R8,ROR #29
	RSB	R0,R0,#0
	SUB	R4,R4,R0
	MOV	R4,R4,ROR R0
	ADD	R0,R3,R7,ROR #29
	RSB	R0,R0,#0
	SUB	R2,R2,R0
	MOV	R2,R2,ROR R0
	ADD	R9,R10,R7,ROR #29
	ADD	R10,R10,R8,ROR #29
	ADD	R9,R9,R2
	ADD	R10,R10,R4
	STMIA	R12!,{R7-R10}
	ADD	R0,R4,R10,ROR #29
	RSB	R0,R0,#0
	SUB	R5,R5,R0
	MOV	R5,R5,ROR R0
	ADD	R0,R2,R9,ROR #29
	RSB	R0,R0,#0
	SUB	R3,R3,R0
	LDMIA	R1!,{R8,R11}
	MOV	R3,R3,ROR R0
	ADD	R0,R8,R9,ROR #29
	ADD	R7,R0,R3
	ADD	R0,R8,R10,ROR #29
	ADD	R8,R0,R5
	ADD	R0,R5,R8,ROR #29
	RSB	R0,R0,#0
	SUB	R4,R4,R0
	MOV	R4,R4,ROR R0
	ADD	R0,R3,R7,ROR #29
	RSB	R0,R0,#0
	SUB	R2,R2,R0
	MOV	R2,R2,ROR R0
	ADD	R9,R11,R7,ROR #29
	ADD	R11,R11,R8,ROR #29
	ADD	R9,R9,R2
	ADD	R11,R11,R4
	STMIA	R12!,{R7-R9,R11}
	ADD	R0,R4,R11,ROR #29
	RSB	R0,R0,#0
	SUB	R5,R5,R0
	MOV	R5,R5,ROR R0
	ADD	R0,R2,R9,ROR #29
	RSB	R0,R0,#0
	SUB	R3,R3,R0
	LDMIA	R1!,{R8,R10}
	MOV	R3,R3,ROR R0
	ADD	R0,R8,R9,ROR #29
	ADD	R7,R0,R3
	ADD	R0,R8,R11,ROR #29
	ADD	R8,R0,R5
	ADD	R0,R5,R8,ROR #29
	RSB	R0,R0,#0
	SUB	R4,R4,R0
	MOV	R4,R4,ROR R0
	ADD	R0,R3,R7,ROR #29
	RSB	R0,R0,#0
	SUB	R2,R2,R0
	MOV	R2,R2,ROR R0
	ADD	R9,R10,R7,ROR #29
	ADD	R10,R10,R8,ROR #29
	ADD	R9,R9,R2
	ADD	R10,R10,R4
	STMIA	R12!,{R7-R10}
	ADD	R0,R4,R10,ROR #29
	RSB	R0,R0,#0
	SUB	R5,R5,R0
	MOV	R5,R5,ROR R0
	ADD	R0,R2,R9,ROR #29
	RSB	R0,R0,#0
	SUB	R3,R3,R0
	LDMIA	R1!,{R8,R11}
	MOV	R3,R3,ROR R0
	ADD	R0,R8,R9,ROR #29
	ADD	R7,R0,R3
	ADD	R0,R8,R10,ROR #29
	ADD	R8,R0,R5
	ADD	R0,R5,R8,ROR #29
	RSB	R0,R0,#0
	SUB	R4,R4,R0
	MOV	R4,R4,ROR R0
	ADD	R0,R3,R7,ROR #29
	RSB	R0,R0,#0
	SUB	R2,R2,R0
	MOV	R2,R2,ROR R0
	ADD	R9,R11,R7,ROR #29
	ADD	R11,R11,R8,ROR #29
	ADD	R9,R9,R2
	ADD	R11,R11,R4
	STMIA	R12!,{R7-R9,R11}
	ADD	R0,R4,R11,ROR #29
	RSB	R0,R0,#0
	SUB	R5,R5,R0
	MOV	R5,R5,ROR R0
	ADD	R0,R2,R9,ROR #29
	RSB	R0,R0,#0
	SUB	R3,R3,R0
	LDMIA	R1!,{R8,R10}
	MOV	R3,R3,ROR R0
	ADD	R0,R8,R9,ROR #29
	ADD	R7,R0,R3
	ADD	R0,R8,R11,ROR #29
	ADD	R8,R0,R5
	ADD	R0,R5,R8,ROR #29
	RSB	R0,R0,#0
	SUB	R4,R4,R0
	MOV	R4,R4,ROR R0
	ADD	R0,R3,R7,ROR #29
	RSB	R0,R0,#0
	SUB	R2,R2,R0
	MOV	R2,R2,ROR R0
	ADD	R9,R10,R7,ROR #29
	ADD	R10,R10,R8,ROR #29
	ADD	R9,R9,R2
	ADD	R10,R10,R4
	STMIA	R12!,{R7-R10}
	ADD	R0,R4,R10,ROR #29
	RSB	R0,R0,#0
	SUB	R5,R5,R0
	MOV	R5,R5,ROR R0
	ADD	R0,R2,R9,ROR #29
	RSB	R0,R0,#0
	SUB	R3,R3,R0
	LDMIA	R1!,{R8,R11}
	MOV	R3,R3,ROR R0
	ADD	R0,R8,R9,ROR #29
	ADD	R7,R0,R3
	ADD	R0,R8,R10,ROR #29
	ADD	R8,R0,R5
	ADD	R0,R5,R8,ROR #29
	RSB	R0,R0,#0
	SUB	R4,R4,R0
	MOV	R4,R4,ROR R0
	ADD	R0,R3,R7,ROR #29
	RSB	R0,R0,#0
	SUB	R2,R2,R0
	MOV	R2,R2,ROR R0
	ADD	R9,R11,R7,ROR #29
	ADD	R11,R11,R8,ROR #29
	ADD	R9,R9,R2
	ADD	R11,R11,R4
	STMIA	R12!,{R7-R9,R11}
	ADD	R0,R4,R11,ROR #29
	RSB	R0,R0,#0
	SUB	R5,R5,R0
	MOV	R5,R5,ROR R0
	ADD	R0,R2,R9,ROR #29
	RSB	R0,R0,#0
	SUB	R3,R3,R0
	LDR	R8,[R1],#4
	MOV	R3,R3,ROR R0
	ADD	R0,R8,R9,ROR #29
	ADD	R7,R0,R3
	ADD	R0,R8,R11,ROR #29
	ADD	R8,R0,R5
	STMIA	R12!,{R7,R8}
	ADD	R0,R5,R8,ROR #29
	RSB	R0,R0,#0
	SUB	R4,R4,R0
	MOV	R4,R4,ROR R0
	ADD	R0,R3,R7,ROR #29
	RSB	R0,R0,#0
	SUB	R2,R2,R0
	MOV	R2,R2,ROR R0
	ADD	R0,R2,R7,ROR #29
	ADD	R1,R4,R8,ROR #29
	SUB	R12,R12,#0xD0
	LDR	R7,pqtable
	LDR	R9,[R12,#-16]
	ADD	R6,R0,R7,ROR #29
	ADD	R7,R1,R7,ROR #29
	ADD	R0,R2,R6,ROR #29
	ADD	R1,R4,R7,ROR #29
	RSB	R0,R0,#0
	RSB	R1,R1,#0
	SUB	R3,R3,R0
	SUB	R5,R5,R1
	MOV	R3,R3,ROR R0
	MOV	R5,R5,ROR R1
	ADD	R0,R3,R6,ROR #29
	ADD	R1,R5,R7,ROR #29
	ADD	R8,R0,R9,ROR #29
	ADD	R9,R1,R9,ROR #29
	ADD	R0,R3,R8,ROR #29
	ADD	R1,R5,R9,ROR #29
	STMIA	R12!,{R6-R9}
	RSB	R0,R0,#0
	RSB	R1,R1,#0
	SUB	R2,R2,R0
	SUB	R4,R4,R1
	MOV	R2,R2,ROR R0
	MOV	R4,R4,ROR R1
	ADD	R0,R2,R8,ROR #29
	ADD	R1,R4,R9,ROR #29
	LDMIA	R12,{R6-R11}
	ADD	R6,R0,R6,ROR #29
	ADD	R7,R1,R7,ROR #29
	ADD	R0,R2,R6,ROR #29
	ADD	R1,R4,R7,ROR #29
	RSB	R0,R0,#0
	RSB	R1,R1,#0
	SUB	R3,R3,R0
	SUB	R5,R5,R1
	MOV	R3,R3,ROR R0
	MOV	R5,R5,ROR R1
	ADD	R0,R3,R6,ROR #29
	ADD	R1,R5,R7,ROR #29
	ADD	R8,R0,R8,ROR #29
	ADD	R9,R1,R9,ROR #29
	ADD	R0,R3,R8,ROR #29
	ADD	R1,R5,R9,ROR #29
	RSB	R0,R0,#0
	RSB	R1,R1,#0
	SUB	R2,R2,R0
	SUB	R4,R4,R1
	MOV	R2,R2,ROR R0
	MOV	R4,R4,ROR R1
	ADD	R0,R2,R8,ROR #29
	ADD	R1,R4,R9,ROR #29
	ADD	R10,R0,R10,ROR #29
	ADD	R11,R1,R11,ROR #29
	ADD	R0,R2,R10,ROR #29
	ADD	R1,R4,R11,ROR #29
	STMIA	R12!,{R6-R11}
	RSB	R0,R0,#0
	RSB	R1,R1,#0
	SUB	R3,R3,R0
	SUB	R5,R5,R1
	MOV	R3,R3,ROR R0
	MOV	R5,R5,ROR R1
	ADD	R0,R3,R10,ROR #29
	ADD	R1,R5,R11,ROR #29
	LDMIA	R12,{R6-R11}
	ADD	R6,R0,R6,ROR #29
	ADD	R7,R1,R7,ROR #29
	ADD	R0,R3,R6,ROR #29
	ADD	R1,R5,R7,ROR #29
	RSB	R0,R0,#0
	RSB	R1,R1,#0
	SUB	R2,R2,R0
	SUB	R4,R4,R1
	MOV	R2,R2,ROR R0
	MOV	R4,R4,ROR R1
	ADD	R0,R2,R6,ROR #29
	ADD	R1,R4,R7,ROR #29
	ADD	R8,R0,R8,ROR #29
	ADD	R9,R1,R9,ROR #29
	ADD	R0,R2,R8,ROR #29
	ADD	R1,R4,R9,ROR #29
	RSB	R0,R0,#0
	RSB	R1,R1,#0
	SUB	R3,R3,R0
	SUB	R5,R5,R1
	MOV	R3,R3,ROR R0
	MOV	R5,R5,ROR R1
	ADD	R0,R3,R8,ROR #29
	ADD	R1,R5,R9,ROR #29
	ADD	R10,R0,R10,ROR #29
	ADD	R11,R1,R11,ROR #29
	ADD	R0,R3,R10,ROR #29
	ADD	R1,R5,R11,ROR #29
	STMIA	R12!,{R6-R11}
	RSB	R0,R0,#0
	RSB	R1,R1,#0
	SUB	R2,R2,R0
	SUB	R4,R4,R1
	MOV	R2,R2,ROR R0
	MOV	R4,R4,ROR R1
	ADD	R0,R2,R10,ROR #29
	ADD	R1,R4,R11,ROR #29
	LDMIA	R12,{R6-R11}
	ADD	R6,R0,R6,ROR #29
	ADD	R7,R1,R7,ROR #29
	ADD	R0,R2,R6,ROR #29
	ADD	R1,R4,R7,ROR #29
	RSB	R0,R0,#0
	RSB	R1,R1,#0
	SUB	R3,R3,R0
	SUB	R5,R5,R1
	MOV	R3,R3,ROR R0
	MOV	R5,R5,ROR R1
	ADD	R0,R3,R6,ROR #29
	ADD	R1,R5,R7,ROR #29
	ADD	R8,R0,R8,ROR #29
	ADD	R9,R1,R9,ROR #29
	ADD	R0,R3,R8,ROR #29
	ADD	R1,R5,R9,ROR #29
	RSB	R0,R0,#0
	RSB	R1,R1,#0
	SUB	R2,R2,R0
	SUB	R4,R4,R1
	MOV	R2,R2,ROR R0
	MOV	R4,R4,ROR R1
	ADD	R0,R2,R8,ROR #29
	ADD	R1,R4,R9,ROR #29
	ADD	R10,R0,R10,ROR #29
	ADD	R11,R1,R11,ROR #29
	ADD	R0,R2,R10,ROR #29
	ADD	R1,R4,R11,ROR #29
	STMIA	R12!,{R6-R11}
	RSB	R0,R0,#0
	RSB	R1,R1,#0
	SUB	R3,R3,R0
	SUB	R5,R5,R1
	MOV	R3,R3,ROR R0
	MOV	R5,R5,ROR R1
	ADD	R0,R3,R10,ROR #29
	ADD	R1,R5,R11,ROR #29
	LDMIA	R12,{R6-R11}
	ADD	R6,R0,R6,ROR #29
	ADD	R7,R1,R7,ROR #29
	ADD	R0,R3,R6,ROR #29
	ADD	R1,R5,R7,ROR #29
	RSB	R0,R0,#0
	RSB	R1,R1,#0
	SUB	R2,R2,R0
	SUB	R4,R4,R1
	MOV	R2,R2,ROR R0
	MOV	R4,R4,ROR R1
	ADD	R0,R2,R6,ROR #29
	ADD	R1,R4,R7,ROR #29
	ADD	R8,R0,R8,ROR #29
	ADD	R9,R1,R9,ROR #29
	ADD	R0,R2,R8,ROR #29
	ADD	R1,R4,R9,ROR #29
	RSB	R0,R0,#0
	RSB	R1,R1,#0
	SUB	R3,R3,R0
	SUB	R5,R5,R1
	MOV	R3,R3,ROR R0
	MOV	R5,R5,ROR R1
	ADD	R0,R3,R8,ROR #29
	ADD	R1,R5,R9,ROR #29
	ADD	R10,R0,R10,ROR #29
	ADD	R11,R1,R11,ROR #29
	ADD	R0,R3,R10,ROR #29
	ADD	R1,R5,R11,ROR #29
	STMIA	R12!,{R6-R11}
	RSB	R0,R0,#0
	RSB	R1,R1,#0
	SUB	R2,R2,R0
	SUB	R4,R4,R1
	MOV	R2,R2,ROR R0
	MOV	R4,R4,ROR R1
	ADD	R0,R2,R10,ROR #29
	ADD	R1,R4,R11,ROR #29
	LDMIA	R12,{R6-R11}
	ADD	R6,R0,R6,ROR #29
	ADD	R7,R1,R7,ROR #29
	ADD	R0,R2,R6,ROR #29
	ADD	R1,R4,R7,ROR #29
	RSB	R0,R0,#0
	RSB	R1,R1,#0
	SUB	R3,R3,R0
	SUB	R5,R5,R1
	MOV	R3,R3,ROR R0
	MOV	R5,R5,ROR R1
	ADD	R0,R3,R6,ROR #29
	ADD	R1,R5,R7,ROR #29
	ADD	R8,R0,R8,ROR #29
	ADD	R9,R1,R9,ROR #29
	ADD	R0,R3,R8,ROR #29
	ADD	R1,R5,R9,ROR #29
	RSB	R0,R0,#0
	RSB	R1,R1,#0
	SUB	R2,R2,R0
	SUB	R4,R4,R1
	MOV	R2,R2,ROR R0
	MOV	R4,R4,ROR R1
	ADD	R0,R2,R8,ROR #29
	ADD	R1,R4,R9,ROR #29
	ADD	R10,R0,R10,ROR #29
	ADD	R11,R1,R11,ROR #29
	ADD	R0,R2,R10,ROR #29
	ADD	R1,R4,R11,ROR #29
	STMIA	R12!,{R6-R11}
	RSB	R0,R0,#0
	RSB	R1,R1,#0
	SUB	R3,R3,R0
	SUB	R5,R5,R1
	MOV	R3,R3,ROR R0
	MOV	R5,R5,ROR R1
	ADD	R0,R3,R10,ROR #29
	ADD	R1,R5,R11,ROR #29
	LDMIA	R12,{R6-R11}
	ADD	R6,R0,R6,ROR #29
	ADD	R7,R1,R7,ROR #29
	ADD	R0,R3,R6,ROR #29
	ADD	R1,R5,R7,ROR #29
	RSB	R0,R0,#0
	RSB	R1,R1,#0
	SUB	R2,R2,R0
	SUB	R4,R4,R1
	MOV	R2,R2,ROR R0
	MOV	R4,R4,ROR R1
	ADD	R0,R2,R6,ROR #29
	ADD	R1,R4,R7,ROR #29
	ADD	R8,R0,R8,ROR #29
	ADD	R9,R1,R9,ROR #29
	ADD	R0,R2,R8,ROR #29
	ADD	R1,R4,R9,ROR #29
	RSB	R0,R0,#0
	RSB	R1,R1,#0
	SUB	R3,R3,R0
	SUB	R5,R5,R1
	MOV	R3,R3,ROR R0
	MOV	R5,R5,ROR R1
	ADD	R0,R3,R8,ROR #29
	ADD	R1,R5,R9,ROR #29
	ADD	R10,R0,R10,ROR #29
	ADD	R11,R1,R11,ROR #29
	ADD	R0,R3,R10,ROR #29
	ADD	R1,R5,R11,ROR #29
	STMIA	R12!,{R6-R11}
	RSB	R0,R0,#0
	RSB	R1,R1,#0
	SUB	R2,R2,R0
	SUB	R4,R4,R1
	MOV	R2,R2,ROR R0
	MOV	R4,R4,ROR R1
	ADD	R0,R2,R10,ROR #29
	ADD	R1,R4,R11,ROR #29
	LDMIA	R12,{R6-R11}
	ADD	R6,R0,R6,ROR #29
	ADD	R7,R1,R7,ROR #29
	ADD	R0,R2,R6,ROR #29
	ADD	R1,R4,R7,ROR #29
	RSB	R0,R0,#0
	RSB	R1,R1,#0
	SUB	R3,R3,R0
	SUB	R5,R5,R1
	MOV	R3,R3,ROR R0
	MOV	R5,R5,ROR R1
	ADD	R0,R3,R6,ROR #29
	ADD	R1,R5,R7,ROR #29
	ADD	R8,R0,R8,ROR #29
	ADD	R9,R1,R9,ROR #29
	ADD	R0,R3,R8,ROR #29
	ADD	R1,R5,R9,ROR #29
	RSB	R0,R0,#0
	RSB	R1,R1,#0
	SUB	R2,R2,R0
	SUB	R4,R4,R1
	MOV	R2,R2,ROR R0
	MOV	R4,R4,ROR R1
	ADD	R0,R2,R8,ROR #29
	ADD	R1,R4,R9,ROR #29
	ADD	R10,R0,R10,ROR #29
	ADD	R11,R1,R11,ROR #29
	ADD	R0,R2,R10,ROR #29
	ADD	R1,R4,R11,ROR #29
	STMIA	R12!,{R6-R11}
	RSB	R0,R0,#0
	RSB	R1,R1,#0
	SUB	R3,R3,R0
	SUB	R5,R5,R1
	MOV	R3,R3,ROR R0
	MOV	R5,R5,ROR R1
	ADD	R0,R3,R10,ROR #29
	ADD	R1,R5,R11,ROR #29
	LDMIA	R12,{R6-R11}
	ADD	R6,R0,R6,ROR #29
	ADD	R7,R1,R7,ROR #29
	ADD	R0,R3,R6,ROR #29
	ADD	R1,R5,R7,ROR #29
	RSB	R0,R0,#0
	RSB	R1,R1,#0
	SUB	R2,R2,R0
	SUB	R4,R4,R1
	MOV	R2,R2,ROR R0
	MOV	R4,R4,ROR R1
	ADD	R0,R2,R6,ROR #29
	ADD	R1,R4,R7,ROR #29
	ADD	R8,R0,R8,ROR #29
	ADD	R9,R1,R9,ROR #29
	ADD	R0,R2,R8,ROR #29
	ADD	R1,R4,R9,ROR #29
	RSB	R0,R0,#0
	RSB	R1,R1,#0
	SUB	R3,R3,R0
	SUB	R5,R5,R1
	MOV	R3,R3,ROR R0
	MOV	R5,R5,ROR R1
	ADD	R0,R3,R8,ROR #29
	ADD	R1,R5,R9,ROR #29
	ADD	R10,R0,R10,ROR #29
	ADD	R11,R1,R11,ROR #29
	ADD	R0,R3,R10,ROR #29
	ADD	R1,R5,R11,ROR #29
	STMIA	R12!,{R6-R11}
	RSB	R0,R0,#0
	RSB	R1,R1,#0
	SUB	R2,R2,R0
	SUB	R4,R4,R1
	MOV	R2,R2,ROR R0
	MOV	R4,R4,ROR R1
	SUB	R12,R12,#0xD0
	LDMIA	R13,{R8,R9}
	ADD	R0,R2,R10,ROR #29
	ADD	R1,R4,R11,ROR #29
	LDMIA	R12!,{R10,R11}
	ADD	R10,R0,R10,ROR #29
	ADD	R11,R1,R11,ROR #29
	ADD	R7,R9,R10,ROR #29
	ADD	R1,R2,R10,ROR #29
	RSB	R1,R1,#0
	SUB	R3,R3,R1
	MOV	R3,R3,ROR R1
	ADD	R9,R9,R11,ROR #29
	ADD	R1,R4,R11,ROR #29
	RSB	R1,R1,#0
	SUB	R5,R5,R1
	MOV	R5,R5,ROR R1
	ADD	R0,R3,R10,ROR #29
	ADD	R1,R5,R11,ROR #29
	LDMIA	R12!,{R10,R11}
	ADD	R10,R0,R10,ROR #29
	ADD	R11,R1,R11,ROR #29
	ADD	R6,R8,R10,ROR #29
	ADD	R1,R3,R10,ROR #29
	RSB	R1,R1,#0
	SUB	R2,R2,R1
	MOV	R2,R2,ROR R1
	ADD	R8,R8,R11,ROR #29
	ADD	R1,R5,R11,ROR #29
	RSB	R1,R1,#0
	SUB	R4,R4,R1
	MOV	R4,R4,ROR R1
	ADD	R0,R2,R10,ROR #29
	ADD	R1,R4,R11,ROR #29
	LDMIA	R12!,{R10,R11}
	ADD	R10,R0,R10,ROR #29
	ADD	R11,R1,R11,ROR #29
	EOR	R7,R7,R6
	RSB	R1,R6,#0
	MOV	R7,R7,ROR R1
	ADD	R7,R7,R10,ROR #29
	ADD	R1,R2,R10,ROR #29
	RSB	R1,R1,#0
	SUB	R3,R3,R1
	MOV	R3,R3,ROR R1
	EOR	R9,R9,R8
	RSB	R1,R8,#0
	MOV	R9,R9,ROR R1
	ADD	R9,R9,R11,ROR #29
	ADD	R1,R4,R11,ROR #29
	RSB	R1,R1,#0
	SUB	R5,R5,R1
	MOV	R5,R5,ROR R1
	ADD	R0,R3,R10,ROR #29
	ADD	R1,R5,R11,ROR #29
	LDMIA	R12!,{R10,R11}
	ADD	R10,R0,R10,ROR #29
	ADD	R11,R1,R11,ROR #29
	EOR	R6,R6,R7
	RSB	R1,R7,#0
	MOV	R6,R6,ROR R1
	ADD	R6,R6,R10,ROR #29
	ADD	R1,R3,R10,ROR #29
	RSB	R1,R1,#0
	SUB	R2,R2,R1
	MOV	R2,R2,ROR R1
	EOR	R8,R8,R9
	RSB	R1,R9,#0
	MOV	R8,R8,ROR R1
	ADD	R8,R8,R11,ROR #29
	ADD	R1,R5,R11,ROR #29
	RSB	R1,R1,#0
	SUB	R4,R4,R1
	MOV	R4,R4,ROR R1
	ADD	R0,R2,R10,ROR #29
	ADD	R1,R4,R11,ROR #29
	LDMIA	R12!,{R10,R11}
	ADD	R10,R0,R10,ROR #29
	ADD	R11,R1,R11,ROR #29
	EOR	R7,R7,R6
	RSB	R1,R6,#0
	MOV	R7,R7,ROR R1
	ADD	R7,R7,R10,ROR #29
	ADD	R1,R2,R10,ROR #29
	RSB	R1,R1,#0
	SUB	R3,R3,R1
	MOV	R3,R3,ROR R1
	EOR	R9,R9,R8
	RSB	R1,R8,#0
	MOV	R9,R9,ROR R1
	ADD	R9,R9,R11,ROR #29
	ADD	R1,R4,R11,ROR #29
	RSB	R1,R1,#0
	SUB	R5,R5,R1
	MOV	R5,R5,ROR R1
	ADD	R0,R3,R10,ROR #29
	ADD	R1,R5,R11,ROR #29
	LDMIA	R12!,{R10,R11}
	ADD	R10,R0,R10,ROR #29
	ADD	R11,R1,R11,ROR #29
	EOR	R6,R6,R7
	RSB	R1,R7,#0
	MOV	R6,R6,ROR R1
	ADD	R6,R6,R10,ROR #29
	ADD	R1,R3,R10,ROR #29
	RSB	R1,R1,#0
	SUB	R2,R2,R1
	MOV	R2,R2,ROR R1
	EOR	R8,R8,R9
	RSB	R1,R9,#0
	MOV	R8,R8,ROR R1
	ADD	R8,R8,R11,ROR #29
	ADD	R1,R5,R11,ROR #29
	RSB	R1,R1,#0
	SUB	R4,R4,R1
	MOV	R4,R4,ROR R1
	ADD	R0,R2,R10,ROR #29
	ADD	R1,R4,R11,ROR #29
	LDMIA	R12!,{R10,R11}
	ADD	R10,R0,R10,ROR #29
	ADD	R11,R1,R11,ROR #29
	EOR	R7,R7,R6
	RSB	R1,R6,#0
	MOV	R7,R7,ROR R1
	ADD	R7,R7,R10,ROR #29
	ADD	R1,R2,R10,ROR #29
	RSB	R1,R1,#0
	SUB	R3,R3,R1
	MOV	R3,R3,ROR R1
	EOR	R9,R9,R8
	RSB	R1,R8,#0
	MOV	R9,R9,ROR R1
	ADD	R9,R9,R11,ROR #29
	ADD	R1,R4,R11,ROR #29
	RSB	R1,R1,#0
	SUB	R5,R5,R1
	MOV	R5,R5,ROR R1
	ADD	R0,R3,R10,ROR #29
	ADD	R1,R5,R11,ROR #29
	LDMIA	R12!,{R10,R11}
	ADD	R10,R0,R10,ROR #29
	ADD	R11,R1,R11,ROR #29
	EOR	R6,R6,R7
	RSB	R1,R7,#0
	MOV	R6,R6,ROR R1
	ADD	R6,R6,R10,ROR #29
	ADD	R1,R3,R10,ROR #29
	RSB	R1,R1,#0
	SUB	R2,R2,R1
	MOV	R2,R2,ROR R1
	EOR	R8,R8,R9
	RSB	R1,R9,#0
	MOV	R8,R8,ROR R1
	ADD	R8,R8,R11,ROR #29
	ADD	R1,R5,R11,ROR #29
	RSB	R1,R1,#0
	SUB	R4,R4,R1
	MOV	R4,R4,ROR R1
	ADD	R0,R2,R10,ROR #29
	ADD	R1,R4,R11,ROR #29
	LDMIA	R12!,{R10,R11}
	ADD	R10,R0,R10,ROR #29
	ADD	R11,R1,R11,ROR #29
	EOR	R7,R7,R6
	RSB	R1,R6,#0
	MOV	R7,R7,ROR R1
	ADD	R7,R7,R10,ROR #29
	ADD	R1,R2,R10,ROR #29
	RSB	R1,R1,#0
	SUB	R3,R3,R1
	MOV	R3,R3,ROR R1
	EOR	R9,R9,R8
	RSB	R1,R8,#0
	MOV	R9,R9,ROR R1
	ADD	R9,R9,R11,ROR #29
	ADD	R1,R4,R11,ROR #29
	RSB	R1,R1,#0
	SUB	R5,R5,R1
	MOV	R5,R5,ROR R1
	ADD	R0,R3,R10,ROR #29
	ADD	R1,R5,R11,ROR #29
	LDMIA	R12!,{R10,R11}
	ADD	R10,R0,R10,ROR #29
	ADD	R11,R1,R11,ROR #29
	EOR	R6,R6,R7
	RSB	R1,R7,#0
	MOV	R6,R6,ROR R1
	ADD	R6,R6,R10,ROR #29
	ADD	R1,R3,R10,ROR #29
	RSB	R1,R1,#0
	SUB	R2,R2,R1
	MOV	R2,R2,ROR R1
	EOR	R8,R8,R9
	RSB	R1,R9,#0
	MOV	R8,R8,ROR R1
	ADD	R8,R8,R11,ROR #29
	ADD	R1,R5,R11,ROR #29
	RSB	R1,R1,#0
	SUB	R4,R4,R1
	MOV	R4,R4,ROR R1
	ADD	R0,R2,R10,ROR #29
	ADD	R1,R4,R11,ROR #29
	LDMIA	R12!,{R10,R11}
	ADD	R10,R0,R10,ROR #29
	ADD	R11,R1,R11,ROR #29
	EOR	R7,R7,R6
	RSB	R1,R6,#0
	MOV	R7,R7,ROR R1
	ADD	R7,R7,R10,ROR #29
	ADD	R1,R2,R10,ROR #29
	RSB	R1,R1,#0
	SUB	R3,R3,R1
	MOV	R3,R3,ROR R1
	EOR	R9,R9,R8
	RSB	R1,R8,#0
	MOV	R9,R9,ROR R1
	ADD	R9,R9,R11,ROR #29
	ADD	R1,R4,R11,ROR #29
	RSB	R1,R1,#0
	SUB	R5,R5,R1
	MOV	R5,R5,ROR R1
	ADD	R0,R3,R10,ROR #29
	ADD	R1,R5,R11,ROR #29
	LDMIA	R12!,{R10,R11}
	ADD	R10,R0,R10,ROR #29
	ADD	R11,R1,R11,ROR #29
	EOR	R6,R6,R7
	RSB	R1,R7,#0
	MOV	R6,R6,ROR R1
	ADD	R6,R6,R10,ROR #29
	ADD	R1,R3,R10,ROR #29
	RSB	R1,R1,#0
	SUB	R2,R2,R1
	MOV	R2,R2,ROR R1
	EOR	R8,R8,R9
	RSB	R1,R9,#0
	MOV	R8,R8,ROR R1
	ADD	R8,R8,R11,ROR #29
	ADD	R1,R5,R11,ROR #29
	RSB	R1,R1,#0
	SUB	R4,R4,R1
	MOV	R4,R4,ROR R1
	ADD	R0,R2,R10,ROR #29
	ADD	R1,R4,R11,ROR #29
	LDMIA	R12!,{R10,R11}
	ADD	R10,R0,R10,ROR #29
	ADD	R11,R1,R11,ROR #29
	EOR	R7,R7,R6
	RSB	R1,R6,#0
	MOV	R7,R7,ROR R1
	ADD	R7,R7,R10,ROR #29
	ADD	R1,R2,R10,ROR #29
	RSB	R1,R1,#0
	SUB	R3,R3,R1
	MOV	R3,R3,ROR R1
	EOR	R9,R9,R8
	RSB	R1,R8,#0
	MOV	R9,R9,ROR R1
	ADD	R9,R9,R11,ROR #29
	ADD	R1,R4,R11,ROR #29
	RSB	R1,R1,#0
	SUB	R5,R5,R1
	MOV	R5,R5,ROR R1
	ADD	R0,R3,R10,ROR #29
	ADD	R1,R5,R11,ROR #29
	LDMIA	R12!,{R10,R11}
	ADD	R10,R0,R10,ROR #29
	ADD	R11,R1,R11,ROR #29
	EOR	R6,R6,R7
	RSB	R1,R7,#0
	MOV	R6,R6,ROR R1
	ADD	R6,R6,R10,ROR #29
	ADD	R1,R3,R10,ROR #29
	RSB	R1,R1,#0
	SUB	R2,R2,R1
	MOV	R2,R2,ROR R1
	EOR	R8,R8,R9
	RSB	R1,R9,#0
	MOV	R8,R8,ROR R1
	ADD	R8,R8,R11,ROR #29
	ADD	R1,R5,R11,ROR #29
	RSB	R1,R1,#0
	SUB	R4,R4,R1
	MOV	R4,R4,ROR R1
	ADD	R0,R2,R10,ROR #29
	ADD	R1,R4,R11,ROR #29
	LDMIA	R12!,{R10,R11}
	ADD	R10,R0,R10,ROR #29
	ADD	R11,R1,R11,ROR #29
	EOR	R7,R7,R6
	RSB	R1,R6,#0
	MOV	R7,R7,ROR R1
	ADD	R7,R7,R10,ROR #29
	ADD	R1,R2,R10,ROR #29
	RSB	R1,R1,#0
	SUB	R3,R3,R1
	MOV	R3,R3,ROR R1
	EOR	R9,R9,R8
	RSB	R1,R8,#0
	MOV	R9,R9,ROR R1
	ADD	R9,R9,R11,ROR #29
	ADD	R1,R4,R11,ROR #29
	RSB	R1,R1,#0
	SUB	R5,R5,R1
	MOV	R5,R5,ROR R1
	ADD	R0,R3,R10,ROR #29
	ADD	R1,R5,R11,ROR #29
	LDMIA	R12!,{R10,R11}
	ADD	R10,R0,R10,ROR #29
	ADD	R11,R1,R11,ROR #29
	EOR	R6,R6,R7
	RSB	R1,R7,#0
	MOV	R6,R6,ROR R1
	ADD	R6,R6,R10,ROR #29
	ADD	R1,R3,R10,ROR #29
	RSB	R1,R1,#0
	SUB	R2,R2,R1
	MOV	R2,R2,ROR R1
	EOR	R8,R8,R9
	RSB	R1,R9,#0
	MOV	R8,R8,ROR R1
	ADD	R8,R8,R11,ROR #29
	ADD	R1,R5,R11,ROR #29
	RSB	R1,R1,#0
	SUB	R4,R4,R1
	MOV	R4,R4,ROR R1
	ADD	R0,R2,R10,ROR #29
	ADD	R1,R4,R11,ROR #29
	LDMIA	R12!,{R10,R11}
	ADD	R10,R0,R10,ROR #29
	ADD	R11,R1,R11,ROR #29
	EOR	R7,R7,R6
	RSB	R1,R6,#0
	MOV	R7,R7,ROR R1
	ADD	R7,R7,R10,ROR #29
	ADD	R1,R2,R10,ROR #29
	RSB	R1,R1,#0
	SUB	R3,R3,R1
	MOV	R3,R3,ROR R1
	EOR	R9,R9,R8
	RSB	R1,R8,#0
	MOV	R9,R9,ROR R1
	ADD	R9,R9,R11,ROR #29
	ADD	R1,R4,R11,ROR #29
	RSB	R1,R1,#0
	SUB	R5,R5,R1
	MOV	R5,R5,ROR R1
	ADD	R0,R3,R10,ROR #29
	ADD	R1,R5,R11,ROR #29
	LDMIA	R12!,{R10,R11}
	ADD	R10,R0,R10,ROR #29
	ADD	R11,R1,R11,ROR #29
	EOR	R6,R6,R7
	RSB	R1,R7,#0
	MOV	R6,R6,ROR R1
	ADD	R6,R6,R10,ROR #29
	ADD	R1,R3,R10,ROR #29
	RSB	R1,R1,#0
	SUB	R2,R2,R1
	MOV	R2,R2,ROR R1
	EOR	R8,R8,R9
	RSB	R1,R9,#0
	MOV	R8,R8,ROR R1
	ADD	R8,R8,R11,ROR #29
	ADD	R1,R5,R11,ROR #29
	RSB	R1,R1,#0
	SUB	R4,R4,R1
	MOV	R4,R4,ROR R1
	ADD	R0,R2,R10,ROR #29
	ADD	R1,R4,R11,ROR #29
	LDMIA	R12!,{R10,R11}
	ADD	R10,R0,R10,ROR #29
	ADD	R11,R1,R11,ROR #29
	EOR	R7,R7,R6
	RSB	R1,R6,#0
	MOV	R7,R7,ROR R1
	ADD	R7,R7,R10,ROR #29
	ADD	R1,R2,R10,ROR #29
	RSB	R1,R1,#0
	SUB	R3,R3,R1
	MOV	R3,R3,ROR R1
	EOR	R9,R9,R8
	RSB	R1,R8,#0
	MOV	R9,R9,ROR R1
	ADD	R9,R9,R11,ROR #29
	ADD	R1,R4,R11,ROR #29
	RSB	R1,R1,#0
	SUB	R5,R5,R1
	MOV	R5,R5,ROR R1
	ADD	R0,R3,R10,ROR #29
	ADD	R1,R5,R11,ROR #29
	LDMIA	R12!,{R10,R11}
	ADD	R10,R0,R10,ROR #29
	ADD	R11,R1,R11,ROR #29
	EOR	R6,R6,R7
	RSB	R1,R7,#0
	MOV	R6,R6,ROR R1
	ADD	R6,R6,R10,ROR #29
	ADD	R1,R3,R10,ROR #29
	RSB	R1,R1,#0
	SUB	R2,R2,R1
	MOV	R2,R2,ROR R1
	EOR	R8,R8,R9
	RSB	R1,R9,#0
	MOV	R8,R8,ROR R1
	ADD	R8,R8,R11,ROR #29
	ADD	R1,R5,R11,ROR #29
	RSB	R1,R1,#0
	SUB	R4,R4,R1
	MOV	R4,R4,ROR R1
	ADD	R0,R2,R10,ROR #29
	ADD	R1,R4,R11,ROR #29
	LDMIA	R12!,{R10,R11}
	ADD	R10,R0,R10,ROR #29
	ADD	R11,R1,R11,ROR #29
	EOR	R7,R7,R6
	RSB	R1,R6,#0
	MOV	R7,R7,ROR R1
	ADD	R7,R7,R10,ROR #29
	ADD	R1,R2,R10,ROR #29
	RSB	R1,R1,#0
	SUB	R3,R3,R1
	MOV	R3,R3,ROR R1
	EOR	R9,R9,R8
	RSB	R1,R8,#0
	MOV	R9,R9,ROR R1
	ADD	R9,R9,R11,ROR #29
	ADD	R1,R4,R11,ROR #29
	RSB	R1,R1,#0
	SUB	R5,R5,R1
	MOV	R5,R5,ROR R1
	ADD	R0,R3,R10,ROR #29
	ADD	R1,R5,R11,ROR #29
	LDMIA	R12!,{R10,R11}
	ADD	R10,R0,R10,ROR #29
	ADD	R11,R1,R11,ROR #29
	EOR	R6,R6,R7
	RSB	R1,R7,#0
	MOV	R6,R6,ROR R1
	ADD	R6,R6,R10,ROR #29
	ADD	R1,R3,R10,ROR #29
	RSB	R1,R1,#0
	SUB	R2,R2,R1
	MOV	R2,R2,ROR R1
	EOR	R8,R8,R9
	RSB	R1,R9,#0
	MOV	R8,R8,ROR R1
	ADD	R8,R8,R11,ROR #29
	ADD	R1,R5,R11,ROR #29
	RSB	R1,R1,#0
	SUB	R4,R4,R1
	MOV	R4,R4,ROR R1
	ADD	R0,R2,R10,ROR #29
	ADD	R1,R4,R11,ROR #29
	LDMIA	R12!,{R10,R11}
	ADD	R10,R0,R10,ROR #29
	ADD	R11,R1,R11,ROR #29
	EOR	R7,R7,R6
	RSB	R1,R6,#0
	MOV	R7,R7,ROR R1
	ADD	R7,R7,R10,ROR #29
	ADD	R1,R2,R10,ROR #29
	RSB	R1,R1,#0
	SUB	R3,R3,R1
	MOV	R3,R3,ROR R1
	EOR	R9,R9,R8
	RSB	R1,R8,#0
	MOV	R9,R9,ROR R1
	ADD	R9,R9,R11,ROR #29
	ADD	R1,R4,R11,ROR #29
	RSB	R1,R1,#0
	SUB	R5,R5,R1
	MOV	R5,R5,ROR R1
	ADD	R0,R3,R10,ROR #29
	ADD	R1,R5,R11,ROR #29
	LDMIA	R12!,{R10,R11}
	ADD	R10,R0,R10,ROR #29
	ADD	R11,R1,R11,ROR #29
	EOR	R6,R6,R7
	RSB	R1,R7,#0
	MOV	R6,R6,ROR R1
	ADD	R6,R6,R10,ROR #29
	ADD	R1,R3,R10,ROR #29
	RSB	R1,R1,#0
	SUB	R2,R2,R1
	MOV	R2,R2,ROR R1
	EOR	R8,R8,R9
	RSB	R1,R9,#0
	MOV	R8,R8,ROR R1
	ADD	R8,R8,R11,ROR #29
	ADD	R1,R5,R11,ROR #29
	RSB	R1,R1,#0
	SUB	R4,R4,R1
	MOV	R4,R4,ROR R1
	ADD	R0,R2,R10,ROR #29
	ADD	R1,R4,R11,ROR #29
	LDMIA	R12!,{R10,R11}
	ADD	R10,R0,R10,ROR #29
	LDR	R12,[R13,#12]
	ADD	R11,R1,R11,ROR #29
	SUB	R0,R12,R10,ROR #29
	SUB	R1,R12,R11,ROR #29
	EOR	R0,R6,R0,ROR R6
	EOR	R1,R8,R1,ROR R8
	TEQ	R1,R9
	TEQNE	R0,R7
	BEQ	check_r9

missed:
	ADD	R12,R13,#0x30
	LDR	R2,[R13,#24]
	SUBS	R14,R14,#1
	BEQ	the_end

inc_1st:
	ADDS	R2,R2,#0x02000000
	BCC	timingloop2

carry_1st:
	ADD	R2,R2,#0x00010000
	TST	R2,#0x00FF0000
	BNE	timingloop2
	SUB	R2,R2,#0x01000000
	ADD	R2,R2,#0x0100
	TST	R2,#0xFF00
	BNE	timingloop2
	SUB	R2,R2,#0x00010000
	ADD	R2,R2,#1
	ANDS	R2,R2,#0xFF
	BNE	timingloop2
	LDR	R3,[R13,#28]
	ADDS	R3,R3,#0x01000000
	BCC	timingloop
	ADD	R3,R3,#0x00010000
	TST	R3,#0x00FF0000

check_r6:
	BNE	timingloop
	SUB	R3,R3,#0x01000000
	ADD	R3,R3,#0x0100
	TST	R3,#0xFF00
	BNE	timingloop
	SUB	R3,R3,#0x00010000
	ADD	R3,R3,#1
	AND	R3,R3,#0xFF
	B	timingloop

the_end:
	ADD	R13,R13,#0x10
	LDMIA	R13!,{R0-R3}
	ADD	R2,R2,#0x02000000
	TST	R2,#0xFF000000
	BNE	function_exit
	ADD	R2,R2,#0x00010000
	TST	R2,#0x00FF0000
	BNE	function_exit
	SUB	R2,R2,#0x01000000
	ADD	R2,R2,#0x0100
	TST	R2,#0xFF00
	BNE	function_exit
	SUB	R2,R2,#0x00010000
	ADD	R2,R2,#1
	ANDS	R2,R2,#0xFF
	BNE	function_exit
	ADDS	R3,R3,#0x01000000
	TST	R3,#0xFF000000
	BNE	function_exit
	ADD	R3,R3,#0x00010000
	TST	R3,#0x00FF0000
	BNE	function_exit
	SUB	R3,R3,#0x01000000
	ADD	R3,R3,#0x0100
	TST	R3,#0xFF00
	BNE	function_exit
	SUB	R3,R3,#0x00010000
	ADD	R3,R3,#1
	AND	R3,R3,#0xFF

function_exit:
	LDR	R11,[R13,#224]
	STMIA	R1,{R2,R3}
	LDMDB	R11,{R4-R11,R13,PC}

check_r9:
	TEQ	R1,R9
	BNE	check_r7

check_r8:
	ADD	R1,R4,R11,ROR #29
	RSB	R1,R1,#0
	SUB	R5,R5,R1
	MOV	R5,R5,ROR R1
	ADD	R1,R5,R11,ROR #29
	LDR	R11,[R13,#252]
	ADD	R1,R1,R11,ROR #29
	MOV	R11,R1,ROR #29
	LDR	R1,[R13,#8]
	SUB	R1,R1,R11
	EOR	R1,R12,R1,ROR R12
	TEQ	R1,R8
	BNE	check_r7
	ADD	R13,R13,#0x10
	LDMIA	R13!,{R0-R3}
	SUB	R0,R0,R14,LSL #1
	ADD	R0,R0,#1
	ORR	R2,R2,#0x01000000
	B	function_exit

check_r7:
	TEQ	R0,R7
	BNE	missed
	ADD	R0,R2,R10,ROR #29
	RSB	R0,R0,#0
	SUB	R3,R3,R0
	MOV	R3,R3,ROR R0
	ADD	R0,R3,R10,ROR #29
	LDR	R10,[R13,#248]
	ADD	R0,R0,R10,ROR #29
	MOV	R10,R0,ROR #29
	LDR	R0,[R13,#8]
	SUB	R0,R0,R10
	EOR	R0,R12,R0,ROR R12
	TEQ	R0,R6
	BNE	missed
	ADD	R13,R13,#0x10
	LDMIA	R13!,{R0-R3}
	SUB	R0,R0,R14,LSL #1
	B	function_exit

odd:
	SUB	R13,R13,#0x10
	MVN	R0,#0
	B	function_exit