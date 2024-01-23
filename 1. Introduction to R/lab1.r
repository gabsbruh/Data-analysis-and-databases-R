library(ggplot2)
# Cwiczenie 1.
wielokrotnosc5 <- c(5, 10, 15, 20, 25)
# wieksze od 15
wielokrotnosc5[wielokrotnosc5 > 15]
#srednia z wektora
mean(wielokrotnosc5)
# suma pwszych trzech
sum(wielokrotnosc5[1:3])

# Cwiczenie 2.
lista_wynikow <- c(75, 48, 90, 60, 30)
for (wynik in lista_wynikow) {
  if (wynik >= 60) {
    cat("Zaliczony\n")
  } else {
    cat("Niezaliczony\n")
  }
}

# Cwiczenie 3.
imie  <- c("Jan", "Ola", "Ela")
wiek  <- c(23, 30, 28)
punkty <- c(85, 92, 78)
ocena <- c(1.0, 1.0, 1.0)
for (num in 1:3) {
  if (punkty[num] >= 90) {
    ocena[num] <- 5.0
  } else if (punkty[num] >= 80){
    ocena[num] <- 4.5
  } else if (punkty[num] >= 70){
    ocena[num] <- 4.0
  } else if (punkty[num] >= 60){
    ocena[num] <- 3.5
  } else if (punkty[num] >= 50){
    ocena[num] <- 3.0
  } else {
    ocena[num] <- 2.0
  }
}
df <- data.frame(Imię = imie, Wiek = wiek, Punkty = punkty, Ocena = ocena)
df

# Cwiczenie 4.
dane <- data.frame(
  Przedmiot = c("Analiza i Bazy Danych", "Metody numeryczne",
                "Eksploracja danych"),
  Średnia = c(71, 67, 89)
)

wykres_slupkowy <- ggplot(dane, aes(x = Przedmiot, y = Średnia)) +
  geom_bar(stat = "identity", fill = "#19cf5f") +
  labs(title = "Średnik wynik zaliczenia przedmiotów w roku 2022",
       x = "Przedmiot",
       y = "Średnia") +
  theme(plot.title = element_text(size = 22))

print(wykres_slupkowy)

## Zadanie Domowe

# Test 1 Wyniki testów Matematyki dla Grupy A i Grupy B
wyniki_grupa_a_1 <- c(60, 65, 75, 68, 62)
wyniki_grupa_b_1 <- c(78, 80, 85, 92, 88)

# Test 2 Wyniki testów Matematyki dla Grupy A i Grupy B
wyniki_grupa_a_2 <- c(80, 65, 75, 68, 72)
wyniki_grupa_b_2 <- c(78, 80, 85, 92, 88)

srednia_a1 <- c(mean(wyniki_grupa_a_1))
srednia_a2 <- c(mean(wyniki_grupa_a_2))
srednia_b1 <- c(mean(wyniki_grupa_b_1))
srednia_b2 <- c(mean(wyniki_grupa_b_2))
srednie <- c(srednia_a1, srednia_a2, srednia_b1, srednia_b2)
srednie_do_wykresu <- c()
for (sr in srednie) {
  if (sr >= 70) {
    srednie_do_wykresu <- append(srednie_do_wykresu, sr)
  }
}

dane__ <- data.frame(
  Nrtestu_Grupa = c("2_A", "1_B",
                    "2_B"),
  Średnia = srednie_do_wykresu
)

wykres_testow <- ggplot(dane__, aes(x = Nrtestu_Grupa, y = Średnia)) +
  geom_bar(stat = "identity", fill = "#1925cf") +
  labs(title = "Średnie wyniki testów dla danej grupy",
       x = "Nr testu _ Grupa",
       y = "Średnia") +
  theme(plot.title = element_text(size = 22, face = "bold"),
        axis.text = element_text(size = 16),
        axis.title = element_text(size = 18, face = "bold"))

print(wykres_testow)