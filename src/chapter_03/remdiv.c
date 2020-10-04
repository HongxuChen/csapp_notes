void remdiv(long x, long y, long *qp, long *rp) {
    long q = x/y;
    long r = x%y;
    *qp = q;
    *rp = r;
}
// x in %rdi, y in %rsi, qp in %rdx, rp in %rcx
