from functools import wraps
from typing import Callable, List
from flask import session, redirect, url_for

def login_required(allowed_roles: List[str] = []) -> Callable:
    def decorator(func: Callable) -> Callable:
        @wraps(func)
        def wrapper(*args, **kwargs):
            # Если у пользователя нет роли, автоматически присваиваем 'guest'
            if session.get('user_group') is None:
                session['user_group'] = 'guest'

            # Проверяем, есть ли у пользователя разрешение на доступ
            if len(allowed_roles) != 0 and session.get('user_group') not in allowed_roles:
                # Перенаправляем на страницу с ошибкой доступа
                return redirect(url_for('bp_auth.auth_fail'))

            # Проверяем, что пользователь авторизован
            if 'user_id' in session:
                return func(*args, **kwargs)

            # Если пользователь не авторизован, перенаправляем на страницу авторизации
            return redirect(url_for('bp_auth.start_auth'))  # Перенаправление на страницу авторизации

        return wrapper
    return decorator
