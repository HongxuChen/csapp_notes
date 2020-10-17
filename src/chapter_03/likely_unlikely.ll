define i32 @main() local_unnamed_addr #0 {
  %1 = tail call i64 @time(i64* null) #3
  %2 = icmp eq i64 %1, 0
  br i1 %2, label %3, label %5, !prof !4, !misexpect !5  ; used metadata for branch_weights
  ...
}
!4 = !{!"branch_weights", i32 1, i32 2000}      ; metadata name
!5 = !{!"misexpect", i64 1, i64 2000, i64 1}    ; metadata weight
