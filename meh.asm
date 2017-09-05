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
; Inspired by emulation of aesenc in C by J.P Aumasson.
;
; 
;
; size: 200 bytes
;
; global calls use cdecl convention
;
; -----------------------------------------------
; 
    bits 32
   
   %ifdef BIN
    ;global _aesenc
   %endif
   
; **********************************   
; uint8_t aesenc (void *s, void *rk)
; **********************************       
_aesenc:
    pushad
    xor    ecx, ecx          ; i = 0     
    lea    esi, [esp+32+4]
    lodsd
    push   eax               ; save state
    lodsd                    
    xchg   eax, ebx          ; ebx = round key 
    lodsd                    ; eax = last
    pop    esi               ; esi = state   
    pushad                   ; v = alloc(32)
    mov    edi, esp          ; edi = v
    dec    eax               ; last--
    pushfd
subbytes_shiftrows:    
    mov    al, [esi+ecx]     ; al = sub_byte(s[i])
    call   sub_byte
    mov    edx, ecx          ; edx = i
    mov    ebp, ecx          ; ebp = i
    shr    ebp, 2            ; ebp >>= 2
    and    edx, 3            ; edx &= 3
    sub    ebp, edx          ; ebp -= edx
    and    ebp, 3            ; ebp &= 3
    lea    edx, [edx+ebp*4]  ; edx = (edx + ebp * 4) 
    mov    [edi+edx], al     ; v.b[edx] = al
    inc    ecx               ; i++
    cmp    cl, 16            ; for (i=0; i<16; i++)
    jnz    subbytes_shiftrows
    popfd
    js     add_round_key    
    pushad
    mov    cl, 4    
mix_columns:
    mov    ebx, [edi]        ; w0 = v.w[i];
    mov    edx, ebx
    ror    edx, 8
    mov    eax, edx
    xor    edx, ebx
    call   gf_mul2
    xor    eax, edx
    ror    ebx, 16
    xor    eax, ebx
    ror    ebx, 8
    xor    eax, ebx
    stosd
    loop   mix_columns
    popad
add_round_key:
    mov    al, [edi]
    xor    al, [ebx]
    inc    ebx
    mov    [esi], al
    cmpsb
    loop   add_round_key    
    popad
    popad
    ret    
; *****************************
; uint32_t gf_mul2 (uint32_t w)
; *****************************
gf_mul2:
    mov    ebp, eax
    and    ebp, 080808080h
    xor    eax, ebp
    add    eax, eax
    shr    ebp, 7
    imul   ebp, ebp, 01bh
    xor    eax, ebp
    ret
; *****************************   
; uint8_t sub_byte (uint8_t x)
; *****************************       
sub_byte:
    pushad
    xor    ebx, ebx     ; y = 0
    mov    cl, 4
    test   al, al       ; if (x) {
    xchg   eax, edx     ; edx = x    
    je     sb_l3
    inc    ebx          ; y = 1
sb_l0:
    mov    al, bl       ; al = y
    call   gf_mul2
    xor    bl, al       ; y ^= gf_mul2 (y);
    inc    bh           ; i++
    cmp    dl, bl       ; if (x == y) break;
    jne    sb_l0    
    mov    bl, 1        ; y=1
sb_l1:
    mov    al, bl       ; al = y     
    call   gf_mul2
    xor    bl, al       ; y ^= gf_mul2(y);
    inc    bh           ; i++
    jnz    sb_l1
sb_l3:
    rol    bl, 1        ; y = ROTL8(y, 1);
    xor    al, bl       ; sb ^= y;
    loop   sb_l3
    xor    al, 63h      ; return sb ^ 0x63
    mov    byte[esp+1ch], al
    popad
    ret
    