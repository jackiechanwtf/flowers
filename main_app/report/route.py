from flask import Blueprint, render_template, request, redirect, url_for, current_app
from database.operations import call_proc, select_dict
from database.sql_provider import SQLProvider
import os
from datetime import datetime
import pymysql
from access import login_required

blueprint_report = Blueprint('bp_report', __name__, template_folder='templates')
provider = SQLProvider(os.path.join(os.path.dirname(__file__), 'sql'))

@blueprint_report.route('/start', methods=['GET'])
@login_required
def start_report():
    """
    Главная страница работы с отчётами.
    """
    return render_template('report_menu.html')


@blueprint_report.route('/generate', methods=['GET', 'POST'])
@login_required
def generate_report():
    current_year = datetime.now().year

    if request.method == 'GET':
        return render_template('generate_report.html', year=current_year)

    try:
        # Получаем данные из формы
        month = int(request.form.get('month_choice'))
        year = int(request.form.get('year_choice'))

        # Вызываем хранимую процедуру
        result = call_proc(current_app.config['db_config'], 'date_report', month, year)

        if result is None:
            # Обработка ошибки дублирования (MySQL Error 1062)
            message = f"Ошибка: отчёт за {month}/{year} уже существует."
        else:
            message = f"Отчёт за {month}/{year} успешно создан."
    except pymysql.MySQLError as e:
        if e.args[0] == 1062:  # Код ошибки дублирования
            message = f"Ошибка: отчёт за {month}/{year} уже существует."
        else:
            message = f"Ошибка базы данных: {str(e)}"
    except Exception as e:
        message = f"Не получилось создать отчет, не выбран год/месяц"

    return render_template('generate_report.html', year=current_year, message=message)


@blueprint_report.route('/total', methods=['GET', 'POST'])
@login_required
def report_total():
    if request.method == 'POST':
        try:
            month = request.form.get('month')
            year = request.form.get('year')
            print(month, year)
            # SQL-запрос для получения всех данных из таблицы report
            sql = provider.get('report_total.sql', kwargs={'month': month, 'year': year})

            # Выполнение запроса
            records = select_dict(current_app.config['db_config'], sql)

            # Отправка данных на страницу
            return render_template('report_total.html', records=records)
        except Exception as e:
            return f"Ошибка при выполнении запроса: {e}", 500
    return render_template('report_total.html')

@blueprint_report.route('/choose', methods=['GET'])
@login_required
def choose_report():
    """
    Страница выбора типа отчёта: по курьерам или букетам.
    """
    action = request.args.get('action')  # Получаем действие: 'view' или 'create'

    # Передаем действие в шаблон
    return render_template('choose_report.html', action=action)



@blueprint_report.route('/create/couriers', methods=['GET'])
@login_required
def create_report_for_couriers():
    """
    Создание отчёта по курьерам.
    """
    return render_template('create_for_couriers.html')


@blueprint_report.route('/create/bouquets', methods=['GET'])
@login_required
def create_report_for_bouquets():
    """
    Создание отчёта по букетам.
    """
    return render_template('create_for_bouqets.html')


@blueprint_report.route('/view/couriers', methods=['GET'])
@login_required
def view_report_for_couriers():
    """
    Просмотр отчёта по курьерам.
    """
    return render_template('view_for_couriers.html')


@blueprint_report.route('/view/bouquets', methods=['GET'])
@login_required
def view_report_for_bouquets():
    """
    Просмотр отчёта по букетам.
    """
    return render_template('view_for_bouqets.html')
