# sf-b1112-pr-jenkins-terraform-ansible-docker-nginx-webapp
For Skill Factory study project (B11, PR)

<br>


### 01. Общее описание

```bash
Веб приложение на стеке HTML + CSS + JavaScript для вычисления контрольной md5 суммы файла
```

### 02. Порядок работы

```bash
1. скопировать содержимое каталога "src" в каталог вашего веб сервера, 
   например в "/var/www"

2. перейти на корневую страницу вашего сайта
   http://your_site.org

3. перетянуть файл в область выделенную пунктиром
   в результате чего в JavaScript консоли браузера и на странице в области "CALCULATED MD5 CHECKSUM"
   будет отображена вычисленная контрольная md5 сумма (хэш)
   *см. скриншоты ниже;

4. для проверки вычисленного md5 хэша можно воспользоваться онлайн инструментом "MD5 Hash Generator":
   https://www.md5hashgenerator.com/
   *скопировать код из файла в поле "Use this generator to create an MD5 hash of a string";
   *нажать кнопку "Generate"
   
5. кроме того, для ветки "main" репозитория настроен хостинг на "GitHub Pages",
   т.о работу веб-приложения можно проверить по URL:
   https://victornuzhdin.github.io/sf-b1112-pr-jenkins-terraform-ansible-docker-nginx-webapp/src/

6. для локального тестирования веб-приложения можно запустить его в Docker-контейнере, для этого нужно выполнить ряд команд:

   ..для сборки Docker образа на основе конфигурации Dockerfile:

     $ docker build . -t nve-nginx-alpine-317

   ..для запуска Docker контейнера из образа:

     $ docker run -d --rm --name webapp1 -p 8000:9000 -p 8001:9889 nve-nginx-alpine-317

   ..для вывода информации о запущенном контейнере:

     $ docker ps

           CONTAINER ID   IMAGE                  COMMAND                  CREATED          STATUS          PORTS                                                                                          NAMES
           256fa911fb00   nve-nginx-alpine-317   "/docker-entrypoint.…"   19 minutes ago   Up 19 minutes   80/tcp, 0.0.0.0:8000->9000/tcp, :::8000->9000/tcp, 0.0.0.0:8001->9889/tcp, :::8001->9889/tcp   webapp1

   ..для вывода информации о локально доступных образах:

     $ docker images

           REPOSITORY             TAG          IMAGE ID       CREATED          SIZE
           nve-nginx-alpine-317   latest       a33b10ff1ffb   20 minutes ago   41.4MB
           nginx                  alpine3.17   fe7edaf8a8dc   2 weeks ago      41.4MB

   ..для проверки результата работы через браузер (если контейнер запущен на Jenkins сервере):

     browser: http://jenkins.dotspace.ru:8001/         ## Web App :: Calculate MD5 from File (см. скриншоты ниже)
              http://jenkins.dotspace.ru:8000/health   ## healthy
     
   ..для проверки результата работы через браузер (если контейнер запущен локально):

     browser:  http://localhost:8001/                   ## Web App :: Calculate MD5 from File
               http://loaclhost:8000/health             ## healthy

   ..для остановки контейнера и удаления образа (для повторной дальнейшей сборки и запуска):

     $ docker container stop webapp1
     $ docker image rm nve-nginx-alpine-317
```

### 03. Важные замечания

