import matplotlib.pyplot as plt
from sklearn.linear_model import LinearRegression, Ridge, Lasso, Lars
from sklearn.ensemble import RandomForestRegressor


def temperature_regressions(df):
    features = ['HUMIDITY', 'PRECIPITATION', 'PRESSURE', 'CLOUDCOVER', 'WINDSPEED']
    target = 'TEMPERATURE'

    x_train = df[features].to_numpy()
    y_train = df[target].to_numpy()

    models = {
        'Linear Regression': LinearRegression(),
        'Ridge Regression': Ridge(),
        'Lasso Regression': Lasso(),
        'Lars Regression': Lars(),
        'Random Forest Regression': RandomForestRegressor()
    }

    for name, model in models.items():
        model.fit(x_train, y_train)
        y_pred = model.predict(x_train)

        plt.scatter(df[target], y_train, label="Wartości rzeczywiste", alpha=0.5)
        plt.scatter(df[target], y_pred, label=f"Przewidywanie {name}")
        plt.title('Statystyki atmosferyczne a temperatura')
        plt.legend()
        plt.show()


def precipitation_regressions(df):
    features = 'CLOUDCOVER'
    target = 'PRECIPITATION'

    x_train = df[features].to_numpy().reshape(-1, 1)
    y_train = df[target].to_numpy()

    models = {
        'Linear Regression': LinearRegression(),
        'Ridge Regression': Ridge(),
        'Lasso Regression': Lasso(),
        'Lars Regression': Lars(),
        'Random Forest Regression': RandomForestRegressor()
    }

    for name, model in models.items():
        model.fit(x_train, y_train)
        y_pred = model.predict(x_train)

        plt.scatter(x_train, y_train, label="Wartości rzeczywiste", alpha=0.5)
        plt.scatter(x_train, y_pred, label=f"Przewidywanie {name}")
        plt.title('Statystyki zachmurzenia a opadów')
        plt.legend()
        plt.show()
