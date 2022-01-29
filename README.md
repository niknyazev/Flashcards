# Flashcards

Приложение для изучение слов по карточкам


**В разработке**

## Сложности

### Отрисовка круга прогресса обучения

Решение:
https://stackoverflow.com/questions/51429479/stroke-of-cashapelayer-stops-at-wrong-point

### Растянутость картинок в collection view по умолчанию

Решение: 
По умолчанию картики в CV растягиваются. Нужно принудительно установить для Collection view параметр Estimate size в значение None


### Округление ячеек в colltction view

Решение:
Вместо округление через contentView.layer нужно округлять через cell.layer


