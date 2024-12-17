from database.sql_provider import SQLProvider
from database.operations import select_dict
from database.connection import DBContextManager
import os
from datetime import datetime

# Подключаем SQLProvider
provider = SQLProvider(os.path.join(os.path.dirname(__file__), 'sql'))


def validate_report_existence(month, year, report_type, db_config):
    """
    Проверка, существует ли отчет за указанный месяц и год.
    :param month: месяц.
    :param year: год.
    :param report_type: тип отчета.
    :param db_config: конфигурация базы данных.
    :return: результат запроса о существовании отчета.
    """
    if report_type == 'couriers':
        sql_file = 'validate_courier_report.sql'
    elif report_type == 'bouquets':
        sql_file = 'validate_bouq_report.sql'
    else:
        raise ValueError("Неверный тип отчета")

    sql_query = provider.get(sql_file, kwargs={'month': month, 'year': year})
    return select_dict(db_config, sql_query)


def add_report(month, year, report_type, db_config):
    """
    Добавление отчета в базу данных, если он еще не существует.
    :param month: месяц.
    :param year: год.
    :param report_type: тип отчета.
    :param db_config: конфигурация базы данных.
    :return: сообщение о результате выполнения.
    """
    try:
        procedure_name = 'courier_report' if report_type == 'couriers' else 'date_report'

        # Вызов хранимой процедуры для добавления отчета
        with DBContextManager(db_config) as cursor:
            cursor.callproc(procedure_name, [month, year])

        # Повторно проверяем, добавлен ли отчет
        result_after = validate_report_existence(month, year, report_type, db_config)
        if result_after and result_after[0]['record_count'] > 0:
            return f"Отчет за {month}/{year} успешно создан."
        else:
            return f"Ошибка: отчет за {month}/{year} не был создан. Проверьте данные."
    except Exception as e:
        return f"Ошибка: {str(e)}"


def get_report(month, year, report_type, db_config):
    """
    Получение отчета за указанный месяц и год.
    :param month: месяц.
    :param year: год.
    :param report_type: тип отчета.
    :param db_config: конфигурация базы данных.
    :return: список записей отчета.
    """
    if report_type == 'couriers':
        sql = provider.get('couriers_report.sql', kwargs={'month': month, 'year': year})
    elif report_type == 'bouquets':
        sql = provider.get('bouq_report.sql', kwargs={'month': month, 'year': year})
    else:
        raise ValueError("Неверный тип отчета")

    return select_dict(db_config, sql)