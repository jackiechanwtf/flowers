from calendar import month

from flask import Blueprint, render_template, request, current_app
from database.sql_provider import SQLProvider
from database.operations import select_dict
import os
from access import login_required

# Создаем блюпринт
blueprint_query = Blueprint('bp_query', __name__, template_folder='templates')

# Подключаем SQLProvider
provider = SQLProvider(os.path.join(os.path.dirname(__file__), 'sql'))

@blueprint_query.route('/query', methods=['GET'])
@login_required
def query_page():
    # Возвращаем страницу с гиперссылками
    return render_template('query.html')

@blueprint_query.route('/clients_by_period', methods=['GET', 'POST'])
@login_required
def clients_by_period():
    if request.method == 'POST':
        params = {
            'year': request.form.get('year'),
            'month_start': request.form.get('month_start'),
            'month_end': request.form.get('month_end')
        }
        print('perio-', params)
        sql = provider.get('clients_by_period.sql', params)
        print(sql)
        result = select_dict(current_app.config['db_config'], sql)
        return render_template('clients_by_period.html', result=result)
    return render_template('clients_by_period.html')

@blueprint_query.route('/min_order_price', methods=['GET', 'POST'])
@login_required
def min_order_price():
    if request.method == 'POST':
        params = {'year': request.form.get('year')}
        print('min', params)
        sql = provider.get('min_order_price.sql', params)
        print(sql)
        result = select_dict(current_app.config['db_config'], sql)
        print(result)
        return render_template('min_order_price.html', result=result)
    return render_template('min_order_price.html')

@blueprint_query.route('/couriers_no_orders', methods=['GET', 'POST'])
@login_required
def couriers_no_orders():
    sql = provider.get('couriers_no_orders.sql', {})
    result = select_dict(current_app.config['db_config'], sql)
    return render_template('couriers_no_orders.html', result=result)
