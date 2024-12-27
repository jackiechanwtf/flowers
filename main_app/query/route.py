from flask import Blueprint, render_template, request, current_app
from .model_route import get_clients_by_period, get_min_order_price, get_couriers_no_orders
from access import login_required

# Создаем блюпринт
blueprint_query = Blueprint('bp_query', __name__, template_folder='templates')


@blueprint_query.route('/', methods=['GET'])
@login_required(['manager'])
def query_page():
    """
    Страница с гиперссылками на разные запросы.
    """
    return render_template('query.html')


@blueprint_query.route('/clients_by_period', methods=['GET', 'POST'])
@login_required(['manager'])
def clients_by_period():
    """
    Страница для запроса клиентов за указанный период.
    """
    if request.method == 'POST':
        params = {
            'year': request.form.get('year'),
            'month_start': request.form.get('month_start'),
            'month_end': request.form.get('month_end')
        }
        result = get_clients_by_period(params, current_app.config['db_config'])
        return render_template('clients_by_period.html', result=result)
    return render_template('clients_by_period.html')


@blueprint_query.route('/min_order_price', methods=['GET', 'POST'])
@login_required(['manager'])
def min_order_price():
    """
    Страница для запроса минимальной стоимости заказа.
    """
    if request.method == 'POST':
        params = {'year': request.form.get('year')}
        result = get_min_order_price(params, current_app.config['db_config'])
        return render_template('min_order_price.html', result=result)
    return render_template('min_order_price.html')


@blueprint_query.route('/couriers_no_orders', methods=['GET'])
@login_required(['manager'])
def couriers_no_orders():
    """
    Страница для запроса курьеров без заказов.
    """
    result = get_couriers_no_orders(current_app.config['db_config'])
    return render_template('couriers_no_orders.html', result=result)
