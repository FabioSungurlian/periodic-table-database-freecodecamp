ERROR_MESSAGE="I could not find that element in the database."

if [[ -z $1 ]]
then
  echo "Please provide an element as an argument."
  exit
fi

PSQL="psql --username=freecodecamp --dbname=periodic_table --tuples-only --command"

if [[ $1 =~ ^[0-9]+$ ]] 
then
  CONDITION="atomic_number = $1"
elif [[ $1 =~ ^[a-zA-Z]{1,2}$ ]] 
then
  CONDITION="symbol = '$1'" 
elif [[ $1 =~ ^[a-zA-Z]+$ ]]
then
  CONDITION="name = '$1'"
else
  echo $ERROR_MESSAGE
  exit
fi

ELEMENT_INFO=$($PSQL "
  SELECT atomic_number, symbol, name, type, melting_point_celsius, boiling_point_celsius, atomic_mass 
  FROM elements
  INNER JOIN properties USING(atomic_number)
  INNER JOIN types USING(type_id)
  WHERE $CONDITION;
")

if [[ -z $ELEMENT_INFO ]]
then
  echo $ERROR_MESSAGE
  exit
fi

IFS=" |"

read ATOMIC_NUMBER SYMBOL NAME TYPE MELTING_POINT BOILING_POINT ATOMIC_MASS <<< $ELEMENT_INFO

echo -e "The element with atomic number $ATOMIC_NUMBER is $NAME ($SYMBOL). It's a $TYPE, with a mass of $ATOMIC_MASS amu. $NAME has a melting point of $MELTING_POINT celsius and a boiling point of $BOILING_POINT celsius." 

  
