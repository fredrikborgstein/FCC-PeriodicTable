#!/bin/bash

# Script to output information about elements

# The connection to the DB
PSQL="psql --username=freecodecamp --dbname=periodic_table -t --no-align -c"


# If there is no argument provided
if [[ -z $1 ]]
then
  echo Please provide an element as an argument.
else
  # If there is an argument provided

  GET_ATOMIC_NUMBER=$($PSQL "SELECT atomic_number FROM elements WHERE '$1' = ANY(ARRAY[atomic_number::text, name, symbol]) or '$1' = ANY(ARRAY[name, symbol]); ")
  # If the argument does not exist in the db
  if [[ -z $GET_ATOMIC_NUMBER ]]
  then
    echo I could not find that element in the database.
  else

    # If the argument exists in the db
    GET_ELEMENT_NAME=$($PSQL "SELECT name FROM elements WHERE atomic_number = '$GET_ATOMIC_NUMBER';")
    GET_ELEMENT_SYMBOL=$($PSQL "SELECT symbol FROM elements WHERE atomic_number = '$GET_ATOMIC_NUMBER';")
    GET_ELEMENT_TYPE_ID=$($PSQL "SELECT type_id FROM properties WHERE atomic_number = '$GET_ATOMIC_NUMBER';")
    GET_ELEMENT_TYPE=$($PSQL "SELECT type FROM types WHERE type_id = '$GET_ELEMENT_TYPE_ID';")
    GET_ELEMENT_MASS=$($PSQL "SELECT atomic_mass FROM properties WHERE atomic_number = '$GET_ATOMIC_NUMBER';")
    GET_ELEMENT_MELTING=$($PSQL "SELECT melting_point_celsius FROM properties WHERE atomic_number = '$GET_ATOMIC_NUMBER';")
    GET_ELEMENT_BOILING=$($PSQL "SELECT boiling_point_celsius FROM properties WHERE atomic_number = '$GET_ATOMIC_NUMBER';")

  echo "The element with atomic number $GET_ATOMIC_NUMBER is $GET_ELEMENT_NAME ($GET_ELEMENT_SYMBOL). It's a $GET_ELEMENT_TYPE, with a mass of $GET_ELEMENT_MASS amu. $GET_ELEMENT_NAME has a melting point of $GET_ELEMENT_MELTING celsius and a boiling point of $GET_ELEMENT_BOILING celsius."

  fi
fi



