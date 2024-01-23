# NIE EDYTOWAĆ *****************************************************************
dsn_database = "wbauer_adb_2023"   # Specify the name of  Database
dsn_hostname = "pgsql-196447.vipserv.org"  # Specify host name 
dsn_port = "5432"                # Specify your port number. 
dsn_uid = "wbauer_adb"         # Specify your username. 
dsn_pwd = "adb2020"        # Specify your password.

library(DBI)
library(RPostgres)
library(testthat)

con <- dbConnect(Postgres(), dbname = dsn_database, host=dsn_hostname, port=dsn_port, user=dsn_uid, password=dsn_pwd) 
# ******************************************************************************

film_in_category <- function(category_id)
{
  # Funkcja zwracająca wynik zapytania do bazy o tytuł filmu, 
  # język, oraz kategorię dla zadanego id kategorii.
  # Przykład wynikowej tabeli:
  # |   |title          |language    |category|
  # |0	|Amadeus Holy	|English	|Action|
  # 
  # Tabela wynikowa ma być posortowana po tylule filmu i języku.
  # 
  # Jeżeli warunki wejściowe nie są spełnione to funkcja powinna zwracać wartość NULL
  # 
  # Parameters:
  # category_id (integer): wartość id kategorii dla którego wykonujemy zapytanie
  # 
  # Returns:
  # DataFrame: DataFrame zawierający wyniki zapytania
  # 
  if (is.integer(category_id)) {
    category_of_film <- dbGetQuery(con, sprintf(
     "SELECT f.title, l.name as language, cat.name as category
      FROM category AS cat 
      INNER JOIN film_category fcat ON cat.category_id = fcat.category_id 
      INNER JOIN film f ON fcat.film_id = f.film_id
      INNER JOIN language l ON f.language_id = l.language_id
      WHERE cat.category_id = %i
      ORDER BY f.title, l.name;", category_id))
    return(category_of_film)
  } else {
    return(NULL)
  }
}


number_films_in_category <- function(category_id){
  #   Funkcja zwracająca wynik zapytania do bazy o ilość filmów w zadanej kategori przez id kategorii.
  #     Przykład wynikowej tabeli:
  #     |   |category   |count|
  #     |0	|Action 	|64	  | 
  #     
  #     Jeżeli warunki wejściowe nie są spełnione to funkcja powinna zwracać wartość NULL.
  #         
  #     Parameters:
  #     category_id (integer): wartość id kategorii dla którego wykonujemy zapytanie
  #     
  #     Returns:
  #     DataFrame: DataFrame zawierający wyniki zapytania
  if (is.integer(category_id)) {
    category_of_film <- dbGetQuery(con, sprintf(
     "SELECT cat.name as category, COUNT(fcat.film_id) as count
      FROM category AS cat 
      INNER JOIN film_category fcat ON cat.category_id = fcat.category_id
      WHERE cat.category_id = %i
      GROUP BY cat.name", category_id))
    return(category_of_film)
  } else {
    return(NULL)
  }
}


number_film_by_length <- function(min_length, max_length){
  #   Funkcja zwracająca wynik zapytania do bazy o ilość filmów dla poszczególnych długości pomiędzy wartościami min_length a max_length.
  #     Przykład wynikowej tabeli:
  #     |   |length     |count|
  #     |0	|46 	    |64	  | 
  #     
  #     Jeżeli warunki wejściowe nie są spełnione to funkcja powinna zwracać wartość NULL.
  #         
  #     Parameters:
  #     min_length (int,double): wartość minimalnej długości filmu
  #     max_length (int,double): wartość maksymalnej długości filmu
  #     
  #     Returns:
  #     pd.DataFrame: DataFrame zawierający wyniki zapytania
  if ((is.integer(min_length) || is.double(min_length)) && 
      (is.integer(max_length) || is.double(max_length)) &&
      (min_length > 0) &&
      (min_length < max_length)) {
    length_of_film <- dbGetQuery(con, sprintf(
     "SELECT f.length AS length, COUNT(f.film_id) AS count
      FROM film AS f
      WHERE f.length BETWEEN %f AND %f
      GROUP BY f.length", min_length, max_length))
    return(length_of_film)
  } else {
    return(NULL)
  }
}


client_from_city<- function(city){
  #   Funkcja zwracająca wynik zapytania do bazy o listę klientów z zadanego miasta przez wartość city.
  #     Przykład wynikowej tabeli:
  #     |   |city	    |first_name	|last_name
  #     |0	|Athenai	|Linda	    |Williams
  #     
  #     Tabela wynikowa ma być posortowana po nazwisku i imieniu klienta.
  #     
  #     Jeżeli warunki wejściowe nie są spełnione to funkcja powinna zwracać wartość NULL.
  #         
  #     Parameters:
  #     city (character): nazwa miasta dla którego mamy sporządzić listę klientów
  #     
  #     Returns:
  #     DataFrame: DataFrame zawierający wyniki zapytania
  if (is.character(city)) {
    city_customers_list <- dbGetQuery(con, sprintf(
     "SELECT ct.city, c.first_name, c.last_name
      FROM customer AS c
      INNER JOIN address a ON c.address_id = a.address_id
      INNER JOIN city ct ON a.city_id = ct.city_id 
      WHERE city = '%s'
      ORDER BY c.first_name, c.last_name", city))
    return(city_customers_list)
  } else {
    return(NULL)
  }
}

avg_amount_by_length<-function(length){
  #   Funkcja zwracająca wynik zapytania do bazy o średnią wartość wypożyczenia filmów dla zadanej długości length.
  #     Przykład wynikowej tabeli:
  #     |   |length |avg
  #     |0	|48	    |4.295389
  #     
  #     
  #     Jeżeli warunki wejściowe nie są spełnione to funkcja powinna zwracać wartość NULL.
  #         
  #     Parameters:
  #     length (integer,double): długość filmu dla którego mamy pożyczyć średnią wartość wypożyczonych filmów
  #     
  #     Returns:
  #     DataFrame: DataFrame zawierający wyniki zapytania
  if (is.integer(length) || is.double(length)) {
    avg_price_length <- dbGetQuery(con, sprintf(
      "SELECT f.length, AVG(p.amount) as avg
       FROM payment as p
       INNER JOIN rental r ON p.rental_id = r.rental_id
       INNER JOIN inventory i ON r.inventory_id = i.inventory_id
       INNER JOIN film f ON i.film_id = f.film_id
       WHERE f.length = %f
       GROUP BY f.length", length))
    return(avg_price_length)
  } else {
    return(NULL)
  }
}


client_by_sum_length <- function(sum_min){
  #   Funkcja zwracająca wynik zapytania do bazy o sumaryczny czas wypożyczonych filmów przez klientów powyżej zadanej wartości .
  #     Przykład wynikowej tabeli:
  #     |   |first_name |last_name  |sum
  #     |0  |Brian	    |Wyman  	|1265
  #     
  #     Tabela wynikowa powinna być posortowane według sumy, nazwiska i imienia klienta.
  #     Jeżeli warunki wejściowe nie są spełnione to funkcja powinna zwracać wartość NULL.
  #
  #     Parameters:
  #     sum_min (integer,double): minimalna wartość sumy długości wypożyczonych filmów którą musi spełniać klient
  #     
  #     Returns:
  #     DataFrame: DataFrame zawierający wyniki zapytania
  if (is.integer(sum_min) || is.double(sum_min)) {
    sum_film_length <- dbGetQuery(con, sprintf(
      "SELECT c.first_name, c.last_name, SUM(f.length) AS sum
       FROM customer as c
       INNER JOIN rental r ON c.customer_id = r.customer_id
       INNER JOIN inventory i ON r.inventory_id = i.inventory_id
       INNER JOIN film f ON i.film_id = f.film_id
       GROUP BY c.first_name, c.last_name
       HAVING SUM(f.length) >= %f
       ORDER BY sum, c.last_name, c.first_name", sum_min))
    return(sum_film_length)
  } else {
    return(NULL)
  }
}


category_statistic_length<-function(name){
  #   Funkcja zwracająca wynik zapytania do bazy o statystykę długości filmów w kategorii o zadanej nazwie.
  #     Przykład wynikowej tabeli:
  #     |   |category   |avg    |sum    |min    |max
  #     |0	|Action 	|111.60 |7143   |47 	|185
  #     
  #     Jeżeli warunki wejściowe nie są spełnione to funkcja powinna zwracać wartość NULL.
  #         
  #     Parameters:
  #     name (character): Nazwa kategorii dla której ma zostać wypisana statystyka
  #     
  #     Returns:
  #     DataFrame: DataFrame zawierający wyniki zapytania
  if (is.character(name)) {
    length_stats <- dbGetQuery(con, sprintf(
      "SELECT cat.name as category, AVG(f.length) as avg, SUM(f.length) as sum, MIN(f.length) as min, MAX(f.length) as max
       FROM category AS cat
       INNER JOIN film_category fcat ON cat.category_id = fcat.category_id
       INNER JOIN film f ON fcat.film_id = f.film_id
       WHERE cat.name = '%s'
       GROUP BY cat.name", name))
    return(length_stats)
  } else {
    return(NULL)
  }
}

# NIE EDYTOWAĆ *****************************************************************
test_dir('tests/testthat')
# ******************************************************************************