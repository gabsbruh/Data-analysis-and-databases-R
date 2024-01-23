# NIE EDYTOWAĆ *****************************************************************
dsn_database <- "wbauer_adb_2023" # Specify the name of  Database
dsn_hostname <- "pgsql-196447.vipserv.org" # Specify host name
dsn_port <- "5432" # Specify your port number.
dsn_uid <- "wbauer_adb" # Specify your username.
dsn_pwd <- "adb2020" # Specify your password.

library(DBI)
library(RPostgres)
library(testthat)

con <- dbConnect(Postgres(), dbname = dsn_database, host = dsn_hostname, port = dsn_port, user = dsn_uid, password = dsn_pwd)
# ******************************************************************************

film_in_category <- function(category) {
  # Funkcja zwracająca wynik zapytania do bazy o tytuł filmu, język, oraz kategorię dla zadanego:
  #     - id: jeżeli categry jest integer
  #     - name: jeżeli category jest character, dokładnie taki jak podana wartość
  # Przykład wynikowej tabeli:
  # |   |title          |language    |category|
  # |0	|Amadeus Holy	|English	|Action|
  #
  # Tabela wynikowa ma być posortowana po tylule filmu i języku.
  #
  # Jeżeli warunki wejściowe nie są spełnione to funkcja powinna zwracać wartość NULL.
  #
  # Parameters:
  # category (integer,character): wartość kategorii po id (jeżeli typ integer) lub nazwie (jeżeli typ character)  dla którego wykonujemy zapytanie
  #
  # Returns:
  # DataFrame: DataFrame zawierający wyniki zapytania

  if (is.integer(category)) {
    category_of_film <- dbGetQuery(con, sprintf(
      "SELECT f.title AS title, l.name AS languge, cat.name AS category
      FROM category AS cat
      INNER JOIN film_category fcat ON cat.category_id = fcat.category_id
      INNER JOIN film f ON fcat.film_id = f.film_id
      INNER JOIN language l ON f.language_id = l.language_id
      WHERE cat.category_id = %i
      ORDER BY f.title, l.name;", category
    ))
    return(category_of_film)
  } else if (is.character(category)) {
    category_of_film <- dbGetQuery(con, sprintf(
      "SELECT f.title AS title , l.name AS languge, cat.name AS category
      FROM category AS cat
      INNER JOIN film_category fcat ON cat.category_id = fcat.category_id
      INNER JOIN film f ON fcat.film_id = f.film_id
      INNER JOIN language l ON f.language_id = l.language_id
      WHERE cat.name = '%s'
      ORDER BY f.title, l.name;", category
    ))
    return(category_of_film)
  } else {
    return(NULL)
  }
}


film_in_category_case_insensitive <- function(category) {
  #  Funkcja zwracająca wynik zapytania do bazy o tytuł filmu, język, oraz kategorię dla zadanego:
  #     - id: jeżeli categry jest integer
  #     - name: jeżeli category jest character
  #  Przykład wynikowej tabeli:
  #     |   |title          |languge    |category|
  #     |0	|Amadeus Holy	|English	|Action|
  #
  #   Tabela wynikowa ma być posortowana po tylule filmu i języku.
  #
  #     Jeżeli warunki wejściowe nie są spełnione to funkcja powinna zwracać wartość NULL.

  #   Parameters:
  #   category (integer,str): wartość kategorii po id (jeżeli typ integer) lub nazwie (jeżeli typ character)  dla którego wykonujemy zapytanie
  #
  #   Returns:
  #   DataFrame: DataFrame zawierający wyniki zapytania
  if (is.integer(category)) {
    category_of_film <- dbGetQuery(con, sprintf(
      "SELECT f.title AS title, l.name AS languge, cat.name AS category
      FROM category AS cat
      INNER JOIN film_category fcat ON cat.category_id = fcat.category_id
      INNER JOIN film f ON fcat.film_id = f.film_id
      INNER JOIN language l ON f.language_id = l.language_id
      WHERE cat.category_id = %i
      ORDER BY f.title, l.name;", category
    ))
    return(category_of_film)
  } else if (is.character(category)) {
    category_of_film <- dbGetQuery(con, sprintf(
      "SELECT f.title AS title , l.name AS languge, cat.name AS category
      FROM category AS cat
      INNER JOIN film_category fcat ON cat.category_id = fcat.category_id
      INNER JOIN film f ON fcat.film_id = f.film_id
      INNER JOIN language l ON f.language_id = l.language_id
      WHERE cat.name ILIKE '%s'
      ORDER BY f.title, l.name;", category
    ))
    return(category_of_film)
  } else {
    return(NULL)
  }
}


film_cast <- function(title) {
  # Funkcja zwracająca wynik zapytania do bazy o obsadę filmu o dokładnie zadanym tytule.
  # Przykład wynikowej tabeli:
  #     |   |first_name |last_name  |
  #     |0	|Greg       |Chaplin    |
  #
  # Tabela wynikowa ma być posortowana po nazwisku i imieniu klienta.
  # Jeżeli warunki wejściowe nie są spełnione to funkcja powinna zwracać wartość NULL.
  #
  # Parameters:
  # title (character): wartość id kategorii dla którego wykonujemy zapytanie
  #
  # Returns:
  # DataFrame: DataFrame zawierający wyniki zapytania
  if (is.character(title)) {
    cast <- dbGetQuery(
      con,
      sprintf("SELECT a.first_name AS first_name, a.last_name AS last_name
       FROM actor AS a
       INNER JOIN film_actor fa ON a.actor_id = fa.actor_id
       INNER JOIN film f ON fa.film_id = f.film_id
       WHERE f.title = '%s'
       ORDER BY a.last_name ASC, a.first_name ASC", title)
    )
    return(cast)
  } else {
    return(NULL)
  }
}



film_title_case_insensitive <- function(words) {
  # Funkcja zwracająca wynik zapytania do bazy o tytuły filmów zawierających conajmniej jedno z podanych słów z listy words.
  # Przykład wynikowej tabeli:
  #     |   |title              |
  #     |0	|Crystal Breaking 	|
  #
  # Tabela wynikowa ma być posortowana po nazwisku i imieniu klienta.
  #
  # Jeżeli warunki wejściowe nie są spełnione to funkcja powinna zwracać wartość NULL.
  #
  # Parameters:
  # words(list[character]): wartość minimalnej długości filmu
  #
  # Returns:
  # DataFrame: DataFrame zawierający wyniki zapytania
  #
  if (all(sapply(words, is.character))) {
    wordsstring <- paste(words, collapse = "|")
    paste1 <- paste("SELECT title FROM film f WHERE f.title ~*")
    paste2 <- paste("'\\y(", wordsstring, ")\\y'", sep = "")
    paste3 <- paste("ORDER BY f.title")
    paste <- paste0(paste1, paste2, paste3)
    out <- dbGetQuery(con, paste)
    return(out)
  } else {
    return(NULL)
  }
}
# NIE EDYTOWAĆ *****************************************************************
test_dir("tests/testthat")
# ******************************************************************************
