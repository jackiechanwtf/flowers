from flask import Blueprint, session, request, redirect, render_template, flash, current_app
from database.sql_provider import SQLProvider
from database.operations import execute_update
import os
from database.connection import DBContextManager
from access import login_required

blueprint_cart = Blueprint('bp_cart', __name__, template_folder='templates')

# Загружаем SQL-провайдер
sql_provider = SQLProvider(os.path.join(os.path.dirname(__file__), 'sql'))

@blueprint_cart.route('/', methods=['GET', 'POST'])
@login_required(['guest'])
def cart():
    if 'cart' not in session:
        session['cart'] = []

    if request.method == 'POST':
        # Обработка очистки корзины
        if 'clear_cart' in request.form:
            session['cart'] = []
            session.modified = True
            flash('Корзина была успешно очищена.', 'success')
            return redirect('/cart')

        # Обработка удаления товара из корзины
        elif 'remove_from_cart' in request.form:
            bouq_name = request.form['bouq_name']
            session['cart'] = [item for item in session['cart'] if item['bouq_name'] != bouq_name]
            session.modified = True
            flash(f'Букет "{bouq_name}" удален из корзины!', 'success')
            return redirect('/cart')

        # Обработка оформления заказа
        elif 'checkout' in request.form:
            try:
                del_date = request.form['delivery_date']
                delivery_time = request.form['delivery_time']
                delivery_place = request.form['delivery_address']
                user_id = session.get('user_id')  # ID клиента из сессии

                sql_insert_delivery = sql_provider.get('insert_delivery.sql', {
                    'del_date': del_date,
                    'delivery_time': delivery_time,
                    'delivery_place': delivery_place
                })
                delivery_id = execute_update(current_app.config['db_config'], sql_insert_delivery, fetch_last_id=True)

                sql_insert_order = sql_provider.get('insert_order.sql', {
                    'cl_id': user_id,
                    'creation_date': 'CURDATE()',
                    'delivery_id': delivery_id
                })
                order_id = execute_update(current_app.config['db_config'], sql_insert_order, fetch_last_id=True)

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

            return redirect('/cart')

    # Отображение корзины
    cart_items = session['cart']
    return render_template('cart.html', cart_items=cart_items)
