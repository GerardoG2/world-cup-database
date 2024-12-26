#! /bin/bash

if [[ $1 == "test" ]]
then
  PSQL="psql --username=postgres --dbname=worldcuptest -t --no-align -c"
else
  PSQL="psql --username=freecodecamp --dbname=worldcup -t --no-align -c"
fi

# Do not change code above this line. Use the PSQL variable above to query your database.

# Script to isnert data from games.csv file into world cup database
cat games.csv | while IFS="," read YEAR ROUND WINNER OPPONENT WINNER_GOALS OPPONENT_GOALS
do
  if [[ $YEAR != 'year' ]]
  then
    # get winner_id
    WINNER_ID=$($PSQL "SELECT team_id FROM teams WHERE name = '$WINNER'")

    if [[ -z $WINNER_ID ]]
    then
      INSERT_WINNER_RESULT=$($PSQL "INSERT INTO teams(name) VALUES('$WINNER')")

      if [[ $INSERT_WINNER_RESULT == 'INSERT 0 1' ]]
      then 
        echo -e "\nInserted into teams, $WINNER"
      fi

      WINNER_ID=$($PSQL "SELECT team_id FROM teams WHERE name = '$WINNER'")
      
    fi

    # get opponent_id
    OPPONENT_ID=$($PSQL "SELECT team_id FROM teams WHERE name = '$OPPONENT'")

    if [[ -z $OPPONENT_ID ]]
    then
      INSERT_OPPONENT_RESULT=$($PSQL "INSERT INTO teams(name) VALUES('$OPPONENT')")

      if [[ $INSERT_OPPONENT_RESULT == 'INSERT 0 1' ]]
      then 
        echo -e "\nInserted into teams, $OPPONENT"
      fi

      OPPONENT_ID=$($PSQL "SELECT team_id FROM teams WHERE name = '$OPPONENT'")
      
    fi

    INSERT_ROUND_RESULT=$($PSQL "INSERT INTO games (year, round, winner_id, opponent_id, winner_goals, opponent_goals) VALUES ($YEAR, '$ROUND', $WINNER_ID, $OPPONENT_ID, $WINNER_GOALS, $OPPONENT_GOALS) ")
    if [[ $INSERT_ROUND_RESULT == 'INSERT 0 1' ]]
    then
      # insert row with year, round, winner, winner_goals, opponent goals into games table
      echo -e "\nInserted into games, $YEAR, $ROUND, $WINNER_ID, $OPPONENT_ID, $WINNER_GOALS, $OPPONENT_GOALS"
    fi  
  
  fi



done