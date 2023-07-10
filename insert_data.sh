#! /bin/bash

if [[ $1 == "test" ]]
then
  PSQL="psql --username=postgres --dbname=worldcuptest -t --no-align -c"
else
  PSQL="psql --username=freecodecamp --dbname=worldcup -t --no-align -c"
fi

# Do not change code above this line. Use the PSQL variable above to query your database.

RESET=$($PSQL "TRUNCATE TABLE teams, games")

# Add all winners to the database
cat games.csv | while IFS="," read YEAR ROUND WINNER OPPONENT WINNER_GOALS OPPONENT_GOALS
do
  if [[ $WINNER != "winner" ]]
  then
    LISTED_WINNER=$($PSQL "SELECT name FROM teams WHERE name = '$WINNER'")
    if [[ -z $LISTED_WINNER ]]
    then
      WINNER_TO_ADD=$($PSQL "INSERT INTO teams(name) VALUES('$WINNER')")
      echo Added $WINNER to the database
    fi
  fi
done

# Add all opponents to the database
cat games.csv | while IFS="," read YEAR ROUND WINNER OPPONENT WINNER_GOALS OPPONENT_GOALS
do
  if [[ $WINNER != "winner" ]]
  then
    LISTED_OPPONENT=$($PSQL "SELECT name FROM teams WHERE name = '$OPPONENT'")
    if [[ -z $LISTED_OPPONENT ]]
    then
      OPPONENT_TO_ADD=$($PSQL "INSERT INTO teams(name) VALUES('$OPPONENT')")
      echo Added $OPPONENT to the database
    fi
  fi
done

# Add all rounds to the database
cat games.csv | while IFS="," read YEAR ROUND WINNER OPPONENT WINNER_GOALS OPPONENT_GOALS
do
  if [[ $WINNER != "winner" ]]
  then
    WINNER_ID=$($PSQL "SELECT team_id FROM teams WHERE name = '$WINNER'")
    OPPONENT_ID=$($PSQL "SELECT team_id FROM teams WHERE name = '$OPPONENT'")
    GAME=$($PSQL "INSERT INTO games(year, round, winner_id, opponent_id, winner_goals, opponent_goals) VALUES($YEAR, '$ROUND', $WINNER_ID, $OPPONENT_ID, $WINNER_GOALS, $OPPONENT_GOALS)")
    echo Added $WINNER-$OPPONENT round to the database
  fi
done
