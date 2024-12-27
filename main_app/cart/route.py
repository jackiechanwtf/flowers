from flask import Blueprint, request, redirect, render_template, session
from .model import get_cart, clear_cart, remove_from_cart, checkout

blueprint_cart = Blueprint('bp_cart', __name__, template_folder='templates')


@blueprint_cart.route('/', methods=['GET', 'POST'])
def cart():
    if request.method == 'POST':
        if 'clear_cart' in request.form:
            clear_cart(request)
            return redirect('/cart')

        elif 'remove_from_cart' in request.form:
            remove_from_cart(request)
            return redirect('/cart')

        elif 'checkout' in request.form:
            user_id = session.get('user_id')  # ID клиента из сессии
            checkout(request, user_id)
            return redirect('/cart')

    cart_items = get_cart()
    return render_template('cart.html', cart_items=cart_items)
