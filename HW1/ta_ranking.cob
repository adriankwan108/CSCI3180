       IDENTIFICATION DIVISION.
       PROGRAM-ID. TA-RANKING.
       AUTHOR.     Adrian.
      *8901*

       ENVIRONMENT DIVISION.
       INPUT-OUTPUT SECTION.
           FILE-CONTROL.
           SELECT OPTIONAL CANDIDATES ASSIGN TO 'candidates.txt'
               ORGANIZATION IS LINE SEQUENTIAL
               FILE STATUS IS CANDIDATE-FILE-STATUS.

           SELECT OPTIONAL INSTRUCTORS ASSIGN TO 'instructors.txt'
               ORGANIZATION IS LINE SEQUENTIAL
               FILE STATUS IS INSTRUCTORS-FILE-STATUS.

           SELECT OUTPUT-FILE ASSIGN TO 'output.txt'
                ORGANIZATION IS BINARY SEQUENTIAL.

       DATA DIVISION.
      *DEFINE RECORD STRUCTURE OF THE FILE 
       FILE SECTION.
       FD CANDIDATES.
       01 CANDIDATES-FILE.
           05 C-ID PIC X(11).
           05 C-SKILLTABLE OCCURS 8 TIMES.
               10 C-SKILLS PIC X(15) VALUE SPACES.
           05 C-PREF-TABLE OCCURS 3 TIMES.
               10 C-PREFERENCE PIC X(5) VALUE SPACES.

       FD INSTRUCTORS.
       01 INSTRUCTORS-FILE.
           05 I-ID PIC 9(5).
           05 I-RE-TABLE OCCURS 3 TIMES.
               10 I-REQUIRE PIC X(15) VALUE SPACES.
           05 I-OP-TABLE OCCURS 5 TIMES.
               10 I-OPTIONAL PIC X(15) VALUE SPACES.

       FD OUTPUT-FILE.
       01  RANK-RESULT.
               03 R-COURSE-ID PIC X(5) VALUE SPACES.
               03 RANK-1 PIC X(11) VALUE SPACES.
               03 RANK-2 PIC X(11) VALUE SPACES.
               03 RANK-3 PIC X(11) VALUE SPACES.
               03 END-OF-FILE PIC X.

      *DECLARE TEMPORARY VARIABLES AND FILE STRUCTURES 
       WORKING-STORAGE SECTION.
       01 CANDIDATE-FILE-STATUS PIC XX.

       01 WS-CANDIDATES.
           02 WS-C-COUNT PIC 999 VALUE ZEROES.
           02 WS-C-TABLE OCCURS 1 TO 300 TIMES 
               DEPENDING ON WS-C-COUNT.
               05 WS-C-ID PIC X(11) VALUE SPACES.
               05 WS-C-SKILLTABLE OCCURS 8 TIMES.
                   10 WS-C-SKILLS PIC X(15) VALUE SPACES.
               05 WS-C-PREF-TABLE OCCURS 3 TIMES.
                   10 WS-C-PREFERENCE PIC X(5) VALUE SPACES.
       01 WS-C-EOF PIC A(1) VALUE 'N'.

       01 INSTRUCTORS-FILE-STATUS PIC XX.
       01 WS-INSTRUCTORS.
           02 WS-I-COUNT PIC 999 VALUE ZEROES.
           02 WS-I-TABLE OCCURS 1 TO 300 TIMES DEPENDING ON WS-I-COUNT.
               05 WS-I-ID PIC 9(5).
               05 WS-I-RE-TABLE OCCURS 3 TIMES.
                   10 WS-I-REQUIRE PIC X(15) VALUE SPACES.
               05 WS-I-OP-TABLE OCCURS 5 TIMES.
                   10 WS-I-OPTIONAL PIC X(15) VALUE SPACES.
       01 WS-I-EOF PIC A(1) VALUE 'N'.
       01 WS-INDEX PIC 9(4) VALUE 1.

       01 WS-COURSE-INDEX PIC 999 VALUE 1.
       01 WS-COURSE-J PIC 9 VALUE 1.

       01 WS-TA-INDEX PIC 999 VALUE 1.
       01 WS-TA-J PIC 99 VALUE 1.

       01 WS-VALID PIC 9 VALUE 0.
       01 WS-TEMP-SCORE PIC 99V9 VALUE 00.0.
       01 WS-TEMP-PREF PIC 99V9 VALUE 00.0.
       01 WS-TEMP-ID PIC 9(10).

       01 WS-SCORESTORE.
           02 WS-SCORETABLE OCCURS 1 TO 300 TIMES 
               DEPENDING ON WS-I-COUNT.
               05 WS-TAID PIC 9(10).
               05 WS-TASCORE PIC 99V9 VALUE ZEROES.

       01 WS-CHECK PIC 9 VALUE 0.
       01 WS-SWAP-I PIC 999 VALUE 1.
       01 WS-SWAP-J PIC 999 VALUE 2.

      *VARIABLES INITIALIZED EVERY TIME STARTS EXECUTION
      *LOCAL-STORAGE SECTION.
      *DATA RECEIVED FROM AN EXTERNAL PROGRAM
      *LINKAGE SECTION.
       
       PROCEDURE DIVISION.
       MAIN-PARAGRAPH.
           PERFORM C-OPEN-PARA.
           PERFORM I-OPEN-PARA.

           PERFORM C-SAVE-PARA.
           PERFORM I-SAVE-PARA.
           
           PERFORM CHECK-EMPTY-INSTRUCTOR.
           PERFORM CHECK-CANDIDATES-EMPTY.

           OPEN OUTPUT OUTPUT-FILE.
           PERFORM MANAGER.
           CLOSE OUTPUT-FILE.

       STOP RUN.

       C-OPEN-PARA.
           OPEN INPUT CANDIDATES.
               IF CANDIDATE-FILE-STATUS = "05" THEN
                   PERFORM C-STOP-PARA
               END-IF
               PERFORM C-COUNT-PARA
           CLOSE CANDIDATES.

       C-COUNT-PARA.
           READ CANDIDATES
               AT END MOVE 'Y'TO WS-C-EOF
               NOT AT END ADD 1 TO WS-C-COUNT
           END-READ
           IF WS-C-EOF = 'N'
               GO TO C-COUNT-PARA
           END-IF.

       I-OPEN-PARA.
           OPEN INPUT INSTRUCTORS.
               IF INSTRUCTORS-FILE-STATUS = "05" THEN
               PERFORM I-STOP-PARA
               END-IF
               PERFORM I-COUNT-PARA
           CLOSE INSTRUCTORS.

       I-COUNT-PARA.
           READ INSTRUCTORS 
           AT END MOVE 'Y'TO WS-I-EOF
           NOT AT END ADD 1 TO WS-I-COUNT
           END-READ.
           IF WS-I-EOF = 'N'
               GO TO I-COUNT-PARA
           END-IF.
      
       C-SAVE-PARA.
           MOVE 1 TO WS-INDEX
           OPEN INPUT CANDIDATES.
               MOVE 'N'TO WS-C-EOF
               PERFORM C-TRANSFER-PARA
           CLOSE CANDIDATES.

       C-TRANSFER-PARA.
           READ CANDIDATES INTO CANDIDATES-FILE
               AT END MOVE 'Y' TO WS-C-EOF
           END-READ.
            IF WS-C-EOF = 'N'
                MOVE CANDIDATES-FILE TO WS-C-TABLE(WS-INDEX)
                ADD 1 TO WS-INDEX
                GO TO C-TRANSFER-PARA
            END-IF.

       I-SAVE-PARA.
           MOVE 1 TO WS-INDEX
           OPEN INPUT INSTRUCTORS.
               MOVE 'N'TO WS-I-EOF
               PERFORM I-TRANSFER-PARA
           CLOSE INSTRUCTORS.

       I-TRANSFER-PARA.
           READ INSTRUCTORS INTO INSTRUCTORS-FILE
               AT END MOVE 'Y' TO WS-I-EOF
           END-READ.
            IF WS-I-EOF = 'N'
                MOVE INSTRUCTORS-FILE TO WS-I-TABLE(WS-INDEX)
                ADD 1 TO WS-INDEX
                GO TO I-TRANSFER-PARA
            END-IF.

       VALIDITY.
           IF WS-I-REQUIRE(WS-COURSE-INDEX,WS-COURSE-J) =
               WS-C-SKILLS(WS-TA-INDEX,WS-TA-J) THEN
               ADD 1 TO WS-VALID
           END-IF
           IF WS-TA-J < 8 THEN
               ADD 1 TO WS-TA-J
               GO TO VALIDITY
           END-IF
           IF WS-TA-J=8 THEN
               IF WS-COURSE-J<3 THEN
                   ADD 1 TO WS-COURSE-J
                   MOVE 1 TO WS-TA-J
                   GO TO VALIDITY
                END-IF
            END-IF.
        
       OPTION.
           IF WS-I-OPTIONAL(WS-COURSE-INDEX, WS-COURSE-J) =
               WS-C-SKILLS(WS-TA-INDEX,WS-TA-J) THEN 
               ADD 1 TO WS-TEMP-SCORE
           END-IF
           ADD 1 TO WS-TA-J
           IF WS-TA-J <9 THEN
               GO TO OPTION
           END-IF
           IF WS-TA-J=9 THEN
               IF WS-COURSE-J<5 THEN
                   ADD 1 TO WS-COURSE-J
                   MOVE 1 TO WS-TA-J
                   GO TO OPTION
                END-IF
            END-IF.

       PREFERENCE.
           IF WS-I-ID(WS-COURSE-INDEX) = 
           WS-C-PREFERENCE(WS-TA-INDEX, WS-TA-J) THEN 
               IF WS-TA-J = 1 THEN MOVE 1.5 TO WS-TEMP-PREF END-IF
               IF WS-TA-J = 2 THEN MOVE 1.0 TO WS-TEMP-PREF END-IF
               IF WS-TA-J = 3 THEN MOVE 0.5 TO WS-TEMP-PREF END-IF
           END-IF
           ADD 1 TO WS-TA-J
           IF WS-TA-J<4 THEN
           GO TO PREFERENCE
           END-IF.

       RESTORE-INDICE.
           MOVE 1 TO WS-TA-J
           MOVE 1 TO WS-COURSE-J.

       SCORE-CAL.
           MOVE 0 TO WS-VALID
           MOVE 00.0 TO WS-TEMP-PREF
           MOVE 00.0 TO WS-TEMP-SCORE
           PERFORM RESTORE-INDICE
           PERFORM VALIDITY
           PERFORM RESTORE-INDICE
           IF WS-VALID = 3 THEN
               PERFORM OPTION
               PERFORM RESTORE-INDICE
               PERFORM PREFERENCE
               PERFORM RESTORE-INDICE
               ADD WS-TEMP-PREF 1 TO WS-TEMP-SCORE
           END-IF.

       SCORE-STORE.
           PERFORM SCORE-CAL
           MOVE WS-TEMP-SCORE TO WS-TASCORE(WS-TA-INDEX)
           MOVE WS-C-ID(WS-TA-INDEX) TO WS-TAID(WS-TA-INDEX)

           ADD 1 TO WS-TA-INDEX
           IF WS-TA-INDEX <= WS-C-COUNT THEN
               GO TO SCORE-STORE
           END-IF
           IF WS-TA-INDEX > WS-C-COUNT THEN
               MOVE 1 TO WS-TA-INDEX
           END-IF.

       SWAP.
           IF WS-TASCORE(WS-SWAP-I) < WS-TASCORE(WS-SWAP-J) THEN
      *        SWAP SCORE     
               MOVE WS-TASCORE(WS-SWAP-J) TO WS-TEMP-SCORE
               MOVE WS-TASCORE(WS-SWAP-I) TO WS-TASCORE(WS-SWAP-J)
               MOVE WS-TEMP-SCORE TO WS-TASCORE(WS-SWAP-I)
      *        SWAP ID
               MOVE WS-TAID(WS-SWAP-J) TO WS-TEMP-ID
               MOVE WS-TAID(WS-SWAP-I) TO WS-TAID(WS-SWAP-J)
               MOVE WS-TEMP-ID TO WS-TAID(WS-SWAP-I)
      *        INDICATE THERE IS A CHANGE
               MOVE 1 TO WS-CHECK        
           END-IF
           IF WS-TASCORE(WS-SWAP-I) = WS-TASCORE(WS-SWAP-J) THEN
      *        SWAP ID
               IF WS-TAID(WS-SWAP-I)>WS-TAID(WS-SWAP-J) THEN
                   MOVE WS-TAID(WS-SWAP-J) TO WS-TEMP-ID
                   MOVE WS-TAID(WS-SWAP-I) TO WS-TAID(WS-SWAP-J)
                   MOVE WS-TEMP-ID TO WS-TAID(WS-SWAP-I)
                   MOVE 1 TO WS-CHECK
               END-IF
           END-IF
           ADD 1 TO WS-SWAP-I
           ADD 1 TO WS-SWAP-J
           IF WS-SWAP-J <= WS-C-COUNT THEN
               GO TO SWAP
           END-IF
           IF WS-SWAP-J > WS-C-COUNT THEN
               IF WS-CHECK = 1 THEN
                   PERFORM RESTORE-SWAP
                   GO TO SWAP
                END-IF
            END-IF.
       
       RESTORE-SWAP.
           MOVE 0 TO WS-CHECK
           MOVE 1 TO WS-SWAP-I
           MOVE 2 TO WS-SWAP-J.

      * PRINT TO OUTPUT.TXT
       OUTPRINT.
      *    PERFORM SHOW 
           MOVE WS-I-ID(WS-COURSE-INDEX) TO R-COURSE-ID
           IF WS-TASCORE(1) = 0 THEN
               MOVE "0000000000" TO WS-TAID(1)
           END-IF
           IF WS-TASCORE(2) = 0 THEN
               MOVE "0000000000" TO WS-TAID(2)
           END-IF
           IF WS-TASCORE(3) = 0 THEN
               MOVE "0000000000" TO WS-TAID(3)
           END-IF
           MOVE WS-TAID(1) TO RANK-1
           MOVE WS-TAID(2) TO RANK-2
           MOVE WS-TAID(3) TO RANK-3
           MOVE X'0a' TO END-OF-FILE
           WRITE RANK-RESULT
           END-WRITE.

       SHOW.
           DISPLAY WS-I-ID(WS-COURSE-INDEX)
           DISPLAY WS-TAID(1) WS-TASCORE(1)
           DISPLAY WS-TAID(2) WS-TASCORE(2)
           DISPLAY WS-TAID(3) WS-TASCORE(3)
           DISPLAY WS-TAID(4) WS-TASCORE(4)
           DISPLAY WS-TAID(5) WS-TASCORE(5)
           DISPLAY WS-TAID(6) WS-TASCORE(6).

       MANAGER.
           PERFORM SCORE-STORE
           PERFORM SWAP
           PERFORM RESTORE-SWAP
           PERFORM OUTPRINT
           ADD 1 TO WS-COURSE-INDEX
           IF WS-COURSE-INDEX <= WS-I-COUNT THEN
               MOVE 1 TO WS-TA-INDEX
               PERFORM RESTORE-INDICE
               GO TO MANAGER
           END-IF.

      *EXCEPTION HANDLING
      *As it is assumed that inputs are free of format on content error
      *empty id doesn't exist, which implies that, empty id = empty file
       CHECK-EMPTY-INSTRUCTOR.
                IF WS-I-COUNT = 0 THEN
      *            DISPLAY "EMPTY INSTRUCTOR"
                   OPEN OUTPUT OUTPUT-FILE
                   WRITE RANK-RESULT
                   END-WRITE
                   CLOSE OUTPUT-FILE
                   STOP RUN
                END-IF.
            

       EMPTY-OUTPRINT.
           PERFORM OUTPRINT
           ADD 1 TO WS-COURSE-INDEX
           IF WS-COURSE-INDEX <= WS-I-COUNT THEN
               MOVE 1 TO WS-TA-INDEX
               GO TO EMPTY-OUTPRINT
           END-IF.

       CHECK-CANDIDATES-EMPTY.
           IF WS-C-ID(1) = SPACES THEN
                OPEN OUTPUT OUTPUT-FILE
                PERFORM EMPTY-OUTPRINT
                CLOSE OUTPUT-FILE
                STOP RUN
            END-IF.

       C-STOP-PARA.
           CLOSE CANDIDATES
           DISPLAY "non-existing file!"
           STOP RUN.
        
       I-STOP-PARA.
           CLOSE INSTRUCTORS
           DISPLAY "non-existing file!"
           STOP RUN.
       