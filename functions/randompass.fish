function randompass
    set length $argv[1]
    
    if test "$length" -eq "$length" 2>/dev/null
        if test $length -gt 0
            ~/.scripts/random_password.sh $length
        else
            echo "Error: Length must be a positive integer."
        end
    else
        echo "Error: Length must be a positive integer."
    end
end
