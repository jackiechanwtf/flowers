from flask import Blueprint, render_template, request, redirect, url_for, current_app
from database.operations import select_dict, execute_update
from database.sql_provider import SQLProvider
import os
from access import login_required

blueprint_delivery = Blueprint('bp_delivery', __name__, template_folder='templates')
provider = SQLProvider(os.path.join(os.path.dirname(__file__), 'sql'))

# Главная страница с заказами
@blueprint_delivery.route('/orders', methods=['GET'])
@login_required
def orders_page():
    """
    Страница с заказами без доставки.
    """
    try:
        sql = provider.get('orders_without_courier.sql', kwargs={})  # Получаем SQL-запрос

        orders = select_dict(current_app.config['db_config'], sql)  # Получаем данные из БД
        return render_template('orders.html', orders=orders)
    except Exception as e:
        return f"Ошибка при получении заказов: {e}", 500

# Страница с курьерами для выбранного заказа
@blueprint_delivery.route('/couriers/<int:order_id>', methods=['GET'])
@login_required
def couriers_for_order(order_id):
    """
    Страница с курьерами для выбранного заказа.
    """
    try:
        # Получаем список свободных курьеров для указанного заказа
        sql = provider.get('free_couriers.sql', kwargs={})  # Запрос для получения свободных курьеров
        couriers = select_dict(current_app.config['db_config'], sql)
        return render_template('couriers.html', couriers=couriers, order_id=order_id)
    except Exception as e:
        return f"Ошибка при получении курьеров: {e}", 500

# Обработчик назначения курьера на заказ
@blueprint_delivery.route('/assign_courier', methods=['POST'])
@login_required
def assign_courier():
    """
    Назначить курьера на заказ и обновить статусы в таблицах delivery и couriers.
    """
    order_id = request.form.get('order_id')
    courier_id = request.form.get('courier_id')

    if not order_id or not courier_id:
        return "Ошибка: order_id или courier_id не переданы", 400

    try:
        # Получаем delivery_id для выбранного заказа
        sql_get_delivery_id = provider.get('get_delivery.sql', kwargs={'order_id': order_id})
        delivery_id_result = select_dict(current_app.config['db_config'], sql_get_delivery_id)
        if not delivery_id_result:
            return f"Ошибка: не найден delivery_id для заказа {order_id}", 400

        delivery_id = delivery_id_result[0]['delivery_id']  # Получаем delivery_id из результата

        # 1. Обновляем таблицу delivery (назначаем курьера на заказ)
        sql_update_delivery = provider.get('update_delivery.sql', kwargs={'courier_id': courier_id, 'delivery_id': delivery_id})
        execute_update(current_app.config['db_config'], sql_update_delivery)

        # 2. Обновляем таблицу couriers (меняем статус курьера на 'busy')
        sql_update_courier = provider.get('update_courier.sql', kwargs={'courier_id': courier_id})
        execute_update(current_app.config['db_config'], sql_update_courier)

        # Получаем информацию о заказе и курьере для отображения на странице
        sql_order_info = provider.get('get_order_info.sql', {'order_id': order_id, 'courier_id': courier_id})
        order_info = select_dict(current_app.config['db_config'], sql_order_info)

        if not order_info:
            return "Ошибка: не удалось получить информацию о заказе и курьере.", 400

        return render_template('assignment_result.html', order_info=order_info[0])

    except Exception as e:
        return f"Ошибка при назначении курьера: {e}", 500
