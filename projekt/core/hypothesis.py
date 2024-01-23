import scipy.stats as stats

alpha = 0.05


def normal(data):
    _, p_value = stats.normaltest(data)
    return "Dane są z rozkładu normalnego" if p_value >= alpha else "Dane nie są z rozkładu normalnego"


def homogeneous_variance(data1, data2):
    _, p_value = stats.bartlett(data1, data2)
    return "Wariancje między dwoma zbiorami są równe" if p_value >= alpha else \
        "Warancje między dwoma zbiorami nie są równe"


def dependent_t_test(data1, data2):
    _, p_value = stats.ttest_rel(data1, data2)
    return "Zmienne sa zależne" if p_value >= alpha else "Zmienne nie sa zależne"


def independent_t_test(data1, data2):
    _, p_value = stats.ttest_ind(data1, data2)
    return "Zmienne sa niezależne" if p_value >= alpha else "Zmienne nie sa niezależne"


def anova(group):
    _, p_value = stats.f_oneway(*group)
    return "Analiza ANOVA jest spełniona" if p_value >= alpha else "Analiza ANOVA nie jest spełniona"


def repeated_anova(group):
    _, p_value = stats.friedmanchisquare(*group)
    return "Analiza wariancji z powtórzeniami jest spełniona" if p_value >= alpha else\
        "Analiza wariancji z powtórzeniami nie jest spełniona"


def print_hypothesis(df):
    temp = df['TEMPERATURE'].to_numpy()
    app_temp = df['APPARENTTEMPERATURE'].to_numpy()
    multiply = temp * app_temp

    print(normal(temp))
    print(homogeneous_variance(temp, app_temp))
    print(dependent_t_test(temp, app_temp))
    print(independent_t_test(temp, app_temp))
    print(anova([temp, app_temp, multiply]))
    print(repeated_anova([temp, app_temp, multiply]))
