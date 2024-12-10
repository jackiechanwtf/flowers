from flask import Blueprint, render_template, request, current_app, session
from database.operations import call_proc, select_dict
from database.sql_provider import SQLProvider
import os
from datetime import datetime
import pymysql
from access import login_required

blueprint_report = Blueprint('bp_report', __name__, template_folder='templates')
provider = SQLProvider(os.path.join(os.path.dirname(__file__), 'sql'))


@blueprint_report.route('/reports', methods=['GET', 'POST'])
@login_required
def reports_page():
    """
    Универсальная страница для работы с отчетами с учетом роли пользователя.
    """
    current_year = datetime.now().year
    message = None
    records = None

    # Получаем роль пользователя из сессии
    user_group = session.get('user_group')  # По умолчанию роль "guest"

    if request.method == 'POST':
        try:
            # Получаем данные из формы
            action = request.form.get('action')  # Действие: "add" или "view"
            month = int(request.form.get('month_choice'))
            year = int(request.form.get('year_choice'))
            report_type = request.form.get('report_type')  # Тип отчета: "couriers" или "bouquets"

            if action == 'add' and user_group == 'manager':
                if report_type == 'couriers':
                    procedure_name = 'courier_report'
                elif report_type == 'bouquets':
                    procedure_name = 'date_report'
                else:
                    raise ValueError("Неверный тип отчета")

                # Генерация отчета
                call_proc(current_app.config['db_config'], procedure_name, month, year)
                message = f"Отчет за {month}/{year} успешно создан."

            elif action == 'view' and user_group in ['admin', 'manager']:
                # Формируем SQL-запрос на основе типа отчета
                if report_type == 'couriers':
                    sql = provider.get('couriers_report.sql', kwargs={'month': month, 'year': year})
                elif report_type == 'bouquets':
                    sql = provider.get('bouq_report.sql', kwargs={'month': month, 'year': year})
                else:
                    raise ValueError("Неверный тип отчета")

                # Выполняем запрос и проверяем наличие записей
                records = select_dict(current_app.config['db_config'], sql)
                if not records:
                    message = f"Отчет за {month}/{year} не найден."
                else:
                    message = f"Отчет за {month}/{year} успешно загружен."
            else:
                message = "У вас нет доступа для выполнения этого действия."
        except Exception as e:
            message = f"Ошибка: {str(e)}"

    return render_template(
        'reports_page.html',
        year=current_year,
        message=message,
        records=records,
        user_group=user_group
    )
