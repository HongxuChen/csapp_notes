#include "stdio.h"
#include "time.h"

int main() {
    /* Use time to prevent it from being optimized away. */
    int i = !time(NULL);
    // if (__builtin_expect(i, 0))
    if (i)
        printf("%d\n", i);
    puts("a");
    return 0;
}
