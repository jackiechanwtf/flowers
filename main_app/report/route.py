from flask import Blueprint, render_template, request, current_app, session
from .model import validate_report_existence, add_report, get_report
from access import login_required
from datetime import datetime

blueprint_report = Blueprint('bp_report', __name__, template_folder='templates')


@blueprint_report.route('/', methods=['GET', 'POST'])
@login_required(['admin', 'manager'])
def reports_page():
    #страница для работы с отчетами с учетом роли пользователя.
    current_year = datetime.now().year
    current_month = datetime.now().month
    message = None
    records = None

    month = current_month
    year = current_year

    # Получаем роль пользователя из сессии
    user_group = session.get('user_group')

    if request.method == 'POST':
        try:
            # Получаем данные из формы
            action = request.form.get('action')  # Действие: "add" или "view"
            month = int(request.form.get('month_choice'))
            year = int(request.form.get('year_choice'))
            report_type = request.form.get('report_type')  # Тип отчета: "couriers" или "bouquets"

            if action == 'add' and user_group == 'manager':
                # Проверяем, существует ли отчет
                result = validate_report_existence(month, year, report_type, current_app.config['db_config'])

                if result and result[0]['record_count'] > 0:
                    message = f"Отчет за {month}/{year} уже существует. Создание отменено."
                else:
                    # Если отчета нет, добавляем новый
                    message = add_report(month, year, report_type, current_app.config['db_config'])

            elif action == 'view' and user_group in ['admin', 'manager']:
                # Получаем отчет
                records = get_report(month, year, report_type, current_app.config['db_config'])
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
        current_year=current_year,
        message=message,
        records=records,
        user_group=user_group,
        year=year,
        month=month
    )