```bash
#2
Выявлен нюанс работы Python приложения отправки уведомления в Telegram канал при сбоях сборки на уровне Jenkins (scripts/tgMessaging).
Нюанс состоит в следующем.
Механизм авторизации в Telegram API включает требование что сообщения отправляются с сервера у которого не изменный ip-адрес.
При этом необходимо прохождение первичной процедуры авторизации:
- при первичной отправке сообщения с нового сервера, 
  в мобильное приложение Telegram, которое привязано к номеру телефона, отправляется код авторизации,
  и этот код ТРЕБУЕТСЯ ввести в консоли при первчном выполнения скрипта отправки уведомления (scripts/tgMessaging/sendTgMsg.py).
- НЮАНС в том, что если серверу / виртуальной машине облачного провайдера, выдается периодически НОВЫЙ динамический ip-адрес,
  это требует ПОВТОРНОЙ процедуры авторизации с ПОВТОРНОЙ отправкой OTP кода и ввода его в консоли при выполнении скрипта отправки.
- ОДНАКО это еще не все..
  империческим путем, в результате первичного теста отправки с виртуального сервера с динамическим адресом,
  был выявлен встроенный механизм Защиты Telegram, природу которого понять удалось только косвенно в результате тестов.
  Суть этого механизма защиты в том, что Telegram БЛОКИРУЕТ все сессии при попытке отправки сообщения с подозрительных ip-адресов.
  Именно ЭТО и произошло при отправке тестового сообщения в свой Telegram канал со своего Jenkins серверв Yandex Облаке.
  Через 10-20 секунд после отправки сообщения (которое успешно пришло), Telegram, возможно в целях защиты,
  уничтожил ВСЕ активные сессии со ВСЕХ устройств в которых аккаунт был авторизован, в том числе и для мобильной версии Telegram...
  В результате ДОСТУП к Telegram был потерян.
  Повторная авторизация в Telegram со смартфона с мобильной версии была НЕвозможна, т.к Telegram отправлят код подтверждения в мобильную версию!
  При этом отправка кода по SMS НЕ работает.
  РЕШЕНИЕМ было установка альтернативной версии Telegram клиента (Telegram X) на смартфон привязанный по номеру телефона к Telegram аккаунту.
  В этой версии реализована РАБОТАЮЩАЯ версия отправки кода авторизации по SMS (приходит через 4 секунды после запроса).
  После использования этого кода, был произведен вход с помощью стандартного Telegram приложения и восстановлен доступ с остальных desktop усройств.
  В общем, осталься неприятный осадок. Написал в техподдержку Telegram, но она не ответила за 3 часа.
  Решение в итоге нашел в инете, НО не на официальном сайте Telegram!
  Эта проблема с авторизацией по SMS старая и была ранее около 6 лет назад, однако вменяемого удобного решения у Telegram до сих пор нет
  и приходится устанавливать какое то непонятное приложение (Telegram X) о котором НИ СЛОВА не сказано на официальных источниках Telegram.
- существует другая реализация приложения отправки уведомлений в Telegram канал.
  Она основана на использовании API ключа, вместо данных авторизации пользователя Telegram.
  Возможно в этой реализации не будет происходить блокировка при отправки с постоянно меняющихся ip-адресов.
  Эта реализация возможно будет добавлена позже в версии "scripts/tgMessaging_v2"

#1
В процессе разработки веб-приложения, появилась идея разместить статическое значение вычисленного md5 хэша страницы index.html 
в html коде этойже страницы, чтобы при вычислении хэша страницы путем перебрасывания файла в пунктирную область, 
статический отображаемый на странице вычисленный ранее хэш совпадал с текущим вычесленным.

Однако это оказалось невозможным, т.к каждое изменение страницы index.html приводит к изменению ее контрольной md5 суммы
и поэтому не существует способа отображения md5 хэша на странице для которой вычисляется md5 хэш.
Можно вычислить md5 хэш страницы и поместить ео в отдельный файл,
но невозможно сделать вычисленный md5 хэш статической частью самой страницы чтобы вычисляемый хэш этой страницы совпадал со статическим.

В источнике ниже приведено обсуждение этой проблемы:

  Can a file contain its md5sum inside it?
  https://security.stackexchange.com/questions/3851/can-a-file-contain-its-md5sum-inside-it
  2011.05.16
  Q:
    Just wondering if it is possible to create a file 
    which has its md5sum inside it along with other contents too.
  A:
    Theoretically? Yes.
    Practically, however, since /any/ change to a file's contents, no matter how minute, 
    causes a drastic change in the checksum (which is how md5 checksums work, after all), 
    you'd need to be able to predict how the checksum will change when you alter the file 
    to include the checksum -- for all intents and purposes this isn't much different 
    from being able to break the md5 hashing algorithm.

    There's no such thing as "impossible" in cryptography, 
    but the science does acknowledge the concept of "practically undoable" or "statistically improbable" 
    and that's pretty much what you're dealing with here, at the moment.
```

### 04. Результат работы веб-приложения

[Веб-приложение размещенное на GitHub Pages](https://victornuzhdin.github.io/sf-b1112-pr-jenkins-terraform-ansible-docker-nginx-webapp/src/)

[Веб-приложение развернутое в Docker контейнере (необходим ручной запуск контейнера)](http://jenkins.dotspace.ru:8001/)
[Healthcheck статус Nginx в виде отдельного приложения в томже контейнере](http://jenkins.dotspace.ru:8000/health)


Скриншот1: Основная/Домашняя страница
![screen](_screens/webapp__index-page.png?raw=true)
