# server/main/views.py
import os
import subprocess
import uuid

from flask import render_template, Blueprint, jsonify, request, current_app, flash, redirect, app

from werkzeug.utils import secure_filename
from subprocess import Popen, PIPE

main_blueprint = Blueprint("main", __name__, )


@main_blueprint.route("/", methods=["GET"])
def home():
    return render_template("main/home.html")


# @main_blueprint.route("/compile", methods=["POST"])
# def compile_file():
#     response_object = {
#         "status": "success",
#         "data": {
#             # .elf file here
#         }
#     }
#
#     return jsonify(response_object), 202


@main_blueprint.route("/run", methods=["POST"])
def run():
    code = request.form.get('code')

    if code is None:
        flash('No file part')
        return redirect(request.url)

    if code == '':
        flash('Empty file')
        return redirect(request.url)

    # os.makedirs(os.path.join(current_app.config['TEMP_DIR']), mode=0o777, exist_ok=True)
    temp_folder_path = os.path.join(current_app.config['TEMP_DIR'])
    file_path = os.path.join(temp_folder_path, secure_filename('file.c'))
    with open('file.c', '+w') as f:
        f.write(code)

    # f = open(file_path, 'w+')
    #
    # f.close()

    make_proc = subprocess.Popen(['make'], stdout=PIPE, stderr=PIPE, shell=False)
    stdout, stderr = make_proc.communicate()
    # print("stdout: {}".format(stdout), flush=True)
    # print("stderr: {}".format(stderr), flush=True)
    # print("Return code: {}".format(make_proc.returncode), flush=True)

    # patmos - clang - O2 *.c - o hello.elf
    # with Popen(["ifconfig"], stdout=PIPE) as proc:
    #     log.write(proc.stdout.read())

    pasim_proc = subprocess.Popen(['pasim', 'file.elf'],stdout=subprocess.PIPE)
    stdout, stderr = pasim_proc.communicate()
    out = "{}".format(stdout)
    print(out, flush=True)
    print("stderr: {}".format(stderr), flush=True)
    print("Return code: {}".format(pasim_proc.returncode), flush=True)

    delete_proc = subprocess.Popen(['rm', 'file.elf', 'file.c'])

    response_object = {
        "status": "success",
        "data": {
            "stdout" : out,
        }
    }

    return jsonify(response_object), 202
