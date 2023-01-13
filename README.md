# API Example Foodsi

## API zahostowane na Heroku
https://api-example-foodsi.herokuapp.com/

(Uwagi i komentarze od twórcy na dole.)

---
---
## Wymagania

- Ruby version: 2.7.2
- Postgresql > 9.0

---
---
## Konfiguracja

- Zainstaluj wymagane gemy:

```
$ bundle install
```

- Ustaw zmienne środowiskowe `DB_DEV_USERNAME` i `DB_DEV_PASSWORD` w pliku `.env`, by wykorzystać swoje credentiale z Postgresa.

- Postaw bazę danych:

```
$ rake db:setup
```

- Wygeneruj klucze i sól do encryptowania niektórych kolumn bazy danych i ustaw jako zmienne środowiskowe `ACTIVE_RECORD_ENCRYPTION_PRIMARY_KEY`, `ACTIVE_RECORD_ENCRYPTION_DETERMINISTIC_KEY` i `ACTIVE_RECORD_ENCRYPTION_KEY_DERIVATION_SALT` w pliku `.env`:

```
$ rails db:encryption:init
```

- Wystartuj serwer:
```
$ rails s
```

---
---
## Zmienne środowiskowe

* **DB_DEV_USERNAME** - Username PostgreSQL dla deweloperskiej i testowej bazy danych.
* **DB_DEV_PASSWORD** - Hasło PostgreSQL dla deweloperskiej i testowej bazy danych.
* **DB_PROD_USERNAME** - Username PostgreSQL dla produkcyjnej bazy danych.
* **DB_PROD_PASSWORD** - Hasło PostgreSQL dla produkcyjnej bazy danych.
* **SAFE_REDIRECT_DOMAIN** - Poprawny działajacy URL, na który chcemy przekierowywać uszkodzone skrócone linki, bądź nierozpoznane requesty z poziomu przeglądarki np. `https://www.youtube.com/watch?v=h_QNYTrHZ2c`
* **DOMAIN** - Domena naszej aplikacji. Lokalnie `http://localhost:3000`. **Ważne:** domena nie powinna kończyć się ukośnikiem.
* **ACTIVE_RECORD_ENCRYPTION_PRIMARY_KEY** - klucz do szyfrowania niedeterministycznego.
* **ACTIVE_RECORD_ENCRYPTION_DETERMINISTIC_KEY** - klucz do szyfrowania deterministycznego.
* **ACTIVE_RECORD_ENCRYPTION_KEY_DERIVATION_SALT** - sól do szyfrowania.

Aby ustawić zmienne dla środoiwska deweloperskiego, powinienieś utworzyć plik `.env` w głównym katalogu projektu. W tym miejscu powinien obejmować go filtr z `.gitignore`. Zmienne dodawaj w poniższy sposób:

```
ENV_VARIABLE_NAME=value
```

---
---
## Obsługa API

### **POST	/api/v1/users**
Tworzy nowego użytkownika i zwraca jego api-key.

---
### **PATCH	/api/v1/users/refresh_encrypted_key**
Generuje nowy api-key dla użytkownika.
#### **Przykład response:**
``` json
{
  "user_api_key": "e202d281-bbdd-4bb0-bbd1-7cc209629fe0",
  "message": "This is your key. Save it."
}
```

---
### **GET	/api/v1/links**
Zwraca dane o wszystkich linkach przynależących do użytkownika.
#### **Autentykacja:**
Bearer Token: *osobisty api-key użytkownika*
#### **Przykład response:**
``` json
"links": [
  {
      "id": 2,
      "long_link": "https://www.youtube.com/watch?v=h_QNYTrHZ2c",
      "shortened_link": "http://localhost:3000/?l=Ck1YCliGxeC15ON8",
      "click_count": 0,
      "created_at": "2023-01-13T22:16:30.780Z",
      "updated_at": "2023-01-13T22:16:33.039Z"
  },
  {
      "id": 3,
      "long_link": "https://www.youtube.com/watch?v=h_QNYTrHZ2c",
      "shortened_link": "http://localhost:3000/?l=Bjc63liGxe723Jk8",
      "click_count": 1,
      "created_at": "2023-01-13T22:16:30.780Z",
      "updated_at": "2023-01-13T22:16:33.039Z"
  }
]
```

---
### **POST	/api/v1/links**
Tworzy nowy przynależny do użytkownika link.
#### **Autentykacja:**
Bearer Token: *osobisty api-key użytkownika*
#### **Przykład body:**
``` json
{
  "long_link": "https://www.youtube.com/watch?v=h_QNYTrHZ2c" // link do skrócenia
}
```
#### **Przykład response:**
``` json
{
  "id": 2,
  "shortened_link": "http://localhost:3000/?l=Ck1YCliGxeC15ON8"
}
```

