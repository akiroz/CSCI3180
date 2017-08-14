# CSCI3180 Principles of Programming Languages
#
# --- Declaration ---
# I declare that the assignment here submitted is original except for source material explicitly
# acknowledged. I also acknowledge that I am aware of University policy and regulations on
# honesty in academic work, and of the disciplinary guidelines and procedures applicable to
# breaches of such policy and regulations, as contained in the website
# http://www.cuhk.edu.hk/policy/academichonesty/
#
# Assignment 2
# Name:
# Student ID:
# Email Addr:

# check if [coord] is a winning move on [board] for [sym]
def win?(coord, board, sym)
    # movement, return next coordinare based on operations
    mv = lambda {|o1,o2,c| [c[0].send(o1,1), c[1].send(o2,1)]}
    # count length in direction
    dfs = lambda {|nex, c, len=0|
        unless (0..14).cover?(c[0]); return len end
        unless (0..14).cover?(c[1]); return len end
        unless board[c[0]][c[1]] == sym; return len end
        dfs.(nex, nex.(c), len+1)
    }
    for mvf,mvb in [
        [mv.curry[:+,:*], mv.curry[:-,:*]], # vertical movement (|)
        [mv.curry[:*,:+], mv.curry[:*,:-]], # horizontal movement (-)
        [mv.curry[:+,:+], mv.curry[:-,:-]], # diagonal movement (\)
        [mv.curry[:+,:-], mv.curry[:-,:+]]  # diagonal movement (/)
    ]
        # sum lengths from both forward and backwards direction
        len = dfs.(mvf,coord) + dfs.(mvb,coord) - 1
        if len >= 5; return true end
    end; false
end

class Player
    def initialize(s,b) @symbol,@board = s,b end
    def nextMove; end
    def isValid(c)
        c.all?{|n| (0..14).cover?(n)} && @board[c[0]][c[1]] == '.'
    end
end

class Human < Player
    def nextMove
        loop do
            print "Player #{@symbol}, make a move (row col): "
            coord = gets.chomp.split.map{|n| n.to_i}
            if isValid(coord); return coord end
            puts 'Invalid input. Try again!'
        end
    end
end

class Computer < Player
    def nextMove
        for coord in Array(0..14).product(Array(0..14))
            unless isValid(coord); next end
            if win?(coord, @board, @symbol); return coord end
        end
        randomCoord
    end
    def randomCoord
        begin coord = Array.new(2){Random.new.rand(0..14)}
        end until isValid(coord); coord
    end
end

class Gomoku
    def initialize
        @pieces, @turn = 0, 'O'
        @board = Array.new(15){Array.new(15,'.')}
    end
    def startGame
        initPlayer('First'); initPlayer('Second'); printBoard
        loop do
            c = ((@turn == 'O')? @player1 : @player2).nextMove
            puts "Player #{@turn} places to row #{c[0]}, col #{c[1]}"
            @board[c[0]][c[1]] = @turn; printBoard

            @pieces += 1
            if @pieces == 15**2; puts "Draw game!"; break end
            if win?(c, @board, @turn)
                puts "Player #{@turn} wins!"; break end

            @turn = (@turn == 'O')? 'X' : 'O'
        end
    end
    def initPlayer(nth) 
        print "#{nth} player is (1) Computer or (2) Human? "
        sym = (nth == "First")? 'O' : 'X'
        ply = ((gets == "1\n")? Computer : Human).new(sym,@board)
        (sym == 'O')? @player1 = ply : @player2 = ply
        puts "Player #{sym} is #{ply.class.name}"
    end
    def printBoard
        cols = Array(0..14).map{|n| n.to_s.rjust(2,' ').split(//)}
        puts cols.inject('  '){|str,n| str+' '+n[0]}
        puts cols.inject('  '){|str,n| str+' '+n[1]}
        (0..14).each do |n|
            puts n.to_s.rjust(2,' ')+' '+@board[n].join(' ')
        end
    end
end

Gomoku.new.startGame
