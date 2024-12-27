from flask import Blueprint, render_template, request, redirect, url_for, current_app
from .model import get_orders, get_free_couriers, get_delivery_id, assign_courier_to_order, get_order_info
from access import login_required

blueprint_delivery = Blueprint('bp_delivery', __name__, template_folder='templates')


# Главная страница с заказами
@blueprint_delivery.route('/orders', methods=['GET'])
@login_required(['dispatcher'])
def orders_page():
    """
    Страница с заказами без доставки.
    """
    try:
        orders = get_orders(current_app.config['db_config'])  # Получаем все заказы
        return render_template('orders.html', orders=orders)
    except Exception as e:
        return f"Ошибка при получении заказов: {e}", 500


# Страница с курьерами для выбранного заказа
@blueprint_delivery.route('/couriers/<int:order_id>', methods=['GET'])
@login_required(['dispatcher'])
def couriers_for_order(order_id):
    """
    Страница с курьерами для выбранного заказа.
    """
    try:
        couriers = get_free_couriers(current_app.config['db_config'])  # Получаем список свободных курьеров
        return render_template('couriers.html', couriers=couriers, order_id=order_id)
    except Exception as e:
        return f"Ошибка при получении курьеров: {e}", 500


# Обработчик назначения курьера на заказ
@blueprint_delivery.route('/assign_courier', methods=['POST'])
@login_required(['dispatcher'])
def assign_courier():
    """
    Назначить курьера на заказ и обновить статусы в таблицах delivery и couriers.
    """
    try:
        # Передаем request в модель для обработки данных
        assign_courier_to_order(request, current_app.config['db_config'])

        # Получаем данные о заказе и курьере для отображения
        order_id = request.form.get('order_id')
        courier_id = request.form.get('courier_id')
        order_info = get_order_info(order_id, courier_id, current_app.config['db_config'])
        if not order_info:
            return "Ошибка: не удалось получить информацию о заказе и курьере.", 400

        return render_template('assignment_result.html', order_info=order_info)

    except Exception as e:
        return f"Ошибка при назначении курьера: {e}", 500
