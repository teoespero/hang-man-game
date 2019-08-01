##################################################################################################
# hang-man.ps1
# Teo Espero
# Cloud and Systems Administration (BS)
# Western Governors University
#
# This game project is the PowerShell Hangman game. Although a little different
# from the traditional children’s Hangman game, this PowerShell game still captures the spirit
# of the original.
#
# The PowerShell Hangman game is a word guessing game in which the player is challenged to 
# guess a randomly selected secret word, a letter at a time. To win, the player must guess 
# each letter in the word in 12 guesses or fewer.
##################################################################################################


##################################################################################################
## This function determines if the player's guess is correct or incorrect


function Check-Answer {
    param ($reply) # Argument containing the player's guess

    ## Access script-level variable representing valid users guesses and
    ## add the current guess to it

    $script:guesses = $script:guesses + " " + $reply
    
    ## Loop through each letter in the secret word (e.g., each element in the
    ## array) and see if it matches the player's guess

    for ($i = 0; $i -le $secretWord.length - 1; $i++) {
        if ($secretWord[$i] -ne $reply) { 
        
            ## The guess does not match
        
            #Place an underscore character into $word[0] in place of the letter
            if ($words[0][$i] -eq "") {$words[0][$i] = "_"}
        }
        else { 
        
            ## The guess matches

            ## Place the letter being guessed into $word[0]
            $words[0][$i] = $reply
        }
    }
}

##################################################################################################

## declare our vars

$playGame = "False"                       # Controls gameplay and when to stop gameplay
$response = ""                            # Store the player's input when prompted to play a game

$randomNo = New-Object System.Random      # This variable stores a random object
$number = 0                               # Stores the game's randomly generated number
$secretWord = ""                          # Stores the secret word for the current round of play
$attempts = 0                             # Keeps track of the number of valid guesses made
$status = "True"                          # Controls the current round of play
$guesses = ""                             # A list of letters by the player during gameplay
$reply                                    # Stores player letter guesses
$tempstring                               # Stores a display string with hidden characters that is used 
                                          # to represent the secret word during gameplay

$validReply                               # Stores the player’s response when prompted to play a new game
$rejectList = '~!@#$%^&-_={}]|\:;",.?/<>' # String listing unacceptable input
$GuessesRemaining                         # Keeps track of the number of guesses the player has left

## Create an Associative array and load it with words

$words = @{}
$words[0] = @("", "", "", "", "", "", "", "", "", "", "", "", "", "", "")
$words[1] = @("C", "O", "M", "M", "A", "N", "D", "E", "R")
$words[2] = @("F", "L", "A", "G")
$words[3] = @("T", "O", "A", "S", "T", "E", "R")
$words[4] = @("M", "A", "R", "K", "E", "R")
$words[5] = @("P", "I", "C", "T", "U", "R", "E")
$words[6] = @("D", "E", "S", "K")
$words[7] = @("G", "L", "O", "B", "E")
$words[8] = @("S", "P", "E", "A", "K", "E", "R")
$words[9] = @("B", "A", "C", "K", "Y", "A", "R", "D")
$words[10] = @("P", "E", "N", "C", "I", "L")


## Prompt the player to guess a number
while ($playGame -ne "True") {

    Clear-Host 

    ## Display the game's opening screen

    Write-Host "`n`n`n`n"
    write-Host " Welcome to the ****************************"
    Write-Host "                                       *   *"
    Write-host " PowerShell Hangman Game!              O   *"
    Write-host "                                     __|__ *"
    Write-host "                                       |   *"
    Write-host "                                      / \  *"
    Write-host " Teo Espero                                *"
    Write-host " Cloud and Systems Administration (BS)     *"
    Write-host " Western Governors University              *"
    Write-host "                                           *"
    Write-host "                                           *"
    Write-host "                                     *******"
    
    ## Collect the player's guess

    $response = Read-Host "`n`n`n`n`n`n`n`n Would you like to play? (Y/N)"
    
    ## validate the player's input
    if ($response -eq "Y"){ $playGame = "True"}
    elseif ($response -eq "N") {
        Clear-Host
        Write-host " `n`n Please return and play again soon."
        Read-Host
        exit
    }
    else {
        Write-Host "`n`n Invalid input. Please press Enter try again."
        Read-Host
    }

}

##################################################################################################
## Main game loop

