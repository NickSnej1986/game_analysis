# game_analysis
Анализ основных пользовательских, маркетинговых и финансовых метрик мобильной игры Zombie Revolution

## Проект и бизнес контекст

Zombie Revolution — мобильная игра (условно freemium) с внутриигровыми покупками и регулярными маркетинговыми кампаниями.

Оценить основные пользовательские, маркетинговые, продуктовые и финансовые метрики мобильной игры.
Провести когортный анализ, рассмотреть динамику измнения пользовательской базы и влияния маркетинговых усилий на ключевые метрики.

## Метрики

Основные метрики: DAU/WAU/MAU, Sticky Factor, Revenue, K‑factor, LMAU/LWAU/LDAU.  
Данные: логи событий, транзакции, профили пользователей.  
Инструменты: PostgreSQL (SQL), Power Query, Excel, PowerPoint.  
Результат: 15 SQL‑запросов, 14 Excel‑отчётов, презентация для стейкхолдеров.

## Технический стек

PostgreSQL
Metabase
Excel
Power Pivot 
Power Point

## Структура БД

Модель данных Skygame

Анализ построен на следующих ключевых таблицах PostgreSQL:

| Таблица | Назначение | Ключевые поля | Примеры метрик |
| --- | --- | --- | --- |
| `game_sessions` | Игровая активность, длительность сессий | `id_user`, `start_session`, `end_session` | Длительность сессии, доля длинных сессий, окна активности |
| `users` | Профили пользователей, регистрация, устройства | `id_user`, `reg_date`, `dev_type` | Когортный анализ по дате регистрации, сегментация по типу устройства |
| `monetary` | Платежи и покупки внутриигровых объектов | `id_user`, `dtime_pay`, `id_item_buy`, `cnt_buy` | Выручка, ARPU, частота покупок, LTV |
| `referral` | Реферальная программа, виральность | `id_user`, `ref_reg` | K‑factor, доля привлечённых пользователей |
| `log_prices` | История цен на игровые объекты (временные диапазоны) | `id_item`, `price`, `valid_from`, `valid_to` | Анализ влияния цены на конверсию и выручку; корректный расчёт стоимости по дате покупки |
| `item_list` | Справочник игровых объектов | `id_item`, `name_item`, `type` | Сегментация по типам предметов, анализ популярности конкретных объектов |

### Схема БД Skygame (ER)

```mermaid
erDiagram
    users {
        int id_user PK
        date reg_date
        string dev_type
    }

    game_sessions {
        int id_user FK
        timestamp start_session
        timestamp end_session
    }

    monetary {
        int id_user FK
        timestamp dtime_pay
        int id_item_buy FK
        int cnt_buy
    }

    referral {
        int id_user FK
        boolean ref_reg
    }

    item_list {
        int id_item PK
        string name_item
        string type
    }

    log_prices {
        int id_item FK
        numeric price
        date valid_from
        date valid_to
    }

    users ||--o{ game_sessions : "has"
    users ||--o{ monetary : "makes"
    users ||--o{ referral : "participates"
    item_list ||--o{ log_prices : "priced"
    item_list ||--o{ monetary : "bought"
