write   "ssg.bin"
org     &4000
run     $
block       equ 143
space       equ ' '
rowcount    equ 10
rowlen      equ 3
numlines    equ 5
numbits     equ 7
linedup     equ 4
PPI_B       equ &F5
TXT_OUTPUT  equ &BB5A
VSYNC       equ &BD19
SETINK      equ &BC32
SETBORDER   equ &BC38
SETMODE     equ &BC0E
        xor   a
        call  SETMODE
        call  setscr
        ld    b, a
        ld    c, a
        inc   a
        call  SETINK
        ld    hl, lines
        ld    b, numlines
lineloop:
        ld    a, (hl)
        ld    de, line1
        add   e
        ld    e, a
        push  bc
        ld    b, linedup        
duploop:
        call  txtout
        djnz  duploop
        pop   bc
        inc   hl        
        djnz  lineloop
        ld    a, &18
        call  setscr
        ld    c, 2
innerloop:
        dec   a
        and   &3f
        call  setcrtc
        call  VSYNC
        jr    innerloop        
txtout
        push  hl
        push  de
        push  bc        
        ld    a, rowlen
loop:
        ld    b, numbits
        cp    1
        jr    nz, not_last
        dec   b
not_last:
        push  af                
        ld    a, (de)
inners:    
        rra
        push  af    
        ld    a, space
        jr    nc, skip
        ld    a, block
skip:
        call  TXT_OUTPUT
        pop   af
        djnz  inners        
        inc   de
        pop   af
        sub   1
        jr    nz, loop
        pop   bc
        pop   de
        pop   hl
        ret        
setscr:
        ld    c, 6
setcrtc: ;; c = index, a = value
        ld    b, &bc
        out   (c), c
        inc   b
        out   (c), a
        ret
                
lines   defb    0, rowlen, rowlen * 3, rowlen * 2, 0
line1   defb    %0111111, %0111111, %0111111
line2   defb    %0000011, %0000011, %0000011
line4   defb    %0110000, %0110000, %0110011
line3   defb    %0111111, %0111111, %0110011
