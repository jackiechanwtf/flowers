import os
from database.sql_provider import SQLProvider
from database.connection import DBContextManager
import pymysql
from pymysql.err import OperationalError

def select(db_config, sql):
    """
    Выполняет запрос (SELECT) к БД с указанным конфигом и запросом.

    Args:
        db_config: dict - Конфиг для подключения к БД.
        sql: str - SQL-запрос.
    Return:
        Кортеж с результатом запроса и описанеим колонок запроса.
    """

    result = []
    schema = []

    with DBContextManager(db_config) as cursor:
        if cursor is None:
            raise ValueError('Cursor not found')

        cursor.execute(sql)
        schema = [column[0] for column in cursor.description]
        result = cursor.fetchall()

    return result, schema


def select_dict(db_config, sql):
    """
    Выполняет запрос (SELECT) к БД с указанным конфигом и запросом.

    Args:
        db_config: dict - Конфиг для подключения к БД.
        sql: str - SQL-запрос.
    Return:
        Список словарей, где словарь это строка результата sql-запроса.
    """

    rows, schema = select(db_config, sql)
    return [dict(zip(schema, row)) for row in rows]


def call_proc(db_config, proc_name, *args):
    """
    Вызывает хранимую процедуру.

    :param db_config: Словарь с конфигурацией базы данных
    :param proc_name: Название хранимой процедуры
    :param args: Аргументы для хранимой процедуры
    :return: Результат выполнения процедуры
    """
    try:
        # Подключение к базе данных
        conn = pymysql.connect(**db_config)
        cursor = conn.cursor()

        # Вызов хранимой процедуры
        cursor.callproc(proc_name, args)
        conn.commit()  # Подтверждаем изменения (если требуется)

        # Получаем результат, если процедура возвращает данные
        result = cursor.fetchall()

        cursor.close()
        conn.close()

        # Возвращаем результат
        return result
    except pymysql.MySQLError as e:
        print(f"Ошибка работы с базой данных: {e}")
        return None

def execute_update(db_config, sql, fetch_last_id=False):
    """ Функция для выполнения обновлений в базе данных """
    try:
        # Выполнение SQL-запроса
        with DBContextManager(db_config) as cursor:
            if cursor is None:
                raise ValueError('Cursor not found')

            cursor.execute(sql)
            rows_affected = cursor.rowcount  # Количество затронутых строк
            print(f"rows_affected: {rows_affected}")  # Выводим, сколько строк затронуто

            # Если нужно вернуть последний вставленный ID
            if fetch_last_id:
                cursor.execute("SELECT LAST_INSERT_ID();")
                last_insert_id = cursor.fetchone()[0]  # Получаем последний ID
                print(f"Last Insert ID: {last_insert_id}")
                return last_insert_id

            return rows_affected
    except Exception as e:
        print(f"Ошибка при выполнении запроса: {e}")
        return 0  # Возвращаем 0 в случае ошибки