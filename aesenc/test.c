#include <stdio.h>
#include <string.h>
#include <stdint.h>

#include <tmmintrin.h>
#include <wmmintrin.h>

#ifdef DYNAMIC
extern void aesenc (uint8_t *s, const uint8_t *rk, int last);
void aesencx (uint8_t *s, const uint8_t *rk, int last);
#else
extern void aesenc (uint8_t *s, const uint8_t *rk);
#endif

extern void aesenclast (uint8_t *s, const uint8_t *rk);

int main () {
    uint8_t rk[16], s[16], s0[16];
    __m128i rk128, s128;

    for (int i = 0; i < 16; ++i) rk[i] = i;
    for (int i = 0; i < 16; ++i) s[i] = i;
    rk128 = _mm_load_si128 ((__m128i *)rk);
    s128 = _mm_load_si128 ((__m128i *)s);

    #ifdef DYNAMIC
    aesencx (s, rk, 0);
    #else
    aesenc (s, rk);
    #endif
    s128 = _mm_aesenc_si128 (s128, rk128);
    _mm_storeu_si128 ((__m128i *)s0, s128);

    if (!memcmp(s,s0,16)) printf("aesenc ok\n");
    else printf("aesenc fail\n");

    rk128 = _mm_load_si128 ((__m128i *)rk);
    s128 = _mm_load_si128 ((__m128i *)s);

    #ifdef DYNAMIC
    aesencx (s, rk, 1);
    #else
    aesenclast (s, rk);
    #endif
    
    s128 = _mm_aesenclast_si128 (s128, rk128);
    _mm_storeu_si128 ((__m128i *)s0, s128);

    if (!memcmp(s,s0,16)) printf("aesenclast ok\n");
    else printf("aesenclast fail\n");
}
