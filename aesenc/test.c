#include <stdio.h>
#include <string.h>
#include <stdint.h>

#include <tmmintrin.h>
#include <wmmintrin.h>

#if defined(_MSC_VER)
#define ALIGNED_(x) __declspec(align(x))
#else
#if defined(__GNUC__)
#define ALIGNED_(x) __attribute__ ((aligned(x)))
#endif
#endif

typedef union ALIGNED_(16) _w128_t {
  uint8_t b[16];
  uint32_t w[4];
  __m128i x;
} w128_t;

#ifdef DYNAMIC
extern void aesenc (uint8_t *s, const uint8_t *rk, int last);
void aesencx (uint8_t *s, const uint8_t *rk, int last);
#else
extern void aesenc (uint8_t *s, const uint8_t *rk);
#endif

extern void aesenclast (uint8_t *s, const uint8_t *rk);

int main (void) {
    w128_t rk, s, s0, rk128, s128;
    int    i;

    for (i=0; i<16; i++) rk.b[i] = i;
    for (i=0; i<16; i++)  s.b[i] = i;
    
    rk128.x = _mm_load_si128 (&rk.x);
    s128.x  = _mm_load_si128 (&s.x);

    #ifdef DYNAMIC
    aesenc (s.b, rk.b, 0);
    #else
    aesenc (s.b, rk.b);
    #endif
    
    s128.x = _mm_aesenc_si128 (s128.x, rk128.x);
    _mm_storeu_si128 (&s0.x, s128.x);

    if (!memcmp(s.b, s0.b, 16)) printf("aesenc ok\n");
    else printf("aesenc fail\n");

    rk128.x = _mm_load_si128 (&rk.x);
    s128.x = _mm_load_si128 (&s.x);

    #ifdef DYNAMIC
    aesenc (s.b, rk.b, 1);
    #else
    aesenclast (s.b, rk.b);
    #endif
    
    s128.x = _mm_aesenclast_si128 (s128.x, rk128.x);
    _mm_storeu_si128 (&s0.x, s128.x);

    if (!memcmp(s.b, s0.b, 16)) printf("aesenclast ok\n");
    else printf("aesenclast fail\n");
}
