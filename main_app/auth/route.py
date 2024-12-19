# route.py
from flask import Blueprint, request, render_template, session, redirect, url_for
from .model import authenticate_user, save_in_session_and_redirect

blueprint_auth = Blueprint('bp_auth', __name__, template_folder='templates')


@blueprint_auth.route('/', methods=['GET', 'POST'])
def start_auth():
    """
    Обработка аутентификации: внешний или внутренний логин
    """
    if request.method == 'GET':
        return render_template('input_login.html', message='')
    else:
        login = request.form.get('login', '')
        password = request.form.get('password', '')
        is_internal = True if request.form.get('is_internal') == 'on' else False

        user, message = authenticate_user(login, password, is_internal)

        if user:
            save_in_session_and_redirect(user, session)
            return redirect(url_for('menu_choice'))
        else:
            return render_template('input_login.html', message=message)


@blueprint_auth.route('/auth_fail')
def auth_fail():
    """
    Страница ошибки доступа.
    Пользователь перенаправляется сюда, если у него нет прав для доступа.
    """
    return render_template('auth_fail.html')
