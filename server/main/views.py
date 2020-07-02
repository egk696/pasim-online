# server/main/views.py


from flask import render_template, Blueprint, jsonify, request, current_app, flash, redirect

main_blueprint = Blueprint("main", __name__, )


@main_blueprint.route("/", methods=["GET"])
def home():
    return render_template("main/home.html")
