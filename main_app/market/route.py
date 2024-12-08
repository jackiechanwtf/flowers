from flask import Blueprint, session, request, redirect, render_template, flash, current_app
from pathlib import Path
from database.sql_provider import SQLProvider
from database.operations import select_dict
import os

# Создаем Blueprint
blueprint_market = Blueprint('bp_market', __name__, template_folder='templates')

# Путь к SQL-запросам
sql_provider = SQLProvider(os.path.join(os.path.dirname(__file__), 'sql'))


@blueprint_market.route('/')
def market():
    """Отображение списка букетов."""
    # Получаем путь к папке с изображениями
    image_folder = Path(current_app.root_path) / 'static' / 'images'

    # Выполняем запрос для получения букетов
    sql_query = sql_provider.get('select_bouquets.sql', {})
    bouquets = select_dict(current_app.config['db_config'], sql_query)

    # Проверяем наличие изображений
    for bouquet in bouquets:
        image_path = image_folder / f"{bouquet['bouq_name']}.png"
        bouquet['image_exists'] = image_path.is_file()

    # Передаем данные в шаблон
    return render_template('market.html', bouquets=bouquets)


@blueprint_market.route('/add_to_cart', methods=['POST'])
def add_to_cart():
    """Обработка добавления товара в корзину."""
    if 'cart' not in session:
        session['cart'] = []
    # Получаем данные из формы
    bouq_id = request.form['bouq_id']
    bouq_name = request.form['bouq_name']
    bouq_price = float(request.form['bouq_price'])
    quantity = int(request.form['quantity'])

    # Проверяем, есть ли товар уже в корзине
    for item in session['cart']:
        if item['bouq_name'] == bouq_name:
            item['quantity'] += quantity
            break
    else:
        session['cart'].append({
            'bouq_id' : bouq_id,
            'bouq_name': bouq_name,
            'bouq_price': bouq_price,
            'quantity': quantity
        })
    print(session['cart'])
    session.modified = True
    flash('Товар добавлен в корзину!', 'success')

    # Возвращаем пользователя обратно на страницу маркета
    return redirect('/market')
