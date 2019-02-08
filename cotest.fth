\ Tests for conditions

\ THROW and CATCH

: TEST-NOTHROW   ;
: TEST-NOCATCH   ['] TEST-NOTHROW CATCH ;
\ result: 0

: TEST-UNDERTHROW   >F THROW ;
: TEST-UNDERCATCH   1 2 >F 3   ['] TEST-UNDERTHROW CATCH AND   F> ;
\ result: 1 2

: TEST-OVERTHROW   4 5 THROW ;
: TEST-OVERCATCH   3   ['] TEST-OVERTHROW CATCH AND ;
\ result: 3 4 5

: TEST-NESTTHROW   TEST-NOCATCH TEST-UNDERCATCH
  TEST-OVERCATCH THROW ;
: TEST-NESTCATCH   -2 -1 ['] TEST-NESTTHROW CATCH AND ;
\ result: -2 -1 0 1 2 3 4 5

\ SIGNAL, HANDLE, and DECLINE

: TEST-HANDLE-S   2 SIGNAL ;
: TEST-HANDLE-H   DROP 1 - ;
: TEST-HANDLE  ['] TEST-HANDLE-S ['] TEST-HANDLE-H HANDLE
  HANDLER @ FP0 = AND ;
\ result: 1

: TEST-DECLINE-S   1 SIGNAL ;
: TEST-DECLINE-H   3 SWAP DECLINE ;
: TEST-DECLINE-T   ['] TEST-DECLINE-S ['] TEST-DECLINE-H HANDLE ;
: TEST-DECLINE   ['] TEST-DECLINE-T ['] TEST-HANDLE-H HANDLE
  HANDLER @ FP0 = AND ;
\ result: 1 2

\ OFFER and AGREE

: TEST-NOAGREE-A   DROP ;
: TEST-NOAGREE   ['] TEST-NOAGREE-A OFFER ;
\ result: 0

: TEST-INNERAGREE-A   1 SWAP AGREE ;
: TEST-INNERAGREE   ['] TEST-INNERAGREE-A OFFER AND ;
\ result: 1

: TEST-OUTERAGREE-A   DROP 2 SWAP AGREE ;
: TEST-OUTERAGREE-B   ['] TEST-OUTERAGREE-A OFFER ;
: TEST-OUTERAGREE   ['] TEST-NOAGREE OFFER OR NIP
  ['] TEST-INNERAGREE OFFER OR NIP   ['] TEST-OUTERAGREE-B OFFER AND
  OFFERS @ FP0 = AND ;
\ result: 0 1 2

\ Class system

TOP CLASS FOO
: TEST-FOO   FOO DUP   DUP @ SWAP   CELL+ DUP @ SWAP   DROP ;
\ result: x 1cells x

FOO CLASS BAR
: TEST-BAR   BAR DUP   DUP @ SWAP   CELL+ DUP @ SWAP
  CELL+ DUP @ SWAP   DROP ;
\ result: y 2cells x y

BAR CLASS BAZ
: TEST-BAZ   BAZ DUP   DUP @ SWAP   CELL+ DUP @ SWAP
  CELL+ DUP @ SWAP   CELL+ DUP @ SWAP   DROP ;
\ result: z 3cells x y z

: TEST-EXTENDS   BAZ FOO EXTENDS  BAR BAZ EXTENDS ;
\ result: true false
