# model.py
import os
import requests
from base64 import b64encode
from database.sql_provider import SQLProvider
from database.operations import select_dict
from flask import current_app

# Инициализация SQL-поставщика
provider = SQLProvider(os.path.join(os.path.dirname(__file__), 'sql'))


def create_basic_auth_token(login, password):
    """
    Создает авторизационный токен в формате Basic для внешнего API
    """
    credentials_b64 = b64encode(f'{login}:{password}'.encode('ascii')).decode('ascii')
    token = f'Basic {credentials_b64}'
    return token


def save_in_session_and_redirect(user_dict, session):
    """
    Сохраняет данные пользователя в сессии и перенаправляет на страницу выбора меню
    """
    session['user_id'] = user_dict['user_id']
    session['user_group'] = user_dict['user_group']
    session.permanent = True
    return True  # Перенаправление будет обработано в контроллере


def authenticate_user(login, password, is_internal):
    """
    Аутентификация пользователя: внешний API или внутренняя база данных
    """
    if not login or not password:
        return None, 'Повторите ввод'

    if not is_internal:
        # Внешний API для аутентификации
        response = requests.get(
            f'http://127.0.0.1:5002/api/auth/find-user',
            headers={'Authorization': create_basic_auth_token(login, password)}
        )

        resp_json = response.json()
        if resp_json['status'] == 200:
            return resp_json['user'], None
        return None, 'Пользователь не найден'

    else:
        # Внутренний поиск пользователя в базе данных
        sql = provider.get('user.sql', dict(login=login, password=password))
        user = select_dict(current_app.config['db_config'], sql)
        if user:
            return user[0], None
        return None, 'Пользователь не найден'
