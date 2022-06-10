"""
Flask API of the SMS Spam detection model model.
"""

import pickle
import random
from flask import Flask, jsonify, request, Response, render_template
from flasgger import Swagger

from src.version import __version__
from src.config.definitions import ROOT_DIR
from src.features.build_features import text_prepare

app = Flask(__name__)
swagger = Swagger(app)

NUM_PRED = 0
VERSION = __version__


@app.route('/', methods=['GET'])
def index_get():
    """
    Show a landing page to the user.
    """
    return render_template('index.html', version=VERSION)


@app.route('/', methods=['POST'])
def index_post():
    """
    Show the predicted tags from user input.
    """
    title = request.form['text']

    if not title:
        return render_template('index.html', version=VERSION)

    predicted_tags = predict(title)[0]
    data = [f"Title: {title}", f"Tags: {', '.join(predicted_tags)}"]

    return render_template('index.html', data=data, version=VERSION)


def predict(title):
    """
    Function that returns the predicted tags of the given title.
    Used in the endpoints.
    """
    prepared_title = text_prepare(title)  # remove bad symbols
    processed_title = tfidf_vectorizer.transform([prepared_title])

    with open(ROOT_DIR / 'models/tfidf.pkl', 'rb') as file:
        model = pickle.load(file)
    prediction = model.predict(processed_title)

    with open(ROOT_DIR / 'models/mlb.pkl', 'rb') as file:
        mlb = pickle.load(file)
    tags = mlb.inverse_transform(prediction)

    # global statement is used to keep track of predictions, this is the simplest solution
    # pylint: disable=global-statement
    global NUM_PRED
    NUM_PRED = NUM_PRED + 1  # Increment number of total predictions made

    return tags


@app.route('/predict', methods=['POST'])
def predict_post():
    """
    Predict the tag belonging to the title of a post of StackOverflow.
    ---
    consumes:
      - application/json
    parameters:
        - name: input_data
          in: body
          description: title to predict tags for.
          required: True
          schema:
            type: object
            required: title
            properties:
                title:
                    type: string
                    example: This is an example of a title.
    responses:
      200:

        description: "The result of the prediction, a list of tags (e.g. 'python', 'c++' and/or 'javascript')"

    """
    input_data = request.get_json()
    title = input_data.get('title')

    tags = predict(title)

    return jsonify({
        "result": tags,
        "classifier": "tfifd multi-label-binarizer ",
        "title": title
    })


@app.route('/metrics', methods=['GET'])
def metrics():
    """
    Get metrics for monitoring.
    """
    string = ""
    string += "# HELP my_random A random number\n"
    string += "# TYPE my_random gauge\n"
    string += "my_random " + str(random.randint(0, 100)) + "\n\n"

    string += "# HELP num_pred Number of total predictions made\n"
    string += "# TYPE num_pred counter\n"
    string += "num_pred " + str(NUM_PRED) + "\n\n"

    # Note: Prometheus requires mimetype to be explicitly set to text/plain
    return Response(string, mimetype='text/plain')


if __name__ == '__main__':
    with open(ROOT_DIR / 'data/derivates/tfidf_vectorizer.pkl', 'rb') as f:
        tfidf_vectorizer = pickle.load(f)
    app.run(host='0.0.0.0', port=8080, debug=True)
