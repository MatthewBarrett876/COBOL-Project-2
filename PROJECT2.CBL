       IDENTIFICATION DIVISION.
       PROGRAM-ID. PROJECT2.
       AUTHOR. M BARRETT.
      ***************************************************************
      * This program is designed to group warehouse data together 
      * based on location(more specifcially WarehouseID) then make
      * the following changes:
      *
      * Increase employee salary by 5%
      * Increase Union dues by 3%
      * Increase Insurance by 5%
      * 
      * These increases will be totaled for every warehouse
      * 
      ********
      * INPUT: PR2F19.txt
      *     The employee file contains the following records:
      *       1. Warehouse ID
      *       2. Employee ID
      *       3. Employee Position
      *       4. Employee Last Name
      *       5. Employee First Name
      *       6. Hire Date
      *       7. Starting Salary
      *       8. Date of Last Pay Increase
      *       9. Current Salary
      *      10. Union Dues
      *      11. Insurance
      * *******
       ENVIRONMENT DIVISION.
       CONFIGURATION SECTION.
       SOURCE-COMPUTER. PC.
       OBJECT-COMPUTER. PC.

       INPUT-OUTPUT SECTION.
       FILE-CONTROL.
            SELECT DATA-FILE
               ASSIGN TO 'PR2FA19.TXT'
               ORGANIZATION IS LINE SEQUENTIAL.
            SELECT REPORT-FILE
               ASSIGN TO PRINTER 'WHREPORT.TXT'.
 
       DATA DIVISION.
       FILE SECTION.

       FD DATA-FILE
          RECORD CONTAINS 83 CHARACTERS.

       01 IN-EMPLOYEE-RECORD.
          05 WAREHOUSE-ID    PIC X(4).
          05 EMPLOYEE-ID     PIC X(5).
          05 EMPLOYEE-POS    PIC X(2).
          05 EMP-LAST        PIC X(10).
          05 EMP-FIRST       PIC X(10).
          05 FILLER          PIC X(3).
          05 HIRE-DATE       PIC S9(8).
          05 START-SAL       PIC 999999V99.
          05 FILLER-2        PIC X(4).
          05 LAST-INC        PIC S9(8).
          05 CUR-SAL         PIC 999999V99.
          05 FILLER-3        PIC X(5).
          05 UNION-DUES      PIC 999.
          05 INSURANCE       PIC 999V99.

       FD REPORT-FILE
          RECORD CONTAINS 80 CHARACTERS.
       
       01 REPORT-RECORD   PIC X(80).

       WORKING-STORAGE SECTION.

       01  WS-WORK-AREAS.
           05 ARE-THERE-MORE-RECORDS PIC X(3) VALUE 'YES'.
           05 FIRST-RECORD           PIC X(3) VALUE 'YES'.
           05 WH-HOLD                PIC XXXX.
           05 SALARY-HOLD            PIC 999999V99.
           05 UNION-HOLD             PIC 999V99.
           05 INSUR-HOLD             PIC 999999V99.

       01 TOTAL-FIELDS.
           05  INCR-CURR    PIC 999999V99.
           05  INCR-UNION   PIC 999V99.
           05  INCR-INSUR   PIC 999999V99.

       01 REPORT-FIELDS.
          05  PROPER-SPACING    PIC S9      VALUE +1.
          05  BLANK-FILLER      PIC X(80)   VALUE SPACES.
   
       01  WS-CURRENT-DATE.
           05  WS-YEAR                     PIC 99.
           05  WS-MONTH                    PIC 99.
           05  WS-DAY                      PIC 99.


      *********     OUTPUT AREA     **********************************
       01 HEADING-ONE.
          05  H1-DATE.
               10  H1-MONTH                PIC Z9.
               10                          PIC X     VALUE '/'.
               10  H1-DAY                  PIC 99.
               10                          PIC X     VALUE '/'.
               10  H1-YEAR                 PIC 99.
          05                  PIC X(22)   VALUE '    MAB'.
          05                  PIC X(35)   VALUE 'DRAKEA, LTD'.
          05                  PIC X(8)    VALUE 'PAGE 01 '.

       01 HEADING-TWO.
          05                  PIC X(32)   VALUE SPACES.
          05                  PIC X(13)   VALUE 'SALARY REPORT'.
          05                  PIC X(31)   VALUE SPACES.

       01 HEADING-THREE.
          05                  PIC X(12)   VALUE 'WAREHOUSE:'.
          05 WHOUSE-NAME      PIC X(11).
          05                  PIC X(57)   VALUE SPACES.

       01 HEADING-FOUR.
          05                  PIC X(2)    VALUE SPACES.
          05                  PIC X(12)   VALUE 'EMPLOYEE'.
          05                  PIC X(13)   VALUE 'EMPLOYEE'.
          05                  PIC X(12)   VALUE 'EMPLOYEE'.
          05                  PIC X(14)   VALUE 'INCREASED'.
          05                  PIC X(13)   VALUE 'INCREASED'.
          05                  PIC X(13)   VALUE 'INCREASED'.

       01 HEADING-FIVE.
          05                  PIC X(5)    VALUE SPACES.
          05                  PIC X(9)    VALUE 'ID'.
          05                  PIC X(12)   VALUE 'POSITION'.
          05                  PIC X(14)   VALUE 'LAST NAME'.
          05                  PIC X(13)   VALUE 'CURRENT'.
          05                  PIC X(13)   VALUE 'UNION DUES'.
          05                  PIC X(12)   VALUE 'INSURANCE'.

        01 DETAIL-LINE.
          05                  PIC X(3)    VALUE SPACES.
          05 DL-EMP-ID        PIC X(10).
          05 DL-EMP-POS       PIC X(13).
          05 DL-EMP-LAST      PIC X(13).
          05 DL-INC-CUR       PIC $ZZZ,ZZZ.99.
          05                  PIC X(3)    VALUE SPACES.
          05 DL-INC-UNION     PIC $ZZ,ZZZ.99.
          05                  PIC X(3)    VALUE SPACES.
          05 DL-INC-INSUR     PIC $ZZ,ZZZ.99.
          05                  PIC X(3)    VALUE SPACES.

        01 TOTAL-LINE.
          05                  PIC X(7)    VALUE SPACES.
          05 TL-WHOUSE        PIC X(12).
          05                  PIC X(18) VALUE 'WAREHOUSE TOTAL:'.
          05 TL-INC-CURR      PIC $Z,ZZZ,ZZZ.99.
          05                  PIC X(2)    VALUE SPACES.
          05 TL-INC-UNION     PIC $ZZZ,ZZZ.99.
          05                  PIC X(2)    VALUE SPACES.
          05 TL-INC-INSUR     PIC $ZZZ,ZZZ.99.
          05                  PIC X(3)    VALUE SPACES.

       PROCEDURE DIVISION.

       10-MAIN-MODULE.
          PERFORM 15-HOUSEKEEPING
          PERFORM UNTIL ARE-THERE-MORE-RECORDS = 'NO '
             READ DATA-FILE
               AT END
                 MOVE 'NO ' TO ARE-THERE-MORE-RECORDS
               NOT AT END
                 PERFORM 45-BUILD-REPORT
             END-READ
          END-PERFORM
          CLOSE DATA-FILE
                REPORT-FILE
          STOP RUN
          .
      
        15-HOUSEKEEPING.
         OPEN INPUT  DATA-FILE
              OUTPUT  REPORT-FILE
         ACCEPT WS-CURRENT-DATE FROM DATE
           MOVE WS-MONTH TO H1-MONTH
           MOVE WS-DAY TO H1-DAY
           MOVE WS-YEAR TO H1-YEAR
         PERFORM 20-TOP-HEADER-ROUTINE
         .



        20-TOP-HEADER-ROUTINE.
         WRITE REPORT-RECORD FROM HEADING-ONE
            AFTER ADVANCING PAGE
         MOVE 2 TO PROPER-SPACING
         MOVE HEADING-TWO TO REPORT-RECORD
         PERFORM 35-WRITE-A-LINE
         .


        21-WHOUSE-HEADER-ROUTINE.
         PERFORM 300-PRINT-WHOUSE-HEADER
         MOVE 3 TO PROPER-SPACING
         MOVE HEADING-FOUR TO REPORT-RECORD
         PERFORM 35-WRITE-A-LINE
         MOVE 1 TO PROPER-SPACING
         MOVE HEADING-FIVE TO REPORT-RECORD
         PERFORM 35-WRITE-A-LINE
         MOVE 2 TO PROPER-SPACING
         .


        35-WRITE-A-LINE.
          WRITE REPORT-RECORD
             AFTER ADVANCING PROPER-SPACING
          .

        45-BUILD-REPORT.
         
         IF FIRST-RECORD = 'YES'
            MOVE WAREHOUSE-ID TO WH-HOLD
            MOVE 'NO' TO FIRST-RECORD
            PERFORM 21-WHOUSE-HEADER-ROUTINE
         ELSE
           IF WAREHOUSE-ID NOT = WH-HOLD
              PERFORM 500-CLASS-BREAK
 
           END-IF
         END-IF
         


         
         MOVE EMPLOYEE-ID TO DL-EMP-ID
         PERFORM 400-EVAL-EMPLOYEE-POSITION
         MOVE EMP-LAST TO DL-EMP-LAST
         PERFORM 310-INCREASE-SALARY
         PERFORM 315-INCREASE-UNION
         PERFORM 320-INCREASE-INSUR
         MOVE DETAIL-LINE TO REPORT-RECORD
         PERFORM 35-WRITE-A-LINE
         MOVE 1 TO PROPER-SPACING
         .


        300-PRINT-WHOUSE-HEADER.
        
        IF WAREHOUSE-ID = 'AL10'
           MOVE 'ALABAMA' TO WHOUSE-NAME
           MOVE 'ALABAMA' TO TL-WHOUSE
        ELSE
           IF WAREHOUSE-ID = 'GA11'
             MOVE 'GEORGIA' TO WHOUSE-NAME
             MOVE 'GEORGIA' TO TL-WHOUSE
           ELSE
             IF WAREHOUSE-ID = 'MS12'
               MOVE 'MISSISSIPPI' TO WHOUSE-NAME
               MOVE 'MISSISSIPPI' TO TL-WHOUSE
             END-IF
           END-IF
        END-IF
        MOVE HEADING-THREE TO REPORT-RECORD
        PERFORM 35-WRITE-A-LINE
        .

        310-INCREASE-SALARY.
        COMPUTE SALARY-HOLD = CUR-SAL * .05
        ADD SALARY-HOLD TO INCR-CURR
        COMPUTE DL-INC-CUR = CUR-SAL + SALARY-HOLD
        .
        315-INCREASE-UNION.
        COMPUTE UNION-HOLD = UNION-DUES * .03
        ADD UNION-HOLD TO INCR-UNION
        COMPUTE DL-INC-UNION = UNION-DUES + UNION-HOLD
        .
        320-INCREASE-INSUR.
        COMPUTE INSUR-HOLD = INSURANCE * .05
        ADD INSUR-HOLD TO INCR-INSUR
        COMPUTE DL-INC-INSUR = INSURANCE + INSUR-HOLD
        .
        
        400-EVAL-EMPLOYEE-POSITION.
         EVALUATE EMPLOYEE-POS
           WHEN 'WM'
             MOVE 'MANAGER' TO DL-EMP-POS
           WHEN 'DS'
             MOVE 'SUPERVISOR' TO DL-EMP-POS
           WHEN 'OW'
             MOVE 'OFFICE' TO DL-EMP-POS
           WHEN 'WW'
             MOVE 'WAREHOUSE' TO DL-EMP-POS
           WHEN 'WS'
             MOVE 'SECURITY' TO DL-EMP-POS
         END-EVALUATE
         .

        500-CLASS-BREAK.
          MOVE WAREHOUSE-ID TO WH-HOLD.
          MOVE 3 TO PROPER-SPACING
          MOVE INCR-CURR TO TL-INC-CURR
          MOVE INCR-UNION TO TL-INC-UNION
          MOVE INCR-INSUR TO TL-INC-INSUR
          MOVE TOTAL-LINE TO REPORT-RECORD
          PERFORM 35-WRITE-A-LINE
          MOVE 0 TO INCR-CURR
          MOVE 0 TO INCR-UNION
          MOVE 0 TO INCR-INSUR
          PERFORM 21-WHOUSE-HEADER-ROUTINE
        .