---
### **GET	/api/v1/links**
Zwraca dane o pojedynczym linku przynależącym do użytkownika.
#### **Autentykacja:**
Bearer Token: *osobisty api-key użytkownika*
#### **Przykład body:**
``` json
{
  "id": 1 // id linku
}
```
#### **Przykład response:**
``` json
{
  "links": [
    {
        "id": 2,
        "long_link": "https://www.youtube.com/watch?v=h_QNYTrHZ2c",
        "shortened_link": "https://api-example-foodsi.herokuapp.com/?l=Ck1YCliGxeC15ON8",
        "click_count": 1,
        "created_at": "2023-01-13T22:16:30.780Z",
        "updated_at": "2023-01-13T22:16:33.039Z"
    }
  ]
}
```

---
### **DELETE	/api/v1/links**
Usuwa z bazy pojedynczy link przynależący do użytkownika.
#### **Autentykacja:**
Bearer Token: *osobisty api-key użytkownika*
#### **Przykład body:**
``` json
{
  "id": 1 // id linku
}
```
#### **Przykład response:**
``` json
{
  "message": "Link successfully deleted"
}
```

---
---
## Uwagi twórcy
### **Autentykacja**
Zdecydowałam się na prostą autentykację poprzez przypisanie użytkownikowi unikalnego zaszyfrowanego w bazie UUID jako api-key. Przy każdym requeście (za wyjątkiem utworzenia użytkownika) aplikacja wymaga podania go jako bearer tokenu. Generowanie api-key obywa się przy requeście tworzącym nowego użytkownika.

---
### **Skracanie linku**
Skrócony link jest tworzony w formacie domeny naszej strony z parametrem `l` zawierającym alfanumeryczny ciąg 16 znaków. Po przekierowaniu pod tego typu adres, metoda `aplication#show_link` odszukuje oryginalny nieskrócony link w bazie, i jesli jej się to uda, przekierowuje pod niego.

---
### **Walidacja**
W przypadku wartości, które są przypisywane automatycznie przy tworzeniu użytkownika oraz linku zastosowałam callback `before_validation`. Dzięki temu api-key z UUID oraz skrócony link są przypisywane na tyle wcześnie, że jest możliwość walidowania ich wartości przez `validates_presence_of`. Dzięki temu mamy pewność, że nikt niepostrzeżenie nie usunie generowanie UUID. Nie było to możliwe przy użyciu `before_create`, ponieważ wywołuje się ona już po walidacjach.

---
### **Błędnie podana strona**
Przy podawaniu `long_link` przez użytkownika zastosowałam walidacje za pomocą regexu. W przypadku kiedy użytkownik poda błędny (niedziałający) link do strony przy tworzeniu, zależnie od wyniku walidacji regexem może zostać albo przekierowny pod ten sam niedziałajacy link, albo tam, gdzie przekierowujemy złe linki skrócone. W przypadku gdy użytkownik poda zły link skrócony (na przykład nie poda go w całości), strona przekieruje go do wybranego przez nas miejsca, które definiujemy lokalnie w pliku `.env`, na produkcji w zmiennych aplikacji.

---
### **Testowanie**
Aplikacja pokryta jest testami modeli i testami controllerów. Testy pisałam korzystając z `rspec`. Jedyna funkcjonalność, której testy nie obejmują to licznik kliknięć w skrócony link - w tym przypadku z jakiegoś powodu nie potrafiłam poradzić sobie z zaimplementowanie testu. Jednakże funkcjonalność działa i przy każdym kliknięciu w skrócony link liczba wzrasta. Oprócz testów modeli i controllerów jest również zaimplementowany rubocop w celu zachowania poprawności kodu. I rubocop i rspec uruchamiane są w workflole chroniącym główną branch przed złymi pull requestami.

---
### **Pull requesty i zaplanowanie zadań**
Zgodnie z prośbą, zasymulowana została praca małego zespołu. PRy są niewielkie, dotyczące poszczególnych funkcjonalności.
Uważam jednak, że mogłoby to wyglądać nieco lepiej, to znaczy:
- mogłam wgrać formatkę do pull requestu na samym początku
- przy stymulowaniu pracy zespołu przydałyby się również komentarze jak przetestować dane rozwiązanie oraz rozpisane Issues.

Przyznam szczerze, że pomyślałam o tym już w trakcie robienia zadania, formatkę zaimplementowałam bezzwłocznie. Komentarzy odnośnie testowania nie dodawałam, ze względu na zachowanie spójności oraz także dlatego, że tworzyłam jednak to zadanie sama, w związku z czym dokładnie wiedziałam jak przetestować PR.

W trakcie tworzenia API zorientowałam się również, że mogłam rozpisać Issues na GitHubie. Nie zrobiłam tego, ponieważ przeważnie w pracy do planowania tasków używałam `Jiry` lub `ClickUpa`. 