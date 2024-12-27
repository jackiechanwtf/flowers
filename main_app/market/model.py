from flask import session
from database.sql_provider import SQLProvider
from database.operations import select_dict
from cache.wrapper import fetch_from_cache
import os

# Функция для получения всех букетов
def get_bouquets(db_config, cache_config):
    sql_provider = SQLProvider(os.path.join(os.path.dirname(__file__), 'sql'))

    # Подключение к redis
    cache_select_dict = fetch_from_cache('items_cached', cache_config)(select_dict)
    sql_query = sql_provider.get('select_bouquets.sql', {})
    bouquets = cache_select_dict(db_config, sql_query)

    # Аналог редису с обычным вызовом
    # sql_query = sql_provider.get('select_bouquets.sql', {})
    # bouquets = select_dict(db_config, sql_query)

    return bouquets

# Функция для добавления товара в корзину из данных запроса
def add_item_to_cart(request):
    """
    Извлекает данные из request.form и добавляет товар в корзину.
    :param request: объект запроса
    """
    # Получаем данные из формы
    bouq_id = request.form['bouq_id']
    bouq_name = request.form['bouq_name']
    bouq_price = int(request.form['bouq_price'])
    quantity = int(request.form['quantity'])

    if 'cart' not in session:
        session['cart'] = []

    # Проверяем, есть ли товар в корзине и обновляем количество
    for item in session['cart']:
        if item['bouq_name'] == bouq_name:
            item['quantity'] += quantity
            break
    else:
        # Добавляем новый товар в корзину
        session['cart'].append({
            'bouq_id': bouq_id,
            'bouq_name': bouq_name,
            'bouq_price': bouq_price,
            'quantity': quantity
        })

    session.modified = True
