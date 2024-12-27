from flask import session, flash, current_app
from database.sql_provider import SQLProvider
from database.operations import execute_update
from database.connection import DBContextManager
import os

sql_provider = SQLProvider(os.path.join(os.path.dirname(__file__), 'sql'))


def get_cart():
    """Получение текущего содержимого корзины."""
    if 'cart' not in session:
        session['cart'] = []
    return session['cart']


def clear_cart(request):
    """Очистка корзины."""
    session['cart'] = []
    session.modified = True
    flash('Корзина была успешно очищена.', 'success')


def remove_from_cart(request):
    """Удаление товара из корзины."""
    bouq_name = request.form.get('bouq_name')
    session['cart'] = [item for item in session['cart'] if item['bouq_name'] != bouq_name]
    session.modified = True
    flash(f'Букет "{bouq_name}" удален из корзины!', 'success')


def checkout(request, user_id):
    """
    Оформление заказа.
    :param request: объект запроса, содержащий данные формы.
    :param user_id: ID клиента из сессии.
    """
    try:
        # Извлечение данных из формы
        del_date = request.form.get('delivery_date')
        delivery_time = request.form.get('delivery_time')
        delivery_place = request.form.get('delivery_address')

        # Добавление информации о доставке
        sql_insert_delivery = sql_provider.get('insert_delivery.sql', {
            'del_date': del_date,
            'delivery_time': delivery_time,
            'delivery_place': delivery_place
        })
        delivery_id = execute_update(current_app.config['db_config'], sql_insert_delivery, fetch_last_id=True)

        # Добавление информации о заказе
        sql_insert_order = sql_provider.get('insert_order.sql', {
            'cl_id': user_id,
            'creation_date': 'CURDATE()',
            'delivery_id': delivery_id
        })
        order_id = execute_update(current_app.config['db_config'], sql_insert_order, fetch_last_id=True)

        # Добавление товаров из корзины
        with DBContextManager(current_app.config['db_config']) as cursor:
            if cursor is None:
                raise ValueError('Cursor not found')
            for item in session['cart']:
                sql_insert_compos = sql_provider.get('insert_compos.sql', {
                    'order_id': order_id,
                    'bouq_id': item['bouq_id'],
                    'quantity': item['quantity'],
                })
                cursor.execute(sql_insert_compos)

        session['cart'] = []
        session.modified = True
        flash(f'Заказ №{order_id} успешно оформлен!', 'success')
    except Exception as e:
        flash(f'Ошибка при оформлении заказа: {str(e)}', 'error')
