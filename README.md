# COBOL-Project-2
Project 2 for CS370

PROBLEM DESCRIPTION - "CS370 Program 2 Problem Description FA19.docx"

This program builds on Program 1 (which can be found here: https://github.com/MatthewBarrett876/COBOL-Project-1) involving the same
company and also dealing with warehouses, but multiple this time around. There are now 3 warehouses in Alabama, Mississippi, and Georgia.
The report is to be seperated by warehouse location and has a few calculations applied to the input data:
  1.	Each employee’s current salary is to be increased by 5%. 
  2.	The union dues have increased by 3%.
  3.	The insurance has increased by 5%.
  4.	Total Increased Current Salary, Total Increased Union Dues, and Total Increased Insurance for each Warehouse Grouping

These new values along with the corresponding data is then sent to the report according to the printer spacing chart:"CS370 Program 2 Printer Spacing Chart F19-1.xls" Which has also been included in this repository

INPUT FILE - PR2F19.txt

this file contains an 83-character record that has the following layout:

  1. Warehouse ID(1-4)
  2. Employee ID(5-9)
  3. Employee Position(10-11)
  4. Employee Last Name(12-21)
  5. Employee First Name(22-31)
  6. Hire Date(35-42)
  7. Starting Salary(43-50)
  8. Date of Last Pay Increase(55-62)
  9. Current Salary(63-70)
  10. Union Dues(76-78)
  11. Insurance(79-83)
  
  The program will perform class breaks based on WarehouseID.
  
OUTPUT FILE - WHREPORT.TXT
this is the final output of the program. this report is formatted based ont the printer spacing chart




FUNCTION BREAKDOWN

10-MAIN-MODULE - CALLS 15-HOUSEKEEPING, 45-BUILD-REPORT
  15-Housekeeping is called, then the input record is read in and checks for the end of the file. If there are more records the 
  45-build-report is called. At the end of the input file 55-build-total is called. Afterwards, the input and output files are closed, 
  STOP-RUN ends the program

this was copied directly from project 1 as all changes were made in the build-report function

15-HOUSEKEEPING - CALLED BY 10-MAIN-MODULE // CALLS 20-TOP-HEADER-ROUTINE
  The data and report files are opened. The date is moved from they system values. This time however the date is rearranged properly
  and moved to the header line in individual values. 20-top-header-routine is called

20-TOP-HEADER-ROUTINE- CALLED BY 15-HOUSEKEEPING // CALLS 35-WRITE-A-LINE
This function writes the static headers at the beginning of the report that will not be need by the rest of the program

21-WHOUSE-HEADER-ROUTINE - CALLED BY 45-BUILD-REPORT, 500-CLASS-BREAK // CALLS 300-PRINT-WHOUSE-HEADER, 35-WRITE-A-LINE
This function is part of the major class break. This will write the name of the warehouse along with the column headers for the 
following detail lines. Also takes advantage of the proper-spacing value when calling write-a-line

35-WRITE-A-LINE - CALLED BY 20-TOP-HEADER-ROUTINE, 21-WHOUSE-HEADER-ROUTINE, 45-BUILD-REPORT, 300-PRINT-WHOUSE-HEADER, 500-CLASS-BREAK
This is a general use function that writes what ever is in the Report record to the output file. Uses the proper-spacing value to
regulate how many blank lines are between records.

45-BUILD-REPORT - CALLED BY 10-MAIN-MODULE // CALLS 21-WHOUSE-HEADER-ROUTINE, 35-WRITE-A-LINE, 400-EVAL-EMPLOYEE-POSITION, 310-INCREASE-SALARY, 315-INCREASE-UNION, 320-INCREASE-INSUR, 500-CLASS-BREAK

This function works very similar to project 1's , but has the inclustion of the Warehouse class break which is checked for in the initial If loop. The break uses the value "WH-HOLD" for the comparison with the incoming record. If the warehouse-ID is different then the one in the hold then 500-class-break is called.
The rest of the function is devoted to moving values from the incoming record to the detail line, calling functions to modify 
them along the way.

300-PRINT-WHOUSE-HEADER CALLED BY 21-WHOUSE-HEADER-ROUTINE // CALLS 35-WRTIE-A-LINE
This function determines the full name of the state base on the warehouseID value and moves the full name to the appropriate headers, then prints the initial warehouse name that will seperate the different sections of the report.

310-INCREASE-SALARY, 315-INCREASE-UNION,320-INCREASE-INSUR - CALLED BY 45-BUILD-REPORT
all of these are simple math functions that perform the requested increases from the problem statement, them moves them to the detail line, as well as to a total field for thier respective values.

400-EVAL-EMPLOYEE-POSITION - CALLED BY 45-BUILD-REPORT
a simple evaluate statement, but also the first one I had used in a program of my own. Reads in the Employee-position value then expands the two letter code to the full name of the position, then moves it to the detail line.

500-CLASS-BREAK CALLED BY 45-BUILD-REPORT

this function performs the large seperation between warehouses in the report. It starts by updating the warehouse hold value to the new value, then prints the total-line with the cumulative values that were being added to by 310,315, and 320. It then zeroes those values and prints a new set of warehouse headers by calling the 21-whouse-header-routine, which also takes care of the column headers for the new detail lines.
