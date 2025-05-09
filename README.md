# Информационная система для реализации бизнес-логики создания заказов в магазине цветов

## 🚀 Запуск проекта
- Запустите главный файл (`main_app/app.py`) при предварительно запущенном микросервисе для авторизации внешних пользователей (`external_app/app.py`).

## 📝 Документация
В репозитории доступны файлы расчетно-пояснительной записки по курсовой работе, содержащие подробное описание бизнес-логики работы сервисов приложения, а также диаграммы последовательности для blueprint'ов, реализующих различные фрагменты системы:
- Глаголев.docx
- Глаголев.pdf

Документация включает детальное описание:
- Бизнес-логики информационной системы
- Сценариев работы внутренних пользователей (диспетчеры, менеджеры, директор)
- Сценариев работы внешних пользователей (клиенты)

## 💾 База данных
В папке `db` содержатся все необходимые файлы для создания и настройки MySQL базы данных: можно запустить файл db.sql для полного создания из одного файла или поочередно запустить оставшиеся файлы, исключая db.sql.

## ⚙️ Конфигурация
### База данных
- Название БД: `userdb`
- Хранимые процедуры:
  - `courier_report` - для формирования отчетов по курьерам
  - `date_report` - для отчетов по продажам букетов

### Redis
- Порт: 6379
- Используется для кэширования данных о букетах и заказах
