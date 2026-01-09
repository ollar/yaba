social_tags_title: Задача "Счастливый билетик" - Решение в лоб
description: Давайте сначала просто напишем базовый код и первое решение.
author: @ollar
date_created: 2023-05-17
is_editable: true

# Решение в лоб

Давайте сначала просто напишем базовый код и первое решение.

### Основные файлы

HTML код `index.html`

```html
<!DOCTYPE html>
<html>
<head>
  <meta charset="utf-8">
  <meta name="viewport" content="width=device-width, initial-scale=1">
  <title>Lucky ticket</title>
</head>
<body>
  <button id="start">start</button>
  <div id="app"></div>
  <script type="module" src="main.js"></script>
</body>
</html>
```

вспомогательные функции `utils.js`

```js
export function normalizeNumber(numberStr) {
  return numberStr.padStart(6, 0);
}

export function calcNumbersSum(str) {
  return str.split('').reduce((acc, curr) => Number(curr) + acc, 0);
}

export function checkIsHappy(numberStr) {
  const normalizedNumber = normalizeNumber(numberStr);
  const leftSide = normalizedNumber.slice(0, 3);
  const rightSide = normalizedNumber.slice(3);
  return calcNumbersSum(leftSide) === calcNumbersSum(rightSide);
}

export function handleTicketClick(e) {
  const { target } = e;
  const numberStr = target.innerHTML;
  alert(`${normalizeNumber(numberStr)}, ${checkIsHappy(numberStr) ? 'счастливый' : 'несчастливый'}`);
}

export function createTicket(i) {
  const $ticket = document.createElement('button');
  $ticket.innerHTML = i;
  $ticket.addEventListener('click', handleTicketClick);
  return $ticket;
}
```

и основной файл нашего приложения `main.js`

```js
import { normalizeNumber, checkIsHappy, handleTicketClick, createTicket } from './utils.js';

const $start = document.getElementById('start');
const $app = document.getElementById('app');

let startTime, endTime;

function runApp() {
  startTime = performance.now();
  for (let i = 1; i < 1_000_000; i++) {
    const $ticket = createTicket(i);
    $app.appendChild($ticket);
  }
  endTime = performance.now();
  console.log(`Call took ${endTime - startTime} milliseconds`);
}

$start.addEventListener('click', runApp);
```

### Запуск сервера

Для запуска этого приложения нужен сервер, чтобы заработали скрипты-модули. Просто кинув HTML файлик в браузер мы получим ошибку CORS запроса.

Я использую [serve](https://www.npmjs.com/package/serve), но можно просто запустить `python3 -m http.server 7777`, если у вас установлен питон.

### Проверяем результаты

Запустив этот код, вы сразу почувствуете недовольство компьютера – у меня хром стабильно падает, видимо срабатывает защита, а ФФ стойко терпит и доводит дело до конца.

ФФ – `Call took 1367 milliseconds` + 2-3 секунды рендера страницы.
Chrome – `Call took 1614 milliseconds`, но в итоге -> Aw, Snap!

Интересно заметить, что ФФ сначала выполняет JS часть кода и только потом переходит к рендеру элементов. Кнопки отрисовываются примерно через пару секунд после сообщения в консоли.

Судя по профайлеру ФФ, страничка отъедает 1 GB памяти, _но это не точно_.

![](screenshot0.png)

Красная полоса свидетельствует о проблемах, советуют поразбираться. В этот момент у нас заполняется стек задач для текущего фрейма[^frame] и браузер использует все ресурсы на их выполение, _как студент перед сессией_.

## Метод рекурсии

Попробуем выполнить создание билетиков рекурсией[^recursion]? Интервьюеры яндекса очень не любят это слово, но мы не боимся проблем!

[^recursion]: Цикличное выполнение функции с вызовом самой себя и выходом по заданному результату [Вики](https://ru.wikipedia.org/wiki/%D0%A0%D0%B5%D0%BA%D1%83%D1%80%D1%81%D0%B8%D1%8F#%D0%92_%D0%BF%D1%80%D0%BE%D0%B3%D1%80%D0%B0%D0%BC%D0%BC%D0%B8%D1%80%D0%BE%D0%B2%D0%B0%D0%BD%D0%B8%D0%B8)
[^frame]: JS формирует очередь задач на выполнение и хранит их в оперативной памяти. Более подробно можно почитать на [Вики](https://ru.wikipedia.org/wiki/%D0%A1%D1%82%D0%B5%D0%BA_%D0%B2%D1%8B%D0%B7%D0%BE%D0%B2%D0%BE%D0%B2) или [MDN](https://developer.mozilla.org/en-US/docs/Glossary/Call_Stack)

```js
function runApp(i) {
  if (i === 1) {
    startTime = performance.now();
  }

  if (i >= 1_000_000) {
    const endTime = performance.now();
    console.log(`Call took ${endTime - startTime} milliseconds`);
    return;
  };

  const $ticket = createTicket(i);
  $app.appendChild($ticket);

  return runApp(++i);
}

$start.addEventListener('click', () => runApp(1));
```

`Uncaught InternalError: too much recursion` - браузер тоже не любит рекурсии. По крайней мере, в том виде, в которым мы её записали. Сработала защита от бесконечного вызова функции[^2] с выходом в ошибку. Есть попытки добавить в браузеры механизм хвостовой рекурсии[^3], где эта проблема не будет актуальна, но пока она [не реализована](http://kangax.github.io/compat-table/es6/#test-proper_tail_calls_(tail_call_optimisation)).

Исправлять все это мы будем в следующей статье, в который разберем методы разбиения тяжелых задач на группу более мелких.

[^2]: [Переполнение стека на Вики](https://ru.wikipedia.org/wiki/%D0%9F%D0%B5%D1%80%D0%B5%D0%BF%D0%BE%D0%BB%D0%BD%D0%B5%D0%BD%D0%B8%D0%B5_%D1%81%D1%82%D0%B5%D0%BA%D0%B0)
[^3]: [Хвостовая рекурсия на Вики](https://ru.wikipedia.org/wiki/%D0%A5%D0%B2%D0%BE%D1%81%D1%82%D0%BE%D0%B2%D0%B0%D1%8F_%D1%80%D0%B5%D0%BA%D1%83%D1%80%D1%81%D0%B8%D1%8F)
