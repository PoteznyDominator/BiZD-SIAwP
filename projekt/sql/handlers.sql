CREATE OR REPLACE PROCEDURE AddNewWeather (
    p_CityID INT,
    p_CodeId INT,
    p_MeasureDate TIMESTAMP,
    p_Temperature FLOAT,
    p_ApparentTemperature FLOAT,
    p_Humidity FLOAT,
    p_Precipitation FLOAT,
    p_Pressure FLOAT,
    p_CloudCover INT,
    p_WindSpeed FLOAT
)
IS
    v_WeatherID INT;
BEGIN
    SELECT COALESCE(MAX(WeatherID), 0) + 1 INTO v_WeatherID FROM Weather;

    INSERT INTO Weather (
        WeatherID, CityID, CodeId, MeasureDate,
        Temperature, ApparentTemperature, Humidity,
        Precipitation, Pressure, CloudCover, WindSpeed
    )
    VALUES (
        v_WeatherID, p_CityID, p_CodeId, p_MeasureDate,
        p_Temperature, p_ApparentTemperature, p_Humidity,
        p_Precipitation, p_Pressure, p_CloudCover, p_WindSpeed
    );
    COMMIT;

END AddNewWeather;

CREATE OR REPLACE PROCEDURE RemoveWeather (
    p_WeatherID INT,
    p_DeletedWeather OUT SYS_REFCURSOR
)
IS
BEGIN
    OPEN p_DeletedWeather FOR
    SELECT *
    FROM Weather
    WHERE WeatherID = p_WeatherID;

    DELETE FROM Weather WHERE WeatherID = p_WeatherID;
    COMMIT;

    DBMS_OUTPUT.PUT_LINE('Pogoda usunięta pomyślnie.');
EXCEPTION
    WHEN NO_DATA_FOUND THEN
        DBMS_OUTPUT.PUT_LINE('Nie znaleziono pogody o podanym ID.');
    WHEN OTHERS THEN
        DBMS_OUTPUT.PUT_LINE('Wystąpił błąd podczas usuwania pogody.');
END RemoveWeather;

CREATE OR REPLACE PROCEDURE UpdateWeather (
    p_WeatherID INT,
    p_Temperature FLOAT,
    p_ApparentTemperature FLOAT,
    p_Humidity FLOAT,
    p_Precipitation FLOAT,
    p_Pressure FLOAT,
    p_CloudCover INT,
    p_WindSpeed FLOAT
)
IS
BEGIN
    UPDATE Weather
    SET
        Temperature = p_Temperature,
        ApparentTemperature = p_ApparentTemperature,
        Humidity = p_Humidity,
        Precipitation = p_Precipitation,
        Pressure = p_Pressure,
        CloudCover = p_CloudCover,
        WindSpeed = p_WindSpeed
    WHERE WeatherID = p_WeatherID;

    COMMIT;
    DBMS_OUTPUT.PUT_LINE('Pogoda zaktualizowana pomyślnie.');
EXCEPTION
    WHEN NO_DATA_FOUND THEN
        DBMS_OUTPUT.PUT_LINE('Nie znaleziono pogody o podanym ID.');
    WHEN OTHERS THEN
        DBMS_OUTPUT.PUT_LINE('Wystąpił błąd podczas aktualizacji pogody.');
END UpdateWeather;

CREATE OR REPLACE TRIGGER Weather_BeforeInsert
BEFORE INSERT ON Weather
FOR EACH ROW
DECLARE
    v_MaxCodeId INT;
    v_MaxCityId INT;
BEGIN
    SELECT MAX(CodeId) INTO v_MaxCodeId FROM CODES;
    SELECT MAX(CityId) INTO v_MaxCityId FROM CITIES;


    IF :NEW.CodeId < 0 OR :NEW.CodeId > v_MaxCodeId THEN
        RAISE_APPLICATION_ERROR(-20002, 'Nieprawidłowy CodeId. Pogoda nie została dodana.');
    ELSIF :NEW.CityId < 0 OR :NEW.CityId > v_MaxCityId THEN
        RAISE_APPLICATION_ERROR(-20003, 'Nieprawidłowy CityId. Pogoda nie została dodana.');
    ELSIF :NEW.CloudCover < 0 OR :NEW.CloudCover > 100 THEN
         RAISE_APPLICATION_ERROR(-20004, 'CloudCover jest zapisane w % (0 - 100). Pogoda nie została dodana.');
    ELSIF :NEW.Humidity < 0 OR :NEW.Humidity > 100 THEN
         RAISE_APPLICATION_ERROR(-20005, 'Humidity jest zapisane w % (0 - 100). Pogoda nie została dodana.');
    END IF;
END Weather_BeforeInsert;