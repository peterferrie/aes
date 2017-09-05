/**
  Copyright © 2015 Odzhan. All Rights Reserved.

  Redistribution and use in source and binary forms, with or without
  modification, are permitted provided that the following conditions are
  met:

  1. Redistributions of source code must retain the above copyright
  notice, this list of conditions and the following disclaimer.

  2. Redistributions in binary form must reproduce the above copyright
  notice, this list of conditions and the following disclaimer in the
  documentation and/or other materials provided with the distribution.

  3. The name of the author may not be used to endorse or promote products
  derived from this software without specific prior written permission.

  THIS SOFTWARE IS PROVIDED BY AUTHORS "AS IS" AND ANY EXPRESS OR
  IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED
  WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE
  DISCLAIMED. IN NO EVENT SHALL THE AUTHOR BE LIABLE FOR ANY DIRECT,
  INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES
  (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR
  SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION)
  HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT,
  STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN
  ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE
  POSSIBILITY OF SUCH DAMAGE. */

#ifndef AES_H
#define AES_H

#include "macros.h"

#define Nk 8      // key length in words
#define Nr 14     // number of rounds for 256-bit
#define Nb 4      // number of words in each block

#define AES_ENCRYPT 1
#define AES_DECRYPT 0

#define AES_BLK_LEN Nb*4

typedef union _aes_blk_t {
  uint8_t  b[Nb*4];
  uint32_t w[Nb];
  uint64_t q[Nb/2];
} aes_blk;

#pragma pack(push, 1)
typedef struct _aes_ctx_t {
  uint32_t w[Nb*(Nr+1)];
  
  uint8_t sbox[256];
  uint8_t sbox_inv[256];
} aes_ctx;
#pragma pack(pop)

#define AES_ECB_MODE 0
#define AES_CBC_MODE 1
#define AES_OFB_MODE 2
#define AES_CFB_MODE 3
#define AES_CTR_MODE 4

#ifdef __cplusplus
extern "C" { 
#endif

  void aes_enc (void*, void*);
  
  void aes_setkey (aes_ctx*, void*);
  void aes_setkeyx (aes_ctx*, void*);
  
  void aes_encrypt (aes_ctx*, void*, int);
  void aes_encryptx (aes_ctx*, void*, int);
  
#ifdef __cplusplus
}
#endif

#endif
