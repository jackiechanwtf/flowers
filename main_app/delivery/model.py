from database.sql_provider import SQLProvider
from database.operations import select_dict, execute_update
from database.connection import DBContextManager
import os

# Подключаем SQLProvider
provider = SQLProvider(os.path.join(os.path.dirname(__file__), 'sql'))


def get_orders(db_config):
    """
    Получить все заказы без назначения курьера.
    :param db_config: конфигурация базы данных.
    :return: список заказов.
    """
    sql = provider.get('orders_without_courier.sql', kwargs={})
    return select_dict(db_config, sql)


def get_free_couriers(db_config):
    """
    Получить список свободных курьеров.
    :param db_config: конфигурация базы данных.
    :return: список свободных курьеров.
    """
    sql = provider.get('free_couriers.sql', kwargs={})
    return select_dict(db_config, sql)


def get_delivery_id(order_id, db_config):
    """
    Получить delivery_id для указанного заказа.
    :param order_id: ID заказа.
    :param db_config: конфигурация базы данных.
    :return: delivery_id.
    """
    sql = provider.get('get_delivery.sql', kwargs={'order_id': order_id})
    result = select_dict(db_config, sql)
    return result[0]['delivery_id'] if result else None


def assign_courier_to_order(courier_id, delivery_id, db_config):
    """
    Назначить курьера на заказ и обновить статусы в таблицах delivery и couriers.
    :param courier_id: ID курьера.
    :param delivery_id: ID доставки.
    :param db_config: конфигурация базы данных.
    """
    # Обновляем таблицу delivery (назначаем курьера на заказ)
    sql_update_delivery = provider.get('update_delivery.sql', kwargs={'courier_id': courier_id, 'delivery_id': delivery_id})
    execute_update(db_config, sql_update_delivery)

    # Обновляем таблицу couriers (меняем статус курьера на 'busy')
    sql_update_courier = provider.get('update_courier.sql', kwargs={'courier_id': courier_id})
    execute_update(db_config, sql_update_courier)


def get_order_info(order_id, courier_id, db_config):
    """
    Получить информацию о заказе и курьере.
    :param order_id: ID заказа.
    :param courier_id: ID курьера.
    :param db_config: конфигурация базы данных.
    :return: информация о заказе и курьере.
    """
    sql_order_info = provider.get('get_order_info.sql', {'order_id': order_id, 'courier_id': courier_id})
    result = select_dict(db_config, sql_order_info)
    return result[0] if result else None
