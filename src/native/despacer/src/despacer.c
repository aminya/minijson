#ifndef DESPACER_H
#define DESPACER_H

#include "./despacer_tables.h"

#ifdef __SSE4_1__

#include <x86intrin.h>

static inline __m128i cleanm128(__m128i x, __m128i spaces, __m128i newline,
                                __m128i carriage, int *mask16) {
  __m128i xspaces = _mm_cmpeq_epi8(x, spaces);
  __m128i xnewline = _mm_cmpeq_epi8(x, newline);
  __m128i xcarriage = _mm_cmpeq_epi8(x, carriage);
  __m128i anywhite = _mm_or_si128(_mm_or_si128(xspaces, xnewline), xcarriage);
  *mask16 = _mm_movemask_epi8(anywhite);
  return _mm_shuffle_epi8(
      x, _mm_loadu_si128((const __m128i *)despace_mask16 + (*mask16 & 0x7fff)));
}

size_t sse4_despace_branchless_u4(char *bytes, size_t howmany) {
  size_t pos = 0;
  __m128i spaces = _mm_set1_epi8(' ');
  __m128i newline = _mm_set1_epi8('\n');
  __m128i carriage = _mm_set1_epi8('\r');
  size_t i = 0;
  for (; i + 64 - 1 < howmany; i += 64) {
    __m128i x1 = _mm_loadu_si128((const __m128i *)(bytes + i));
    __m128i x2 = _mm_loadu_si128((const __m128i *)(bytes + i + 16));
    __m128i x3 = _mm_loadu_si128((const __m128i *)(bytes + i + 32));
    __m128i x4 = _mm_loadu_si128((const __m128i *)(bytes + i + 48));

    int mask16;
    x1 = cleanm128(x1, spaces, newline, carriage, &mask16);
    _mm_storeu_si128((__m128i *)(bytes + pos), x1);
    pos += 16 - _mm_popcnt_u32(mask16);

    x2 = cleanm128(x2, spaces, newline, carriage, &mask16);
    _mm_storeu_si128((__m128i *)(bytes + pos), x2);
    pos += 16 - _mm_popcnt_u32(mask16);

    x3 = cleanm128(x3, spaces, newline, carriage, &mask16);
    _mm_storeu_si128((__m128i *)(bytes + pos), x3);
    pos += 16 - _mm_popcnt_u32(mask16);

    x4 = cleanm128(x4, spaces, newline, carriage, &mask16);
    _mm_storeu_si128((__m128i *)(bytes + pos), x4);
    pos += 16 - _mm_popcnt_u32(mask16);
  }
  for (; i + 16 - 1 < howmany; i += 16) {
    __m128i x = _mm_loadu_si128((const __m128i *)(bytes + i));
    int mask16;
    x = cleanm128(x, spaces, newline, carriage, &mask16);
    _mm_storeu_si128((__m128i *)(bytes + pos), x);
    pos += 16 - _mm_popcnt_u32(mask16);
  }
  for (; i < howmany; i++) {
    char c = bytes[i];
    if (c == '\r' || c == '\n' || c == ' ') {
      continue;
    }
    bytes[pos++] = c;
  }
  return pos;
}

#endif

#endif