#Prompt the player to guess a number
while ($status -eq "True") {

    ## Reset variables at the beginning of each new round of play

    $tempString = ""
    $words[0] = @("", "", "", "", "", "", "", "", "", "", "", "", "", "", "")
    $attempts = 0
    $guesses = ""
    $reply = ""

    ## Generate a random number between 1 and 10

    $number = $randomNo.Next(1, 11)
    $secretWord = $words[$number] # Populate an array with the letters that
                                  #make up the game's secret word using the
                                  #random number to specify the array index 

    ## Create a loop to collect and analyze player input

    while ($reply -eq "") {
        Clear-Host 

        $reply = Read-Host "`n`n Enter a guess" # Collect the player answer
        if ($reply -eq "") { # If an empty string was submitted, repeat the
            continue #loop
        }

        ## It is time to validate player input
        if ($reply.Length -gt 1) { # Limit input to one character at a time

            Clear-Host 

            Write-Host "`n`n Error: You may enter only one letter at a time."
            Read-Host "`n`n`n`n`n`n`n`n`n`n`n Press Enter to continue."
            $reply = "" # Clear out the player's input
            continue # Repeat the loop
        }
        if (1234567890 -match $reply) { # Numeric input is not allowed

            Clear-Host #Clear the Windows command console screen

            Write-Host "`n`n Error: Numeric guesses are not allowed."
            Read-Host "`n`n`n`n`n`n`n`n`n`n`n Press Enter to continue."
            $reply = "" #Clear out the player's input
            continue #Repeat the loop
        }
        if ($rejectList -match $reply) {

            Clear-Host #Clear the Windows command console screen

            Write-Host "`n`n Error: Special characters are not permitted."
            Read-Host "`n`n`n`n`n`n`n`n`n`n`n Press Enter to continue."
            $reply = "" #Clear out the player's input
            continue #Repeat the loop
        }

        Clear-Host # Clear the Windows command console screen
        $attempts++ # Only increment for good guesses


        ## Now that player input has been validated, call on the Check-Answer
        ## function to process the input

        Check-Answer $reply
    
        $tempString = "" # Clear out this variable used to display the
                         # current state of the word being guessed
                         # Loop through $words[0] and create a temporary display string that
                         # shows the state of the word being guessed

        for ($i = 0; $i -le $words[0].length - 1; $i++) {
            $tempString = $tempString + " " + $words[0][$i]
        }
    
        ## Display the current state of the secret word based on the input
        ## collected from the player

        Write-Host "`n`n Results:`n"
        Write-Host " ------------------------------------------`n"
        Write-Host " $tempString`n"
        Write-Host " ------------------------------------------`n`n"
        Write-Host " Letters that have been guessed: $guesses`n"

        ## Calculate the number of guesses that the player has left

        $GuessesRemaining = (12 - $attempts)
        ## Display the number of guesses remaining in the current round of play
        Write-Host " Number of guesses remaining: $GuessesRemaining"

        ## Pause the game to allow the player to review the game's status

        Read-Host "`n`n`n`n`n`n`n`n`n Press Enter to continue"

        ## The secret word has been guessed if there are no more underscore
        ## characters left

        if ($tempString -notmatch "_") {
            Write-Host "`n Game over. You have guessed the secret word! in $attempts guesses.`n`n"
            Write-Host " The secret word was $secretWord `n`n"
            Write-Host "`n`n`n`n`n`n`n`n" `
            "`n`n`n`n`n`n`n"

            Read-Host # Pause gameplay

            $reply = "Done" # Signal the end of the current round of play
            continue        # Repeat the loop
        }
   
        ## The player is only allowed 12 guesses, after which the game ends
        if ($attempts -eq 12) {
            Clear-Host

            Write-Host "`n Game over. You have exceeded the maximum allowed number of guesses.`n`n"
            Write-Host " The secret word was $secretWord `n`n"
            Write-Host " The best you could do was $tempString`n`n`n`n`n`n`n`n`n`n`n`n`n`n`n"

            Read-Host # Pause the game
        
            $reply = "Done" # signal the end of the current round of play
            continue        # Repeat the loop
        }
        $reply = "" # Clear out the player's input

    }
    
    $response = "" # Reset value to allow the loop to continue iterating

    ## It is time to prompt the player to play another round

    $validReply = "False" # Set variable to ready its use in the while loop

    ## Loop until valid input is received

    while ($validReply -ne "True") {
        Clear-Host #Clear the Windows command console screen

        ## Prompt the player to play a new game
        $response = Read-Host "`n`n Play again? (Y/N)"

        ## Validate the player's input 
        
        ## Keep playing
        if ($response -eq "Y"){
            $validReply = "True"
            $status = "True"
        }

        ## Time to quit
        elseif ($response -eq "N") { 
        
            Clear-Host # Clear the Windows command console screen

            Write-host " `n`n Please return and play again soon."
            Read-Host # Pause gameplay

            $validReply = "True"
            $status = "False"
        }
        else { 
            ## Invalid input received
            Clear-Host #Clear the Windows command console screen

            Write-Host "`n`n Invalid input. Please press Enter to try again."
            #$validReply = "False"

            Read-Host #Pause gameplay
        }
    }
    
}


Clear-Host

##################################################################################################
## EOF 