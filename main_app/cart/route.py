from flask import Blueprint, request, redirect, render_template, session
from .model import get_cart, clear_cart, remove_from_cart, checkout

blueprint_cart = Blueprint('bp_cart', __name__, template_folder='templates')


@blueprint_cart.route('/', methods=['GET', 'POST'])
def cart():
    if request.method == 'POST':
        if 'clear_cart' in request.form:
            clear_cart()
            return redirect('/cart')

        elif 'remove_from_cart' in request.form:
            bouq_name = request.form['bouq_name']
            remove_from_cart(bouq_name)
            return redirect('/cart')

        elif 'checkout' in request.form:
            del_date = request.form['delivery_date']
            delivery_time = request.form['delivery_time']
            delivery_place = request.form['delivery_address']
            user_id = session.get('user_id')  # ID клиента из сессии
            checkout(del_date, delivery_time, delivery_place, user_id)
            return redirect('/cart')

    cart_items = get_cart()
    return render_template('cart.html', cart_items=cart_items)
