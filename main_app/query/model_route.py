from database.sql_provider import SQLProvider
from database.operations import select_dict
import os

# Подключаем SQLProvider
provider = SQLProvider(os.path.join(os.path.dirname(__file__), 'sql'))


def get_clients_by_period(request, db_config):
    """
    Получение списка клиентов за указанный период из данных формы.
    :param request: объект запроса.
    :param db_config: конфигурация базы данных.
    :return: список клиентов.
    """
    params = {
        'year': request.form.get('year'),
        'month_start': request.form.get('month_start'),
        'month_end': request.form.get('month_end')
    }
    sql = provider.get('clients_by_period.sql', params)
    return select_dict(db_config, sql)


def get_min_order_price(request, db_config):
    """
    Получение минимальной стоимости заказа за указанный год из данных формы.
    :param request: объект запроса.
    :param db_config: конфигурация базы данных.
    :return: минимальная стоимость заказа.
    """
    params = {'year': request.form.get('year')}
    sql = provider.get('min_order_price.sql', params)
    return select_dict(db_config, sql)


def get_couriers_no_orders(db_config):
    """
    Получение списка курьеров без заказов.
    :param db_config: конфигурация базы данных.
    :return: список курьеров.
    """
    sql = provider.get('couriers_no_orders.sql', {})
    return select_dict(db_config, sql)
