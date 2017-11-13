;
;  Copyright © 2015, 2017 Odzhan, Peter Ferrie. All Rights Reserved.
;
;  Redistribution and use in source and binary forms, with or without
;  modification, are permitted provided that the following conditions are
;  met:
;
;  1. Redistributions of source code must retain the above copyright
;  notice, this list of conditions and the following disclaimer.
;
;  2. Redistributions in binary form must reproduce the above copyright
;  notice, this list of conditions and the following disclaimer in the
;  documentation and/or other materials provided with the distribution.
;
;  3. The name of the author may not be used to endorse or promote products
;  derived from this software without specific prior written permission.
;
;  THIS SOFTWARE IS PROVIDED BY AUTHORS "AS IS" AND ANY EXPRESS OR
;  IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED
;  WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE
;  DISCLAIMED. IN NO EVENT SHALL THE AUTHOR BE LIABLE FOR ANY DIRECT,
;  INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES
;  (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR
;  SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION)
;  HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT,
;  STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN
;  ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE
;  POSSIBILITY OF SUCH DAMAGE.
;
; -----------------------------------------------
; AES round of encryption in x86 assembly
;
; Inspired by emulation of aesenc in C by J.P Aumasson @veorq
;
; https://github.com/veorq/aesenc-noNI
;
; size: 187 bytes
;
; global calls use cdecl convention
;
; -----------------------------------------------
; 
    bits 32
   
   %ifndef BIN
    global _aesencx
   %endif
   
; **********************************   
; uint8_t aesenc (void *s, void *rk)
; **********************************       
_aesencx:
    pushad
    xor    ecx, ecx          ; i = 0     
    lea    esi, [esp+32+4]
    lodsd
    xchg   eax, edi          ; edi = state
    lodsd                      
    xchg   eax, ebx          ; ebx = round key 
    lodsd                    ; eax = last 
    pushad                   ; v = alloc(32)
    mov    esi, esp          ; esi = v
    dec    eax               ; last--
    pushfd
subbytes_shiftrows:    
    mov    al, [edi+ecx]     ; al = sub_byte(s[i])
    pushad
    test   al, al            ; if (x)
    xchg   eax, edx          ; y = x    
    jz     sb_l2
    ; calculate logarithm gen 3
    mov    bh, 1             ; i = 1
    mov    bl, 1             ; y = 1
sb_l0:    
    mov    al, bl            ; y ^= gf_mul2(y)
    call   gf_mul2
    xor    bl, al       
    cmp    bl, dl            ; if (y == x) break;
    jz     sb_lx
    inc    bh                ; i++
    jnz    sb_l0             ; i != 0
sb_lx:        
    ; calculate anti-logarithm gen 3
    xor    bl, bl            ; i = 0
    mov    dl, 1             ; y = 1
    xor    bh, -1            ; x = ~i (bitwise NOT doesn't affect ZF)
    jz     sb_l2    
sb_l1:
    mov    al, dl            ; al = y
    call   gf_mul2
    xor    dl, al            ; y ^= gf_mul2(y)
    inc    bl                ; i++
    cmp    bl, bh            ; i < x 
    jnz    sb_l1             ; 
sb_l2:
    mov    al, dl            ; if before sb_l0, dl is already zero
    mov    cl, 4             ; loop 4 times
sb_l3:
    rol    dl, 1             ; y = ROTL8(y, 1);
    xor    al, dl            ; sb ^= y;
    loop   sb_l3 
    xor    al, 0x63          ; sb ^= 0x63
    mov    [esp+1ch], al   
    popad
    mov    edx, ecx          ; edx = i
    mov    ebp, ecx          ; ebp = i
    shr    ebp, 2            ; ebp >>= 2
    and    edx, 3            ; edx &= 3
    sub    ebp, edx          ; ebp -= edx
    and    ebp, 3            ; ebp &= 3
    lea    edx, [edx+ebp*4]  ; edx = (edx + ebp * 4) 
    mov    [esi+edx], al     ; v.b[edx] = al
    inc    ecx               ; i++
    cmp    cl, 16            ; for (i=0; i<16; i++)
    jnz    subbytes_shiftrows
    popfd
    jz     add_round_key    
    pushad
    mov    cl, 4
    mov    edi, esi    
mix_columns:
    lodsd                    ; w0 = v.w[i]
    mov    ebx, eax          ; w1 = ROTR32(w0, 8)
    ror    ebx, 8
    mov    edx, ebx          ; w2 = ROTR32(w0, 8)
    xor    ebx, eax          ; w1 ^= w0
    xchg   eax, ebx    
    call   gf_mul2
    xor    edx, eax          ; w2 ^= gf_mul2(w1)
    ror    ebx, 16           ; w0 = ROTR32(w0, 16)
    xor    edx, ebx          ; w2 ^= w0
    ror    ebx, 8            ; w0 = ROTR32(w0, 8)
    xor    ebx, edx          ; w0 ^= w2
    xchg   ebx, eax          ; eax = w0
    stosd                    ; v.w[i] = eax
    loop   mix_columns
    popad
add_round_key:               ; for (i=0; i<16; i++) {
    lodsb                    ;   al = v.b[i] 
    xor    al, [ebx]         ;   al ^= rk[i]
    inc    ebx               ;   
    stosb                    ;   s[i] = al   
    loop   add_round_key     ; }
    popad                    ; release memory
    popad                    ; restore registers
    ret    
; *****************************
; uint32_t gf_mul2 (uint32_t w)
; *****************************
gf_mul2:
    mov    ebp, eax          ; t = w & 0x80808080
    and    ebp, 080808080h   ; 
    xor    eax, ebp          ; w ^= t
    add    eax, eax          ; w <<= 1
    shr    ebp, 7            ; t >>= 7
    imul   ebp, ebp, 01bh    ; *= 0x1b
    xor    eax, ebp          ; w ^= t
    ret    