not R2, R0
add R2, R3, R0
li R4, 8
addi R4, R4, 4      -- R4 = 8 + 4 περιμένουμε ο R4 να βγει 12 decimal -> 1100 binary
sw R2, R4, 0        -- στη θέση R4+0 βάλε το R2
lw R4, R0, 8        -- φερε στο R4 τη θέση 8 της μνήμης
beq R2 R3 3         -- branch taken
lb R4, R0, 8

100000 00000 00010 00000 00000 110100
100000 00010 00011 00000 00000 110000
111000 00000 00100 00000000 00001000
110000 00100 00100 00000000 00000100
011111 00100 00010 00000000 00000000
001111 00000 00100 00000000 00001000
010000 00011 00010 0000000000000011
10000001000001010101000000110011		
10000000101001100000000000111100			
10000000110001010000000000111101
000011 00000 00100 00000000 00001000

