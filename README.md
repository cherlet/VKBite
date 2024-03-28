# VKBite - Симулятор распространения вируса

<img align="right" width="230" src="https://github.com/cherlet/VKBite/assets/90555971/f4df91ac-3157-430d-b002-d27ddf8a7c68" />

### Обзор

VKBite - это iOS-приложение, которое симулирует и визуализирует распространение инфекции в группе людей. <br />
Приложение позволяет пользователю вводить параметры моделирования, запускать симуляцию и визуализировать процесс <br />
распространения вируса с учетом заданных параметров. <br />

Приложение состоит из двух экранов:

1. Экран ввода параметров: Пользователь может ввести количество людей в группе,  <br />
   количество людей, которое может быть заражено одним человеком при контакте,  <br />
   и период пересчета количества зараженных людей.  <br />

2. Экран визуализации моделирования: После запуска симуляции открывается экран, который визуализирует группу людей и процесс распространения вируса в ней.  <br />
   Пользователь может заражать элементы вручную, листать содержие, а также увеличивать/уменьшать масштаб отображения.  <br />

$~$

$~$

## Реализация

### Экран ввода параметров (HomeViewController)

- Интерфейс: Реализован с использованием стандартных элементов UIKit, таких как UILabel, UITextField и UIButton. Интерфейс отзывчив и соответствует Human Interface Guidelines.
- Инициализация параметров: По умолчанию установлены параметры для удобства пользователя.
- Обработка ввода: Проверка введенных данных на корректность.

### Экран визуализации моделирования (SimulatorViewController)

- Интерфейс: Визуализация группы людей реализована с использованием UICollectionView. Реализованы pinch и long press жесты для управления масштабом и выделения нескольких элементов сразу.
- Симуляция: Запуск симуляции осуществляется с использованием DispatchQueue и DispatchSourceTimer для асинхронного выполнения операций. Вычисление нового состояния экрана происходит в фоновом потоке для отзывчивости интерфейса.

### Архитектура

VKBite построен с использованием паттерна MVC.

### Валидация и обработка ошибок

- Проверка ввода: Проверка на ввод только целочисленных значений и корректность параметров для предотвращения ошибок.
- Обработка ошибок: Ошибки ввода и выполнения операций обрабатываются с уведомлением пользователю.

## Технологии и инструменты

- Язык программирования: Swift
- Фреймворки: UIKit, Foundation
- Инструменты: Xcode
