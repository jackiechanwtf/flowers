from flask import Blueprint, session, request, redirect, render_template, flash, current_app
from .model import get_bouquets, add_item_to_cart
from pathlib import Path
from access import login_required

# Создаем Blueprint
blueprint_market = Blueprint('bp_market', __name__, template_folder='templates')

# Главная страница с букетами
@blueprint_market.route('/')
@login_required(['guest'])
def market():
    """Отображение списка букетов."""
    # Получаем путь к папке с изображениями
    image_folder = Path(current_app.root_path) / 'static' / 'images'

    # Получаем данные о букетах из модели
    bouquets = get_bouquets(current_app.config['db_config'], current_app.config['cache_config'])

    # Проверяем наличие изображений
    for bouquet in bouquets:
        image_path = image_folder / f"{bouquet['bouq_name']}.png"
        bouquet['image_exists'] = image_path.is_file()

    # Передаем данные в шаблон
    return render_template('market.html', bouquets=bouquets)


# Обработчик добавления товара в корзину
@blueprint_market.route('/add_to_cart', methods=['POST'])
@login_required(['guest'])
def add_to_cart():
    """Обработка добавления товара в корзину."""
    try:
        # Передаем request в модель для обработки данных
        add_item_to_cart(request)

        # Уведомление пользователя
        flash('Товар добавлен в корзину!', 'success')

        # Возвращаем пользователя на страницу маркета
        return redirect('/market')
    except Exception as e:
        flash(f"Ошибка: {str(e)}", 'danger')
        return redirect('/market')
