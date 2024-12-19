import json
from pathlib import Path

from flask import Flask, render_template, session

from auth.route import blueprint_auth
from report.route import blueprint_report
from query.route import blueprint_query
from market.route import blueprint_market
from cart.route import blueprint_cart
from delivery.route import blueprint_delivery
from access import login_required


app = Flask(__name__)
app.secret_key = 'SuperKey'

app.register_blueprint(blueprint_auth, url_prefix='/auth')
app.register_blueprint(blueprint_query, url_prefix='/query')
app.register_blueprint(blueprint_report, url_prefix='/report')
app.register_blueprint(blueprint_market, url_prefix='/market')
app.register_blueprint(blueprint_cart, url_prefix='/cart')
app.register_blueprint(blueprint_delivery, url_prefix='/delivery')


project_path = Path(__file__).resolve().parent
app.config['db_config'] = json.load(open(project_path / 'configs/db.json'))

app.config['roles_config'] = json.load(open(project_path / 'configs/roles.json'))

@app.route('/')
@login_required(['guest', 'admin', 'manager', 'dispatcher'])
def menu_choice():
    # Получение роли пользователя из сессии
    user_group = session.get('user_group', 'guest')  # Присваиваем 'guest', если role отсутствует

    # Доступные сервисы для роли
    user_services = app.config['roles_config'].get(user_group, [])

    template = 'internal_user_menu.html' if user_group != 'guest' else 'external_user_menu.html'

    return render_template(template, user_services=user_services)

@app.context_processor
def inject_user():
    # Получение данных пользователя из сессии
    user = {
        'is_authenticated': 'user_group' in session,
        'username': session.get('user_name', 'Гость'),
        'role': session.get('user_group', 'guest')
    }
    return {'user': user}


@app.route('/exit')
@login_required(['guest', 'admin', 'manager', 'dispatcher'])
def exit_func():
    session.clear()
    return render_template('exit.html')


if __name__ == '__main__':
    app.run(host='127.0.0.1', port=5001)
