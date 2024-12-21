from database.operations import select_dict
from database.sql_provider import SQLProvider
from flask import session
import os
from cache.wrapper import fetch_from_cache

# Функция для получения всех букетов
def get_bouquets(db_config, cache_config):
    sql_provider = SQLProvider(os.path.join(os.path.dirname(__file__), 'sql'))

    # Подключение к redis
    cache_select_dict = fetch_from_cache('items_cached', cache_config)(select_dict)
    sql_query = sql_provider.get('select_bouquets.sql', {})
    bouquets = cache_select_dict(db_config, sql_query)

    # #Аналог редису с обычным вызовом
    # sql_query = sql_provider.get('select_bouquets.sql', {})
    # bouquets = select_dict(db_config, sql_query)

    return bouquets

# Функция для добавления товара в корзину
def add_item_to_cart(bouq_id, bouq_name, bouq_price, quantity):
    if 'cart' not in session:
        session['cart'] = []

    for item in session['cart']:
        if item['bouq_name'] == bouq_name:
            item['quantity'] += quantity
            break
    else:
        session['cart'].append({
            'bouq_id' : bouq_id,
            'bouq_name': bouq_name,
            'bouq_price': bouq_price,
            'quantity': quantity
        })

    session.modified = True