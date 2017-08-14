      * ----------------------------------------------------------------
      * | CSCI3180 Principles of Programming Languages                 |
      * |                                                              |
      * | --- Declaration ---                                          |
      * | I declare that the assignment here submitted is original     |
      * | except for source material explicitly acknowledged. I also   |
      * | acknowledge that I am aware of University policy and         |
      * | regulations on honesty in academic work, and of the          |
      * | disciplinary guidelines and procedures applicable to reaches |
      * | of such policy and regulations, as contained in the website  |
      * | http://www.cuhk.edu.hk/policy/academichonesty/               |
      * |                                                              |
      * | Assignment 1                                                 |
      * | Name:
      * | Student ID:
      * | Email Addr:
      * ----------------------------------------------------------------

      * NOTE: this program was translated from the FORTRAN source,
      * please refer to the comments in dda.for for in-depth details.
      * function and variable naming conventions should be similar.

       identification division.
       program-id. dda.

       environment division.
       input-output section.
       file-control.

           select ifile assign to disk
               organization is line sequential
               file status is istatus.

           select ofile assign to disk
               organization is line sequential
               file status is ostatus.

      * ifile: maximum of two 2-digit int per line, read into a and b.
      * ofile: records of 79 characters per line.
       data division.
       file section.
       fd ifile label record is standard
           value of file-id is "input.txt".
       01 irecord.
           05 a         pic 9(2).
           05 filler    pic X(1).
           05 b         pic 9(2).
       fd ofile label record is standard
           value of file-id is "output.txt".
       01 orecord pic X(79).

      * n: number of points
      * x: x-coordinate of input points (array)
      * y: y-coordinate of input points (array)
      * i/ostatus: status of I/O file operations
      * plot: output plot (array of strings) 
      * x/yi, x/yj: begin/end points of the DDA algorithm
      * m: DDA line gradiant
      * m2: m-squared, since abs() is not avaliable in MS COBOL
      * i, j: iterators 
      * c1/2/3: temporary compute variables 
      * flag: state of DDA algorithm for flow control
       working-storage section.
       01 n pic 9(2).
       01 idata.
           05 points occurs 99 times.
               10 x pic 9(2).
               10 y pic 9(2).
       01 istatus pic X(2).
       01 ostatus pic X(2).
       01 odata.
           05 plot pic X(79) occurs 23 times.
       01 xi pic 9(2).
       01 yi pic 9(2).
       01 xj pic 9(2).
       01 yj pic 9(2).
       01 m pic S9(3)V9(6).
       01 m2 pic S9(3)V9(6).
       01 i pic 9(2).
       01 j pic 9(2).
       01 c1 pic 9(3).
       01 c2 pic 9(3).
       01 c3 pic 9(3).
       01 flag pic 9.
           
       procedure division.
       main.
           perform readFile.
           perform plotInit.
           move 1 to i.
           perform main-loop.
           perform plotPrint.
           stop run.
       main-loop.
           move 0 to flag.
           perform plotLine.
           add 1 to i.
           if i < n go to main-loop.

       plotLine.
           if flag = 0 go to setupPoints.
      *    if flag = 1 display '(' xi ',' yi ')--(' xj ',' yj ') ' m.
           move 0 to j.
           if flag = 1 and m2 not > 1 go to plotLine-sx.
           if flag = 1 and m2     > 1 go to plotLine-sy.
       plotLine-sx.
           compute c1 = xi + j + 1.
           compute c2 rounded = yi + (j * m) + 1.
           string "*" delimited by size into plot(c2) with pointer c1.
           add 1 to j.
           compute c1 = xi + j. 
           if c1 not > xj go to plotLine-sx.
           move 2 to flag.
           go to plotLine.
       plotLine-sy.
           compute c1 rounded = xi + (j / m) + 1.
           compute c2 = yi + j + 1.
           string "*" delimited by size into plot(c2) with pointer c1.
           add 1 to j.
           compute c1 = yi + j. 
           if c1 not > yj go to plotLine-sy.
           move 2 to flag.
           go to plotLine.

       setupPoints.
           compute c3 = i + 1.
           compute c1 = x(i) + y(i).
           compute c2 = x(c3) + y(c3).
           if c1 > c2   go to setupPoints-b.
                        go to setupPoints-a.
       setupPoints-a.
           move x(i)  to xi. move y(i)  to yi.
           move x(c3) to xj. move y(c3) to yj.
           compute m = ( yj - yi ) / ( xj - xi )
               on size error move 999 to m.
           compute m2 = m ** 2
               on size error move 999 to m2.
           move 1 to flag.
           go to plotLine.
       setupPoints-b.
           move x(c3) to xi. move y(c3) to yi.
           move x(i)  to xj. move y(i)  to yj.
           compute m = ( yj - yi ) / ( xj - xi )
               on size error move 999 to m.
           compute m2 = m ** 2
               on size error move 999 to m2.
           move 1 to flag.
           go to plotLine.

       
       fileError.
           display "File I/O Error.".
           stop run.

       readFile.
           open input ifile.
           if istatus not = "00" go to fileError.
           read ifile.
           inspect irecord replacing all SPACES by "0".
           move a to n.
           move 1 to i.
           perform readFile-loop.
           close ifile.
       readFile-loop.
           read ifile.
           inspect irecord replacing all SPACES by "0".
           move a to x(i). move b to y(i).
           add 1 to i.
           if i not > n go to readFile-loop.

       plotInit.
           move "+" to plot(1).
           move 2 to i. perform plotInit-y.
           move 2 to i. perform plotInit-x.
       plotInit-y.
           move '|' to plot(i). add 1 to i.
           if i not > 23 go to plotInit-y.
       plotInit-x.
           string "-" delimited by size into plot(1) with pointer i.
           if i not > 79 go to plotInit-x.

       plotPrint.
           open output ofile.
           if ostatus not = "00" go to fileError.
           move 23 to i. perform plotPrint-loop.
           close ofile.
       plotPrint-loop.
           move plot(i) to orecord.
      *    display orecord.
           write orecord.
           subtract 1 from i.
           if i > 0 go to plotPrint-loop.

      * END OF FILE ---------------------------------------------------
