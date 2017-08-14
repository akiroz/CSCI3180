c ----------------------------------------------------------------------
c | CSCI3180 Principles of Programming Languages                       |
c |                                                                    |
c | --- Declaration ---                                                |
c | I declare that the assignment here submitted is original except    |
c | for source material explicitly acknowledged. I also acknowledge    |
c | that I am aware of University policy and regulations on honesty    |
c | in academic work, and of the disciplinary guidelines and           |
c | procedures applicable to reaches of such policy and regulations,   |
c | as contained in the website                                        |
c | http://www.cuhk.edu.hk/policy/academichonesty/                     |
c |                                                                    |
c | Assignment 1                                                       |
c | Name:
c | Student ID:
c | Email Addr:
c ----------------------------------------------------------------------

c       label convention: xyz
c       x: block identifier
c       y: functionality
c          0 = loop entry
c          1 = flow control
c       z: label identifier

c       variables are named as follows unless stated otherwise:
c       i,j: iterator
c       n: number of points
c       x: x-axis coordinates of each point (array)
c       y: y-axis coordinates of each point (array)
c       plot: result plot (array of strings)


        program main
            integer i, n, x(99), y(99)
            character plot(0:22)*79
            data plot /23*'|'/
            call readFile(n, x, y)
            call plotInit(plot)
            i = 1
100         call plotLine(i, x, y, plot)
            i = i+1
            if(i .lt. n) go to 100
            call plotPrint(plot)
        end

c       readFile: read data from input file
        subroutine readFile(n, x, y)
            integer i, n, x(99), y(99)
            go to 211
c           file error routine:
210         write(*,'(A)') 'File I/O Error.'
            stop
c           read input.txt, unit=3:
211         open(3, err=210, file='input.txt', status='OLD')
            read(3,*) n
            i = 1
200         read(3,*) x(i), y(i)
            i = i+1
            if(i .le. n) go to 200
            close(3)
        end

c       plotInit: draw axis of the plot
        subroutine plotInit(plot)
            integer i
            character plot(0:22)*79
            i = 1
300         call plotSet(plot, i,0, '-')
            i = i+1
            if(i .lt. 79) go to 300
            call plotSet(plot, 0,0, '+')
        end

c       plotLine: draw rasterized line on plot connecting
c                 points i and i+1 using the DDA algorithm.
        subroutine plotLine(i, x, y, plot)
            integer i, x(99), y(99)
            character plot(0:22)*79
            integer j, xi, xj, yi, yj
            real m

            if(x(i)+y(i) .gt. x(i+1)+y(i+1)) go to 412
            xi = x(i)
            yi = y(i)
            xj = x(i+1)
            yj = y(i+1)
            go to 413
412         continue
            xi = x(i+1)
            yi = y(i+1)
            xj = x(i)
            yj = y(i)
413         continue

c           add small num to prevent divide-by-zero
            m = real(yj-yi) / (real(xj-xi) + 0.00001)

            j = 0
            if(abs(m) .gt. 1) go to 410
c           |m| <= 1:
400         call plotSet(plot, (xi+j), nint(yi+(j*m)), '*')
            j = j+1
            if(xi+j .le. xj) go to 400
            go to 411
c           |m| > 1:
410         continue
401         call plotSet(plot, nint(xi+(j/m)), (yi+j), '*')
            j = j+1
            if(yi+j .le. yj) go to 401
411         continue 

        end

c       plotSet: assign a character (ch) to a position on the plot
c       x: x-coordinate on plot to assign character
c       y: y-coordinate on plot to assign character
        subroutine plotSet(plot, x, y, ch)
            character plot(0:22)*79, ch
            integer x, y
            plot(y)(x+1:x+1) = ch
        end

c       plotPrint: write plot to attached console
        subroutine plotPrint(plot)
            character plot(0:22)*79
            integer i
            i = 22
500         write(*,'(A)') plot(i)
            i = i-1
            if(i .ge. 0) go to 500
        end

c END OF FILE ---------------------------------------------------------
