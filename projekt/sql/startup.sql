CREATE TABLE Cities (
    CityID INT PRIMARY KEY,
    CityName VARCHAR(255),
    Latitude FLOAT,
    Longitude FLOAT
);

CREATE TABLE Codes (
  CodeId INT PRIMARY KEY,
  Description VARCHAR(255)
);

CREATE TABLE Weather (
    WeatherID INT PRIMARY KEY,
    CityID INT,
    CodeId INT,
    MeasureDate TIMESTAMP,
    Temperature FLOAT,
    ApparentTemperature FLOAT,
    Humidity FLOAT,
    Precipitation FLOAT,
    Pressure FLOAT,
    CloudCover INT,
    WindSpeed FLOAT,
    FOREIGN KEY (CityID) REFERENCES Cities(CityID),
    FOREIGN KEY (CodeId) REFERENCES Codes(CodeId)
);
