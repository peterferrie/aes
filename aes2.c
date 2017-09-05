
#include "macros.h"
#include "aes.h"

#define RotWord(x) ROTR32(x, 8)

typedef union _w32_t {
  uint8_t  b[4];
  uint32_t w; 
} w32_t;

typedef union _w128_t {
  uint8_t  b[16];
  uint8_t  m[4][4];
  uint32_t w[4];
} w128_t;

typedef union _w256_t {
  uint8_t  b[32];
  uint32_t w[8];
} w256_t;

uint32_t XT (uint32_t w) {
    uint32_t t = w & 0x80808080;
    
    return ( (w ^ t ) << 1) ^ ( ( t >> 7) * 0x0000001B);
}

// ------------------------------------
// multiplicative inverse
// ------------------------------------
uint8_t gf_mulinv (uint8_t x)
{
    uint8_t y=x, i;

    if (x)
    {
      // calculate logarithm gen 3
      for (y=1, i=0; ;i++) {
        y ^= XT(y);
        if (y==x) break;
      }
      i += 2;
      // calculate anti-logarithm gen 3
      for (y=1; i; i++) {
        y ^= XT(y);
      }
    }
    return y;
}

// ------------------------------------
// substitute byte
// ------------------------------------
uint8_t SubByte (uint8_t x)
{
    uint8_t i, y=0, sb;

    sb = y = gf_mulinv (x);

    for (i=0; i<4; i++) {
      y   = ROTL8(y, 1);
      sb ^= y;
    }
    return sb ^ 0x63;
}

// ------------------------------------
// substitute 4 bytes
// ------------------------------------
uint32_t SubWord (uint32_t x)
{
    uint8_t i;
    w32_t   r;

    r.w=x;
    
    for (i=0; i<4; i++) {
      r.b[i] = SubByte(r.b[i]);
    }
    return r.w;
}

// ------------------------------------
// create AES-256 key
// ------------------------------------
void aes_setkey (aes_ctx *ctx, void *key)
{
    int      i;
    uint32_t x;
    uint32_t *w=(uint32_t*)ctx->w;
    uint32_t rcon=1;

    memcpy (w, key, Nk);

    for (i=Nk; i<Nb*(Nr+1); i++)
    {
      x = w[i-1];
      if ((i % Nk)==0) {
        x = RotWord(x);
        x = SubWord(x) ^ rcon;
        rcon=XT(rcon);
      } else if ((Nk > 6) && ((i % Nk) == 4)) {
        x=SubWord(x);
      }
      w[i] = w[i-Nk] ^ x;
    }
}

void aes_enc (void *state, void *key) {
    w128_t  *s, *k, v;
    uint32_t i, w, r;
    
    s=(w128_t*)state;
    k=(w128_t*)key;

    // copy first key to local buffer
    memcpy (&v, s, 16);
    r = 0;
    goto add_key;
    
    do { 
      // sub bytes and shift rows
      for (i=0; i<16; i++) {     
        v.m[((i >> 2) + 4 - (i & 3) ) & 3][i & 3] = SubByte(s->b[i]);
      }
    
      // if not last round
      if (r != Nr) {
        // mix columns
        for (i=0; i<4; i++) {
          w = v.w[i];
          v.w[i] = ROTR32(w,  8) ^ 
                   ROTR32(w, 16) ^ 
                   ROTL32(w,  8) ^ 
                   XT(ROTR32(w, 8) ^ w);
        }
      }
add_key:    
      // add round key
      for (i=0; i<4; i++) {
        s->w[i] = v.w[i] ^ k->w[i];
      }
      k++;    
    } while (++r <= Nr);
}
