# Multilabel classification on Stack Overflow tags
Predict tags for posts from StackOverflow with multilabel classification approach.

## Dataset
- Dataset of post titles from StackOverflow

## Transforming text to a vector
- Transformed text data to numeric vectors using bag-of-words and TF-IDF.

## MultiLabel classifier
[MultiLabelBinarizer](http://scikit-learn.org/stable/modules/generated/sklearn.preprocessing.MultiLabelBinarizer.html) to transform labels in a binary form and the prediction will be a mask of 0s and 1s.

[Logistic Regression](http://scikit-learn.org/stable/modules/generated/sklearn.linear_model.LogisticRegression.html) for Multilabel classification
- Coefficient = 10
- L2-regularization technique

## Evaluation
Results evaluated using several classification metrics:
- [Accuracy](http://scikit-learn.org/stable/modules/generated/sklearn.metrics.accuracy_score.html)
- [F1-score](http://scikit-learn.org/stable/modules/generated/sklearn.metrics.f1_score.html)
- [Area under ROC-curve](http://scikit-learn.org/stable/modules/generated/sklearn.metrics.roc_auc_score.html)
- [Area under precision-recall curve](http://scikit-learn.org/stable/modules/generated/sklearn.metrics.average_precision_score.html#sklearn.metrics.average_precision_score)

## Libraries
- [Numpy](http://www.numpy.org/) — a package for scientific computing.
- [Pandas](https://pandas.pydata.org/) — a library providing high-performance, easy-to-use data structures and data analysis tools for the Python
- [scikit-learn](http://scikit-learn.org/stable/index.html) — a tool for data mining and data analysis.
- [NLTK](http://www.nltk.org/) — a platform to work with natural language.

## Contributing
To prepare your local environment for development, install all requirements using `pip install -r requirements.txt`. We make use of the conventional commits specification for our commit messages, checkout [Conventional Commits](https://www.conventionalcommits.org/en/v1.0.0/#summary) for format. We've got checks on CI that enforce this specification. To help you, we've defined a git hook that runs these checks after every commit. You can configure it by running `pre-commit install`.
